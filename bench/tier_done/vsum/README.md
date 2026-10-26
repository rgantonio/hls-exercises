# vsum

$$\mathit{out} = \sum_{i=0}^{N-1} A_i, \quad \text{int64}$$

snax-forge `kernels/polybench/vsum.py`, with `recipes/vsum.json` (W = 1, `chisel_accumulator`) and `recipes/vsum_tree.json` (W = 4, `chisel_adder_tree`). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, out (one beat)): one valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `vsum` (`src/vsum.cpp`) | `BEAT` over the beats, `LANE` over the W lanes of a beat, nothing pipelined: the lanes run one after the other. |
| `opt` | `vsum` (`src/vsum.cpp`) | `directives_opt.tcl`: `BEAT` pipelined at II = 1, `LANE` unrolled, so a whole beat goes through every cycle. |
| `dace` | `vsum_dace` (`dace/<size>_w<W>/`) | DaCe expands `np.sum` into a loop at II = 1 that writes through a write-conflict resolution into a scalar. DaCe 1.0.2 cannot vectorize the reduction, so this case runs at W = 1 only. |

Sizes n64 and n512, W = 1, 4 and 8.

## What to expect

- `opt` W = 1: about $N$ plus the depth, one add per cycle on the loop-carried path (forge's accumulator).
- `opt` W = 4 and 8: about $N/W$ plus the depth. Vitis has to put the W lanes in a tree so only one add is on the loop-carried path (forge's adder tree). Check that `BEAT`'s II is 1.
- forge, `vsum.json` at n512: `sum_acc` counts 515 cycles on SNAX-GVSoC (overhead 3).

## Results

**Update, commit 4fea150: register slices off.** The tables below are from the axis run with Vitis's register slices (bb9ca4c). Since 4fea150 the ports have none: `opt` and `dace` are 2 cycles shorter (1 for some reductions), and `unopt` saves up to one cycle per beat. `results/report_done.md` has the current numbers.

First axis run: 26 Oct 2026, commit bb9ca4c. All 14 points pass with timing met, DSP 0, portable. Every loop reaches its II.

| Case | n64 W1 / W4 / W8 | n512 W1 / W4 / W8 | Overhead |
|---|---|---|---|
| `unopt` | 66 / 162 / 146 | 514 / 1282 / 1154 | 2 at W = 1 |
| `opt` | 68 / 20 / 12 | 516 / 132 / 68 | 4 |
| `dace` | 68 | 516 | 4 |
| forge `sum_acc` (W = 1) | — | 515 | 3 |

- At W = 1 even `unopt` runs one element per cycle: Vitis schedules the read and the add in one state, so a loop that is not pipelined already does what pipelining would. `opt` pays 2 cycles more for the pipeline's fill.
- At W = 4 and 8, `opt` adds the W lanes in a tree and keeps `BEAT` at II = 1 (iteration latency 2), with no code change. That is forge's adder tree.
- `opt` costs 4 cycles beyond the beats, one more than forge's accumulator (516 against 515 at n512 W = 1). The extra cycles are the result's write on the `out` stream.
- DaCe's reduction gives exactly `opt` W = 1. It cannot go wider.
