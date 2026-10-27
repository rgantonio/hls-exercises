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

Sizes n64 and n512, W = 1, 4 and 8 (`dace` W = 1).

## What to expect

- As `vecadd`, with a compare and a mux in place of the adder: `opt` about N/W + 2.
- The cheapest datapath of the tier, so the control and the ports are most of the area.

## Results

Not run yet. The numbers will be in `results/report_untiered.md`.
