# axpy

$$y \leftarrow y + \alpha x, \quad \text{int64}$$

snax-forge `kernels/blas/axpy.py`. Forge has no recipe for it yet, so the sizes follow `vecadd` (n64, n512). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (x, y, y_out). One valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

An axis port cannot be read and written in place (forge open item 47), so `y` comes in on `y` and leaves on `y_out`; `gen_dace.py` splits DaCe's `y` the same way (`split_inout`). `alpha` is a scalar: forge would hold it in a CSR, so here it is a run-time pin like `loop_count` (64 bits with `ap_vld`, read once per run). Run-time pin, as forge's `loopCount`: `loop_count` (beats in the run), 32 bits with `ap_vld`, pulsed with the start (`docs/HLS_VS_FORGE.md` section 2). The size reaches the hardware only through it, so every size runs on one hardware point per case and W.

## Cases

| Case | Top | What runs |
|---|---|---|
| `opt` | `axpy` (`src/axpy.cpp`) | `directives_opt.tcl`: `BEAT` at II = 1, `LANE` unrolled: W multipliers and W adders. |
| `dace` | `axpy_dace` (`dace/w1/`) | DaCe writes two loops, `alpha * x` into a transient `__tmp0[N]`, then `y + __tmp0`, as `dot`. The transient is a RAM sized for n512, which parks its synthesis. W = 1 only: DaCe 1.0.2's `Vectorization` rejects the scalar `alpha` (memlet out of bounds). |

Sizes n64 and n512, W = 1, 2, 4, 8 and 16 (`dace` W = 1).

## What to expect

- `opt`: about N/W + the multiplier's depth, as `vecmul`, with an adder behind it.
- Area close to `vecmul`'s: the 64-bit multipliers dominate, one per lane in `opt`.
- `dace`: about 2N, its two loops one after the other, as DaCe's `dot`.

## Results

Rebuilt in HSYN1 (snax-forge-experiments, 5 Nov 2026): `opt` and `dace` at a 10 ns HLS clock, W = 1 to 16. The cycles below are filled by HSYN1 R2 from `snax-forge-experiments/results/hls/hls_cycles.csv`; area, timing and energy per point are in `snax-forge-experiments/results/compare_<tier>.csv`. The earlier results (3.33 ns, `unopt`, W up to 32) are in git history up to cbc2541.

Cycles are cosim's (RTL simulation) from `ap_start` to `ap_done`; beats = elements / W at n512. Loop II and iteration latency are csynth's, per loop in the order named below the table.

| case | W | cycles n64 | cycles n512 | cycles / beats (n512) | loop II | iteration latency |
|---|---|---|---|---|---|---|
| opt | 1 | 66 | 514 | 1.00 | 1 | 2 |
| opt | 2 | 34 | 258 | 1.01 | 1 | 2 |
| opt | 4 | 18 | 130 | 1.02 | 1 | 2 |
| opt | 8 | 10 | 66 | 1.03 | 1 | 2 |
| opt | 16 | 6 | 34 | 1.06 | 1 | 2 |
| dace | 1 | 133 | 1029 | 2.01 | 1 / 1 | 1 / 2 |

Loops: `opt` `BEAT`; `dace` `VITIS_LOOP_19_1`, `VITIS_LOOP_37_2`.

- `opt`: `BEAT`'s iteration latency is 2 at every W, against 3 at 3.33 ns, one fewer cycle per run.
- `dace`: `VITIS_LOOP_19_1`'s iteration latency 3 to 1, one fewer cycle per run.
- Loop II is 1 at both clocks.
