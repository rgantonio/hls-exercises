# vecadd

$$C = A + B, \quad A, B, C \in \mathbb{Z}^{N}, \text{ int64}$$

snax-forge `kernels/polybench/vecadd.py` and `recipes/vecadd.json` (N = 64, W = 4). This is the first kernel through the bench, so it checks the flow as much as the numbers. The plan is in `docs/HLS_VS_FORGE.md`.

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `vecadd` (`src/vecadd.cpp`) | One loop `ADD`, nothing pipelined (`common/asic.tcl`). One port per array. |
| `opt` | `vecadd` (`src/vecadd.cpp`) | `directives_opt.tcl`: A, B and C split cyclic by W into W ports each, `ADD` unrolled by W and pipelined at II = 1. |
| `dace` | `vecadd_dace` (`dace/<size>/vecadd_dace.cpp`) | DaCe's device file (`dace/<size>/vecadd_0_0.cpp`) from forge's SDFG after `FPGATransformSDFG`. DaCe puts `PIPELINE II=1` on the map itself. One port per array. |

Sizes n64 (the recipe's) and n512; W = 4 and 8 for `opt`. The testbench makes one call on forge's vectors and checks every output.

## What to expect

These are a guide for reading the first run, not results:

- `unopt`: a few cycles per element, from the read, add and write of one iteration in sequence.
- `opt`: about N / W cycles plus the pipeline depth, since each cycle reads W elements of A and B from W ports.
- `dace`: about N cycles plus the depth: II = 1, but one element per cycle.
- forge: `add_acc` counts 19 cycles for 16 beats at N = 64, W = 4, on SNAX-GVSoC and on snax_cluster's RTL (`results/forge_cycles.csv`). That makes `opt` n64 W = 4 the like-for-like row.

## Results

`results/report_done.md`. Findings from the runs go here.
