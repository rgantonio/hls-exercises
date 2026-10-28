# vecadd

$$C = A + B, \quad \text{int64}$$

snax-forge `kernels/polybench/vecadd.py`, with `recipes/vecadd.json` (N = 64, W = 4). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, B, C): one valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

Run-time pin, as forge's `loopCount`: `loop_count` (beats in the run, N / W), a 32-bit plain input read at `ap_start`. The size reaches the hardware only through the pins, so every size runs on one hardware point per case and W (`rtl/done/vecadd/<case>_w<W>/`).

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `vecadd` (`src/vecadd.cpp`) | `BEAT` over the beats, `LANE` over the W lanes of a beat, nothing pipelined: the lanes run one after the other. |
| `opt` | `vecadd` (`src/vecadd.cpp`) | `directives_opt.tcl`: `BEAT` pipelined at II = 1, `LANE` unrolled, so a whole beat goes through every cycle. |
| `dace` | `vecadd_dace` (`dace/w<W>/`) | DaCe's map at II = 1. At W = 4 and 8, DaCe's `Vectorization` makes the arrays W-lane words, so the loop takes one beat per cycle. |

Sizes n64 and n512 (the pins' values), W = 1, 2, 4, 8, 16 and 32 (hardware).

## What to expect

- `unopt`: about $N$ lane steps plus the beat's read and write per beat.
- `opt`: about $N/W$ plus the pipeline depth.
- `dace`: about $N/W$ plus the depth at every W, since DaCe vectorizes elementwise maps.
- forge, W = 4: `add_acc` counts 19 cycles for 16 beats at N = 64 (overhead 3), on SNAX-GVSoC and on snax_cluster's RTL (`snax-forge-experiments/results/hls/forge_cycles.csv`).

## Results

Runs of 27 Oct 2026: W = 1, 4, 8 first (d2062af), then the lane sweep W = 1 to 32 (07f5dec, lane accessors inlined in e1427cc; `notes/w_sweep.md`). Run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC at 10 ns on the Nangate 45 nm and 15 nm Open Cell Libraries, rerun of 28 Oct 2026: the columns marked 45 and 15 are area, critical path, energy per cycle at DC's default switching activity (`e_total_pj`) and leakage on each, from `snax-forge-experiments/results/hls/<tech>/` (run note `snax-forge-experiments/results/hls/runs/2026-10-28_tech_rerun.md`). Every point passes csim and cosim and is portable, and both sizes run on the same hardware point. `snax-forge-experiments/results/hls/report_done.md` has every column; the run notes are in `snax-forge-experiments/results/hls/runs/`.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² 45 | crit ns 45 | E pJ 45 | leak µW 45 | area µm² 15 | crit ns 15 | E pJ 15 | leak µW 15 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 65 | 513 | 1 | 861 | 4.62 | 0.924 | 17.5 | 246 | 0.58 | 0.267 | 8.40 |
| `unopt` | 2 | 257 | 2049 | 1793 | 4,828 | 4.58 | 3.16 | 92.6 | 1,400 | 0.58 | 1.40 | 51.5 |
| `unopt` | 4 | 225 | 1793 | 1665 | 7,445 | 4.58 | 4.83 | 143 | 2,146 | 0.58 | 2.18 | 78.5 |
| `unopt` | 8 | 209 | 1665 | 1601 | 12,834 | 4.55 | 8.37 | 247 | 3,694 | 0.58 | 3.74 | 134 |
| `unopt` | 16 | 201 | 1601 | 1569 | 23,544 | 4.58 | 15.6 | 454 | 6,695 | 0.58 | 6.80 | 244 |
| `unopt` | 32 | 197 | 1569 | 1553 | 44,691 | 4.58 | 30.9 | 867 | 12,835 | 0.58 | 12.9 | 461 |
| `opt` | 1 | 66 | 514 | 2 | 1,301 | 4.54 | 0.894 | 24.9 | 369 | 0.58 | 0.321 | 13.2 |
| `opt` | 2 | 34 | 258 | 2 | 1,980 | 4.54 | 1.31 | 37.1 | 558 | 0.58 | 0.489 | 19.5 |
| `opt` | 4 | 18 | 130 | 2 | 3,340 | 4.54 | 2.14 | 61.4 | 937 | 0.58 | 0.822 | 31.9 |
| `opt` | 8 | 10 | 66 | 2 | 6,057 | 4.54 | 3.74 | 110 | 1,693 | 0.58 | 1.49 | 56.8 |
| `opt` | 16 | 6 | 34 | 2 | 11,489 | 4.54 | 7.07 | 211 | 3,207 | 0.58 | 2.82 | 107 |
| `opt` | 32 | 4 | 18 | 2 | 22,358 | 4.54 | 13.6 | 410 | 6,233 | 0.58 | 5.47 | 206 |
| `dace` | 1 | 66 | 514 | 2 | 1,420 | 4.54 | 1.06 | 27.1 | 406 | 0.58 | 0.386 | 14.4 |
| `dace` | 2 | 34 | 258 | 2 | 2,273 | 4.54 | 2.26 | 43.0 | 634 | 0.58 | 0.796 | 21.6 |
| `dace` | 4 | 19 | 131 | 3 | 3,779 | 4.54 | 4.09 | 70.3 | 1,061 | 0.58 | 1.43 | 35.7 |
| `dace` | 8 | 11 | 67 | 3 | 6,459 | 4.54 | 7.31 | 118 | 1,807 | 0.58 | 2.54 | 60.1 |
| `dace` | 16 | 7 | 35 | 3 | 11,864 | 4.54 | 13.9 | 215 | 3,311 | 0.58 | 4.86 | 109 |
| `dace` | 32 | 5 | 19 | 3 | 22,700 | 4.54 | 26.8 | 410 | 6,329 | 0.58 | 9.40 | 208 |

- `opt` runs N/W + 2 cycles (18 for 16 beats at n64, W = 4). Forge's `add_acc` counts 19 for the same run, one more. DaCe at W = 4 and 8 also costs 3 over the beats, the same as forge.
- `unopt` at W = 1 is N + 1: Vitis puts the read, the add and the write in one state, so even the plain loop runs one element per cycle. At W = 4 and 8 the lanes run one after the other, 14 and 26 cycles per beat.
- `unopt` is the largest design from W = 2 on (12.8k µm² against 6.1k for `opt` at W = 8 on nangate45, 3.7k against 1.7k on nangate15). It holds the whole input and output beats in flops while it walks the lanes: 8.3k µm² of sequential area against 2.6k (nangate45). Only at W = 1 is `unopt` the smallest.
- At W = 1 to 8, DaCe costs 7 to 15 % more area than `opt` on both technologies, for the same cycles at W = 1 and one more at W = 4 and 8. At W = 16 and 32 the two are within 3.3 %.
- Lane sweep, `opt`: N/W + 2 cycles at every W from 1 to 32, so one beat per cycle holds up to 2048-bit beats.
- Lane sweep, `unopt`: from W = 2 on each beat costs about 3W + 2 cycles (its lane loop takes 3 cycles per lane), so a run is about 3N + 2N/W: slowest at W = 2 (2049 cycles at n512) and only a little faster when wider (1569 at W = 32). W = 1 is the exception (513).
- Lane sweep, area: `opt` grows from 1.3k (W = 1) to 11.5k (W = 16) and 22.4k µm² (W = 32) on nangate45, 1.95x for the last doubling; on nangate15 from 369 to 3.2k and 6.2k µm², 1.94x.
