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

Sizes n64 and n512 (the pins' values), W = 1, 2, 4, 8, 16 and 32 (hardware).

## What to expect

- As `vecadd`, with the multiplier's latency in every lane step (`unopt`) or in the pipeline depth (`opt`, `dace`).
- DSP 0 on every point (`config_op mul -impl fabric`). The 64-bit fabric multiplier missed 3.33 ns on the FPGA in the `ap_memory` run, so look at `timing`.

## Results

Rerun on 27 Oct 2026 (commit d2062af): run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC on FreePDK45 at 10 ns. Every point passes csim and cosim and is portable. Both sizes run on the same hardware point (`rtl_same`: `yes`, or `renamed` for `unopt` W = 8, the same circuit with shifted net names). `results/report_done.md` has every column.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² | of which flops | critical path ns |
|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 129 | 1025 | 513 | 18,918 | 543 | 5.96 |
| `unopt` | 4 | 225 | 1793 | 1665 | 32,715 | 8,537 | 6.23 |
| `unopt` | 8 | 209 | 1665 | 1601 | 45,469 | 14,688 | 6.25 |
| `opt` | 1 | 66 | 514 | 2 | 20,615 | 1,580 | 6.25 |
| `opt` | 4 | 18 | 130 | 2 | 78,107 | 4,643 | 6.22 |
| `opt` | 8 | 10 | 66 | 2 | 154,778 | 8,728 | 6.26 |
| `dace` | 1 | 66 | 514 | 2 | 20,845 | 1,811 | 6.25 |
| `dace` | 4 | 19 | 131 | 3 | 79,036 | 5,106 | 6.22 |
| `dace` | 8 | 11 | 67 | 3 | 155,614 | 9,159 | 6.32 |

- `opt` and DaCe take the same cycles as `vecadd`. `unopt` at W = 1 is 2N + 1: the multiplier needs its own state.
- A 64-bit fabric multiplier is about 19k µm², so the multipliers are the design: `opt` grows from 20.6k (W = 1) to 154.8k µm² (W = 8), about W × 19k.
- `unopt` shares one multiplier across the lanes, so from W = 4 on it is the small design (45.5k against 154.8k µm² at W = 8), at 26 cycles per beat instead of 1.
