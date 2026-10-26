# vecmul

$$C = A \odot B, \quad \text{int64}$$

snax-forge `kernels/polybench/vecmul.py`, with `recipes/vecmul.json` (N = 64, W = 4). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, B, C): one valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `vecmul` (`src/vecmul.cpp`) | `BEAT` over the beats, `LANE` over the W lanes of a beat, nothing pipelined: the lanes run one after the other. |
| `opt` | `vecmul` (`src/vecmul.cpp`) | `directives_opt.tcl`: `BEAT` pipelined at II = 1, `LANE` unrolled, so a whole beat goes through every cycle. |
| `dace` | `vecmul_dace` (`dace/<size>_w<W>/`) | As `vecadd`: II = 1, vectorized at W = 4 and 8. |

Sizes n64 and n512, W = 1, 4 and 8.

## What to expect

- As `vecadd`, with the multiplier's latency in every lane step (`unopt`) or in the pipeline depth (`opt`, `dace`).
- DSP 0 on every point (`config_op mul -impl fabric`). The 64-bit fabric multiplier missed 3.33 ns on the FPGA in the `ap_memory` run, so look at `timing`.

## Results

**Update, commit 4fea150: register slices off.** The tables below are from the axis run with Vitis's register slices (bb9ca4c). Since 4fea150 the ports have none: `opt` and `dace` are 2 cycles shorter (1 for some reductions), and `unopt` saves up to one cycle per beat. `results/report_done.md` has the current numbers.

First axis run: 26 Oct 2026, commit bb9ca4c. All 18 points pass, DSP 0, portable. Cycles are the same as `vecadd`'s except `unopt` at W = 1 (3 per element against 2), because the multiplier takes the extra cycle when nothing overlaps.

- **Every point misses 3.33 ns on the FPGA.** Vitis estimates the 64-bit fabric multiplier (`mul_64s_64s_64_1_1`, one stage) at 3.648 ns against a budget of 2.431 ns. The cycle counts belong to a schedule with a one-cycle 64-bit multiply, which an ASIC at 300 MHz closes easily but this FPGA does not.
- `opt` and `dace` still run one beat per cycle plus 2 and 3, the same as `vecadd`. In these pipelines the multiplier only adds depth if it gets more stages.
