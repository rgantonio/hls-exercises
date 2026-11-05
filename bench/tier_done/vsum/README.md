# vsum

$$\mathit{out} = \sum_{i=0}^{N-1} A_i, \quad \text{int64}$$

snax-forge `kernels/polybench/vsum.py`, with `recipes/vsum.json` (W = 1, `chisel_accumulator`) and `recipes/vsum_tree.json` (W = 4, `chisel_adder_tree`). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, out (one beat)): one valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

Run-time pins, as forge's `Accumulator`: `loop_count` (beats in the run, N / W) and `len` (beats per result, T), 32-bit plain inputs read at `ap_start`. A result leaves every `len` beats and at the last beat, and the sum restarts. The testbench sets `len = loop_count`, so one sum. DaCe's top takes `len` too but has no restart, so it ignores it. The size reaches the hardware only through the pins, so every size runs on one hardware point per case and W (`rtl/done/vsum/<case>_w<W>/`).

## Cases

| Case | Top | What runs |
|---|---|---|
| `opt` | `vsum` (`src/vsum.cpp`) | `directives_opt.tcl`: `BEAT` pipelined at II = 1, `LANE` unrolled, so a whole beat goes through every cycle. |
| `dace` | `vsum_dace` (`dace/w<W>/`) | DaCe expands `np.sum` into a loop at II = 1 that writes through a write-conflict resolution into a scalar. DaCe 1.0.2 cannot vectorize the reduction, so this case runs at W = 1 only. |

Sizes n64 and n512 (the pins' values), W = 1, 2, 4, 8 and 16 (hardware).

## What to expect

- `opt` W = 1: about $N$ plus the depth, one add per cycle on the loop-carried path (forge's accumulator).
- `opt` W = 4 and 8: about $N/W$ plus the depth. Vitis has to put the W lanes in a tree so only one add is on the loop-carried path (forge's adder tree). Check that `BEAT`'s II is 1.
- forge, `vsum.json` at n512: `sum_acc` counts 515 cycles on SNAX-GVSoC (overhead 3).

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
| dace | 1 | 67 | 515 | 1.01 | 1 | 1 |

Loops: `opt` `BEAT`; `dace` `VITIS_LOOP_37_1`.

- `opt` W = 16: `BEAT`'s iteration latency 3 to 2 against 3.33 ns, one fewer cycle per run; W = 1 to 8 unchanged.
- `dace`: `VITIS_LOOP_37_1`'s iteration latency 2 to 1, cycles unchanged.
- Loop II is 1 at both clocks.
