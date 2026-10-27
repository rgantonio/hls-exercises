# vecmul

$$C = A \odot B, \quad \text{int64}$$

snax-forge `kernels/polybench/vecmul.py`, with `recipes/vecmul.json` (N = 64, W = 4). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, B, C): one valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

Run-time pin, as forge's `loopCount`: `loop_count` (beats in the run, N / W), a 32-bit plain input read at `ap_start`. The size reaches the hardware only through the pins, so every size runs on one hardware point per case and W (`rtl/done/vecmul/<case>_w<W>/`).

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `vecmul` (`src/vecmul.cpp`) | `BEAT` over the beats, `LANE` over the W lanes of a beat, nothing pipelined: the lanes run one after the other. |
| `opt` | `vecmul` (`src/vecmul.cpp`) | `directives_opt.tcl`: `BEAT` pipelined at II = 1, `LANE` unrolled, so a whole beat goes through every cycle. |
| `dace` | `vecmul_dace` (`dace/w<W>/`) | As `vecadd`: II = 1, vectorized at W = 4 and 8. |

Sizes n64 and n512 (the pins' values), W = 1, 4 and 8 (hardware).

## What to expect

- As `vecadd`, with the multiplier's latency in every lane step (`unopt`) or in the pipeline depth (`opt`, `dace`).
- DSP 0 on every point (`config_op mul -impl fabric`). The 64-bit fabric multiplier missed 3.33 ns on the FPGA in the `ap_memory` run, so look at `timing`.

## Results

Rerun on 27 Oct 2026 with the run-time pins; the numbers are in `results/report_done.md`. The earlier runs, with the size fixed at compile time (`ap_memory`, then axis with and without register slices), are in git history up to commit b2ddd1a.
