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

Rerun on 27 Oct 2026 with the run-time pins; the numbers are in `results/report_done.md`. The earlier runs, with the size fixed at compile time (`ap_memory`, then axis with and without register slices), are in git history up to commit b2ddd1a.
