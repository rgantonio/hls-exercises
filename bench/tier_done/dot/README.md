# dot

$$\mathit{out} = \sum_{i=0}^{N-1} A_i B_i, \quad \text{int64}$$

snax-forge `kernels/polybench/dot.py`, with `recipes/dot.json` (vmul then an adder tree) and `recipes/dot_serial.json` (vmul then an accumulator), both chaining two accelerators through L1. dot is parked in forge until M13, so forge rows come later. The plan is in `docs/HLS_VS_FORGE.md`.

## Ports

Axis (A, B, out (one beat)): one valid-ready port per array, each beat W lanes of 64 bits, as forge's `Decoupled(Vec(lanes, UInt(64)))`. Control is `ap_ctrl_hs`. The testbench packs forge's vectors into beats and checks every output exactly.

Run-time pins, as forge's `Accumulator`: `loop_count` (beats in the run, N / W) and `len` (beats per result, T), 32-bit plain inputs read at `ap_start`. A result leaves every `len` beats and at the last beat, and the sum restarts. The testbench sets `len = loop_count`, so one sum. DaCe's top takes `len` too but has no restart, so it ignores it. The size reaches the hardware only through the pins, so every size runs on one hardware point per case and W (`rtl/done/dot/<case>_w<W>/`).

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `dot` (`src/dot.cpp`) | `BEAT` over the beats, `LANE` over the W lanes of a beat, nothing pipelined: the lanes run one after the other. |
| `opt` | `dot` (`src/dot.cpp`) | `directives_opt.tcl`: `BEAT` pipelined at II = 1, `LANE` unrolled, so a whole beat goes through every cycle. |
| `dace` | `dot_dace` (`dace/w<W>/`) | DaCe's default is two loops: `A * B` into a transient array `__tmp0[N]`, then the sum over it, which is forge's "vmul then vsum through L1" inside one block. The array is a RAM inside the block (BRAM in the estimate), sized for n512, the largest size: its depth is a design-time bound, so this hardware takes runs up to N = 512. As for `vsum`, W = 1 only. |

Sizes n64 and n512 (the pins' values), W = 1, 2, 4, 8, 16 and 32 (hardware).

## What to expect

- `opt`: about $N/W$ plus a deeper pipeline (W multipliers, an adder tree, one accumulator). This is the fused form, with no buffer between multiply and sum.
- `dace`: about $2N$ plus two depths, because its two loops run one after the other.

## Results

Runs of 27 Oct 2026: W = 1, 4, 8 first (d2062af), then the lane sweep W = 1 to 32 (07f5dec, lane accessors inlined in e1427cc; `notes/w_sweep.md`). Run-time pins as `ap_vld`, axis without register slices, HLS clock 3.33 ns, DC at 10 ns on gscl45nm (FreePDK45), since retired: the area and critical-path columns are from that run. Synthesis now runs on the Nangate 45 nm and 15 nm Open Cell Libraries, with results in `snax-forge-experiments/results/hls/<tech>/`. Every point passes csim and cosim and is portable, and both sizes run on the same hardware point. `snax-forge-experiments/results/hls/report_done.md` has every column; the run notes are in `snax-forge-experiments/results/hls/runs/`.

| Case | W | cycles n64 | cycles n512 | over the beats (n512) | area µm² | of which flops | critical path ns |
|---|---|---|---|---|---|---|---|
| `unopt` | 1 | 193 | 1537 | 1025 | 23,561 | 2,617 | 5.96 |
| `unopt` | 2 | 289 | 2305 | 2049 | 30,314 | 6,231 | 6.20 |
| `unopt` | 4 | 241 | 1921 | 1793 | 34,087 | 8,289 | 6.21 |
| `unopt` | 8 | 217 | 1729 | 1665 | 43,345 | 12,390 | 6.21 |
| `unopt` | 16 | 205 | 1633 | 1601 | 60,316 | 20,576 | 6.39 |
| `unopt` | 32 | 199 | 1585 | 1569 | 93,875 | 36,931 | 6.23 |
| `opt` | 1 | 67 | 515 | 3 | 24,445 | 3,143 | 6.22 |
| `opt` | 2 | 35 | 259 | 3 | 45,010 | 4,675 | 6.23 |
| `opt` | 4 | 19 | 131 | 3 | 86,091 | 7,739 | 6.16 |
| `opt` | 8 | 12 | 68 | 4 | 169,995 | 14,903 | 6.35 |
| `opt` | 16 | 8 | 36 | 4 | 337,975 | 29,200 | 6.21 |
| `opt` | 32 | 6 | 20 | 4 | 666,998 | 53,709 | 6.06 |
| `dace` | 1 | 135 | 1031 | 519 | parked (RAM) | - | - |

- `opt` runs N/W + 3 (W = 1, 4) or + 4 (W = 8): the multiply, the lane tree and the accumulator make the pipeline one stage deeper than `vsum`'s.
- DaCe's dot is two loops one after the other through a 512-entry buffer: 1031 cycles at n512, about 2N. Its synthesis is parked until a RAM macro exists (`docs/HLS_VS_FORGE.md` section 6).
- As in `vecmul`, the multipliers set the area: `opt` W = 8 is 170k µm², `unopt` W = 8, with one shared multiplier, 43.3k.
- Lane sweep, `opt`: N/W + 3 to 4 cycles at every W from 1 to 32, so one beat per cycle holds up to 2048-bit beats.
- Lane sweep, `unopt`: from W = 2 on each beat costs about 3W + 3 cycles (its lane loop takes 3 cycles per lane), so a run is about 3N + 3N/W: slowest at W = 2 (2305 cycles at n512) and only a little faster when wider (1585 at W = 32). W = 1 is the exception (1537).
- Lane sweep, area: `opt` grows from 24.4k (W = 1) to 338.0k (W = 16) and 667.0k µm² (W = 32), 1.97x for the last doubling.
