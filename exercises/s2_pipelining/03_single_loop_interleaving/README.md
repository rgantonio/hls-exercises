# S2.1.3 — Single-loop accumulation interleaving

S1.2 left `accumulate` in float at II = 7. The running sum `acc` is read and written in every iteration and the float add takes 7 cycles, so each iteration waits for the previous one's add.

This exercise removes that wait without touching the adder or the clock. It keeps $K$ running sums ("lanes") instead of one, so each sum is touched only once every $K$ iterations. The cost: lane registers, a second loop that combines the lanes, and a result that is no longer bit-identical to the sequential sum.

Kernel: `accumulate`, float, $N = 1024$, swept over $K$. Tool: Vitis HLS 2023.2.2.

**Result.** At $K = 7$: II 7 → 1, `ACC` loop 7170 → 1032 cycles (6.95×), function 7172 → 1128 cycles (6.36×), cosim pass. Cost: +1134 FF. $K = 2$ does not help at all, and $K > 7$ buys nothing.

---

## 0. Setup

**Prerequisites:** S1.2 run; `common/part.tcl` (`xcku5p-ffvb676-2-e`, 3.33 ns, `config_compile -pipeline_loops 0`); `common/collect_latency.sh`, `common/collect_resources.sh`.

**Files**

```
s2_pipelining/03_single_loop_interleaving/
  README.md  run_hls.tcl
  src/accumulate.h  src/accumulate.cpp  src/tb_accumulate.cpp     (S1.2 kernel; header and N_RANDOM fixed)
  src/acc_il.h      src/acc_shift.cpp   src/acc_index.cpp   src/tb_acc_il.cpp
  directives_accumulate_pipe.tcl
  directives_acc_shift_pipe.tcl
  directives_acc_index_pipe.tcl
  directives_acc_index_pipe_dist.tcl
  directives_acc_index_pipe_lie.tcl      (extra 5.5a)
  directives_acc_shift_pipe_comb.tcl     (extra 5.5b)
```

**Projects.** $K$ is a compile-time constant passed with `-cflags` on `add_files`, which is project-level, so each $K$ needs its own project. Extras also get their own projects, because `open_project -reset` wipes every solution.

| project          | top          | $K$ | solution    | what it is                                                  |
|------------------|--------------|-----|-------------|-------------------------------------------------------------|
| `base_proj`      | `accumulate` | —   | `seq`       | S1.2 baseline                                               |
| `base_proj`      | `accumulate` | —   | `pipe`      | S1.2 dependency blocker (II = 7)                            |
| `shift_k1_proj`  | `acc_shift`  | 1   | `pipe`      | one lane: must behave like `base/pipe`                      |
| `shift_k2_proj`  | `acc_shift`  | 2   | `pipe`      | sweep point                                                 |
| `shift_k4_proj`  | `acc_shift`  | 4   | `pipe`      | sweep point                                                 |
| `shift_k7_proj`  | `acc_shift`  | 7   | `pipe`      | $K$ = fast `fadd` latency                                   |
| `shift_k10_proj` | `acc_shift`  | 10  | `pipe`      | $K$ = relaxed `fadd` latency                                |
| `index_k10_proj` | `acc_index`  | 10  | `pipe`      | index form, no help given to the tool                       |
| `index_k10_proj` | `acc_index`  | 10  | `pipe_dist` | index form + dependence directive, distance 10 (true)       |
| `index_k4_proj`  | `acc_index`  | 4   | `pipe_lie`  | extra 5.5a: dependence directive, distance 10 (false)       |
| `comb_k10_proj`  | `acc_shift`  | 10  | `pipe_comb` | extra 5.5b: `shift_k10/pipe` with `COMBINE` pipelined too   |

**Speedup baseline.** An interleaved kernel has no meaningful `seq`, so every speedup is against `base/seq` and `base/pipe`.

**Conventions** (from S1.2):
- `accumulate.h` uses `#error` instead of a silent `DATA_T` fallback.
- The `Bind Op Report` is only in the design-wide `syn/report/csynth.rpt`.
- $D_{\text{add}}$ is read per solution.
- $L_p = C - I \cdot 1023$. The `Iteration Latency` column reads $L_p + 1$.
- II is recorded with the clock estimate and whether HLS 200-871 was printed.

---

## 1. The transformation

**Source:** de Fine Licht et al. [1, Sec. 2.1.3, Lst. 2].

### The problem

```cpp
acc = 0;
for (i = 0; i < 1024; i++) acc = acc + x[i];
```

Iteration $i+1$ needs `acc` with `x[i]` already in it. That value leaves the 7-cycle `fadd` 7 cycles after iteration $i$ started. S1.2's model: an iteration that reads a value written $d$ iterations earlier, produced by a $\delta$-cycle path, needs $I \cdot d \ge \delta$. Here $d = 1$ and $\delta = 7$, so $I = 7$, and the adder pipeline holds one addition at a time.

The obvious fixes are not available:
- **A faster adder:** 7 cycles is already the fastest `fadd` the tool uses at this clock.
- **A slower clock:** it would slow down everything else.
- **Letting the tool reorder:** float addition is not associative, so the tool will not regroup terms (S1.2 Q1).

$\delta$ is fixed, so the only lever is $d$.

### The fix

Keep $K$ lanes. Iteration $i$ adds `x[i]` to lane $i \bmod K$. Each lane is touched once every $K$ iterations, so $d = K$:

$$I = \max\left(1,\ \left\lceil \frac{D_{\text{add}}}{K} \right\rceil\right)$$

After the loop, `COMBINE` adds the $K$ lanes together. The paper calls these the two stages: stage one handles $N$ inputs at II = 1, stage two only $K$ additions [1, Sec. 2.1.3].

There is still **one adder** in `ACC`. At II = 1 its 7 stages each hold a different addition; the lanes make sure each finished result goes to a register that the next entering iteration can safely read. Appendix A walks through this cycle by cycle.

### Two ways to write it

| | index form (`acc_index`, paper Lst. 2) | shift form (`acc_shift`) |
|---|---|---|
| **code** | `lane[c] += x[i]` with a wrap counter `c` | `s = lane[K-1] + x[i]`, shift the lanes up, `lane[0] = s` |
| **how `lane` is stored** | an array: $K$-entry LUTRAM, one read + one write per iteration | partitioned into $K$ registers (every lane moves every iteration) |
| **what the tool must see** | that `lane[c]` repeats every $K$ iterations. It does not track `c`, so you state it with `-distance` | $K$ register hops between write and read: visible in the code |
| **final lane order** | class $j$ in lane $j$ | rotated: lane $j$ holds class $(N-1-j) \bmod K$ |

- A counter replaces the paper's `i % 16`, because `%` builds a divider for $K = 7$ or 10.
- An explicit `INIT` loop replaces the paper's `(i < 16) ? 0 : t[i % 16]` guard.

**The cost of the transformation.**
- Lane state that grows with $K$.
- $K$ more additions in `COMBINE`.
- **Different result bits:** grouping terms into lanes changes float rounding. That is why the tool never does this on its own; it is the designer's decision.

---

## 2. The blocker

**`base/pipe`** (re-measured, same as S1.2): 6 × HLS 200-880 on `acc`, `distance = 1`; `Final II = 7, Depth = 10`. Under the II = 1 target the tool swaps the 10-cycle `fulldsp` `fadd` of `seq` for the 7-cycle `fabric` core. Call these $D_{\min} = 7$ and $D_{\text{seq}} = 10$.

**What must not become a new blocker.**
- **Ports on `x`:** one read per iteration.
- **Shift form: lanes must be registers.** Every lane moves every iteration ($A \approx K$); as a RAM that would be a port blocker.
- **Index form: `lane` must stay an array.** A 1R1W RAM serves one read and one write at II = 1, and the dependence directive is attached to the variable `lane`. If `lane` is partitioned, the directive matches nothing, silently, and II stays 7. Partitioning happens in two ways:
  - explicitly, with `set_directive_array_partition`;
  - **automatically for small arrays**: at $K = 4$ the tool prints `XFORM 203-102 Automatically partitioning small array 'lane'`. `set_directive_array_partition -off "acc_index" lane` prevents it (5.5a).

---

## 3. Predict

Do each stage before opening the matching reports. The results of the 2023.2.2 run are in the collapsed blocks.

### Stage A — shape (before any run)

| row                   | II = 1? | HLS 200-871? | FF vs `base/pipe` | DSP |
|-----------------------|---------|--------------|-------------------|-----|
| `shift_k1/pipe`       |         |              |                   |     |
| `shift_k2/pipe`       |         |              |                   |     |
| `shift_k4/pipe`       |         |              |                   |     |
| `shift_k7/pipe`       |         |              |                   |     |
| `shift_k10/pipe`      |         |              |                   |     |
| `index_k10/pipe`      |         |              |                   |     |
| `index_k10/pipe_dist` |         |              |                   |     |

<details><summary>Measured</summary>

`base/pipe`: FF 460, DSP 0.

| row                   | II = 1?  | HLS 200-871?     | FF vs `base/pipe` | DSP |
|-----------------------|----------|------------------|-------------------|-----|
| `shift_k1/pipe`       | no, 7    | yes (2.719 ns)   | +383              | 2   |
| `shift_k2/pipe`       | no, **7** | **no** (2.292 ns) | +517             | 2   |
| `shift_k4/pipe`       | no, 2    | yes (2.719 ns)   | +742              | 2   |
| `shift_k7/pipe`       | yes      | yes (2.719 ns)   | +1134             | 2   |
| `shift_k10/pipe`      | yes      | yes (2.719 ns)   | +1519             | 2   |
| `index_k10/pipe`      | no, 7    | yes (2.969 ns)   | +660              | 2   |
| `index_k10/pipe_dist` | yes      | yes (2.969 ns)   | +631              | 2   |

- **DSP is 2, not 4.** The `ACC` `fadd` is the fabric core (0 DSP) in every pipelined solution. The 2 DSPs belong to the unpipelined `COMBINE` `fadd` (`fulldsp`, 10 cycles).
- **`shift_k2` stays at II = 7**, not 4 (Stage C).
- **`shift_k10` does not take the relaxed core.** $D_{\text{ACC}} = 7$ and HLS 200-871 remain, although $10 \le 1 \cdot 10$ would allow it.
- **The index form trades FF for timing:** at $K = 10$ it uses 888 fewer FF than the shift form, but the RAM read in front of the `fadd` costs 0.25 ns.

</details>

### Stage B — to the cycle (after pass 1)

**Pass 1:** `base_proj` only, no cosim.

```bash
ONLY=base_proj DO_COSIM=0 vitis_hls -f run_hls.tcl 2>&1 | tee run_pass1.log
PROJ=base_proj TOP=accumulate OUT=lat_base.md bash ../../../common/collect_latency.sh
```

| symbol | where | measured |
|--------|-------|----------|
| $D_{\text{seq}}$ | `fadd` row, `Bind Op Report`, `base_proj/seq/syn/report/csynth.rpt` | 10 (`fulldsp`) |
| $D_{\min}$ | same, `base_proj/pipe` | 7 (`fabric`) |
| $L_p$ | $7170 - 7 \cdot 1023$ | 9 $= D_{\min} + 2$ (read, add, store) |

**Model for each interleaved row.** Once $I$ is fixed, any core with $D \le I \cdot K$ fits, so predict the core as a range:

$$I = \max\left(1, \left\lceil \frac{D_{\min}}{K} \right\rceil\right), \quad D_{\text{ACC}} \in \left[D_{\min}, \min(D_{\text{seq}}, I K)\right], \quad L_p = D_{\text{ACC}} + 2, \quad C_{\text{ACC}} = L_p + 1023\, I$$

**Function latency.** The pipelined `ACC` is a submodule (+2 cycles). `COMBINE` is unpipelined, with one register or RAM read plus a relaxed `fadd` per trip. Predict:

$$T = C_{\text{INIT}} + (C_{\text{ACC}} + 2) + C_{\text{COMBINE}} + 3$$

| row                   | $I$ | $D_{\text{ACC}}$ | $L_p$ | $C_{\text{ACC}}$ | vs `base/seq` | vs `base/pipe` | $T$ |
|-----------------------|-----|------------------|-------|------------------|---------------|----------------|-----|
| `base/pipe`           | 7   | 7                | 9     | 7170             | 2.00          | 1.00           | 7172 |
| `shift_k1/pipe`       |     |                  |       |                  |               |                |     |
| `shift_k2/pipe`       |     |                  |       |                  |               |                |     |
| `shift_k4/pipe`       |     |                  |       |                  |               |                |     |
| `shift_k7/pipe`       |     |                  |       |                  |               |                |     |
| `shift_k10/pipe`      |     |                  |       |                  |               |                |     |
| `index_k10/pipe`      |     |                  |       |                  |               |                |     |
| `index_k10/pipe_dist` |     |                  |       |                  |               |                |     |

<details><summary>Measured (pass 2)</summary>

| row                   | $I$ (model) | $I$ | $D_{\text{ACC}}$ | $L_p$ | $C_{\text{ACC}}$ | vs `base/seq` | vs `base/pipe` | `INIT` C | `COMBINE` C | $T$ |
|-----------------------|-------------|-----|------------------|-------|------------------|---------------|----------------|----------|-------------|-----|
| `base/pipe`           | 7           | 7   | 7                | 9     | 7170             | 2.00          | 1.00           | —        | —           | 7172 |
| `shift_k1/pipe`       | 7           | 7   | 7                | 9     | 7170             | 2.00          | 1.00           | —        | — (one `fadd`, 10) | 7184 |
| `shift_k2/pipe`       | 4           | **7** | 7              | 9     | 7170             | 2.00          | 1.00           | —        | 26          | 7201 |
| `shift_k4/pipe`       | 2           | 2   | 7                | 9     | 2055             | 6.98          | 3.49           | —        | 52          | 2112 |
| `shift_k7/pipe`       | 1           | 1   | 7                | 9     | 1032             | 13.9          | 6.95           | —        | 91          | 1128 |
| `shift_k10/pipe`      | 1           | 1   | 7                | 9     | 1032             | 13.9          | 6.95           | —        | 130         | 1167 |
| `index_k10/pipe`      | 7           | 7   | 7                | 9     | 7170             | 2.00          | 1.00           | 10       | 140         | 7325 |
| `index_k10/pipe_dist` | 1           | 1   | 7                | 9     | 1032             | 13.9          | 6.95           | 10       | 140         | 1187 |

- **Every $C_{\text{ACC}}$ matches $L_p + 1023\, I$ with $L_p = 9$**, including `shift_k2` once its real II (7) is used.
- **`COMBINE` per trip:** 13 cycles on the shift form (register read + 10-cycle `fadd` + 2), 14 on the index form (one more for the RAM read).
- **`INIT`:** a real loop only in the index form (1 cycle per trip). In the shift form the zero initialisation of the lane registers is absorbed.
- **$T$ matches the model on every row.**
- **Function-level speedup over `base/pipe`:** 6.36× at $K = 7$, 6.15× at $K = 10$, 6.04× for `index_k10/pipe_dist`. `COMBINE` eats the difference.

</details>

### Stage C — the log

For each solution, predict the number of `II Violation` lines, the reason text, and whether HLS 200-871 appears.

<details><summary>Measured</summary>

| solution | violation lines | reason | `Final II / Depth` | 200-871 |
|----------|-----------------|--------|--------------------|---------|
| `base/pipe` | 6 × HLS 200-880 | carried dependence on `acc`, `distance = 1` | 7 / 10 | yes |
| `shift_k1/pipe` | 6 × HLS 200-880 | on `empty` (the renamed `lane[0]`), `distance = 1` | 7 / 10 | yes |
| `shift_k2/pipe` | 6 × **HLS 200-881** | "unable to enforce a carried constraint between 'fadd' operation ('lane') and 'fadd' operation ('lane')" | 7 / 10 | **no** |
| `shift_k4/pipe` | 1 × HLS 200-880 | on `empty`, `distance = 1` (a single register hop, not the chain) | 2 / 10 | yes |
| `shift_k7/pipe`, `shift_k10/pipe` | 0 | — | 1 / 10 | yes |
| `index_k10/pipe` | 6 × HLS 200-880 | 4 on `add` with `distance = 2, offset = 1`, then 2 on `reuse_reg` (the read-after-write bypass) with `distance = 1` | 7 / **11** | yes |
| `index_k10/pipe_dist` | 0 | — | 1 / 10 | yes |

- **Violation lines $= I - 1$** on every row.
- **`shift_k2` is outside the model.** The tool does not name a variable dependence. It reports a carried constraint between two `fadd` operations and gives up at II = 7 instead of 4. The dependency model does not explain it; record it as a tool behavior.
- **`index_k10/pipe` log `Depth` is 11,** but $L_p$ solved from C is 9 (iteration latency 10). Trust C.
- **HLS 200-871 on every II = 1 design:** the fast `fadd` is kept even where $K = 10$ would allow the relaxed one.

**Did the dependence directive take effect?**

| indicator | applied | dropped |
|---|---|---|
| `Running: set_directive_dependence ...` | present | present too: proves nothing |
| HLS 200-880 variable names | no lines | `lane[2]` or `mux_case_0` (lane was partitioned) |
| `XFORM 203-10[12]` partition lines for `lane` | none | present |
| `Pipelining result` | `Final II = 1` | `Final II = 7` |
| `* Memory:` in `acc_index_csynth.rpt` | `lane_U` / `lane_RAM_AUTO_1R1W` | `N/A` |

</details>

---

## 4. Apply

### 4.1 Sources

```cpp
// src/accumulate.h   (S1.2 header with the silent fallback replaced)
#pragma once
#ifndef DATA_T
#error "DATA_T must be set with -DDATA_T=<type> on add_files"
#endif
typedef DATA_T data_t;

const int N = 1024;

void accumulate(const data_t x[N], data_t *sum);
```

`src/accumulate.cpp` is the S1.2 file. `src/tb_accumulate.cpp` is the S1.2 file with a single `N_RANDOM = 64` (4.4).

```cpp
// src/acc_il.h
#pragma once
#ifndef K
#error "K must be set with -DK=<lanes> on add_files"
#endif
#if K < 1
#error "K must be at least 1"
#endif

typedef float data_t;   // interleaving only matters when the add is slow

const int N = 1024;

void acc_shift(const data_t x[N], data_t *sum);
void acc_index(const data_t x[N], data_t *sum);
```

```cpp
// src/acc_shift.cpp
#include "acc_il.h"

// Shift form. lane[K-1] holds the partial sum last updated K iterations ago.
void acc_shift(const data_t x[N], data_t *sum) {
    data_t lane[K];

INIT:
    for (int k = 0; k < K; k++) lane[k] = 0;

ACC:
    for (int i = 0; i < N; i++) {
        data_t s = lane[K - 1] + x[i];
    SHIFT:
        for (int k = K - 1; k > 0; k--) lane[k] = lane[k - 1];
        lane[0] = s;
    }

    data_t total = 0;
COMBINE:
    for (int k = 0; k < K; k++) total += lane[k];
    *sum = total;
}
```

- With $K = 1$, `SHIFT` has zero trips and `ACC` is the S1.2 loop.
- `SHIFT` sits inside the pipelined `ACC`, so it is unrolled automatically; `-pipeline_loops 0` does not affect that.

```cpp
// src/acc_index.cpp
#include "acc_il.h"

// Index form (paper Lst. 2), with a wrap counter instead of i % K.
void acc_index(const data_t x[N], data_t *sum) {
    data_t lane[K];

INIT:
    for (int k = 0; k < K; k++) lane[k] = 0;

    int c = 0;
ACC:
    for (int i = 0; i < N; i++) {
        lane[c] = lane[c] + x[i];
        c = (c == K - 1) ? 0 : c + 1;   // i % K would build a divider for K = 7, 10
    }

    data_t total = 0;
COMBINE:
    for (int k = 0; k < K; k++) total += lane[k];
    *sum = total;
}
```

Both forms hold the same residue classes, but in a different lane order, and `COMBINE` adds them in lane order. So the two forms can produce different bits for the same input, and each testbench reference mirrors its own form.

### 4.2 The script

```tcl
# exercises/s2_pipelining/03_single_loop_interleaving/run_hls.tcl
# Run:  vitis_hls -f run_hls.tcl 2>&1 | tee run.log

# ---- knobs ------------------------------------------------------------
# Pass 1 (stage B): ONLY=base_proj DO_COSIM=0
# Pass 2:           the defaults below (main projects, with cosim)
# Extras (5.5):     ONLY="index_k4_proj comb_k10_proj" DO_COSIM=1
# Environment variables ONLY and DO_COSIM override these.
set ONLY     {base_proj shift_k1_proj shift_k2_proj shift_k4_proj shift_k7_proj shift_k10_proj index_k10_proj}
set DO_COSIM 1
if {[info exists ::env(ONLY)]}     { set ONLY     $::env(ONLY) }
if {[info exists ::env(DO_COSIM)]} { set DO_COSIM $::env(DO_COSIM) }

# K     = number of lanes (0 for the untransformed kernel)
# cosim = solutions that also run cosim_design when DO_COSIM is 1
set RUNS {
    base_proj      {top accumulate tb tb_accumulate K 0  sols {seq pipe}       cosim {pipe}}
    shift_k1_proj  {top acc_shift  tb tb_acc_il     K 1  sols {pipe}           cosim {}}
    shift_k2_proj  {top acc_shift  tb tb_acc_il     K 2  sols {pipe}           cosim {}}
    shift_k4_proj  {top acc_shift  tb tb_acc_il     K 4  sols {pipe}           cosim {}}
    shift_k7_proj  {top acc_shift  tb tb_acc_il     K 7  sols {pipe}           cosim {pipe}}
    shift_k10_proj {top acc_shift  tb tb_acc_il     K 10 sols {pipe}           cosim {pipe}}
    index_k10_proj {top acc_index  tb tb_acc_il     K 10 sols {pipe pipe_dist} cosim {pipe_dist}}
    index_k4_proj  {top acc_index  tb tb_acc_il     K 4  sols {pipe_lie}       cosim {pipe_lie}}
    comb_k10_proj  {top acc_shift  tb tb_acc_il     K 10 sols {pipe_comb}      cosim {}}
}
# Extras live in their own projects, because open_project -reset wipes every solution.
#   index_k4_proj: extra 5.5a (false distance promise)
#   comb_k10_proj: extra 5.5b (COMBINE pipelined)
# -----------------------------------------------------------------------

foreach {proj cfg} $RUNS {
    if {[llength $ONLY] > 0 && [lsearch -exact $ONLY $proj] < 0} { continue }

    set top   [dict get $cfg top]
    set tb    [dict get $cfg tb]
    set K     [dict get $cfg K]
    set sols  [dict get $cfg sols]
    set cosim [dict get $cfg cosim]

    if {$top eq "accumulate"} {
        set cflags "-DDATA_T=float"
    } else {
        set cflags "-DK=$K"
    }

    open_project -reset $proj
    set_top $top
    add_files     src/${top}.cpp -cflags $cflags
    add_files -tb src/${tb}.cpp  -cflags "$cflags -DUSE_$top"

    set first 1
    foreach sol $sols {
        open_solution -reset $sol -flow_target vivado
        source ../../../common/part.tcl

        # Directive files are sourced in this scope, so they can use $K.
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

- **Cosim** covers `base/pipe`, the two II = 1 shift points, `index_k10/pipe_dist` and the false promise. The directive is unchecked by the tool, so its cosim matters most.
- **Runtime:** about 6 minutes for pass 2 and 5 for the extras. The failing cosim of 5.5a writes a very large log (≈ 85 MB).
- **`make clean`** covers every `*_proj` and `run_*.log`.

### 4.3 The directives

```tcl
# directives_accumulate_pipe.tcl   (same as S1.2)
set_directive_pipeline -II 1 "accumulate/ACC"
```

```tcl
# directives_acc_shift_pipe.tcl
set_directive_array_partition -type complete -dim 1 "acc_shift" lane
set_directive_pipeline -II 1 "acc_shift/ACC"
```

```tcl
# directives_acc_index_pipe.tcl
# No array_partition: lane stays an array (1R1W LUTRAM), same as pipe_dist,
# so pipe vs pipe_dist differs only by the dependence directive.
set_directive_pipeline -II 1 "acc_index/ACC"
```

```tcl
# directives_acc_index_pipe_dist.tcl
# No array_partition: a complete partition turns lane[c] into registers named
# mux_case_0..K-1, and set_directive_dependence -variable lane then silently
# matches nothing (II stays 7). Kept as an array, the directive applies.
set_directive_pipeline -II 1 "acc_index/ACC"
set_directive_dependence -variable lane -type inter -dependent true -distance $K "acc_index/ACC"
```

```tcl
# directives_acc_index_pipe_lie.tcl
# K = 4 is small enough that Vitis partitions lane into registers on its own
# (XFORM 203-102), which silently drops the dependence directive. -off keeps
# lane an array, so the false distance actually reaches the scheduler.
set_directive_array_partition -off "acc_index" lane
set_directive_pipeline -II 1 "acc_index/ACC"
set_directive_dependence -variable lane -type inter -dependent true -distance 10 "acc_index/ACC"
```

```tcl
# directives_acc_shift_pipe_comb.tcl
set_directive_array_partition -type complete -dim 1 "acc_shift" lane
set_directive_pipeline -II 1 "acc_shift/ACC"
set_directive_pipeline -II 1 "acc_shift/COMBINE"
```

- `-distance` is only used with `-dependent true` [2]: a read of `lane` depends on the write from $K$ iterations earlier.
- **Partitioned `lane` drops the directive (measured, $K = 10$).** An earlier version partitioned `lane` in both index solutions: both came out at II = 7, 6 violation lines on `mux_case_0`, 3.046 ns, LUT 1269, FF 1317, with `-distance 10` or `-dependent false` alike, and no warning.
- **`set_directive_array_partition -off`** (2023.2 `help`: "Turn off auto array partition") is needed for $K \le 4$.

### 4.4 Testbench

`tb_accumulate.cpp` is the S1.2 file with a single `N_RANDOM`. The interleaved testbench keeps the repo shape: a separate `ref()` model, POISON in the output, directed then seeded random vectors, errors counted, non-zero return on failure.

- **Reference:** computes the lane sums independently, in index order, then combines them in the lane order of the form under test. The compare is exact.
- **Sequential sum:** printed for information only (`cancel:` and `random:` lines), never checked.
- **One `N_RANDOM = 64`:** `__RTL_SIMULATION__` is not defined for the testbench in cosim (68 transactions per cosim; `notes/env.md`, Probe E).

```cpp
// src/tb_acc_il.cpp
#include <cmath>
#include <cstdio>
#include <random>
#include "acc_il.h"

#if defined(USE_acc_shift)
#  define DUT  acc_shift
#  define FORM "shift"
#elif defined(USE_acc_index)
#  define DUT  acc_index
#  define FORM "index"
#else
#  error "tb_acc_il: compile with -DUSE_acc_shift or -DUSE_acc_index"
#endif

// One count for csim and cosim: __RTL_SIMULATION__ is not defined for the
// testbench during cosim on 2023.2.2 (notes/env.md, Probe E).
static const int N_RANDOM = 64;

static const data_t POISON = (data_t)-12345;

// part[r] = x[r] + x[r+K] + x[r+2K] + ..., added in index order from 0.
static void lane_sums(const data_t x[N], data_t part[K]) {
    for (int r = 0; r < K; r++) part[r] = 0;
    for (int i = 0; i < N; i++) part[i % K] += x[i];
}

// Same lanes and same combine order as the DUT, so the result must be bit-exact.
static data_t ref(const data_t x[N]) {
    data_t part[K];
    lane_sums(x, part);
    data_t total = 0;
    for (int j = 0; j < K; j++) {
#if defined(USE_acc_shift)
        total += part[(N - 1 - j) % K];   // shift form: lane[j] holds class (N-1-j) mod K
#else
        total += part[j];                 // index form: lane[j] holds class j
#endif
    }
    return total;
}

// The untransformed order. Printed for comparison, never checked.
static data_t ref_sequential(const data_t x[N]) {
    data_t acc = 0;
    for (int i = 0; i < N; i++) acc += x[i];
    return acc;
}

static int check(const char *name, const data_t x[N]) {
    data_t got = POISON;
    DUT(x, &got);
    data_t exp = ref(x);
    if (got != exp) {
        std::printf("FAIL %-8s got %.9g expected %.9g\n", name, (double)got, (double)exp);
        return 1;
    }
    return 0;
}

int main() {
    std::printf("tb_acc_il: form=%s K=%d N=%d N_RANDOM=%d\n", FORM, K, N, N_RANDOM);
    int errors = 0;
    data_t x[N];

    // --- directed ------------------------------------------------------
    for (int i = 0; i < N; i++) x[i] = 0;
    errors += check("zeros", x);

    for (int i = 0; i < N; i++) x[i] = 1;
    errors += check("ones", x);

    // Order-sensitive: 1e8 + 1 rounds back to 1e8 in single precision.
    x[0] = (data_t)100000000;
    for (int i = 1; i < N - 1; i++) x[i] = 1;
    x[N - 1] = (data_t)-100000000;
    errors += check("cancel", x);
    std::printf("cancel: interleaved=%.9g sequential=%.9g exact=1022\n",
                (double)ref(x), (double)ref_sequential(x));

    for (int i = 0; i < N; i++) x[i] = (i % 2) ? (data_t)-1000 : (data_t)1000;
    errors += check("alt", x);

    // --- random (fixed seed: cosim replays the same stimulus) ---------
    std::mt19937 rng(42);
    double max_rel = 0;
    for (int v = 0; v < N_RANDOM; v++) {
        for (int i = 0; i < N; i++) {
            int r = (int)(rng() % 2001) - 1000;
            x[i] = (data_t)r / 1000;
        }
        errors += check("random", x);
        double s  = ref_sequential(x);
        double il = ref(x);
        if (s != 0) {
            double rel = std::fabs(il - s) / std::fabs(s);
            if (rel > max_rel) max_rel = rel;
        }
    }
    std::printf("random: max |interleaved - sequential| / |sequential| = %.3g\n", max_rel);

    std::printf("%s: %d error(s)\n", errors ? "FAILED" : "PASSED", errors);
    return errors ? 1 : 0;
}
```

**Which vectors catch a wrong kernel.** On small integers every grouping gives the same float sum, so `zeros`, `ones` and `alt` only catch gross errors (5.5a: `ones` returns 344). `cancel` and the fractional random vectors catch a wrong lane distance or a wrong combine order, because either one moves the rounding.

---

## 5. Measure

**Pass 2 and extras:**

```bash
vitis_hls -f run_hls.tcl 2>&1 | tee run.log
ONLY="index_k4_proj comb_k10_proj" DO_COSIM=1 vitis_hls -f run_hls.tcl 2>&1 | tee run_extras.log

C=../../../common
PROJ=base_proj TOP=accumulate OUT=lat_base.md bash $C/collect_latency.sh
PROJ=base_proj TOP=accumulate OUT=res_base.md bash $C/collect_resources.sh
for K in 1 2 4 7 10; do
    PROJ=shift_k${K}_proj TOP=acc_shift OUT=lat_shift_k${K}.md bash $C/collect_latency.sh
    PROJ=shift_k${K}_proj TOP=acc_shift OUT=res_shift_k${K}.md bash $C/collect_resources.sh
done
PROJ=index_k10_proj TOP=acc_index OUT=lat_index_k10.md    bash $C/collect_latency.sh
PROJ=index_k10_proj TOP=acc_index OUT=res_index_k10.md    bash $C/collect_resources.sh
PROJ=index_k4_proj  TOP=acc_index OUT=lat_index_k4_lie.md bash $C/collect_latency.sh
PROJ=comb_k10_proj  TOP=acc_shift OUT=lat_comb_k10.md     bash $C/collect_latency.sh
PROJ=comb_k10_proj  TOP=acc_shift OUT=res_comb_k10.md     bash $C/collect_resources.sh
```

The pipelined `ACC` is extracted into `<top>_Pipeline_ACC`, with its own report; the collector picks it up. Each interleaved `Bind Op Report` has two `fadd` rows: `ACC` (in the submodule) and `COMBINE` (variable `total`).

### 5.1 csynth

**Timing**

| row                   | II tgt | II ach | Iter. Lat. | $C_{\text{ACC}}$ | `INIT` C | `COMBINE` C | Fn lat | est. ns | 200-871 | $D_{\text{ACC}}$ | $D_{\text{COMBINE}}$ |
|-----------------------|--------|--------|------------|------------------|----------|-------------|--------|---------|---------|------------------|----------------------|
| `base/seq`            | —      | —      | 14         | 14336            | —        | —           | 14337  | 2.262   | no      | 10               | —                    |
| `base/pipe`           | 1      | 7      | 10         | 7170             | —        | —           | 7172   | 2.719   | yes     | 7                | —                    |
| `shift_k1/pipe`       | 1      | 7      | 10         | 7170             | —        | — (1 trip)  | 7184   | 2.719   | yes     | 7                | 10                   |
| `shift_k2/pipe`       | 1      | 7      | 10         | 7170             | —        | 26          | 7201   | 2.292   | no      | 7                | 10                   |
| `shift_k4/pipe`       | 1      | 2      | 10         | 2055             | —        | 52          | 2112   | 2.719   | yes     | 7                | 10                   |
| `shift_k7/pipe`       | 1      | 1      | 10         | 1032             | —        | 91          | 1128   | 2.719   | yes     | 7                | 10                   |
| `shift_k10/pipe`      | 1      | 1      | 10         | 1032             | —        | 130         | 1167   | 2.719   | yes     | 7                | 10                   |
| `index_k10/pipe`      | 1      | 7      | 10         | 7170             | 10       | 140         | 7325   | 2.969   | yes     | 7                | 10                   |
| `index_k10/pipe_dist` | 1      | 1      | 10         | 1032             | 10       | 140         | 1187   | 2.969   | yes     | 7                | 10                   |

**Area** (Total row)

| row                   | LUT  | FF   | DSP | BRAM | FF − `shift_k1` |
|-----------------------|------|------|-----|------|-----------------|
| `base/seq`            | 356  | 491  | 2   | 0    | —               |
| `base/pipe`           | 541  | 460  | 0   | 0    | —               |
| `shift_k1/pipe`       | 831  | 843  | 2   | 0    | 0               |
| `shift_k2/pipe`       | 925  | 977  | 2   | 0    | 134             |
| `shift_k4/pipe`       | 946  | 1202 | 2   | 0    | 359             |
| `shift_k7/pipe`       | 1097 | 1594 | 2   | 0    | 751             |
| `shift_k10/pipe`      | 1241 | 1979 | 2   | 0    | 1136            |
| `index_k10/pipe`      | 1233 | 1120 | 2   | 0    | —               |
| `index_k10/pipe_dist` | 1086 | 1091 | 2   | 0    | —               |

`index_k10` `lane`: `lane_RAM_AUTO_1R1W`, 10 × 32 bits, 64 FF + 5 LUT (the Storage Report lists it as `ram_s2p array`, `Impl auto`).

**Checks**

1. **II:** $\lceil D_{\min}/K \rceil$ holds for $K = 1, 4, 7, 10$. **$K = 2$ fails** (7, not 4).
2. **Core choice:** $D_{\text{ACC}} = 7$ on every pipelined row. At $K = 10$ the tool did not move to the relaxed core, so HLS 200-871 stays.
3. **Depth:** $L_p = C_{\text{ACC}} - I \cdot 1023 = 9 = D_{\text{ACC}} + 2$ on every row. The iteration latency reads 10.
4. **$K = 1$:** same $C_{\text{ACC}}$ as `base/pipe` (7170). The function is 12 cycles longer, for the lone `COMBINE` add.
5. **Lane cost:** FF grows by about **128 per lane** ($K = 4 \to 7 \to 10$: +392, +385), not 32. Each lane costs about four 32-bit words (the lane register plus copies the pipeline keeps; not traced in the RTL).
6. **Storage:** at $K = 10$, `index_k10/pipe_dist` uses 1091 FF / 1086 LUT against 1979 / 1241 for the shift form, but its estimate is 2.969 ns against 2.719 ns.
7. **Sharing:** DSP is 2 on every interleaved row. The pipelined `ACC` and the unpipelined `COMBINE` use different `fadd` cores (fabric against `fulldsp`), so they are not shared. When both are pipelined, they are (5.5b).

### 5.2 Log diagnostics

```bash
grep -nE "Running: open_(project|solution)|II Violation|HLS 200-881|Pipelining result|WARNING: \[HLS 200-871\]|XFORM 203-10[12]" run.log
```

The results are in Stage C. Match `WARNING: [HLS 200-871]`, or the Resolution lines are counted twice.

### 5.3 Cosim

| row                   | cosim min / avg / max | Fn lat (5.1) | cosim − Fn lat | calls | tb     |
|-----------------------|-----------------------|--------------|----------------|-------|--------|
| `base/pipe`           | 7170 / 7170 / 7170    | 7172         | −2             | 68    | PASSED |
| `shift_k7/pipe`       | 1126 / 1126 / 1126    | 1128         | −2             | 68    | PASSED |
| `shift_k10/pipe`      | 1165 / 1165 / 1165    | 1167         | −2             | 68    | PASSED |
| `index_k10/pipe_dist` | 1185 / 1185 / 1185    | 1187         | −2             | 68    | PASSED |
| `index_k4/pipe_lie`   | 1095 / 1095 / 1095    | 1097         | −2             | 68    | **FAILED** (66 errors) |

Zero variance and a gap of −2 everywhere, as in S1.1 and S1.2. The three-loop structure does not change the gap.

**`cancel:` and `random:` lines** (csim; Q1 uses them). The exact answer on `cancel` is 1022.

| row         | `cancel:` interleaved | `cancel:` sequential | `random:` max rel. diff |
|-------------|-----------------------|----------------------|-------------------------|
| `shift_k1`  | 0                     | 0                    | 0                       |
| `shift_k2`  | 512                   | 0                    | 0.00463                 |
| `shift_k4`  | 768                   | 0                    | 0.00363                 |
| `shift_k7`  | 874                   | 0                    | 0.00391                 |
| `shift_k10` | 924                   | 0                    | 0.00629                 |
| `index_k10` | 924                   | 0                    | 0.00557                 |
| `index_k4`  | 768                   | 0                    | 0.00344                 |

`shift_k1` reproduces the sequential sum bit for bit. `shift_k10` and `index_k10` give the same `cancel` result but different random deviations, because they combine the lanes in a different order.

### 5.4 results.csv

`sweep_param` is `K` on the shift rows. The index and extra rows have a fixed $K$, recorded in `notes`. `fmax_est` is 1000 / estimated ns.

```csv
s2.1.3,accumulate,seq,float,1024,,,,14,14337,,356,491,2,0,442,?,unpipelined; II_achieved=L by substitution; S1.2 re-run; fadd lat=10 (fulldsp)
s2.1.3,accumulate,pipe,float,1024,,,1,7,7172,7170,541,460,0,0,368,?,S1.2 re-run; fadd lat=7 (fabric); 200-871=y
s2.1.3,acc_shift,pipe,float,1024,K,1,1,7,7184,,831,843,2,0,368,?,fadd ACC lat=7 (fabric); COMBINE fadd lat=10 (fulldsp); 200-871=y
s2.1.3,acc_shift,pipe,float,1024,K,2,1,7,7201,,925,977,2,0,436,?,fadd ACC lat=7 (fabric); 200-871=n; II=7 from 6x HLS 200-881 (fadd-fadd on lane) not 200-880; model says 4
s2.1.3,acc_shift,pipe,float,1024,K,4,1,2,2112,,946,1202,2,0,368,?,fadd ACC lat=7 (fabric); 200-871=y
s2.1.3,acc_shift,pipe,float,1024,K,7,1,1,1128,1126,1097,1594,2,0,368,?,fadd ACC lat=7 (fabric); 200-871=y
s2.1.3,acc_shift,pipe,float,1024,K,10,1,1,1167,1165,1241,1979,2,0,368,?,fadd ACC lat=7 (fabric; relaxed core not taken); 200-871=y
s2.1.3,acc_index,pipe,float,1024,,,1,7,7325,,1233,1120,2,0,337,?,K=10; no dependence directive; lane unpartitioned (LUTRAM); 200-871=y
s2.1.3,acc_index,pipe_dist,float,1024,,,1,1,1187,1185,1086,1091,2,0,337,?,K=10; dependence inter true distance=10; lane unpartitioned (LUTRAM); 200-871=y
s2.1.3,acc_index,pipe_lie,float,1024,,,1,1,1097,1095,1079,1087,2,0,337,?,extra 5.5a; K=4; distance=10 (false); array_partition -off; csim PASS; cosim FAIL 66/68
s2.1.3,acc_shift,pipe_comb,float,1024,,,1,7,1111,,1096,1579,0,0,368,?,extra 5.5b; K=10; COMBINE pipelined II=7 C=71; one fabric fadd shared by ACC and COMBINE
```

For the `pipe_comb` row, `II_achieved` is that of `COMBINE`; `ACC` is at II = 1.

### 5.5 Extras

**a. A false distance promise** (`index_k4_proj/pipe_lie`). The lanes really repeat every 4 iterations, but the directive says 10.

| attempt | partition lines | II | $C_{\text{ACC}}$ | Fn lat | est. ns | csim | cosim |
|---|---|---|---|---|---|---|---|
| without `-off` | `XFORM 203-102` auto-partition of `lane` | 7 (6 × HLS 200-880 on `lane[2]`) | 7170 | 7232 | 2.817 | PASS | PASS (7230) |
| with `-off` | none | **1**, 0 violations | 1032 | 1097 | 2.969 | PASS | **FAIL: 66 of 68 calls** |

- **Without `-off`:** the tool silently dropped the lie with the partition, so the design is slow but correct.
- **With `-off`:** the tool believes the promise. csim passes because C runs one iteration at a time. The RTL overlaps iterations and reads stale lanes: `ones` returns 344 instead of 1024. Only `zeros` and `alt` survive.

**b. Pipeline the second stage** (`comb_k10_proj/pipe_comb`).

| | `COMBINE` II | `COMBINE` C | $L_p$ | Fn lat | est. ns | LUT / FF / DSP | `fadd` cores |
|---|---|---|---|---|---|---|---|
| `shift_k10/pipe`      | — (unpipelined) | 130 | — | 1167 | 2.719 | 1241 / 1979 / 2 | fabric in `ACC` + `fulldsp` in `COMBINE` |
| `comb_k10/pipe_comb`  | 7 (6 × HLS 200-880 on `total`) | 71 | 8 | **1111** | 2.719 | **1096 / 1579 / 0** | **one fabric core, shared** |

- **`COMBINE` is the S1.2 blocker again:** II = 7, $C = 8 + 7 \cdot 9 = 71$.
- **56 cycles saved (4.8%).**
- **The area also drops.** Both pipelined loops now use the same 7-cycle fabric `fadd`, and they run one after the other, so the tool instantiates one core in the top module and muxes it between the two submodules (`acc_shift.v`: `grp_fu_256`). That saves the `fulldsp` core: −2 DSP, −400 FF, −145 LUT. The shared core is not listed in the `Bind Op Report`; it shows in the top module's instance table.

---

## 6. Questions

**Q1.** On the `cancel` vector, the sequential float sum is 0 and the exact answer is 1022. What does `shift_k2` return, and which of the three is "right"?

<details><summary>Answer</summary>

**`shift_k2` returns 512.** The ones are split into two lanes of 511 each. In single precision, values between $2^{26}$ and $2^{27}$ are 8 apart, and $10^8$ is in that range.
- **The lane holding `x[0]`** starts at $10^8$. Every $+1$ rounds back, so all 511 ones are lost.
- **The lane holding `x[1023]`** sums its 511 ones exactly first, then meets $-10^8$. $511 - 10^8$ rounds to $-99\,999\,488$, losing only 1.
- **Combined:** $10^8 - 99\,999\,488 = 512$, exactly.

**None of the three is right in float32:** the format cannot hold $10^8 + 1$. Interleaving only changes which small terms meet the large ones, and when. $K = 4, 7, 10$ give 768, 874 and 924. So "interleaving is more accurate" is not a rule. On the random vectors the difference is at the rounding level (up to 0.63%). That difference is the price of the transformation, and the reason the tool will not apply it [1, Sec. 2.1].

**To match a CPU reference exactly:** write the reference with the same lane grouping (as this testbench does), or use a type with associative addition (int, `ap_fixed`, S4.4).

</details>

**Q2.** `COMBINE` adds $K$ values into one running sum, the same pattern this exercise set out to fix. Should it be pipelined? What would a much larger $K$ need?

<details><summary>Answer</summary>

**At $K = 10$, yes, and not for speed.** Unpipelined, `COMBINE` takes $13K = 130$ cycles. Pipelined, it hits the same dependency at II = 7: $C = 71$. That saves 56 cycles of 1167 (4.8%). The real gain is area: with both loops on the fast fabric core, the tool shares one `fadd` and drops the 2-DSP `fulldsp` core (5.5b). The earlier expectation that pipelining `COMBINE` "costs extra registers" was wrong on 2023.2.2.

**For a large $K$** the second stage stops being negligible ($13K$ cycles unpipelined, $\approx 7K$ pipelined). Options:
- **Interleave again:** `COMBINE` is a single loop with a slow add, so the same transformation applies with fewer lanes.
- **A balanced adder tree:** $K - 1$ adders in $\lceil \log_2 K \rceil$ levels; latency about $D_{\text{add}} \lceil \log_2 K \rceil$, but $K - 1$ `fadd` cores, and the rounding changes again.
- **Separate dataflow processes (S3.3):** helps throughput across calls, not the latency of one call [1, Sec. 2.1.3].

</details>

**Q3.** `index_k10/pipe` stays at II = 7, and a dependence directive fixes it. Why can't the tool see the distance itself? And in 5.5a, why does csim pass while cosim fails?

<details><summary>Answer</summary>

**Why $d = 1$ is assumed.** Iteration $i$ reads and writes `lane[c]`. The dependency analysis looks at the array accesses, not at how `c` evolves, so it cannot prove that consecutive iterations touch different elements. The violation lines show it: distance 2 on the add, then distance 1 on `reuse_reg`, the read-after-write bypass.

**What the directive does.** `-dependent true -distance K` replaces that assumption, so the tool only needs $I \cdot K \ge$ its read-to-write span. The shift form never needs it: the distance is a visible chain of registers.

**Why it only works on an unpartitioned array.** The directive is attached to the variable `lane`. A partition replaces `lane` with registers (`mux_case_*` when explicit, `lane[j]` when automatic) before scheduling. The directive then matches nothing, with no warning. At $K = 4$ this happens automatically, which is why 5.5a needs `-off`.

**Why the false promise breaks only cosim.** The tool does not check the promise. With `-distance 10` it schedules II = 1. Each iteration reads its lane at the start of the pipeline, but the write from the iteration 4 steps earlier lands about 9 cycles after that one started, so the read is stale and that iteration's input is lost. csim runs the C code one iteration at a time, so nothing overlaps; the RTL overlaps them. Measured: 66 of 68 cosim calls fail, and `ones` returns 344.

**Rule:** a stated distance is safe only if it is $\le$ the real one. Stating 4 when the truth is 10 may cost II; stating 10 when it is 4 builds wrong hardware. S2.3 uses `-dependent false` together with a forwarding buffer that makes the promise true.

</details>

---

## 7. Conclusions

### What we set out to show

The claim from [1, Sec. 2.1.3]: a single accumulation loop blocked by a slow carried operator can reach II = 1 by splitting the running sum into $K \ge D_{\text{add}}$ lanes, followed by a short combine stage. It trades bit-exactness with the sequential sum for speed. The exercise also asked two practical questions:
- Does the tool see the new distance, and does that depend on how the code is written?
- What happens when the distance is stated wrongly?

### How we tested it

- **A sweep** $K \in \{1, 2, 4, 7, 10\}$ on the shift form, against the re-measured S1.2 baseline (`base/seq`, `base/pipe`). The prediction was $I = \lceil D_{\min}/K \rceil$, $L_p = D_{\text{ACC}} + 2$ and $T = C_{\text{INIT}} + C_{\text{ACC}} + 2 + C_{\text{COMBINE}} + 3$.
- **The same idea written two ways** at $K = 10$: shift form against index form, with and without the dependence directive.
- **Correctness:** a reference that mirrors each form's lane grouping, compared exactly, in csim and cosim (68 calls). The sequential sum is printed to measure how far the answer moves.
- **Two extras:** a false distance promise ($K = 4$, stated 10), and pipelining the second stage.

### What the data shows

1. **The claim holds for $K \ge D_{\min}$.** At $K = 7$: II 7 → 1, `ACC` 7170 → 1032 cycles (6.95×), function 7172 → 1128 (6.36×), cosim pass. The adder, the clock and the core are unchanged.
2. **The ceiling model is only partly reliable.** $K = 1, 4, 7, 10$ match $\lceil 7/K \rceil$. $K = 2$ does not: the tool reports a carried constraint between two `fadd` operations (HLS 200-881) and stays at II = 7 instead of 4. Below about $K = 4$, run it before trusting the model.
3. **There is no gain past $K = D_{\min}$.** $K = 10$ has the same $C_{\text{ACC}}$ as $K = 7$, costs +385 FF and +39 `COMBINE` cycles, and the tool did not use the extra slack to take the relaxed core. Choose $K = D_{\min}$.
4. **Lanes cost more than their bits.** The shift form grows by about 128 FF per lane, not 32. The index form keeps the lanes in a LUTRAM (1091 against 1979 FF at $K = 10$), but pays 0.25 ns in the clock estimate and needs the directive.
5. **The answer changes, deterministically.** `cancel` gives 0 (sequential), 512 / 768 / 874 / 924 (interleaved) against 1022 exact. Random vectors move by up to 0.63%. The result is only reproducible against a reference with the same grouping.
6. **How you write it decides whether the tool sees it.** The shift form's distance is visible (no directive). The index form needs `set_directive_dependence`, and that directive disappears silently whenever `lane` is partitioned, explicitly or automatically for small arrays ($K = 4$).
7. **The directive is a promise the tool never checks.** A false distance gave II = 1, a clean csim and 66 of 68 failing cosim calls. Cosim is the only check that catches it.
8. **Pipelining the combine stage pays off.** It saves 56 cycles (4.8%). Because both loops then use the same fabric `fadd`, the tool shares one core: −2 DSP, −400 FF.

### Limits of this evidence

- **One design point:** $N = 1024$, one part, one clock, one tool version (2023.2.2).
- **The $K = 2$ result is measured but not explained.** Neither the dependency model nor the log names a variable-level cause.
- **Timing is estimated only.** Every II = 1 design reports HLS 200-871; closure after implementation is not shown.
- **The per-lane FF cost is measured, not traced** to specific registers.
- **Correctness is shown for the tested vectors** (4 directed + 64 random, fixed seed).

### Rules of thumb

- **When to use it:** a single loop whose II equals the latency of the operator on its running value, and a slightly different float result is acceptable.
- **Choosing $K$:** $K = D_{\text{add}}$ under pipeline pressure (the fast core, 7 here). More lanes buy nothing; fewer lanes do not scale down smoothly ($K = 2$).
- **Prefer the shift form** when the tool must find the distance by itself and $K$ is small. Use the index form with the directive when FF matters more than clock margin, and keep the array unpartitioned (`array_partition -off` for small $K$).
- **Treat every dependence directive as a claim to verify in cosim**, with vectors that make stale reads visible.
- **Pipeline the combine stage too,** and check the Bind Op Report and the top-level instance table for sharing.

---

## Appendix A — Worked example: how the lanes add up

A shrunk version: **a 3-stage adder**, 9 integer inputs `x = [5, 2, 8, 1, 7, 3, 4, 6, 9]` (sum 45). Reads and write-backs are free: an iteration reads its register at the start of its cycle, and the result is written at the end of its 3rd stage. S1/S2/S3 are the adder's pipeline stages.

A pipelined adder accepts a new pair every cycle: "latency 3" means one addition needs 3 cycles to get through, not that the adder is locked for 3 cycles. What forces a high II is only that each addition needs the previous addition's answer.

### Case A: one `acc`, II = 3

| cycle | new input | S1 | S2 | S3 | `acc` at end |
|---|---|---|---|---|---|
| 0 | x0=5 | 0+5 | – | – | 0 |
| 1 | – | – | 0+5 | – | 0 |
| 2 | – | – | – | 0+5 | **5** |
| 3 | x1=2 | 5+2 | – | – | 5 |
| ... | | | | | |

Only one stage is busy at a time: $3 + 3 \cdot 8 = 27$ cycles, and the answer is correct (45).

### Case B: one `acc`, forced to II = 1 (broken)

| cycle | new input | reads `acc` | S1 | S2 | S3 | `acc` at end |
|---|---|---|---|---|---|---|
| 0 | x0=5 | 0 | 0+5 | – | – | 0 |
| 1 | x1=2 | 0 (stale) | 0+2 | 0+5 | – | 0 |
| 2 | x2=8 | 0 (stale) | 0+8 | 0+2 | 0+5 | 5 |
| 3 | x3=1 | 5 | 5+1 | 0+8 | 0+2 | 2 |
| 4 | x4=7 | 2 | 2+7 | 5+1 | 0+8 | 8 |
| 5 | x5=3 | 8 | 8+3 | 2+7 | 5+1 | 6 |
| 6 | x6=4 | 6 | 6+4 | 8+3 | 2+7 | 9 |
| 7 | x7=6 | 9 | 9+6 | 6+4 | 8+3 | 11 |
| 8 | x8=9 | 11 | 11+9 | 9+6 | 6+4 | 10 |
| 9 | – | | – | 11+9 | 9+6 | 15 |
| 10 | – | | – | – | 11+9 | **20** |

The result is 20, not 45. Each iteration builds on the one written 3 iterations earlier, so the register really carries three running sums (5 → 6 → 10, 2 → 9 → 15, 8 → 11 → 20). They add up to 45, but they overwrite each other in one register. This is also what 5.5a's false promise builds.

### Case C: three lanes, II = 1 (interleaving)

Iteration $i$ reads and writes lane $i \bmod 3$. The adder is unchanged.

| cycle | new input | reads | S1 | S2 | S3 | written | L0, L1, L2 after |
|---|---|---|---|---|---|---|---|
| 0 | x0=5 | L0=0 | 0+5 | – | – | – | 0, 0, 0 |
| 1 | x1=2 | L1=0 | 0+2 | 0+5 | – | – | 0, 0, 0 |
| 2 | x2=8 | L2=0 | 0+8 | 0+2 | 0+5 | L0 ← 5 | 5, 0, 0 |
| 3 | x3=1 | L0=5 | 5+1 | 0+8 | 0+2 | L1 ← 2 | 5, 2, 0 |
| 4 | x4=7 | L1=2 | 2+7 | 5+1 | 0+8 | L2 ← 8 | 5, 2, 8 |
| 5 | x5=3 | L2=8 | 8+3 | 2+7 | 5+1 | L0 ← 6 | 6, 2, 8 |
| 6 | x6=4 | L0=6 | 6+4 | 8+3 | 2+7 | L1 ← 9 | 6, 9, 8 |
| 7 | x7=6 | L1=9 | 9+6 | 6+4 | 8+3 | L2 ← 11 | 6, 9, 11 |
| 8 | x8=9 | L2=11 | 11+9 | 9+6 | 6+4 | L0 ← 10 | 10, 9, 11 |
| 9 | – | | – | 11+9 | 9+6 | L1 ← 15 | 10, 15, 11 |
| 10 | – | | – | – | 11+9 | L2 ← 20 | 10, 15, 20 |

- **The S1/S2/S3 columns are identical to Case B:** one adder, all stages full.
- **Every read is just in time:** at cycle 3, L0 was written at the end of cycle 2.
- **$3 + 1 \cdot 8 = 11$ cycles against 27.** With only 2 lanes, iteration 2 would read L0 one cycle too early, forcing II = $\lceil 3/2 \rceil = 2$.

`COMBINE` then adds L0 + L1 + L2 = 45 in a separate loop. In the real design that is the second `fadd` (unpipelined: $K$ trips of 13 cycles) or the same shared core when `COMBINE` is pipelined too (5.5b).

| term | meaning |
|---|---|
| **pipeline stage** | one slice of the adder, with a register after it (S1, S2, S3) |
| **paper's "two stages"** | two loops run one after the other: `ACC` over the inputs, `COMBINE` over the lanes |

---

## References

[1] J. de Fine Licht, M. Besta, S. Meierhans, T. Hoefler, "Transformations of High-Level Synthesis Codes for High-Performance Computing," *IEEE Trans. Parallel and Distributed Systems*, 32(5), 2021. arXiv:1805.08288.
- Sec. 1.2: the pipeline model, Eq. 1.
- Sec. 2: the two classes that block pipelining.
- Sec. 2.1: accumulation interleaving, and why its four variants exist.
- Sec. 2.1.3 and Lst. 2: single-loop accumulation interleaving, with two stages, $K \ge L_{\text{acc}}$, and an unpipelined collapse loop.

[2] AMD, *Vitis High-Level Synthesis User Guide* (UG1399), version matching 2023.2. Reference pages for:
- `set_directive_pipeline`;
- `set_directive_array_partition` (`-type complete`, `-dim`, `-off`);
- `set_directive_dependence` (`-variable`, `-type inter`, `-dependent`, `-distance`);
- the Bind Op section of the synthesis report.
