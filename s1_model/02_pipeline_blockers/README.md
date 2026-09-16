# S1.2 — What blocks pipelining

S1.1 measured what $C = L + I(N-1)$ predicts when nothing gets in the way, so $I$ went to 1 as soon as it was asked. This exercise is about the two things that stop $I$ from reaching 1:

1. a **loop-carried dependency**, where iteration $i+1$ needs a value that iteration $i$ has not finished computing, and
2. **interface contention**, where one iteration needs the same memory port more times than the port can serve in one cycle.

Neither blocker has anything to do with auto-pipelining being on or off. Both are structural. Ask for `PIPELINE II=1` and the tool will refuse, and it will tell you why in the log. The goal here is to predict the refusal to the cycle and read the reason off the log and report, not to fix anything. The fixes are the S2 transformations.

This is the last exercise before S2.

---

## 0. Setup

**Prerequisites:** S1.1 run, and `common/part.tcl` in place (part `xcku5p-ffvb676-2-e`, 3.33 ns clock, `config_compile -pipeline_loops 0`).

**Files in this directory**

```
s1_model/02_pipeline_blockers/
  README.md
  run_hls.tcl
  src/accumulate.h  src/accumulate.cpp  src/tb_accumulate.cpp
  src/fir3.h        src/fir3.cpp        src/tb_fir3.cpp
  directives_accumulate_pipe.tcl
  directives_fir3_pipe.tcl
  directives_fir3_pipe_2p.tcl
```

(If S1.1 keeps its testbenches outside `src/`, match that layout and adjust the `add_files` lines.)

**Solution roster.** There are three projects in one `run_hls.tcl`. The float and int builds of `accumulate` must be separate projects because the dtype is set with `-cflags` on `add_files`, and `add_files` is a project-level command.

| project     | top          | dtype   | solution  | what it is                                           |
|-------------|--------------|---------|-----------|------------------------------------------------------|
| `accf_proj` | `accumulate` | `float` | `seq`     | no directive; sequential baseline                    |
| `accf_proj` | `accumulate` | `float` | `pipe`    | `PIPELINE II=1`; **dependency blocker**               |
| `acci_proj` | `accumulate` | `int`   | `seq`     | no directive; sequential baseline                    |
| `acci_proj` | `accumulate` | `int`   | `pipe`    | `PIPELINE II=1`; same dependency, blocker gone       |
| `fir_proj`  | `fir3`       | `int`   | `seq`     | no directive; sequential baseline                    |
| `fir_proj`  | `fir3`       | `int`   | `pipe`    | `PIPELINE II=1`; **port blocker**, one read port     |
| `fir_proj`  | `fir3`       | `int`   | `pipe_2p` | `PIPELINE II=1` + `ram_2p` on `x`; two read ports    |

**Why the suppression stays on.** `part.tcl` keeps `-pipeline_loops 0`, so every `seq` row really is sequential. An explicit `set_directive_pipeline` is not affected by that setting; it only turns off *automatic* pipelining. Running with the tool defaults is optional extra 5.5a.

**Dtype choice.** `accumulate` is float, following the repo dtype policy: with `int` the add fits in one clock cycle and the dependency never becomes a blocker. The int build is kept on purpose, as the control that shows this. `fir3` is int, so the add is cheap and the only thing that can hold $I$ above 1 is the port count.

---

## 1. The model: what sets the lower bound on II

S1.1 used $C = L + I(N-1)$ with $I$ treated as a free choice. It is not a free choice. $I$ has a lower bound, and each blocker gives one.

**Loop-carried dependency.** A variable is read in iteration $i$ and written back so that iteration $i+d$ can read it. $d$ is the dependency *distance* in iterations. Let $\delta$ be the number of clock cycles from that read to the finished write. Iteration $i+d$ starts $I \cdot d$ cycles after iteration $i$, and it may not read the variable before the write is done:

$$I \cdot d \ge \delta \quad\Rightarrow\quad I_{\text{dep}} = \left\lceil \frac{\delta}{d} \right\rceil$$

For `acc += x[i]`, $d = 1$ and $\delta$ is the latency of the adder, so $I_{\text{dep}} \approx D_{\text{add}}$. A 32-bit int add fits in one cycle, which gives $I_{\text{dep}} = 1$ and no blocker. A float add uses a Xilinx floating-point core with several cycles of latency at 3.33 ns, which gives $I_{\text{dep}} > 1$.

The dependency exists in both builds. It only blocks when $\delta > d$.

**Interface contention.** One iteration makes $A$ accesses to the same memory, which has $P$ ports. Each access holds a port for one cycle. In any window of $I$ cycles there are at most $P \cdot I$ port-cycles, so:

$$P \cdot I \ge A \quad\Rightarrow\quad I_{\text{port}} = \left\lceil \frac{A}{P} \right\rceil$$

For naive `fir3`, $A = 3$ reads of `x` per iteration. A top-level `ap_memory` array defaults to a single port, which gives $I_{\text{port}} = 3$. With `ram_2p` there are two ports, which gives $I_{\text{port}} = 2$.

**Combined.**

$$I_{\min} = \max\left(1,\ I_{\text{dep}},\ I_{\text{port}}\right), \qquad C = L + I_{\min}(N-1)$$

The tool tries $I = 1$, reports a violation, tries $I = 2$, and so on, until a schedule works. The number it settles on should be $I_{\min}$.

The de Fine Licht et al. taxonomy [1, Sec. 3] is built on exactly these two bounds. Its pipeline-enabling transformations each remove one term. Loop interleaving raises the effective $d$ in $\lceil \delta/d \rceil$ (S2.1.2, S2.1.3). Delay buffering lowers $A$ in $\lceil A/P \rceil$ (S2.2). Array partitioning raises $P$ (S3.0).

---

## 2. The blockers

### 2.1 `accumulate` — loop-carried dependency

```cpp
// src/accumulate.h
#pragma once
#ifndef DATA_T
#define DATA_T float
#endif
typedef DATA_T data_t;

const int N = 1024;

void accumulate(const data_t x[N], data_t *sum);
```

```cpp
// src/accumulate.cpp
#include "accumulate.h"

void accumulate(const data_t x[N], data_t *sum) {
    data_t acc = 0;
ACC:
    for (int i = 0; i < N; i++) {
        acc += x[i];
    }
    *sum = acc;
}
```

What blocks $I = 1$: `acc` is read and written in every iteration. Iteration $i+1$ reads the value iteration $i$ writes, and in float that write lands $D_{\text{add}}$ cycles after the read.

Why the tool will not rearrange the sum into a tree to break the chain: float addition is not associative. Changing the order of the additions changes the result bits, so a legal compiler must keep the order written in C. The testbench's `cancel` vector shows this in practice (see Q1).

### 2.2 `fir3` — interface contention

```cpp
// src/fir3.h
#pragma once
#ifndef DATA_T
#define DATA_T int
#endif
typedef DATA_T data_t;

const int N = 1024;
const int M = N - 2;   // one output per full 3-tap window

void fir3(const data_t x[N], data_t y[M]);
```

```cpp
// src/fir3.cpp
#include "fir3.h"

void fir3(const data_t x[N], data_t y[M]) {
TAPS:
    for (int i = 0; i < M; i++) {
        y[i] = x[i] + x[i + 1] + x[i + 2];
    }
}
```

This is a 3-tap FIR with all taps set to 1. The tap values do not matter for this exercise.

What blocks $I = 1$: three reads of `x` per iteration through one `ap_memory` port. A read puts the address out in one cycle and the data comes back on `x_q0` in the next, so the three reads need three separate cycles on the same port.

There is no dependency here: `y[i]` does not depend on any earlier `y`. The only writer of `y` touches its port once per iteration, so `y` is not contended either.

The tool will not notice that `x[i+1]` and `x[i+2]` were already read in the previous iteration. Keeping them in registers is a manual transformation (delay buffering, S2.2), and S2.2 applies it to this exact kernel.

---

## 3. Predict

Do all three stages before looking at any `pipe*` report.

### Stage A — shape only (before any run)

For each solution, write down: does it pipeline at the target? Is achieved II equal to target II? Will the area go up, stay the same, or go down relative to its own `seq`?

| project/solution    | II target | II achieved = 1? | area vs `seq` |
|---------------------|-----------|------------------|---------------|
| `accf_proj/pipe`    | 1         |                N |            up |
| `acci_proj/pipe`    | 1         |                Y |            up |
| `fir_proj/pipe`     | 1         |                N |            up |
| `fir_proj/pipe_2p`  | 1         |                N |            up |

<details><summary>Expected shape</summary>

- `accf/pipe`: refuses. Achieved II is about $D_{\text{add}}$. Area is close to `accf/seq`, because the achieved II is close to the sequential iteration latency. S1.1 found that every II in the range $2 \le I \le L$ reuses `seq`'s register boundaries (confirmed for $I = 2$; $I = 3, 4$ is the S1.1 open experiment).
- `acci/pipe`: achieves II=1. Area goes up the same way `vec_scale` did in S1.1.
- `fir/pipe`: refuses, achieved II=3. Area is close to `fir/seq` if $3 \ge L_{\text{seq}} - 1$, for the same reason as above.
- `fir/pipe_2p`: refuses, achieved II=2. Area is slightly above `fir/pipe` because of a second address/ce/q port set.

</details>

### Stage B — to the cycle (after the first pass)

**First pass.** In `run_hls.tcl`, set each project's `sols` list to `{seq}` only, and set `DO_COSIM 0`. Run it and open the three `seq` reports. Particularly the:

- `accf_proj/seq/syn/report/accumulate_csynth.rpt`: look for Loop table, `ACC` row: `Iteration Latency` → $L_\textrm{seq}$. Bind Op Report, fadd row: Latency → $D_{\textrm{add}}$. `accf/pipe` would be $I_\textrm{min}$ and $L_p$
- `acci_proj/seq/syn/report/accumulate_csynth.rpt`: look for Loop table, `ACC` row: `Iteration Latency` → $L_\textrm{seq}$. `acci/pipe` would be $L_p$
- `fir_proj/seq/syn/report/fir3_csynth.rpt`: look for Loop table, `TAPS` row: `Iteration Latency` → $L_\textrm{seq}$. `fir/pipe` and `fir/pip_2p` would be $L_p$

Now hand-compute the pipelined rows. Use the S1.1 finding that the effective pipelined depth is one less than the sequential iteration latency, $L_p \approx L_{\text{seq}} - 1$. That rule held on both S1.1 kernels, so treat it as the working rule and check it here.

| row                 | trips | $I_{\min}$ formula                   | ports on x | $L_\textrm{seq}$ | $D_\textrm{add}$ | $I_{\min}$  | $L_p$ | predicted loop $C$                        | predicted speedup vs own `seq` |
|---------------------|-------|--------------------------------------|------------|------------------|------------------|-------------|-------|-------------------------------------------|--------------------------------|
| `accf/seq`          | 1024  | (not pipelined)                      |          — |               14 |               10 |           — |     — | $1024 \cdot 14 = 14{,}336$                | —                              |
| `accf/pipe`         | 1024  | $\lceil D_{\text{add}}/1 \rceil$     |          — |               14 |               10 |          10 |    13 | $13 + 10 \cdot 1{,}023 = 10{,}243$        | $\approx 1.40$                 |
| `acci/seq`          | 1024  | (not pipelined)                      |          — |                3 |                0 |           — |     — | $1024 \cdot 3 = 3{,}072$                  | —                              |
| `acci/pipe`         | 1024  | $\lceil \delta/1 \rceil,\ \delta = 1$|          — |                3 |                0 |           1 |     2 | $2 + 1 \cdot 1{,}023 = 1{,}025$           | $\approx 3.00$                 |
| `fir/seq`           | 1022  | (not pipelined)                      |            |                4 |                — |           — |     — | $1022 \cdot 4 = 4{,}088$                  | —                              |
| `fir/pipe`          | 1022  | $\lceil 3/1 \rceil$                  |          1 |                4 |                — |           3 |     4 | $4 + 3 \cdot 1{,}021 = 3{,}067$           | $\approx 1.33$                 |
| `fir/pipe_auto`     | 1022  | $\lceil 3/1 \rceil$                  |          2 |                4 |                — |           2 |     3 | $3 + 2 \cdot 1{,}021 = 2{,}045$           | $\approx 2.00$                 |
| `fir/pipe_2p`       | 1022  | $\lceil 3/2 \rceil$                  |          2 |                4 |                — |           2 |     3 | $3 + 2 \cdot 1{,}021 = 2{,}045$           | $\approx 2.00$                 |


Speedup is loop C of own `seq` divided by predicted loop C. For `acci`, $D_\textrm{add} = 0$ but $\delta = 1$: the read of `acc`, the add and the register write take one cycle. Float `seq` vs int `pipe` (dtype and pipelining combined) is $14{,}336 / 1{,}025 \approx 14$.
Notice the trip count for `fir3` is $M = 1022$, not 1024.

Predicted speedup of `accf/pipe` over `accf/seq`:

$$\frac{1024 \cdot L_{\text{seq}}}{L_p + D_{\text{add}} \cdot 1023} \approx \frac{L_{\text{seq}}}{D_{\text{add}}}$$

With $L_{\text{seq}} = D_{\text{add}} + 1$, this is a small gain, of order $(D_{\text{add}}+1)/D_{\text{add}}$. Pipelining lets the read of `x[i+1]` overlap with the add of `x[i]`, and that is all it can do while the add is on the dependency cycle.

**One caveat to watch for.** The tool picks each operator's latency per solution. `fadd` in `pipe` may not have the same latency as in `seq`, because the tool may try a faster core to lower II. After the second pass, compare the two `Bind Op Report` rows. If they differ, that is a finding worth writing down, and $I_{\min}$ should follow the `pipe` value.

### Stage C — the log

Predict which violation messages each solution prints, and how many.

<details><summary>Expected pattern (confirm on your install)</summary>

In Vitis 2023.x, a refused II prints a warning like `[HLS 200-880] The II Violation in module ... (loop 'ACC'): Unable to enforce a carried dependence constraint (II = 1, distance = 1, ...)` between a `load` and a `store` of `acc`. A port conflict prints the same `II Violation` prefix with `Unable to schedule 'load' operation ... due to limited memory ports`, naming `x`. When scheduling succeeds, it prints `Pipelining result : Target II = 1, Final II = ..., Depth = ...`.

The message IDs above are what 2023.x logs normally show. Grep for the text rather than the IDs.

If the tool tries II values in order, you should see about $I_{\min} - 1$ violation lines per loop:

- `accf/pipe`: about $D_{\text{add}} - 1$ dependency violations, distance = 1.
- `acci/pipe`: none.
- `fir/pipe`: two port violations on `x` (at II = 1 and 2).
- `fir/pipe_2p`: one port violation (at II = 1).

The "one line per rejected II" count is an inference from how the scheduler searches. Check it and write down what you actually see.

</details>

---

## 4. Apply

### 4.1 The script

```tcl
# s1_model/02_pipeline_blockers/run_hls.tcl
# Run:  vitis_hls -f run_hls.tcl 2>&1 | tee run.log

# ---- knobs ------------------------------------------------------------
# Pass 1 (stage B): every sols list = {seq}, DO_COSIM 0.
# Pass 2: full lists below, DO_COSIM 1.
set RUNS {
    accf_proj {kernel accumulate dtype float sols {seq pipe}}
    acci_proj {kernel accumulate dtype int   sols {seq pipe}}
    fir_proj  {kernel fir3       dtype int   sols {seq pipe pipe_2p}}
}
set DO_COSIM 1
# -----------------------------------------------------------------------

foreach {proj cfg} $RUNS {
    set kernel [dict get $cfg kernel]
    set dtype  [dict get $cfg dtype]
    set sols   [dict get $cfg sols]

    open_project -reset $proj
    set_top $kernel
    add_files     src/${kernel}.cpp    -cflags "-DDATA_T=$dtype"
    add_files -tb src/tb_${kernel}.cpp -cflags "-DDATA_T=$dtype"

    set first 1
    foreach sol $sols {
        open_solution -reset $sol -flow_target vivado
        source ../../common/part.tcl

        set dfile ./directives_${kernel}_${sol}.tcl
        if {[file exists $dfile]} { source $dfile }

        if {$first} { csim_design; set first 0 }
        csynth_design
        if {$DO_COSIM} { cosim_design }
    }
    close_project
}
exit
```

Directive files are named `directives_<kernel>_<solution>.tcl`, so both `accumulate` projects share one `pipe` file. `seq` has no file, and the guard skips it.

Check the `source ../../common/part.tcl` path against the one S1.1 uses.

All three project names end in `_proj`, so `make clean` already covers them.

### 4.2 The directives

```tcl
# directives_accumulate_pipe.tcl
set_directive_pipeline -II 1 "accumulate/ACC"
```

```tcl
# directives_fir3_pipe.tcl
set_directive_pipeline -II 1 "fir3/TAPS"
```

```tcl
# directives_fir3_pipe_2p.tcl
set_directive_pipeline -II 1 "fir3/TAPS"
set_directive_interface -mode ap_memory -storage_type ram_2p "fir3" x
```

`-storage_type` on `set_directive_interface` is how a top-level `ap_memory` port gets more than one port set [2]. `BIND_STORAGE` is for arrays inside the design, not for top-level arguments. If 2023.2 rejects the option, run `vitis_hls -i` and then `help set_directive_interface` to see the accepted spelling.

### 4.3 Testbenches

Both testbenches follow the repo shape:

- a separate `ref()` reference model;
- a POISON value in every output before each call;
- directed vectors first, then seeded random vectors;
- errors are counted rather than stopping at the first one;
- a non-zero return from `main` on any failure;
- `__RTL_SIMULATION__` to cut the random count in cosim.

The first printed line shows the dtype. This confirms the `-cflags` reached the build: `accf_proj` must print `float`.

```cpp
// src/tb_accumulate.cpp
#include <cstdio>
#include <limits>
#include <random>
#include "accumulate.h"

#define STR_(s) #s
#define STR(s)  STR_(s)

#ifdef __RTL_SIMULATION__
static const int N_RANDOM = 4;
#else
static const int N_RANDOM = 64;
#endif

static const data_t POISON = (data_t)-12345;
// Integer builds use raw ints; float builds scale to fractional values.
static const data_t SCALE  = std::numeric_limits<data_t>::is_integer ? 1 : 1000;

static data_t ref(const data_t x[N]) {
    data_t acc = 0;
    for (int i = 0; i < N; i++) acc += x[i];   // same order as the kernel
    return acc;
}

static int check(const char *name, const data_t x[N]) {
    data_t got = POISON;
    accumulate(x, &got);
    data_t exp = ref(x);
    // Exact compare on purpose: same order of additions, so bit-exact is expected.
    if (got != exp) {
        std::printf("FAIL %-10s got %.9g expected %.9g\n", name, (double)got, (double)exp);
        return 1;
    }
    return 0;
}

int main() {
    std::printf("tb_accumulate: dtype=%s N=%d N_RANDOM=%d\n", STR(DATA_T), N, N_RANDOM);
    int errors = 0;
    data_t x[N];

    // --- directed ------------------------------------------------------
    for (int i = 0; i < N; i++) x[i] = 0;
    errors += check("zeros", x);

    for (int i = 0; i < N; i++) x[i] = 1;
    errors += check("ones", x);

    // Order-sensitive in float: 1e8 + 1 rounds back to 1e8 in single precision,
    // so the ones in the middle vanish. A different order would not lose them.
    x[0] = (data_t)100000000;
    for (int i = 1; i < N - 1; i++) x[i] = 1;
    x[N - 1] = (data_t)-100000000;
    errors += check("cancel", x);
    std::printf("cancel vector: ref sum = %.9g (int build: 1022)\n", (double)ref(x));

    for (int i = 0; i < N; i++) x[i] = (i % 2) ? (data_t)-1000 : (data_t)1000;
    errors += check("alt", x);

    // --- random (fixed seed: cosim replays the same stimulus) ---------
    std::mt19937 rng(42);
    for (int v = 0; v < N_RANDOM; v++) {
        for (int i = 0; i < N; i++) {
            int r = (int)(rng() % 2001) - 1000;   // bounded: no int overflow over 1024 terms
            x[i] = (data_t)r / SCALE;
        }
        errors += check("random", x);
    }

    std::printf("%s: %d error(s)\n", errors ? "FAILED" : "PASSED", errors);
    return errors ? 1 : 0;
}
```

```cpp
// src/tb_fir3.cpp
#include <cstdio>
#include <random>
#include "fir3.h"

#define STR_(s) #s
#define STR(s)  STR_(s)

#ifdef __RTL_SIMULATION__
static const int N_RANDOM = 4;
#else
static const int N_RANDOM = 64;
#endif

static const data_t POISON = (data_t)-12345;

static void ref(const data_t x[N], data_t y[M]) {
    for (int i = 0; i < M; i++) y[i] = x[i] + x[i + 1] + x[i + 2];
}

static int check(const char *name, const data_t x[N]) {
    data_t got[M], exp[M];
    for (int i = 0; i < M; i++) got[i] = POISON;
    fir3(x, got);
    ref(x, exp);
    int bad = 0;
    for (int i = 0; i < M; i++) {
        if (got[i] != exp[i]) {
            if (bad < 4) std::printf("FAIL %-8s y[%d] got %d expected %d\n",
                                     name, i, (int)got[i], (int)exp[i]);
            bad++;
        }
    }
    return bad ? 1 : 0;
}

int main() {
    std::printf("tb_fir3: dtype=%s N=%d M=%d N_RANDOM=%d\n", STR(DATA_T), N, M, N_RANDOM);
    int errors = 0;
    data_t x[N];

    // --- directed ------------------------------------------------------
    for (int i = 0; i < N; i++) x[i] = 0;
    errors += check("zeros", x);

    // Impulse at k: y[k-2], y[k-1], y[k] must be 1, all else 0. Checks every tap position.
    for (int i = 0; i < N; i++) x[i] = 0;
    x[100] = 1;
    errors += check("impulse", x);

    for (int i = 0; i < N; i++) x[i] = i;
    errors += check("ramp", x);

    for (int i = 0; i < N; i++) x[i] = 1000000;     // 3e6: large but no overflow
    errors += check("const", x);

    // --- random -------------------------------------------------------
    std::mt19937 rng(42);
    for (int v = 0; v < N_RANDOM; v++) {
        for (int i = 0; i < N; i++) x[i] = (int)(rng() % 2000001) - 1000000;
        errors += check("random", x);
    }

    std::printf("%s: %d error(s)\n", errors ? "FAILED" : "PASSED", errors);
    return errors ? 1 : 0;
}
```

### 4.4 The "fixes" that are not transformations

This exercise removes each blocker in the cheapest possible way. Neither way is a real HLS transformation.

- **int instead of float.** This changes the kernel rather than restructuring it. The dependency stays; only $\delta$ drops to 1. It works only because int addition happens to fit in one cycle.
- **`ram_2p`.** This adds a port rather than removing an access. It reaches only $\lceil 3/2 \rceil = 2$, and a top-level RAM interface has no third read port to offer.

The transformations that keep float semantics and one port come in S2. S2.1.3 (single-loop interleaving) splits the dependency on `accumulate`. S2.2 (delay buffering) takes `fir3` to one access per iteration.

---

## 5. Measure

Second pass: restore the full `sols` lists, set `DO_COSIM 1`, and run.

### 5.1 csynth

For each solution, record the following from `csynth.rpt`:

- **Loop table:** `Iteration Latency`, II `achieved`, II `target`, `Trip Count`, loop `Latency (cycles)`.
  - Remember that the II heading spans two sub-columns.
  - Remember that for pipelined rows, `Iteration Latency` is one more than the effective depth.
- **Summary of Overall Latency:** function latency, max column. This goes into `latency_est`.
- **Bind Op Report:** latency of `fadd` (`accf` only), in both `seq` and `pipe`.
- **Utilization Estimates, Total row:** LUT, FF, DSP, BRAM.
- **Timing:** estimated clock period, for `fmax_est`.

To collect the resource tables, use the S0.4 helper (it reads env overrides):

```bash
H=../../common/collect_resources.sh
PROJ=accf_proj TOP=accumulate SOLS="seq pipe"         OUT=res_accf.md $H
PROJ=acci_proj TOP=accumulate SOLS="seq pipe"         OUT=res_acci.md $H
PROJ=fir_proj  TOP=fir3       SOLS="seq pipe pipe_2p" OUT=res_fir.md  $H
```

This is the helper's third caller (S0.4, S1.1, now S1.2), so it is a good moment to move it to `common/`.

To confirm `pipe_2p` really has two ports on `x`:

```bash
grep -oE "x_(address|ce|q)[01]" fir_proj/pipe_2p/syn/verilog/fir3.v | sort -u
grep -oE "x_(address|ce|q)[01]" fir_proj/pipe/syn/verilog/fir3.v    | sort -u
```

Expect `address0/1`, `ce0/1`, `q0/1` for `pipe_2p`, and only the `0` set for `pipe`.

If `pipe` also shows a `1` set, the tool gave the top-level array two ports by default. Then `pipe` should come back at II=2, not 3. Record that and correct the $P$ used in section 1.

Fill in:

| row             | II tgt | II ach | Iter. Lat. (col) | loop C | Fn lat (max) | LUT | FF  | DSP | BRAM | fadd lat     |
|-----------------|--------|--------|------------------|--------|--------------|-----|-----|-----|------|--------------|
| `accf/seq`      | —      |      — |               14 | 14,336 |       14,337 | 356 | 491 |   2 |    0 | 10 (fulldsp) |
| `accf/pipe`     | 1      |      7 |               10 |  7,170 |        7,172 | 541 | 460 |   0 |    0 | 7 (fabric)   |
| `acci/seq`      | —      |      — |                3 |  3,072 |        3,073 | 120 |  79 |   0 |    0 | —            |
| `acci/pipe`     | 1      |      1 |                3 |  1,025 |        1,027 | 136 |  81 |   0 |    0 | —            |
| `fir/seq`       | —      |      — |                4 |  4,088 |        4,089 | 169 | 109 |   0 |    0 | —            |
| `fir/pipe`      | 1      |      3 |                5 |  3,067 |        3,069 | 215 | 143 |   0 |    0 | —            |
| `fir/pipe_auto` | 1      |      2 |                4 |  2,045 |        2,047 | 192 | 142 |   0 |    0 | —            |
| `fir/pipe_2p`   | 1      |      2 |                4 |  2,045 |        2,047 | 192 | 142 |   0 |    0 | —            |

Checks against stage B:

1. II achieved matches $I_{\min}$ on every pipelined row.
2. Loop C matches $L_p + I_{\min}(\text{trips}-1)$, with $L_p$ = column − 1. Use S1.1's method: solve $L_p$ from the reported C and the achieved II, then compare it with the column.
3. `accf/pipe` area is close to `accf/seq`, and `acci/pipe` area is clearly above `acci/seq`.

### 5.2 Log diagnostics

```bash
grep -nE "Running: open_(project|solution)|II Violation|Pipelining result" run.log
```

The `Running:` lines echo each Tcl command as it runs, so they split the output into project/solution blocks. Both `accumulate` projects name the module `accumulate`, so use those markers to tell them apart.

For each pipelined solution, record:

- the number of violation lines;
- the reason text (carried dependence, or limited memory ports);
- the named operations or port;
- the `distance` value (dependency case);
- the `Final II` and `Depth` from `Pipelining result`.

Check two things:

- `distance = 1` in `accf/pipe`. This matches $d = 1$ in the model.
- `Depth` against the loop table. `Depth` is a second, independent reading of pipeline depth. Does it agree with the `Iteration Latency` column, or with the column minus one?

### 5.3 Cosim

Read the latency line of each `<proj>/<sol>/sim/report/*cosim.rpt`. It reports function-level min/avg/max.

- All three kernels are fully static, so expect min = avg = max, as in S1.1.
- For the pipelined rows, S1.1 found cosim equal to loop C. Check whether that holds again, especially on `accf/pipe`, where the float core is the new element.
- Also confirm `accf` passes cosim at all. The testbench compares exactly, so a pass means the float core added in the same order as the C code.

| row             | cosim min/avg/max     | loop C (5.1) | cosim − loop C |
|-----------------|-----------------------|--------------|----------------|
| `accf/seq`      | 14337 / 14337 / 14337 |       14,336 |             +1 |
| `accf/pipe`     |  7170 /  7170 /  7170 |        7,170 |              0 |
| `acci/seq`      |  3073 /  3073 /  3073 |        3,072 |             +1 |
| `acci/pipe`     |  1025 /  1025 /  1025 |        1,025 |              0 |
| `fir/seq`       |  4089 /  4089 /  4089 |        4,088 |             +1 |
| `fir/pipe`      |  3067 /  3067 /  3067 |        3,067 |              0 |
| `fir/pipe_auto` |  2045 /  2045 /  2045 |        2,045 |              0 |
| `fir/pipe_2p`   |  2045 /  2045 /  2045 |        2,045 |              0 |

Record the gap in absolute cycles (S1.1 convention).

### 5.4 results.csv

These are the first rows in the repo where `II_target` and `II_achieved` differ, which is what the pair of columns was added for.

Column rules (from S1.1):

- `latency_est` and `latency_cosim` are function-level.
- For unpipelined rows, `II_target` is blank and `II_achieved` is $L$, with a note.
- `sweep_*` columns stay blank.
- `fmax_impl` is `?`.

```csv
exercise,kernel,variant,dtype,N,sweep_param,sweep_value,II_target,II_achieved,latency_est,latency_cosim,LUT,FF,DSP,BRAM,fmax_est,fmax_impl,notes
s1.2,accumulate,seq,float,1024,,,,<L>,<>,<>,<>,<>,<>,<>,<>,?,unpipelined; II_achieved=L by substitution
s1.2,accumulate,pipe,float,1024,,,1,<>,<>,<>,<>,<>,<>,<>,<>,?,dependency blocker; fadd lat=<>; distance=1
s1.2,accumulate,seq,int,1024,,,,<L>,<>,<>,<>,<>,<>,<>,<>,?,unpipelined; II_achieved=L by substitution
s1.2,accumulate,pipe,int,1024,,,1,<>,<>,<>,<>,<>,<>,<>,<>,?,same dependency; delta=1 so no blocker
s1.2,fir3,seq,int,1022,,,,<L>,<>,<>,<>,<>,<>,<>,<>,?,unpipelined; trips=M=N-2
s1.2,fir3,pipe,int,1022,,,1,<>,<>,<>,<>,<>,<>,<>,<>,?,port blocker; A=3 P=1
s1.2,fir3,pipe_2p,int,1022,,,1,<>,<>,<>,<>,<>,<>,<>,<>,?,port blocker; A=3 P=2 (ram_2p)
```

The `N` column holds the loop trip count, so `fir3` gets 1022. If you prefer `N` to always be the array size, write 1024 and put `trips=1022` in `notes`, but choose one and keep it for the rest of the repo.

### 5.5 Optional extras

**a. Auto-pipelining hits the same wall.** Add a solution `auto` to `accf_proj` and `fir_proj` that does *not* source `common/part.tcl`. Set the part and clock inline instead, the same way probe D did.

Probe D showed that a loop of 1024 trips is auto-pipelined under the tool defaults. So you should get the same achieved II as `pipe`, plus the same violation lines, even without asking. This settles the "should S1.2 run with the suppression removed" question with data, not argument.

**b. Relaxed float math.** Add `pipe_unsafe` to `accf_proj`. Use the `pipe` directives, plus this line after `source ../../common/part.tcl`:

```tcl
config_compile -pipeline_loops 0 -unsafe_math_optimizations
```

Keep `-pipeline_loops 0` on the same line, in case a second `config_compile` call resets options it does not mention.

The switch lets the tool ignore some IEEE rules, such as signed zero. Record whether it changes `fadd` latency, the achieved II, or neither. The `cancel` vector in the testbench tells you whether the result changed.

Do not assume in advance that it lowers II. A carried reduction still needs restructuring, and that is what interleaving does (S2.1.3).

---

## 6. Questions

**Q1.** The `accf/pipe` loop spends most of each iteration waiting on one adder. Why doesn't Vitis just split the sum into two running halves, or a tree, to cut the dependency?

<details><summary>Answer</summary>

Because that changes the result. Float addition is not associative: $(a+b)+c$ and $a+(b+c)$ can round differently.

The `cancel` vector makes this visible. Added in order, $10^8 + 1$ rounds back to $10^8$ in single precision every time, so the 1022 ones vanish and the sum is 0. The int build of the same vector gives 1022. Any tree that grouped the ones together first would also give about 1022 in float.

C semantics fix the order of the float additions. A tool that reorders them without permission is producing a different program. Loop interleaving (S2.1.3) makes the reordering an explicit choice by the designer, who accepts the numerical change in exchange for a smaller $I$ [1, Sec. 3].

</details>

**Q2.** `pipe_2p` reaches II=2. What would it take to reach II=1 on `fir3`, and which options keep the default single port?

<details><summary>Answer</summary>

From $I_{\text{port}} = \lceil A/P \rceil$, reaching 1 needs $P \ge A$. There are two ways to get there.

**Raise $P$ to 3.** A top-level RAM interface does not offer a third read port, so the extra ports would have to come from partitioning the array into separate memories (S3.0). For a window that slides over the whole array, that is costly.

**Lower $A$ to 1.** Read each new sample once, and keep the previous two in registers: `x[i+2]` is read, `x[i+1]` and `x[i]` come from a 2-deep shift register. That gives $A = 1$ on a single port, so II=1.

Lowering $A$ is delay buffering (S2.2). It keeps the default single-port interface, costs two registers, and also makes `x` readable as a stream, since the reads are now strictly in order.

</details>

**Q3.** `acci/pipe` has the same loop-carried dependency as `accf/pipe`, yet reaches II=1. Under what change would the int build also refuse II=1?

<details><summary>Answer</summary>

When $\delta$ goes above 1, meaning the add, the register write and the feedback mux no longer fit in one clock period.

The tool is really scheduling against the 3.33 ns period minus the 0.90 ns uncertainty, about 2.43 ns (see `notes/env.md`). Two changes push the int add past that:

- a much wider accumulator, such as a very wide `ap_int`;
- a tighter clock.

In both cases the tool must register the add, which gives $\delta = 2$, so $I_{\text{dep}} = 2$.

The dependency is not the blocker by itself. The blocker is the dependency *combined with* an operator slower than one cycle. This is also why type demotion (S4.4) can act as a pipelining transformation and not only as an area one: a narrower type can bring $\delta$ back down to 1.

</details>

---

## References

[1] J. de Fine Licht, M. Besta, S. Meierhans, T. Hoefler, "Transformations of High-Level Synthesis Codes for High-Performance Computing," *IEEE Trans. Parallel and Distributed Systems*, 32(5), 2021. arXiv:1805.08288. Sec. 3, pipeline-enabling transformations; the loop-carried dependency and memory-access limits that motivate interleaving and delay buffering.

[2] AMD, *Vitis High-Level Synthesis User Guide* (UG1399), version matching 2023.2. Reference pages for `set_directive_pipeline` and `set_directive_interface` (`-mode ap_memory`, `-storage_type`); pipelining discussion of loop dependencies and limited memory ports; `config_compile` options.

[3] R. Kastner, J. Matai, S. Neuendorffer, *Parallel Programming for FPGAs* (open access), Ch. 3, Finite Impulse Response (FIR) Filters: a worked FIR in HLS, including the II effect of array accesses and the shift-register rewrite that S2.2 builds on.