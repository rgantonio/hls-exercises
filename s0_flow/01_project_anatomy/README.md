# S0.1 — Anatomy of a Vitis HLS Project

**Repo path:** `s0_flow/01_project_anatomy/README.md`
**Tool:** Vitis HLS v2023.2.2 (64-bit), batch mode only — no GUI in this exercise.
**Time:** ~1.5 hours.

---

## 0. What this exercise is for

Every later exercise in this repo runs the same way: you edit a kernel, edit a
`directives.tcl`, and type `vitis_hls -f run_hls.tcl`. Before any of that means
anything, you need to know what that command actually builds, where it puts
things, and which knobs are set by *you* versus set silently by the tool.

This exercise is **not** about performance. There is no transformation here, no
II target, and nothing to predict. The standard six-section exercise template
(Transformation / Blocker / Predict / Apply / Measure / Questions) resumes at
S1.1. S0 uses a step-by-step scenario format instead, because the thing being
learned is the flow itself.

**Scope split with S0.2:** this exercise stops after `csynth_design`. Running
the full four-step flow (csim → csynth → cosim → export) on a real compute unit
with a self-checking testbench is S0.2. Here the kernel is deliberately trivial
so that nothing about the *kernel* distracts from the *project*.

By the end you will have:

- `common/part.tcl` and a working `run_hls.tcl`, both hand-written.
- A synthesized project you can navigate without the GUI.
- Four recorded facts about your specific install (version, part, clock
  uncertainty, auto-pipelining threshold) written into `notes/env.md`.
- `notes/results.csv` created with its header row.

---

## 1. Background: the object model

Vitis HLS has three nested objects. Almost every Tcl command belongs to exactly
one of them, and the most common beginner error is calling a command before its
owning object exists.

| Object | Created by | Owns |
|---|---|---|
| **Project** | `open_project` | The source files, the testbench files, the name of the top function |
| **Solution** | `open_solution` | The target part, the clock, the flow target, all directives and config |
| **Design run** | `csim_design`, `csynth_design`, ... | The generated RTL, reports, logs |

The consequence: `set_part`, `create_clock`, `config_compile`, and every
directive must come **after** `open_solution`. `add_files` and `set_top` must
come after `open_project`. A project can hold several solutions side by side,
which is how you keep a naive and an optimized variant of the same source in
one place — that is how S2 onward is structured.

There are two ways to drive the tool without a GUI:

```bash
vitis_hls -f run_hls.tcl    # batch: run the script, exit
vitis_hls -i                # interactive Tcl shell, same commands typed live
```

Batch is the default for this repo. Interactive is useful when you want to poke
at an open solution without re-running synthesis.

There are four design steps, and this exercise uses the first two:

1. **C simulation** (`csim_design`) — compiles your kernel and testbench as
   ordinary C++ and runs them. No hardware involved. Catches functional bugs
   cheaply.
2. **C synthesis** (`csynth_design`) — the actual HLS step. Produces RTL, a
   schedule, and the estimate reports.
3. **C/RTL cosimulation** (`cosim_design`) — runs the same testbench against
   the generated RTL in a simulator. Gives measured latency instead of
   estimated. *(S0.2)*
4. **Export** (`export_design`) — packages the RTL as IP, and optionally runs
   Vivado synthesis/implementation for real timing and area. *(S0.2, and
   properly in S6.2)*

---

## 2. Step 1 — Create the skeleton

From the repo root:

```bash
mkdir -p common notes
mkdir -p s0_flow/01_project_anatomy/src
cd s0_flow/01_project_anatomy
```

Per the repo convention, each exercise directory eventually holds
`naive.cpp`, `opt.cpp`, `tb.cpp`, `directives.tcl`, `params.json`, `README.md`.
S0.1 has no optimized variant, so it only gets `src/tiny.cpp`, `src/tb.cpp`,
`directives.tcl` (empty for now), and `run_hls.tcl`.

---

## 3. Step 2 — Write `common/part.tcl`

This file is shared by every exercise in the repo. It fixes the three things
that must never drift between exercises, because if they drift your
`results.csv` rows stop being comparable.

`common/part.tcl`:

```tcl
# Target: mid-size Kintex UltraScale+, speed grade -2, 300 MHz.
set_part xcku5p-ffvb676-2-e
create_clock -period 3.33 -name default

# Baseline policy for this repo: the tool must not pipeline anything
# unless an exercise explicitly asks for it. See Step 7, probe D.
config_compile -pipeline_loops 0
```

Two notes on this:

- `create_clock -period 3.33` is in nanoseconds by default. You can write
  `-period 300MHz` instead and Vitis will convert, but the period form is what
  appears in the reports, so keeping both in the same unit avoids confusion.
- `config_compile -pipeline_loops 0` disables auto-pipelining. This matters far
  more than it looks. In 2023.2, loops whose trip count is at or above a
  threshold (default 64) are pipelined *with no pragma at all*. Without this
  line, most "before" cases in this repo would already be optimized and the
  transformations would appear to do nothing. Probe D in Step 7 confirms the
  threshold on your install.

Because these commands belong to the solution, `part.tcl` is `source`d **after**
`open_solution`, never before.

---

## 4. Step 3 — The kernel and testbench

`src/tiny.cpp` — as small as a kernel can get while still having an input, an
output, and one operation:

```cpp
void tiny(int a, int b, int *c) {
    *c = a + b;
}
```

`src/tb.cpp` — directed vectors for the interesting cases, then randoms for
coverage, checked against a reference model:

```cpp
#include <cstdio>
#include <cstdlib>
#include <climits>

void tiny(int a, int b, int *c);

// Reference model. Computed in unsigned so that wraparound is
// well defined, which is what the hardware adder actually does.
// Signed overflow in C++ is undefined behaviour; the RTL has no
// such notion and simply wraps mod 2^32. See the note below.
static int ref(int a, int b) {
    return (int)((unsigned)a + (unsigned)b);
}

static const int POISON = 0x5A5A5A5A;

static int check(int a, int b, int &errors) {
    int c = POISON;                 // detect "kernel never wrote the output"
    tiny(a, b, &c);
    int expected = ref(a, b);
    if (c != expected) {
        printf("FAIL  a=%11d  b=%11d  got=%11d  expected=%11d%s\n",
               a, b, c, expected, (c == POISON) ? "   (output untouched)" : "");
        errors++;
        return 1;
    }
    return 0;
}

int main() {
    int errors = 0;
    int tests  = 0;

    // ---- directed vectors: zero, identity, signs, boundaries ----------
    const int va[] = { 0, 0, 1, 3, -7,  -7, INT_MAX, INT_MIN, INT_MAX, INT_MIN, 123456789 };
    const int vb[] = { 0, 5, 0, 4,  7, -11,       0,       0,       1,      -1, 987654321 };
    const int nvec = sizeof(va) / sizeof(va[0]);

    for (int i = 0; i < nvec; i++) {
        check(va[i], vb[i], errors);
        tests++;
    }

    // ---- random vectors: fixed seed, so the run is reproducible -------
    srand(1);
    for (int i = 0; i < 1000; i++) {
        // rand() gives only 15-31 bits depending on platform; build a full
        // 32-bit value so the upper half of the adder gets exercised too.
        int a = (rand() << 16) ^ rand();
        int b = (rand() << 16) ^ rand();
        check(a, b, errors);
        tests++;
    }

    printf("%s: %d/%d vectors passed\n",
           errors ? "FAIL" : "PASS", tests - errors, tests);
    return errors ? 1 : 0;
}
```

Five things in there are habits worth carrying into every later exercise:

- **A separate reference model.** `ref()` is the specification, the kernel is
  the implementation. Once the kernel stops being one line, keeping these as
  two independent pieces of code is the only thing that makes a mismatch
  informative.
- **The poison value.** Initialising the output to something the kernel would
  never legitimately produce catches the case where it does not write at all.
  Without it, a zero-initialised output plus a kernel that silently does
  nothing looks like a pass on the `0 + 0` vector.
- **Counting errors instead of returning on the first one.** Whether one vector
  failed or all of them usually tells you immediately whether the bug is an
  edge case or something structural.
- **A fixed seed.** S0.2 replays this same testbench against the generated RTL
  in cosimulation. If the stimulus changes between runs, a csim/cosim mismatch
  becomes impossible to reason about. Seed it, always.
- **Directed before random.** Randoms almost never hit `0`, `INT_MAX`, or
  exact boundaries, and that is where real bugs live. Randoms cover the middle;
  they do not find edge cases.

The return value is the contract with the tool: `csim_design` treats a non-zero
return from `main()` as a failed simulation and stops the script. That is the
whole mechanism behind "self-checking" — there is nothing more to it.

**On the overflow vectors.** `INT_MAX + 1` is undefined behaviour in C++, so
the reference must not compute it with signed arithmetic — hence the cast
through `unsigned`. This is not pedantry; it is the first appearance of a theme
that runs through the whole repo. C semantics and hardware semantics differ,
and where C says "undefined" the hardware still does something specific and
deterministic. The same question returns in S4.4 as "what exactly happens on
overflow, and which `ap_fixed` saturation mode did I ask for." If the
undefined-behaviour framing bothers you, drop the four boundary vectors — but
then record in `notes/findings.md` that overflow behaviour is untested.

S0.2 extends this shape to arrays: a reference model over a whole buffer, a
tolerance comparison instead of exact equality (the dtype there is `float`),
and a report of which index first diverged.

`directives.tcl` — create it empty with a comment, so the file exists from the
first exercise and the pattern is established:

```tcl
# S0.1 has no directives. Kept for consistency with later exercises.
```

The reason directives live here instead of as `#pragma HLS` lines in the source
is a repo-wide convention: the kernel source stays byte-identical across
variants, so `diff naive.cpp opt.cpp` shows only genuine code restructuring and
the pragma story lives in one place. Vitis supports both; pragmas win over Tcl
directives if both target the same object.

---

## 5. Step 4 — Write `run_hls.tcl`

Type this out by hand rather than copying it. The point of the exercise is that
you know what each line does.

`run_hls.tcl`:

```tcl
# ---- project ----------------------------------------------------------
open_project -reset hls_proj
set_top tiny
add_files     src/tiny.cpp
add_files -tb src/tb.cpp

# ---- solution ---------------------------------------------------------
open_solution -reset "solution1" -flow_target vivado
source ../../common/part.tcl
source ./directives.tcl

# ---- run --------------------------------------------------------------
csim_design
csynth_design

close_project
exit
```

Line by line:

| Line | What it does | Why it is written that way |
|---|---|---|
| `open_project -reset hls_proj` | Creates/opens the project directory | `-reset` wipes any previous contents. Without it, a re-run can inherit stale state and you get results you cannot reproduce. Always use it in batch. |
| `set_top tiny` | Names the function to synthesize | Must match the C++ symbol. For C++ overloads you need the mangled name; avoid overloading your top function. |
| `add_files src/tiny.cpp` | Synthesizable source | Add `-cflags "-I../../common"` here if you ever need include paths. |
| `add_files -tb src/tb.cpp` | Testbench source | `-tb` files are compiled for simulation only and are never synthesized. Forgetting `-tb` is a classic error: the tool then tries to synthesize `main()`. |
| `open_solution -reset "solution1"` | Creates the solution | `-reset` again, same reason. |
| `-flow_target vivado` | Selects the Vivado IP flow | **Important.** The default in 2023.2 is the Vitis kernel flow, which forces `m_axi` + `s_axilite` on every argument. The Vivado IP flow gives the plain `ap_memory` / `ap_ctrl_hs` defaults, which is what S0.4 needs in order to show the full interface catalogue. Every exercise in this repo uses `vivado`. |
| `source ../../common/part.tcl` | Part, clock, compile config | After `open_solution`, because these are solution-level commands. |
| `source ./directives.tcl` | Per-exercise directives | Empty here. This is the line that changes between naive and optimized solutions later. |
| `csim_design` | Runs the C testbench | Stops the script on non-zero return. |
| `csynth_design` | Runs HLS | Produces RTL and reports. |
| `close_project` / `exit` | Clean shutdown | Without `exit`, batch mode can leave the Tcl shell open. |

---

## 6. Step 5 — Run it

```bash
cd s0_flow/01_project_anatomy
vitis_hls -f run_hls.tcl 2>&1 | tee run.log
```

Expected: the version banner, the C compile, `PASS: 1011/1011 vectors passed`
from your testbench, then the synthesis messages, then a summary table. The run
should take well under a minute — 1011 vectors is nothing in csim, because it
is just a compiled C++ binary. (That stops being true in cosim, where every
vector is a full RTL simulation. S0.2 discusses how many vectors to keep.)

Common failures and what they actually mean:

| Message | Cause |
|---|---|
| `ERROR: ... 'set_part' is not allowed ...` | You sourced `part.tcl` before `open_solution`. |
| `ERROR: [SYNCHK 200-11] ... unsupported ...` pointing at `main()` | You added the testbench without `-tb`. |
| `ERROR: [HLS 200-70] ... part 'xcku5p-...' is not installed` | Part name typo, or that family is not in your install. See probe B. |
| csim passes, csynth reports 0 cycles latency | The top function name is wrong, so nothing was synthesized. Check `set_top`. |

---

## 7. Step 6 — Read the generated tree

Run `find hls_proj -maxdepth 3 -type d | sort` and match it against this:

```
hls_proj/
  vitis_hls.log              <- full log of the last run
  solution1/
    solution1.aps            <- solution settings (what the GUI would edit)
    solution1.directive      <- directives as applied
    csim/
      build/                 <- compiled testbench binary, and anything it wrote
      report/                <- csim console log
    syn/
      report/                <- *** the estimate reports you will live in ***
      verilog/               <- generated RTL
      vhdl/
    sim/                     <- cosim outputs (empty until S0.2)
    impl/                    <- export outputs (empty until S0.2)
    .autopilot/db/           <- internal database; the schedule viewer reads this
```

Open `solution1/syn/report/tiny_csynth.rpt` and locate four things. You are not
expected to interpret them deeply yet — that is S0.3 — only to find them:

1. **Timing** — target period, estimated period, and **uncertainty**.
2. **Latency** — min/max latency and interval, in cycles.
3. **Utilization Estimates** — LUT, FF, DSP, BRAM.
4. **Interface** — the port table. For `tiny` you should see `ap_clk`,
   `ap_rst`, `ap_start`/`ap_done`/`ap_idle`/`ap_ready`, the two scalar inputs
   as `ap_none`, and `c` with a `c_ap_vld` companion. That is the `ap_ctrl_hs`
   block protocol plus `ap_vld` on the output. S0.4 takes this apart properly.

There is also a `.xml` next to the `.rpt` with the same numbers in machine
-readable form. That is what `collect.py` will parse in S6.2 — do not write
that script yet.

---

## 8. Step 7 — Four environment probes

The curriculum file lists these as unconfirmed. Confirm them now and write the
answers into `notes/env.md`, because every later exercise depends on them.

**Probe A — version.** The banner at the top of `hls_proj/vitis_hls.log` prints
the exact build on every run. Copy the full string, including the SW build
number.

**Probe B — part.** If `set_part xcku5p-ffvb676-2-e` did not error, the part is
installed and the question is settled. Confirm the report header names the same
part. If it did error, fall back to another installed Kintex UltraScale+ part
and record the substitution, because area numbers are only comparable within
one part.

**Probe C — clock uncertainty.** Vitis subtracts a default uncertainty margin
from your 3.33 ns before scheduling, so the scheduler is actually targeting
less than 3.33 ns. Read the exact value out of the Timing section of the
report. Once you know it, decide whether to pin it explicitly with
`set_clock_uncertainty` in `part.tcl`. Pinning it is the safer choice for a
repo whose whole point is comparing numbers across many runs.

**Probe D — auto-pipelining threshold.** This is the one that can quietly
invalidate half the repo, so measure it rather than trusting the documented
default of 64.

Temporarily add a second kernel with two loops:

```cpp
void probe(const int in[64], int out[64], int n) {
    // no pragmas anywhere
    for (int i = 0; i < 63; i++) out[i] = in[i] * 3;   // trip count 63
    for (int i = 0; i < 64; i++) out[i] = in[i] * 3;   // trip count 64
}
```

**Note: for this we created the `run_hls_probe.tcl`**

Synthesize it **twice**: once with `config_compile -pipeline_loops 0`
commented out, once with it active. In the first run, check the per-loop
latency/interval table in the report — if the threshold really is 64, the
trip-count-64 loop is pipelined (interval ≈ 1 per iteration) and the
trip-count-63 loop is not (interval ≈ loop body latency). In the second run,
neither should be pipelined.

Record the threshold you observed, and confirm that `-pipeline_loops 0` fully
suppresses auto-pipelining. Then delete the probe kernel.

`notes/env.md` should end up looking roughly like:

```markdown
# Environment
- Vitis HLS: <full banner string>
- Part: xcku5p-ffvb676-2-e, speed grade -2
- Clock: 3.33 ns target / 300 MHz
- Clock uncertainty: <observed> ns  (pinned explicitly: yes/no)
- Auto-pipeline threshold observed: <N>
- config_compile -pipeline_loops 0 suppresses it: yes/no
- Flow target: vivado (IP flow) for all exercises
```

---

## 9. Step 8 — Create `notes/results.csv`

Create the file now with only its header row, so that every later exercise
appends rather than invents a schema:

```
exercise,kernel,variant,dtype,N,sweep_param,sweep_value,II_target,II_achieved,latency_est,latency_cosim,LUT,FF,DSP,BRAM,fmax_est,fmax_impl,notes
```

S0.1 adds no data row — there is nothing here worth comparing. The first real
row arrives in S1.1.

A column worth flagging early: `II_target` versus `II_achieved`. Vitis will
accept a `PIPELINE II=1` directive, fail to meet it, issue a warning, and
continue with a larger II. If you only record what was achieved, you lose the
single most informative fact in the whole repo — *where the tool refused*.

---

## 10. Checkpoint

You are done with S0.1 when you can, without the GUI and without copying from
this file:

- Explain why `set_part` must follow `open_solution`.
- Explain what `-flow_target vivado` changes about the generated interfaces.
- Say from memory where the synthesis report and the generated Verilog live.
- State your install's auto-pipelining threshold and why it is disabled here.

---

## 11. Questions

**Q1.** You run the flow twice in a row without `-reset` on `open_solution`,
changing `directives.tcl` in between. The report changes in a way that does not
match your edit. What happened?

<details><summary>Answer</summary>

Directives accumulate in the solution. Without `-reset`, the second run's
directives are applied *on top of* the first run's, which are still recorded in
`solution1.directive`. So you are looking at the union of both directive sets,
not the new one. This also means removing a directive from `directives.tcl`
does not remove it from the solution. In batch, always use `-reset` on both
`open_project` and `open_solution`; it costs a few seconds and makes every run
reproducible from source alone.
</details>

**Q2.** Your testbench prints `PASS` and `csim_design` succeeds, but
`csynth_design` fails with a synthesizability error inside `printf`. What did
you get wrong, and why did csim not catch it?

<details><summary>Answer</summary>

The testbench was added with `add_files` instead of `add_files -tb`, so Vitis
treated it as synthesizable source. C simulation compiles *everything* as plain
C++, so `printf`, `malloc`, file I/O, and the standard library all work fine
there — csim can never catch a synthesizability problem. Only `csynth_design`
applies the synthesizable-subset rules. This asymmetry is the reason the two
steps exist separately: csim checks functional correctness, csynth checks
hardware legality.
</details>

**Q3.** The report gives an estimated clock period below your 3.33 ns target,
and estimated latency in cycles. Which of these two numbers is more likely to
be wrong by a large margin once you get to real hardware, and why?

<details><summary>Answer</summary>

The clock period. Latency in cycles comes from the schedule, which the tool
fully controls, so the csynth estimate is usually close — cosim (S0.2) mostly
confirms it, and where it differs the cause is a structural one such as
interface stalls or variable trip counts, not estimation error.

The period estimate is a different kind of number. It is derived from operator
delay models plus a fixed uncertainty margin, and it contains no information
about placement or routing. As a design grows or gets replicated, routing
degrades while this estimate stays flat. Only `export_design -flow impl`, which
runs the real Vivado flow, shows the wall. That is exactly why `results.csv`
has both `fmax_est` and `fmax_impl`, and why S6.2 runs implementation on a few
points only.
</details>

---

## 12. References

- AMD/Xilinx, *Vitis High-Level Synthesis User Guide* (UG1399), v2023.2 —
  authoritative reference for `open_solution`, `-flow_target`,
  `config_compile`, and the report contents. Match the document version to your
  install; Tcl option names moved between releases.
- J. de Fine Licht, M. Besta, S. Meierhans, T. Hoefler, "Transformations of
  High-Level Synthesis Codes for High-Performance Computing," *IEEE TPDS*
  32(5), 2021; arXiv:1805.08288 — the 15-transformation taxonomy this repo
  works through, starting at S2.
- R. Kastner, J. Matai, S. Neuendorffer, *Parallel Programming for FPGAs* (open
  access) — Chapter 1 covers the project/solution/flow model with worked
  examples.
- `spcl/hls_tutorial_examples` and `hlslib` (de Fine Licht & Hoefler) —
  reference `run_hls.tcl` structures worth comparing against yours.