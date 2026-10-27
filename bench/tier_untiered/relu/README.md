# relu

$$B_i = \max(A_i, 0), \quad \text{int64}$$

snax-forge `kernels/elementwise/relu.py`. Forge has no recipe for it yet, so the sizes follow `vecadd` (n64, n512). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, B). One valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

Run-time pin, as forge's `loopCount`: `loop_count` (beats in the run), 32 bits with `ap_vld`, pulsed with the start (`docs/HLS_VS_FORGE.md` section 2). The size reaches the hardware only through it, so every size runs on one hardware point per case and W.

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `relu` (`src/relu.cpp`) | `BEAT` over the beats, `LANE` over the lanes, a compare and a select per lane, nothing pipelined. |
| `opt` | `relu` (`src/relu.cpp`) | `directives_opt.tcl`: `BEAT` at II = 1, `LANE` unrolled. |
| `dace` | `relu_dace` (`dace/w1/`) | DaCe's map at II = 1. W = 1 only: DaCe 1.0.2 vectorizes the map, but writes `max(dace::vec, 0)`, which does not compile (no `max` for a vector and a scalar). |

Sizes n64 and n512, W = 1, 2, 4, 8, 16 and 32 (`dace` W = 1).

## What to expect

- As `vecadd`, with a compare and a mux in place of the adder: `opt` about N/W + 2.
- The cheapest datapath of the tier, so the control and the ports are most of the area.

## Results

Runs of 27 Oct 2026: W = 1, 4, 8 first (1aa2298), then the lane sweep W = 1 to 32 (07f5dec, lane accessors inlined in e1427cc; `notes/w_sweep.md`). Run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC on FreePDK45 at 10 ns. Every point passes csim and cosim and is portable, and both sizes run on the same hardware point. `results/report_untiered.md` has every column; the run notes are in `results/runs/`.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² | of which flops | critical path ns |
|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 129 | 1025 | 513 | 1,565 | 543 | 0.89 |
| `unopt` | 2 | 257 | 2049 | 1793 | 6,366 | 3,399 | 2.01 |
| `unopt` | 4 | 225 | 1793 | 1665 | 9,932 | 5,449 | 2.01 |
| `unopt` | 8 | 209 | 1665 | 1601 | 17,951 | 9,526 | 2.01 |
| `unopt` | 16 | 201 | 1601 | 1569 | 32,920 | 17,656 | 2.01 |
| `unopt` | 32 | 197 | 1569 | 1553 | 63,233 | 33,891 | 2.01 |
| `opt` | 1 | 66 | 514 | 2 | 2,515 | 1,069 | 1.26 |
| `opt` | 2 | 34 | 258 | 2 | 3,583 | 1,580 | 1.19 |
| `opt` | 4 | 18 | 130 | 2 | 5,711 | 2,601 | 1.35 |
| `opt` | 8 | 10 | 66 | 2 | 9,974 | 4,643 | 1.56 |
| `opt` | 16 | 6 | 34 | 2 | 18,512 | 8,728 | 1.65 |
| `opt` | 32 | 4 | 18 | 2 | 35,713 | 16,898 | 1.58 |
| `dace` | 1 | 66 | 514 | 2 | 2,747 | 1,300 | 2.86 |

- `opt` runs N/W + 2, as `vecadd`. `unopt` at W = 1 is 2N + 1, where `vecadd`'s is N + 1: Vitis gives the compare and the select their own state.
- The cheapest datapath so far: `opt` at W = 8 is 10.0k µm² against `vecadd`'s 12.6k, and its critical path is 1.6 ns against 5.3 ns. Most of the area is the ports, the pin registers and the control.
- DaCe at W = 1 takes `opt`'s cycles at 9 % more area. It cannot go wider (`max(vec, 0)` does not compile).
- Lane sweep, `opt`: N/W + 2 cycles at every W from 1 to 32, so one beat per cycle holds up to 2048-bit beats.
- Lane sweep, `unopt`: from W = 2 on each beat costs about 3W + 2 cycles (its lane loop takes 3 cycles per lane), so a run is about 3N + 2N/W: slowest at W = 2 (2049 cycles at n512) and only a little faster when wider (1569 at W = 32). W = 1 is the exception (1025).
- Lane sweep, area: `opt` grows from 2.5k (W = 1) to 18.5k (W = 16) and 35.7k µm² (W = 32), 1.93x for the last doubling.
