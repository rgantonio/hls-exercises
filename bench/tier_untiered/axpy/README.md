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

First run on 27 Oct 2026 (commit 1aa2298): run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC on FreePDK45 at 10 ns. All 60 points of the tier pass csim and cosim and are portable; both sizes run on the same hardware point (`rtl_same` `yes`, or `renamed` for `unopt` W = 8). `results/report_untiered.md` has every column and `results/runs/2026-10-27_untiered.md` the run note.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² | of which flops | critical path ns |
|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 193 | 1537 | 1025 | 22,365 | 2,090 | 6.60 |
| `unopt` | 4 | 289 | 2305 | 2177 | 35,337 | 9,574 | 6.58 |
| `unopt` | 8 | 273 | 2177 | 2113 | 48,092 | 15,725 | 6.43 |
| `opt` | 1 | 67 | 515 | 3 | 24,050 | 3,127 | 6.22 |
| `opt` | 4 | 19 | 131 | 3 | 88,534 | 9,255 | 6.27 |
| `opt` | 8 | 11 | 67 | 3 | 174,759 | 17,424 | 6.44 |
| `dace` | 1 | 134 | 1030 | 518 | parked (RAM) | - | - |

- `opt` runs N/W + 3 at every W, one cycle deeper than `vecmul` for the add behind the multiplier.
- The multipliers set the area again: `opt` W = 8 is 174.8k µm² against `vecmul`'s 154.8k; the extra 20k is the eight 64-bit adders, the third axis port and the 64-bit `alpha` register (not split out by DC here).
- `unopt` at W = 4 and 8 takes 18 and 34 cycles per beat (`vecmul`'s 14 and 26), with one shared multiplier: 48.1k µm² at W = 8.
- DaCe takes about 2N (134, 1030): `alpha * x` into `__tmp0`, then `y + __tmp0`, one loop after the other, as DaCe's `dot`. Its synthesis is parked (`__tmp0` is a RAM).
