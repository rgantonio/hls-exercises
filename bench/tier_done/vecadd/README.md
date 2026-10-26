# vecadd

$$C = A + B, \quad \text{int64}$$

snax-forge `kernels/polybench/vecadd.py`, with `recipes/vecadd.json` (N = 64, W = 4). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, B, C): one valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `vecadd` (`src/vecadd.cpp`) | `BEAT` over the beats, `LANE` over the W lanes of a beat, nothing pipelined: the lanes run one after the other. |
| `opt` | `vecadd` (`src/vecadd.cpp`) | `directives_opt.tcl`: `BEAT` pipelined at II = 1, `LANE` unrolled, so a whole beat goes through every cycle. |
| `dace` | `vecadd_dace` (`dace/<size>_w<W>/`) | DaCe's map at II = 1. At W = 4 and 8, DaCe's `Vectorization` makes the arrays W-lane words, so the loop takes one beat per cycle. |

Sizes n64 and n512, W = 1, 4 and 8.

## What to expect

- `unopt`: about $N$ lane steps plus the beat's read and write per beat.
- `opt`: about $N/W$ plus the pipeline depth.
- `dace`: about $N/W$ plus the depth at every W, since DaCe vectorizes elementwise maps.
- forge, W = 4: `add_acc` counts 19 cycles for 16 beats at N = 64 (overhead 3), on SNAX-GVSoC and on snax_cluster's RTL (`results/forge_cycles.csv`).

## Results

First axis run: 26 Oct 2026, commit bb9ca4c. All 18 points pass csim and cosim with timing met, DSP 0 and portable Verilog; the tables are in `results/report_done.md`.

| Case | n64 W1 / W4 / W8 | n512 W1 / W4 / W8 | Overhead (cycles − beats) |
|---|---|---|---|
| `unopt` | 129 / 241 / 217 | 1025 / 1921 / 1729 | — (2 cycles per element at W = 1, about 3.5–4 above) |
| `opt` | 66 / 18 / 10 | 514 / 130 / 66 | 2 |
| `dace` | 66 / 19 / 11 | 514 / 131 / 67 | 2 at W = 1, 3 vectorized |
| forge `add_acc` | — / 19 / — | — | 3 (W = 4) |

- The ports are as planned: `A_TDATA`, `B_TDATA`, `C_TDATA` of 256 bits at W = 4 with `TVALID`/`TREADY`, and an active-low synchronous reset `ap_rst_n` (Vitis fixes that once AXI ports exist).
- `opt` runs one beat per cycle plus 2. Forge's unit runs one beat per cycle plus 3, so at n64 W = 4 it is 18 cycles against 19.
- DaCe's vectorized loop reaches one beat per cycle too, one cycle behind `opt`, because its module is a function call from the generated top.
- `unopt` at W = 4 and 8 is slower than at W = 1: each beat runs its W lanes one after the other, with loop overhead on top (15 cycles per beat at W = 4). So "vs unopt" at W > 1 uses a slower baseline than at W = 1.
