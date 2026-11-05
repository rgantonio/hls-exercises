# rowsum

$$y_i = \sum_j A_{ij}, \quad \text{int64}$$

snax-forge `kernels/elementwise/rowsum.py`, with `recipes/rowsum_serial.json` (M = 4, N = 16, W = 1, accumulator) and `recipes/rowsum.json` (M = 8, N = 64, W = 4, adder tree). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, y). One valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly. `y` carries one element per beat, M beats.

Run-time pins, as forge's `Accumulator`: `loop_count` (M × N / W beats) and `len` (N / W beats per sum), 32 bits with `ap_vld`, pulsed with the start. This is `vsum`'s top with `len` < `loop_count`: the sum restarts every row. DaCe's top sets DaCe's M and N from the pins (M = `loop_count` / `len`, N = `len` × W).

## Cases

| Case | Top | What runs |
|---|---|---|
| `opt` | `rowsum` (`src/rowsum.cpp`) | `directives_opt.tcl`: `BEAT` at II = 1, `LANE` unrolled into an adder tree. |
| `dace` | `rowsum_dace` (`dace/w1/`) | DaCe's reduction first zeroes `y` (M cycles), then adds every element into `y[i]` in place (`xilinx_wcr_fixed`), so `y` is read and written N times per row. An axis port cannot do that, so the generated top keeps `y` in a local buffer (sized for m8_n64) and streams it out after DaCe's loops: M more cycles and a RAM, which parks its synthesis. W = 1 only, as for the other reductions. |

Sizes m4_n16 and m8_n64 (the two recipes), W = 1, 2, 4, 8 and 16 (`dace` W = 1).

## What to expect

- `opt`: about M × N / W plus a few, one result every N / W beats with no stall at the restart.
- `dace`: about M (zeroing) + M × N + M (streaming `y` out), so roughly 2M more than `opt` W = 1.

## Results

Rebuilt in HSYN1 (snax-forge-experiments, 5 Nov 2026): `opt` and `dace` at a 10 ns HLS clock, W = 1 to 16. The cycles below are filled by HSYN1 R2 from `snax-forge-experiments/results/hls/hls_cycles.csv`; area, timing and energy per point are in `snax-forge-experiments/results/compare_<tier>.csv`. The earlier results (3.33 ns, `unopt`, W up to 32) are in git history up to cbc2541.
