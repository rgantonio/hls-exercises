# vecadd

$$C = A + B, \quad A, B, C \in \mathbb{Z}^{N}, \text{ int64}$$

snax-forge `kernels/polybench/vecadd.py` and `recipes/vecadd.json` (N = 64, W = 4). This is the first kernel through the bench, so it checks the flow as much as the numbers. The plan is in `docs/HLS_VS_FORGE.md`.

## Cases

| Case | Top | What runs |
|---|---|---|
| `unopt` | `vecadd` (`src/vecadd.cpp`) | One loop `ADD`, nothing pipelined (`common/asic.tcl`). One port per array. |
| `opt` | `vecadd` (`src/vecadd.cpp`) | `directives_opt.tcl`: A, B and C split cyclic by W into W ports each, `ADD` unrolled by W and pipelined at II = 1. |
| `dace` | `vecadd_dace` (`dace/<size>/vecadd_dace.cpp`) | DaCe's device file (`dace/<size>/vecadd_0_0.cpp`) from forge's SDFG after `FPGATransformSDFG`. DaCe puts `PIPELINE II=1` on the map itself. One port per array. |

Sizes n64 (the recipe's) and n512; W = 4 and 8 for `opt`. The testbench makes one call on forge's vectors and checks every output.

## What to expect

These are a guide for reading the first run, not results:

- `unopt`: a few cycles per element, from the read, add and write of one iteration in sequence.
- `opt`: about N / W cycles plus the pipeline depth, since each cycle reads W elements of A and B from W ports.
- `dace`: about N cycles plus the depth: II = 1, but one element per cycle.
- forge: `add_acc` counts 19 cycles for 16 beats at N = 64, W = 4, on SNAX-GVSoC and on snax_cluster's RTL (`results/forge_cycles.csv`). That makes `opt` n64 W = 4 the like-for-like row.

## Results

The tables are in `results/report_done.md` (first run: 26 Oct 2026, commit 4b7b617). All 8 points pass csim and cosim, with DSP 0 and portable Verilog. Cycles are cosim.

| Case | n64 | n512 | Per element | Why |
|---|---|---|---|---|
| `unopt` | 193 | 1537 | 3 | Each iteration takes 3 cycles in sequence: address out, data back, add and write. |
| `opt` W = 4 | 17 | 129 | $N/W + 1$ | 16 or 128 trips at II = 1. |
| `opt` W = 8 | 9 | 65 | $N/W + 1$ | Same, with 8 ports per array. |
| `dace` | 65 | 513 | $N + 1$ | DaCe pipelines its loop at II = 1 but reads one element per cycle. |
| forge, W = 4 | 19 | — | $N/W + 3$ | `add_acc` on SNAX-GVSoC and on Verilator. |

**Findings**

- `opt` gives the A, B and C ports 4 or 8 one-bank `ap_memory` ports each, as planned. The 4-bit addresses at n64 W = 4 are 16 words per bank.
- The csynth estimate is 2 cycles above cosim for every pipelined point (19 against 17). That is the same gap S1.1 found (1029 against 1027), so the report takes cosim.
- Against forge at n64 W = 4, HLS `opt` takes 17 cycles and forge 19. Both run one beat per cycle. Forge spends 3 cycles on top of its 16 beats and HLS spends 1, which fits the known difference: 1-cycle SRAM ports here, TCDM through streamers in forge. Forge's n512 and W = 8 points would show whether that overhead stays constant.
- `dace` is DaCe's default: II = 1 on one port per array. Reaching W elements per cycle in DaCe would take its vectorization (wide words on one port), which is a different memory layout from W banks.
- The estimated clock is 1.762 ns at n64 W = 8 and 2.322 ns everywhere else. That is Vitis's FPGA estimate and doesn't affect the cycles; synthesis (doc section 6) gives the real numbers.
- DaCe's files compile with 9 `unused parameter` warnings and nothing about the unused entry function's pragmas.
