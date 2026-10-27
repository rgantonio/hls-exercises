# dot

$$\mathit{out} = \sum_{i=0}^{N-1} A_i B_i, \quad \text{int64}$$

snax-forge `kernels/polybench/dot.py`, with `recipes/dot.json` (vmul then an adder tree) and `recipes/dot_serial.json` (vmul then an accumulator), both chaining two accelerators through L1. dot is parked in forge until M13, so forge rows come later. The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, B, out (one beat)): one valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

Run-time pins, as forge's `Accumulator`: `loop_count` (beats in the run, N / W) and `len` (beats per result, T), 32-bit plain inputs read at `ap_start`. A result leaves every `len` beats and at the last beat, and the sum restarts. The testbench sets `len = loop_count`, so one sum. DaCe's top takes `len` too but has no restart, so it ignores it. The size reaches the hardware only through the pins, so every size runs on one hardware point per case and W (`rtl/done/dot/<case>_w<W>/`).

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `dot` (`src/dot.cpp`) | `BEAT` over the beats, `LANE` over the W lanes of a beat, nothing pipelined: the lanes run one after the other. |
| `opt` | `dot` (`src/dot.cpp`) | `directives_opt.tcl`: `BEAT` pipelined at II = 1, `LANE` unrolled, so a whole beat goes through every cycle. |
| `dace` | `dot_dace` (`dace/w<W>/`) | DaCe's default is two loops: `A * B` into a transient array `__tmp0[N]`, then the sum over it, which is forge's "vmul then vsum through L1" inside one block. The array is a RAM inside the block (BRAM in the estimate), sized for n512, the largest size: its depth is a design-time bound, so this hardware takes runs up to N = 512. As for `vsum`, W = 1 only. |

Sizes n64 and n512 (the pins' values), W = 1, 4 and 8 (hardware).

## What to expect

- `opt`: about $N/W$ plus a deeper pipeline (W multipliers, an adder tree, one accumulator). This is the fused form, with no buffer between multiply and sum.
- `dace`: about $2N$ plus two depths, because its two loops run one after the other.

## Results

Rerun on 27 Oct 2026 with the run-time pins; the numbers are in `results/report_done.md`. The earlier runs, with the size fixed at compile time (`ap_memory`, then axis with and without register slices), are in git history up to commit b2ddd1a.
