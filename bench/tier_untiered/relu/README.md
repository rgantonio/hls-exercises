# relu

$$B_i = \max(A_i, 0), \quad \text{int64}$$

snax-forge `kernels/elementwise/relu.py`. Forge has no recipe for it yet, so the sizes follow `vecadd` (n64, n512). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, B). One valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

Run-time pin, as forge's `loopCount`: `loop_count` (beats in the run), 32 bits with `ap_vld`, pulsed with the start (`docs/HLS_VS_FORGE.md` section 2). The size reaches the hardware only through it, so every size runs on one hardware point per case and W.

## Cases

| Case | Top | What runs |
|---|---|---|
| `opt` | `relu` (`src/relu.cpp`) | `directives_opt.tcl`: `BEAT` at II = 1, `LANE` unrolled. |
| `dace` | `relu_dace` (`dace/w1/`) | DaCe's map at II = 1. W = 1 only: DaCe 1.0.2 vectorizes the map, but writes `max(dace::vec, 0)`, which does not compile (no `max` for a vector and a scalar). |

Sizes n64 and n512, W = 1, 2, 4, 8 and 16 (`dace` W = 1).

## What to expect

- As `vecadd`, with a compare and a mux in place of the adder: `opt` about N/W + 2.
- The cheapest datapath of the tier, so the control and the ports are most of the area.

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
| dace | 1 | 66 | 514 | 1.00 | 1 | 2 |

Loops: `opt` `BEAT`; `dace` `VITIS_LOOP_19_1`.

- Cycles, loop II and iteration latency are the same as at 3.33 ns for both cases at every W.
