# vecmul

$$C = A \odot B, \quad \text{int64}$$

snax-forge `kernels/polybench/vecmul.py`, with `recipes/vecmul.json` (N = 64, W = 4). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, B, C): one valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

Run-time pin, as forge's `loopCount`: `loop_count` (beats in the run, N / W), a 32-bit plain input read at `ap_start`. The size reaches the hardware only through the pins, so every size runs on one hardware point per case and W (`rtl/done/vecmul/<case>_w<W>/`).

## Cases

| Case | Top | What runs |
|---|---|---|
| `opt` | `vecmul` (`src/vecmul.cpp`) | `directives_opt.tcl`: `BEAT` pipelined at II = 1, `LANE` unrolled, so a whole beat goes through every cycle. |
| `dace` | `vecmul_dace` (`dace/w<W>/`) | As `vecadd`: II = 1, vectorized at W = 4 and 8. |

Sizes n64 and n512 (the pins' values), W = 1, 2, 4, 8 and 16 (hardware).

## What to expect

- As `vecadd`, with the multiplier's latency in the pipeline depth.
- DSP 0 on every point (`config_op mul -impl fabric`). The 64-bit fabric multiplier missed 3.33 ns on the FPGA in the `ap_memory` run, so look at `timing`.

## Results

Rebuilt in HSYN1 (snax-forge-experiments, 5 Nov 2026): `opt` and `dace` at a 10 ns HLS clock, W = 1 to 16. The cycles below are filled by HSYN1 R2 from `snax-forge-experiments/results/hls/hls_cycles.csv`; area, timing and energy per point are in `snax-forge-experiments/results/compare_<tier>.csv`. The earlier results (3.33 ns, `unopt`, W up to 32) are in git history up to cbc2541.

Cycles are cosim's (RTL simulation) from `ap_start` to `ap_done`; beats = elements / W at n512. Loop II and iteration latency are csynth's, per loop in the order named below the table.

| case | W | cycles n64 | cycles n512 | cycles / beats (n512) | loop II | iteration latency |
|---|---|---|---|---|---|---|
| opt | 1 | 66 | 514 | 1.00 | 1 | 2 |
| opt | 2 | 34 | 258 | 1.01 | 1 | 2 |
| opt | 4 | 18 | 130 | 1.02 | 1 | 2 |
| opt | 8 | 10 | 66 | 1.03 | 1 | 2 |
| opt | 16 | 6 | 34 | 1.06 | 1 | 2 |
| dace | 1 | 66 | 514 | 1.00 | 1 | 2 |
| dace | 2 | 34 | 258 | 1.01 | 1 | 2 |
| dace | 4 | 19 | 131 | 1.02 | 1 | 2 |
| dace | 8 | 11 | 67 | 1.05 | 1 | 2 |
| dace | 16 | 7 | 35 | 1.09 | 1 | 2 |

Loops: `opt` `BEAT`; `dace` `VITIS_LOOP_19_1`.

- Cycles, loop II and iteration latency are the same as at 3.33 ns for both cases at every W.
