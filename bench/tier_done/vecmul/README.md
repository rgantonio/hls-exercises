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

`results/report_done.md`. Findings from the axis runs go here. The earlier `ap_memory` run is in git history (commits 4b7b617 and 99e6c80).
