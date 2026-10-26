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

`results/report_done.md`. Findings from the axis runs go here. The earlier `ap_memory` run is in git history (commits 4b7b617 and 99e6c80).
