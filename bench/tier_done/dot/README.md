# dot

$$\mathit{out} = \sum_{i=0}^{N-1} A_i B_i, \quad A, B \in \mathbb{Z}^{N}, \text{ int64}$$

snax-forge `kernels/polybench/dot.py`, with recipes `recipes/dot.json` (vmul then an adder tree) and `recipes/dot_serial.json` (vmul then an accumulator). Both bind two accelerators that chain through L1. dot is parked in forge until M13, where its variants are the block-library case study, so forge rows may come later than the HLS ones.

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `dot` (`src/dot.cpp`) | One loop `DOT`: multiply and accumulate into `acc`, nothing pipelined. |
| `opt` | `dot` (`src/dot.cpp`) | `directives_opt.tcl`: A and B split cyclic by W, `DOT` unrolled by W and pipelined at II = 1. These are W multipliers feeding an adder tree and one accumulator, all in one loop: the fused form, with no buffer between multiply and sum. |
| `dace` | `dot_dace` (`dace/<size>/`) | DaCe's default is two loops: `A * B` into a transient array `__tmp0[N]`, then a reduction over it. That is forge's "vmul then vsum through L1" in one HLS block. The generated top keeps `__tmp0` as a local array, so it is a RAM inside the block (BRAM in the estimate). |

Sizes n64 and n512, W = 4 and 8 for `opt`.

## What to expect

- `unopt`: the multiplier's latency plus the add, per element, in sequence.
- `opt`: about $N/W$ plus a deeper pipeline (multiplier and adder tree). II should be 1, with one add on the loop-carried path.
- `dace`: about $2N$ plus two pipeline depths, because the two loops run one after the other. `BRAM_18K` should be above 0 for `__tmp0`.

## Results

`results/report_done.md`. Findings from the runs go here.
