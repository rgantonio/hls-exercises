# S0.2 — First Compute Unit: `scale`

**Repo path:** `s0_flow/02_first_compute_unit/README.md`
**Tool:** Vitis HLS v2023.2.2 (64-bit), batch mode only — no GUI.
**Part / clock:** `xcku5p-ffvb676-2-e`, 3.33 ns (300 MHz), from `common/part.tcl`.
**Time:** ~2 hours.

---

## 0. What this exercise is for

S0.1 built the *project*. It stopped after `csynth_design`, and the kernel was
deliberately trivial (`*c = a + b`) so that nothing about the kernel distracted
from the flow.

S0.2 adds the three things S0.1 left out:

1. A kernel with real arithmetic, so the reports have something in them.
2. A **self-checking testbench**, written to the contract that the rest of the
   repo will reuse unchanged.
3. The **full four-step flow** — `csim` → `csynth` → `cosim` → `export` — and a
   tour of every directory the tool creates.

There is still no transformation here, no II target, and nothing to predict.
This is a step-by-step scenario, like S0.1. The six-section template
(Transformation / Blocker / Predict / Apply / Measure / Questions) starts at
S1.1.

By the end you will have:

- `src/scale.h`, `src/scale.cpp`, `src/tb.cpp`, `directives.tcl`, `run_hls.tcl`.
- A testbench that returns non-zero on failure and works unchanged under cosim.
- **Estimated** latency from `csynth` and **measured** latency from `cosim`,
  side by side, plus an explanation of why they differ.
- An exported IP `.zip` you have actually opened.
- The first real data row in `notes/results.csv`.

---

## 1. The kernel

Create the directory:

```bash
mkdir -p s0_flow/02_first_compute_unit/src
cd exercises/s0_flow/02_first_compute_unit
```

`src/scale.h`:

```cpp
#ifndef SCALE_H_
#define SCALE_H_

typedef int data_t;

void scale(data_t x, data_t a, data_t b, data_t *y);

#endif  // SCALE_H_
```

`src/scale.cpp`:

```cpp
#include "scale.h"

void scale(data_t x, data_t a, data_t b, data_t *y) {
  *y = a * x + b;
}
```

Four deliberate choices:

| Choice | Reason |
|---|---|
| Scalars in by value, result out by pointer | This is the smallest case that produces two *different* port protocols. A by-value input becomes a plain `ap_none` port; a pointer output becomes a data port plus a `_ap_vld` strobe. You will see both in the interface table. |
| Multiply **and** add | A multiply is the smallest operation where the tool has a genuine choice: DSP block or LUT fabric. We only observe the default here; forcing it is S5.1 (`BIND_OP`). |
| `typedef data_t` from day one | S4.4 swaps this line for `ap_int<>` / `ap_fixed<>`. The kernel body must not change when it does. Getting the typedef in now means that exercise is a one-line diff. |
| `int`, not `float` | Repo dtype policy: `float` is reserved for the accumulation exercises, where a multi-cycle adder is what makes a loop-carried dependency actually bite. Everywhere else, integer or `ap_fixed`. There is an optional float side-experiment in §9. |

There are no loops in `scale`, so there is nothing to label. The repo rule from
S0.1 — **label every loop, always** — applies from the first loop onward,
because `set_directive_*` has no other handle on a loop than `"function/LABEL"`.

---

## 2. The testbench contract

This is the part worth reading slowly, because every later exercise reuses it.

**What csim does.** `csim_design` compiles `tb.cpp` and `scale.cpp` as ordinary
C++ and runs `main()`. Return 0 means pass. Any non-zero return means fail, and
`csim_design` aborts the Tcl script there, so `csynth_design` never runs on a
broken kernel.

**What cosim does.** `cosim_design` runs *the same* `main()` again, but every
call to `scale()` is intercepted. The arguments are recorded, replayed into an
RTL simulation of the generated `scale.v`, and the RTL's outputs are handed back
to your testbench. Your `if (y != expected)` checks are then checking the
hardware, not the C++.

Three consequences follow directly:

- **The testbench must be deterministic.** Fixed seed, no `time(NULL)`, no
  reading files that may not exist. Cosim replays recorded stimulus; if the
  stimulus is not reproducible, the comparison is meaningless.
- **The reference model must match RTL semantics, not C++ semantics.** Signed
  integer overflow is undefined behaviour in C++ — the compiler may do anything
  — but the generated RTL simply wraps. Compute the reference through
  `unsigned` so it wraps the same way. (This was established on `tiny` in S0.1
  and it still bites here, now with a multiply, which overflows far more easily
  than an add.)
- **Vector count is not free.** 1000 vectors in csim is a compiled binary
  running for milliseconds. 1000 vectors in cosim is 1000 full RTL transactions
  in a simulator. S0.1 used 1000; from here on, csim gets the big count and
  cosim gets a small one.

**Splitting the vector count.** Vitis defines the macro `__RTL_SIMULATION__`
when it compiles the testbench for cosimulation, which gives you a clean way to
branch. *Confirm this on your own install* — the testbench below prints the
count as its first line, so `grep N_RAND run.log` will show you two different
numbers if it worked, and two identical numbers if it did not. If it does not
work on your install, drop the `#ifdef` and use a single small count (64) for
both; you lose csim coverage but nothing else.

---

## 3. `src/tb.cpp`

```cpp
#include <cstdio>
#include <cstdlib>
#include <climits>
#include "scale.h"

// ---------------------------------------------------------------------
// Reference model — kept separate from the kernel on purpose.
// Computed through unsigned so it wraps exactly like the RTL does.
// Signed overflow is UB in C++; the hardware just truncates.
// ---------------------------------------------------------------------
static data_t ref(data_t x, data_t a, data_t b) {
  unsigned ux = (unsigned)x;
  unsigned ua = (unsigned)a;
  unsigned ub = (unsigned)b;
  return (data_t)(ua * ux + ub);
}

// Written into the output before every call. If the kernel never writes,
// the poison survives and the comparison fails loudly.
static const data_t POISON = (data_t)0xDEADBEEF;

#ifdef __RTL_SIMULATION__
static const int N_RAND = 16;      // cosim: one RTL transaction per vector
#else
static const int N_RAND = 1000;    // csim: free
#endif

static const int MAX_REPORTED = 10;

static void check(data_t x, data_t a, data_t b, int *errors) {
  data_t y = POISON;
  scale(x, a, b, &y);
  data_t expected = ref(x, a, b);
  if (y != expected) {
    if (*errors < MAX_REPORTED) {
      printf("FAIL  x=%d a=%d b=%d  got=%d  expected=%d\n",
             x, a, b, y, expected);
    }
    (*errors)++;
  }
}

// Full 32-bit random: rand() only gives 31 bits on glibc.
static data_t rand32(void) {
  return (data_t)(((unsigned)rand() << 16) ^ (unsigned)rand());
}

int main() {
  int errors = 0;
  printf("scale tb: N_RAND = %d\n", N_RAND);

  // ---- directed vectors first: edge cases you chose on purpose --------
  static const data_t directed[][3] = {
    {       0,       0,       0},   // everything zero
    {       1,       1,       0},   // identity
    {       0,       5,       7},   // x = 0, b passes through
    {       1,       0,      -3},   // a = 0, b passes through
    {      -1,      -1,       0},   // sign handling
    {INT_MAX,        1,       0},   // largest input, no overflow
    {INT_MIN,        1,       0},   // smallest input, no overflow
    {INT_MAX,        2,       0},   // multiply overflow
    {       2, INT_MAX,       1},   // multiply overflow, other operand
    {INT_MAX,        1, INT_MAX},   // add overflow
    {  -7,           3,      11},   // mixed signs
  };
  const int n_directed = (int)(sizeof(directed) / sizeof(directed[0]));
  for (int i = 0; i < n_directed; ++i) {
    check(directed[i][0], directed[i][1], directed[i][2], &errors);
  }

  // ---- then seeded randoms -------------------------------------------
  srand(1);   // FIXED seed. Cosim replays this exact stimulus.
  for (int i = 0; i < N_RAND; ++i) {
    check(rand32(), rand32(), rand32(), &errors);
  }

  const int total = n_directed + N_RAND;
  if (errors) {
    printf("TEST FAILED: %d of %d vectors wrong\n", errors, total);
    return 1;
  }
  printf("TEST PASSED: %d vectors\n", total);
  return 0;
}
```

Five properties of this testbench, each of which matters later:

1. **Separate `ref()`.** The reference is never the kernel called a second time.
2. **Poison before every call.** Catches "the kernel never wrote the output",
   which a zero-initialised variable would hide when the expected value is 0.
3. **Directed vectors before randoms.** Edge cases you chose deliberately come
   first, so a failure report starts with a case you can reason about.
4. **Count errors, do not return early.** One failure is a bug; 1011 failures is
   a completely different bug. Returning on the first one hides that.
5. **Non-zero return from `main`.** This is the only signal Vitis reads.
   A testbench that prints `FAIL` and returns 0 will pass silently.

---

## 4. `directives.tcl`

Still empty, but the file must exist — `source ./directives.tcl` is a hard Tcl
error if it is missing.

```tcl
# exercises/s0_flow/02_first_compute_unit/directives.tcl
#
# Only set_directive_* commands belong in this file.
# Solution-wide config_* commands live in common/part.tcl.
# Nothing to direct yet: this exercise measures the default schedule.
```

---

## 5. `run_hls.tcl` — all four steps

```tcl
# ---- project ----------------------------------------------------------
open_project -reset hls_proj
set_top scale
add_files     src/scale.cpp
add_files -tb src/tb.cpp

# ---- solution ---------------------------------------------------------
open_solution -reset "solution1" -flow_target vivado
source ../../../common/part.tcl
source ./directives.tcl

# ---- run --------------------------------------------------------------
csim_design
csynth_design
cosim_design  -rtl verilog -tool xsim -trace_level none
export_design -format ip_catalog -rtl verilog \
              -vendor "hls-exercises" -library "hls" \
              -display_name "scale" -description "y = a*x + b, 32-bit int" \
              -version "1.0.0"

close_project
exit
```

Everything above `csim_design` is identical to S0.1. The two new commands:

| Line | What it does | Notes |
|---|---|---|
| `cosim_design` | Simulates the generated RTL against your testbench | Fails the script if the testbench returns non-zero, same as csim. |
| `-rtl verilog` | Simulate the Verilog output | `csynth` emits Verilog *and* VHDL for the same design; you pick one to simulate. |
| `-tool xsim` | Use the simulator bundled with Vitis | ModelSim/Questa, VCS, Riviera are also accepted but need their own install and licence. |
| `-trace_level none` | Do not dump waveforms | `-trace_level port` dumps only the top-level ports; `-trace_level all` dumps everything and is large and slow. Turn it on only when debugging a specific mismatch. |
| `export_design -format ip_catalog` | Package the RTL as a Vivado IP `.zip` | **Packaging only.** No synthesis runs, no timing or area number changes. |
| *(not used)* `-flow syn` / `-flow impl` | Actually run Vivado synthesis / place-and-route | Needs Vivado on `PATH`, takes minutes, and rewrites the report with *real* timing and area. Deferred to S6.2, where it matters because routing degradation never shows up in `csynth`. |

**One solution, not two.** S0.1 established the naive/opt two-solution pattern
for the same project. There is no transformation here, so there is nothing to
compare; a single `solution1` is correct. The pattern comes back the moment
there is an "after".

Run it:

```bash
cd exercises/s0_flow/02_first_compute_unit
vitis_hls -f run_hls.tcl 2>&1 | tee run.log
```

or from the repo root:

```bash
make run EX=s0_flow/02_first_compute_unit
```

The `2>&1` matters: Vitis writes `ERROR`/`WARNING` lines to stderr, and a bare
pipe into `tee` would drop them from `run.log`.

---

## 6. The generated tree

This is the "find every output file" part of the exercise. Look at yours first:

```bash
find hls_proj -maxdepth 4 -type d | sort
```

Annotated, for a run that completed all four steps:

```
hls_proj/
├── vitis_hls.log                 whole-session log, all steps
└── solution1/
    ├── solution1.aux             solution bookkeeping
    ├── solution1.directive       TOOL-GENERATED. Never hand-edit.
    ├── solution1.log             this solution's log
    ├── csim/
    │   ├── build/                csim.exe, objects, anything your tb wrote
    │   └── report/               scale_csim.log — your printf output lives here
    ├── syn/
    │   ├── report/               csynth.rpt, scale_csynth.rpt, scale_csynth.xml
    │   ├── verilog/              scale.v  ← the actual RTL
    │   ├── vhdl/                 scale.vhd — same design, other language
    │   └── systemc/              SystemC model, unused in this repo
    ├── sim/
    │   ├── report/               scale_cosim.rpt ← MEASURED latency
    │   ├── verilog/              cosim workspace: wrappers, xsim.dir, *.dat stimulus
    │   └── wrapc/                the C side of the cosim harness
    ├── impl/
    │   ├── ip/                   export_design output, including the .zip
    │   └── verilog/              copy of the exported RTL
    └── .autopilot/db/            *.adb — the internal scheduling database.
                                  This is what the schedule viewer reads. S0.3.
```

Exact subdirectory names shift slightly between Vitis versions, which is why the
`find` command above comes first. Two files are worth opening right now:
`syn/report/scale_csynth.rpt` and `sim/report/scale_cosim.rpt`.

A useful habit: the `.xml` next to the `.rpt` holds the same numbers in a form a
script can read. The sweep script in S6.2 parses `scale_csynth.xml`, not the
human-readable report.

---

## 7. The csynth report — a light pass

S0.3 is the full walkthrough. Here, find five things and write them down.

1. **Timing** — target 3.33 ns, estimated *x*, uncertainty 0.90 ns.
   Recall from S0.1 that this install uses a 27 % default uncertainty, so the
   scheduler is really targeting 2.43 ns.
2. **Latency (cycles), min and max** — for `scale` these are equal, because
   there is no data-dependent control flow.
3. **Interval** — how often a new call can start.
4. **Resources** — DSP, FF, LUT, BRAM.
5. **Interface summary** — the port list.

What to expect, and why you should record the real numbers rather than trust
this paragraph: a 32×32 signed multiply does not fit in one DSP48E2 slice
(which is 27×18), so the tool builds it from several DSPs, or from DSPs plus
LUT fabric, and it will not close 2.43 ns combinationally. So unlike `tiny` in
S0.1, you should now see **latency greater than 0**, **non-zero FF**, and
**non-zero DSP**. The exact numbers depend on the operator core Vitis picks —
record what you actually get.

The port list should be close to:

| Port | Protocol | Note |
|---|---|---|
| `ap_clk` | — | |
| `ap_rst` | — | **New compared to S0.1.** There are registers now, so there is state to reset. In `tiny` the design was purely combinational and `ap_ctrl_hs` collapsed away the reset entirely. |
| `ap_start`, `ap_done`, `ap_idle`, `ap_ready` | `ap_ctrl_hs` | Block-level handshake, the default for the Vivado IP flow. |
| `x`, `a`, `b` | `ap_none` | Scalar by value: data wires only, no strobe. They must be held stable by the caller. |
| `y`, `y_ap_vld` | `ap_vld` | Scalar out by pointer: data plus a one-cycle valid strobe. |

That `ap_none` vs `ap_vld` asymmetry is the seed of S0.4, where the same kernel
is rebuilt with five different interface configurations and the port lists are
diffed.

---

## 8. The cosim report — estimated vs measured

`sim/report/scale_cosim.rpt` has a small table: RTL, Status, and Latency and
Interval each as min / avg / max.

Three things to take from it:

**The transaction count.** It equals the number of times your testbench called
`scale()` — 11 directed plus `N_RAND`. Check `run.log` for the `N_RAND = ...`
line printed during cosim to confirm whether `__RTL_SIMULATION__` was defined.
Record the answer in `notes/env.md`; every later exercise depends on it.

**Latency should match csynth closely.** Both measure one call, `ap_start` to
`ap_done`. For a kernel with no memory interfaces and no data-dependent
branching, the estimate is usually exact.

**Interval will not match.** The csynth interval is what the *pipeline* can
sustain. The cosim interval is what your *testbench* actually achieved, and with
`ap_ctrl_hs` the next call cannot begin until the module asserts `ap_ready` and
the harness drives `ap_start` again. That handshake turnaround is real hardware
cost that the csynth number does not include.

This gap is the whole subject of S1.1, where it is measured against

$$C = L + I(N-1)$$

For now, just record both numbers and the difference. You will need this row.

---

## 9. Optional side-experiment: the `float` variant (10 minutes)

Change one line in `scale.h`:

```cpp
typedef float data_t;
```

and run **csynth only** — comment out `csim_design`, `cosim_design` and
`export_design`, or make a scratch copy of the script. (Skip csim because the
integer reference model in `tb.cpp` wraps through `unsigned`, which is nonsense
for float; a float testbench needs a tolerance compare, which is not the point
here.)

Three things change in the report:

- **Latency jumps** — from a few cycles to roughly ten or more, because a
  floating-point multiply and add are multi-cycle operators.
- **The operator names change** — you will see `fmul` and `fadd` in the
  resource table instead of `mul`/`add`.
- **The Verilog changes character.** Open `syn/verilog/` and look: the FP
  operators are *instantiated Xilinx floating-point IP*, not behavioural
  Verilog you could read.

That last point is worth a line in `notes/findings.md`, because it is the single
biggest obstacle to reusing Vitis output outside a Xilinx flow: the control FSM,
the integer datapath and the AXI adapters are portable behavioural Verilog, but
floating-point operators are vendor IP black boxes. (Arrays are a second
problem — behavioural RAM models that infer BRAM on Xilinx but synthesise to
flip-flops in a standard-cell flow. That one shows up from S3.0 onward.)

Revert the typedef before moving on.

---

## 10. Record the result

Append one row to `notes/results.csv` (schema fixed in S0.1):

```
exercise,kernel,variant,dtype,N,sweep_param,sweep_value,II_target,II_achieved,latency_est,latency_cosim,LUT,FF,DSP,BRAM,fmax_est,fmax_impl,notes
s0.2,scale,base,int,1,,,,,<from csynth>,<from cosim>,<LUT>,<FF>,<DSP>,0,<1000/est_ns>,,"first cosim; ap_ctrl_hs handshake gap"
```

`II_target` and `II_achieved` stay empty — there is no pipeline to target yet.
They become the most important columns in the repo from S2 onward, because they
are where you record the cases in which Vitis simply refused the point you asked
for.

Add to `notes/env.md`:

- Whether `__RTL_SIMULATION__` is defined during cosim on this install.
- Which simulator cosim used, and its version (from `run.log`).
- The DSP count and latency of a 32×32 `int` multiply-add at 3.33 ns — a useful
  baseline when the same multiply reappears in `gemm_small`.

If the auto-pipelining probe from S0.1 is still outstanding, `scale` does not
help with it — there are still no loops. It stays open until S1.1 or the
standalone probe.

---

## 11. Troubleshooting

| Symptom | Cause |
|---|---|
| csim passes, csynth fails with "not a synthesizable construct" | Something in `scale.cpp` cannot be built in hardware (`printf`, `malloc`, recursion, system calls). csim compiles everything as plain C++ and cannot catch this — that is what csynth is for. |
| `[SYNCHK 200-11]` referring to `main` | You forgot `-tb` on the testbench, so Vitis is trying to synthesize the testbench. The classic error. |
| csim fails and the script stops before csynth | Working as intended. `csim_design` aborts the Tcl script on a non-zero return from `main`. |
| cosim reports mismatches but csim passed | Almost always the reference model. Integer overflow computed in signed C++, or an output read before the kernel wrote it. |
| cosim takes minutes or appears to hang | Too many transactions. Reduce `N_RAND`. Each vector is a full RTL simulation. |
| cosim: "cannot find xsim" | The Vitis settings script was not sourced in this shell. |
| `export_design` errors about Vivado | You passed `-flow syn` or `-flow impl` without Vivado on `PATH`. Plain `-format ip_catalog` does not need it. |
| Directives you deleted still seem to apply | You dropped `-reset` from `open_project` or `open_solution`. Directives accumulate across runs; removing a line from `directives.tcl` does not remove it from an existing solution. |

---

## 12. Questions

**1. The RTL did not change between csynth and cosim. Why is the cosim interval
larger than the csynth interval?**

<details><summary>Answer</summary>

Because they measure different things. The csynth interval is the rate the
generated pipeline can sustain if something feeds it perfectly. The cosim
interval is the rate your testbench actually achieved, and the testbench talks
to the module over `ap_ctrl_hs`: it must wait for `ap_ready`, then assert
`ap_start` again, which costs cycles that are not part of the module's internal
schedule. Any latency number that comes from a testbench includes the cost of
the protocol used to reach the module. This is exactly why S1.1 checks
$C = L + I(N-1)$ against *both* numbers instead of just the estimate.
</details>

**2. `ap_rst` appears in this design but not in S0.1's `tiny`. Why?**

<details><summary>Answer</summary>

`tiny` was a single 32-bit add that met timing combinationally, so it had no
registers. With no state, there is nothing to reset, and `ap_ctrl_hs` collapsed
to pure combinational logic — no reset port was generated. `scale` contains a
32×32 multiply that cannot meet 2.43 ns in one cycle, so the tool registers it.
Once state exists, the reset port exists. The port list is a consequence of the
schedule, not a fixed template.
</details>

**3. What breaks if the testbench uses `srand(time(NULL))` instead of
`srand(1)`?**

<details><summary>Answer</summary>

csim still works — it would just test different vectors each run, which is
merely annoying. Cosim is the real problem: it records the stimulus produced by
one execution and replays it against the RTL. With a time-based seed, the run
that generates the stimulus and the run that checks it can disagree, so a
failure may be unreproducible and a pass may be meaningless. Worse, a
regression becomes impossible to bisect, because "it failed yesterday" no longer
refers to the same test. Fixed seeds are not a style preference here; they are
required by how cosim works.
</details>

---

## 13. References

- **AMD/Xilinx, *Vitis HLS User Guide* (UG1399)** — reference for
  `cosim_design`, `export_design`, the `-trace_level` options, and the
  interface defaults of the Vivado IP flow. Version-specific; use the 2023.2
  edition to match this install.
- **R. Kastner, J. Matai, S. Neuendorffer, *Parallel Programming for FPGAs***
  (open access) — chapter 1 covers the C-simulation / synthesis / cosimulation
  loop with worked kernels.
- **J. de Fine Licht, M. Besta, S. Meierhans, T. Hoefler, "Transformations of
  High-Level Synthesis Codes for High-Performance Computing," *IEEE TPDS*
  32(5), 2021; arXiv:1805.08288** — no transformation is applied in this
  exercise. Section 2 defines the performance model this repo uses from S1.1
  onward.

---

## 14. Next

**S0.3 — Reading what the tool tells you.** Same `scale` project, no new code:
a full walkthrough of the synthesis report, then the schedule viewer (one of the
two GUI-permitted exercises in this repo), mapping operations to control states.
The skill that matters there is finding the message where Vitis explains *why*
it failed to reach a target — which is the message you will be reading for the
rest of S2.