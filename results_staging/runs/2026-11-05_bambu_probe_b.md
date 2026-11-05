# BAM3 probe B: the `bambu` case on Bambu 2026.11, 2026-11-05

Probe B of BAM3 (docs/BAMBU_PLAN.md section 8): the unchanged `bambu` case (config b0: axis pragmas plus `#pragma HLS unroll` on LANE) built with Bambu 2026.11 (`tools/bin/bambu-2026.11`, commit cda4db2e, from step B0) for vecadd, dot, relu and rowsum at W = 1, 8, 32. 2026.11 pipelines innermost single-block loops by itself. `bench/bambu_probe.py --probe b` built 12 points (largest size, podman container `localhost/hls-exercises-bambu:4`), and our testbenches simulated each at both sizes, no-stall and random-stall runs, in Questa 2022.4 on the host: 23 rows (rowsum W = 32 has no m4_n16 point), 46 simulations.

Outputs: `results_staging/probe_bam3b.csv` and `probe_bam3b.md` only. `rtl/` and `results_staging/bambu_cycles.csv` are unchanged (`git diff --quiet HEAD -- rtl results_staging/bambu_cycles.csv`). Code at 7452465.

## Commands

```bash
git pull                       # main at 7452465
rm -rf build
lmutil lmstat -a -c 1717@licserv     # msimhdlsim: 75 issued, 6 in use -> --sim-jobs 32
pixi run python bench/bambu_probe.py run --probe b --dry-run     # "# 12 builds, 46 simulations"
pixi run python bench/bambu_probe.py run --probe b -j32 --sim questa --sim-jobs 32
```

The run took 24 s wall in total. vlog never stopped on panda_libtech.v: no module is defined both there and in the kernel's Verilog (step 7).

## Results

12 of 12 builds ok. 15 of 23 rows ok: every simulation of dot and rowsum at all W, and of vecadd and relu at W = 1, PASS, the stall runs included. vecadd and relu at W = 8 and W = 32 fail (8 rows, 16 simulations): the design runs at 1 cycle per beat, but fixed 32-bit words of the output beat are wrong (see "Wrong output words" below). Every simulation ended with `Errors: 0, Warnings: 2`; the two warnings are the new `idle_port` output of the 2026.11 top, which our testbenches leave unconnected (`vopt-2685` Too few port connections, `vopt-2718` Missing connection for port 'idle_port'). The 2024.10 pair of warnings was for `out1`.

Every build pipelined its BEAT loop: II=1 everywhere except dot W = 8 (II=2). There is no "Loop pipelining not possible" line in any log; the reductions (dot, rowsum) pipeline as well, because the `if` that writes the result becomes a predicated stream write inside the same basic block.

Tables from `probe_bam3b.md` (largest size; `stall` is the random-stall run at each size, smaller size first; `2024.10` is the `bambu` case's cycles from `bambu_cycles.csv`):

### dot, W = 1 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 513 | 1.00 | 1536 | PASS/PASS | 8 | 452 | BB2 II=1 lat=2 | 13.6 |

### dot, W = 8 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 128 | 2.00 | 256 | PASS/PASS | 11 | 1347 | BB2 II=2 lat=3 | 16.4 |

### dot, W = 32 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 18 | 1.12 | 64 | PASS/PASS | 15 | 4805 | BB2 II=1 lat=3 | 15.9 |

### relu, W = 1 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 513 | 1.00 | 1023 | PASS/PASS | 8 | 225 | BB2 II=1 lat=2 | 15.2 |

### relu, W = 8 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | failed: sim | - | - | 191 | FAIL/FAIL | 8 | 1121 | BB2 II=1 lat=2 | 13.8 |

### relu, W = 32 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | failed: sim | - | - | 47 | FAIL/FAIL | 8 | 4193 | BB2 II=1 lat=2 | 15.1 |

### rowsum, W = 1 (m8_n64)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 513 | 1.00 | 1287 | PASS/PASS | 8 | 356 | BB2 II=1 lat=2 | 15.2 |

### rowsum, W = 8 (m8_n64)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 65 | 1.02 | 199 | PASS/PASS | 8 | 804 | BB2 II=1 lat=2 | 15.0 |

### rowsum, W = 32 (m8_n64)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 18 | 1.12 | 71 | PASS | 15 | 2469 | BB2 II=1 lat=3 | 14.2 |

### vecadd, W = 1 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 513 | 1.00 | 767 | PASS/PASS | 8 | 322 | BB2 II=1 lat=2 | 13.7 |

### vecadd, W = 8 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | failed: sim | - | - | 191 | FAIL/FAIL | 8 | 1666 | BB2 II=1 lat=2 | 14.9 |

### vecadd, W = 32 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | failed: sim | - | - | 47 | FAIL/FAIL | 8 | 6274 | BB2 II=1 lat=2 | 15.0 |

## Wrong output words (vecadd, relu at W = 8 and 32)

The testbench prints only the first three mismatches, so the four n512 no-stall points were rerun by hand in `build/diag_words/` with a scratch copy of `tb/` whose print limit was raised (same vlog/vsim command as the probe; `tb/` itself unchanged). Every mismatch is a whole 32-bit word of a lane, at the same lanes in every beat:

| point | wrong words (lane, half) | how often |
|---|---|---|
| vecadd W = 8 | lane 0 high word = 0; lane 1 low word = 0 | 30 + 64 = 94 of 512 lanes |
| relu W = 8 | lane 1 low word = 0 | 32 of 512 |
| vecadd W = 32 | lane 0 high = 0; lanes 1, 27, 28, 29, 30 low = 0; lane 26 low wrong (values below 0x200) | 104 of 512 |
| relu W = 32 | lanes 1, 27, 28, 29, 30, 31 low = 0; lane 26 low wrong (values below 0x200) | 57 of 512 |

The counts are exactly the number of times the expected data has a nonzero value in those words (for example vecadd W = 8 n64: lane 1's low word is nonzero in all 8 beats and lane 0's high word in 3, and the testbench reports 11 lanes). The stall runs fail with exactly twice the no-stall count (two tasks): 22 = 2 x 11, 188 = 2 x 94, 64 = 2 x 32, 208 = 2 x 104, 114 = 2 x 57, 14 = 2 x 7. So the error is in the datapath and independent of stalls and timing. Only the kernels that write a wide (W x 64-bit) output beat fail; dot and rowsum read wide beats and write one 64-bit value, and pass. At W = 1 (64-bit ports, no ac_int) everything passes. 2024.10 builds the same source correctly (bambu_cycles.csv PASS). 2026.11 has no option to switch loop pipelining off (`--pipelining` pipelines whole functions), so this probe cannot tell whether the loop pipeliner or another 2026.11 change drops the words. vecadd W = 8's datapath has seven 64-bit adders for eight lanes, two 32-bit adders, 26 right shifts and 19 left shifts (ac_int keeps its value as 32-bit words), so part of the output beat is assembled from 32-bit pieces; that is consistent with a word-slicing error, but not proven.

## Step 5: loop pipelining lines per build

Every log has one Scheduling Information block with these lines and nothing else of the kind (no "Loop pipelining not possible"):

| kernel | W | minII / maxII | II line | iteration latency | Initiation Interval line |
|---|---|---|---|---|---|
| vecadd | 1 | 1 / 2 | `II=1 solution found for loop (BB2)` | 2 | `BB2 = 1` |
| vecadd | 8 | 1 / 2 | `II=1 solution found for loop (BB2)` | 2 | `BB2 = 1` |
| vecadd | 32 | 1 / 2 | `II=1 solution found for loop (BB2)` | 2 | `BB2 = 1` |
| dot | 1 | 1 / 2 | `II=1 solution found for loop (BB2)` | 2 | `BB2 = 1` |
| dot | 8 | 1 / 3 | `II=2 solution found for loop (BB2)` | 3 | `BB2 = 2` |
| dot | 32 | 1 / 3 | `II=1 solution found for loop (BB2)` | 3 | `BB2 = 1` |
| relu | 1 | 1 / 2 | `II=1 solution found for loop (BB2)` | 2 | `BB2 = 1` |
| relu | 8 | 1 / 2 | `II=1 solution found for loop (BB2)` | 2 | `BB2 = 1` |
| relu | 32 | 1 / 2 | `II=1 solution found for loop (BB2)` | 2 | `BB2 = 1` |
| rowsum | 1 | 1 / 2 | `II=1 solution found for loop (BB2)` | 2 | `BB2 = 1` |
| rowsum | 8 | 1 / 2 | `II=1 solution found for loop (BB2)` | 2 | `BB2 = 1` |
| rowsum | 32 | 1 / 3 | `II=1 solution found for loop (BB2)` | 3 | `BB2 = 1` |

(The full lines read `Iteration latency for function <mangled top>:BB2 = <n>` and `Initiation Interval (II) for function <mangled top>:BB2 = <n>`.)

BB2 is the BEAT loop in every build: LANE is fully unrolled, so BEAT is the only loop left, and the result write under `if` in dot and rowsum is if-converted into the same block (the rowsum W = 8 datapath starts its `y` write with `selector & predicate` and counts a skipped write as done).

dot W = 8 gets II=2 while dot W = 32 gets II=1. Bambu prints no reason. It is not a resource limit: both have one multiplier per lane (8 and 32 `ui_mul_node_FU`). The W = 8 schedule has a minimum slack of 0.07 ns at the 10 ns clock.

## Step 6: the W = 8 controllers

All four have the same pattern: a prologue state that starts the first beat's reads, a steady state that starts the reads of beat i together with the write of beat i-1 and loops on itself (II=1), a wait state, and an epilogue that writes the last result. Stream operations are "unbounded" operations: each AXI-Stream read or write module raises its done when the handshake completes, and a multi-unbounded tracker (`mu_S_<n>`) collects the done of every operation started in a state. The FSM leaves the state only when all of them are done; until then it sits in the wait state and starts nothing new, latching each read's data when that read completes.

- vecadd (8 states): S_6 idle; S_0 starts A and B reads (mu_S_0 waits for 2 ops); S_4 starts A rd, B rd and C wr (mu_S_4 waits for 3) and goes back to S_4; S_1 and S_5 are the wait states for S_0 and S_4; S_2/S_3 write the last beat and wait for it; S_7 done. A, B and C overlap in S_4.
- relu (8 states): the same with one input: S_0 starts A rd, S_4 starts A rd and B wr (mu_S_4 waits for 2).
- rowsum (8 states): the same as relu with A rd and y wr in S_4; the y write is predicated, so it runs only at the end of a row and is skipped (done at once) on the other beats.
- dot (11 states, II=2): reads and the write do not share a state. S_0 and S_5 start A rd and B rd (mu waits for 2), S_2 and S_7 start the predicated `out` write, and the loop alternates S_5 -> S_7 -> S_5, 2 cycles per beat; S_1, S_3, S_6, S_8 are the wait states. At W = 32 (15 states) dot does have the steady state S_11 that starts A rd, B rd and out wr together (mu_S_11 waits for 3), hence II=1 there.

Stalls: a stall on any stream (TVALID low on an input or TREADY low on the output) stops the whole pipeline. There is no drain: the beat being written and the beats being read wait together in the wait state until every operation of the state has completed, then the FSM resumes the steady state. The stall runs pass for every kernel that passes without stalls, and for the failing ones they give exactly twice the no-stall mismatch count, so the stop-and-resume itself is correct.

## Step 7: against 2024.10

Largest size; 2024.10 cycles and FSM states from `bambu_cycles.csv`, 2024.10 register bits summed the same way (register instances) from `rtl/<tier>/<kernel>/bambu_w<W>/`:

| kernel | W | beats | 2024.10 cycles | 2024.10 cyc/beat | 2026.11 cycles | 2026.11 cyc/beat | 2024.10 states | 2026.11 states | 2024.10 reg bits | 2026.11 reg bits | 2026.11 status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| dot | 1 | 512 | 1536 | 3.00 | 513 | 1.00 | 9 | 8 | 514 | 452 | ok |
| dot | 8 | 64 | 256 | 4.00 | 128 | 2.00 | 10 | 11 | 1538 | 1347 | ok |
| dot | 32 | 16 | 64 | 4.00 | 18 | 1.12 | 10 | 15 | 4930 | 4805 | ok |
| relu | 1 | 512 | 1023 | 2.00 | 513 | 1.00 | 15 | 8 | 540 | 225 | ok |
| relu | 8 | 64 | 191 | 2.98 | - | - | 8 | 8 | 1120 | 1121 | failed: sim |
| relu | 32 | 16 | 47 | 2.94 | - | - | 8 | 8 | 4192 | 4193 | failed: sim |
| rowsum | 1 | 512 | 1287 | 2.51 | 513 | 1.00 | 21 | 8 | 1056 | 356 | ok |
| rowsum | 8 | 64 | 199 | 3.11 | 65 | 1.02 | 9 | 8 | 866 | 804 | ok |
| rowsum | 32 | 16 | 71 | 4.44 | 18 | 1.12 | 10 | 15 | 2786 | 2469 | ok |
| vecadd | 1 | 512 | 767 | 1.50 | 513 | 1.00 | 21 | 8 | 1091 | 322 | ok |
| vecadd | 8 | 64 | 191 | 2.98 | - | - | 8 | 8 | 1665 | 1666 | failed: sim |
| vecadd | 32 | 16 | 47 | 2.94 | - | - | 8 | 8 | 6273 | 6274 | failed: sim |

(For the failed rows the 2026.11 design does run at 1 cycle per beat: 65 cycles for 64 beats at W = 8, 17 for 16 beats at W = 32, `cycles=` in the FAIL lines.)

- Cycles per beat: from 1.5 to 4.4 on 2024.10 down to 1.00 to 1.12 on 2026.11 (dot W = 8: 2.00). The extra 0.12 at W = 32 is the 2-cycle fill and drain over 16 beats.
- FSM states: fewer at W = 1 (8 instead of 9 to 21), the same 8 for vecadd and relu at W = 8 and 32, more for dot and rowsum at W = 32 (15 instead of 10, the extra prologue and epilogue states of a 3-cycle iteration).
- Register bits: lower everywhere it passes, by 12 to 70 % at W = 1 (vecadd 1091 to 322) and by 2.5 to 12 % for dot and rowsum at W = 8 and 32. Pipelining did not cost registers here. vecadd and relu at W = 8 and 32 differ by one bit from 2024.10.
- panda_libtech.v: every module it defines (10 to 17 per build: register_SE, register_AR, MUX2_GATE, SIMPLEJOIN_FU, multi_read_cond_FU, UUdata_converter_FU and the ui_* operator units) is instantiated by the kernel's Verilog. It is not unused library code: 2026.11 moved the library modules that 2024.10 wrote into `<kernel>.v` into this file. No module is defined in both files.

## Bambu wall times

12 builds, 13.6 to 16.4 s each (2024.10 in probe A: 9.0 to 12.2 s for a0 on vecadd and dot), run 32 at a time; the whole probe, builds and 46 simulations, took 24 s.

| kernel | W = 1 | W = 8 | W = 32 |
|---|---|---|---|
| dot | 13.6 | 16.4 | 15.9 |
| relu | 15.2 | 13.8 | 15.1 |
| rowsum | 15.2 | 15.0 | 14.2 |
| vecadd | 13.7 | 14.9 | 15.0 |

## Unexpected

- vecadd and relu at W = 8 and 32 produce wrong output words (above): a 2026.11 correctness problem on wide (ac_int) output beats, deterministic, independent of stalls, absent in 2024.10. Not yet isolated to the loop pipeliner.
- dot W = 8 pipelines at II=2 while dot W = 32 reaches II=1; Bambu gives no reason.
- The 2026.11 top has a new output `idle_port`, unconnected in our testbenches (two vopt warnings per simulation), and the top module is a `p_<mangled name>` wrapper (2024.10's top was the mangled name itself).
- Neither reduction needed a change: the result write under `if` did not stop pipelining.
