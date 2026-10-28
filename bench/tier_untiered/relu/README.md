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

Runs of 27 Oct 2026: W = 1, 4, 8 first (1aa2298), then the lane sweep W = 1 to 32 (07f5dec, lane accessors inlined in e1427cc; `notes/w_sweep.md`). Run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC at 10 ns on the Nangate 45 nm and 15 nm Open Cell Libraries, rerun of 28 Oct 2026: the columns marked 45 and 15 are area, critical path, energy per cycle at DC's default switching activity (`e_total_pj`) and leakage on each, from `snax-forge-experiments/results/hls/<tech>/` (run note `snax-forge-experiments/results/hls/runs/2026-10-28_tech_rerun.md`). Every point passes csim and cosim and is portable, and both sizes run on the same hardware point. `snax-forge-experiments/results/hls/report_untiered.md` has every column; the run notes are in `snax-forge-experiments/results/hls/runs/`.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² 45 | crit ns 45 | E pJ 45 | leak µW 45 | area µm² 15 | crit ns 15 | E pJ 15 | leak µW 15 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 129 | 1025 | 513 | 668 | 0.97 | 0.591 | 14.6 | 193 | 0.14 | 0.187 | 7.60 |
| `unopt` | 2 | 257 | 2049 | 1793 | 2,888 | 1.13 | 2.23 | 58.5 | 846 | 0.21 | 0.878 | 30.9 |
| `unopt` | 4 | 225 | 1793 | 1665 | 4,586 | 1.14 | 3.50 | 91.0 | 1,343 | 0.21 | 1.39 | 49.1 |
| `unopt` | 8 | 209 | 1665 | 1601 | 8,011 | 1.14 | 6.05 | 157 | 2,331 | 0.22 | 2.40 | 84.3 |
| `unopt` | 16 | 201 | 1601 | 1569 | 14,912 | 1.19 | 11.3 | 294 | 4,290 | 0.22 | 4.40 | 155 |
| `unopt` | 32 | 197 | 1569 | 1553 | 28,519 | 1.24 | 22.1 | 568 | 8,270 | 0.24 | 8.34 | 294 |
| `opt` | 1 | 66 | 514 | 2 | 1,128 | 0.96 | 0.750 | 22.2 | 320 | 0.17 | 0.291 | 12.5 |
| `opt` | 2 | 34 | 258 | 2 | 1,635 | 0.97 | 1.03 | 31.7 | 460 | 0.20 | 0.425 | 17.8 |
| `opt` | 4 | 18 | 130 | 2 | 2,647 | 0.98 | 1.57 | 50.6 | 741 | 0.20 | 0.691 | 28.4 |
| `opt` | 8 | 10 | 66 | 2 | 4,672 | 1.15 | 2.65 | 88.5 | 1,303 | 0.20 | 1.23 | 49.7 |
| `opt` | 16 | 6 | 34 | 2 | 8,724 | 1.31 | 4.84 | 164 | 2,426 | 0.24 | 2.30 | 92.2 |
| `opt` | 32 | 4 | 18 | 2 | 16,809 | 1.11 | 9.10 | 316 | 4,672 | 0.22 | 4.43 | 177 |
| `dace` | 1 | 66 | 514 | 2 | 1,246 | 1.69 | 0.911 | 24.3 | 357 | 0.31 | 0.356 | 13.6 |

- `opt` runs N/W + 2, as `vecadd`. `unopt` at W = 1 is 2N + 1, where `vecadd`'s is N + 1: Vitis gives the compare and the select their own state.
- The cheapest datapath so far: `opt` at W = 8 is 4.7k µm² against `vecadd`'s 6.1k on nangate45, and its critical path is 1.15 ns against 4.54 ns (0.20 against 0.58 ns on nangate15). Most of the area is the ports, the pin registers and the control.
- DaCe at W = 1 takes `opt`'s cycles at 10 % more area on nangate45 (12 % on nangate15). It cannot go wider (`max(vec, 0)` does not compile).
- Lane sweep, `opt`: N/W + 2 cycles at every W from 1 to 32, so one beat per cycle holds up to 2048-bit beats.
- Lane sweep, `unopt`: from W = 2 on each beat costs about 3W + 2 cycles (its lane loop takes 3 cycles per lane), so a run is about 3N + 2N/W: slowest at W = 2 (2049 cycles at n512) and only a little faster when wider (1569 at W = 32). W = 1 is the exception (1025).
- Lane sweep, area: `opt` grows from 1.1k (W = 1) to 8.7k (W = 16) and 16.8k µm² (W = 32) on nangate45, 1.93x for the last doubling; on nangate15 from 320 to 2.4k and 4.7k µm², 1.93x.
