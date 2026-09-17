# S2.1.2 — Tiled accumulation interleaving

S2.1.1 removed the float-add dependency in `gemm_small` by swapping the `k` and `m` loops. The running sums moved into a buffer `acc[M]`, each element was touched once every $M$ trips, and `trans/pipe` reached II = 1, 6.26× faster than `naive/pipe`. The price was a buffer whose size is tied to the matrix width $M$.

Tiled interleaving keeps the idea but bounds the buffer. The columns are walked in tiles of $T$, and only the $T$ sums of the current tile are in progress at once. The dependency distance becomes $T$ instead of $M$. $T = 1$ is the naive loop order and $T = M$ is full transposition, so this lesson is a sweep that connects the two.

S2.1.1 also left a correction to carry in: through a RAM buffer, the span the dependency has to cover is not $D_{\text{add}}$ but $D_{\text{add}} + 4$. So this lesson sweeps $T$ twice: once with the tile buffer in a RAM, once in registers. The main question is where each form first reaches II = 1, and why they differ.

---

## 0. Setup

**Prerequisites**
- S2.1.1 run. Its numbers are the baseline and the calibration for every prediction below.
- `common/part.tcl` (part `xcku5p-ffvb676-2-e`, 3.33 ns, `config_compile -pipeline_loops 0`).
- `common/collect_latency.sh` and `common/collect_resources.sh`.

**Numbers carried in from S2.1.1** (Vitis HLS 2023.2.2):

| quantity | value | source row |
|----------|-------|-----------|
| fast `fadd` core, $D_{\text{fast}}$ | 7 cycles, fabric, 0 DSP | `naive/pipe` |
| slow `fadd` core, $D_{\text{slow}}$ | 10 cycles, fulldsp, 2 DSP | `trans/pipe` |
| `fmul`, $D_{\text{mul}}$ | 6 cycles, 3 DSP | both |
| pipeline depth $L$ | $D_{\text{mul}} + D + 5$: 18 at $D = 7$, 21 at $D = 10$ | both |
| `naive/pipe` | II 7, Fn 229 389. Vitis rewrote the nest (HLS 200-2061) into one flattened run of 32 768 trips | `naive_proj` |
| `trans/pipe` | II 1, no dependence directive, 1024 trips × 32 runs, Fn 36 641, `acc` = 1 BRAM_18K | `trans_proj` |
| RAM buffer span $\delta$ | $D + 4$ = 14 at $D = 10$ | `trans/pipe` schedule |
| cosim gap | cosim is 2 cycles *below* csynth per run of an extracted pipeline submodule | `trans/pipe` |
| `__RTL_SIMULATION__` | not defined for the testbench in cosim (Probe E) | `notes/env.md` |

**Files in this directory**

```
s2_pipelining/02_tiled_accumulation_interleaving/
  README.md
  run_hls.tcl
  src/gemm.h            copied from S2.1.1, M now set by -DGEMM_M (extra 5.5a), plus the gemm_tile and gemm_tshift prototypes
  src/gemm_naive.cpp    copied from S2.1.1, unchanged
  src/gemm_tile.cpp     new
  src/gemm_tshift.cpp   new, extra 5.5c only
  src/tb_gemm.cpp       copied from S2.1.1, plus USE_gemm_tile / USE_gemm_tshift branches and two directed vectors
  directives_gemm_naive_pipe.tcl       copied from S2.1.1
  directives_gemm_tile_ram.tcl
  directives_gemm_tile_reg.tcl
  directives_gemm_tile_reg_dist.tcl    pass-1 gate fallback (T = 32) and extra 5.5b (T = 4)
  directives_gemm_tile_reg_prod.tcl    T = 1 only, blocker 4
  directives_gemm_tshift_reg.tcl       extra 5.5c
  lat_*.md, res_*.md                   collected reports (4.4)
```

**Solution roster.** Loop labels in `gemm_tile`: `ROW` is the `n` loop, `TILE` walks the tiles ($M/T$ trips), `PROD` is the `k` loop, `TCOL` is the column inside a tile ($T$ trips), and `WRITE` copies the tile back to `C`. $T$ is a compile-time define, so each $T$ is its own project. The two buffer forms are two solutions inside it, with identical source.

| project | top | $T$ | solution | what it is |
|---------|-----|-----|----------|------------|
| `base_proj` | `gemm_naive` | — | `pipe` | re-run of S2.1.1 `naive/pipe`; must reproduce Fn 229 389 |
| `tile_t1_proj` | `gemm_tile` | 1 | `reg` | one-column tiles: the naive loop order, but written as a tile nest |
| same | same | 1 | `reg_prod` | `reg` with the pipeline directive on `PROD` (blocker 4 happened) |
| `tile_t2_proj` … `tile_t32_proj` | `gemm_tile` | 2, 4, 8, 16, 32 | `ram` | `acc` pinned to a two-port RAM |
| same | same | same | `reg` | `acc` completely partitioned into $T$ registers |
| `tile_t4_proj`, `tile_t32_proj` | `gemm_tile` | 4, 32 | `reg_dist` | `reg` plus `set_directive_dependence -distance $T`: the pass-1 gate fallback at 32, extra 5.5b at 4 |
| `bigm_t1024_proj`, `bigm_t16_proj` | `gemm_tile` | 1024, 16 | `ram` | extra 5.5a, $M = 1024$ |
| `tshift_t8_proj` | `gemm_tshift` | 8 | `reg` | extra 5.5c, the tile buffer as a shift register |

Notes on the roster:
- **No `ram` at $T = 1$.** A one-word RAM is not a meaningful buffer, and the tool may turn it into a register anyway. (Checked outside the script: with the directive on `PROD` and `array_partition -off`, the one-word RAM became a scalar and the design was identical to `t1/reg_prod`.)
- **No `seq` solutions.** The loop order inside a tile is the same as in S2.1.1, and both `seq` baselines were measured there. Six more `seq` syntheses would add nothing. For that reason, **speedups in this lesson are against `base_proj/pipe`** (the naive pipelined design), which is also how S2.1.1 reported its main result.
- **`tile_t32` is full transposition.** `TILE` has one trip, so `tile_t32/ram` must reproduce S2.1.1 `trans/pipe`. That is the free cross-check for this lesson.

**Why $T$ is a power of two.**
- $M/T$ must be a whole number of tiles.
- The column index `m*T + t` is then a bit concatenation, with no multiplier or adder in the address path.
- The flattened trip count $K \cdot T$ is a power of two, so the loop counter stays a plain counter.

**Conventions carried in**
- `#error` when a required define (`DATA_T`, `GEMM_M`, `TILE_T`) is missing.
- The `Bind Op Report` is read from the design-wide `syn/report/csynth.rpt` only.
- $D$ and $D_{\text{mul}}$ are read per solution. The core can change between rows of this sweep, so read it for every row.
- $L$ is solved from loop C and checked against a stage count. `Iteration Latency` and the log's `Depth` both read $L + 1$ on pipelined loops.
- II is recorded with the clock estimate and whether HLS 200-871 was printed. In S2.1.1, 200-871 came from the flattened loop counter path, not from `fadd`, so check which path the warning names before blaming the core.
- The number of `II Violation` lines is $I_{\min} - 1$.
- One `N_RANDOM` for csim and cosim (Probe E).

**Directives.** No new directives. The lesson uses `set_directive_pipeline`, `set_directive_bind_storage`, `set_directive_array_partition` and `set_directive_dependence`, all already in `notes/directives.md`. The Tcl variable (`$T`) inside a directive file is the same trick S2.1.3 uses with `-distance $K`. What this lesson adds to `notes/directives.md` is a set of notes: a pipeline directive on a one-trip loop is dropped silently, a small `ram_2p` becomes LUTRAM with a cheaper read, and the partitioned-buffer problem from S2.1.3 carries over to the tile nest.

---

## 1. The transformation

**Source:** de Fine Licht et al. [1, Sec. 2.1.2, Lst. 1c].

The paper describes tiled accumulation interleaving as interleaving across a *tile* of an outer loop instead of the whole loop, so that the accumulation buffer shrinks to a fixed size $T$. It adds an inner loop over the tile and cuts the outer loop by the tile size, and it asks for $T \ge L_+$, where $L_+$ is the add latency [1, Sec. 2.1.2]. The same tile structure is the starting point for replication [1, Sec. 3.2, Lst. 10], and the paper also files it under tiling, whose purpose is to bound fast-memory use rather than to add speed [1, Sec. 3.4].

> **Note on Lst. 1c.** The text extraction of the paper I worked from did not include the body of Lst. 1c. The code below follows the paper's description in Sec. 2.1.2 and the tile loops that are visible in Lst. 10. Compare it against the listing in the PDF.

**Context from the paper.** In the N-body case study, tiled accumulation interleaving gave a 7× step, which the authors tie to the latency of the interleaved accumulation [1, Sec. 6.3]. That is the same factor as our $D_{\text{fast}} = 7$.

### 1.1 The code

S2.1.1 `gemm_trans` (loop order `n, k, m`) for reference:

```cpp
ROW:  for (int n = 0; n < N; n++) {
PROD:     for (int k = 0; k < K; k++) {
COL:          for (int m = 0; m < M; m++) {
                  data_t prev = (k == 0) ? C[n][m] : acc[m];
                  acc[m] = prev + A[n][k] * B[k][m];
              }
          }
WRITE:    for (int m = 0; m < M; m++) C[n][m] = acc[m];
      }
```

`gemm_tile` inserts `TILE` between `ROW` and `PROD`, and the buffer shrinks from `acc[M]` to `acc[T]`:

```cpp
ROW:  for (int n = 0; n < N; n++) {
TILE:     for (int m = 0; m < M / T; m++) {
PROD:         for (int k = 0; k < K; k++) {
TCOL:             for (int t = 0; t < T; t++) {
                      data_t prev = (k == 0) ? C[n][m*T + t] : acc[t];
                      acc[t] = prev + A[n][k] * B[k][m*T + t];
                  }
              }
WRITE:        for (int t = 0; t < T; t++) C[n][m*T + t] = acc[t];
          }
      }
```

### 1.2 Where the distance $T$ comes from

`PROD`·`TCOL` is a perfect nest, as `PROD`·`COL` was in S2.1.1. When `TCOL` is pipelined, Vitis flattens the two into one loop of $K \cdot T$ trips. Inside that loop, `acc[t]` is written in trip $j$ and read again in trip $j + T$. So $d = T$, and by the S1.2 model

$$I(T) = \max\left(1,\ \left\lceil \frac{\delta}{T} \right\rceil\right)$$

where $\delta$ is the span the dependency has to cover: from the stage that reads `acc[t]` to the stage that writes it back.

**The two limits.**
- $T = 1$: the buffer is a single value, $d = 1$, and $I = \delta$. This is the naive design.
- $T = M = 32$: this is full transposition, and $I = 1$.

### 1.3 Two buffer forms, two values of $\delta$

**RAM buffer (`ram`).** S2.1.1 measured $\delta = D + 4$ on `acc[32]` in a two-port RAM. A RAM read needs the address one cycle before the data appears, the write lands one cycle after it is issued, and the tool placed the read earlier than strictly needed. Which of the four extra cycles is which was not pinned down; the measured total is what matters here.

$$\delta_{\text{ram}} = D + 4$$

**Register buffer (`reg`).** With `acc` completely partitioned, each element is a register. A register is read in the same cycle and written at the clock edge. In `naive/pipe` the scalar `acc` gave II = 7 = $D$ exactly, so a register path adds nothing there. The partitioned version adds a $T$-way read mux and a write decode, which the tool *might* register. So:

$$\delta_{\text{reg}} = D + \varepsilon, \qquad \varepsilon \text{ predicted } 0, \text{ possibly } 1 \text{ or } 2$$

**Paper vs. this install.** The paper's rule $T \ge L_+$ is the register case. For a RAM buffer here, the rule becomes $T \ge D + 4$. With the fastest core that means $T \ge 11$, so the first power of two with II = 1 is $T = 16$, not $T = 8$.

> **What the run showed (5.1).**
> - **RAM:** under pressure the tool packs the RAM span to $\delta_{\text{ram}} = D + 3$, one cycle less than S2.1.1's $D + 4$. The $D + 4$ reading came from a schedule with slack. The first power of two with II = 1 is still $T = 16$.
> - **Registers:** the partitioned form never gets $d = T$ from the analyzer (blocker 1). It stays at II 7 for every $T$.

### 1.4 Which `fadd` core the tool picks

S1.2 and S2.1.1 both showed that the tool uses the fast, 7-cycle core only when it has to. The working hypothesis for this sweep:

1. Find the smallest $I$ for which the fast core fits: $\delta(7) \le I \cdot T$.
2. At that $I$, switch to the slow, 10-cycle core if it still fits: $\delta(10) \le I \cdot T$.

The DSP column shows which core was used: **DSP = 3** means the fast fabric core (only `fmul` uses DSPs), **DSP = 5** means the slow fulldsp core. Whether step 2 still happens after the tool has relaxed II from 1 is not known; record it.

> **What the run showed:** step 2 happens only at II = 1. Every row with II > 1 kept the fast core, including `t8/ram`, where the slow core would have fitted at II 2.

### 1.5 What else changes with $T$

1. **The II**, as above.
2. **The number of pipeline runs.** Every tile is one run of the flattened `PROD_TCOL` loop, and there are $N \cdot M / T$ tiles per call: 32 runs at $T = 32$, 1024 runs at $T = 1$. Each run pays the fill and drain once.
3. **The buffer size.** $T$ words, independent of $M$. At $M = 32$ this does not save anything that matters, and item 2 even costs a little. Extra 5.5a shows the case where it does matter.

### 1.6 Why the result stays bit-exact

For each `C[n][j]`, `gemm_tile` does the same float operations in the same order as `gemm_naive`: start from `C[n][j]`, add the $k = 0$ product, then $k = 1$, and so on. Only the timing changes. Each column has its own buffer element, and each tile restarts its buffer from `C` at $k = 0$. So, as in S2.1.1, the naive loop itself is the testbench reference, for every $T$ and both buffer forms.

### 1.7 Deviations from the paper

- **`A[n][k]` is read inside `TCOL`.** The paper reads each `A[n][k]` once and keeps it in a register for the whole tile [1, Sec. 3.2]. Hoisting that read into `PROD` would make `PROD`·`TCOL` imperfect and block flattening. `A` is an on-chip array read once per trip, so the extra reads do not cost II. (Same choice as S2.1.1.)
- **The buffer restarts from `C` when $k = 0$**, avoiding a separate reset loop, as in Lst. 1b [1, Sec. 2.1.1].
- **`WRITE` stays a separate, unpipelined loop.** The paper's case study fuses the write phase into the pipeline [1, Sec. 6.2]. That is pipelined loop fusion and flattening, S2.4 and S2.5.

---

## 2. The blocker

**For $T < \delta$, the blocker is still there, only divided by $T$.** The loop-carried dependency on `acc[t]` has distance $T$, but if the add path is longer than $T$ trips, the next write to the same element still arrives too late, and the tool has to stretch the II until $I \cdot T \ge \delta$.

**What must not become a new blocker, or silently change the experiment:**

1. **The analyzer must see $d = T$ on the partitioned registers.** S2.1.1 showed that Vitis sees $d = M$ through a RAM index. After complete partitioning, `acc[t]` becomes $T$ separate registers selected by `t`. If the analyzer cannot tell that register `acc_0` is only touched every $T$ trips, it assumes $d = 1$ and every `reg` row sticks at II = $D$. **Pass 1 tests this at $T = 32$** (the gate in 3.B). The fallback `reg_dist` states the distance with a dependence directive. S2.1.3 already warned about this fallback: its partitioned `lane` became `mux_case_*` registers, and the dependence directive then silently matched nothing.
   *Measured: the gate failed, and `reg_dist` did not rescue it* (5.1).
2. **The tool must not partition the RAM buffer by itself.** Vitis completely partitions small arrays automatically below a size threshold (`config_array_partition -complete_threshold`, default 4). If that overrides the `bind_storage` pin, `tile_t2/ram` is really a register design. Check that `acc` is listed in the **Memory** section of every `ram` row.
   *Measured: the pin held. `acc` is `acc_RAM_2P_AUTO_1R1W` at every $T$, as LUTRAM for $T \le 16$ and BRAM at $T = 32$* (5.2).
3. **Flattening must happen in every row.** The pipelined loop must be listed with $K \cdot T$ trips. If `PROD` and `TCOL` stay separate, II can still look right while the run count becomes $32 \times$ larger.
   *Measured: flattened in every row. For $2 \le T \le 16$, `TILE` is also flattened into `ROW` (`ROW_TILE`), which does not change the run count* (5.1).
4. **$T = 1$ has a one-trip `TCOL`.** The tool may remove a one-trip loop before it applies the pipeline directive. If the log says the directive on `gemm_tile/TCOL` was ignored, or `PROD` is not pipelined, change the directive location for this project to `gemm_tile/PROD` (with $T = 1$ that pipelines the same work) and note it.
   *Measured: it happened, and the log said nothing. `t1/reg` has no pipelined loop at all, which is why `reg_prod` exists* (5.1).
5. **Ports on `acc`.** One read and one write per trip, hence `ram_2p`, as in S2.1.1.

---

## 3. Predict

Do Stage A before running anything. Do Stages B and C after pass 1 and before pass 2. The **Answers** blocks give what the carried-in model predicts. The **Measured** blocks give what Vitis HLS 2023.2.2 actually did; read them only after you have your own predictions.

### Stage A — shape only (before any run)

For each row, predict the achieved II, which `fadd` core the tool uses, and the DSP count. Use $\delta_{\text{ram}} = D + 4$, $\delta_{\text{reg}} = D$, and the core rule in 1.4.

| row | II | $D$ (7 or 10) | DSP | `II Violation` lines |
|-----|----|---------------|-----|---------------------|
| `base/pipe` | | | | |
| `t1/reg` | | | | |
| `t2/ram` | | | | |
| `t2/reg` | | | | |
| `t4/ram` | | | | |
| `t4/reg` | | | | |
| `t8/ram` | | | | |
| `t8/reg` | | | | |
| `t16/ram` | | | | |
| `t16/reg` | | | | |
| `t32/ram` | | | | |
| `t32/reg` | | | | |

Then answer in one line each:
1. What is the cheapest $T$ that reaches II = 1, for each buffer form?
2. Which rows should be *slower* than `base/pipe`, if any?
3. Between `t8/reg` and `t32/ram`, which is faster, and by roughly how much?

<details><summary>Answers</summary>

**RAM** ($\delta = D + 4$):

| $T$ | smallest $I$ with fast core ($11 \le I \cdot T$) | slow core fits? ($14 \le I \cdot T$) | II | $D$ | DSP | violations |
|-----|------|------|----|-----|-----|-----|
| 2 | 6 (12) | no (14 > 12) | 6 | 7 | 3 | 5 |
| 4 | 3 (12) | no (14 > 12) | 3 | 7 | 3 | 2 |
| 8 | 2 (16) | yes (14 ≤ 16) | 2 | 10 (or 7) | 5 (or 3) | 1 |
| 16 | 1 | yes | 1 | 10 | 5 | 0 |
| 32 | 1 | yes | 1 | 10 | 5 | 0 |

**Registers** ($\delta = D$):

| $T$ | smallest $I$ with fast core ($7 \le I \cdot T$) | slow core fits? ($10 \le I \cdot T$) | II | $D$ | DSP | violations |
|-----|------|------|----|-----|-----|-----|
| 1 | 7 | no | 7 | 7 | 3 | 6 |
| 2 | 4 (8) | no (10 > 8) | 4 | 7 | 3 | 3 |
| 4 | 2 (8) | no (10 > 8) | 2 | 7 | 3 | 1 |
| 8 | 1 (8) | no (10 > 8) | 1 | 7 | 3 | 0 |
| 16 | 1 | yes | 1 | 10 | 5 | 0 |
| 32 | 1 | yes | 1 | 10 | 5 | 0 |

`base/pipe`: II 7, $D$ 7, DSP 3, 6 violation lines (must match S2.1.1).

**If $\varepsilon = 1$** on the register path, nothing changes: $\lceil 8/2 \rceil = 4$, $\lceil 8/4 \rceil = 2$, $\lceil 8/8 \rceil = 1$. **If $\varepsilon = 2$**, `t4/reg` becomes II 3 and `t8/reg` becomes II 2, and the register form loses its advantage at $T = 8$.

1. **Cheapest II = 1:** $T = 8$ with registers, $T = 16$ with a RAM. Same transformation, same source, one power of two apart, only because of where the buffer lives.
2. **Slower than `base/pipe`:** `t1/reg`. Same II as the naive design, but `base/pipe` was rewritten into *one* long pipeline run, while `t1/reg` has one run per output element. Unless the tool rewrites this nest too (see Stage B).
3. **`t8/reg` vs `t32/ram`:** both II = 1. `t8/reg` has 128 runs instead of 32, so it pays about 96 extra fill/drain phases. Expect it about 5% slower. Stage B puts a number on it.

</details>

<details><summary>Measured</summary>

| row | II | $D$ | DSP | `II Violation` lines | model said |
|-----|----|-----|-----|---------------------|------------|
| `base/pipe` | 7 | 7 | 3 | 6 | ✓ |
| `t1/reg` | not pipelined | 10 | 5 | 0 | blocker 4 |
| `t1/reg_prod` | 7 | 7 | 3 | 6 | ✓ |
| `t2/ram` | **5** | 7 | 3 | 4 | II 6 |
| `t2/reg` | **7** | 7 | 3 | 6 | II 4 |
| `t4/ram` | 3 | 7 | 3 | 2 | ✓ |
| `t4/reg` | **7** | 7 | 3 | 6 | II 2 |
| `t8/ram` | 2 | **7** | **3** | 1 | II ✓; core said 10 (or 7) |
| `t8/reg` | **7** | 7 | 3 | 6 | II 1 |
| `t16/ram` | 1 | 10 | 5 | 0 | ✓ |
| `t16/reg` | **7** | **7** | **3** | 6 | II 1, $D$ 10 |
| `t32/ram` | 1 | 10 | 5 | 0 | ✓ |
| `t32/reg` | **7** | **7** | **3** | 6 | II 1, $D$ 10 |

- **The RAM form follows $\lceil (D+3)/T \rceil$, not $\lceil (D+4)/T \rceil$.** With $D = 7$, $\lceil 10/T \rceil$ gives 5, 3, 2, 1 at $T = 2, 4, 8, 16$: all four match. $D + 4$ only fails at $T = 2$, where $\lceil 11/2 \rceil = 6$. The violation lines name `acc` with `distance = T, offset = 1`, so the analyzer sees the true distance through the RAM index at every $T$.
- **The register form is II 7 everywhere.** Every violation line names a local register `mux_case_05` with `distance = 1, offset = 0`. The complete partition rewrites `acc[t] = ...` into one register per element that is loaded and stored on *every* trip (with the old value when $t$ does not match). That is a genuine distance-1 dependency in the rewritten code, so the analyzer is right about the code it was given.
- **Answers to the three questions.** (1) RAM: $T = 16$; registers: never. (2) Slower than `base/pipe`: every `reg` row except `t1/reg_prod`, plus `t1/reg`, which is not pipelined at all. (3) `t8/reg` is not II 1, and `t32/ram` is 6.34× faster than it.

</details>

### Stage B — to the cycle (after pass 1)

**Pass 1.** Run with `ONLY {base_proj tile_t32_proj}` and `DO_COSIM 0` (the default in `run_hls.tcl`). At $T = 32$ both buffer forms should reach II = 1 no matter what, so this pass does not give away the sweep. It gives three things: the baseline check, the per-tile overhead, and the gate.

```bash
vitis_hls -f run_hls.tcl 2>&1 | tee run_pass1.log
```

**The gate.** `tile_t32/reg` must reach II = 1. With $d = 32$ and $\delta \approx 10$, any II above 1 means the analyzer does not see the distance through the partitioned registers (blocker 1). If so, rerun `tile_t32_proj` with `reg_dist` added, to see whether the stated distance rescues it. If it does, use `reg_dist` instead of `reg` in pass 2. Record the failure; it is a finding.

> **Measured: the gate failed, and so did the fallback.** `t32/reg` came out at II 7 (6 violation lines on `mux_case_05`, distance 1), and so did `t32/reg_dist`, with an identical report. The log echoes `set_directive_dependence -variable acc ... -distance 32` and prints no warning: after the partition there is no `acc` left for the directive to apply to. This is S2.1.3's finding again. `run_hls.tcl` therefore keeps `reg` in pass 2 (the failure *is* the result for that column), keeps `reg_dist` at $T = 32$ as the gate record, and adds it at $T = 4$ as extra 5.5b.

**What to read.**

| symbol | meaning | where | expected | measured |
|--------|---------|-------|----------|----------|
| $D$ in `base/pipe` | `fadd` latency | `fadd` row, Bind Op Report, `base_proj/pipe/syn/report/csynth.rpt` | 7 | 7 (fabric) |
| $D_{\text{mul}}$ | `fmul` latency | `fmul` row, same file | 6 | 6 (maxdsp, 3 DSP) |
| Fn `base/pipe` | function latency (max) | `gemm_naive_csynth.rpt` | 229 389 | 229 389 |
| $D_{32}^{\text{ram}}$, $D_{32}^{\text{reg}}$ | `fadd` latency at $T = 32$ | Bind Op Report of each solution | 10, 10 | 10, **7** |
| trips | trip count of the pipelined loop | loop table of `gemm_tile_Pipeline_PROD_TCOL` | 1024 | 1024 (both) |
| $C_{\text{run}}$ | loop latency of that loop | same row | 1044 | `ram` 1044, `reg` 7176 |
| $L$ | pipeline depth | solve: $L = C_{\text{run}} - I\,(1024 - 1)$ | 21 | `ram` 21, `reg` **15** |
| $w$ | iteration latency of the unpipelined `WRITE` loop | `WRITE` row | 3 | `ram` 3, `reg` **1** |
| Fn `t32/ram` | function latency | `gemm_tile_csynth.rpt` | 36 641 ± 2 | 36 641 (and `reg` 230 881) |
| memory | `acc` in the Memory section | top module report | `ram`: 32 × 32 bits; `reg`: absent | as expected; `ram` is 1 BRAM_18K |

At $T = 32$ the `TILE` loop has one trip and may be removed from the report; that is expected.

**Model.** Per call there are $NM/T$ tiles. Each tile is one pipeline run of $KT$ trips, then the `WRITE` loop, then some loop entry/exit overhead $o$:

$$C_{\text{tile}}(T) = \underbrace{L + I\,(KT - 1)}_{\text{pipelined run}} + \underbrace{T \cdot w}_{\texttt{WRITE}} + o$$

$$\text{Fn}(T) \approx \frac{NM}{T} \cdot C_{\text{tile}}(T)$$

with $L = D_{\text{mul}} + D + 5$ for the core that row uses.

**Calibrate $w$ and $o$ from `t32/ram`.** At $T = 32$ there are 32 tiles, so

$$32 \cdot (1044 + 32w + o) = \text{Fn}_{32} \quad\Rightarrow\quad 32w + o = \frac{\text{Fn}_{32}}{32} - 1044$$

S2.1.1's 36 641 gives $32w + o \approx 101$. Take $w$ from the `WRITE` row and solve for $o$. If the `WRITE` row is not listed, use $w = 3$, $o = 5$. The split between $w$ and $o$ changes the predictions below by less than 1%.

**Also solve $L$ for `t32/reg`.** The buffer read is not on the longest path (that is the `B` read, then `fmul`, then `fadd`), so predict $L^{\text{reg}} = L^{\text{ram}}$ at the same core. If they differ, carry the measured value into the `reg` rows.

**Fill in** (use your calibrated $w$, $o$, and the II and $D$ from Stage A):

| row | II | $L$ | $KT$ | $C_{\text{run}}$ | $C_{\text{tile}}$ | tiles | Fn predicted | speedup vs `base/pipe` |
|-----|----|-----|------|------------------|-------------------|-------|--------------|------------------------|
| `t1/reg` | | | 32 | | | 1024 | | |
| `t2/ram` | | | 64 | | | 512 | | |
| `t2/reg` | | | 64 | | | 512 | | |
| `t4/ram` | | | 128 | | | 256 | | |
| `t4/reg` | | | 128 | | | 256 | | |
| `t8/ram` | | | 256 | | | 128 | | |
| `t8/reg` | | | 256 | | | 128 | | |
| `t16/ram` | | | 512 | | | 64 | | |
| `t16/reg` | | | 512 | | | 64 | | |
| `t32/ram` | 1 | | 1024 | | | 32 | (measured) | |
| `t32/reg` | 1 | | 1024 | | | 32 | (measured) | |

<details><summary>Answers (with $w = 3$, $o = 5$)</summary>

| row | II | $L$ | $C_{\text{run}}$ | $C_{\text{tile}}$ | tiles | Fn | speedup |
|-----|----|-----|------------------|-------------------|-------|----|---------|
| `t1/reg` | 7 | 18 | 18 + 7·31 = 235 | 243 | 1024 | 248 832 | 0.92 |
| `t2/ram` | 6 | 18 | 18 + 6·63 = 396 | 407 | 512 | 208 384 | 1.10 |
| `t2/reg` | 4 | 18 | 18 + 4·63 = 270 | 281 | 512 | 143 872 | 1.59 |
| `t4/ram` | 3 | 18 | 18 + 3·127 = 399 | 416 | 256 | 106 496 | 2.15 |
| `t4/reg` | 2 | 18 | 18 + 2·127 = 272 | 289 | 256 | 73 984 | 3.10 |
| `t8/ram` | 2 | 21 | 21 + 2·255 = 531 | 560 | 128 | 71 680 | 3.20 |
| `t8/reg` | 1 | 18 | 18 + 255 = 273 | 302 | 128 | 38 656 | 5.93 |
| `t16/ram` | 1 | 21 | 21 + 511 = 532 | 585 | 64 | 37 440 | 6.13 |
| `t16/reg` | 1 | 21 | 532 | 585 | 64 | 37 440 | 6.13 |
| `t32/ram` | 1 | 21 | 1044 | 1145 | 32 | 36 641 | 6.26 |
| `t32/reg` | 1 | 21 | 1044 | 1145 | 32 | ≈ 36 640 | 6.26 |

If `t8/ram` keeps the fast core, $L = 18$ and Fn ≈ 71 296 instead.

**`t1/reg` has two possible outcomes.** With $T = 1$, both `TCOL` and `WRITE` have one trip and may be removed, which leaves `TILE` holding `PROD` plus one statement. That is the same imperfect shape the tool rewrote in `naive/pipe` (HLS 200-2061). If it does the same here, `t1/reg` becomes one long run and lands near 229 389 instead of 248 832. Record which one happened; the loop table's trip count tells you.

**Reading the II = 1 rows.** With $I = 1$, the total work across all tiles is the same for every $T$, and the only part that depends on $T$ is the per-tile cost of starting and ending a run:

$$\text{Fn}(T) = \frac{NM}{T}\,(L - 1 + o) + NMK + NM\,w$$

So `t8/reg` minus `t32/ram` ≈ $128 \cdot 22 - 32 \cdot 25 = 2016$ cycles, about 5.5%. Tiling at $M = 32$ does not buy speed; it costs a little.

**Reading the II > 1 rows.** `t4/reg` (II 2) and `t8/ram` (II 2) land close together, as do `t8/reg` and `t16/ram` (II 1). For the RAM form, every $T$ step lands one step of II behind the register form.

</details>

<details><summary>Measured (all passes)</summary>

**Calibration from `t32/ram`:** $32w + o = 36\,641/32 - 1044 = 101$, with $w = 3$ and $o = 5$, as assumed. $o$ is 2 for the call into the extracted pipeline submodule (module latency 1046 against loop latency 1044), plus 3 for the `ROW` iteration.

**The per-tile costs are not constant across rows.** Solved from the loop tables, every row fits

$$\text{Fn} = \frac{NM}{T}\,\big(C_{\text{run}} + 2 + T\,w + o_r\big) + 1$$

*exactly*, but $w$ and $o_r$ depend on where `acc` lives:

| `acc` storage | rows | $w$ (`WRITE` iter. lat) | $o_r$ |
|---------------|------|-------------------------|-------|
| BRAM (32 words) | `t32/ram` | 3 | 3 |
| LUTRAM ($\le 16$ words) | `t2/ram` … `t16/ram` | **2** | 3 (4 at $T = 2$) |
| registers | all `reg` rows | **1** | **5** |

The LUTRAM read takes one cycle less than the BRAM read in `WRITE`. That is why `t16/ram` ends up faster than `t32/ram` (below).

| row | II | $L$ | $C_{\text{run}}$ | $C_{\text{tile}}$ | tiles | Fn measured | Fn predicted | Δ | speedup vs `base/pipe` |
|-----|----|-----|------------------|-------------------|-------|-------------|--------------|---|------------------------|
| `t1/reg_prod` | 7 | 18 | 229 387 (one run) | — | — | 229 389 | ≈ 229 389 (outcome 2) | 0 | 1.00 |
| `t2/ram` | 5 | 17 | 332 | 342 | 512 | 175 105 | 208 384 | −16.0% | 1.31 |
| `t2/reg` | 7 | 16 | 457 | 466 | 512 | 238 593 | 143 872 | +65.8% | 0.96 |
| `t4/ram` | 3 | 18 | 399 | 412 | 256 | 105 473 | 106 496 | −1.0% | 2.17 |
| `t4/reg` | 7 | 15 | 904 | 915 | 256 | 234 241 | 73 984 | +216.6% | 0.98 |
| `t8/ram` | 2 | 18 | 528 | 549 | 128 | 70 273 | 71 680 (71 296 fast core) | −2.0% (−1.4%) | 3.26 |
| `t8/reg` | 7 | 15 | 1 800 | 1 815 | 128 | 232 321 | 38 656 | +501% | 0.99 |
| `t16/ram` | 1 | 21 | 532 | 569 | 64 | 36 417 | 37 440 | −2.7% | 6.30 |
| `t16/reg` | 7 | 16 | 3 593 | 3 616 | 64 | 231 425 | 37 440 | +518% | 0.99 |
| `t32/ram` | 1 | 21 | 1 044 | 1 145 | 32 | 36 641 | (calibration) | 0 | 6.26 |
| `t32/reg` | 7 | 15 | 7 176 | 7 215 | 32 | 230 881 | ≈ 36 640 | +530% | 0.99 |

- **The `ram` rows** miss by 1–3% where the II was right. The miss is the $w = 2$ LUTRAM read, not the II. `t2/ram` misses by 16% because it reached II 5, not 6.
- **The `reg` rows** miss by the whole $D$-fold gain, because none of them gets past II 7. $L$ is also 2–3 stages *shallower* than in the `ram` rows (15–16 against 18). The tool chains a memory read into the `fadd` or `fmul` input in one cycle: the critical paths are `C_load → prev → fadd` (3.940 ns at $T = 4, 8$) and `A_load → fmul` (3.653 ns at $T = 32$), both above the 3.33 ns clock itself.
- **`t1/reg` became outcome 2 only after the directive moved to `PROD`.** `t1/reg_prod` is three-level flattened (`ROW_TILE_PROD`, 32 768 trips, HLS 200-2061) and identical to `base/pipe` to the cycle. `t1/reg` itself is not pipelined: Fn 658 497, which is S2.1.1 `naive/seq` to the cycle, with the slow core.
- **`t16/ram` beats `t32/ram` by 224 cycles.** The II = 1 formula above still holds, but $w$ differs between the two rows. The 32 extra runs cost 32 × ($L - 1 + o$) = 32 × 25 = +800 cycles, and the one-cycle-cheaper `WRITE` saves 1024 × 1 = −1024.

</details>

### Stage C — area direction (before pass 2)

Predict the direction only, relative to `t32/ram`. Fill in: up, down, or same.

| row | LUT | FF | DSP | BRAM | `acc` in Memory section? |
|-----|-----|----|-----|------|------------------------|
| `t2/ram` … `t16/ram` | | | | | |
| `t2/reg` … `t32/reg` | | | | | |

And one question: at II = 1, which is cheaper overall, `t8/reg` or `t16/ram`?

<details><summary>Answers</summary>

- **DSP** follows the core table from Stage A: 3 where $D = 7$, 5 where $D = 10$. This is the easiest check that the core rule is right.
- **`ram` rows:** LUT and FF close to `t32/ram` at every $T$. Only a few counter bits change. `acc` is listed as $T$ words × 32 bits. Whether it maps to BRAM or LUTRAM at small $T$ is not predicted; record it. Rows with II > 1 may show *lower* FF than the II = 1 rows, because fewer iterations are in flight at once (S1.1, `pipe_ii2` had the same area as `seq`).
- **`reg` rows:** FF grows by about $32T$ for the buffer registers, so `t32/reg` should be roughly 1000 FF above `t32/ram`. LUT grows with $T$ as well, for the $T$-way, 32-bit read mux and the write enables. `acc` is **not** in the Memory section, and BRAM drops by the one block that `acc` used.
- **Missing `acc` in a `ram` row** means the tool auto-partitioned it (blocker 2). That row then belongs in the `reg` series.
- **`t8/reg` vs `t16/ram`:** not predicted. `t8/reg` pays about 256 FF plus a mux, but no DSP for `fadd` and no memory block. `t16/ram` pays a small RAM and 2 extra DSP for the slow core. The answer depends on how the tool maps a 16-word RAM. This is the comparison to look at in 5.2.

</details>

<details><summary>Measured</summary>

| row | LUT | FF | DSP | BRAM | `acc` in Memory section? |
|-----|-----|----|-----|------|------------------------|
| `t2/ram` … `t8/ram` | **up** (1110–1215 vs 914) | down to up (1037–1181 vs 1095) | down, 3 (fast core) | down, 0 | yes, as LUTRAM |
| `t16/ram` | up slightly (942) | up slightly (1134) | same, 5 | down, 0 | yes, as LUTRAM (16 × 32) |
| `t2/reg` … `t32/reg` | up (1198 → 1886) | up (1057 → 2880) | down, 3 | down, 0 | no |

- **The DSP rule held on the core that was actually chosen.** Every row with DSP 3 has `fadd` at 7 (fabric), and every row with DSP 5 has `fadd` at 10 (fulldsp).
- **The small RAMs are LUTRAM.** At $T \le 16$, `acc_RAM_2P_AUTO_1R1W` uses 0 BRAM, 64 FF and $T/2$ LUT. Only at 32 words does it become a BRAM_18K.
- **The `ram` rows with II > 1 cost *more* LUT than `t32/ram`,** not less. They carry the 0-DSP fabric `fadd`, which is built from LUTs. FF is not lower either.
- **`reg` FF grows with $T$, but not as $32T$:** +20, +37, +355, +774 and +1785 over `ram` at $T$ = 2, 4, 8, 16, 32. The last two include a core change on the `ram` side.
- **`t8/reg` vs `t16/ram` is moot,** because `t8/reg` is not II 1. The cheapest II = 1 point is `t16/ram` (5.2).

</details>

---

## 4. Apply

### 4.1 Sources

**`src/gemm_tile.cpp`** (new). Same signature as `gemm_trans` in S2.1.1.

```cpp
// src/gemm_tile.cpp
#include "gemm.h"

#ifndef TILE_T
#error "TILE_T is not defined: pass -DTILE_T=<T> in add_files -cflags"
#endif

static_assert(M % TILE_T == 0, "TILE_T must divide M");

// Loop order n, tile, k, t (paper Sec. 2.1.2, Lst. 1c). One accumulator per
// column of the current tile. acc[t] is written in trip (k, t) and read again
// in trip (k+1, t), TILE_T trips later.
void gemm_tile(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]) {
    // Tile buffer: its size depends on TILE_T only, not on M.
    // Left uninitialised: it is restarted from C when k == 0, as in gemm_trans.
    data_t acc[TILE_T];

ROW:
    for (int n = 0; n < N; n++) {
    TILE:
        for (int m = 0; m < M / TILE_T; m++) {
        PROD:
            for (int k = 0; k < K; k++) {
            TCOL:
                for (int t = 0; t < TILE_T; t++) {
                    data_t prev = (k == 0) ? C[n][m * TILE_T + t] : acc[t];
                    acc[t] = prev + A[n][k] * B[k][m * TILE_T + t];
                }
            }
        WRITE:
            for (int t = 0; t < TILE_T; t++) {
                C[n][m * TILE_T + t] = acc[t];
            }
        }
    }
}
```

Notes:
- **`static_assert` instead of `#if`.** `M` is a `const int`, not a macro, so the preprocessor would treat it as 0, and an `#if (M % TILE_T)` check would pass silently. `static_assert` works for both (checked: `-DTILE_T=3` stops the compile).
- **`TILE_T` is used directly** rather than through a short macro such as `T`, so it cannot clash with names in the testbench.
- **`PROD`·`TCOL` is perfect:** `PROD` contains only `TCOL`, as in S2.1.1.

**`src/gemm.h`.** The S2.1.1 header with two changes: `M` comes from `-DGEMM_M` (extra 5.5a needs $M = 1024$; every other project passes 32), and the new prototypes are added.

```cpp
// src/gemm.h
#pragma once
#ifndef DATA_T
#error "DATA_T must be set with -DDATA_T=<type> on add_files"
#endif
#ifndef GEMM_M
#error "GEMM_M must be set with -DGEMM_M=<columns> on add_files (32 everywhere except extra 5.5a)"
#endif
typedef DATA_T data_t;

const int N = 32;       // rows of A and C
const int K = 32;       // columns of A = rows of B
const int M = GEMM_M;   // columns of B and C

// All four compute C = A*B + C.
void gemm_naive(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]);
void gemm_trans(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]);
void gemm_tile(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]);
void gemm_tshift(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]);
```

**`src/tb_gemm.cpp`.** Two changes to the S2.1.1 testbench. `N_RANDOM` stays 16, so with 6 directed vectors there are **22 calls** per csim or cosim run (S2.1.1 had 20).

1. **DUT selection.** `USE_gemm_tile` and `USE_gemm_tshift` branches, in the same style as the existing ones. `main` prints `TILE_T` on a second line when it is defined, so each csim in the log shows which $T$ it ran.

```cpp
#if defined(USE_gemm_naive)
#  define DUT  gemm_naive
#  define FORM "naive"
#elif defined(USE_gemm_trans)
#  define DUT  gemm_trans
#  define FORM "trans"
#elif defined(USE_gemm_tile)
#  define DUT  gemm_tile
#  define FORM "tile"
#elif defined(USE_gemm_tshift)
#  define DUT  gemm_tshift
#  define FORM "tshift"
#else
#  error "tb_gemm: compile with -DUSE_gemm_naive, -DUSE_gemm_trans, -DUSE_gemm_tile or -DUSE_gemm_tshift"
#endif
```

2. **Two directed vectors aimed at tiling bugs**, placed before the S2.1.1 directed vectors. They use the S2.1.1 `fill(a, b, c)` helper and the `C_in` array.

```cpp
    // --- directed: tiling ----------------------------------------------
    // c_passthrough: A = 0, B = 0, C[n][m] = n*M + m + 1.
    // Output must equal the input C exactly. Catches a tile that does not
    // restart from C at k == 0 (it would carry stale sums from the previous tile).
    fill(0, 0, 0);
    for (int n = 0; n < N; n++) for (int m = 0; m < M; m++) C_in[n][m] = (data_t)(n * M + m + 1);
    errors += check("c_pass");

    // col_id: A = 1, B[k][m] = m, C = 0.
    // Expected C[n][m] = K*m exactly (small integers are exact in float).
    // Catches a wrong column address m*T + t.
    fill(1, 0, 0);
    for (int k = 0; k < K; k++) for (int m = 0; m < M; m++) B[k][m] = (data_t)m;
    errors += check("col_id");
```

Both still go through the normal `check()` comparison against `ref()`. The expected values in the comments are only there to reason about.

### 4.2 The script

```tcl
# s2_pipelining/02_tiled_accumulation_interleaving/run_hls.tcl
# Run:       vitis_hls -f run_hls.tcl 2>&1 | tee run_pass1.log
# Override:  ONLY="tile_t8_proj" DO_COSIM=1 vitis_hls -f run_hls.tcl 2>&1 | tee run_cosim.log

# ---- knobs ------------------------------------------------------------
# Pass 1 (stage B): ONLY {base_proj tile_t32_proj}                          DO_COSIM 0
# Pass 2 (sweep):   ONLY {tile_t1_proj tile_t2_proj tile_t4_proj
#                         tile_t8_proj tile_t16_proj}                        DO_COSIM 0
# Pass 3 (cosim):   ONLY {tile_t8_proj}                                     DO_COSIM 1
# Extras:           ONLY {bigm_t1024_proj bigm_t16_proj tshift_t8_proj}     DO_COSIM 0
set ONLY     {base_proj tile_t32_proj}
set DO_COSIM 0
if {[info exists ::env(ONLY)]}     { set ONLY     $::env(ONLY) }
if {[info exists ::env(DO_COSIM)]} { set DO_COSIM $::env(DO_COSIM) }

set DTYPE float

# M is the matrix width (GEMM_M). T {} means the kernel does not take TILE_T.
set RUNS {
    base_proj       {top gemm_naive  M 32   T {}   sols {pipe}             cosim {}}
    tile_t1_proj    {top gemm_tile   M 32   T 1    sols {reg reg_prod}     cosim {}}
    tile_t2_proj    {top gemm_tile   M 32   T 2    sols {ram reg}          cosim {}}
    tile_t4_proj    {top gemm_tile   M 32   T 4    sols {ram reg reg_dist} cosim {}}
    tile_t8_proj    {top gemm_tile   M 32   T 8    sols {ram reg}          cosim {ram reg}}
    tile_t16_proj   {top gemm_tile   M 32   T 16   sols {ram reg}          cosim {}}
    tile_t32_proj   {top gemm_tile   M 32   T 32   sols {ram reg reg_dist} cosim {}}
    bigm_t1024_proj {top gemm_tile   M 1024 T 1024 sols {ram}              cosim {}}
    bigm_t16_proj   {top gemm_tile   M 1024 T 16   sols {ram}              cosim {}}
    tshift_t8_proj  {top gemm_tshift M 32   T 8    sols {reg}              cosim {}}
}
# Tcl does not allow comments inside the braces above, so the notes are here:
#   tile_t1_proj reg_prod:   blocker 4; the TCOL directive is dropped at T = 1, so PROD is pipelined
#   tile_t32_proj reg_dist:  the pass-1 gate fallback (it did not help, see 5.1)
#   tile_t4_proj reg_dist:   extra 5.5b
#   bigm_*_proj:             extra 5.5a (M = 1024)
#   tshift_t8_proj:          extra 5.5c (shift-register tile buffer)
# -----------------------------------------------------------------------

foreach {proj cfg} $RUNS {
    if {[llength $ONLY] > 0 && [lsearch -exact $ONLY $proj] < 0} { continue }

    set top   [dict get $cfg top]
    set M     [dict get $cfg M]
    set T     [dict get $cfg T]
    set sols  [dict get $cfg sols]
    set cosim [dict get $cfg cosim]

    set cflags "-DDATA_T=$DTYPE -DGEMM_M=$M"
    if {$T ne ""} { append cflags " -DTILE_T=$T" }

    open_project -reset $proj
    set_top $top
    add_files     src/${top}.cpp   -cflags $cflags
    add_files -tb src/tb_gemm.cpp  -cflags "$cflags -DUSE_$top"

    set first 1
    foreach sol $sols {
        open_solution -reset $sol -flow_target vivado
        source ../../common/part.tcl

        # Directive files may use $T (reg_dist does).
        set dfile ./directives_${top}_${sol}.tcl
        if {[file exists $dfile]} { source $dfile }

        if {$first} { csim_design; set first 0 }
        csynth_design
        if {$DO_COSIM && [lsearch -exact $cosim $sol] >= 0} { cosim_design }
    }
    close_project
}
exit
```

Notes on the script:
- **Same shape as S2.1.1**, with `M` and `T` keys. The directive files do not depend on $T$ (except `reg_dist`, which reads `$T`), so projects of the same kernel differ only in `-DGEMM_M` and `-DTILE_T`.
- **csim runs once per project.** That checks bit-exactness at every $T$, which matters here because $T$ changes the code the compiler sees. All 10 csims PASSED (22 calls each).
- **Pass 2 does not rerun pass 1.** `open_project -reset` would wipe `tile_t32_proj` and `base_proj`, so they are left out of the pass-2 list.
- **Pass 3 reruns `tile_t8_proj`** from scratch (csim, both csynths, both cosims). Collect `lat_t8.md` after pass 3, not after pass 2.
- **Cosim scope:** `tile_t8_proj` only, both solutions. Same $T$, different II, so one cosim pair covers the II difference and bit-exactness in RTL. It took 12.5 minutes, most of it in `t8/reg` (232 065 cycles × 22 calls).
- **`make clean`:** every project name ends in `_proj`, and every log matches `run_*.log`, so the root Makefile already covers them.

The four passes as run:

```bash
vitis_hls -f run_hls.tcl 2>&1 | tee run_pass1.log
ONLY="tile_t1_proj tile_t2_proj tile_t4_proj tile_t8_proj tile_t16_proj" DO_COSIM=0 vitis_hls -f run_hls.tcl 2>&1 | tee run_pass2.log
ONLY="bigm_t1024_proj bigm_t16_proj tshift_t8_proj" DO_COSIM=0 vitis_hls -f run_hls.tcl 2>&1 | tee run_extras.log
ONLY="tile_t8_proj" DO_COSIM=1 vitis_hls -f run_hls.tcl 2>&1 | tee run_cosim.log
```

### 4.3 The directives

```tcl
# directives_gemm_naive_pipe.tcl
set_directive_pipeline -II 1 "gemm_naive/PROD"
```

```tcl
# directives_gemm_tile_ram.tcl
set_directive_bind_storage -type ram_2p "gemm_tile" acc
set_directive_pipeline -II 1 "gemm_tile/TCOL"
```

```tcl
# directives_gemm_tile_reg.tcl
set_directive_array_partition -type complete -dim 1 "gemm_tile" acc
set_directive_pipeline -II 1 "gemm_tile/TCOL"
```

```tcl
# directives_gemm_tile_reg_dist.tcl   (pass-1 gate fallback at T = 32; extra 5.5b at T = 4)
# $T is set by run_hls.tcl before this file is sourced.
set_directive_array_partition -type complete -dim 1 "gemm_tile" acc
set_directive_pipeline -II 1 "gemm_tile/TCOL"
set_directive_dependence -variable acc -type inter -dependent true -distance $T "gemm_tile/TCOL"
```

```tcl
# directives_gemm_tile_reg_prod.tcl   (T = 1 only, blocker 4)
# With TILE_T = 1 the one-trip TCOL is removed before the pipeline directive
# on gemm_tile/TCOL is applied, silently. PROD is the same work at T = 1.
set_directive_array_partition -type complete -dim 1 "gemm_tile" acc
set_directive_pipeline -II 1 "gemm_tile/PROD"
```

```tcl
# directives_gemm_tshift_reg.tcl   (extra 5.5c)
set_directive_array_partition -type complete -dim 1 "gemm_tshift" acc
set_directive_pipeline -II 1 "gemm_tshift/TCOL"
```

About the directives [2]:
- **`bind_storage` form** is the one that worked in S2.1.1 (the log showed `RAM_2P`, BIND 205-102). Here it held at every $T$: `acc` was never auto-partitioned, even at 2 words.
- **`array_partition -type complete -dim 1`** turns the one-dimensional `acc` into $T$ separate registers. The log confirms it with `HLS 214-248 Applying array_partition to 'acc': Complete partitioning on dimension 1`.
- **Confirmed on this install: `set_directive_dependence -variable acc` does nothing after `acc` has been partitioned.** The directive is echoed, no warning is printed, and the report is identical to `reg` (at both $T = 4$ and $T = 32$). S2.1.3 showed the same with `lane`.
- **$T = 1$:** the pipeline directive on `gemm_tile/TCOL` was dropped without any message: no `Pipelining result` line, no pipelined loop in the report (blocker 4). `directives_gemm_tile_reg_prod.tcl` is the copy with the location `"gemm_tile/PROD"`.

### 4.4 Collecting

```bash
C=../../common

# latency and resources, one file per project (tile_t8_proj after pass 3)
PROJ=base_proj TOP=gemm_naive OUT=lat_base.md bash $C/collect_latency.sh
PROJ=base_proj TOP=gemm_naive OUT=res_base.md bash $C/collect_resources.sh
for T in 1 2 4 8 16 32; do
  [ -d tile_t${T}_proj ] || continue
  PROJ=tile_t${T}_proj TOP=gemm_tile OUT=lat_t${T}.md bash $C/collect_latency.sh
  PROJ=tile_t${T}_proj TOP=gemm_tile OUT=res_t${T}.md bash $C/collect_resources.sh
done
for P in bigm_t1024 bigm_t16; do
  PROJ=${P}_proj TOP=gemm_tile OUT=lat_$P.md bash $C/collect_latency.sh
  PROJ=${P}_proj TOP=gemm_tile OUT=res_$P.md bash $C/collect_resources.sh
done
PROJ=tshift_t8_proj TOP=gemm_tshift OUT=lat_tshift_t8.md bash $C/collect_latency.sh
PROJ=tshift_t8_proj TOP=gemm_tshift OUT=res_tshift_t8.md bash $C/collect_resources.sh

# is acc a memory in each ram row, and absent in each reg row?
# (the section header in the per-module report is "* Memory:")
for d in tile_t*_proj/* bigm_*_proj/* tshift_t8_proj/*; do
  r=$d/syn/report; [ -d $r ] || continue
  printf "%-24s: " $d
  grep -h -A12 "\* Memory:" $r/*_csynth.rpt | grep -m1 -E "acc|N/A" | tr -s ' '
done
```

**Log summary** (II, violations, 200-871 and the clock estimate, per solution). It keys on the `Running: open_project` and `Running: open_solution` echoes, because other `HLS 200-10` lines also mention the solution.

```bash
awk '
  /Running: open_project/     { proj = $NF }
  /Running: open_solution/    { sol = proj "/" $(NF-2); order[++n] = sol; viol[sol] = 0; t871[sol] = "no" }
  /Pipelining result/         { match($0, /Final II = [0-9]+, Depth = [0-9]+, loop .[A-Za-z_]+./); res[sol] = substr($0, RSTART, RLENGTH) }
  /II Violation/              { viol[sol]++ }
  /^WARNING: \[HLS 200-871\]/ { match($0, /\([0-9.]+ ns\)/); t871[sol] = "yes " substr($0, RSTART, RLENGTH) }
  END { for (i = 1; i <= n; i++) { s = order[i]; printf "%-24s %-46s viol=%-2d 200-871=%s\n", s, res[s], viol[s], t871[s] } }
' run_pass1.log run_pass2.log run_extras.log
```

**`acc` read and write stages in the RTL** (the span $\delta$). With II = $I$, stage $s$ of `ap_enable_reg_pp0_iter`$j$ in FSM state `pp0_stage`$k$ is cycle $jI + k$ of a trip.

```bash
f=tile_t2_proj/ram/syn/verilog/gemm_tile_gemm_tile_Pipeline_PROD_TCOL.v
grep -nE "^\s*acc_(ce0|we1)\s*=\s*1'b1" -B3 $f | grep if
```

---

## 5. Measure

All numbers below are from Vitis HLS 2023.2.2, collected with the commands in 4.4. The reports are in `lat_*.md` and `res_*.md`.

### 5.1 Timing

$C_{\text{run}}$ is the loop latency of the pipelined loop (per run). $L$ is solved as $C_{\text{run}} - I\,(\text{trips} - 1)$. Fn predicted is the Stage B answer (II from the $D + 4$ model).

| row | II tgt | II ach | trips | $C_{\text{run}}$ | $L$ (solved) | Fn lat (max) | Fn predicted | Δ | est. ns | 200-871? | viol. lines | $D$ | $D_{\text{mul}}$ |
|-----|--------|--------|-------|------------------|--------------|--------------|--------------|---|---------|----------|-------------|-----|------------------|
| `base/pipe` | 1 | 7 | 32 768 | 229 387 | 18 | 229 389 | 229 389 | 0 | 2.747 | yes | 6 | 7 | 6 |
| `t1/reg` | 1 | — (not pipelined) | — | — | — | 658 497 | 248 832 | +165% | 2.416 | no | 0 | 10 | 6 |
| `t1/reg_prod` | 1 | 7 | 32 768 | 229 387 | 18 | 229 389 | ≈ 229 389 | 0 | 2.747 | yes | 6 | 7 | 6 |
| `t2/ram` | 1 | 5 | 64 | 332 | 17 | 175 105 | 208 384 | −16.0% | 3.337 | yes | 4 | 7 | 6 |
| `t2/reg` | 1 | 7 | 64 | 457 | 16 | 238 593 | 143 872 | +65.8% | 3.597 | yes | 6 | 7 | 6 |
| `t4/ram` | 1 | 3 | 128 | 399 | 18 | 105 473 | 106 496 | −1.0% | 2.549 | yes | 2 | 7 | 6 |
| `t4/reg` | 1 | 7 | 128 | 904 | 15 | 234 241 | 73 984 | +217% | 3.940 | yes | 6 | 7 | 6 |
| `t4/reg_dist` | 1 | 7 | 128 | 904 | 15 | 234 241 | = `t4/reg` if the directive is dropped | 0 | 3.940 | yes | 6 | 7 | 6 |
| `t8/ram` | 1 | 2 | 256 | 528 | 18 | 70 273 | 71 680 | −2.0% | 2.730 | yes | 1 | 7 | 6 |
| `t8/reg` | 1 | 7 | 256 | 1 800 | 15 | 232 321 | 38 656 | +501% | 3.940 | yes | 6 | 7 | 6 |
| `t16/ram` | 1 | 1 | 512 | 532 | 21 | 36 417 | 37 440 | −2.7% | 2.778 | yes | 0 | 10 | 6 |
| `t16/reg` | 1 | 7 | 512 | 3 593 | 16 | 231 425 | 37 440 | +518% | 3.605 | yes | 6 | 7 | 6 |
| `t32/ram` | 1 | 1 | 1 024 | 1 044 | 21 | 36 641 | 36 641 | 0 | 2.781 | yes | 0 | 10 | 6 |
| `t32/reg` | 1 | 7 | 1 024 | 7 176 | 15 | 230 881 | ≈ 36 640 | +530% | 3.653 | yes | 6 | 7 | 6 |
| `t32/reg_dist` | 1 | 7 | 1 024 | 7 176 | 15 | 230 881 | ≈ 36 640 | +530% | 3.653 | yes | 6 | 7 | 6 |

The log `Depth` is $L + 1$ in every pipelined row, as in S2.1.1.

**The RAM span in RTL** (`acc_ce0` = read address out, `acc_we1` = write; cycle $= jI + k$ for `iter`$j$ / `stage`$k$):

| row | II | read cycle | write cycle | span | $I \cdot T$ | slack |
|-----|----|-----------|-------------|------|-------------|-------|
| `t2/ram` | 5 | 8 | 17 | 10 | 10 | 0 |
| `t4/ram` | 3 | 7 | 18 | 12 | 12 | 0 |
| `t8/ram` | 2 | 7 | 18 | 12 | 16 | 4 |
| `t16/ram` | 1 | 8 | 21 | 14 | 16 | 2 |
| `t32/ram` | 1 | 8 | 21 | 14 | 32 | 18 |

In the tight row, `t2/ram`, the chain is: read address at 8; `acc_q0` through the `k == 0` mux into `prev_reg` at 9; `fadd` from 10 to 16 ($D = 7$); write at 17. That is $\delta = D + 3 = 10$. At $T = 4$ the tool spread the same chain over 12 cycles, because $I \cdot T = 12$ allowed it. The S2.1.1 reading of $D + 4 = 14$ (at $D = 10$) is the same kind of loose schedule. The tight $\delta$ at $D = 10$ was never tested here, because no row puts the slow core under pressure.

**Checks.**
1. **Baseline:** ✓. `base/pipe` reproduces S2.1.1 exactly: II 7, Fn 229 389, DSP 3, LUT 1037, FF 1002.
2. **Transposition limit:** ✓. `t32/ram` reproduces S2.1.1 `trans/pipe` to the cycle and to the LUT: II 1, Fn 36 641, DSP 5, LUT 914, FF 1095, 1 BRAM.
3. **Flattening:** ✓. The pipelined loop is `PROD_TCOL` with $32T$ trips in every `ram`/`reg` row. For $2 \le T \le 16$, `TILE` is also flattened into `ROW` (`ROW_TILE`, $32 \cdot 32/T$ trips), which leaves the run count at $NM/T$. `t1/reg_prod` is flattened three levels (`ROW_TILE_PROD`).
4. **The main result:** half ✓. The `ram` rows follow $\lceil \delta/T \rceil$ with $\delta_{\text{ram}} = D + 3 = 10$, not $D + 4$. The `reg` rows follow no model in $T$: II 7 = $D$ at every $T$, because the analyzer sees distance 1 on `mux_case_05` (blocker 1). $\varepsilon$ cannot be solved.
5. **Violations:** ✓. `II Violation` lines = $I - 1$ in every row (4, 2, 1, 0, 0 for `ram`; 6 for every `reg`).
6. **Core rule:** partly. Step 1 holds in every row. Step 2 (move back to the slow core if it still fits) happened only at II = 1: `t16/ram` and `t32/ram`. `t8/ram` kept the fast core at II 2, although $\delta(10) = 13 \le 16$. The `reg` rows are at II 7 with the fast core; the slow core would need II 10.
7. **Cycle model:** ✓ for `ram` where II matched (−1% to −3%; the rest is $w = 2$ for LUTRAM). Every row fits the exact form in the Stage B *Measured* block.
8. **`t1/reg`:** neither outcome with the `TCOL` directive, because nothing was pipelined. With the directive on `PROD` (`reg_prod`) it became outcome 2: the tool rewrote the nest into one run, the same as `base/pipe`, to the cycle.

### 5.2 Area

| row | LUT | FF | DSP | BRAM | `acc` words × bits | `acc` BRAM / LUTRAM / none |
|-----|-----|----|-----|------|--------------------|---------------------------|
| `base/pipe` | 1037 | 1002 | 3 | 0 | — | — (scalar) |
| `t1/reg` | 702 | 839 | 5 | 0 | 1 × 32 | none |
| `t1/reg_prod` | 1030 | 939 | 3 | 0 | 1 × 32 | none |
| `t2/ram` | 1110 | 1037 | 3 | 0 | 2 × 32 | LUTRAM (1 LUT, 64 FF) |
| `t2/reg` | 1198 | 1057 | 3 | 0 | 2 × 32 | none |
| `t4/ram` | 1158 | 1116 | 3 | 0 | 4 × 32 | LUTRAM (2 LUT, 64 FF) |
| `t4/reg` | 1311 | 1153 | 3 | 0 | 4 × 32 | none |
| `t8/ram` | 1215 | 1181 | 3 | 0 | 8 × 32 | LUTRAM (4 LUT, 64 FF) |
| `t8/reg` | 1611 | 1536 | 3 | 0 | 8 × 32 | none |
| `t16/ram` | 942 | 1134 | 5 | 0 | 16 × 32 | LUTRAM (8 LUT, 64 FF) |
| `t16/reg` | 1458 | 1908 | 3 | 0 | 16 × 32 | none |
| `t32/ram` | 914 | 1095 | 5 | 1 | 32 × 32 | BRAM |
| `t32/reg` | 1886 | 2880 | 3 | 0 | 32 × 32 | none |

`reg_dist` rows are identical to their `reg` rows.

**Checks.**
1. **DSP matches the core column of 5.1:** ✓ in every row (3 ↔ $D = 7$, 5 ↔ $D = 10$).
2. **`reg` FF − `ram` FF ≈ $32T$:** ✗. The differences are +20, +37, +355, +774 and +1785 against a prediction of 64, 128, 256, 512 and 1024. At $T \le 4$ they are below the prediction. At $T \ge 8$ they are above it, and at $T = 16, 32$ they also include the core change (fabric against fulldsp `fadd`) and II 7 against II 1. There is no clean per-register cost to read here.
3. **`acc` listed:** ✓. Every `ram` row lists `acc_RAM_2P_AUTO_1R1W`; no `reg` row lists `acc`.
4. **The cheapest II = 1 point** is `t16/ram`, because no `reg` row reaches II 1. Against `t32/ram` it trades 1 BRAM_18K for +28 LUT and +39 FF, at the same 5 DSP, and it is 224 cycles faster (the LUTRAM `WRITE`). I would pick `t16/ram`: it frees a block RAM, and its buffer stays at 16 words for any $M$ (5.5a). These are csynth estimates; the LUTRAM/BRAM trade needs implementation numbers (S6.2) to settle.

### 5.3 Cosim (pass 3, `tile_t8_proj` only)

| row | Fn csynth | cosim min / avg / max | gap (cycles) | predicted gap | runs per call | pass? |
|-----|-----------|-----------------------|--------------|---------------|---------------|-------|
| `t8/ram` | 70 273 | 70 017 / 70 017 / 70 017 | −256 | −256 | 128 | PASS (22 calls) |
| `t8/reg` | 232 321 | 232 065 / 232 065 / 232 065 | −256 | −256 | 128 | PASS (22 calls) |

**The gap is per run.** With 128 runs per call the gap is −256 in both rows, which confirms S2.1.1's −2 per run of an extracted pipeline submodule (and rules out a per-call gap). Min, avg and max are equal, and all 22 transactions in `sim/report/verilog/result.transaction.rpt` have the same latency, so there is no first-call spread like S2.1.1 `naive/pipe` had. Both designs are bit-exact against the naive reference in RTL.

### 5.4 `results.csv` rows

One row per solution, 18 rows, appended to `notes/results.csv` (the file itself pads the columns):

```csv
s2.1.2,gemm_naive,pipe,float,32,,,1,7,229389,,1037,1002,3,0,364,?,"S2.1.1 naive/pipe re-run; ROW_COL_PROD 32768 trips (1 run); L=18; fadd lat=7 (fabric); 200-871=y"
s2.1.2,gemm_tile,reg,float,32,T,1,1,,658497,,702,839,5,0,414,?,"one-trip TCOL removed and pipeline directive dropped silently; not pipelined; = S2.1.1 naive/seq; fadd lat=10 (fulldsp); 0.35x vs naive pipe"
s2.1.2,gemm_tile,reg_prod,float,32,T,1,1,7,229389,,1030,939,3,0,364,?,"pipeline on PROD; ROW_TILE_PROD 32768 trips (1 run); L=18; fadd lat=7 (fabric); = naive pipe to the cycle; 1.00x vs naive pipe"
s2.1.2,gemm_tile,ram,float,32,T,2,1,5,175105,,1110,1037,3,0,300,?,"PROD_TCOL 64 trips x 512 runs; L=17; fadd lat=7 (fabric); acc 2x32 LUTRAM; RTL span 10 = D+3; 200-871=y; 1.31x vs naive pipe"
s2.1.2,gemm_tile,reg,float,32,T,2,1,7,238593,,1198,1057,3,0,278,?,"acc partitioned; 6x 200-880 on mux_case_05 distance 1; L=16; fadd lat=7 (fabric); 0.96x vs naive pipe"
s2.1.2,gemm_tile,ram,float,32,T,4,1,3,105473,,1158,1116,3,0,392,?,"PROD_TCOL 128 trips x 256 runs; L=18; fadd lat=7 (fabric); acc 4x32 LUTRAM; 200-871=y; 2.17x vs naive pipe"
s2.1.2,gemm_tile,reg,float,32,T,4,1,7,234241,,1311,1153,3,0,254,?,"mux_case_05 distance 1; L=15; fadd lat=7 (fabric); crit C_load->prev->fadd 3.940 ns; 0.98x vs naive pipe"
s2.1.2,gemm_tile,reg_dist,float,32,T,4,1,7,234241,,1311,1153,3,0,254,?,"extra 5.5b; dependence distance=4 on partitioned acc ignored without warning; identical to reg"
s2.1.2,gemm_tile,ram,float,32,T,8,1,2,70273,70017,1215,1181,3,0,366,?,"PROD_TCOL 256 trips x 128 runs; L=18; fadd lat=7 (fabric; slow core not retaken at II 2); acc 8x32 LUTRAM; cosim PASS 22 calls; gap -256 = -2/run; 3.26x vs naive pipe"
s2.1.2,gemm_tile,reg,float,32,T,8,1,7,232321,232065,1611,1536,3,0,254,?,"mux_case_05 distance 1; L=15; fadd lat=7 (fabric); cosim PASS 22 calls; gap -256 = -2/run; 0.99x vs naive pipe"
s2.1.2,gemm_tile,ram,float,32,T,16,1,1,36417,,942,1134,5,0,360,?,"PROD_TCOL 512 trips x 64 runs; L=21; fadd lat=10 (fulldsp); acc 16x32 LUTRAM (WRITE w=2); cheapest II=1; 6.30x vs naive pipe"
s2.1.2,gemm_tile,reg,float,32,T,16,1,7,231425,,1458,1908,3,0,277,?,"mux_case_05 distance 1; L=16; fadd lat=7 (fabric); 0.99x vs naive pipe"
s2.1.2,gemm_tile,ram,float,32,T,32,1,1,36641,,914,1095,5,1,360,?,"= S2.1.1 trans/pipe; PROD_TCOL 1024 trips x 32 runs; L=21; fadd lat=10 (fulldsp); acc 32x32 BRAM (WRITE w=3); 6.26x vs naive pipe"
s2.1.2,gemm_tile,reg,float,32,T,32,1,7,230881,,1886,2880,3,0,274,?,"pass-1 gate FAIL; mux_case_05 distance 1; L=15; fadd lat=7 (fabric); crit A_load->fmul 3.653 ns; 0.99x vs naive pipe"
s2.1.2,gemm_tile,reg_dist,float,32,T,32,1,7,230881,,1886,2880,3,0,274,?,"gate fallback; dependence distance=32 on partitioned acc ignored without warning; identical to reg"
s2.1.2,gemm_tile,ram,float,32,T,1024,1,1,1147681,,946,1141,5,2,414,?,"extra 5.5a; M=1024; full transposition; PROD_TCOL 32768 trips x 32 runs; L=21; acc 1024x32 on 2 BRAM_18K; 200-871=n"
s2.1.2,gemm_tile,ram,float,32,T,16,1,1,1165313,,977,1169,5,0,360,?,"extra 5.5a; M=1024; PROD_TCOL 512 trips x 2048 runs; L=21; acc 16x32 LUTRAM; +1.5% vs T=1024"
s2.1.2,gemm_tshift,reg,float,32,T,8,1,7,232193,,3831,3824,3,0,212,?,"extra 5.5c; shift-register tile buffer; 6x 200-880 on acc distance 1; L=14; 8 fabric fadd cores; crit fmul->fadd 4.708 ns"
```

- `kernel` is the top function and `variant` the solution (`pipe`, `ram`, `reg`, `reg_prod`, `reg_dist`), as in the S2.1.1 and S2.1.3 rows. `sweep_param` is `T`.
- `N` stays 32 ($N = K$). The extra 5.5a rows say `M=1024` in `notes`.
- `fmax_est` is $1000/\text{est. ns}$. `latency_cosim` is filled in only for the two `t8` rows. `II_achieved` is empty for `t1/reg`, which was not pipelined.

### 5.5 Extras

**5.5a — The point of tiling: a buffer that does not grow with $M$** (csynth only).

At $M = 32$ tiling costs a little and saves nothing. To see what it is for, make $M$ large enough that the full buffer needs real memory. With $M = 1024$, full transposition needs `acc` = 1024 × 32 bits, about two BRAM_18K, while the tiled buffers stay at 16 or 8 words.

Steps (already in the files):
1. `gemm.h` takes `M` from `-DGEMM_M`, with an `#error` if it is missing. `run_hls.tcl` passes `-DGEMM_M=32` to every other project, so nothing else changes.
2. Two projects with `-DGEMM_M=1024`: `bigm_t1024_proj` (`T 1024`, `sols {ram}`, which is full transposition) and `bigm_t16_proj` (`T 16`, `sols {ram}`). The README originally planned a third, `bigm_t8/reg`. It was dropped because the register form is stuck at II 7 (5.1), so it would only repeat that result at a larger size.
3. Compare the `acc` memory rows and Fn.

<details><summary>Expected</summary>

With the same model ($N = K = 32$, $M = 1024$, so $NM = 32\,768$ output elements):

| project | tiles | $C_{\text{tile}}$ | Fn | vs full | `acc` |
|---------|-------|-------------------|----|---------|-------|
| `bigm_t1024/ram` | 32 | 21 + 32 767 + 3·1024 + 5 = 35 865 | ≈ 1 147 680 | — | 1024 × 32 bits, about 2 BRAM_18K |
| `bigm_t16/ram` | 2048 | 585 | ≈ 1 198 080 | +4.4% | 16 × 32 bits |
| `bigm_t8/reg` | 4096 | 302 | ≈ 1 236 992 | +7.8% | none (256 FF) |

The naive design at this size would be about $7 \times 32 \times 32 \times 1024 \approx 7.3$ million cycles. So all three keep essentially the whole $D$-fold gain, and the tiled ones do it with a buffer that is the same size as at $M = 32$. That is the trade the paper describes: tiling bounds fast-memory use, it does not add speed [1, Sec. 3.4].

</details>

<details><summary>Measured</summary>

| project | II | trips × runs | $L$ | $C_{\text{tile}}$ | Fn | vs full | est. ns | LUT / FF / DSP / BRAM | `acc` |
|---------|----|--------------|-----|-------------------|----|---------|---------|-----------------------|-------|
| `bigm_t1024/ram` | 1 | 32 768 × 32 | 21 | 35 865 | 1 147 681 | — | 2.416 (no 200-871) | 946 / 1141 / 5 / **2** | 1024 × 32, BRAM |
| `bigm_t16/ram` | 1 | 512 × 2048 | 21 | 569 | 1 165 313 | **+1.5%** | 2.778 | 977 / 1169 / 5 / **0** | 16 × 32, LUTRAM |

- **`bigm_t1024` matches the model to one cycle.** $32 \cdot 35\,865 + 1 = 1\,147\,681$.
- **`bigm_t16` costs 1.5%, not 4.4%.** The model's $C_{\text{tile}} = 585$ assumed a BRAM `WRITE` ($w = 3$). The 16-word LUTRAM gives $w = 2$, so $C_{\text{tile}} = 532 + 2 + 32 + 3 = 569$. The `bigm_t16` tile is the same pipeline as `t16/ram`, cycle for cycle: only the number of tiles changed.
- **The buffer really is bounded:** 2 BRAM_18K → 0 BRAM, for +31 LUT and +28 FF.
- **The log `Depth` of `bigm_t1024` is 23**, while $L$ solved from $C_{\text{run}}$ is 21 (iteration latency 22). As in S2.1.3, trust $C$. This is also the only pipelined design in this lesson without HLS 200-871: its estimate is 2.416 ns, the same value as the `fmul` delay in the other critical-path reports.

</details>

**5.5b — `reg_dist` even if `reg` passes the gate** (one project).

Add `reg_dist` to `tile_t4_proj`. If the analyzer already sees $d = 4$, the directive should change nothing: same II, same schedule, same area. If it changes anything, that is worth a line in `notes/findings.md`.

<details><summary>Measured</summary>

`reg` did not pass the gate, so this became a second check of the directive on a partitioned array. `t4/reg_dist` is identical to `t4/reg` in every report field: II 7, 6 violations on `mux_case_05` (distance 1), Fn 234 241, 3.940 ns, LUT 1311, FF 1153. The directive is echoed and silently does nothing, at $T = 4$ as at $T = 32$.

</details>

**5.5c — A shift-register tile buffer** (added after the gate failed; one project).

S2.1.3's fix for a partitioned lane was the shift form: the distance is then a chain of register copies that the tool can see without a directive. `src/gemm_tshift.cpp` applies it to the tile buffer. The tail `acc[TILE_T-1]` is the same column one `k` earlier, the new sum enters at `acc[0]`, and `WRITE` reads the chain in reverse.

```cpp
// src/gemm_tshift.cpp   (extra 5.5c)
#include "gemm.h"

#ifndef TILE_T
#error "TILE_T is not defined: pass -DTILE_T=<T> in add_files -cflags"
#endif

static_assert(M % TILE_T == 0, "TILE_T must divide M");

// gemm_tile with the tile buffer written as a shift register (the S2.1.3
// acc_shift form). acc[TILE_T-1] holds the sum of the same column one k earlier,
// so the distance is visible in the code instead of hidden in the index t.
void gemm_tshift(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]) {
    data_t acc[TILE_T];

ROW:
    for (int n = 0; n < N; n++) {
    TILE:
        for (int m = 0; m < M / TILE_T; m++) {
        PROD:
            for (int k = 0; k < K; k++) {
            TCOL:
                for (int t = 0; t < TILE_T; t++) {
                    data_t prev = (k == 0) ? C[n][m * TILE_T + t] : acc[TILE_T - 1];
                    data_t s = prev + A[n][k] * B[k][m * TILE_T + t];
                SHIFT:
                    for (int j = TILE_T - 1; j > 0; j--) acc[j] = acc[j - 1];
                    acc[0] = s;
                }
            }
        WRITE:
            // After the last k, column t sits TILE_T-1-t places down the chain.
            for (int t = 0; t < TILE_T; t++) {
                C[n][m * TILE_T + t] = acc[TILE_T - 1 - t];
            }
        }
    }
}
```

Project `tshift_t8_proj` (`T 8`, `sols {reg}`, directives `directives_gemm_tshift_reg.tcl`). Prediction if the S2.1.3 result carries over: the same as `t8/reg` should have been, II 1 with $\delta = D$.

<details><summary>Measured</summary>

| row | II | viol. | $L$ | Fn | est. ns | LUT / FF / DSP | `fadd` cores |
|-----|----|-------|-----|----|---------|----------------|--------------|
| `tshift_t8/reg` | **7** | 6 on `acc`, distance 1 | 14 | 232 193 | **4.708** | 3831 / 3824 / 3 | **8** (fabric, lat 7) |

- **The shift form does not help here either.** csim passes (22 calls), the partition is applied (HLS 214-248) and `SHIFT` is unrolled (HLS 214-186). The analyzer still reports a distance-1 dependency on `acc`, and II stays at 7.
- **The tool built something very different from the C.** It instantiated 8 `fadd` cores (`acc_add` … `acc_6_add`, `acc_8`) instead of 1, and chained `fmul` straight into `fadd` in one cycle (4.708 ns). LUT and FF are about 2.4× `t8/reg`.
- **Why this differs from S2.1.3 is not established.** Two differences from S2.1.3's `acc_shift` are the flattened `PROD_TCOL` nest and the `k == 0` mux in front of the tail read. Two variants tried outside the script (a zero-initialised buffer, and reading the tail before the shift) gave the same II 7 at $T = 8$. Record it as tool behaviour, like S2.1.3's `shift_k2`.

</details>

---

## 6. Questions

**Q1.** The paper says the tile size should be at least the add latency. With $D = 7$, the RAM form reached II = 1 at $T = 16$ and II = 2 at $T = 8$, although $8 \ge D$. Which buffer does the paper's rule describe, and what is the rule that covers the RAM case?

<details><summary>Answer</summary>

**The paper's rule is the register case.** Its buffered-accumulation figure treats the buffer as storage that can be read and written with no extra delay, so the only span to cover is the add itself: $T \ge L_+$ [1, Sec. 2.1.2].

**The rule that covers both** is $T \ge \delta$, where $\delta$ is the full read-to-write span of the buffer in the schedule. For a two-port RAM on this tool, the tight span is $\delta = D + 3$ (`t2/ram` RTL: address out, then data through the `k == 0` mux into a register, then $D$ cycles of `fadd`, then the write). With $D = 7$ that is $T \ge 10$, so $T = 16$ is the first power of two. Every `ram` row matches $\lceil (D+3)/T \rceil$. Anything that adds stages between reading `acc[t]` and writing it back (a slower core, a registered mux, a RAM) raises $\delta$ and therefore the tile size you need.

**Two practical points.**
- Read $\delta$ from the most tightly scheduled row, not from one with slack. S2.1.1's $D + 4$ came from a design where $M = 32$ left 18 trips spare, so the tool had no reason to pack the read.
- The register case could not be tested on this install, because the tool never saw $d = T$ through registers (Q2). S2.1.3's lane count $K$ follows the same $\delta$ rule, and there the shift form did reach $\delta \approx D$.

</details>

**Q2.** The `reg` form was meant to show the paper's $T \ge D$ rule. Instead every `reg` row, at every $T$, came out at II 7, with or without `set_directive_dependence -distance $T`. What does the tool actually see, and why can the directive not fix it?

<details><summary>Answer</summary>

**What the tool sees.** `set_directive_array_partition -type complete` is applied in the front end (HLS 214-248), before loop analysis. The indexed statements `prev = acc[t]` and `acc[t] = ...` are rewritten into $T$ registers, one per element, each with a `t == j` mux on its input. After if-conversion, every register is loaded and stored on *every* trip: it gets either the new sum or its own old value. The violation lines name exactly that: `store` and `load` on the local variable `mux_case_05`, distance 1, offset 0. In the rewritten code this is a real distance-1 dependency, so the analyzer's answer of II = $D$ is correct for the code it was given.

**Why the directive cannot fix it.** `set_directive_dependence -variable acc` attaches to the source array `acc`. After the partition there is no `acc`, only `mux_case_*`, so the directive matches nothing. The log echoes it and prints no warning (`t4/reg_dist`, `t32/reg_dist`). S2.1.3 found the same with `lane`.

**What does work.** Keep the buffer as a memory, `ram` (the analyzer sees `distance = T, offset = 1` through the RAM index), and pay the extra 3 cycles of $\delta$. The shift form, which fixed this in S2.1.3, did not help in this nest (5.5c).

**Side effect worth remembering.** Because II 7 leaves slack, the tool packed the `reg` pipelines 2–3 stages shallower and chained memory reads into the `fadd`/`fmul` inputs. The result is 3.6–3.9 ns estimates, over the 3.33 ns clock itself. A "slow but safe" II can still fail timing.

</details>

**Q3.** `t16/ram` and `t32/ram` both run at II = 1, yet `t16/ram` has twice as many pipeline runs and is *faster*. And `t1/reg_prod` has 1024 tiles but is cycle-identical to `base/pipe`. Where do the per-tile cycles come from, and which later lesson removes them?

<details><summary>Answer</summary>

**Per-tile cost.** Each tile is one run of the flattened `PROD_TCOL` submodule, plus the `WRITE` loop, plus the loop overhead:

$$C_{\text{tile}} = \underbrace{L + I(KT - 1)}_{C_{\text{run}}} + 2 + T\,w + o_r$$

At II = 1 the only $T$-dependent part is $\frac{NM}{T}(L - 1 + 2 + o_r)$ plus the `WRITE` term $NM\,w$.
- **`t16/ram` vs `t32/ram`:** 32 more runs × 25 = +800 cycles. But the 16-word buffer is LUTRAM, and its `WRITE` read takes $w = 2$ instead of 3 on the 32-word BRAM, which saves 1024 cycles. Net −224. The buffer's storage type moved the result more than the run count did.
- **`t1/reg_prod`:** with $T = 1$ the one-trip `TCOL` and `WRITE` loops vanish, the nest becomes `ROW`·`TILE`·`PROD` with one statement before and after `PROD`, and the tool rewrites it into one perfect nest (HLS 200-2061) and one run of 32 768 trips, exactly as it did for `naive/pipe`. There is no per-tile cost left.

**What removes them in general.** The runs are separate because `TILE` holds two loops, `PROD_TCOL` and `WRITE`, so it cannot be flattened into one pipeline. Folding the write into the pipelined loop is pipelined loop fusion (S2.4), and then coalescing `TILE`, `PROD` and `TCOL` into one loop is flattening (S2.5). The paper's matrix-multiplication case study does exactly that in its first stage [1, Sec. 6.2].

</details>

**Q4.** At $M = 32$, tiling barely changes the speed of full transposition. So why does the paper include it, and what does the tile structure enable later in this curriculum?

<details><summary>Answer</summary>

**Bounded buffer.** Full transposition needs a buffer of $M$ elements. That is fine at $M = 32$, but it grows with the problem. At $M = 1024$ it already takes 2 BRAM_18K, while `bigm_t16/ram` keeps a 16-word LUTRAM with 0 BRAM, at +1.5% latency (5.5a). For the paper's $8192 \times 8192$ matrices it is 8192 floats per replicated unit. The tile buffer is $T$ elements for any $M$, so the same hardware handles any matrix width, at the cost of a few percent more pipeline restarts. That is why the paper also lists it under tiling, whose purpose is to fit fast memory, not to add speed [1, Sec. 3.4].

**What it enables.** Replication (S3.2) keeps $P$ rows of `A` in registers and updates them in parallel against each streamed value of `B`. The partial sums then become a $T \times P$ buffer [1, Sec. 3.2, Lst. 10]. Without the tile, that buffer would be $M \times P$, which does not scale.

</details>

**Q5.** Across the `ram` sweep the DSP count went 3, 3, 3, 5, 5 although the source did not change. What decides it, and is the tool's choice always the better design?

<details><summary>Answer</summary>

**What decides it.** The `fadd` core. The tool first finds the smallest II that works with the fast fabric core (7 cycles, 0 DSP). Only if that II is 1 does it try the slow fulldsp core (10 cycles, 2 DSP) and keep it when it still fits. So DSP = 5 at $T = 16, 32$ (II 1, $\delta(10) = 13 \le T$) and DSP = 3 at $T = 2, 4, 8$. At $T = 8$ the slow core would also have fitted at II 2 ($13 \le 16$), but the tool did not go back to it once II had been relaxed. The `reg` rows all kept the fast core, because II 7 is below the slow core's $D = 10$.

**Is it better?** Not by itself. The slow core has more timing margin and uses hard DSP blocks; the fast core uses fabric LUTs (the `t2`–`t8` `ram` rows have *more* LUT than `t32/ram`) and has less margin. Which is better depends on what limits the design: throughput (take II 1), DSP budget (take the fabric core), or Fmax. csynth's timing estimate is only a hint, and in the `ram` rows the 200-871 warnings come from the flattened loop counter, not the adder. Real Fmax needs implementation, which is S6.2. `set_directive_bind_op` (S5.1) lets you fix the core yourself instead of leaving it to the tool.

</details>

---

## 7. Conclusions

### What we set out to show

The claim from [1, Sec. 2.1.2]: interleaving over a tile of $T$ columns instead of all $M$ keeps the II gain of full transposition while bounding the buffer at $T$ elements. The condition is that $T$ covers the add latency. Expected outcome:
- II falls as $\lceil \delta/T \rceil$ and reaches 1 once $T \ge \delta$;
- $\delta \approx D$ for a register buffer and $\delta = D + 4$ for a RAM (S2.1.1), so registers reach II = 1 one power of two earlier ($T = 8$ against $T = 16$);
- at II = 1, a few percent slower than full transposition, because of more pipeline runs;
- bit-exact at every $T$.

### How we tested it

- **One kernel, one source, a $T$ sweep.** $T = 1 \dots 32$ (powers of two) with the tile buffer in two forms: pinned to a `ram_2p` and completely partitioned into registers. Same part, clock, arithmetic and loop structure in every row.
- **Two end-point controls.** `base_proj` re-runs S2.1.1 `naive/pipe`. `t32/ram` must reproduce S2.1.1 `trans/pipe`. Both reproduced to the cycle and to the LUT.
- **Cycle-exact models.** II from $\lceil \delta/T \rceil$ and latency from a per-tile model, calibrated on `t32/ram` and checked row by row. The RAM read and write stages were read from the RTL for every `ram` row.
- **A gate before the sweep.** `t32/reg` had to reach II 1 before the register sweep meant anything. When it failed, the fallback `reg_dist` was tried, and a shift-register form (5.5c) was added.
- **Correctness.** csim at every $T$ (22 calls: 6 directed, 2 of them aimed at tiling bugs, plus 16 random) and cosim on both `t8` designs, all compared against the naive order with exact `!=`.
- **Scale control.** $M = 1024$ (5.5a), to show what the bounded buffer is for.

### What the data shows

1. **The claim holds for the RAM form.** II 5, 3, 2, 1 at $T = 2, 4, 8, 16$. `t16/ram` reaches **6.30×** over `naive/pipe`, slightly *better* than full transposition (6.26×). Its buffer is 16 words of LUTRAM instead of a BRAM_18K. Cosim at $T = 8$ is bit-exact.
2. **The RAM span is $D + 3$, not $D + 4$.** When the schedule is tight (`t2/ram`, II 5), the tool packs read → register → $D$ × `fadd` → write into 10 cycles. S2.1.1's 14 at $D = 10$ was a schedule with slack. All four `ram` IIs match $\lceil 10/T \rceil$; $D + 4$ would have predicted II 6 at $T = 2$.
3. **The register form never works on this tool.** Every `reg` row is II 7 = $D$, at every $T$. A complete partition rewrites `acc[t]` into `mux_case_*` registers that are loaded and stored on every trip: a real distance-1 dependency in the rewritten code. `set_directive_dependence -variable acc` cannot reach those registers; it is dropped silently. The shift form from S2.1.3 also stays at II 7 in this nest. The paper's $T \ge L_+$ rule for registers is therefore untested here.
4. **The register rows are worse than slow.** Every `reg` row is slower than `naive/pipe` (0.96–0.99×). The pipelines are 2–3 stages shallower, with memory reads chained into the `fadd`/`fmul` inputs, and the estimates are 3.6–3.9 ns, over the 3.33 ns clock. FF also grows with $T$ (up to 2880 at $T = 32$).
5. **The core follows II, but only in one direction.** The fast fabric `fadd` is chosen whenever II > 1. The tool moves back to the slow fulldsp core only at II = 1 ($T = 16, 32$), even where the slow core would fit at the relaxed II (`t8/ram`). DSP goes 3 → 5 between $T = 8$ and $T = 16$.
6. **Storage type moves latency as much as tiling does.** A LUTRAM read in `WRITE` costs 2 cycles, a BRAM read 3, and a register 1. That one cycle per element is why `t16/ram` beats `t32/ram` by 224 cycles, and why `bigm_t16` is only +1.5% behind full transposition at $M = 1024$ (the model, with $w = 3$, said +4.4%). With the right $w$, every row fits $\text{Fn} = \frac{NM}{T}(C_{\text{run}} + 2 + Tw + o_r) + 1$ exactly.
7. **Tiling bounds the buffer at negligible cost.** At $M = 1024$: 2 BRAM_18K → 0, for +31 LUT, +28 FF and +1.5% latency, with the same 16-word buffer and the same pipeline as at $M = 32$.
8. **$T = 1$ is a trap in two ways.** A pipeline directive on a one-trip loop is dropped without a message (`t1/reg` is not pipelined, identical to S2.1.1 `naive/seq`). With the directive moved to `PROD`, the tool rewrites the tile nest back into the naive nest, cycle-identical to `base/pipe`.
9. **The cosim gap is per run.** −2 cycles per run of an extracted pipeline submodule: −256 at 128 runs, in both `t8` designs. This confirms S2.1.1's reading.

### Limits of this evidence

- **One design point per $T$:** $N = K = 32$, $M = 32$ (and 1024 in 5.5a), one part, one clock (3.33 ns), one tool version (2023.2.2).
- **$\delta_{\text{ram}} = D + 3$ is shown for $D = 7$ only.** No row put the slow core ($D = 10$) under pressure, so its tight span is inferred, not measured. The II = 1 rows show 14 with slack.
- **The register-form result is a tool result, not a limit of tiling.** It says that this tool, with complete partitioning or this shift form in a flattened tile nest, does not see $d = T$. Other buffer codings (for example an explicit cyclic delay buffer, S2.2) were not tried.
- **Why the shift form fails here while it worked in S2.1.3 is not explained.** Two variants were tried outside the script; the mechanism was not traced.
- **Timing is estimated only.** Every pipelined design except `bigm_t1024` prints HLS 200-871; the `reg` rows exceed even the clock period. `fmax_impl` was not measured.
- **Correctness is shown for the tested vectors** (22 calls, fixed seed) in csim at every $T$, and in cosim only at $T = 8$. The bit-exact argument in 1.6 is what generalises.

### Rules of thumb

- **Size the tile from the storage's span:** $T \ge D + 3$ for a two-port RAM buffer on this tool, and read $\delta$ from a tightly scheduled design. A design with slack will overstate it.
- **Keep an interleaving buffer as a memory** when its index is a loop counter and you need the tool to see the distance. Complete partitioning turns it into `mux_case_*` registers with a distance-1 dependency that no dependence directive can reach.
- **Check that a directive landed, not just that it was echoed.** A dependence directive on a partitioned array and a pipeline directive on a one-trip loop are both dropped silently. Look for the `Pipelining result` line and the variable names in the violation lines.
- **Count the storage type in the latency model.** BRAM, LUTRAM and register reads differ by a cycle, and in a loop outside the pipeline that cycle is paid per element.
- **Tile when the buffer size matters, not for speed.** At $M = 32$ tiling changes latency by under 1%. At $M = 1024$ it removes the buffer's block RAM for about 1.5% latency.

---

## References

[1] J. de Fine Licht, M. Besta, S. Meierhans, T. Hoefler, "Transformations of High-Level Synthesis Codes for High-Performance Computing," *IEEE Trans. Parallel and Distributed Systems*, 32(5), 2021. arXiv:1805.08288.
- Sec. 1.2, Eq. 1: the pipeline model $C = L + I(N-1)$.
- Sec. 2: loop-carried dependencies and interface contention as the two blockers.
- Sec. 2.1.1, Lst. 1a and 1b: naive and transposed matrix multiplication; buffer of depth $M$; implicit reset.
- Sec. 2.1.2, Lst. 1c: tiled accumulation interleaving; tile buffer of size $T \ge L_+$; extra inner loop over the tile.
- Sec. 2.2: the note that the transposed buffer is accessed in a fixed cyclic order and could be a delay buffer instead (S2.2).
- Sec. 2.4 and 2.5: pipelined loop fusion and flattening (Q3).
- Sec. 3.2, Lst. 10: replication built on the tile structure, with a $T \times P$ buffer (Q4).
- Sec. 3.4: tiling as a way to bound fast-memory use rather than a speedup (5.5a, Q4).
- Sec. 6.2: matrix-multiplication case study (transposition, memory extraction, fusion and coalescing in the first stage).
- Sec. 6.3: N-body case study, where tiled accumulation interleaving gave a 7× step tied to the accumulation latency.

[2] AMD, *Vitis High-Level Synthesis User Guide* (UG1399), version matching 2023.2 (https://docs.amd.com/r/2023.2-English/ug1399-vitis-hls). Reference pages for `set_directive_pipeline`, `set_directive_bind_storage`, `set_directive_array_partition`, `set_directive_dependence`, and `config_array_partition` (automatic partitioning threshold). Confirm option spellings with `help <command>` in `vitis_hls -i`.
