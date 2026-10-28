# matadd

$$C = A + B, \quad A, B, C \in \mathbb{Z}^{M \times N}, \quad \text{int64}$$

snax-forge `kernels/elementwise/matadd.py`, with `recipes/matadd.json` (M = 8, N = 16, W = 4). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, B, C). One valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

The rows are contiguous, so the block sees one flat run of M × N / W beats, as forge's recipe programs it: the row loop and the split column loop live in the streamer, and the unit gets one `loopCount`. Run-time pin, as forge's `loopCount`: `loop_count` (beats in the run), 32 bits with `ap_vld`, pulsed with the start (`docs/HLS_VS_FORGE.md` section 2). The size reaches the hardware only through it, so every size runs on one hardware point per case and W. DaCe's top keeps DaCe's two symbols and sets them from the pin as M = 1 and N = `loop_count` × W, the same flat run.

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `matadd` (`src/matadd.cpp`) | `vecadd`'s body. |
| `opt` | `matadd` (`src/matadd.cpp`) | `directives_opt.tcl`: `BEAT` at II = 1, `LANE` unrolled. |
| `dace` | `matadd_dace` (`dace/w<W>/`) | DaCe's 2-D map, vectorized along the columns at W = 4 and 8; its row loop runs once. |

Sizes m8_n16 (the recipe) and m16_n32 (512 elements), W = 1, 2, 4, 8, 16 and 32.

## What to expect

- The hand-written tops are `vecadd`'s hardware with another name, so the cycles and area should match `vecadd` at the same element count. That checks that the 2-D shape costs the unit nothing.
- `dace` may differ from `vecadd`'s: DaCe's map is 2-D, with a row loop around the column loop.

## Results

Runs of 27 Oct 2026: W = 1, 4, 8 first (1aa2298), then the lane sweep W = 1 to 32 (07f5dec, lane accessors inlined in e1427cc; `notes/w_sweep.md`). Run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC at 10 ns on the Nangate 45 nm and 15 nm Open Cell Libraries, rerun of 28 Oct 2026: the columns marked 45 and 15 are area, critical path, energy per cycle at DC's default switching activity (`e_total_pj`) and leakage on each, from `snax-forge-experiments/results/hls/<tech>/` (run note `snax-forge-experiments/results/hls/runs/2026-10-28_tech_rerun.md`). Every point passes csim and cosim and is portable, and both sizes run on the same hardware point. `snax-forge-experiments/results/hls/report_untiered.md` has every column; the run notes are in `snax-forge-experiments/results/hls/runs/`.

| Case | W | cycles m8_n16 | cycles m16_n32 | over the beats (m16_n32) | area µm² 45 | crit ns 45 | E pJ 45 | leak µW 45 | area µm² 15 | crit ns 15 | E pJ 15 | leak µW 15 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 129 | 513 | 1 | 861 | 4.62 | 0.924 | 17.5 | 246 | 0.58 | 0.267 | 8.40 |
| `unopt` | 2 | 513 | 2049 | 1793 | 4,828 | 4.58 | 3.16 | 92.6 | 1,400 | 0.58 | 1.40 | 51.5 |
| `unopt` | 4 | 449 | 1793 | 1665 | 7,445 | 4.58 | 4.83 | 143 | 2,146 | 0.58 | 2.18 | 78.5 |
| `unopt` | 8 | 417 | 1665 | 1601 | 12,834 | 4.55 | 8.37 | 247 | 3,694 | 0.58 | 3.74 | 134 |
| `unopt` | 16 | 401 | 1601 | 1569 | 23,544 | 4.58 | 15.6 | 454 | 6,695 | 0.58 | 6.80 | 244 |
| `unopt` | 32 | 393 | 1569 | 1553 | 44,691 | 4.58 | 30.9 | 867 | 12,835 | 0.58 | 12.9 | 461 |
| `opt` | 1 | 130 | 514 | 2 | 1,301 | 4.54 | 0.894 | 24.9 | 369 | 0.58 | 0.321 | 13.2 |
| `opt` | 2 | 66 | 258 | 2 | 1,980 | 4.54 | 1.31 | 37.1 | 558 | 0.58 | 0.489 | 19.5 |
| `opt` | 4 | 34 | 130 | 2 | 3,340 | 4.54 | 2.14 | 61.4 | 937 | 0.58 | 0.822 | 31.9 |
| `opt` | 8 | 18 | 66 | 2 | 6,057 | 4.54 | 3.74 | 110 | 1,693 | 0.58 | 1.49 | 56.8 |
| `opt` | 16 | 10 | 34 | 2 | 11,489 | 4.54 | 7.07 | 211 | 3,207 | 0.58 | 2.82 | 107 |
| `opt` | 32 | 6 | 18 | 2 | 22,358 | 4.54 | 13.6 | 410 | 6,233 | 0.58 | 5.47 | 206 |
| `dace` | 1 | 130 | 514 | 2 | 1,420 | 4.54 | 1.06 | 27.1 | 406 | 0.58 | 0.386 | 14.4 |
| `dace` | 2 | 66 | 258 | 2 | 2,273 | 4.54 | 2.26 | 43.0 | 634 | 0.58 | 0.796 | 21.6 |
| `dace` | 4 | 35 | 131 | 3 | 3,779 | 4.54 | 4.09 | 70.3 | 1,061 | 0.58 | 1.43 | 35.7 |
| `dace` | 8 | 19 | 67 | 3 | 6,459 | 4.54 | 7.31 | 118 | 1,807 | 0.58 | 2.54 | 60.1 |
| `dace` | 16 | 11 | 35 | 3 | 11,864 | 4.54 | 13.9 | 215 | 3,311 | 0.58 | 4.86 | 109 |
| `dace` | 32 | 7 | 19 | 3 | 22,700 | 4.54 | 26.8 | 410 | 6,329 | 0.58 | 9.40 | 208 |

- `matadd` is `vecadd`. At 512 elements the cycles and the area are the same in all nine case and W pairs, the Verilog differs only in names and the latency comment, and DC gives the same cells and critical path on both technologies. The 2-D shape costs the unit nothing, because the streamer holds it.
- DaCe's 2-D map with M = 1 also lands on `vecadd`'s DaCe numbers (131 cycles at W = 4, 3,779 µm² on nangate45 and 1,061 on nangate15).
- Lane sweep, `opt`: N/W + 2 cycles at every W from 1 to 32, so one beat per cycle holds up to 2048-bit beats.
- Lane sweep, `unopt`: from W = 2 on each beat costs about 3W + 2 cycles (its lane loop takes 3 cycles per lane), so a run is about 3N + 2N/W: slowest at W = 2 (2049 cycles at m16_n32) and only a little faster when wider (1569 at W = 32). W = 1 is the exception (513).
- Lane sweep, area: `opt` grows from 1.3k (W = 1) to 11.5k (W = 16) and 22.4k µm² (W = 32) on nangate45, 1.95x for the last doubling; on nangate15 from 369 to 3.2k and 6.2k µm², 1.94x.
