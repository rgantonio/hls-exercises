# vecmul

$$C = A \odot B, \quad A, B, C \in \mathbb{Z}^{N}, \text{ int64}$$

snax-forge `kernels/polybench/vecmul.py` and `recipes/vecmul.json` (N = 64, W = 4). This is `vecadd` with a multiplier, so it is the first check that a 64-bit multiplier stays in fabric (DSP 0) and what its latency costs.

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `vecmul` (`src/vecmul.cpp`) | One loop `MUL`, nothing pipelined. One port per array. |
| `opt` | `vecmul` (`src/vecmul.cpp`) | `directives_opt.tcl`: A, B and C split cyclic by W, `MUL` unrolled by W and pipelined at II = 1. |
| `dace` | `vecmul_dace` (`dace/<size>/`) | DaCe's map at II = 1, one port per array. |

Sizes n64 and n512, W = 4 and 8 for `opt`.

## What to expect

- `unopt`: vecadd's 3 cycles per element plus the multiplier's latency, since nothing overlaps.
- `opt`: still about $N/W$ plus the pipeline depth. The multiplier's latency only makes the pipeline deeper.
- `dace`: about $N$ plus the depth.
- Every point should have DSP 0 (`config_op mul -impl fabric`).

## Results

`results/report_done.md`. Findings from the runs go here.
