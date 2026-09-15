# S1.1 — Latency, II, and `C = L + I(N-1)`

**Exercise dir:** `s1_model/01_latency_and_ii/`
**Kernel:** `vec_scale` (new to the spine: array in, array out)
**Runs:** csim once, csynth on 5 solutions, cosim on 3, plus a throwaway probe project
**Format note:** this is the first exercise on the six-section template. Section 1 is
called "The model" rather than "The transformation", because S1.1 is not a
transformation — it is the measuring stick used by every transformation after it.

---

## 0. Why this exercise exists

Every later exercise ends with a number: an II, a latency, a speedup. Those numbers
are worthless if you cannot say where they come from. This lesson pins down three
things:

1. The performance model itself, and exactly which columns of the Vitis report
   correspond to which symbol.
2. The **cosim gap** — how far the scheduler's estimate is from what the RTL
   actually does, and why the gap exists at all.
3. `LOOP_TRIPCOUNT` — the one directive in the whole toolkit that changes the
   report and *nothing else*, which is a useful thing to have proven to yourself
   before you start trusting reports.

It also clears the outstanding **probe D** from S0.1: the auto-pipelining
threshold on this install. See the appendix.

**Solution names used throughout.** Five solutions across two projects,
defined in `run_hls.tcl` (section 4):

| solution | project | what it is |
|---|---|---|
| `seq` | `hls_proj` | baseline, loop not pipelined (sequential) |
| `pipe` | `hls_proj` | same loop, `PIPELINE II=1` |
| `pipe_ii2` | `hls_proj` | same loop, `PIPELINE II=2` |
| `notc` | `tc_proj` | runtime trip count, no `LOOP_TRIPCOUNT` |
| `tc` | `tc_proj` | runtime trip count, with `LOOP_TRIPCOUNT` |

---

## 1. The model

A loop body is a chunk of scheduled hardware. Two independent times describe it:

- **Iteration latency, $L$** — cycles from the start of one iteration to the
  moment that iteration's result is finished. This is a property of the datapath:
  memory read time, multiplier depth, write time.
  $L$ is the full span of one iteration, from the cycle it issues its load to the cycle its store completes. It includes the loading cycles. It is the depth of the body's pipeline.
- **Initiation interval, $I$** — cycles between the *start* of one iteration and
  the *start* of the next. This is a property of the resource conflicts and data
  dependencies, not of the datapath depth.
  $I$ the gap between the start of iteration $i$ and the start of iteration $i+1$. It says nothing about how long either one takes.

Concretely, suppose the body schedules as read (1 cycle), multiply (2), add (1), write (1), so $L=5$. At $I=1$:

```txt
cycle:   0    1    2    3    4    5    6    7
iter 0: rd   mul  mul  add  wr
iter 1:      rd   mul  mul  add  wr
iter 2:           rd   mul  mul  add  wr
iter 3:                rd   mul  mul  add  wr
```

Iteration 0 spans cycles 0–4, so $L=5$. Iteration 1 starts one cycle after iteration 0, so $I=1$. Iteration 1's load happens at cycle 1, while iteration 0 is still multiplying. That overlap is the entire point of pipelining — and it's why $L$ stops mattering for throughput once the pipe is full.

With trip count $N$, the loop occupies

$$C = L + I\,(N-1)$$

cycles. The last iteration starts at cycle $I(N-1)$ and takes $L$ more to finish.

Two corner cases are worth writing out, because they bound everything you will do
in S2–S4:

- **Not pipelined.** Each iteration must complete before the next starts, so
  $I = L$ and $C = L + L(N-1) = LN$. Time is linear in $N$ with slope $L$.
- **Perfectly pipelined.** $I = 1$, so $C = L + N - 1$. Time is linear in $N$ with
  slope 1, and $L$ has decayed into a constant offset — the pipeline fill.

So pipelining buys you a factor of roughly $L$, and then it is done. It cannot buy
more, because $I \geq 1$ as long as one iteration is started per cycle. Getting
below $I = 1$ effective requires doing more than one iteration's work per start,
which is vectorization (S3.1) or replication (S3.2). This is the single most
useful consequence of the model: **pipelining and scaling are different levers and
they compose multiplicatively.**

Reference: de Fine Licht, Besta, Meierhans, Hoefler, *Transformations of
High-Level Synthesis Codes for High-Performance Computing*, IEEE TPDS 32(5),
2021 (arXiv:1805.08288) — background sections, where the same model is stated and
then used to classify all 15 transformations. Also Kastner, Matai, Neuendorffer,
*Parallel Programming for FPGAs*, ch. 2, for a slower walk through II.

### Where each symbol appears in the Vitis report

In the `Loop` table of `<solution>/syn/report/<top>_csynth.rpt`:

| Report column | Symbol | Note |
|---|---|---|
| `Trip Count` | $N$ | blank or `?` when the bound is a runtime value |
| `Iteration Latency` | $L$ | |
| `Initiation Interval` | $I$ | shown as `-` when the loop is not pipelined |
| `Latency` | $C$ | this is the whole loop, not one iteration |
| `Pipelined` | — | `yes` / `no`; check this before believing anything else |

In the `Summary of timing and resource` / function-level table:

- Function `Latency` = loop $C$ + a small amount of pre/post overhead (argument
  registration, the write of any scalar return).
- Function `Interval` = how often a *new call* can start. For a plain
  `ap_ctrl_hs` function that is not itself pipelined or in dataflow, expect
  `Latency + 1`.

Read those two tables as answering different questions: the loop table is about
the loop, the function table is about the module's contract with whoever calls it.

---

## 2. The blocker

This is the one exercise where nothing is structurally wrong with the code. The
naive variant is slow for a policy reason, not a hardware reason.

`common/part.tcl` sets `config_compile -pipeline_loops 0`. That is the standing
convention from S0.1: it disables Vitis 2023.2's automatic pipelining so that
every "before" case in this repo is genuinely a before case. Without it, a loop
whose trip count is at or above the threshold (nominally 64 — probe D confirms the
number on this install) is pipelined with no pragma at all, and half the exercises
in S2 would appear to do nothing.

So in `seq`, the blocker is: **the tool was told not to pipeline.** Remove the
prohibition with an explicit `set_directive_pipeline` and it goes away.

There is one real structural constraint hiding here, and it is worth naming now
because S1.2 and S3.0 are built on it. $I = 1$ means one iteration is *started*
every cycle, which means every memory access in the body must be serviceable once
per cycle. The body does exactly one read of `x` and one write of `y`. Under the
default `ap_memory` interface each array gets its own port, so one read per cycle
from one array and one write per cycle to a different array is fine — $I = 1$ is
reachable. Change the body to read `x[i]` *and* `x[i+1]`, or to accumulate into a
single array, and it stops being reachable. That is S1.2's subject.

---

## 3. Predict

**Do not skip this. Write the numbers down before you run anything.**

This exercise splits the prediction into two stages, because you do not yet know
$L$ for this datapath and guessing it is not the point. The point is that once you
know $L$, the model should predict everything else exactly.

### Stage A — before any synthesis

Fill in the shape, not the numbers:

1. For `seq` (not pipelined), $C \approx \underline{\hspace{2cm}} \times N$, i.e.
   $C$ should be $L \cdot N$ with $N = 1024$.

<details><summary>Answer</summary>

From the earlier: $C = L + I(N-1)$ and say $I = L$ and say $N$ is very high, then this approaches $L\times N$

</details>

2. For `pipe` (II=1), $C = L + \underline{\hspace{2cm}}$.

<details><summary>Answer</summary>

From the earlier: $C = L + I(N-1)$ and say $I = 1$ and say $N$ is very high, then this approaches $L + N - 1$

</details>

3. Expected speedup of `pipe` over `seq`, in terms of $L$ alone:
   $\underline{\hspace{2cm}}$.

<details><summary>Answer</summary>

Speed-up is:

$$ \textrm{speedup} = \frac{LN}{L+N-1} $$

Then, when $N \gg L$ we have $\textrm{speedup} \approx L$

</details>

4. Resource direction, `seq` → `pipe`: LUT/FF go **up / down / flat**? Why?

<details><summary>Answer</summary>

Both LUT and FF change up and down. Specficially:

Think about what the FSM looks like in each case. In seq, the loop body is sequenced across `L` cycles, so the controller has roughly `L` states to walk through per iteration. In pipe, the steady state is one state — every stage fires every cycle — and the fill/drain are handled by counters and stage-enable flags rather than distinct states. So the FSM gets simpler while the pipeline control logic gets added. Those pull in opposite directions.

Also worth sharpening your `FF` reasoning into something quantitative, since it'll recur every time you widen a pipeline in S3: `FF` is roughly (live values per stage) × (iterations in flight). `seq` has one iteration in flight; `pipe` has  `L`. That's the mechanism, and it predicts the rough magnitude of the jump, not just its sign.

</details>

5. DSP count in both: $\underline{\hspace{2cm}}$. (One `int` multiply in the body.
   Pipelining does not add multipliers — it adds registers.)

<details><summary>Answer</summary>

DSP count never changes in here.

</details>

A reasonable prior for $L$ on this part with `data_t = int` is somewhere in the
range 3–7 cycles: one cycle of BRAM read on `x`, a couple for the 32×32 multiply
mapped onto a DSP48, possibly one for the add if it is not absorbed into the DSP,
one to write `y`. If your measured $L$ lands far outside that, stop and open the
schedule viewer before continuing — something is different from what you think.

### Stage B — after the `seq` run, before the `pipe` run

Read $L$ off the `seq` report's `Iteration Latency` column. Now compute and write
down, to the cycle:

**Note**: We have to run the `run_hls.tcl` first to at least get the `Latency Iteration` or $L$ so that we know the value. Then do a sanity check to see if the numbers make sense. When ran, you get $L=5$.

| Quantity | Formula | Your number |
|---|---|---|
| $C$ for `seq` | $L \times 1024$ | $5 \times 1024 = 5120$ |
| $C$ for `pipe` (II=1) | $L + 1023$ | $5 + 1023 = 1028$ |
| $C$ for `pipe_ii2` (II=2) | $L + 2 \times 1023$ | $5 + 2\times 1023 = 2051$ |
| Function latency, `pipe` | $C$ + overhead (guess the overhead) | 1027 |
| Function interval, `pipe` | | 1027 |

Then run them. The `pipe` and `pipe_ii2` numbers should match your arithmetic
exactly, not approximately. If they do not, the discrepancy is the lesson — chase
it down in the schedule viewer rather than shrugging.

### Stage C — the tripcount prediction

For `notc` vs `tc` on `vec_scale_n`, predict:

- What appears in the `Latency` and `Trip Count` columns for `notc`.
- Whether LUT, FF, DSP, BRAM differ between `notc` and `tc`: **yes / no**.

Commit to that second answer in writing. It is the whole point of section 5.3.

---

## 4. Apply

### Files

```
s1_model/01_latency_and_ii/
  README.md                  this file
  run_hls.tcl                two projects, five solutions
  run_hls_probe.tcl          probe D only, deleted afterwards
  src/vec_scale.h            typedef + N + both prototypes
  src/vec_scale.cpp          fixed trip count
  src/vec_scale_n.cpp        runtime trip count
  src/probe.cpp              probe D only, deleted afterwards
  src/tb.cpp                 testbench for vec_scale (csim + cosim)
  src/tb_n.cpp               testbench for vec_scale_n (csim only)
  directives_seq.tcl
  directives_pipe.tcl
  directives_pipe_ii2.tcl
  directives_notc.tcl
  directives_tc.tcl
```

Deviation from the repo convention, same one as S0.4: one
`directives_<solution>.tcl` per solution instead of a single `directives.tcl`.
With five solutions in one script there is no other clean way to keep the kernel
source byte-identical across variants.

Second deviation: **two projects in one `run_hls.tcl`**. `vec_scale` and
`vec_scale_n` are different top functions, and a testbench that calls a non-top
design function will not cosim cleanly. Rather than rely on re-issuing `set_top`
between solutions of one project, the script closes `hls_proj` and opens
`tc_proj`. The cost is a second project directory; the benefit is that cosim on
project 1 is unambiguous. Both get cleaned by the root `Makefile`, which globs
`*_proj`.

### `src/vec_scale.h`

```c
#ifndef VEC_SCALE_H_
#define VEC_SCALE_H_

typedef int data_t;     // one-line change point: float side-experiment, and S4.4
#define N 1024

void vec_scale  (data_t a, data_t b, const data_t x[N], data_t y[N]);
void vec_scale_n(data_t a, data_t b, const data_t x[N], data_t y[N], int n);

#endif
```

### `src/vec_scale.cpp`

```c
#include "vec_scale.h"

void vec_scale(data_t a, data_t b, const data_t x[N], data_t y[N]) {
VS_LOOP:
    for (int i = 0; i < N; i++) {
        y[i] = a * x[i] + b;
    }
}
```

### `src/vec_scale_n.cpp`

```c
#include "vec_scale.h"

void vec_scale_n(data_t a, data_t b, const data_t x[N], data_t y[N], int n) {
VSN_LOOP:
    for (int i = 0; i < n; i++) {
        y[i] = a * x[i] + b;
    }
}
```

The only difference is `i < n` instead of `i < N`. `n` is an argument, so the
scheduler has no way to know the trip count.

### `src/tb.cpp`

Same shape as the `tiny` and `scale` testbenches: separate `ref()`, poison before
each call, directed vectors first, then seeded randoms, count errors, non-zero
return on failure, fixed seed because cosim replays the same stimulus.

```c
#include <cstdio>
#include <cstdlib>
#include "vec_scale.h"

#ifdef __RTL_SIMULATION__
static const int NUM_CALLS = 2;
#else
static const int NUM_CALLS = 8;
#endif

static const data_t POISON = (data_t)0xDEADBEEF;

// Reference model. The unsigned cast makes overflow well-defined in C++;
// the RTL just wraps. If you switch data_t to float, drop the casts.
static void ref(data_t a, data_t b, const data_t x[N], data_t y[N]) {
    for (int i = 0; i < N; i++)
        y[i] = (data_t)((unsigned)a * (unsigned)x[i] + (unsigned)b);
}

int main() {
    printf("NUM_CALLS = %d\n", NUM_CALLS);   // first line: confirms the macro from run.log

    static data_t x[N], y[N], y_ref[N];
    int errors = 0;

    for (int call = 0; call < NUM_CALLS; call++) {
        data_t a, b;

        if (call == 0)      { a = 0;  b = 0;  for (int i=0;i<N;i++) x[i] = i; }
        else if (call == 1) { a = 1;  b = -1; for (int i=0;i<N;i++) x[i] = -i; }
        else if (call == 2) { a = (data_t)0x7FFFFFFF; b = 1;          // force overflow
                              for (int i=0;i<N;i++) x[i] = 3; }
        else                { srand(1234 + call);
                              a = rand(); b = rand();
                              for (int i=0;i<N;i++) x[i] = rand() - RAND_MAX/2; }

        for (int i = 0; i < N; i++) y[i] = POISON;   // catch "kernel never wrote"

        ref(a, b, x, y_ref);
        vec_scale(a, b, x, y);

        for (int i = 0; i < N; i++) {
            if (y[i] != y_ref[i]) {
                if (errors < 10)
                    printf("call %d idx %d: got %d expected %d\n",
                           call, i, (int)y[i], (int)y_ref[i]);
                errors++;
            }
        }
    }

    printf(errors ? "FAIL: %d mismatches\n" : "PASS\n", errors);
    return errors ? 1 : 0;
}
```

`src/tb_n.cpp` is the same with `n` swept over a few values — use `{1, 17, 512,
1024}` so the `avg` you give `LOOP_TRIPCOUNT` is visibly wrong for most calls.
That is deliberate; see Q3.

### `src/tb.cpp`

```c
#include <cstdio>
#include <cstdlib>
#include "vec_scale.h"

// csynth-only exercise — no cosim on this project, so no __RTL_SIMULATION__ guard.
static const int NUM_TRIPS = 4;
static const int TRIPS[NUM_TRIPS] = {1, 17, 512, 1024};

static const data_t POISON = (data_t)0xDEADBEEF;

// Reference model. Unsigned cast makes overflow well-defined in C++;
// the RTL just wraps. If you switch data_t to float, drop the casts.
static void ref_n(data_t a, data_t b, const data_t x[N], data_t y[N], int n) {
    for (int i = 0; i < n; i++)
        y[i] = (data_t)((unsigned)a * (unsigned)x[i] + (unsigned)b);
}

int main() {
    static data_t x[N], y[N], y_ref[N];
    int errors = 0;

    for (int call = 0; call < NUM_TRIPS; call++) {
        const int n = TRIPS[call];

        srand(1234 + call);
        data_t a = rand();
        data_t b = rand();
        for (int i = 0; i < N; i++) x[i] = rand() - RAND_MAX / 2;

        for (int i = 0; i < N; i++) y[i] = POISON;

        ref_n(a, b, x, y_ref, n);
        vec_scale_n(a, b, x, y, n);

        // in range: must match the reference
        for (int i = 0; i < n; i++) {
            if (y[i] != y_ref[i]) {
                if (errors < 10)
                    printf("n=%d idx %d: got %d expected %d\n",
                           n, i, (int)y[i], (int)y_ref[i]);
                errors++;
            }
        }

        // past the bound: must still be poison
        for (int i = n; i < N; i++) {
            if (y[i] != POISON) {
                if (errors < 10)
                    printf("n=%d idx %d: wrote past the bound (%d)\n",
                           n, i, (int)y[i]);
                errors++;
            }
        }

        printf("n=%4d checked\n", n);
    }

    printf(errors ? "FAIL: %d mismatches\n" : "PASS\n", errors);
    return errors ? 1 : 0;
}
```

> Carried over from S0.2/S0.3: confirm from the first line of `run.log` whether
> `__RTL_SIMULATION__` is actually defined during cosim on this install. If S0.3
> already settled it, the answer is in `notes/env.md` — use it and delete the
> `#ifdef`. If it is not defined, replace the block with a single small constant
> for both.

### Directives

`directives_seq.tcl` — empty by design, but the file must exist, because
`source ./directives_seq.tcl` on a missing file is a hard Tcl error:

```tcl
# S1.1 seq: no directives.
# The loop is unpipelined because common/part.tcl sets
# config_compile -pipeline_loops 0. That is the baseline convention.
```

`directives_pipe.tcl`:

```tcl
set_directive_pipeline -II 1 "vec_scale/VS_LOOP"
```

`directives_pipe_ii2.tcl`:

```tcl
set_directive_pipeline -II 2 "vec_scale/VS_LOOP"
```

`directives_notc.tcl`:

```tcl
set_directive_pipeline -II 1 "vec_scale_n/VSN_LOOP"
```

`directives_tc.tcl` — identical plus the one line under test, so tripcount is the
only variable:

```tcl
set_directive_pipeline -II 1 "vec_scale_n/VSN_LOOP"
set_directive_loop_tripcount -min 1 -max 1024 -avg 512 "vec_scale_n/VSN_LOOP"
```

### `run_hls.tcl`

```tcl
# S1.1 — latency, II, and C = L + I(N-1)

set CSIM   1
set CSYNTH 1
set COSIM  1

# ---------- project 1: fixed trip count, top = vec_scale ----------
open_project -reset hls_proj
set_top vec_scale
add_files     src/vec_scale.cpp
add_files -tb src/tb.cpp

foreach sol {seq pipe pipe_ii2} {
    open_solution -reset $sol -flow_target vivado
    source ../../common/part.tcl
    source ./directives_$sol.tcl

    if {$CSIM && $sol eq "seq"} { csim_design }
    if {$CSYNTH}                { csynth_design }
    if {$COSIM}                 { cosim_design -trace_level none }
}
close_project

# ---------- project 2: runtime trip count, top = vec_scale_n ----------
open_project -reset tc_proj
set_top vec_scale_n
add_files     src/vec_scale_n.cpp
add_files -tb src/tb_n.cpp

foreach sol {notc tc} {
    open_solution -reset $sol -flow_target vivado
    source ../../common/part.tcl
    source ./directives_$sol.tcl
    csynth_design
}
close_project

exit
```

csim runs once — the C source is identical across solutions, so running it three
times proves nothing and costs time. cosim runs on all three of project 1 because
the measured latency is the point. Project 2 is csynth-only: the tripcount
directive cannot change simulated behaviour, and proving that would take a cosim
run to demonstrate a null result.

Run it the standard way, so stderr lands in the log:

```
vitis_hls -f run_hls.tcl 2>&1 | tee run.log
```

---

## 5. Measure

### 5.1 The three fixed-trip-count solutions

Note again that $N=1024$. Fill this from `hls_proj/<sol>/syn/report/vec_scale_csynth.rpt`:

| solution | Pipelined | Trip Count $N$ | Iter. Latency $L$ | II $I$ | Loop Latency $C$ | $L + I(N-1)$ | match? | Fn Latency | Fn Interval | LUT | FF  | DSP | BRAM |
|----------|-----------|----------------|-------------------|--------|------------------|--------------|--------|------------|-------------|-----|-----|-----|------|
| seq      |         N | 1024           |                 5 | -      |             5120 |         5120 |      Y |       5121 |        5122 | 206 | 366 |   3 |    0 |
| pipe     |         Y | 1024           |                 5 | 1      |             1027 |         1028 |      Y |       1029 |        1030 | 261 | 516 |   3 |    0 |
| pipe_ii2 |         Y | 1024           |                 5 | 2      |             2050 |         2051 |      Y |       2052 |        2053 | 206 | 366 |   3 |    0 |

Two things to check, not just record:

- The `$L + I(N-1)$` column must equal the `Loop Latency` column exactly, for all
  three rows including `seq` (where $I = L$). If it does not, you have misread
  which column is which.
- `II_target` vs `II_achieved` goes in `results.csv`. For `pipe_ii2` the target is
  2; check whether the tool honoured it or did something else. Vitis will happily
  give you a *better* II than you asked for in some cases, and it will silently
  give you a worse one in others with a warning buried in `run.log`. Grep for
  `II Violation` and `Unable to enforce`.
- The `Fn Latency` and `Fn Interval` are the `Latency` and `Interval` directly.
- The `Loop Latency C` is from the sub-loop.

### 5.2 The cosim gap

From `hls_proj/<sol>/sim/report/vec_scale_cosim.rpt` (and the console tail):

| solution | csynth Latency | cosim Latency (min / avg / max) |       gap | gap as % of csynth |
|----------|----------------|---------------------------------|-----------|--------------------|
| seq      |           5121 |              5121 / 5121 / 5121 |         0 |                  0 |
| pipe     |           1029 |              1027 / 1027 / 1027 |         2 |               0.19 |
| pipe_ii2 |           2052 |              2050 / 2050 / 2050 |         2 |              0.097 |

What to expect and why. csynth reports the scheduler's count of the function body:
from the cycle the FSM leaves idle to the cycle it asserts done. cosim measures
the real transaction on the real RTL, driven by the testbench's memory model.
Sources of gap, in rough order of size for this kernel:

1. **Handshake overhead.** `ap_start` is sampled, `ap_done` is asserted, and the
   module returns to idle. That is a small fixed number of cycles per call, and it
   is not in the csynth body count.
2. **Memory model timing.** The `ap_memory` ports are driven by the cosim
   testbench wrapper's RAM. If its read latency matches what the scheduler
   assumed, no gap. If not, every iteration pays.
3. **Anything data-dependent.** There is none here — no variable bounds, no AXI
   bursts, no stalling streams. That is exactly why this is the right kernel to
   measure the *floor* of the gap on.

So the expected result is a small, roughly constant gap that does not scale with
$N$. Record the number. The reason it matters: in S3.3 (dataflow) and S4.3 (AXI
striping) the gap stops being constant and stops being small, and you will want a
baseline to compare against. Note it in `notes/findings.md`.

Also note the cosim `Interval` column, not just latency. For back-to-back calls,
interval is what determines throughput, and it is not the same as latency + 1 once
the function itself is pipelined (S5.3).

### 5.3 The tripcount pair

From `tc_proj/{notc,tc}/syn/report/vec_scale_n_csynth.rpt`:

| solution | Trip Count | Iter. Latency | II | Loop Latency | Fn Latency | LUT | FF  | DSP | BRAM |
|----------|------------|---------------|----|--------------|------------|-----|-----|-----|------|
| notc     |          ? |             5 |  1 |            ? |          ? | 281 | 516 |   3 |    0 |
| tc       |   1 ~ 1024 |             5 |  1 |     6 ~ 1029 |   7 ~ 1030 | 281 | 516 |   3 |    0 |

Expected: `notc` reports `?` or `undef` for trip count and latency — the scheduler
cannot count iterations it cannot bound. `tc` reports numbers derived from your
`-min/-max/-avg`.

**The check that matters: every resource column must be identical between the two
rows.** `LOOP_TRIPCOUNT` is a reporting annotation. It produces no hardware, adds
no constraint, and is not checked against reality at runtime. If LUT/FF/DSP/BRAM
differ by even one, something else varied between the solutions and you should
diff the two `directives_*.tcl` files again.

Reference: AMD/Xilinx Vitis HLS User Guide (UG1399), `LOOP_TRIPCOUNT` pragma —
stated there as affecting reporting only.

Optional but cheap confirmation: diff the two generated port lists in
`<solution>/syn/report/` or the Verilog in `<solution>/syn/verilog/`. They should
be identical modulo timestamps.

### 5.4 Optional — measure the model's parameters instead of reading them

Ten minutes, and it turns the model from something the tool told you into
something you measured. Change `N` in `vec_scale.h` to 256, re-run the `pipe`
solution, record $C_{256}$. Restore `N = 1024`, you already have $C_{1024}$. Then

$$I = \frac{C_{1024} - C_{256}}{1024 - 256}, \qquad L = C_{256} - I \cdot 255$$

Both should come out as exact integers and should match the report's columns. If
$I$ comes out non-integer, $C$ is not affine in $N$ and something in the loop is
not what you think it is.

### 5.5 Optional — the float side-experiment

Same trick as S0.2: change `typedef int data_t` to `float` and drop the unsigned
casts in `ref()`. csynth only. The point is one line in your notes: $L$ grows a
lot (floating-point multiply and add are deep operators), while $I$ stays at 1.
That is the model's central claim made visible — **depth and throughput are
independent**. The DSP count will also jump, and the operators will be Xilinx FP
IP black boxes, which is the S0.2 portability finding again.

### 5.6 results.csv

Append five rows. Schema reminder: `exercise, kernel, variant, dtype, N,
sweep_param, sweep_value, II_target, II_achieved, latency_est, latency_cosim,
LUT, FF, DSP, BRAM, fmax_est, fmax_impl, notes`.

```
1.1,vec_scale,seq,int,1024,,,,,,,,,,,,,unpipelined baseline (pipeline_loops 0)
1.1,vec_scale,pipe,int,1024,,,1,,,,,,,,,,
1.1,vec_scale,pipe_ii2,int,1024,,,2,,,,,,,,,,
1.1,vec_scale_n,notc,int,1024,,,1,,,,,,,,,,runtime bound, latency unreportable
1.1,vec_scale_n,tc,int,1024,,,1,,,,,,,,,,LOOP_TRIPCOUNT 1/512/1024, report only
```

`fmax_impl` stays blank — no `export_design -flow impl` in this exercise. Per the
S0 finding, the csynth Fmax estimate does not show routing degradation, so record
`fmax_est` but do not read anything into it.

### 5.7 Resource collection

Reuse the script from S0.4. It takes `PROJ`/`TOP`/`SOLS`/`OUT` from the
environment:

```
PROJ=hls_proj TOP=vec_scale SOLS="seq pipe pipe_ii2" \
  ../../s0_flow/04_interfaces/collect_resources.sh

PROJ=tc_proj TOP=vec_scale_n SOLS="notc tc" \
  ../../s0_flow/04_interfaces/collect_resources.sh
```

It is now used by two exercises and will be used by the S6.2 sweep. Move it to
`common/collect_resources.sh` and update the S0.4 README to point at the new
location — that is the right moment, before a third caller appears.

---

### 5.8 Further Explanation on the Architectural Differences

All three solutions have the same operators — 3 DSPs for the low 32 bits of the product, one adder, one address incrementer, the same `ap_memory` ports on `x` and `y`. Your DSP column is 3 in every row and BRAM is 0 in every row. That is not a coincidence, it's the point: pipelining is a control transformation, not a datapath transformation. The arithmetic hardware is identical. What changes is who is allowed to be using it, and when.

#### `seq`: a multi-cycle FSM, one tenant

The body needs 5 control steps. The generated RTL has an FSM walking through them, roughly:

```txt
state 1: issue address to x, assert x_ce
state 2: latch x_q0 into a register
state 3: multiply (DSP stage)
state 4: add b, latch result
state 5: drive y address + y_d0, assert y_we
        -> back to state 1, i++
```

Critically, register boundaries already exist between those states. The loaded value has to survive from state 2 to state 3; the product has to survive state 3 to state 4. Those are real flip-flops, and they're in your 366. They're just idle 4 cycles out of every 5 — each one holds a value belonging to one single iteration, and the next iteration cannot enter until that iteration has left.

So `seq` is not "unregistered." It's registered and serially occupied.

#### `pipe` ($II=1$): the FSM collapses, the valid chain appears

Two structural changes.

**The control FSM shrinks**. Instead of ~5 states cycling per iteration, you get roughly three: entry, a single steady-state "pipeline running" state, and exit. The per-cycle sequencing is no longer done by state, it's done by position. Vitis names this region pp0 (pipelined pipeline 0) in the Verilog.

**A valid shift register appears**. Since there is no longer a state telling stage 3 "you are active," each stage needs its own occupancy flag. In the generated Verilog these are literally named:

```txt
ap_enable_reg_pp0_iter0
ap_enable_reg_pp0_iter1
ap_enable_reg_pp0_iter2
...
```

One per iteration in flight. That's the pipeline's control skeleton — a shift register of valid bits marching alongside the data. It also drives the drain: when the loop counter hits $N$, `iter0` stops being set but `iter1..iterK` keep shifting until the last real iteration exits. That drain is your $L−1$ tail in $C=L+I(N−1)$, made of actual flip-flops.

**And every operator must now accept work every cycle**. In `seq` the multiplier sees one operand pair every 5 cycles; a slow, lightly-registered multiply is fine. At $II=1$ it sees a new pair every cycle, which forces a fully pipelined multiplier. Same DSP count, more internal registers.

Your measured delta: +150 FF, +55 LUT. 150 is suspiciously close to 4–5 × 32 bits. That's the live 32-bit values now needing a copy per stage instead of one copy total, plus the valid chain, plus the multiplier's internal pipelining. The +55 LUT is mostly exit-condition logic — the loop counter must now signal "last iteration issued" several cycles before the last result appears, which is a different comparison than `seq`'s simple "am I done."


#### `pipe_ii2`: modulo scheduling, and why it was free

$II=2$ means iterations start on even offsets only. The scheduler solves a modulo scheduling problem: assign each operation to a control step such that no resource is used by two iterations in the same cycle modulo 2. With depth 4–5 and II=2, you have $⌈L/I⌉≈3$ iterations in flight instead of 5.

Now the thing you actually measured: 206 LUT / 366 FF, byte-identical to `seq`.

The explanation is the register-boundary point from above. `seq` already paid for stage registers between its 5 control steps. At II=2 the schedule is spread out enough that those same existing register boundaries suffice — the tool fills slots that were already there and already idle, rather than needing new ones. The multiplier only needs a new operand pair every other cycle, so it doesn't need the extra internal pipelining that II=1 forced. And 3 iterations in flight fits the existing structure where 5 did not.

That's the finding hiding in your table: you got 2.5× throughput for literally zero area, because unpipelined hardware is already mostly pipeline-shaped and merely underutilized. The jump from 2.5× to 4.98× is where you start paying, and it cost +27% LUT / +41% FF.

**NOTE** A very important part of this work is to know that what changes, is how the order of all the steps change. Here is a nice visualization of this case:

<img width="614" height="448" alt="image" src="https://github.com/user-attachments/assets/a4d148f6-0bcf-497e-95d7-ab20f11f3e00" />

## 6. Questions

**Q1.** The function `Latency` is a few cycles larger than the loop `Latency`, and
the function `Interval` is `Latency + 1`. Where do those extra cycles come from,
and why is the `+1` there specifically?

<details><summary>Answer</summary>

The extra cycles around the loop are the FSM's entry and exit states: sampling
`ap_start`, registering the scalar arguments `a` and `b`, initialising the loop
counter, and on the way out asserting `ap_done`. They are constant in $N$, which
is why they vanish as a fraction when $N$ is large and why they dominate for a
tiny kernel like S0.1's `tiny`.

The `+1` on interval is the return to idle. With `ap_ctrl_hs` and no function-level
pipelining, the module cannot accept a new `ap_start` in the same cycle it asserts
`ap_done` — it needs one cycle to get back to a state where it can latch new
arguments. So the call-to-call period is one more than the call duration. This is
also why `ap_ctrl_chain` exists (S0.4): it lets the next call be queued up so the
`+1` is not paid on every call in a chain.
</details>

**Q2.** You asked for II=2 and got roughly double the latency, as predicted. But
the DSP count did not drop. A looser II means the multiplier is only needed every
other cycle — why did the tool not share it, or use a cheaper one?

<details><summary>Answer</summary>

There is only one multiply in the body, so there is nothing to share it *with*.
Resource sharing under a relaxed II works by time-multiplexing several operations
in the source onto one physical unit. One operation cannot be multiplexed with
itself: at II=2 the single DSP simply idles every other cycle.

A relaxed II can still save area when the body contains several instances of the
same operator, or when it lets the tool pick a smaller/slower implementation of an
operator. Neither applies here. Forcing the allocation question is S5.2
(`ALLOCATION`), and forcing the implementation question is S5.1 (`BIND_OP`).

The practical takeaway: relaxing II is not an area optimization by default. It is
an area optimization only when there is something to share. Left alone it is a
pure throughput loss.
</details>

**Q3.** Your `tb_n.cpp` calls the kernel with `n` in `{1, 17, 512, 1024}`, but you
gave `LOOP_TRIPCOUNT` an `-avg` of 512. For three of those four calls the average
is wrong. What breaks?

<details><summary>Answer</summary>

Nothing breaks. The hardware is bit- and cycle-identical with or without the
directive — that is what section 5.3 measures. `LOOP_TRIPCOUNT` only supplies
numbers for the scheduler to print in the `Latency` column, so a wrong `-avg`
produces a wrong report and a correct circuit.

The danger is entirely social: a plausible-looking latency number in a report is
easy to quote, and if it came from a `-avg` somebody guessed, it means nothing.
Rule for this repo: any `latency_est` in `results.csv` that came from a
`LOOP_TRIPCOUNT`-annotated loop gets a note in the `notes` column saying so. When
the number actually matters, get it from cosim with representative stimulus, not
from csynth.
</details>

**Q4.** In the `seq` solution, the report shows no value in the `Initiation
Interval` column — just a dash. But the model needs an $I$ to compute $C$. What is
$I$ for an unpipelined loop, and why does Vitis print nothing instead?

<details><summary>Answer</summary>

$I = L$. An unpipelined loop starts the next iteration only after the current one
finishes, so the start-to-start distance equals the iteration latency, and
$C = L + L(N-1) = LN$, which is what the report's `Latency` column shows.

Vitis prints a dash because "initiation interval" is a pipeline attribute and
there is no pipeline. The dash means "not applicable", not "unknown" and not
"zero". Substituting $I = L$ yourself is how you keep one formula for both cases
rather than carrying two.
</details>

---

## Appendix — probe D: the auto-pipelining threshold

Outstanding since S0.1. `tiny` and `scale` have no loops, so the threshold could
not be measured there. `vec_scale` does, but its trip count of 1024 is far above
any plausible threshold, so it cannot bracket the value either. Hence a throwaway
probe with trip counts straddling the documented default of 64.

Run this **after** the main exercise, record the result in `notes/env.md`, then
delete `src/probe.cpp`, `run_hls_probe.tcl`, and `probe_proj/`.

### `src/probe.cpp`

```c
void probe(const int in[64], int out63[64], int out64[64]) {
L63:
    for (int i = 0; i < 63; i++) out63[i] = in[i] * 3 + 1;
L64:
    for (int i = 0; i < 64; i++) out64[i] = in[i] * 5 + 2;
}
```

Two labelled loops, separate output arrays so neither loop is dead code and
neither can be merged away. No `n` argument — both bounds are compile-time
constants, which is required, since a loop with an unknown bound cannot be
auto-pipelined on a trip-count rule in the first place.

### `run_hls_probe.tcl`

This script must **not** source `common/part.tcl`, because that file already sets
`config_compile -pipeline_loops 0` and would flatten the very difference being
measured. The part and clock are therefore set inline.

```tcl
# probe D — auto-pipelining threshold. Throwaway; delete after recording.
open_project -reset probe_proj
set_top probe
add_files src/probe.cpp

# solution "auto": tool defaults, no config_compile at all
open_solution -reset auto -flow_target vivado
set_part {xcku5p-ffvb676-2-e}
create_clock -period 3.33 -name default
csynth_design

# solution "off": auto-pipelining explicitly disabled
open_solution -reset off -flow_target vivado
set_part {xcku5p-ffvb676-2-e}
create_clock -period 3.33 -name default
config_compile -pipeline_loops 0
csynth_design

close_project
exit
```

```
vitis_hls -f run_hls_probe.tcl 2>&1 | tee run_probe.log
```

No testbench, csynth only.

### What to record

From the `Loop` table of each solution, the `Pipelined` and `Initiation Interval`
columns for `L63` and `L64`:

| solution | L63 Pipelined | L63 II | L64 Pipelined | L64 II |
|----------|---------------|--------|---------------|--------|
| auto     |             Y |      3 |             Y |      3 |
| off      |             N |      3 |             N |      3 |

If the documented default holds, `auto` shows `L63` unpipelined and `L64`
pipelined, and `off` shows both unpipelined. That pins the threshold at exactly
64 — at or above the threshold gets pipelined, below does not.

If `auto` pipelines both, the threshold is lower than 63 on this install and needs
bracketing: change the bounds to 31/32, or 15/16, and re-run. If it pipelines
neither, it is higher than 64, or `-flow_target vivado` changes the default, or
something in the install's defaults differs — try 127/128.

Write into `notes/env.md`:

- the measured threshold,
- the exact `config_compile` line that disables it,
- and one sentence recording that every baseline variant in this repo depends on
  that line being present in `common/part.tcl`.

That last sentence is the point of the whole probe. If the threshold on this
install is not what the documentation says, every "before" measurement in S2–S4
is affected, and the note in `env.md` is the thing that catches it.

---

## References

- de Fine Licht, Besta, Meierhans, Hoefler, "Transformations of High-Level
  Synthesis Codes for High-Performance Computing," *IEEE TPDS* 32(5), 2021.
  arXiv:1805.08288. The performance model and the 15-transformation taxonomy.
- AMD/Xilinx, *Vitis HLS User Guide* (UG1399), v2023.2. `PIPELINE`,
  `LOOP_TRIPCOUNT`, `config_compile`, and the report column definitions.
- Kastner, Matai, Neuendorffer, *Parallel Programming for FPGAs* (open access),
  ch. 2. Worked introduction to II and loop pipelining.
