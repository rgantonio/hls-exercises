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

Sizes n64 and n512 (the pins' values), W = 1, 4 and 8 (hardware).

## What to expect

- `unopt`: about $N$ lane steps plus the beat's read and write per beat.
- `opt`: about $N/W$ plus the pipeline depth.
- `dace`: about $N/W$ plus the depth at every W, since DaCe vectorizes elementwise maps.
- forge, W = 4: `add_acc` counts 19 cycles for 16 beats at N = 64 (overhead 3), on SNAX-GVSoC and on snax_cluster's RTL (`results/forge_cycles.csv`).

## Results

Rerun on 27 Oct 2026 (commit d2062af): run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC on FreePDK45 at 10 ns. Every point passes csim and cosim and is portable. Both sizes run on the same hardware point (`rtl_same`: `yes`, or `renamed` for `unopt` W = 8, the same circuit with shifted net names). `results/report_done.md` has every column.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² | of which flops | critical path ns |
|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 65 | 513 | 1 | 1,958 | 535 | 5.24 |
| `unopt` | 4 | 225 | 1793 | 1665 | 15,768 | 8,537 | 5.30 |
| `unopt` | 8 | 209 | 1665 | 1601 | 28,519 | 14,688 | 5.29 |
| `opt` | 1 | 66 | 514 | 2 | 2,845 | 1,069 | 5.25 |
| `opt` | 4 | 18 | 130 | 2 | 7,033 | 2,601 | 5.25 |
| `opt` | 8 | 10 | 66 | 2 | 12,617 | 4,643 | 5.25 |
| `dace` | 1 | 66 | 514 | 2 | 3,078 | 1,300 | 5.25 |
| `dace` | 4 | 19 | 131 | 3 | 7,964 | 3,064 | 5.25 |
| `dace` | 8 | 11 | 67 | 3 | 13,474 | 5,074 | 5.25 |

- `opt` runs N/W + 2 cycles (18 for 16 beats at n64, W = 4). Forge's `add_acc` counts 19 for the same run, one more. DaCe at W = 4 and 8 also costs 3 over the beats, the same as forge.
- `unopt` at W = 1 is N + 1: Vitis puts the read, the add and the write in one state, so even the plain loop runs one element per cycle. At W = 4 and 8 the lanes run one after the other, 14 and 26 cycles per beat.
- `unopt` is the largest design at W = 4 and 8 (28.5k µm² against 12.6k for `opt` at W = 8). It holds the whole input and output beats in flops while it walks the lanes: 14.7k µm² of sequential area against 4.6k. Only at W = 1 is `unopt` the smallest.
- DaCe costs 7 to 13 % more area than `opt`, for the same cycles at W = 1 and one more at W = 4 and 8.
