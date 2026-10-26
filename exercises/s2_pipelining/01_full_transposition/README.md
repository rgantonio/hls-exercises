# S2.1.1 — Full transposition

S1.2 showed that a running float sum pipelines at II = $D_{\text{add}}$: every iteration waits for the previous add. S2.1.3 split the sum into $K$ lanes, which changes the answer.

Matrix multiplication has the same blocker in its inner loop, and a way out that S2.1.3 did not have: a second loop to swap with. After the swap, $M$ running sums take turns, so each sum is touched once every $M$ iterations instead of every iteration. Every output element still gets the same float operations in the same order, so the result is bit-identical.

Kernel: `gemm_small`, $C = A \cdot B + C$, float, $N = K = M = 32$. Tool: Vitis HLS 2023.2.2.

**Result.** II 7 → 1, latency 229 389 → 36 641 cycles (6.26×), bit-exact in cosim. Cost: one 32 × 32 BRAM and 2 DSPs.

---

## 0. Setup

**Prerequisites:** S1.2 run; `common/part.tcl` (`xcku5p-ffvb676-2-e`, 3.33 ns, `config_compile -pipeline_loops 0`); `common/collect_latency.sh`, `common/collect_resources.sh`.

**Files**

```
s2_pipelining/01_full_transposition/
  README.md  run_hls.tcl
  src/gemm.h  src/gemm_naive.cpp  src/gemm_trans.cpp  src/tb_gemm.cpp
  directives_gemm_naive_pipe.tcl
  directives_gemm_trans_seq.tcl
  directives_gemm_trans_pipe.tcl
  directives_gemm_trans_pipe_noflat.tcl    (extra 5.5a)
  directives_gemm_trans_pipe_dist.tcl      (fallback, see 3.C)
```

**Projects.** Loop labels: `ROW` is `n`, `PROD` is `k`, `COL` is `m`; `WRITE` exists only in `gemm_trans`. Extras have their own projects, because `open_project -reset` wipes every solution of a project.

| project          | top          | dtype | solution      | what it is                                   |
|------------------|--------------|-------|---------------|----------------------------------------------|
| `naive_proj`     | `gemm_naive` | float | `seq`         | order `n, m, k`, nothing pipelined           |
| `naive_proj`     | `gemm_naive` | float | `pipe`        | `PROD` pipelined: the blocker                |
| `trans_proj`     | `gemm_trans` | float | `seq`         | order `n, k, m`, nothing pipelined           |
| `trans_proj`     | `gemm_trans` | float | `pipe`        | `COL` pipelined: the fix                     |
| `noflat_proj`    | `gemm_trans` | float | `pipe_noflat` | extra 5.5a: `pipe` with flattening off       |
| `naive_int_proj` | `gemm_naive` | int   | `pipe`        | extra 5.5b: the blocker with an integer add  |
| `dist_proj`      | `gemm_trans` | float | `pipe_dist`   | fallback only; not needed on 2023.2.2        |

**Why $N = K = M = 32$.**
- Powers of two: the flat address `n*32 + k` is a bit concatenation.
- $M$ is well above the span the `acc` buffer needs (14 trips, see 5.1).
- $32^3 = 32\,768$ multiply-adds per call: the II ratio is visible, and cosim of `naive/pipe` (≈ 229 000 cycles per call) takes about 6 minutes.

**Conventions** (from S1 and S2.1.3):
- The header uses `#error` if `DATA_T` is missing.
- The `Bind Op Report` is only in the design-wide `syn/report/csynth.rpt`.
- $D_{\text{add}}$ and $D_{\text{mul}}$ are read per solution.
- Pipeline depth comes from loop C: $L = C - I(\text{trips} - 1)$. The `Iteration Latency` column and the log's `Depth` read $L + 1$.
- II is recorded with the clock estimate and whether HLS 200-871 was printed.
- Speedups are against the kernel's own `seq`; the main result is `trans/pipe` against `naive/pipe`.

**New directives** (in `notes/directives.md`): `set_directive_bind_storage`, `set_directive_loop_flatten`.

---

## 1. The transformation

**Source:** de Fine Licht et al. [1, Sec. 2.1.1, Lst. 1a and 1b].

**Naive** (order `n, m, k`). A scalar `acc` starts at `C[n][m]`, `PROD` adds `A[n][k] * B[k][m]` for $k = 0 \dots K-1$, and the result is written back. `acc` is read and written in every iteration, through one `fadd`:

$$I_{\text{naive}} = D_{\text{add}}$$

**Transposed** (order `n, k, m`). $M$ sums are in progress at once, so the scalar becomes a buffer `acc[M]`. Once `PROD`·`COL` is flattened into one pipeline, `acc[m]` is written in trip $t$ and read again in trip $t + M$:

$$I_{\text{trans}} = 1 \quad \text{when } M \text{ covers the read-to-write span of } \texttt{acc} \text{ (14 trips here, 5.1)}$$

**What Vitis does to the two nests.**
- **Naive:** the nest is imperfect (`acc = C[n][m]` before `PROD`, `C[n][m] = acc` after it). Vitis moves both statements into the loop behind $k = 0$ and $k = K-1$ conditions (HLS 200-2061) and flattens all three loops into `ROW_COL_PROD`, 32 768 trips. **One pipeline run per call.**
- **Transposed:** `PROD`·`COL` is flattened into `PROD_COL`, 1024 trips, extracted into the submodule `gemm_trans_Pipeline_PROD_COL`. `ROW` stays, because `WRITE` follows `PROD`. **32 pipeline runs per call.**

So the gain comes from the II alone. The transposed design pays more around its pipeline (32 runs plus the `WRITE` loop), so expect a little under $D_{\text{add}}$.

**Deviations from the paper's listing.**
- `A[n][k]` is read inside `COL`, which keeps `PROD`·`COL` perfect. The paper reads it once because it also extracts memory [1, Sec. 6.2].
- The buffer restarts from `C` when `k == 0`, as in the paper, so no reset loop is needed [1, Sec. 2.4].
- `acc` is bound to `ram_2p`: each trip does one read and one write of it.

**Why bit-exact.** Each `C[n][m]` starts from `C[n][m]` and adds the products for $k = 0, 1, \dots$ in the same order in both kernels. Only the timing interleaves. Each column has its own buffer element, so sums never mix. The naive loop is therefore the testbench reference.

**Context.** The paper's 40× for this step also includes off-chip memory effects [1, Sec. 6.2]. Here all arrays are on-chip `ap_memory`.

---

## 2. The blocker

**`naive/pipe`:** the carried dependency on `acc` (distance 1, through `fadd`). Under the II = 1 target the tool swaps the 10-cycle `fulldsp` `fadd` of `seq` for the 7-cycle `fabric` core and settles at II = 7, as in S1.2 `accf/pipe`.

**Not the multiply.** `fmul` reads fresh `A` and `B` values in every trip, so it adds depth, not II.

**What must not block `trans/pipe`:**
- **Input ports:** `A`, `B` and `C` are each read at most once per trip.
- **`acc` ports:** one read and one write per trip, hence `ram_2p`.
- **The distance on `acc`:** the tool must prove that no trip reads an element before an earlier trip's write to it has landed. On 2023.2.2 it did, with no directive. If it does not, `pipe_dist` states distance 32.

**Symbols.** $D_{\min}$: fast `fadd` latency (7). $D_{\text{seq}}$: relaxed `fadd` latency (10). $D_T$: the `fadd` latency the tool picks in `trans/pipe`.

---

## 3. Predict

Do each stage before opening the matching reports. The results of the 2023.2.2 run are in the collapsed blocks.

### Stage A — shape (before any run)

| row          | II = 1? | HLS 200-871? | DSP vs `naive/pipe` | FF vs `naive/pipe` | `acc` memory |
|--------------|---------|--------------|---------------------|--------------------|--------------|
| `naive/seq`  |         |              |                     |                    |              |
| `naive/pipe` |         |              | —                   | —                  |              |
| `trans/seq`  |         |              |                     |                    |              |
| `trans/pipe` |         |              |                     |                    |              |

Also predict: is `trans/seq` faster, slower or the same as `naive/seq`? Does `naive/pipe` flatten?

<details><summary>Measured</summary>

| row          | II = 1? | HLS 200-871?     | DSP | FF   | `acc` memory              |
|--------------|---------|------------------|-----|------|---------------------------|
| `naive/seq`  | —       | no (2.416 ns)    | 5   | 775  | —                         |
| `naive/pipe` | no, 7   | yes (2.747 ns)   | 3   | 1002 | —                         |
| `trans/seq`  | —       | no (2.416 ns)    | 5   | 875  | 1 BRAM_18K, 32 × 32       |
| `trans/pipe` | yes     | yes (2.781 ns)   | 5   | 1095 | 1 BRAM_18K, 32 × 32       |

- **DSP is not constant.** `naive/pipe` uses the fabric `fadd` (0 DSP). `trans/pipe` keeps the 10-cycle `fulldsp` core (2 DSP), because distance 32 leaves room for it.
- **HLS 200-871 in both pipelines comes from the flattened loop counter** (compare → select → add → select), not from the `fadd`.
- **`trans/seq` is 5.4% slower than `naive/seq`.** Its `COL` iteration takes 21 cycles against 20 for `PROD` in `naive/seq`, and it adds the `WRITE` loop. Transposition by itself buys nothing.
- **`naive/pipe` flattens completely** (section 1).

</details>

### Stage B — to the cycle (after pass 1)

**Pass 1:** `naive_proj` only, no cosim.

```bash
ONLY=naive_proj DO_COSIM=0 vitis_hls -f run_hls.tcl 2>&1 | tee run.log
PROJ=naive_proj TOP=gemm_naive OUT=lat_naive.md bash ../../../common/collect_latency.sh
```

**Read:**

| symbol | meaning | where | measured |
|--------|---------|-------|----------|
| $D_{\text{seq}}$ | `fadd` latency, `seq` | `Bind Op Report`, `naive_proj/seq/syn/report/csynth.rpt` | 10 (`fulldsp`, 2 DSP) |
| $D_{\min}$ | `fadd` latency, `pipe` | same, `naive_proj/pipe` | 7 (`fabric`) |
| $D_{\text{mul}}$ | `fmul` latency | same | 6 (`maxdsp`, 3 DSP) |
| $L_s$ | `PROD` iteration latency, `seq` | loop table | 20 $= D_{\text{mul}} + D_{\text{seq}} + 4$ |
| $I_n$ | II of `ROW_COL_PROD` | loop table | 7 |
| $L_p$ | depth, `pipe` | $C - I_n(32\,768 - 1)$ | 18 |
| $o_c$ | `COL` iteration latency − `PROD` C, `seq` | loop table | 3 |
| $o_r$ | `ROW` iteration latency − `COL` C, `seq` | loop table | 2 |

**$L_p$ by stages** (`naive_proj/pipe/syn/verilog/gemm_naive.v`; with II = 7, stage $t$ is FSM state $t \bmod 7$ in `ap_enable_reg_pp0_iter`$\lfloor t/7 \rfloor$):

| $t$ | what happens | signal | advance |
|-----|--------------|--------|---------|
| 0  | flattened counters give `n`, `m`, `k` | `icmp_ln7_reg_462`, `or_ln9_reg_486` | — |
| 1  | `A`, `B` address out | `A_ce0`, `B_ce0` | +1 |
| 2  | `A`, `B` data captured | `A_load_reg_515`, `B_load_reg_520` | +1 |
| 3  | `fmul` starts | `fmul din0 = A_load_reg_515` | +1 |
| 9  | product captured (`C[n][m]` read in parallel at 8–9) | `mul_reg_545`, `C_load_reg_540` | $+D_{\text{mul}}$ |
| 10 | `fadd` starts; mux picks `C` ($k = 0$) or the previous sum | `ap_sig_allocacmp_acc_1_load` | +1 |
| 17 | sum stored in `acc` and in the `C` write register | `acc_1_fu_82`, `bitcast_ln15_reg_555` | $+D_{\min}$ |
| 18 | `C[n][m]` written, only when $k = K-1$ | `C_we0` | +1 |

$$L_p = D_{\text{mul}} + D_{\min} + 5 = 18$$

The sum of trip $i$ is ready at its stage 17. Trip $i+1$ starts its add at its own stage 10, which is 17 in trip $i$'s time. So II = 7 = $D_{\min}$.

**Models for the naive rows** (both exact):

$$T_{\text{naive/seq}} = N\left[M\left(K L_s + o_c\right) + o_r\right] + 1 = 658\,497$$

$$T_{\text{naive/pipe}} = L_p + D_{\min}(NMK - 1) + 2 = 229\,389$$

**Now predict the transposed rows.** Assume the same stage structure, $L_t = D_{\text{mul}} + D_T + 5$ with $D_T \in [7, 10]$. The pipeline is a submodule (+2 cycles per call). $w$ is the `WRITE` iteration latency, $o_p$ is the `PROD` overhead in `seq`, and $o_r'$ is the `ROW` overhead:

$$T_{\text{trans/pipe}} \approx N\left[(L_t + KM - 1 + 2) + M w + o_r'\right] + 1$$

$$T_{\text{trans/seq}} \approx N\left[K\left(M L_s' + o_p\right) + M w + o_r'\right] + 1$$

For large sizes, $T_{\text{naive/pipe}} / T_{\text{trans/pipe}} \to D_{\min} \cdot K/(K + w)$.

| row          | $I$ | depth | trips per run | runs per call | loop C per run | $T$ | vs own `seq` | vs `naive/pipe` |
|--------------|-----|-------|---------------|---------------|----------------|-----|--------------|-----------------|
| `naive/seq`  | —   | $L_s = 20$ | 32 | 1024 | 640     | 658 497 | 1.00 | — |
| `naive/pipe` | 7   | $L_p = 18$ | 32 768 | 1  | 229 387 | 229 389 | 2.87 | 1.00 |
| `trans/seq`  | —   |       |               |               |                |     | 1.00         | — |
| `trans/pipe` |     |       |               |               |                |     |              |   |

<details><summary>Measured (pass 2)</summary>

$D_T = 10$, $L_t = 21$, $L_s' = 21$, $w = 3$, $o_p = 3$, $o_r' = 3$.

| row          | $I$ | depth      | trips per run | runs per call | loop C per run | $T$     | vs own `seq` | vs `naive/pipe` |
|--------------|-----|------------|---------------|---------------|----------------|---------|--------------|-----------------|
| `naive/seq`  | —   | $L_s = 20$ | 32 (`PROD`)   | 1024          | 640            | 658 497 | 1.00         | —               |
| `naive/pipe` | 7   | $L_p = 18$ | 32 768        | 1             | 229 387        | 229 389 | 2.87         | 1.00            |
| `trans/seq`  | —   | $L_s' = 21$| 32 (`COL`)    | 1024          | 672            | 694 369 | 1.00         | —               |
| `trans/pipe` | 1   | $L_t = 21$ | 1024          | 32            | 1044           | 36 641  | 18.95        | 6.26            |

$$T_{\text{trans/seq}} = 32\left[32(32 \cdot 21 + 3) + 32 \cdot 3 + 3\right] + 1 = 694\,369$$

$$T_{\text{trans/pipe}} = 32\left[(21 + 1023 + 2) + 32 \cdot 3 + 3\right] + 1 = 36\,641$$

**6.26, not 7:** $D_{\min} K/(K+w) = 7 \cdot 32/35 = 6.4$ is the ceiling set by the 3-cycle `WRITE` loop. Each row also pays 25 cycles around the pipeline ($L_t - 1 = 20$, submodule call 2, `ROW` overhead 3), while `naive/pipe` pays its depth once.

</details>

### Stage C — the log

For each pipelined solution, predict: the number of `II Violation` lines and what they name, whether HLS 200-871 appears, and which flattening messages appear.

<details><summary>Measured</summary>

| solution     | violations | Final II / Depth | HLS 200-871 | flattening |
|--------------|------------|------------------|-------------|------------|
| `naive/pipe` | 6 × HLS 200-880 on `acc`, `distance = 1` | 7 / 19 | yes | 2 × HLS 200-2061, 2 × XFORM 203-541 → `ROW_COL_PROD` |
| `trans/pipe` | 0 | 1 / 22 | yes | 1 × HLS 200-2061, XFORM 203-541 on `PROD` → `PROD_COL` |

- Violation lines $= I - 1$, as in S1.2.
- `trans/seq` and `trans/pipe` also print `BIND 205-102` ("the specified resource core for memory 'acc' will be ignored if a simpler one can be used"). `acc` is built as `gemm_trans_acc_RAM_2P_AUTO_1R1W`.

</details>

**If `trans/pipe` misses on another version:**
1. **No flattening** (`COL` of 32 trips inside `PROD`): II is still 1, but you get extra 5.5a. Check that `COL` is the only statement in `PROD`.
2. **II > 1 with violations on `acc`:** the tool did not prove the distance. Run `dist_proj`.
3. **II = 2 with a port or resource reason on `acc`:** `acc` is on a one-port RAM. Check that the `bind_storage` line is echoed in the log.

---

## 4. Apply

### 4.1 Sources

```cpp
// src/gemm.h
#pragma once
#ifndef DATA_T
#error "DATA_T must be set with -DDATA_T=<type> on add_files"
#endif
typedef DATA_T data_t;

const int N = 32;   // rows of A and C
const int K = 32;   // columns of A = rows of B
const int M = 32;   // columns of B and C

// Both compute C = A*B + C.
void gemm_naive(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]);
void gemm_trans(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]);
```

```cpp
// src/gemm_naive.cpp
#include "gemm.h"

// Loop order n, m, k (paper Lst. 1a). One scalar accumulator per output element.
void gemm_naive(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]) {
ROW:
    for (int n = 0; n < N; n++) {
    COL:
        for (int m = 0; m < M; m++) {
            data_t acc = C[n][m];
        PROD:
            for (int k = 0; k < K; k++) {
                acc += A[n][k] * B[k][m];
            }
            C[n][m] = acc;
        }
    }
}
```

```cpp
// src/gemm_trans.cpp
#include "gemm.h"

// Loop order n, k, m (paper Lst. 1b). One accumulator per column, in a buffer.
// acc[m] is written in trip (k, m) and read again in trip (k+1, m), M trips later.
void gemm_trans(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]) {
    data_t acc[M];

ROW:
    for (int n = 0; n < N; n++) {
    PROD:
        for (int k = 0; k < K; k++) {
        COL:
            for (int m = 0; m < M; m++) {
                // k == 0 restarts the column sum from C, so acc needs no reset loop.
                data_t prev = (k == 0) ? C[n][m] : acc[m];
                acc[m] = prev + A[n][k] * B[k][m];
            }
        }
    WRITE:
        for (int m = 0; m < M; m++) {
            C[n][m] = acc[m];
        }
    }
}
```

- `PROD` holds nothing but `COL`, so `PROD`·`COL` is a perfect nest.
- `acc` is never read before it is written: on `k == 0` the mux drops the RAM output.

### 4.2 The script

```tcl
# exercises/s2_pipelining/01_full_transposition/run_hls.tcl
# Run:  vitis_hls -f run_hls.tcl 2>&1 | tee run.log
# Extras without editing this file:
#   ONLY="noflat_proj naive_int_proj" DO_COSIM=0 vitis_hls -f run_hls.tcl 2>&1 | tee run_extras.log

# ---- knobs ------------------------------------------------------------
# Main run: ONLY {naive_proj trans_proj}, DO_COSIM 1.
# Environment variables ONLY and DO_COSIM override these.
set ONLY     {naive_proj trans_proj}
set DO_COSIM 1
if {[info exists ::env(ONLY)]}     { set ONLY     $::env(ONLY) }
if {[info exists ::env(DO_COSIM)]} { set DO_COSIM $::env(DO_COSIM) }

# cosim = solutions that also run cosim_design when DO_COSIM is 1
set RUNS {
    naive_proj     {top gemm_naive tb tb_gemm dtype float sols {seq pipe}    cosim {pipe}}
    trans_proj     {top gemm_trans tb tb_gemm dtype float sols {seq pipe}    cosim {pipe}}
    noflat_proj    {top gemm_trans tb tb_gemm dtype float sols {pipe_noflat} cosim {}}
    naive_int_proj {top gemm_naive tb tb_gemm dtype int   sols {pipe}        cosim {}}
    dist_proj      {top gemm_trans tb tb_gemm dtype float sols {pipe_dist}   cosim {pipe_dist}}
}
# Extras live in their own projects, because open_project -reset wipes every solution.
#   noflat_proj:    extra 5.5a
#   naive_int_proj: extra 5.5b
#   dist_proj:      fallback only, if trans_proj/pipe misses II = 1 on acc (not needed on 2023.2.2)
# -----------------------------------------------------------------------

foreach {proj cfg} $RUNS {
    if {[llength $ONLY] > 0 && [lsearch -exact $ONLY $proj] < 0} { continue }

    set top   [dict get $cfg top]
    set tb    [dict get $cfg tb]
    set dtype [dict get $cfg dtype]
    set sols  [dict get $cfg sols]
    set cosim [dict get $cfg cosim]

    set cflags "-DDATA_T=$dtype"

    open_project -reset $proj
    set_top $top
    add_files     src/${top}.cpp -cflags $cflags
    add_files -tb src/${tb}.cpp  -cflags "$cflags -DUSE_$top"

    set first 1
    foreach sol $sols {
        open_solution -reset $sol -flow_target vivado
        source ../../../common/part.tcl

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

- The directive file is `directives_<top>_<solution>.tcl`. `naive/seq` has none and is skipped.
- Cosim covers only the two `pipe` solutions: about 6 minutes for `naive/pipe` and 5 for `trans/pipe` (20 calls each).
- `make clean` covers every `*_proj`.

### 4.3 The directives

```tcl
# directives_gemm_naive_pipe.tcl
set_directive_pipeline -II 1 "gemm_naive/PROD"
```

```tcl
# directives_gemm_trans_seq.tcl
# Same storage as pipe, so that seq -> pipe changes only the pipelining.
set_directive_bind_storage -type ram_2p "gemm_trans" acc
```

```tcl
# directives_gemm_trans_pipe.tcl
set_directive_bind_storage -type ram_2p "gemm_trans" acc
set_directive_pipeline -II 1 "gemm_trans/COL"
```

```tcl
# directives_gemm_trans_pipe_noflat.tcl   (extra 5.5a)
set_directive_bind_storage -type ram_2p "gemm_trans" acc
set_directive_pipeline -II 1 "gemm_trans/COL"
set_directive_loop_flatten -off "gemm_trans/COL"
```

```tcl
# directives_gemm_trans_pipe_dist.tcl   (fallback, only if pipe fails on acc)
set_directive_bind_storage -type ram_2p "gemm_trans" acc
set_directive_pipeline -II 1 "gemm_trans/COL"
set_directive_dependence -variable acc -type inter -dependent true -distance 32 "gemm_trans/COL"
```

Confirmed on 2023.2.2 [2]:
- `bind_storage` takes options, then location, then variable. `ram_2p` becomes a 1R1W RAM in BRAM (`-impl` left to the tool).
- `loop_flatten -off` on `COL` alone keeps `COL` inside `PROD`.

### 4.4 Testbench

- **Reference:** the naive loop order, compared with exact `!=`.
- **Unwritten check:** `C` is both input and output, so there is no POISON value. The check counts elements that should have changed but still equal their input.
- **One `N_RANDOM`:** `__RTL_SIMULATION__` is not defined for the testbench in cosim on this install (`notes/env.md`, Probe E).

```cpp
// src/tb_gemm.cpp
#include <cstdio>
#include <random>
#include "gemm.h"

#if defined(USE_gemm_naive)
#  define DUT  gemm_naive
#  define FORM "naive"
#elif defined(USE_gemm_trans)
#  define DUT  gemm_trans
#  define FORM "trans"
#else
#  error "tb_gemm: compile with -DUSE_gemm_naive or -DUSE_gemm_trans"
#endif

// One count for csim and cosim: __RTL_SIMULATION__ is not defined for the
// testbench during cosim on 2023.2.2 (S2.1.1 cosim ran all 20 calls).
static const int N_RANDOM = 16;

// True for float/double, false for integer types (1/2 truncates to 0).
static const bool IS_REAL = ((data_t)1 / 2) != 0;

static data_t A[N][K], B[K][M], C_in[N][M], C_dut[N][M], C_ref[N][M];

// Reference: loop order n, m, k, each sum starting from C (paper Lst. 1a).
static void ref() {
    for (int n = 0; n < N; n++) {
        for (int m = 0; m < M; m++) {
            data_t acc = C_in[n][m];
            for (int k = 0; k < K; k++) acc += A[n][k] * B[k][m];
            C_ref[n][m] = acc;
        }
    }
}

static int check(const char *name) {
    for (int n = 0; n < N; n++)
        for (int m = 0; m < M; m++) C_dut[n][m] = C_in[n][m];

    DUT(A, B, C_dut);
    ref();

    int bad = 0, unwritten = 0;
    for (int n = 0; n < N; n++) {
        for (int m = 0; m < M; m++) {
            if (C_dut[n][m] != C_ref[n][m]) {
                if (bad < 3)
                    std::printf("  %s C[%d][%d]: got %.9g expected %.9g\n",
                                name, n, m, (double)C_dut[n][m], (double)C_ref[n][m]);
                bad++;
            }
            if (C_ref[n][m] != C_in[n][m] && C_dut[n][m] == C_in[n][m]) unwritten++;
        }
    }
    if (bad)
        std::printf("FAIL %-8s %d of %d elements differ (%d still equal their input)\n",
                    name, bad, N * M, unwritten);
    return bad ? 1 : 0;
}

static data_t rnd(std::mt19937 &g) {
    int r = (int)(g() % 2001) - 1000;              // -1000 .. 1000
    return IS_REAL ? (data_t)r / (data_t)1000 : (data_t)r;
}

static void fill(data_t a, data_t b, data_t c) {
    for (int n = 0; n < N; n++) for (int k = 0; k < K; k++) A[n][k] = a;
    for (int k = 0; k < K; k++) for (int m = 0; m < M; m++) B[k][m] = b;
    for (int n = 0; n < N; n++) for (int m = 0; m < M; m++) C_in[n][m] = c;
}

int main() {
    std::printf("tb_gemm: form=%s N=%d K=%d M=%d N_RANDOM=%d\n", FORM, N, K, M, N_RANDOM);
    int errors = 0;

    // --- directed ------------------------------------------------------
    fill(0, 0, 0);
    errors += check("zeros");

    // A = identity, so C = B + C_in.
    fill(0, 0, 0);
    for (int n = 0; n < N; n++) A[n][n] = 1;
    for (int k = 0; k < K; k++) for (int m = 0; m < M; m++) B[k][m] = (data_t)(k - m);
    for (int n = 0; n < N; n++) for (int m = 0; m < M; m++) C_in[n][m] = (data_t)(n + m);
    errors += check("identity");

    // A[n][k] = n+1, B = 1, C_in = 0, so C[n][m] = K*(n+1).
    // A transposed kernel that does not restart acc at k == 0 carries the previous row in.
    fill(0, 1, 0);
    for (int n = 0; n < N; n++) for (int k = 0; k < K; k++) A[n][k] = (data_t)(n + 1);
    errors += check("rows");

    // C_in = 1e8, A = B = 1. In float32, 1e8 + 1 rounds back to 1e8, so the
    // naive order (C first, then the ones) gives 1e8. Adding C last would give
    // 1e8 + 32, which is exact. Catches a kernel that sums in a different order.
    fill(1, 1, (data_t)100000000);
    errors += check("order");

    // --- random (fixed seed: cosim replays the same stimulus) ---------
    std::mt19937 rng(42);
    for (int v = 0; v < N_RANDOM; v++) {
        for (int n = 0; n < N; n++) for (int k = 0; k < K; k++) A[n][k] = rnd(rng);
        for (int k = 0; k < K; k++) for (int m = 0; m < M; m++) B[k][m] = rnd(rng);
        for (int n = 0; n < N; n++) for (int m = 0; m < M; m++) C_in[n][m] = rnd(rng);
        errors += check("random");
    }

    std::printf("%s: %d error(s)\n", errors ? "FAILED" : "PASSED", errors);
    return errors ? 1 : 0;
}
```

| vector     | catches |
|------------|---------|
| `zeros`    | garbage where the answer is trivially 0 |
| `identity` | a swapped index (`A[k][n]`, `B[m][k]`); `B` is not symmetric |
| `rows`     | a missing restart of `acc` at `k == 0` |
| `order`    | a different summation order (float rounding makes it visible) |
| `random`   | everything else, plus a kernel that never writes `C` |

---

## 5. Measure

**Pass 2:** the main projects with cosim, then the extras.

```bash
vitis_hls -f run_hls.tcl 2>&1 | tee run.log
ONLY="noflat_proj naive_int_proj" DO_COSIM=0 vitis_hls -f run_hls.tcl 2>&1 | tee run_extras.log

C=../../../common
for P in naive trans; do
    PROJ=${P}_proj TOP=gemm_$P OUT=lat_$P.md bash $C/collect_latency.sh
    PROJ=${P}_proj TOP=gemm_$P OUT=res_$P.md bash $C/collect_resources.sh
done
PROJ=noflat_proj    TOP=gemm_trans OUT=lat_noflat.md    bash $C/collect_latency.sh
PROJ=naive_int_proj TOP=gemm_naive OUT=lat_naive_int.md bash $C/collect_latency.sh
```

`collect_latency.sh` now lists every loop level (`++` rows included).

### 5.1 csynth

**Timing**

| row          | II tgt | II ach | pipelined loop | trips  | iter. lat | loop C  | outer iter. lat              | Fn lat  | est. ns | 200-871 | $D_{\text{add}}$ | $D_{\text{mul}}$ |
|--------------|--------|--------|----------------|--------|-----------|---------|------------------------------|---------|---------|---------|------------------|------------------|
| `naive/seq`  | —      | —      | —              | —      | `PROD` 20 | 640     | `COL` 643, `ROW` 20 578      | 658 497 | 2.416   | no      | 10               | 6                |
| `naive/pipe` | 1      | 7      | `ROW_COL_PROD` | 32 768 | 19        | 229 387 | —                            | 229 389 | 2.747   | yes     | 7                | 6                |
| `trans/seq`  | —      | —      | —              | —      | `COL` 21  | 672     | `PROD` 675, `ROW` 21 699     | 694 369 | 2.416   | no      | 10               | 6                |
| `trans/pipe` | 1      | 1      | `PROD_COL`     | 1024   | 22        | 1 044   | module 1 046, `ROW` 1 145    | 36 641  | 2.781   | yes     | 10               | 6                |

`WRITE` in both `trans` rows: iteration latency 3, C = 96.

**Area** (Total row, plus the `acc` memory row)

| row          | LUT  | FF   | DSP | BRAM | `acc` words × bits | `acc` impl |
|--------------|------|------|-----|------|--------------------|------------|
| `naive/seq`  | 666  | 775  | 5   | 0    | —                  | —          |
| `naive/pipe` | 1037 | 1002 | 3   | 0    | —                  | —          |
| `trans/seq`  | 789  | 875  | 5   | 1    | 32 × 32            | BRAM (`RAM_2P_AUTO_1R1W`) |
| `trans/pipe` | 914  | 1095 | 5   | 1    | 32 × 32            | BRAM (`RAM_2P_AUTO_1R1W`) |

**Checks**

1. **Blocker:** `naive/pipe` II 7 = its $D_{\text{add}}$ 7.
2. **Fix:** `trans/pipe` II 1, with one pipelined loop of 1024 trips.
3. **Depths:** $L_p = 229\,387 - 7 \cdot 32\,767 = 18$ and $L_t = 1044 - 1023 = 21$. Both equal $D_{\text{mul}} + D_{\text{add}} + 5$. The iteration latencies read 19 and 22.
4. **Core choice:** $D_T = 10$ (`fulldsp`). The tool did not need the fast core, and HLS 200-871 stays because of the counter path.
5. **Row cost:** $1145 = 1046 + 32 \cdot 3 + 3$.
6. **Main ratio:** 6.26, under $D_{\min} = 7$.
7. **Transposition alone:** `trans/seq` is 35 872 cycles slower than `naive/seq`: one extra cycle per multiply-add (32 768), plus `WRITE` and the row overhead.
8. **DSP:** 5 / 3 / 5 / 5. The only difference is the `fadd` core in `naive/pipe`.

**The `acc` span in RTL** (`trans_proj/pipe/syn/verilog/gemm_trans_gemm_trans_Pipeline_PROD_COL.v`). `acc` is read at stage 8 (`acc_ce0`, `iter8`) and written at stage 21 (`acc_we1`, `iter21`). A trip therefore needs the value written at least 14 trips earlier: $\delta = D_T + 4 = 14 \le M = 32$. The slack is why the tool keeps the 10-cycle `fadd`.

### 5.2 Log diagnostics

```bash
grep -nE "Running: open_(project|solution)|II Violation|Pipelining result|WARNING: \[HLS 200-871\]|200-2061|[Ff]latten|BIND 205-102" run.log
```

The results are in Stage C.

### 5.3 Cosim

| row          | cosim min / avg / max     | Fn lat (5.1) | cosim − Fn lat | calls | tb     |
|--------------|---------------------------|--------------|----------------|-------|--------|
| `naive/pipe` | 229 387 / 229 387 / 229 388 | 229 389    | −2 / −1        | 20    | PASSED |
| `trans/pipe` | 36 577 / 36 577 / 36 577  | 36 641       | −64            | 20    | PASSED |

- **Both are bit-exact** against the naive reference.
- **`naive/pipe` has a 1-cycle spread:** call 1 takes 229 387 cycles, calls 2–20 take 229 388 (`sim/report/verilog/result.transaction.rpt`).
- **`trans/pipe` has no spread.** Its gap of −64 is −2 per pipeline run × 32 runs, the same size as the submodule's +2 in csynth (1046 against a loop C of 1044).

### 5.4 results.csv

Rows added to `notes/results.csv`:

```csv
s2.1.1,gemm_naive,seq,float,32,,,,20,658497,,666,775,5,0,414,?,unpipelined; II_achieved=PROD iter lat by substitution; fadd lat=10 (fulldsp); fmul lat=6; K=M=32
s2.1.1,gemm_naive,pipe,float,32,,,1,7,229389,229387,1037,1002,3,0,364,?,ROW*COL*PROD auto-flattened (32768 trips; 1 run); L=18; fadd lat=7 (fabric); fmul lat=6; 200-871=y; cosim max 229388; K=M=32
s2.1.1,gemm_trans,seq,float,32,,,,21,694369,,789,875,5,1,414,?,unpipelined; II_achieved=COL iter lat by substitution; acc ram_2p on BRAM (1R1W); K=M=32
s2.1.1,gemm_trans,pipe,float,32,,,1,1,36641,36577,914,1095,5,1,360,?,PROD*COL flattened (1024 trips; 32 runs); L=21; fadd lat=10 (fulldsp); acc BRAM; 200-871=y (counter path); 6.26x vs naive pipe; K=M=32
s2.1.1,gemm_trans,pipe_noflat,float,32,,,1,1,61537,,837,1052,5,1,408,?,extra 5.5a; flatten off; COL (32 trips) inside PROD (1024 runs); L=20; fadd lat=10 (fulldsp); 200-871=y; K=M=32
s2.1.1,gemm_naive,pipe,int,32,,,1,1,32775,,559,651,3,0,379,?,extra 5.5b; flattened 32768 trips; L=6; mul lat=1 (DSP); add lat=0; 200-871=y; K=M=32
```

### 5.5 Extras

**a. Transposition without flattening** (`noflat_proj/pipe_noflat`).

| | II | pipelined loop | depth | loop C | module | `PROD` iter. lat | `ROW` iter. lat | Fn lat | est. ns | LUT / FF / DSP / BRAM |
|---|---|---|---|---|---|---|---|---|---|---|
| measured | 1, 0 violations | `COL`, 32 trips, inside `PROD` | 20 | 51 | 53 | 57 | 1 923 | 61 537 | 2.451 (200-871) | 837 / 1052 / 5 / 1 |

- $T = 32\left[32 \cdot 57 + 96 + 3\right] + 1 = 61\,537$.
- **3.73×** faster than `naive/pipe`. Flattening adds another **1.68×** on top (36 641).
- One stage shallower than `trans/pipe` (20 against 21) and a shorter clock path (2.451 ns against 2.781 ns): the flattened counter costs a stage and sets the critical path.

**b. The integer control** (`naive_int_proj/pipe`).

| | II | pipelined loop | depth | loop C | Fn lat | `mul` / `add` latency | est. ns | LUT / FF / DSP |
|---|---|---|---|---|---|---|---|---|
| measured | 1, 0 violations | `ROW_COL_PROD`, 32 768 trips | 6 | 32 773 | 32 775 | 1 (DSP) / 0 (fabric) | 2.636 (200-871) | 559 / 651 / 3 |

The integer add has latency 0, so the carried dependency costs nothing and the naive order is already fine [1, Sec. 2.1.1]. It is 7.0× faster than float `naive/pipe` and 1.12× faster than float `trans/pipe`. This is why the accumulation lessons use float.

---

## 6. Questions

**Q1.** The testbench compares `gemm_trans` with the naive order using exact equality, while S2.1.3 had to rewrite its reference. Why is transposition exact? And why does Vitis not reorder the loops itself?

<details><summary>Answer</summary>

**Exact.** Each `C[n][m]` goes through the same steps in both kernels: start from `C[n][m]`, then add the products for $k = 0, 1, \dots, K-1$ in order. Transposition only interleaves the columns in time, and each column keeps its own buffer element. S2.1.3 regrouped terms of one sum across lanes, so its rounding changed.

**Legal.** The only dependency runs from $(n, m, k)$ to $(n, m, k+1)$, and it still points forward in the order `n, k, m`.

**Not automatic.** Vitis rewrites imperfect nests into perfect ones (HLS 200-2061) and flattens, merges, unrolls and pipelines loops [2]. It never swaps the order of a nest. The swap also turns a scalar into an $M$-element memory, which is a design trade-off. The paper leaves it to the designer or a polyhedral source-to-source tool [1, Sec. 2.1.1, Sec. 7].

</details>

**Q2.** The multiply takes $D_{\text{mul}} = 6$ cycles in the same pipeline as the add, yet it does not affect II. Why not? Where does its latency show up?

<details><summary>Answer</summary>

**Not II.** II is set by the path from `acc` back to `acc`, which is only the `fadd` (plus the RAM read and write in `trans`). The inputs of `fmul` come fresh from `A` and `B` in every trip, so `fmul` is feed-forward.

**In the depth,** which every pipeline run pays once:

| design       | runs per call | cycles around the pipeline per call | share of $T$ |
|--------------|---------------|-------------------------------------|--------------|
| `naive/pipe` | 1             | 13                                  | ≈ 0%         |
| `trans/pipe` | 32            | 32 × 22 = 704                       | 1.9%         |
| `pipe_noflat`| 1024          | 1024 × 25 = 25 600                  | 42%          |

One extra multiplier stage costs `naive/pipe` 1 cycle, `trans/pipe` 32 and `pipe_noflat` 1024.

</details>

**Q3.** What would happen with $M = 4$? And with $M = 4096$? (Not measured.)

<details><summary>Answer</summary>

**$M = 4$.** The buffer needs a span of $\delta = D_T + 4$ cycles between the read and the write of one element (5.1). Consecutive visits to that element are $I \cdot M$ cycles apart, so $I \ge \lceil \delta / M \rceil$. With the fast core, $\delta = 11$ and $I = 3$. With the 10-cycle core, $\delta = 14$ and $I = 4$. Expect II = 3 and a gain of about $7/3$ over `naive/pipe`. Full transposition reaches II = 1 only when $M \ge D_{\text{add}} + 4$ with this RAM schedule, and only when $M \ge D_{\text{add}}$ in the paper's register model [1, Sec. 2.1.1].

**$M = 4096$.** II stays 1, but `acc` holds 131 072 bits, several BRAMs, and it grows with the matrix. Tiled accumulation interleaving (S2.1.2) keeps the buffer at $T \ge \delta$ columns, independent of $M$ [1, Sec. 2.1.2].

</details>

**Q4.** In extra 5.5a, `COL` reaches II = 1 without flattening and without any violation. Why? What does flattening buy?

<details><summary>Answer</summary>

**Why II = 1.** Within one `COL` run (fixed $k$), every trip uses a different element, `acc[0]` to `acc[31]`. The dependency on `acc[m]` crosses `PROD` iterations, and those are separate pipeline runs: `COL` drains before the next $k$ starts. The tool never has to reason about distance.

**What it costs.** 1024 runs × 25 cycles ($L - 1 = 19$, submodule call 2, `PROD` overhead 4) = 25 600 cycles, or 42% of the 61 537.

**What flattening buys.** 32 runs instead of 1024: 61 537 → 36 641 cycles (1.68×). The price is one pipeline stage for the flattened counter (21 against 20), a slower clock path (2.781 ns against 2.451 ns), and a distance the tool must now prove across trips. 2023.2.2 proved it without `pipe_dist`. Pipelined loop flattening is S2.5 [1, Sec. 2.5].

</details>

---

## 7. Conclusions

### What we set out to show

The claim from [1, Sec. 2.1.1]: a carried dependency through a slow operator can be removed without changing the result by reordering the loop nest, so that $M$ independent sums take turns. Expected outcome:
- II drops from $D_{\text{add}}$ to 1;
- speedup close to $D_{\text{add}}$;
- output bit-identical to the naive order;
- the cost is an $M$-element buffer.

### How we tested it

- **One kernel, two loop orders.** Same part, clock and arithmetic. The directives differ only in which loop is pipelined (plus the `acc` storage binding).
- **Four solutions.** The `seq` pair separates the effect of the reorder from the effect of pipelining. The `pipe` pair is the comparison.
- **Cycle-exact models.** Each latency is predicted from operator latencies, depth and loop overheads, then checked against csynth. The depths are confirmed stage by stage in the generated RTL.
- **Correctness.** The naive order is the reference, compared with exact `!=`, in csim and in cosim (20 calls each). The directed vectors target restart, index and summation-order bugs.
- **Two controls.** `pipe_noflat` isolates what flattening contributes. The `int` run removes the slow add, and with it the blocker.

### What the data shows

1. **The claim holds.** II 7 → 1 and latency 229 389 → 36 641 cycles (**6.26×**), bit-exact in cosim. No dependence directive was needed: the tool proved the buffer distance itself.
2. **The reorder alone buys nothing.** `trans/seq` is 5.4% *slower* than `naive/seq` (694 369 against 658 497). Transposition only enables pipelining; the gain appears only in the pipelined pair.
3. **The gain is the II ratio, minus the work outside the pipeline.** The `WRITE` loop caps it at $7 \cdot 32/35 = 6.4$, and the per-row overhead brings it to 6.26. The paper's second effect (fewer pipeline runs) does not apply on 2023.2.2, because the tool already flattens the naive nest into one run (HLS 200-2061).
4. **The cost is memory, not arithmetic.** Against `naive/pipe`: +1 BRAM_18K, LUT −12%, FF +9%, DSP 5 against 3. The extra DSPs are a side effect: with a distance of 32 there is no pressure on the add, so the tool goes back to the 10-cycle `fulldsp` core.
5. **"$M \ge D_{\text{add}}$" is the register model; the RAM needs more.** With `acc` in a RAM, the read-to-write span is $D_T + 4 = 14$ trips. So $M = 32$ has about 2.3× slack, and the II = 1 condition here is $M \ge 14$, not $M \ge 10$.
6. **Flattening is part of the result.** Without it the gain drops to 3.73×, and 42% of the latency goes into entering and leaving 1024 short pipeline runs. Flattening costs one pipeline stage and sets the critical path (the merged loop counter). That counter, not the `fadd`, is what triggers HLS 200-871 in both pipelined designs.
7. **The blocker is specific to slow carried operators.** With `int`, the naive order already reaches II = 1 (32 775 cycles) and beats float `trans/pipe`. Transposition is worth doing only when the operator on the carried path has latency > 0.

### Limits of this evidence

- **One design point:** $N = K = M = 32$, one part, one clock (3.33 ns), one tool version (2023.2.2). The $M = 4$ and $M = 4096$ answers in Q3 are derived, not measured.
- **Timing is estimated only.** Both pipelined designs exceed the effective 2.431 ns budget in the estimate. `fmax_impl` was not measured, so timing closure is not shown.
- **All arrays are on-chip `ap_memory`.** The paper's larger gain also includes memory extraction and off-chip access [1, Sec. 6.2].
- **Correctness is shown for the tested vectors** (4 directed + 16 random, fixed seed), not proven in general. The bit-exact argument in section 1 is what generalises.

### Rules of thumb

- **Diagnose:** if a loop's II equals the latency of an operator on a carried path, look for an enclosing loop to swap with, so that the carried state becomes indexed by the inner loop counter.
- **Keep it flattenable:** put conditionals inside the inner loop instead of statements between loops (`k == 0 ? C : acc`).
- **Size the buffer:** use the read-to-write span of its storage (about $D_{\text{add}} + 4$ for a RAM), not just $D_{\text{add}}$. If that makes $M$ too large, tile (S2.1.2).
- **Check both pairs:** `seq` against `seq` should show no gain, `pipe` against `pipe` should show about $D_{\text{add}}$. Also check the Bind Op Report, because removing II pressure can change the operator cores and the DSP count.

---

## References

[1] J. de Fine Licht, M. Besta, S. Meierhans, T. Hoefler, "Transformations of High-Level Synthesis Codes for High-Performance Computing," *IEEE Trans. Parallel and Distributed Systems*, 32(5), 2021. arXiv:1805.08288.
- Sec. 1.2: the pipeline model, $C = L + I(N-1)$ (Eq. 1).
- Sec. 2: the two classes that block pipelining (loop-carried dependencies, interface contention).
- Sec. 2.1.1 and Lst. 1a/1b: full transposition of matrix multiplication; the buffer of depth $M$; $M \ge L_+$; the implicit reset of the buffer.
- Sec. 2.1.2 and Lst. 1c: tiled accumulation interleaving (S2.1.2).
- Sec. 2.4 and Sec. 2.5: pipelined loop fusion and loop flattening. Note: the section numbers in the transformation table of the arXiv PDF (v6) differ from the section headings for Sec. 2.5 onwards; this README follows the headings.
- Sec. 6.2: the matrix-multiplication case study (transposition, memory extraction and coalescing as the first stage).
- Sec. 7: related work, including polyhedral and source-to-source approaches.

[2] AMD, *Vitis High-Level Synthesis User Guide* (UG1399), version matching 2023.2 (https://docs.amd.com/r/2023.2-English/ug1399-vitis-hls). Reference pages for:
- `set_directive_pipeline`;
- `set_directive_bind_storage` (`-type`, `-impl`);
- `set_directive_loop_flatten` (`-off`);
- `set_directive_dependence` (`-variable`, `-type inter`, `-dependent`, `-distance`);
- the loop optimization directives in general (pipeline, flatten, merge, unroll, tripcount).
