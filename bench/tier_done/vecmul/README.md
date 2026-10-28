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

Runs of 27 Oct 2026: W = 1, 4, 8 first (d2062af), then the lane sweep W = 1 to 32 (07f5dec, lane accessors inlined in e1427cc; `notes/w_sweep.md`). Run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC at 10 ns on the Nangate 45 nm and 15 nm Open Cell Libraries, rerun of 28 Oct 2026: the columns marked 45 and 15 are area, critical path, energy per cycle at DC's default switching activity (`e_total_pj`) and leakage on each, from `snax-forge-experiments/results/hls/<tech>/` (run note `snax-forge-experiments/results/hls/runs/2026-10-28_tech_rerun.md`). Every point passes csim and cosim and is portable, and both sizes run on the same hardware point. `snax-forge-experiments/results/hls/report_done.md` has every column; the run notes are in `snax-forge-experiments/results/hls/runs/`.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² 45 | crit ns 45 | E pJ 45 | leak µW 45 | area µm² 15 | crit ns 15 | E pJ 15 | leak µW 15 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 129 | 1025 | 513 | 7,526 | 5.49 | 9.83 | 156 | 2,387 | 0.73 | 2.74 | 80.0 |
| `unopt` | 2 | 257 | 2049 | 1793 | 11,474 | 5.52 | 3.55 | 231 | 3,529 | 0.74 | 1.51 | 122 |
| `unopt` | 4 | 225 | 1793 | 1665 | 14,103 | 5.52 | 5.33 | 280 | 4,275 | 0.74 | 2.28 | 149 |
| `unopt` | 8 | 209 | 1665 | 1601 | 19,425 | 5.52 | 8.74 | 384 | 5,823 | 0.74 | 3.91 | 205 |
| `unopt` | 16 | 201 | 1601 | 1569 | 30,201 | 5.52 | 16.2 | 593 | 8,824 | 0.74 | 6.94 | 315 |
| `unopt` | 32 | 197 | 1569 | 1553 | 51,349 | 5.52 | 31.4 | 1,005 | 14,964 | 0.74 | 13.1 | 532 |
| `opt` | 1 | 66 | 514 | 2 | 8,368 | 5.58 | 1.33 | 170 | 2,611 | 0.74 | 0.505 | 88.5 |
| `opt` | 2 | 34 | 258 | 2 | 16,115 | 5.58 | 2.11 | 327 | 5,043 | 0.74 | 0.876 | 170 |
| `opt` | 4 | 18 | 130 | 2 | 31,609 | 5.58 | 3.86 | 641 | 9,905 | 0.74 | 1.55 | 333 |
| `opt` | 8 | 10 | 66 | 2 | 62,598 | 5.58 | 6.94 | 1,267 | 19,632 | 0.74 | 3.06 | 659 |
| `opt` | 16 | 6 | 34 | 2 | 124,575 | 5.58 | 13.5 | 2,530 | 39,083 | 0.74 | 5.82 | 1,311 |
| `opt` | 32 | 4 | 18 | 2 | 248,533 | 5.58 | 28.4 | 5,048 | 77,987 | 0.74 | 11.4 | 2,614 |
| `dace` | 1 | 66 | 514 | 2 | 8,487 | 5.58 | 1.48 | 172 | 2,649 | 0.74 | 0.579 | 89.7 |
| `dace` | 2 | 34 | 258 | 2 | 16,407 | 5.58 | 12.7 | 334 | 5,119 | 0.74 | 3.86 | 172 |
| `dace` | 4 | 19 | 131 | 3 | 32,048 | 5.58 | 25.4 | 652 | 10,029 | 0.74 | 7.72 | 336 |
| `dace` | 8 | 11 | 67 | 3 | 63,004 | 5.58 | 49.7 | 1,282 | 19,746 | 0.74 | 14.9 | 661 |
| `dace` | 16 | 7 | 35 | 3 | 124,948 | 5.58 | 100 | 2,542 | 39,189 | 0.74 | 30.3 | 1,312 |
| `dace` | 32 | 5 | 19 | 3 | 248,870 | 5.58 | 196 | 5,065 | 78,083 | 0.74 | 59.8 | 2,613 |

- `opt` and DaCe take the same cycles as `vecadd`. `unopt` at W = 1 is 2N + 1: the multiplier needs its own state.
- A 64-bit multiplier is 6.9k µm² on nangate45 and 2.2k on nangate15 (`synth_dc_modules.csv`), so the multipliers are the design: `opt` grows from 8.4k (W = 1) to 62.6k µm² (W = 8) on nangate45, about W × 7.8k.
- `unopt` shares one multiplier across the lanes, so it is the smaller design at every W (19.4k against 62.6k µm² at W = 8 on nangate45, 5.8k against 19.6k on nangate15), at 26 cycles per beat instead of 1.
- Lane sweep, `opt`: N/W + 2 cycles at every W from 1 to 32, so one beat per cycle holds up to 2048-bit beats.
- Lane sweep, `unopt`: from W = 2 on each beat costs about 3W + 2 cycles (its lane loop takes 3 cycles per lane), so a run is about 3N + 2N/W: slowest at W = 2 (2049 cycles at n512) and only a little faster when wider (1569 at W = 32). W = 1 is the exception (1025).
- Lane sweep, area: `opt` grows from 8.4k (W = 1) to 124.6k (W = 16) and 248.5k µm² (W = 32) on nangate45, 2.00x for the last doubling; on nangate15 from 2.6k to 39.1k and 78.0k µm², 2.00x.
