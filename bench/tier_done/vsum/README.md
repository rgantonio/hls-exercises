# vsum

$$\mathit{out} = \sum_{i=0}^{N-1} A_i, \quad A \in \mathbb{Z}^{N}, \text{ int64}$$

snax-forge `kernels/polybench/vsum.py`, with two recipes: `recipes/vsum.json` (W = 1, `chisel_accumulator`) and `recipes/vsum_tree.json` (W = 4, `chisel_adder_tree`). This is the first reduction: the sum carries from one iteration to the next.

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `vsum` (`src/vsum.cpp`) | One loop `SUM` into a local `acc`, nothing pipelined. |
| `opt` | `vsum` (`src/vsum.cpp`) | `directives_opt.tcl`: W = 1 only pipelines `SUM` at II = 1 (forge's accumulator). W = 4 and 8 also split A cyclic by W and unroll `SUM` by W, so W elements are added per cycle into `acc` (forge's adder tree). |
| `dace` | `vsum_dace` (`dace/<size>/`) | DaCe expands `np.sum` into a reduction loop at II = 1, writing the sum through a write-conflict resolution (`xilinx_wcr_fixed`) into a scalar transient. |

Sizes n64 and n512, W = 1, 4 and 8 for `opt`.

## What to expect

- `unopt`: a few cycles per element, from the read and the add in sequence.
- `opt` W = 1: about $N$ plus the depth, if the 64-bit add closes the loop in one cycle.
- `opt` W = 4 and 8: about $N/W$ plus the depth. Vitis has to rebalance the W adds into a tree, so only one add sits on the loop-carried path. Check that the loop's II is 1.
- `dace`: II = 1 if the write-conflict resolution doesn't add a memory dependence.
- forge, `vsum.json` at n512: `sum_acc` counts 515 cycles on SNAX-GVSoC (`results/forge_cycles.csv`).

## Results

`results/report_done.md`. Findings from the runs go here.
