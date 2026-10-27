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

Rerun on 27 Oct 2026 (commit d2062af): run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC on FreePDK45 at 10 ns. Every point passes csim and cosim and is portable. Both sizes run on the same hardware point (`rtl_same`: `yes`, or `renamed` for `unopt` W = 8, the same circuit with shifted net names). `results/report_done.md` has every column.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² | of which flops | critical path ns |
|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 129 | 1025 | 513 | 5,204 | 2,090 | 5.39 |
| `unopt` | 4 | 177 | 1409 | 1281 | 11,226 | 5,218 | 5.43 |
| `unopt` | 8 | 153 | 1217 | 1153 | 15,868 | 7,276 | 5.43 |
| `opt` | 1 | 66 | 514 | 2 | 5,252 | 2,106 | 5.36 |
| `opt` | 4 | 18 | 130 | 2 | 9,405 | 3,638 | 5.86 |
| `opt` | 8 | 10 | 66 | 2 | 13,323 | 4,659 | 5.68 |
| `dace` | 1 | 67 | 515 | 3 | 4,084 | 1,835 | 5.36 |

- `opt` at W = 1 runs n512 in 514 cycles. Forge's `sum_acc` counts 515, and DaCe 515 too, so the three are within one cycle.
- `opt` at W = 4 and 8 adds the lanes in a tree and keeps one beat per cycle (130 and 66 cycles at n512).
- DaCe is the smallest design (4.08k against 5.25k µm² for `opt` W = 1): it has no `len` restart, which forge's `Accumulator` and the HLS tops carry.
