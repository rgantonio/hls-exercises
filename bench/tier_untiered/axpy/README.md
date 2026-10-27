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

Sizes n64 and n512, W = 1, 4 and 8 (`dace` W = 1).

## What to expect

- `opt`: about N/W + the multiplier's depth, as `vecmul`, with an adder behind it.
- Area close to `vecmul`'s: the 64-bit multipliers dominate, one per lane in `opt`, one shared in `unopt`.
- `dace`: about 2N, its two loops one after the other, as DaCe's `dot`.

## Results

Not run yet. The numbers will be in `results/report_untiered.md`.
