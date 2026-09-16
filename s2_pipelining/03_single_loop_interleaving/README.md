# S2.1.3 — Single-loop accumulation interleaving

S1.2 left `accumulate` in float at II=7. The running sum `acc` is read and written in every iteration, and the float add takes 7 cycles, so each iteration has to wait for the previous iteration's add to finish.

This exercise removes that wait without touching the adder or the clock. It keeps $K$ running sums instead of one, so each sum is touched only once every $K$ iterations. The cost is $K$ registers, a second small loop, and a result that is no longer bit-identical to the sequential sum.

This is the first S2 exercise, and the first exercise in the repo with a real sweep (over $K$).

# Why single-loop accumulation interleaving exists

## 1. Where the problem starts

Take the simplest reduction there is: add up 1024 numbers.

```cpp
acc = 0;
for (i = 0; i < 1024; i++)
    acc = acc + x[i];
```

In software this is trivial. In hardware, `acc` is one register and `+` is one adder circuit. S1.1 showed what we want from a loop: pipeline it, so a new iteration starts every cycle (II=1) while the earlier ones are still moving through the stages.

The trouble comes from the adder's speed. A float add is too big to finish in one 3.33 ns clock cycle, so Vitis splits it into stages. In S1.2, the fastest float adder it would use took 7 cycles.

Now look at what iteration 1 needs. It computes `acc + x[1]`, where `acc` must already contain `x[0]`. That value is not ready until iteration 0's add finishes, 7 cycles after iteration 0 started.

| iteration | wants to read `acc` at cycle | `acc` is ready at cycle | OK? |
|---|---|---|---|
| 0 | 0 | — (starts at 0) | yes |
| 1 | 1 (if II=1) | 7 | **no**: it would read a stale value |
| 1 | 7 (if II=7) | 7 | yes |

So Vitis has to space the iterations 7 cycles apart. That is the II=7 measured in S1.2.

The pipeline is mostly idle. Only one number is inside the adder at a time, and the other stages sit waiting. You get one input per 7 cycles, where you wanted one per cycle.

This only happens because the add is slow. An int add fits in one cycle, which is why `acci` reached II=1 with the exact same loop.

---

## 2. What is being solved

The obvious fixes are not available:

- **A faster adder.** 7 cycles is already the fastest float adder the tool would use at this clock.
- **A slower clock.** That would slow down everything else in the design too.
- **Letting the tool reorder the additions.** It refuses, because float addition is not associative, so a different order gives different bits (S1.2 Q1).

So the adder stays 7 cycles. What we *can* change is **how soon an iteration needs the result of an earlier one**.

S1.2's model says it exactly. If an iteration reads a value that was written $d$ iterations earlier, and producing that value takes $\delta$ cycles, then:

$$I \cdot d \ge \delta$$

Right now $d = 1$ (each iteration needs the previous one) and $\delta = 7$, so $I \ge 7$.

We cannot shrink $\delta$. So the goal is to **make $d$ large**: arrange things so each iteration depends on one that started long enough ago that its add is already finished. If $d \ge 7$, then $I = 1$ satisfies the inequality.

---

## 3. How to solve it

Use several running sums instead of one. With $K = 7$ sums (call them "lanes"), iteration $i$ adds `x[i]` to lane $i \bmod 7$:

- lane 0 collects `x[0], x[7], x[14], ...`
- lane 1 collects `x[1], x[8], x[15], ...`
- ... and so on up to lane 6.

Each lane is touched only once every 7 iterations, so $d = 7$. With II=1, here is the timeline:

| iteration | starts at cycle | lane | that lane's previous value is ready at cycle | OK? |
|---|---|---|---|---|
| 0 | 0 | 0 | — | yes |
| 1 | 1 | 1 | — | yes |
| ... | ... | ... | ... | ... |
| 6 | 6 | 6 | — | yes |
| 7 | 7 | **0** | 7 (from iteration 0) | yes, just in time |
| 8 | 8 | **1** | 8 (from iteration 1) | yes |

Every iteration now reads a lane whose last update has already come out of the adder. Seven numbers are inside the adder pipeline at once, one per stage, so the pipeline is full instead of mostly idle.

After the loop, a second small loop adds the 7 lanes together to get the final sum. That is the "two stages" in the paper [1, Sec. 2.1.3]: stage one does the 1024 inputs at II=1, and stage two does only 7 additions.

### The sweep over K

The lesson also asks what happens when $K$ is too small. With $K = 2$, lane 0 is needed again after 2 iterations, so $I \cdot 2 \ge 7$ gives $I = 4$. The general rule is:

$$I = \left\lceil \frac{7}{K} \right\rceil$$

| $K$ | II |
|---|---|
| 1 | 7 |
| 2 | 4 |
| 4 | 2 |
| 7 | 1 |

Going beyond $K = 7$ buys no more cycles.

### What you get and what you pay

- **Speed:** the main loop goes from about 7170 cycles to about 1032, roughly 7× faster.
- **Registers:** $K$ lanes of 32 bits each.
- **A second loop:** it adds the lanes together.
- **A slightly different answer:** the numbers are added in a different grouping, and float rounding depends on grouping. This is why it is a decision for the designer to make, not something the tool does automatically.

### Where the two forms fit

The shift form and the index form in `README.md` are just two ways of writing "use lane $i \bmod K$" in C.

- **Index form:** stores the lane number in a counter.
- **Shift form:** passes values along a chain of $K$ registers, so the one read now is always the one written $K$ iterations ago.

The hardware idea is the same. The experiment checks which way of writing it Vitis actually understands.

### What it is for in general

Any running total over a long stream where the combining operator takes several cycles: float sums, dot products, norms, means, or even integer sums once the adder gets too wide for the clock.

### A few things to know

**It is not an input buffer**. The inputs go straight into the adder, one per cycle, and are never held back. What gets buffered is the running total: the single `acc` register is replaced by 7 registers, each holding a partial sum. They hold "the sum of everything so far that belongs to lane $r$", not the 7 most recent inputs.

An input buffer would not help anyway. The problem was never fetching inputs fast enough. It was that each add had to wait for the previous add's result to come back around the feedback loop.

**There is still only one adder**. The 7 lanes do not mean 7 adders. There is one float adder with 7 pipeline stages, which is why the README predicts the same DSP count for the main loop as base/pipe. What changes is how full that adder is:

- Before: one addition moves through the 7 stages while the other 6 stages sit empty, because the next addition needs the result first.
- After: a new addition enters every cycle, so all 7 stages are busy at once, each holding a different addition at a different point of completion.



# Worked example: how the lanes add up

---

## 1. A pipelined adder accepts a new input every cycle

There are two ways to build an adder that takes 7 cycles:

1. **Multi-cycle adder.** One block of logic works on a single addition for 7 cycles, with a small state machine keeping track. It really is busy until the addition finishes.
2. **Pipelined adder.** The work is cut into 7 slices with a register between each. A float add roughly means: line up the exponents, add the mantissas, normalize, round. Each slice does its part in one cycle and passes its result into the next register.

Vitis uses the second kind. With registers between the slices, stage 1 can take a new pair of numbers in the same cycle that stage 2 takes over the previous pair, like an assembly line. "Latency 7" means *one* addition needs 7 cycles to get through. It does not mean the adder is locked for 7 cycles.

This has already appeared in the repo. In S1.1, `vec_scale`'s multiplier took more than one cycle, yet the loop ran at II=1, because several iterations were inside the multiplier at the same time.

So the adder was never what forced II=7 in `accumulate`. The only thing forcing it was that each addition needed the *previous addition's answer* as its input. The example below shows that concretely.

---

## 2. Setup for the example

To keep the tables readable, everything is shrunk:

- **the adder has 3 stages** (instead of 7);
- **9 inputs:** `x = [5, 2, 8, 1, 7, 3, 4, 6, 9]`, whose true sum is **45**;
- **integers**, so the numbers are easy to follow;
- **one simplification:** the input read and the write-back are free. An iteration reads its register at the start of its cycle, and the result is written at the end of its 3rd stage.

"S1 / S2 / S3" are the adder's pipeline stages. `a+b` in a stage means that addition is in progress there.

---

## 3. Case A: one `acc` register, II=3 (what Vitis does now)

Iteration 1 cannot enter until iteration 0's result is back in `acc`, so a new input enters only every 3 cycles.

| cycle | new input | S1 | S2 | S3 | `acc` at end of cycle |
|---|---|---|---|---|---|
| 0 | x0=5 | 0+5 | – | – | 0 |
| 1 | – | – | 0+5 | – | 0 |
| 2 | – | – | – | 0+5 | **5** |
| 3 | x1=2 | 5+2 | – | – | 5 |
| 4 | – | – | 5+2 | – | 5 |
| 5 | – | – | – | 5+2 | **7** |
| 6 | x2=8 | 7+8 | – | – | 7 |
| ... | | | | | |

Only one stage is ever busy. The 9 inputs take $3 + 3 \cdot 8 = 27$ cycles, and the answer is correct: 45.

---

## 4. Case B: one `acc` register, forced to II=1 (broken)

Now push a new input in every cycle anyway. Each iteration reads whatever is in `acc` at the start of its cycle.

| cycle | new input | reads `acc` = | S1 | S2 | S3 | `acc` at end of cycle |
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

The final value is 20, not 45. But look at which iterations actually build on each other: each one reads the result written 3 iterations earlier. The register is really carrying **three separate running sums**:

- iterations 0, 3, 6: $5 \to 6 \to 10$
- iterations 1, 4, 7: $2 \to 9 \to 15$
- iterations 2, 5, 8: $8 \to 11 \to 20$

Each of those three sums is correct on its own, and $10 + 15 + 20 = 45$. The design fails only because all three share **one** register and keep overwriting each other, so only the last one (20) survives.

---

## 5. Case C: three lane registers, II=1 (interleaving)

The fix follows directly from Case B: give each of those three chains its own register. Iteration $i$ reads and writes lane $i \bmod 3$. The adder is exactly the same; only the register read and written changes.

| cycle | new input | reads | S1 | S2 | S3 | written at end | lanes L0, L1, L2 after cycle |
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

**What to notice:**

- **The S1/S2/S3 columns are identical in Case B and Case C.** One adder, all three stages full from cycle 2 onward, three different additions in flight at once.
- **Every read is exactly on time.** Take cycle 3: iteration 3 reads L0, and L0 was written at the end of cycle 2. The result coming out of S3 each cycle is always the one the next entering iteration needs.
- **The cycle count matches the model.** 9 inputs take $3 + 1 \cdot 8 = 11$ cycles, against 27 in Case A. That is $C = L + I(N-1)$ with $I = 1$ instead of $I = 3$.
- **In the first 3 iterations the lane is still 0**, so the adder computes `0 + input`. From iteration 3 onward, it adds an input to a real partial sum.
- **The main loop simply stops when the inputs run out.** After the last input enters at cycle 8, the additions still inside the adder finish over cycles 9 and 10 and land in their lanes.

**Too few lanes.** Say you used only 2 lanes with the 3-stage adder. Then iteration 2 reads L0 at cycle 2, but iteration 0's result is not written until the end of cycle 2. That read is stale, so the tool must slow down to II=2, as $\lceil 3/2 \rceil = 2$ says.

---

## 6. The second loop: COMBINE

The main loop leaves three partial sums: L0 = 10, L1 = 15, L2 = 20. Every addition in the main loop is "one lane plus one input", so it has no way to add the lanes together. A separate loop does that:

```cpp
total = 0;
for (k = 0; k < 3; k++)
    total = total + lane[k];
```

| step | `total` so far | lane | result |
|---|---|---|---|
| 1 | 0 | L0 = 10 | 10 |
| 2 | 10 | L1 = 15 | 25 |
| 3 | 25 | L2 = 20 | **45** |

So the design has two adders:

- **adder 1**, inside `ACC`: lane + input, $N$ times, at II=1;
- **adder 2**, inside `COMBINE`: total + lane, only $K$ times.

That is why the README predicts DSP = 4 on the interleaved designs (two float adders at 2 DSP each), against DSP = 2 for `base/pipe`. If the tool reuses the idle `ACC` adder for `COMBINE`, DSP comes back as 2.

`COMBINE` has the original problem: `total` needs the previous addition's result, so its additions run one after another at the full adder latency. That is acceptable because there are only $K$ of them. In the real lesson that is 10 additions of about 12 cycles, roughly 120 cycles, next to about 1032 cycles for the 1024 inputs (README Q2).

### Two meanings of "stage"

| term | what it means | in this example |
|---|---|---|
| **pipeline stage** | one slice of the adder circuit, with a register after it | S1, S2, S3 inside the adder |
| **paper's "two stages"** | two separate loops that run one after the other | stage 1 = `ACC` over the inputs; stage 2 = `COMBINE` over the lanes |

---

## 7. Summary

- **Is it an input buffer?** No. Inputs are never held back. The extra registers hold partial *results*.
- **Are there $K$ adders in the main loop?** No, there is one adder. All of its stages are busy at the same time, each with a different addition at a different point of completion.
- **Is II=1 an illusion?** No. A new input really enters every cycle, and an addition really completes every cycle. The lanes just make sure each completed result goes to a register that the addition entering next can safely use.
- **Scaling back up to the lesson.** 3 stages become 7, 3 lanes become $K = 7$, and 9 inputs become 1024.

---

## References

[1] J. de Fine Licht, M. Besta, S. Meierhans, T. Hoefler, "Transformations of High-Level Synthesis Codes for High-Performance Computing," *IEEE Trans. Parallel and Distributed Systems*, 32(5), 2021. arXiv:1805.08288. Sec. 2 (loop-carried dependencies), Sec. 2.1.3 and Lst. 2 (single-loop accumulation interleaving).

---

## 0. Setup

**Prerequisites:**
- S1.2 run.
- `common/part.tcl` in place (part `xcku5p-ffvb676-2-e`, 3.33 ns clock, `config_compile -pipeline_loops 0`).
- `common/collect_latency.sh` and `common/collect_resources.sh`.

**Files in this directory**

```
s2_pipelining/03_single_loop_interleaving/
  README.md
  run_hls.tcl
  src/accumulate.h  src/accumulate.cpp  src/tb_accumulate.cpp     (copied from S1.2, header fixed)
  src/acc_il.h      src/acc_shift.cpp   src/acc_index.cpp   src/tb_acc_il.cpp
  directives_accumulate_pipe.tcl
  directives_acc_shift_pipe.tcl
  directives_acc_index_pipe.tcl
  directives_acc_index_pipe_dist.tcl
```

Copy the S1.2 kernel and testbench, then replace the header with the fixed version in 4.1:

```bash
cp ../../s1_model/02_pipeline_blockers/src/{accumulate.cpp,tb_accumulate.cpp} src/
```

**Solution roster.** There are seven projects in one `run_hls.tcl`. $K$ is a compile-time constant passed with `-cflags` on `add_files`, which is a project-level command, so each $K$ needs its own project.

| project          | top          | $K$ | solution    | what it is                                                          |
|------------------|--------------|-----|-------------|---------------------------------------------------------------------|
| `base_proj`      | `accumulate` | —   | `seq`       | S1.2 baseline, re-run                                               |
| `base_proj`      | `accumulate` | —   | `pipe`      | S1.2 dependency blocker, re-run (II=7)                              |
| `shift_k1_proj`  | `acc_shift`  | 1   | `pipe`      | shift form with one lane: must behave like `base/pipe`              |
| `shift_k2_proj`  | `acc_shift`  | 2   | `pipe`      | sweep point                                                         |
| `shift_k4_proj`  | `acc_shift`  | 4   | `pipe`      | sweep point                                                         |
| `shift_k7_proj`  | `acc_shift`  | 7   | `pipe`      | sweep point: $K$ equal to the fast `fadd` latency                   |
| `shift_k10_proj` | `acc_shift`  | 10  | `pipe`      | sweep point: $K$ equal to the relaxed `fadd` latency                |
| `index_k10_proj` | `acc_index`  | 10  | `pipe`      | index form, no help given to the tool                               |
| `index_k10_proj` | `acc_index`  | 10  | `pipe_dist` | index form, plus a dependence directive stating the distance is 10  |

**Why `base_proj` is re-run.** In S1.2, `lat_accf.md` was never collected. So the two numbers every prediction below depends on are still expectations, not measurements:
- the `fadd` latency under `pipe` (expected 7);
- the loop C of `base/pipe` (expected 7170).

Pass 1 measures them.

**Speedup baseline.** In S1.2 the speedup column was always against the kernel's own `seq`. An interleaved kernel has no meaningful `seq`, so here every speedup is against `base/seq` and `base/pipe`. That compares the transformation against the code it replaces.

**Conventions carried in from S1.2.** These are applied here and still pending in the S1.2 README:
- `accumulate.h` uses `#error` instead of a silent `DATA_T` fallback.
- The `Bind Op Report` is read from the design-wide `syn/report/csynth.rpt` only.
- $D_{\text{add}}$ is read per solution, never carried over from `seq`.
- $L_p$ comes from stage counting and is cross-checked against loop C. Both the `Iteration Latency` column and the log's `Depth` read $L_p + 1$ on pipelined loops.
- II is always recorded together with the clock estimate and whether HLS 200-871 was printed.

**New in the script.** The `RUNS` dict gains `top`, `tb`, `K` and `cosim` keys. An `ONLY` list picks which projects to run, so pass 1 is a one-word edit. Directive files can use `$K`.

---

## 1. The transformation

**Source:** de Fine Licht et al. [1, Sec. 2.1.3, Lst. 2].

**Idea.** Keep $K$ running sums ("lanes") instead of one. Iteration $i$ adds `x[i]` to lane $i \bmod K$. A given lane is touched once every $K$ iterations, so the dependency distance goes from $d = 1$ to $d = K$. A second loop then adds the $K$ lanes together.

**The model from S1.2**, $I_{\text{dep}} = \lceil \delta / d \rceil$, with $d = K$ and $\delta = D_{\text{add}}$, gives:

$$I = \max\left(1,\ \left\lceil \frac{D_{\text{add}}}{K} \right\rceil\right)$$

So $K \ge D_{\text{add}}$ reaches $I = 1$. For $N \gg L_p$, the accumulation loop speeds up over `base/pipe` by about

$$\frac{C_{\text{base/pipe}}}{C_{K}} \approx \frac{D_{\text{add}}}{\lceil D_{\text{add}}/K \rceil}$$

which saturates at $D_{\text{add}}$ once $K \ge D_{\text{add}}$.

**What it costs.**
- **Registers:** $K$ lanes of 32 bits each.
- **A second stage:** $K$ more additions, done after the main loop.
- **A second `fadd` instance:** most likely, one for each stage.
- **Different result bits.** Float addition is not associative (S1.2 Q1), so grouping the terms into lanes changes the rounding. This is why the tool will never do the transformation for you: it is a designer's decision to accept a different answer.

**Two ways to write it.** Both hold the same lane contents. They ask the tool different questions, which is the second thing this exercise tests.

- **Index form** (`acc_index`, the paper's Lst. 2): `lane[c] += x[i]`, with a wrap-around counter `c`.
  - The paper uses $K = 16$ and `i % 16`, which is just a bit select for a power of two. For $K = 7$ or $10$, `%` would build a divider, so a counter is used instead.
  - The paper also avoids a reset loop with a guard, `(i < 16) ? 0 : t[i % 16]`. This exercise uses an explicit `INIT` loop because it is easier to read. It costs about $K$ extra cycles.
  - **What the tool must see:** that `lane[c]` in iteration $i$ and `lane[c]` in iteration $i+1$ are different elements. That requires knowing how `c` evolves.

- **Shift form** (`acc_shift`): `s = lane[K-1] + x[i]`, shift every lane up by one, then `lane[0] = s`.
  - A value written to `lane[0]` in iteration $i$ is in `lane[1]` at $i+1$, ..., in `lane[K-1]` at $i+K-1$, and is read by iteration $i+K$. So $d = K$.
  - The distance is set by position in a register chain, not by an index value.
  - **What the tool must see:** that each register hop between iterations gives $I$ cycles of slack, so $K$ hops give $K \cdot I \ge D_{\text{add}}$.


Both cases do the same functionality but with subtle differences:

## Shift form vs index form

| | index form | shift form |
|---|---|---|
| **how the right lane is found** | a counter `c` selects it | always the last register; the shift brings the right value there |
| **how `lane` is stored** | kept as an array: a K-entry LUTRAM (`RAM_AUTO_1R1W`), one read and one write per iteration | partitioned into K registers, since every lane moves every iteration |
| **what the tool must work out** | that `lane[c]` repeats every K iterations; it doesn't track `c`, so you state it with `-distance` | that K register hops give K cycles of slack; visible directly in the code |
| **final lane order** | class $j$ in lane $j$ | rotated: lane $j$ holds class $(N-1-j) \bmod K$ |
| **measured area at K=10, II=1** | LUT 1086, FF 1091 | LUT 1241, FF 1979 |
| **measured clock estimate** | 2.969 ns (RAM read in front of the `fadd`) | 2.719 ns |

Both forms describe the same hardware idea. The shift form writes it in a way the tool can see; the index form is easier to read, but the tool needs the dependence directive to schedule it at II=1, and that directive only works while `lane` is still an array (see 4.3).


---

## 2. The blocker

**What S1.2 measured on `accf`.**

| solution | what was measured |
|----------|-------------------|
| `seq`  | `ACC` iteration latency 14; loop C 14336; `fadd` latency 10; est. 2.262 ns |
| `pipe` | Final II 7; log `Depth` 10, so $L_p = 9$; 6 II-violation lines; est. 2.719 ns with HLS 200-871 |
| `pipe`, expected but not collected | `fadd` latency 7; loop C $= 9 + 7 \cdot 1023 = 7170$ |

**What holds II at 7.** `acc` has $d = 1$ and $\delta = D_{\text{add}}$. Under the II=1 target, the tool swapped the relaxed `fadd` core (latency 10) for a faster one (latency 7). That lowered II from 10 to 7 but took the timing estimate past the 2.43 ns effective budget. S1.2 found II was not lowered below 7, which suggests 7 is the fastest `fadd` the tool will use at this clock. Call it $D_{\min}$. Call the relaxed core's latency $D_{\text{seq}} = 10$.

**What must not become a new blocker.**

- **Ports.** `x[i]` is read once per iteration ($A = 1$), so the port bound stays at 1 with the default single port.
- **Shift form: the lanes must be registers.** It touches every entry every iteration ($A \approx K$), so as a $K$-entry RAM it would hit a port blocker in place of the dependency blocker. The shift solutions therefore partition `lane` completely into registers. This is a one-line preview of S3.0.
- **Index form: the lanes must stay an array.** It does one read and one write per iteration, which a 1R1W RAM serves at II=1, so there is no port blocker. More importantly, a complete partition breaks the dependence directive:
  - the partition turns `lane[c]` into a K-to-1 read mux and K registers named `mux_case_0` … `mux_case_{K-1}`;
  - `set_directive_dependence -variable lane` then matches nothing, and the tool prints no warning about it;
  - the pipeline sees an ordinary register with $d = 1$ and stays at II=7.

  The index solutions therefore do not partition `lane`.

---

## 3. Predict

Do all three stages before looking at any interleaved report.

### Stage A — shape only (before any run)

| row                   | II achieved = 1? | HLS 200-871? | FF vs `base/pipe` | DSP |
|-----------------------|------------------|--------------|-------------------|-----|
| `shift_k1/pipe`       |                  |              |                   |     |
| `shift_k2/pipe`       |                  |              |                   |     |
| `shift_k4/pipe`       |                  |              |                   |     |
| `shift_k7/pipe`       |                  |              |                   |     |
| `shift_k10/pipe`      |                  |              |                   |     |
| `index_k10/pipe`      |                  |              |                   |     |
| `index_k10/pipe_dist` |                  |              |                   |     |

<details><summary>Expected shape</summary>

- **`shift_k1`:** the same loop as `base/pipe`, so II=7 with the timing warning. It has one extra `fadd` for `COMBINE`, so DSP 4.
- **`shift_k2`, `shift_k4`:** refuse II=1 and settle at 4 and 2. FF above `base/pipe` by about $32K$. DSP 4.
- **`shift_k7`, `shift_k10`:** reach II=1.
  - `k7` must use the fast core, so expect the timing warning.
  - `k10` has room for the relaxed core ($D \le 1 \cdot 10$). If the tool takes it, the warning disappears.
- **`index_k10/pipe`:** refuses, at II=7. Without help, the tool cannot tell which lane `c` selects, so it assumes $d = 1$.
- **`index_k10/pipe_dist`:** II=1. FF clearly below `shift_k10`, because the lanes sit in a 10 × 32-bit LUTRAM instead of 320 register bits plus their pipeline copies. LUT also below `shift_k10`. The clock estimate is worse than `shift_k10`, because the RAM read sits in front of the `fadd`.

The DSP prediction assumes the tool does not share one `fadd` between the pipelined `ACC` loop and the sequential `COMBINE` loop. A result of DSP 2 would mean it did.

</details>

### Stage B — to the cycle (after the first pass)

**First pass.** In `run_hls.tcl`, set `ONLY {base_proj}` and `DO_COSIM 0`, then run. This is S1.2's `accf_proj` again, and this time the numbers get collected:

```bash
C=../../common
PROJ=base_proj TOP=accumulate OUT=lat_base.md bash $C/collect_latency.sh
```

**What to read.**

| quantity | where | what you expect |
|----------|-------|-----------------|
| $D_{\text{seq}}$ | `fadd` row of the `Bind Op Report` in `base_proj/seq/syn/report/csynth.rpt` | 10, as in S1.2 |
| $D_{\min}$ | the same row in `base_proj/pipe/syn/report/csynth.rpt` | 7 |
| $L_p$ | $L_p = C - 7 \cdot 1023$, from the loop C of `base/pipe` | 9 |

Then check $L_p$ by counting stages:
- the read of `x[i]` takes 1 cycle (address out, data back);
- the add takes $D_{\min}$ cycles;
- the store of the result takes 1 cycle.

That gives $L_p = D_{\min} + 2$. If the two disagree, use the value solved from C, and work out which stage you miscounted before going on.

**How to predict each interleaved row.** The tool picks the core latency per solution, so predict it as a range:

$$I = \max\left(1, \left\lceil \frac{D_{\min}}{K} \right\rceil\right), \qquad D_{\text{ACC}} \in \left[D_{\min},\ \min\left(D_{\text{seq}},\ I \cdot K\right)\right]$$

$$L_p = D_{\text{ACC}} + 2, \qquad C_{\text{ACC}} = L_p + I \cdot 1023$$

The range exists because once $I$ is fixed, any core with $D \le I \cdot K$ fits the dependency. The tool may then prefer a slower core that meets timing. The model fixes $I$; it does not decide which core the tool picks, so record which one it chose.

Speedups are for the `ACC` loop only: $14336 / C_{\text{ACC}}$ against `base/seq` and $7170 / C_{\text{ACC}}$ against `base/pipe`.

| row                   | $I$ | $D_{\text{ACC}}$ range | $L_p$ | $C_{\text{ACC}}$ | vs `base/seq` | vs `base/pipe` |
|-----------------------|-----|------------------------|-------|------------------|---------------|----------------|
| `base/pipe`           |     |                        |       |                  |               |                |
| `shift_k1/pipe`       |     |                        |       |                  |               |                |
| `shift_k2/pipe`       |     |                        |       |                  |               |                |
| `shift_k4/pipe`       |     |                        |       |                  |               |                |
| `shift_k7/pipe`       |     |                        |       |                  |               |                |
| `shift_k10/pipe`      |     |                        |       |                  |               |                |
| `index_k10/pipe`      |     |                        |       |                  |               |                |
| `index_k10/pipe_dist` |     |                        |       |                  |               |                |

<details><summary>Expected values </summary>

with $D_{\min} = 7$, $D_{\text{seq}} = 10$

| row                   | $I$ | $D_{\text{ACC}}$ | $L_p$ | $C_{\text{ACC}}$ | vs `base/seq` | vs `base/pipe` |
|-----------------------|-----|------------------|-------|------------------|---------------|----------------|
| `base/pipe`           | 7   | 7                | 9     | 7170             | 2.00          | 1.00           |
| `shift_k1/pipe`       | 7   | 7                | 9     | 7170             | 2.00          | 1.00           |
| `shift_k2/pipe`       | 4   | 7–8              | 9–10  | 4101–4102        | 3.50          | 1.75           |
| `shift_k4/pipe`       | 2   | 7–8              | 9–10  | 2055–2056        | 6.98          | 3.49           |
| `shift_k7/pipe`       | 1   | 7                | 9     | 1032             | 13.9          | 6.95           |
| `shift_k10/pipe`      | 1   | 7–10             | 9–12  | 1032–1035        | 13.9          | 6.93–6.95      |
| `index_k10/pipe`      | 7   | 7                | 9     | 7170             | 2.00          | 1.00           |
| `index_k10/pipe_dist` | 1   | 7–10             | 9–12  | 1032–1035        | 13.9          | 6.93–6.95      |

**The saturation.** Beyond $K = D_{\min}$, a larger $K$ buys no cycles. It can only buy back timing margin, if the tool moves to a slower core. Beyond $K = D_{\text{seq}}$ it buys nothing at all, and costs 32 FF per lane plus a longer second stage.

</details>

**Function latency.** Do not predict it to the cycle. It is roughly `INIT` + `ACC` + `COMBINE` + a few control cycles.
- `INIT`: expect about $K$ cycles.
- `COMBINE`: $K$ sequential iterations. Each one probably uses the relaxed core and has no RAM read. If it schedules like `base/seq` minus the read, that is about $D_{\text{seq}} + 2$ per iteration, so around 120 cycles at $K = 10$.

Write your estimate down and compare it with the `COMBINE` loop row later. At $K = 10$ the second stage is already about a tenth of the total, which is what Q2 is about.

### Stage C — the log

For each solution, predict the number of `II Violation` lines, the reason text, and whether HLS 200-871 appears.

<details><summary>Expected pattern (confirm on your install)</summary>

S1.2 confirmed that the number of violation lines equals $I - 1$.

| solution | violation lines | reason / note |
|----------|-----------------|---------------|
| `base/pipe` | 6 | carried dependence on `acc`, `distance = 1`. This matches S1.2. |
| `shift_k1/pipe` | 6 | same as `base/pipe` |
| `shift_k2/pipe` | 3 | Write down which variable and which `distance` the tool names. It may report a single register hop (`distance = 1`) rather than the whole chain. |
| `shift_k4/pipe` | 1 | as for `k2` |
| `shift_k7/pipe`, `shift_k10/pipe` | 0 | |
| `index_k10/pipe` | 6 | carried dependence on array `lane`: 4 lines with `distance = 2, offset = 1`, then 2 lines on `reuse_reg` (the tool's read-after-write bypass register) with `distance = 1`. `Final II = 7, Depth = 11` |
| `index_k10/pipe_dist` | 0 | `Final II = 1, Depth = 10` |

**HLS 200-871.** Expected wherever $D_{\text{ACC}} = 7$: `base/pipe`, `shift_k1`, `shift_k7`, and possibly `shift_k2` and `shift_k4`. Not expected on `shift_k10` or `index_k10/pipe_dist` if the tool took the relaxed core.

**How to tell whether the dependence directive took effect** (measured on 2023.2):

| indicator | directive applied | directive dropped |
|---|---|---|
| `Running: set_directive_dependence ...` in the log | present | present too, so it proves nothing |
| variable named in the `HLS 200-880` lines | no violation lines | `local variable 'mux_case_0'` (lane was partitioned) |
| `Pipelining result` | `Final II = 1` | `Final II = 7` |
| `* Memory:` table in `acc_index_csynth.rpt` | `lane_U` / `lane_RAM_AUTO_1R1W` | `N/A` (lane is registers) |
| `Bind Op Report`, `ACC` `fadd` variable | `add` | `add` on both, so it proves nothing |

**Measured for the shift form:** `shift_k7` and `shift_k10` do reach `Final II = 1` with no violation lines. The scheduler does reason across the register chain, so the shift-form prediction for $K \ge D_{\min}$ holds.

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

`src/accumulate.cpp` and `src/tb_accumulate.cpp` are the S1.2 files, unchanged.

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

With $K = 1$, `SHIFT` has zero trips and `ACC` is exactly the S1.2 loop. That is the point of the `shift_k1` row.

`SHIFT` sits inside the pipelined `ACC` loop, so the pipeline directive unrolls it automatically. `-pipeline_loops 0` does not affect that.

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

After the loop, lane `j` of the index form holds residue class $j$. The shift form holds the same classes in a rotated order: `lane[j]` holds class $(N-1-j) \bmod K$. `COMBINE` adds them in lane order in both forms, so the two forms can produce different bits for the same input. Each testbench reference mirrors its own form.

### 4.2 The script

```tcl
# s2_pipelining/03_single_loop_interleaving/run_hls.tcl
# Run:  vitis_hls -f run_hls.tcl 2>&1 | tee run.log

# ---- knobs ------------------------------------------------------------
# Pass 1 (stage B): ONLY {base_proj}, DO_COSIM 0.
# Pass 2:           ONLY {} (every project), DO_COSIM 1.
set ONLY     {base_proj}
set DO_COSIM 0

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
}
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
        source ../../common/part.tcl

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

**Notes on the script.**
- **Cosim scope:** cosim runs on four solutions only. These are the baseline, the two $I = 1$ shift points, and the directive-assisted index form. The directive is a promise the tool does not check, so its cosim matters most.
- **`make clean`:** every project name ends in `_proj`, so it already covers them.
- **Pass 2:** re-runs `base_proj` as well. `-reset` makes that safe, and the cost is small.

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

`-distance` is only used when `-dependent true` is given [2]. It tells the tool that a read of `lane` depends on the write from $K$ iterations earlier, not from the previous iteration.

**Why the index form is not partitioned (measured on 2023.2, K=10).** An earlier version partitioned `lane` in both index solutions. Both came out identical: `Final II = 7`, 6 violation lines naming `local variable 'mux_case_0'`, 3.046 ns. The partition had replaced `lane` before the dependence directive was applied, and the tool gave no warning. Even `-dependent false` was dropped the same way. Without the partition:

| index_k10 variant | II | `ACC` C | Fn lat | est. ns | LUT | FF | cosim |
|---|---|---|---|---|---|---|---|
| partition + `-distance 10` (old `pipe_dist`) | 7 | 7170 | 7305 | 3.046 | 1269 | 1317 | Pass |
| partition + `-dependent false` | 7 | 7170 | 7305 | 3.046 | 1269 | 1317 | — |
| no partition, no directive (`pipe`) | 7 | 7170 | 7325 | 2.969 | 1233 | 1120 | — |
| no partition + `-distance 10` (`pipe_dist`) | **1** | **1032** | **1187** | 2.969 | 1086 | 1091 | Pass (1185) |

Use the indicator table in Stage C to confirm the directive took effect on your run.

### 4.4 Testbench

`tb_accumulate.cpp` is the S1.2 file. The interleaved testbench keeps the repo shape:
- a separate `ref()` model;
- POISON in the output before each call;
- directed vectors first, then seeded random vectors;
- errors counted, not stopped at the first;
- a non-zero return on any failure;
- `__RTL_SIMULATION__` to cut the random count in cosim.

The reference computes the lane sums independently, in index order, then combines them in the same lane order as the form under test. The comparison is exact: same groupings and same order means bit-exact is expected.

It also computes the plain sequential sum, for information only. The difference between the two is printed, never checked.

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

#ifdef __RTL_SIMULATION__
static const int N_RANDOM = 4;
#else
static const int N_RANDOM = 64;
#endif

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

**Why these vectors catch a wrong kernel.** On small integers every grouping gives the same float sum, so `zeros`, `ones` and `alt` cannot catch a wrong lane mapping. The `cancel` vector and the fractional random vectors can:
- a wrong distance (for example $K-1$) changes which terms share a lane;
- a wrong combine order changes the order the lanes are added in.

Either change moves the rounding.

---

## 5. Measure

**Second pass:** set `ONLY {}` and `DO_COSIM 1`, then run.

### 5.1 csynth

**Collect.**

```bash
C=../../common
PROJ=base_proj TOP=accumulate OUT=lat_base.md bash $C/collect_latency.sh
PROJ=base_proj TOP=accumulate OUT=res_base.md bash $C/collect_resources.sh
for K in 1 2 4 7 10; do
    PROJ=shift_k${K}_proj TOP=acc_shift OUT=lat_shift_k${K}.md bash $C/collect_latency.sh
    PROJ=shift_k${K}_proj TOP=acc_shift OUT=res_shift_k${K}.md bash $C/collect_resources.sh
done
PROJ=index_k10_proj TOP=acc_index OUT=lat_index_k10.md bash $C/collect_latency.sh
PROJ=index_k10_proj TOP=acc_index OUT=res_index_k10.md bash $C/collect_resources.sh
```

**First real test of the submodule path in `collect_latency.sh`.** The interleaved kernels have three loops in one function, so Vitis will probably extract the pipelined `ACC` loop into its own module, named something like `acc_shift_Pipeline_ACC`. Its loop row then lives in `acc_shift_Pipeline_ACC_csynth.rpt`, and the top report lists it only as an instance.

In S1.2 every loop stayed in the top module, so this layout is still untested against real reports. Compare one `lat_shift_k7.md` against the raw reports by eye before trusting the rest.

**Two `fadd` rows.** The `Bind Op Report` in `csynth.rpt` should now list two `fadd` rows per interleaved solution: one in `ACC` and one in `COMBINE`. Tell them apart by the `Variable` and module columns. $D_{\text{ACC}}$ is the one in `ACC`.

**Fill in timing:**

| row                   | II tgt | II ach | Iter. Lat. (col) | $C_{\text{ACC}}$ | `INIT` C | `COMBINE` C | Fn lat (max) | est. ns | 200-871? | $D_{\text{ACC}}$ | $D_{\text{COMBINE}}$ |
|-----------------------|--------|--------|------------------|------------------|----------|-------------|--------------|---------|----------|------------------|----------------------|
| `base/seq`            | —      | —      | 14               | 14336            | —        | —           | 14337        | 2.262   | no       | 10               | —                    |
| `base/pipe`           | 1      | 7      | 10               | 7170             | —        | —           | 7172         | 2.719   | yes      | 7                | —                    |
| `shift_k1/pipe`       | 1      | 7      | 10               | 7170             | n/a      | n/a         | 7184         | 2.719   | yes      | 7                | 10                   |
| `shift_k2/pipe`       | 1      | 7      | 10               | 7170             | n/a      | 26          | 7201         | 2.292   | no       | 7                | 10                   |
| `shift_k4/pipe`       | 1      | 2      | 10               | 2055             | n/a      | 52          | 2112         | 2.719   | yes      | 7                | 10                   |
| `shift_k7/pipe`       | 1      | 1      | 10               | 1032             | n/a      | 91          | 1128         | 2.719   | yes      | 7                | 10                   |
| `shift_k10/pipe`      | 1      | 1      | 10               | 1032             | n/a      | 130         | 1167         | 2.719   | yes      | 7                | 10                   |
| `index_k10/pipe`      | 1      | 7      | 10               | 7170             | 10       | 140         | 7325         | 2.969   | yes      | 7                | 10                   |
| `index_k10/pipe_dist` | 1      | 1      | 10               | 1032             | 10       | 140         | 1187         | 2.969   | yes      | 7                | 10                   |

- **`INIT` C:** n/a on the shift rows. With `lane` partitioned into registers there is no `INIT` loop row; the zero initialization was absorbed. The index rows keep `lane` as a RAM, so `INIT` is a real loop: 10 trips × 1 cycle.
- **`COMBINE` C at K=1:** n/a. With one trip there is no loop row; the `total` `fadd` (latency 10) is still in the top module.
- **`COMBINE` iteration latency:** 13 on the shift rows (register read), 14 on the index rows (one extra cycle for the RAM read).
- **`shift_k2`:** II=7 with 6 `HLS 200-881` lines (carried constraint between two `fadd` operations on `lane`), not `HLS 200-880` lines. No 200-871.
- **`index_k10` rows:** from the unpartitioned directives in 4.3, measured in a csynth-only debug run of `acc_index` at K=10. Rerunning `index_k10_proj` should reproduce them. The directive took effect on `pipe_dist`: `Final II = 1`, no violation lines, and `lane_RAM_AUTO_1R1W` in the Memory table.

**Fill in area** (Utilization Estimates, Total row):

| row                   | LUT  | FF   | DSP | BRAM | FF − `shift_k1` FF |
|-----------------------|------|------|-----|------|--------------------|
| `base/pipe`           | 541  | 460  | 0   | 0    | —                  |
| `shift_k1/pipe`       | 831  | 843  | 2   | 0    | 0                  |
| `shift_k2/pipe`       | 925  | 977  | 2   | 0    | 134                |
| `shift_k4/pipe`       | 946  | 1202 | 2   | 0    | 359                |
| `shift_k7/pipe`       | 1097 | 1594 | 2   | 0    | 751                |
| `shift_k10/pipe`      | 1241 | 1979 | 2   | 0    | 1136               |
| `index_k10/pipe`      | 1233 | 1120 | 2   | 0    | —                  |
| `index_k10/pipe_dist` | 1086 | 1091 | 2   | 0    | —                  |

- **DSP:** the `ACC` `fadd` is the fabric core (`no_dsp`, latency 7) in every pipelined solution; the 2 DSPs are the `COMBINE` `fadd` (`fulldsp`, latency 10). For reference, `base/seq` is LUT 356, FF 491, DSP 2, BRAM 0.

**Checks against Stage B.**

1. **II:** achieved II equals $\lceil D_{\min}/K \rceil$ on every shift row.
2. **Core choice:** $D_{\text{ACC}}$ lies in $[D_{\min}, \min(D_{\text{seq}}, I \cdot K)]$. Where the range allowed a choice, write down which core the tool took and whether HLS 200-871 disappeared with it.
3. **Depth:** $L_p = C_{\text{ACC}} - I \cdot 1023$ equals $D_{\text{ACC}} + 2$, and the column reads $L_p + 1$.
4. **The K=1 row:** `shift_k1` has the same $C_{\text{ACC}}$ as `base/pipe`. If it does not, the extra partition or loop structure changed the `ACC` schedule. Find the stage that moved.
5. **Lane cost:** FF − `shift_k1` FF grows by about 32 per extra lane. The lanes are the only state that scales with $K$, apart from a few counter bits.
6. **Storage cost:** `index_k10/pipe_dist` is below `shift_k10/pipe` in both FF (1091 vs 1979) and LUT (1086 vs 1241), because its lanes are a 10 × 32-bit LUTRAM (Memory table: 64 FF, 5 LUT) instead of partitioned registers. It pays in timing instead: 2.969 ns vs 2.719 ns.
7. **Sharing:** DSP is 4 on every interleaved row. A 2 means the tool shared the `fadd`.

### 5.2 Log diagnostics

```bash
grep -nE "Running: open_(project|solution)|II Violation|Pipelining result|WARNING: \[HLS 200-871\]" run.log
```

The `Running:` lines split the log into project and solution blocks. As in S1.2, match `WARNING: [HLS 200-871]` rather than `HLS 200-871`, or the Resolution lines are counted twice.

For each pipelined solution, record:
- the number of violation lines;
- the reason text;
- the named variable;
- the `distance` value;
- `Final II` and `Depth`.

For the shift form, the variable and distance the tool names are the interesting part. Do they describe the whole chain ($d = K$), or a single hop?

### 5.3 Cosim

For each cosim'd solution, read the Verilog latency row of `sim/report/*cosim.rpt`. Also confirm the testbench printed `PASSED` in the cosim section of `run.log`.

| row                   | cosim min/avg/max | Fn lat (5.1) | cosim − Fn lat | tb result |
|-----------------------|-------------------|--------------|----------------|-----------|
| `base/pipe`           | 7170/7170/7170    | 7172         | −2             | PASSED    |
| `shift_k7/pipe`       | 1126/1126/1126    | 1128         | −2             | PASSED    |
| `shift_k10/pipe`      | 1165/1165/1165    | 1167         | −2             | PASSED    |
| `index_k10/pipe_dist` | 1185/1185/1185    | 1187         | −2             | PASSED    |

- **`index_k10/pipe_dist`:** from the unpartitioned debug run (4.3), matching the current directives. The `index_k10_proj` in this directory still holds the old partitioned run (cosim 7304, Pass).
- **`N_RANDOM`:** every cosim section of the log prints `N_RANDOM=64`, not 4, so `__RTL_SIMULATION__` is not in effect for either testbench. The results are still valid; cosim just runs all 64 random vectors.

**What to expect.**
- **Variance:** zero, as in S1.1 and S1.2. The kernels are fully static.
- **Gap:** the function-level gap is recorded in absolute cycles. S1.1 found cosim 0–2 cycles *below* csynth; check the sign again now that the function has three loops.
- **`index_k10/pipe_dist` must pass.** The distance promise is true there. 5.5a shows what happens when it is not.

**Measured:** zero variance on every row, and cosim is exactly 2 cycles below the csynth function latency on all four, the same sign as S1.1. The three-loop structure did not change the gap.

Also copy the two `cancel:` and `random:` lines from the csim part of `run.log` for each $K$. Q1 uses them.

| row              | `cancel:` interleaved | `cancel:` sequential | `random:` max rel. diff |
|------------------|-----------------------|----------------------|-------------------------|
| `shift_k1`       | 0                     | 0                    | 0                       |
| `shift_k2`       | 512                   | 0                    | 0.00463                 |
| `shift_k4`       | 768                   | 0                    | 0.00363                 |
| `shift_k7`       | 874                   | 0                    | 0.00391                 |
| `shift_k10`      | 924                   | 0                    | 0.00629                 |
| `index_k10`      | 924                   | 0                    | 0.00557                 |

Exact answer on `cancel` is 1022. `shift_k1` reproduces the sequential sum bit for bit, as it should. `shift_k10` and `index_k10` give the same `cancel` result but different random deviations, because the two forms combine the lanes in a different order (4.1).

### 5.4 results.csv

This is the first sweep in the repo. `sweep_param` is `K` on the shift rows, because only $K$ changes between them. The index rows have a fixed $K$, so it goes in `notes`.

```csv
exercise,kernel,variant,dtype,N,sweep_param,sweep_value,II_target,II_achieved,latency_est,latency_cosim,LUT,FF,DSP,BRAM,fmax_est,fmax_impl,notes
s2.1.3,accumulate,seq,float,1024,,,,14,14337,,356,491,2,0,442,?,unpipelined; II_achieved=L by substitution; S1.2 re-run; fadd lat=10 (fulldsp)
s2.1.3,accumulate,pipe,float,1024,,,1,7,7172,7170,541,460,0,0,368,?,S1.2 re-run; fadd lat=7 (fabric); 200-871=y
s2.1.3,acc_shift,pipe,float,1024,K,1,1,7,7184,,831,843,2,0,368,?,fadd ACC lat=7 (fabric); COMBINE fadd lat=10 (fulldsp); 200-871=y
s2.1.3,acc_shift,pipe,float,1024,K,2,1,7,7201,,925,977,2,0,436,?,fadd ACC lat=7 (fabric); 200-871=n; II=7 from 6x HLS 200-881 (fadd-fadd on lane) not 200-880
s2.1.3,acc_shift,pipe,float,1024,K,4,1,2,2112,,946,1202,2,0,368,?,fadd ACC lat=7 (fabric); 200-871=y
s2.1.3,acc_shift,pipe,float,1024,K,7,1,1,1128,1126,1097,1594,2,0,368,?,fadd ACC lat=7 (fabric); 200-871=y
s2.1.3,acc_shift,pipe,float,1024,K,10,1,1,1167,1165,1241,1979,2,0,368,?,fadd ACC lat=7 (fabric; relaxed core not taken); 200-871=y
s2.1.3,acc_index,pipe,float,1024,,,1,7,7325,,1233,1120,2,0,337,?,K=10; no dependence directive; lane unpartitioned (LUTRAM); 200-871=y
s2.1.3,acc_index,pipe_dist,float,1024,,,1,1,1187,1185,1086,1091,2,0,337,?,K=10; dependence inter true distance=10; lane unpartitioned (LUTRAM); 200-871=y
```

- **`fmax_est`:** 1000 / estimated clock period in ns, rounded to MHz, as in S1.2.
- **`index_k10` rows:** from the unpartitioned debug run (4.3). The partitioned version measured II=7, 7305, cosim 7304, LUT 1269, FF 1317, 328 MHz, for both `pipe` and `pipe_dist`.

`latency_cosim` is blank on rows that were not cosim'd. Blank means "not measured"; `?` is kept for "the tool could not say".

### 5.5 Optional extras

**a. A false distance promise.** Add this project and directive file:

```tcl
    index_k4_proj  {top acc_index  tb tb_acc_il     K 4  sols {pipe_lie}       cosim {pipe_lie}}
```

```tcl
# directives_acc_index_pipe_lie.tcl
# No array_partition, for the same reason as pipe_dist.
set_directive_pipeline -II 1 "acc_index/ACC"
set_directive_dependence -variable lane -type inter -dependent true -distance 10 "acc_index/ACC"
```

The lanes really repeat every 4 iterations, but the directive says 10.

**Predict before running:** csim result, achieved II, number of violation lines, and cosim result.

**Expected:**
- csim PASS. The C code runs sequentially, so it cannot see the overlap.
- II=1 with no violations. The tool believes the promise.
- cosim FAIL. See Q3.

**b. Pipeline the second stage.** Add `pipe_comb` to `shift_k10_proj`'s `sols`, with this directive file:

```tcl
# directives_acc_shift_pipe_comb.tcl
set_directive_array_partition -type complete -dim 1 "acc_shift" lane
set_directive_pipeline -II 1 "acc_shift/ACC"
set_directive_pipeline -II 1 "acc_shift/COMBINE"
```

`COMBINE` is itself a running sum with $d = 1$, so it should come back at II $= D_{\min}$ with $D_{\min} - 1$ violation lines. It is the S1.2 blocker again, over $K$ trips instead of $N$.

Compare its `COMBINE` loop C, and its function latency, with `shift_k10/pipe`. Q2 discusses the result.

---

## 6. Questions

**Q1.** On the `cancel` vector, the sequential float sum is 0 and the exact answer is 1022. What does `shift_k2` return, and which of the three is "right"?

<details><summary>Answer</summary>

**`shift_k2` returns 512.** The ones are split into two lanes of 511 each.

In single precision, representable values between $2^{26}$ and $2^{27}$ are 8 apart, and $10^8$ lies in that range. Each lane goes like this:

- **The lane holding `x[0]` (even indices).** It starts at $10^8$. Each $+1$ rounds straight back to $10^8$, so all 511 ones in this lane are lost. The lane ends at $10^8$.
- **The lane holding `x[1023]` (odd indices).** It sums its 511 ones exactly first, reaching 511. Only then does it meet $-10^8$. The value $511 - 10^8 = -99999489$ rounds to the nearest multiple of 8, which is $-99999488$. Only 1 is lost.
- **Combining.** $10^8 + (-99999488) = 512$, which is exact. It does not matter which lane is added first.

**None of the three answers is right in float32.** The format cannot represent $10^8 + 1$. What interleaving changes is which small terms meet the large ones, and when. The sequential order loses all 1022 ones. This grouping loses 510. A different $K$, or large values in different positions, gives a different result. So "interleaving is more accurate" is not a rule; it is just what happens on this vector.

On the random vectors the difference is only at the rounding level; the `random:` line gives its size. That difference is the price of the transformation, and the reason the tool will not apply it on its own [1, Sec. 2.1].

**If a result must match a CPU reference exactly,** there are two options:
- write the reference with the same lane grouping, as this testbench does; or
- use a type whose addition is associative, such as int or `ap_fixed` (S4.4), where interleaving does not change the answer at all.

</details>

**Q2.** `COMBINE` adds $K$ values into one running sum, which is exactly the pattern this exercise set out to fix. Why is it left unpipelined, and what would a much larger $K$ need?

<details><summary>Answer</summary>

**At $K = 10$ it is not worth pipelining.** Unpipelined, `COMBINE` takes about $K$ times its iteration latency, on the order of 100–120 cycles. Pipelined, it hits the same dependency: $I = D_{\min}$, so $C \approx L_p + 7 \cdot 9 \approx 72$ cycles (extra 5.5b measures this).

That saves around 50 cycles out of a function latency of roughly 1150, about 4%, for extra pipeline registers. The main loop has $N = 1024$ trips; the second stage has only $K$. That asymmetry is why the paper splits the work into two stages: stage one does almost all the work at $I = 1$ [1, Sec. 2.1.3].

**For a large $K$** (say, interleaving across hundreds of lanes because the operator is very slow), the second stage stops being negligible. There are three ways to handle it:

- **Interleave again.** `COMBINE` is a single loop with a slow add, so the same transformation applies to it, with fewer lanes.
- **Use a balanced adder tree.** $K - 1$ adders arranged in $\lceil \log_2 K \rceil$ levels. Latency is about $D_{\text{add}} \lceil \log_2 K \rceil$, but it costs $K - 1$ `fadd` cores instead of 1, and it changes the rounding once more.
- **Run the two stages as separate dataflow processes** (S3.3). Stage one starts the next input while stage two collapses the previous lanes. This helps throughput across calls, not the latency of a single call. The paper mentions this option for exactly this kernel [1, Sec. 2.1.3].

</details>

**Q3.** `index_k10/pipe` stays at II=7, and a dependence directive fixes it. Why can't the tool see the distance by itself? And in extra 5.5a, why does csim pass while cosim fails?

<details><summary>Answer</summary>

**Why the tool assumes $d = 1$.** In the index form, iteration $i$ reads and writes `lane[c]`. The tool's dependency analysis looks at the array accesses, not at how `c` changes from one iteration to the next. It cannot prove that `c` never selects the same element in consecutive iterations. So it takes the safe assumption, $d = 1$, and schedules as if every iteration touched the same lane.

**What the directive does.** `-dependent true -distance K` replaces that assumption with the stated distance. The tool then only needs $I \cdot K \ge D_{\text{ACC}}$. The shift form never needs this, because its distance is visible in the code as a chain of register copies.

**Why it only works on the unpartitioned array.** The directive is attached to the variable `lane`. A complete partition replaces `lane` with a read mux and registers named `mux_case_*` before scheduling, so the directive has nothing left to attach to, and no warning is printed. The violation lines then name `mux_case_0`, not `lane`. That name is the indicator that the directive was dropped.

**Why the tool believes a false promise.** The tool does not check the promise. In 5.5a the real distance is 4 but the directive says 10. The tool schedules $I = 1$ with a 7-cycle add. The iteration four steps later reads the same lane only 4 cycles after the earlier iteration read it, but the earlier write lands about 8 cycles after that read. So the later iteration reads a stale value, and one input is dropped from that lane. The final sum is wrong.

**Why only cosim sees it.**
- **csim** compiles the C code and runs it one iteration at a time, so no two iterations overlap and the result is correct.
- **cosim** runs the scheduled RTL, where they do overlap.

A dependence directive is therefore only safe when the stated distance is *less than or equal to* the real one:
- stating 4 when the real distance is 10 is safe, but may cost II;
- stating 10 when it is 4 produces wrong hardware.

S2.3 uses the stronger form, `-dependent false`, together with a forwarding buffer that makes the promise true.

</details>

---

## References

[1] J. de Fine Licht, M. Besta, S. Meierhans, T. Hoefler, "Transformations of High-Level Synthesis Codes for High-Performance Computing," *IEEE Trans. Parallel and Distributed Systems*, 32(5), 2021. arXiv:1805.08288.
- Sec. 1.2: the pipeline model, Eq. 1.
- Sec. 2: the two classes that block pipelining.
- Sec. 2.1: accumulation interleaving, and why its four variants exist.
- Sec. 2.1.3 and Lst. 2: single-loop accumulation interleaving, with two stages, $K \ge L_{\text{acc}}$, and an unpipelined collapse loop.

[2] AMD, *Vitis High-Level Synthesis User Guide* (UG1399), version matching 2023.2. Reference pages for:
- `set_directive_pipeline`;
- `set_directive_array_partition` (`-type complete`, `-dim`);
- `set_directive_dependence` (`-variable`, `-type inter`, `-dependent`, `-distance`);
- the Bind Op section of the synthesis report.