# matadd

$$C = A + B, \quad A, B, C \in \mathbb{Z}^{M \times N}, \quad \text{int64}$$

snax-forge `kernels/elementwise/matadd.py`, with `recipes/matadd.json` (M = 8, N = 16, W = 4). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, B, C). One valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

The rows are contiguous, so the block sees one flat run of M × N / W beats, as forge's recipe programs it: the row loop and the split column loop live in the streamer, and the unit gets one `loopCount`. Run-time pin, as forge's `loopCount`: `loop_count` (beats in the run), 32 bits with `ap_vld`, pulsed with the start (`docs/HLS_VS_FORGE.md` section 2). The size reaches the hardware only through it, so every size runs on one hardware point per case and W. DaCe's top keeps DaCe's two symbols and sets them from the pin as M = 1 and N = `loop_count` × W, the same flat run.

## Cases

| Case | Top | What runs |
|---|---|---|
| `opt` | `matadd` (`src/matadd.cpp`) | `directives_opt.tcl`: `BEAT` at II = 1, `LANE` unrolled. |
| `dace` | `matadd_dace` (`dace/w<W>/`) | DaCe's 2-D map, vectorized along the columns at W = 4 and 8; its row loop runs once. |

Sizes m8_n16 (the recipe) and m16_n32 (512 elements), W = 1, 2, 4, 8 and 16.

## What to expect

- The hand-written tops are `vecadd`'s hardware with another name, so the cycles and area should match `vecadd` at the same element count. That checks that the 2-D shape costs the unit nothing.
- `dace` may differ from `vecadd`'s: DaCe's map is 2-D, with a row loop around the column loop.

## Results

Rebuilt in HSYN1 (snax-forge-experiments, 5 Nov 2026): `opt` and `dace` at a 10 ns HLS clock, W = 1 to 16. The cycles below are filled by HSYN1 R2 from `snax-forge-experiments/results/hls/hls_cycles.csv`; area, timing and energy per point are in `snax-forge-experiments/results/compare_<tier>.csv`. The earlier results (3.33 ns, `unopt`, W up to 32) are in git history up to cbc2541.

Cycles are cosim's (RTL simulation) from `ap_start` to `ap_done`; beats = elements / W at m16_n32. Loop II and iteration latency are csynth's, per loop in the order named below the table.

| case | W | cycles m8_n16 | cycles m16_n32 | cycles / beats (m16_n32) | loop II | iteration latency |
|---|---|---|---|---|---|---|
| opt | 1 | 130 | 514 | 1.00 | 1 | 2 |
| opt | 2 | 66 | 258 | 1.01 | 1 | 2 |
| opt | 4 | 34 | 130 | 1.02 | 1 | 2 |
| opt | 8 | 18 | 66 | 1.03 | 1 | 2 |
| opt | 16 | 10 | 34 | 1.06 | 1 | 2 |
| dace | 1 | 130 | 514 | 1.00 | 1 | 2 |
| dace | 2 | 66 | 258 | 1.01 | 1 | 2 |
| dace | 4 | 35 | 131 | 1.02 | 1 | 2 |
| dace | 8 | 19 | 67 | 1.05 | 1 | 2 |
| dace | 16 | 11 | 35 | 1.09 | 1 | 2 |

Loops: `opt` `BEAT`; `dace` `VITIS_LOOP_20_2`.

- Cycles, loop II and iteration latency are the same as at 3.33 ns for both cases at every W.
