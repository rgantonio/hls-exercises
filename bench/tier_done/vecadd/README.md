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

Runs of 27 Oct 2026: W = 1, 4, 8 first (d2062af), then the lane sweep W = 1 to 32 (07f5dec, lane accessors inlined in e1427cc; `notes/w_sweep.md`). Run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC at 10 ns on gscl45nm (FreePDK45), since retired: the area and critical-path columns are from that run. Synthesis now runs on the Nangate 45 nm and 15 nm Open Cell Libraries, with results in `snax-forge-experiments/results/hls/<tech>/`. Every point passes csim and cosim and is portable, and both sizes run on the same hardware point. `snax-forge-experiments/results/hls/report_done.md` has every column; the run notes are in `snax-forge-experiments/results/hls/runs/`.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² | of which flops | critical path ns |
|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 65 | 513 | 1 | 1,958 | 535 | 5.24 |
| `unopt` | 2 | 257 | 2049 | 1793 | 10,317 | 5,449 | 5.29 |
| `unopt` | 4 | 225 | 1793 | 1665 | 15,768 | 8,537 | 5.30 |
| `unopt` | 8 | 209 | 1665 | 1601 | 28,519 | 14,688 | 5.29 |
| `unopt` | 16 | 201 | 1601 | 1569 | 51,969 | 26,966 | 5.30 |
| `unopt` | 32 | 197 | 1569 | 1553 | 99,112 | 51,499 | 5.30 |
| `opt` | 1 | 66 | 514 | 2 | 2,845 | 1,069 | 5.25 |
| `opt` | 2 | 34 | 258 | 2 | 4,242 | 1,580 | 5.25 |
| `opt` | 4 | 18 | 130 | 2 | 7,033 | 2,601 | 5.25 |
| `opt` | 8 | 10 | 66 | 2 | 12,617 | 4,643 | 5.25 |
| `opt` | 16 | 6 | 34 | 2 | 23,774 | 8,728 | 5.25 |
| `opt` | 32 | 4 | 18 | 2 | 46,080 | 16,898 | 5.25 |
| `dace` | 1 | 66 | 514 | 2 | 3,078 | 1,300 | 5.25 |
| `dace` | 2 | 34 | 258 | 2 | 4,822 | 1,811 | 5.25 |
| `dace` | 4 | 19 | 131 | 3 | 7,964 | 3,064 | 5.25 |
| `dace` | 8 | 11 | 67 | 3 | 13,474 | 5,074 | 5.25 |
| `dace` | 16 | 7 | 35 | 3 | 24,573 | 9,127 | 5.25 |
| `dace` | 32 | 5 | 19 | 3 | 46,826 | 17,265 | 5.25 |

- `opt` runs N/W + 2 cycles (18 for 16 beats at n64, W = 4). Forge's `add_acc` counts 19 for the same run, one more. DaCe at W = 4 and 8 also costs 3 over the beats, the same as forge.
- `unopt` at W = 1 is N + 1: Vitis puts the read, the add and the write in one state, so even the plain loop runs one element per cycle. At W = 4 and 8 the lanes run one after the other, 14 and 26 cycles per beat.
- `unopt` is the largest design at W = 4 and 8 (28.5k µm² against 12.6k for `opt` at W = 8). It holds the whole input and output beats in flops while it walks the lanes: 14.7k µm² of sequential area against 4.6k. Only at W = 1 is `unopt` the smallest.
- At W = 1 to 8, DaCe costs 7 to 13 % more area than `opt`, for the same cycles at W = 1 and one more at W = 4 and 8. At W = 16 and 32 the two are within 4 %.
- Lane sweep, `opt`: N/W + 2 cycles at every W from 1 to 32, so one beat per cycle holds up to 2048-bit beats.
- Lane sweep, `unopt`: from W = 2 on each beat costs about 3W + 2 cycles (its lane loop takes 3 cycles per lane), so a run is about 3N + 2N/W: slowest at W = 2 (2049 cycles at n512) and only a little faster when wider (1569 at W = 32). W = 1 is the exception (513).
- Lane sweep, area: `opt` grows from 2.8k (W = 1) to 23.8k (W = 16) and 46.1k µm² (W = 32), 1.94x for the last doubling.
