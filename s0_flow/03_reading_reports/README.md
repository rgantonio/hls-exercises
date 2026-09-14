# S0.3 — Reading What the Tool Tells You

**Kernel:** `scale` (from S0.2), `*y = a*x + b`, `typedef int data_t`
**New files:** none in `src/` — this exercise reuses the S0.2 project
**Flow:** csynth (again) + report reading + GUI schedule viewer
**GUI:** allowed here, read-only. This is one of only two exercises that opens it (the other is 3.3).

---

## 1. Why this exercise exists

S0.1 and S0.2 got a design through the flow. Both times the interesting numbers
(latency 0, interval 1, 39 LUT, 1.016 ns) were read off the screen without
knowing where they came from or what else was in the file.

Every later exercise ends with a row appended to `notes/results.csv`. Those
columns — `II_achieved`, `latency_est`, `latency_cosim`, `LUT`, `FF`, `DSP`,
`BRAM`, `fmax_est` — all come out of two text files and one XML file. If reading
them is guesswork, every measurement in S1–S6 is guesswork.

The goal here is narrow: know which file holds which number, know what the
number means, and be able to pull it out without opening a GUI.

The schedule viewer is the one thing the text reports cannot give you: *which
cycle each operation happens in*. That is worth seeing once, early, on a kernel
small enough that the whole schedule fits on one screen.

---

## 2. Where the files are

After `csynth_design`, the solution directory looks like this (paths relative to
the project dir, `hls_proj/`):

```
hls_proj/
  scale/                              <- solution name from open_solution
    syn/
      report/
        csynth.rpt                    <- "Synthesis Summary" (new-style, 2020.2+)
        scale_csynth.rpt              <- per-function detailed report (old-style)
        csynth.xml                    <- same numbers, machine-readable
      verilog/  scale.v ...           <- generated RTL
      vhdl/
    sim/
      report/
        scale_cosim.rpt               <- measured latency, after cosim_design
        verilog/                      <- xsim run dir, wave data
    impl/                             <- only after export_design
    .autopilot/db/
      scale.adb                       <- schedule database (GUI reads this)
      scale.verbose.sched.rpt         <- text dump of the schedule (verify)
```

Two things to check on this install and write into `notes/env.md`:

1. Whether **both** `csynth.rpt` and `scale_csynth.rpt` exist, or only one. The
   split (summary vs detailed) was introduced around 2020.2 and the exact set of
   files varies with flow target. The IP flow (`-flow_target vivado`, which is
   what we use) normally writes both.
2. Whether `.autopilot/db/scale.verbose.sched.rpt` exists. If it does, the
   schedule is readable in batch and the GUI becomes optional for every later
   exercise. That is a useful thing to know now.

```bash
ls -1 hls_proj/scale/syn/report/
ls -1 hls_proj/scale/.autopilot/db/ | head -20
```

---

## 3. The Synthesis Summary (`csynth.rpt`) — section by section

Open it and read straight down. The sections are always in this order.

### 3.1 General Information

Date, tool version, project name, solution name, flow target, product family,
target device. Two reasons this matters:

- Every result in `results.csv` is only meaningful against a part. Confirm it
  says `xcku5p-ffvb676-2-e` and family `kintexuplus`. A number measured against
  a different part is a different number.
- The solution name here is what distinguishes the `naive` and `opt` rows from
  S1 onward, when one script produces two of these reports.

### 3.2 Timing

```
+ Timing:
    * Summary:
    +--------+---------+----------+------------+
    |  Clock |  Target | Estimated| Uncertainty|
    +--------+---------+----------+------------+
    |ap_clk  |  3.33 ns|   X.XXX ns|     0.90 ns|
    +--------+---------+----------+------------+
```

Four numbers, and the relationship between them is the whole story:

- **Target** — what `create_clock -period` asked for. 3.33 ns here.
- **Uncertainty** — margin the scheduler holds back for routing and clock skew
  it cannot see yet. S0.1 established this install uses 0.90 ns, the 27%
  default, not the older 12.5%.
- **Effective budget** = Target − Uncertainty = **2.43 ns**. This is the number
  the scheduler actually packs logic into. Nothing in the report states it
  directly; you compute it.
- **Estimated** — longest combinational path the scheduler produced, in ns.
  Compare against Target, but remember the scheduler was aiming at 2.43.

`fmax_est` in `results.csv` is `1000 / Estimated` in MHz. It is an *estimate
before place and route* — S0.1 already recorded that routing degradation never
appears here, only in `export_design -flow impl`. Treat `fmax_est` as a
direction indicator, not a frequency.

If Estimated exceeds Target, the report says so and synthesis still completes.
HLS reports a timing violation rather than failing. It is a warning in the log,
easy to miss if you are only reading the table — which is one reason
`2>&1 | tee run.log` is in the conventions.

### 3.3 Performance & Resource Estimates

This is the important table. One row per module and per loop:

```
  PS: '+' for module; 'o' for loop; '*' for dataflow
+---------+------+------+---------+--------+----------+---------+------+----------+------+----+-----+-----+-----+
| Modules | Issue|      | Latency | Latency| Iteration|         | Trip |          |      |    |     |     |     |
| & Loops | Type | Slack| (cycles)|  (ns)  |  Latency | Interval| Count| Pipelined| BRAM | DSP|  FF | LUT | URAM|
+---------+------+------+---------+--------+----------+---------+------+----------+------+----+-----+-----+-----+
|+ scale  |      |      |         |        |          |         |      |          |      |    |     |     |     |
```

Column by column:

- **Latency (cycles)** — clock cycles from `ap_start` to `ap_done` for one call.
  This is `latency_est`. When a design has data-dependent control flow you get
  min and max as separate columns; with fixed trip counts they are equal.
- **Latency (ns)** — cycles × Target period. Derived, not independently measured.
- **Iteration Latency** — for a loop row, cycles for *one* iteration of the loop
  body. Distinct from the loop's total latency.
- **Interval** — for a module, cycles between accepting one `ap_start` and being
  able to accept the next. For a loop row, this is the **initiation interval
  (II)** — cycles between the start of consecutive iterations. This is
  `II_achieved`, the column the entire course is built around.
- **Trip Count** — iterations. Blank or `?` when the tool cannot infer it, which
  is exactly what `LOOP_TRIPCOUNT` fixes in S1.1.
- **Pipelined** — `yes` / `no` / `dataflow`. Check this on every naive variant.
  If a baseline says `yes` without a pragma, auto-pipelining fired and the
  "before" case is already optimized. `config_compile -pipeline_loops 0` in
  `common/part.tcl` is what prevents that.
- **BRAM / DSP / FF / LUT / URAM** — resources for that module, inclusive of
  submodules.
- **Slack** — timing slack for that module specifically. A negative value
  localizes a timing violation to one module instead of the whole design.

The core relationship from the transformations paper, which S1.1 makes explicit:

$$C = L + I(N-1)$$

where $C$ is total cycles for a loop, $L$ is iteration latency, $I$ is the
initiation interval, and $N$ is the trip count. Every column needed to check that
equation is in this one table.

`scale` has no loops, so the table is a single `+ scale` row. That is the point
of doing it here — one row, nothing to misread.

### 3.4 Bind Op Report / Bind Storage Report

Which operations got bound to which hardware resource. For `scale` the multiply
is the interesting entry: whether `a*x` went to a **DSP48** or to fabric
(LUT-based multiplier).

This is the report that exercise 5.1 (`BIND_OP`) manipulates directly, and it
matters for the PDK-portability point recorded in S0.1: a DSP-bound multiply is
a Xilinx primitive, a fabric multiply is portable behavioral Verilog.

Check it now and note which one Vitis chose by default for a 32-bit int multiply
on this part.

---

## 4. The detailed report (`scale_csynth.rpt`)

Same numbers in the summary sections, then three things the summary omits.

### 4.1 Utilization Estimates, broken down

```
+ Summary:
+-----------------+---------+-------+--------+-------+-----+
|       Name      | BRAM_18K|  DSP  |   FF   |  LUT  | URAM|
+-----------------+---------+-------+--------+-------+-----+
|DSP              |         |       |        |       |     |
|Expression       |         |       |        |       |     |
|FIFO             |         |       |        |       |     |
|Instance         |         |       |        |       |     |
|Memory           |         |       |        |       |     |
|Multiplexer      |         |       |        |       |     |
|Register         |         |       |        |       |     |
|Total            |         |       |        |       |     |
|Available        |      960|   1824|  433920| 216960|   64|
|Utilization (%)  |         |       |        |       |     |
+-----------------+---------+-------+--------+-------+-----+
```

The row names tell you *where the area went*, which is far more useful than the
total when a transformation makes something unexpectedly large:

- **Expression** — combinational arithmetic and logic inferred from the C.
- **Instance** — instantiated submodules, including Xilinx IP cores. S0.2's float
  side-experiment put the FP adder and multiplier here; that is how you spot a
  black box.
- **Memory** — arrays that became BRAM/LUTRAM. Empty for `scale`. This row is
  what exercise 4.5 (`BIND_STORAGE`) moves around.
- **Multiplexer** — select logic. Grows quickly with array partitioning and with
  resource sharing; watch this in S3.0 and 5.2.
- **Register** — pipeline and state registers.

`Available` is fixed by the part and confirms S0.1's numbers. `Utilization (%)`
is rounded and reads `~0` for small kernels — always record absolute counts in
`results.csv`, never percentages.

Below the summary there are per-item **Detail** tables, one row per expression or
instance with its bitwidth and resource cost. For `scale` the whole design is a
handful of rows and it is worth reading every one, once. It will never be this
short again.

### 4.2 Interface summary

```
+ Interface
  * Summary:
  +---------+-----+-----+------------+--------------+--------------+
  | RTL Port| Dir | Bits|  Protocol  | Source Object|    C Type    |
  +---------+-----+-----+------------+--------------+--------------+
```

Five columns: the RTL signal name, direction, width, the handshake protocol,
which C argument it came from, and whether it was a scalar or a pointer.

S0.1 already recorded this for `tiny`: `ap_start`/`ap_done`/`ap_idle`/`ap_ready`
for the block control, inputs as `ap_none`, the pointer output as `ap_vld` with a
companion `*_ap_vld` signal. `scale` should look the same with one more input.

Confirm that, and note it — exercise 0.4 is entirely about changing these
protocols and diffing this exact table, so this is the baseline it diffs against.

### 4.3 `csynth.xml`

The same content in XML. This is what the S6.2 sweep script will parse instead of
scraping text. Worth a look now so the eventual script is not written blind.
The elements to find:

```bash
grep -E "EstimatedClockPeriod|Best-caseLatency|Worst-caseLatency|Interval" \
  hls_proj/scale/syn/report/csynth.xml
grep -A2 "<Resources>" hls_proj/scale/syn/report/csynth.xml
```

Roughly: `<PerformanceEstimates>` holds `<SummaryOfTimingAnalysis>` and
`<SummaryOfOverallLatency>`; `<AreaEstimates>` holds `<Resources>` and
`<AvailableResources>`. Confirm the exact tag names on this install and write
them into `notes/env.md` — the XML schema has changed across versions, and
S6.2 should not have to rediscover it.

### 4.4 The cosim report

`sim/report/scale_cosim.rpt`, written by `cosim_design`. This has **measured**
latency and interval from actually running the RTL, not estimates. That fills
`latency_cosim`.

The gap between `latency_est` and `latency_cosim` is the subject of S1.1, so do
not chase it here. Just find the file and confirm both numbers exist.

**Fold in the open S0.2 question while you are here.** S0.2's testbench splits
the vector count with `#ifdef __RTL_SIMULATION__` (1000 in csim, 16 in cosim) and
prints the count as the first line of `main`. That was never verified on this
install. Search `run.log` for the two printed counts:

```bash
grep -n -i "vectors" run.log
```

If csim prints 1000 and cosim prints 16, the macro works. If both print 1000,
Vitis 2023.2 does not define it during cosim — fall back to a single small count
for both. Either way, record the answer in `notes/env.md`; every later testbench
depends on it.

---

## 5. Pulling numbers out in batch

Before touching the GUI, get the habit of extracting from the command line. These
are throwaway one-liners, not a script — `collect.py` is a 6.2 deliverable and
writing it now would be premature.

```bash
# the whole performance/resource table
sed -n '/Performance & Resource Estimates/,/^$/p' hls_proj/scale/syn/report/csynth.rpt

# timing summary
sed -n '/+ Timing/,/^$/p' hls_proj/scale/syn/report/csynth.rpt

# interface table
sed -n '/+ Interface/,/^$/p' hls_proj/scale/syn/report/scale_csynth.rpt

# did anything go wrong
grep -E "ERROR|WARNING|CRITICAL" run.log
```

That last one deserves a habit of its own. Vitis reports a lot of things as
warnings that are actually design problems — unable to pipeline, II not met,
trip count unknown, dependency assumed. The report table shows the *result*;
the log says *why*.

---

## 6. The schedule viewer

The reports tell you how many cycles. The schedule viewer tells you what happens
in each one.

### 6.1 Opening it (read-only)

```bash
vitis_hls -p hls_proj
```

Then in the Explorer pane: solution `scale` → **Synthesis** → **Schedule
Viewer**. Some versions place it under an Analysis perspective; if it is not
where expected, note the actual path in `notes/env.md`.

**Rules for this project, since the GUI is otherwise off-limits:**

- Do not run synthesis from the GUI. Every result in `results.csv` must come
  from `vitis_hls -f run_hls.tcl` so it is reproducible.
- Do not add directives through the GUI. Right-clicking a loop and inserting a
  pragma writes into `solution1.directive` or into the source, and both break the
  convention that `directives.tcl` is the single source of truth. The
  tool-generated `.directive` file is never hand-edited.
- Look, close, go back to batch.

### 6.2 What you are looking at

Rows are operations. Columns are **control steps** — the FSM states, one per
clock cycle. A bar spans the cycles that operation occupies.

For `scale` the whole thing is a few rows. Find:

- the `read` of `x` and `a`
- the **multiply** — note how many control steps its bar spans
- the **add** — note whether it sits in the same column as the multiply
  (chained) or the next one
- the `write` to `y`, and where `ap_done` asserts relative to it

Clicking an operation highlights the originating C line. The properties pane
gives the operation type, bitwidth, estimated delay in ns, and the bound resource
(this is where you can confirm the DSP-vs-fabric answer from §3.4 visually).

### 6.3 Chaining — the thing worth understanding

Two operations in the same column are **chained**: their combined combinational
delay fit inside one clock period, so the scheduler put them in one cycle with no
register between.

That is the mechanism behind the 2.43 ns effective budget. Whether the multiply
and the add chain into one cycle or get split across two is a direct consequence
of Target minus Uncertainty. It is also why tightening the clock changes latency
even though the C code is unchanged — the same operations get spread across more
cycles.

Which is worth demonstrating rather than asserting.

---

## 7. Experiment — make a violation happen

Add a second solution to `run_hls.tcl` with a deliberately impossible clock. Two
solutions in one script is the S0.1 convention, and this is the first exercise
where there is a reason to use it.

```tcl
# ---- solution 2: tight clock, to force a timing violation ----
open_solution -reset "tight" -flow_target vivado
source ./common/part.tcl
create_clock -period 1.5 -name default    ;# override the 3.33 from part.tcl
csynth_design
```

`create_clock` after sourcing `part.tcl` overrides the period set there. Note
that uncertainty is a percentage, so the effective budget scales down with it:
1.5 ns target leaves roughly 1.1 ns to schedule into.

Run it, then compare the two solutions:

```bash
vitis_hls -f run_hls.tcl 2>&1 | tee run.log
diff hls_proj/scale/syn/report/csynth.rpt hls_proj/tight/syn/report/csynth.rpt
```

**Predict before you look.** Write down, on paper:

1. Does Estimated exceed Target in the `tight` solution — yes or no?
2. Does latency in cycles go up, stay the same, or go down?
3. Does resource usage change?

Then check. Three outcomes are possible and all are informative:

- **Timing violation reported, latency unchanged** — the scheduler could not
  split the path and gave up, reporting negative slack. The design is not usable
  at that clock.
- **Latency increased, timing met** — the scheduler inserted registers, breaking
  the chained multiply-add across more cycles. This is the chaining effect from
  §6.3 made visible.
- **Nothing changed** — the path was already short enough. Note the Estimated
  value; you now know the real floor for this kernel.

Open the schedule viewer on `tight` and compare against `scale`. If the operation
bars moved to different columns, you have seen scheduling respond to a constraint
directly.

Record the outcome in `notes/findings.md`. Then decide whether to keep the
`tight` solution in the script or delete it — it is a teaching artifact, not a
baseline, and every later exercise will re-run this script.

---

## 8. What to record

**`notes/env.md`:**
- Which report files this install writes (`csynth.rpt`, `<top>_csynth.rpt`, both)
- Whether `.autopilot/db/scale.verbose.sched.rpt` exists — if so, the schedule is
  batch-readable and the GUI is optional from here on
- The `csynth.xml` tag names for latency, interval, timing, resources
- Where the Schedule Viewer lives in the 2023.2 GUI
- **The `__RTL_SIMULATION__` answer from §4.4** — this closes an S0.2 open item
- Default bind for a 32-bit int multiply on `xcku5p`: DSP or fabric

**`notes/results.csv`** — first real row, establishing the habit:

```
exercise, kernel, variant, dtype, N, sweep_param, sweep_value, II_target,
II_achieved, latency_est, latency_cosim, LUT, FF, DSP, BRAM, fmax_est,
fmax_impl, notes
```

Fill `s0.3, scale, base, int, 1, -, -, -, <Interval>, <Latency cycles>,
<cosim latency>, ...` and leave `fmax_impl` empty — no `-flow impl` run has
happened. Add the `tight` row too if you keep that solution.

**`notes/findings.md`:** the prediction-vs-outcome from §7.

---

## 9. Questions

<details>
<summary>1. The report says Target 3.33 ns and Uncertainty 0.90 ns. What clock period is the scheduler actually designing to, and why does the tool not just say that number?</summary>

2.43 ns. Uncertainty is margin held back for effects HLS cannot see: place-and-route wire delay, clock skew, jitter. HLS schedules against Target − Uncertainty so that the design still meets Target after Vivado has routed it.

It is not reported as a single number because the two components are conceptually different — one is your constraint, the other is the tool's guess about downstream loss. Keeping them separate lets you override the guess with `set_clock_uncertainty` when you have real post-implementation data. Pinning it explicitly in `part.tcl` is worth doing so every `results.csv` row was produced under the same assumption.
</details>

<details>
<summary>2. A loop row shows Iteration Latency 4, Interval 1, Trip Count 100. What is the loop's total latency, and what does Interval 1 mean physically?</summary>

$C = L + I(N-1) = 4 + 1 \times 99 = 103$ cycles.

Interval 1 (II=1) means a new iteration starts every clock cycle. The loop body still takes 4 cycles end to end, but 4 iterations are in flight simultaneously at steady state, each at a different stage. Throughput is one iteration per cycle; latency per iteration is still 4.

II is the number that matters for throughput. Iteration latency mostly matters for the pipeline fill and drain cost, which is the $L$ term — negligible at $N=100$, dominant at $N=4$.
</details>

<details>
<summary>3. Why record absolute LUT/FF/DSP counts rather than the Utilization (%) column?</summary>

Three reasons. The percentage is rounded and reads 0 for everything small — useless for the early exercises. It is relative to one specific part, so no row is comparable against a row from a different device. And the sweeps in 3.1 and 3.2 are about *scaling behaviour* — whether area grows linearly or super-linearly with the unroll factor — which needs the raw counts.
</details>

<details>
<summary>4. `scale` has no loops. Why is it still worth reading the Performance & Resource Estimates table here instead of waiting for a kernel with loops?</summary>

Because the table is one row. Every column can be located and understood without ambiguity about which row it belongs to. When S2.2 produces a nested-loop design with six rows and a dataflow region, knowing the column semantics cold means the only new thing to work out is the structure.

The same argument applies to the Utilization Detail tables: `scale` is the last design where reading every row is feasible.
</details>

<details>
<summary>5. The GUI can insert directives by right-clicking a loop. Why is that banned in this project?</summary>

The convention is that `directives.tcl` holds every `set_directive_*` and kernel source stays identical across variants, so a diff between naive and optimized shows only the intended change. GUI insertion writes either an in-source pragma or an entry in the tool-generated `solution1.directive`, and neither is under that file's control.

Worse, it is silent: a directive added through the GUI persists in the solution and, without `-reset`, survives into later runs. That is the same accumulation failure mode S0.1 established `-reset` to prevent — a result that cannot be reproduced from the script is not a result.
</details>

---

## 10. Checklist before moving to S0.4

- [x] Located both report files and `csynth.xml`; file set recorded in `env.md`
- [x] Can state Target, Uncertainty, effective budget, and Estimated for `scale`
- [x] Can name every column of the Performance & Resource Estimates table
- [x] Read the Utilization Detail and Interface tables for `scale` in full
- [x] Found `scale_cosim.rpt` and the measured latency
- [x] Resolved the `__RTL_SIMULATION__` question and recorded it
- [x] Opened the schedule viewer, identified the multiply and add, noted chaining
- [x] Ran the tight-clock experiment, predicted first, recorded the outcome
- [x] First `results.csv` row written

**Next: S0.4 — interfaces and control.** It diffs the Interface summary table
from §4.2 across `ap_ctrl_hs` / `ap_ctrl_chain` / `ap_ctrl_none` and the port
protocols `s_axilite`, `m_axi`, `ap_fifo`, `ap_memory`, `ap_none`, `ap_vld`.
Reading that table is a prerequisite, which is why this exercise came first.

---

## References

- AMD/Xilinx, *Vitis HLS User Guide* (UG1399), v2023.2 — synthesis report
  contents, the Schedule Viewer, clock uncertainty, and `BIND_OP` / interface
  directive reference. Version-specific; check against the installed version.
- J. de Fine Licht, M. Besta, S. Meierhans, T. Hoefler, "Transformations of
  High-Level Synthesis Codes for High-Performance Computing," *IEEE TPDS* 32(5),
  2021; arXiv:1805.08288 — Section 2 for the latency/II performance model
  $C = L + I(N-1)$ used throughout this curriculum.
- R. Kastner, J. Matai, S. Neuendorffer, *Parallel Programming for FPGAs* (open
  access) — worked examples of relating report numbers back to kernel structure.