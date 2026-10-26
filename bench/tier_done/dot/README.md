# dot

$$\mathit{out} = \sum_{i=0}^{N-1} A_i B_i, \quad \text{int64}$$

snax-forge `kernels/polybench/dot.py`, with `recipes/dot.json` (vmul then an adder tree) and `recipes/dot_serial.json` (vmul then an accumulator), both chaining two accelerators through L1. dot is parked in forge until M13, so forge rows come later. The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, B, out (one beat)): one valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `dot` (`src/dot.cpp`) | `BEAT` over the beats, `LANE` over the W lanes of a beat, nothing pipelined: the lanes run one after the other. |
| `opt` | `dot` (`src/dot.cpp`) | `directives_opt.tcl`: `BEAT` pipelined at II = 1, `LANE` unrolled, so a whole beat goes through every cycle. |
| `dace` | `dot_dace` (`dace/<size>_w<W>/`) | DaCe's default is two loops: `A * B` into a transient array `__tmp0[N]`, then the sum over it, which is forge's "vmul then vsum through L1" inside one block. The array is a RAM inside the block (BRAM in the estimate). As for `vsum`, W = 1 only. |

Sizes n64 and n512, W = 1, 4 and 8.

## What to expect

- `opt`: about $N/W$ plus a deeper pipeline (W multipliers, an adder tree, one accumulator). This is the fused form, with no buffer between multiply and sum.
- `dace`: about $2N$ plus two depths, because its two loops run one after the other.

## Results

First axis run: 26 Oct 2026, commit bb9ca4c. All 14 points pass, DSP 0, portable; all miss 3.33 ns on the FPGA (the 64-bit fabric multiplier, as in `vecmul`).

| Case | n64 W1 / W4 / W8 | n512 W1 / W4 / W8 | Overhead |
|---|---|---|---|
| `unopt` | 194 / 226 / 210 | 1538 / 1794 / 1666 | — |
| `opt` | 69 / 21 / 14 | 517 / 133 / 70 | 5 (6 at W = 8) |
| `dace` | 136 | 1032 | about $N + 8$ |

- `opt` is the fused form: W multipliers, an adder tree and one accumulator at II = 1, one beat per cycle plus 5. At W = 8 the tree is one stage deeper.
- DaCe's `dot` takes 2 cycles per element. Its two loops run one after the other, and `A*B` sits between them in a RAM inside the block (`BRAM_18K` = 2, `dot_dace_p_tmp0_RAM_AUTO_1R1W.v` in `rtl/`). That breaks the plan's rule that memory stays outside the block. It is DaCe's default, which is forge's "vmul then vsum through L1" with the L1 moved inside.
