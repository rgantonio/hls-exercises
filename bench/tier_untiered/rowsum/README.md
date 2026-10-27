# rowsum

$$y_i = \sum_j A_{ij}, \quad \text{int64}$$

snax-forge `kernels/elementwise/rowsum.py`, with `recipes/rowsum_serial.json` (M = 4, N = 16, W = 1, accumulator) and `recipes/rowsum.json` (M = 8, N = 64, W = 4, adder tree). The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, y). One valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly. `y` carries one element per beat, M beats.

Run-time pins, as forge's `Accumulator`: `loop_count` (M × N / W beats) and `len` (N / W beats per sum), 32 bits with `ap_vld`, pulsed with the start. This is `vsum`'s top with `len` < `loop_count`: the sum restarts every row. DaCe's top sets DaCe's M and N from the pins (M = `loop_count` / `len`, N = `len` × W).

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `rowsum` (`src/rowsum.cpp`) | `vsum`'s body, nothing pipelined. |
| `opt` | `rowsum` (`src/rowsum.cpp`) | `directives_opt.tcl`: `BEAT` at II = 1, `LANE` unrolled into an adder tree. |
| `dace` | `rowsum_dace` (`dace/w1/`) | DaCe's reduction first zeroes `y` (M cycles), then adds every element into `y[i]` in place (`xilinx_wcr_fixed`), so `y` is read and written N times per row. An axis port cannot do that, so the generated top keeps `y` in a local buffer (sized for m8_n64) and streams it out after DaCe's loops: M more cycles and a RAM, which parks its synthesis. W = 1 only, as for the other reductions. |

Sizes m4_n16 and m8_n64 (the two recipes), W = 1, 2, 4, 8, 16 and 32 (`dace` W = 1).

## What to expect

- `opt`: about M × N / W plus a few, one result every N / W beats with no stall at the restart.
- `dace`: about M (zeroing) + M × N + M (streaming `y` out), so roughly 2M more than `opt` W = 1.

## Results

Runs of 27 Oct 2026: W = 1, 4, 8 first (1aa2298), then the lane sweep W = 1 to 32 (07f5dec, lane accessors inlined in e1427cc; `notes/w_sweep.md`). Run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC on FreePDK45 at 10 ns. Every point passes csim and cosim and is portable, and both sizes run on the same hardware point. `results/report_untiered.md` has every column; the run notes are in `results/runs/`.

| Case | W | cycles m4_n16 | cycles m8_n64 | over the beats (m8_n64) | area µm² | of which flops | critical path ns |
|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 129 | 1025 | 513 | 5,204 | 2,090 | 5.39 |
| `unopt` | 2 | 225 | 1793 | 1537 | 9,325 | 4,181 | 5.43 |
| `unopt` | 4 | 177 | 1409 | 1281 | 11,226 | 5,218 | 5.43 |
| `unopt` | 8 | 153 | 1217 | 1153 | 15,868 | 7,276 | 5.43 |
| `unopt` | 16 | 141 | 1121 | 1089 | 24,386 | 11,377 | 5.43 |
| `unopt` | 32 | – | 1073 | 1057 | 41,292 | 19,562 | 5.43 |
| `opt` | 1 | 66 | 514 | 2 | 5,252 | 2,106 | 5.36 |
| `opt` | 2 | 34 | 258 | 2 | 6,635 | 2,617 | 5.42 |
| `opt` | 4 | 18 | 130 | 2 | 9,405 | 3,638 | 5.86 |
| `opt` | 8 | 10 | 66 | 2 | 13,323 | 4,659 | 5.68 |
| `opt` | 16 | 7 | 35 | 3 | 22,854 | 7,739 | 5.70 |
| `opt` | 32 | – | 19 | 3 | 43,469 | 14,887 | 5.70 |
| `dace` | 1 | 118 | 578 | 66 | parked (RAM) | - | - |

- `rowsum` is `vsum`: its `unopt` and `opt` Verilog differs from `vsum`'s only in the output port's name, and the area is identical. A row's restart costs no cycle (514 for m8_n64 at W = 1, as `vsum` at n512).
- DaCe takes 118 and 578 cycles, about 46 and 50 more than M + M·N + M. Most of it is a 36-cycle divider that computes M = `loop_count` / `len` before the loops start: the price of deriving DaCe's symbols from forge's pins. Its synthesis is parked (the buffered `y` is a RAM).
- Lane sweep, `opt`: N/W + 2 to 3 cycles at every W from 1 to 32, so one beat per cycle holds up to 2048-bit beats.
- Lane sweep, `unopt`: from W = 2 on each beat costs about 2W + 3 cycles (its lane loop takes 2 cycles per lane), so a run is about 2N + 3N/W: slowest at W = 2 (1793 cycles at m8_n64) and only a little faster when wider (1073 at W = 32). W = 1 is the exception (1025).
- Lane sweep, area: `opt` grows from 5.3k (W = 1) to 22.9k (W = 16) and 43.5k µm² (W = 32), 1.90x for the last doubling.
