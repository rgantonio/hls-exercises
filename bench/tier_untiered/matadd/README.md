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

Runs of 27 Oct 2026: W = 1, 4, 8 first (1aa2298), then the lane sweep W = 1 to 32 (07f5dec, lane accessors inlined in e1427cc; `notes/w_sweep.md`). Run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC on FreePDK45 at 10 ns. Every point passes csim and cosim and is portable, and both sizes run on the same hardware point. `snax-forge-experiments/results/hls/report_untiered.md` has every column; the run notes are in `snax-forge-experiments/results/hls/runs/`.

| Case | W | cycles m8_n16 | cycles m16_n32 | over the beats (m16_n32) | area µm² | of which flops | critical path ns |
|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 129 | 513 | 1 | 1,958 | 535 | 5.24 |
| `unopt` | 2 | 513 | 2049 | 1793 | 10,317 | 5,449 | 5.29 |
| `unopt` | 4 | 449 | 1793 | 1665 | 15,768 | 8,537 | 5.30 |
| `unopt` | 8 | 417 | 1665 | 1601 | 28,519 | 14,688 | 5.29 |
| `unopt` | 16 | 401 | 1601 | 1569 | 51,969 | 26,966 | 5.30 |
| `unopt` | 32 | 393 | 1569 | 1553 | 99,112 | 51,499 | 5.30 |
| `opt` | 1 | 130 | 514 | 2 | 2,845 | 1,069 | 5.25 |
| `opt` | 2 | 66 | 258 | 2 | 4,242 | 1,580 | 5.25 |
| `opt` | 4 | 34 | 130 | 2 | 7,033 | 2,601 | 5.25 |
| `opt` | 8 | 18 | 66 | 2 | 12,617 | 4,643 | 5.25 |
| `opt` | 16 | 10 | 34 | 2 | 23,774 | 8,728 | 5.25 |
| `opt` | 32 | 6 | 18 | 2 | 46,080 | 16,898 | 5.25 |
| `dace` | 1 | 130 | 514 | 2 | 3,078 | 1,300 | 5.25 |
| `dace` | 2 | 66 | 258 | 2 | 4,822 | 1,811 | 5.25 |
| `dace` | 4 | 35 | 131 | 3 | 7,964 | 3,064 | 5.25 |
| `dace` | 8 | 19 | 67 | 3 | 13,474 | 5,074 | 5.25 |
| `dace` | 16 | 11 | 35 | 3 | 24,573 | 9,127 | 5.25 |
| `dace` | 32 | 7 | 19 | 3 | 46,826 | 17,265 | 5.25 |

- `matadd` is `vecadd`. At 512 elements the cycles and the area are the same in all nine case and W pairs, the Verilog differs only in names and the latency comment, and DC gives the same cells and critical path. The 2-D shape costs the unit nothing, because the streamer holds it.
- DaCe's 2-D map with M = 1 also lands on `vecadd`'s DaCe numbers (131 cycles at W = 4, 7,964 µm²).
- Lane sweep, `opt`: N/W + 2 cycles at every W from 1 to 32, so one beat per cycle holds up to 2048-bit beats.
- Lane sweep, `unopt`: from W = 2 on each beat costs about 3W + 2 cycles (its lane loop takes 3 cycles per lane), so a run is about 3N + 2N/W: slowest at W = 2 (2049 cycles at m16_n32) and only a little faster when wider (1569 at W = 32). W = 1 is the exception (513).
- Lane sweep, area: `opt` grows from 2.8k (W = 1) to 23.8k (W = 16) and 46.1k µm² (W = 32), 1.94x for the last doubling.
