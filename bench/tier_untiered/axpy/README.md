# axpy

$$y \leftarrow y + \alpha x, \quad \text{int64}$$

snax-forge `kernels/blas/axpy.py`. Forge has no recipe for it yet, so the sizes follow `vecadd` (n64, n512). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (x, y, y_out). One valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

An axis port cannot be read and written in place (forge open item 47), so `y` comes in on `y` and leaves on `y_out`; `gen_dace.py` splits DaCe's `y` the same way (`split_inout`). `alpha` is a scalar: forge would hold it in a CSR, so here it is a run-time pin like `loop_count` (64 bits with `ap_vld`, read once per run). Run-time pin, as forge's `loopCount`: `loop_count` (beats in the run), 32 bits with `ap_vld`, pulsed with the start (`docs/HLS_VS_FORGE.md` section 2). The size reaches the hardware only through it, so every size runs on one hardware point per case and W.

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `axpy` (`src/axpy.cpp`) | `BEAT` over the beats, `LANE` over the lanes, a multiply and an add per lane, nothing pipelined. |
| `opt` | `axpy` (`src/axpy.cpp`) | `directives_opt.tcl`: `BEAT` at II = 1, `LANE` unrolled: W multipliers and W adders. |
| `dace` | `axpy_dace` (`dace/w1/`) | DaCe writes two loops, `alpha * x` into a transient `__tmp0[N]`, then `y + __tmp0`, as `dot`. The transient is a RAM sized for n512, which parks its synthesis. W = 1 only: DaCe 1.0.2's `Vectorization` rejects the scalar `alpha` (memlet out of bounds). |

Sizes n64 and n512, W = 1, 2, 4, 8, 16 and 32 (`dace` W = 1).

## What to expect

- `opt`: about N/W + the multiplier's depth, as `vecmul`, with an adder behind it.
- Area close to `vecmul`'s: the 64-bit multipliers dominate, one per lane in `opt`, one shared in `unopt`.
- `dace`: about 2N, its two loops one after the other, as DaCe's `dot`.

## Results

Runs of 27 Oct 2026: W = 1, 4, 8 first (1aa2298), then the lane sweep W = 1 to 32 (07f5dec, lane accessors inlined in e1427cc; `notes/w_sweep.md`). Run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC at 10 ns on the Nangate 45 nm and 15 nm Open Cell Libraries, rerun of 28 Oct 2026: the columns marked 45 and 15 are area, critical path, energy per cycle at DC's default switching activity (`e_total_pj`) and leakage on each, from `snax-forge-experiments/results/hls/<tech>/` (run note `snax-forge-experiments/results/hls/runs/2026-10-28_tech_rerun.md`). Every point passes csim and cosim and is portable, and both sizes run on the same hardware point. `snax-forge-experiments/results/hls/report_untiered.md` has every column; the run notes are in `snax-forge-experiments/results/hls/runs/`.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² 45 | crit ns 45 | E pJ 45 | leak µW 45 | area µm² 15 | crit ns 15 | E pJ 15 | leak µW 15 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 193 | 1537 | 1025 | 9,162 | 5.44 | 7.60 | 178 | 2,836 | 0.76 | 2.73 | 95.4 |
| `unopt` | 2 | 321 | 2561 | 2305 | 12,712 | 5.52 | 7.02 | 248 | 3,868 | 0.75 | 2.45 | 134 |
| `unopt` | 4 | 289 | 2305 | 2177 | 15,328 | 5.52 | 8.53 | 300 | 4,613 | 0.75 | 3.20 | 161 |
| `unopt` | 8 | 273 | 2177 | 2113 | 20,717 | 5.52 | 12.0 | 403 | 6,162 | 0.75 | 4.76 | 217 |
| `unopt` | 16 | 265 | 2113 | 2081 | 31,426 | 5.52 | 19.5 | 617 | 9,163 | 0.75 | 7.77 | 327 |
| `unopt` | 32 | 261 | 2081 | 2065 | 52,568 | 5.52 | 33.6 | 1,033 | 15,303 | 0.75 | 13.8 | 544 |
| `opt` | 1 | 67 | 515 | 3 | 9,997 | 5.52 | 5.14 | 194 | 3,069 | 0.76 | 1.65 | 105 |
| `opt` | 2 | 35 | 259 | 3 | 18,865 | 5.55 | 9.42 | 366 | 5,814 | 0.77 | 2.97 | 197 |
| `opt` | 4 | 19 | 131 | 3 | 36,611 | 5.55 | 17.8 | 712 | 11,307 | 0.77 | 5.51 | 383 |
| `opt` | 8 | 11 | 67 | 3 | 72,127 | 5.59 | 35.5 | 1,404 | 22,296 | 0.80 | 10.8 | 754 |
| `opt` | 16 | 7 | 35 | 3 | 143,109 | 5.63 | 66.3 | 2,781 | 44,280 | 0.81 | 21.4 | 1,498 |
| `opt` | 32 | 5 | 19 | 3 | 285,106 | 5.86 | 135 | 5,545 | 88,227 | 0.79 | 43.4 | 2,979 |
| `dace` | 1 | 134 | 1030 | 518 | parked (RAM) | - | - | - | - | - | - | - |

- `opt` runs N/W + 3 at every W, one cycle deeper than `vecmul` for the add behind the multiplier.
- The multipliers set the area again: `opt` W = 8 is 72.1k µm² against `vecmul`'s 62.6k on nangate45 (22.3k against 19.6k on nangate15); the extra 9.5k (2.7k) is the eight 64-bit adders, the third axis port and the 64-bit `alpha` register, all in the top module (only the multipliers are modules of their own).
- `unopt` at W = 4 and 8 takes 18 and 34 cycles per beat (`vecmul`'s 14 and 26), with one shared multiplier: 20.7k µm² at W = 8 on nangate45, 6.2k on nangate15.
- DaCe takes about 2N (134, 1030): `alpha * x` into `__tmp0`, then `y + __tmp0`, one loop after the other, as DaCe's `dot`. Its synthesis is parked (`__tmp0` is a RAM).
- Lane sweep, `opt`: N/W + 3 cycles at every W from 1 to 32, so one beat per cycle holds up to 2048-bit beats.
- Lane sweep, `unopt`: from W = 2 on each beat costs about 4W + 2 cycles (its lane loop takes 4 cycles per lane), so a run is about 4N + 2N/W: slowest at W = 2 (2561 cycles at n512) and only a little faster when wider (2081 at W = 32). W = 1 is the exception (1537).
- Lane sweep, area: `opt` grows from 10.0k (W = 1) to 143.1k (W = 16) and 285.1k µm² (W = 32) on nangate45, 1.99x for the last doubling; on nangate15 from 3.1k to 44.3k and 88.2k µm², 1.99x.
