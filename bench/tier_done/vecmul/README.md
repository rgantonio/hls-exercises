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

Runs of 27 Oct 2026: W = 1, 4, 8 first (d2062af), then the lane sweep W = 1 to 32 (07f5dec, lane accessors inlined in e1427cc; `notes/w_sweep.md`). Run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC at 10 ns on gscl45nm (FreePDK45), since retired: the area and critical-path columns are from that run. Synthesis now runs on the Nangate 45 nm and 15 nm Open Cell Libraries, with results in `snax-forge-experiments/results/hls/<tech>/`. Every point passes csim and cosim and is portable, and both sizes run on the same hardware point. `snax-forge-experiments/results/hls/report_done.md` has every column; the run notes are in `snax-forge-experiments/results/hls/runs/`.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² | of which flops | critical path ns |
|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 129 | 1025 | 513 | 18,918 | 543 | 5.96 |
| `unopt` | 2 | 257 | 2049 | 1793 | 27,267 | 5,449 | 6.23 |
| `unopt` | 4 | 225 | 1793 | 1665 | 32,715 | 8,537 | 6.23 |
| `unopt` | 8 | 209 | 1665 | 1601 | 45,469 | 14,688 | 6.25 |
| `unopt` | 16 | 201 | 1601 | 1569 | 68,916 | 26,966 | 6.06 |
| `unopt` | 32 | 197 | 1569 | 1553 | 116,075 | 51,499 | 6.25 |
| `opt` | 1 | 66 | 514 | 2 | 20,615 | 1,580 | 6.25 |
| `opt` | 2 | 34 | 258 | 2 | 39,784 | 2,601 | 6.25 |
| `opt` | 4 | 18 | 130 | 2 | 78,107 | 4,643 | 6.22 |
| `opt` | 8 | 10 | 66 | 2 | 154,778 | 8,728 | 6.26 |
| `opt` | 16 | 6 | 34 | 2 | 308,195 | 16,898 | 6.25 |
| `opt` | 32 | 4 | 18 | 2 | 614,725 | 33,237 | 6.25 |
| `dace` | 1 | 66 | 514 | 2 | 20,845 | 1,811 | 6.25 |
| `dace` | 2 | 34 | 258 | 2 | 40,361 | 2,832 | 6.25 |
| `dace` | 4 | 19 | 131 | 3 | 79,036 | 5,106 | 6.22 |
| `dace` | 8 | 11 | 67 | 3 | 155,614 | 9,159 | 6.32 |
| `dace` | 16 | 7 | 35 | 3 | 308,865 | 17,297 | 6.25 |
| `dace` | 32 | 5 | 19 | 3 | 615,379 | 33,604 | 6.25 |

- `opt` and DaCe take the same cycles as `vecadd`. `unopt` at W = 1 is 2N + 1: the multiplier needs its own state.
- A 64-bit fabric multiplier is about 19k µm², so the multipliers are the design: `opt` grows from 20.6k (W = 1) to 154.8k µm² (W = 8), about W × 19k.
- `unopt` shares one multiplier across the lanes, so from W = 4 on it is the small design (45.5k against 154.8k µm² at W = 8), at 26 cycles per beat instead of 1.
- Lane sweep, `opt`: N/W + 2 cycles at every W from 1 to 32, so one beat per cycle holds up to 2048-bit beats.
- Lane sweep, `unopt`: from W = 2 on each beat costs about 3W + 2 cycles (its lane loop takes 3 cycles per lane), so a run is about 3N + 2N/W: slowest at W = 2 (2049 cycles at n512) and only a little faster when wider (1569 at W = 32). W = 1 is the exception (1025).
- Lane sweep, area: `opt` grows from 20.6k (W = 1) to 308.2k (W = 16) and 614.7k µm² (W = 32), 1.99x for the last doubling.
