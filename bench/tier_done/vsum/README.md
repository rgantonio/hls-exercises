# vsum

$$\mathit{out} = \sum_{i=0}^{N-1} A_i, \quad \text{int64}$$

snax-forge `kernels/polybench/vsum.py`, with `recipes/vsum.json` (W = 1, `chisel_accumulator`) and `recipes/vsum_tree.json` (W = 4, `chisel_adder_tree`). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, out (one beat)): one valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

Run-time pins, as forge's `Accumulator`: `loop_count` (beats in the run, N / W) and `len` (beats per result, T), 32-bit plain inputs read at `ap_start`. A result leaves every `len` beats and at the last beat, and the sum restarts. The testbench sets `len = loop_count`, so one sum. DaCe's top takes `len` too but has no restart, so it ignores it. The size reaches the hardware only through the pins, so every size runs on one hardware point per case and W (`rtl/done/vsum/<case>_w<W>/`).

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `vsum` (`src/vsum.cpp`) | `BEAT` over the beats, `LANE` over the W lanes of a beat, nothing pipelined: the lanes run one after the other. |
| `opt` | `vsum` (`src/vsum.cpp`) | `directives_opt.tcl`: `BEAT` pipelined at II = 1, `LANE` unrolled, so a whole beat goes through every cycle. |
| `dace` | `vsum_dace` (`dace/w<W>/`) | DaCe expands `np.sum` into a loop at II = 1 that writes through a write-conflict resolution into a scalar. DaCe 1.0.2 cannot vectorize the reduction, so this case runs at W = 1 only. |

Sizes n64 and n512 (the pins' values), W = 1, 2, 4, 8, 16 and 32 (hardware).

## What to expect

- `opt` W = 1: about $N$ plus the depth, one add per cycle on the loop-carried path (forge's accumulator).
- `opt` W = 4 and 8: about $N/W$ plus the depth. Vitis has to put the W lanes in a tree so only one add is on the loop-carried path (forge's adder tree). Check that `BEAT`'s II is 1.
- forge, `vsum.json` at n512: `sum_acc` counts 515 cycles on SNAX-GVSoC (overhead 3).

## Results

Runs of 27 Oct 2026: W = 1, 4, 8 first (d2062af), then the lane sweep W = 1 to 32 (07f5dec, lane accessors inlined in e1427cc; `notes/w_sweep.md`). Run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC at 10 ns on the Nangate 45 nm and 15 nm Open Cell Libraries, rerun of 28 Oct 2026: the columns marked 45 and 15 are area, critical path, energy per cycle at DC's default switching activity (`e_total_pj`) and leakage on each, from `snax-forge-experiments/results/hls/<tech>/` (run note `snax-forge-experiments/results/hls/runs/2026-10-28_tech_rerun.md`). Every point passes csim and cosim and is portable, and both sizes run on the same hardware point. `snax-forge-experiments/results/hls/report_done.md` has every column; the run notes are in `snax-forge-experiments/results/hls/runs/`.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² 45 | crit ns 45 | E pJ 45 | leak µW 45 | area µm² 15 | crit ns 15 | E pJ 15 | leak µW 15 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 129 | 1025 | 513 | 2,320 | 4.65 | 1.98 | 45.5 | 673 | 0.60 | 0.633 | 24.0 |
| `unopt` | 2 | 225 | 1793 | 1537 | 4,278 | 4.65 | 2.93 | 79.6 | 1,244 | 0.59 | 1.11 | 44.3 |
| `unopt` | 4 | 177 | 1409 | 1281 | 5,238 | 4.65 | 3.54 | 98.9 | 1,504 | 0.59 | 1.38 | 53.9 |
| `unopt` | 8 | 153 | 1217 | 1153 | 7,176 | 4.65 | 4.58 | 135 | 2,049 | 0.59 | 1.90 | 73.7 |
| `unopt` | 16 | 141 | 1121 | 1089 | 11,016 | 4.65 | 6.69 | 211 | 3,092 | 0.59 | 2.92 | 112 |
| `unopt` | 32 | 135 | 1073 | 1057 | 18,473 | 4.65 | 10.6 | 351 | 5,226 | 0.59 | 4.95 | 190 |
| `opt` | 1 | 66 | 514 | 2 | 2,383 | 4.68 | 1.67 | 46.4 | 686 | 0.60 | 0.598 | 24.9 |
| `opt` | 2 | 34 | 258 | 2 | 3,060 | 4.71 | 1.96 | 57.4 | 865 | 0.60 | 0.729 | 30.5 |
| `opt` | 4 | 18 | 130 | 2 | 4,414 | 4.90 | 2.50 | 81.8 | 1,241 | 0.63 | 0.992 | 42.7 |
| `opt` | 8 | 10 | 66 | 2 | 6,309 | 5.08 | 3.40 | 115 | 1,768 | 0.64 | 1.33 | 58.9 |
| `opt` | 16 | 7 | 35 | 3 | 10,926 | 4.87 | 5.80 | 200 | 3,064 | 0.61 | 2.31 | 100 |
| `opt` | 32 | 5 | 19 | 3 | 20,961 | 5.08 | 10.7 | 382 | 5,855 | 0.64 | 4.47 | 190 |
| `dace` | 1 | 67 | 515 | 3 | 1,922 | 4.62 | 1.45 | 36.9 | 538 | 0.60 | 0.550 | 19.1 |

- `opt` at W = 1 runs n512 in 514 cycles. Forge's `sum_acc` counts 515, and DaCe 515 too, so the three are within one cycle.
- `opt` at W = 4 and 8 adds the lanes in a tree and keeps one beat per cycle (130 and 66 cycles at n512).
- DaCe is the smallest design (1.9k against 2.4k µm² for `opt` W = 1 on nangate45, 538 against 686 on nangate15): it has no `len` restart, which forge's `Accumulator` and the HLS tops carry.
- Lane sweep, `opt`: N/W + 2 to 3 cycles at every W from 1 to 32, so one beat per cycle holds up to 2048-bit beats.
- Lane sweep, `unopt`: from W = 2 on each beat costs about 2W + 3 cycles (its lane loop takes 2 cycles per lane), so a run is about 2N + 3N/W: slowest at W = 2 (1793 cycles at n512) and only a little faster when wider (1073 at W = 32). W = 1 is the exception (1025).
- Lane sweep, area: `opt` grows from 2.4k (W = 1) to 10.9k (W = 16) and 21.0k µm² (W = 32) on nangate45, 1.92x for the last doubling; on nangate15 from 686 to 3.1k and 5.9k µm², 1.91x.
