# DaCe, tuned with its own tools

Experiments for snax-forge open item 130 (task DACE2): what a `dace_tuned` case could be, beside `dace` (DaCe as it comes, `bench/gen/gen_dace.py`). The rule: only DaCe's own transforms and library expansions, as DaCe's own `tests/npbench/` and `tests/blas/nodes/` use them; no hand-written C++, no added pragmas, no edits to generated code. Nothing here is a bench case yet: no Vitis run, no synthesis.

## Run

From this folder, in snax-forge's pixi environment (DaCe 1.0.2, networkx < 3.6), as `gen_dace.py` runs:

```bash
FORGE=../../../snax-forge pixi run --manifest-path $FORGE/pixi.toml python exp1_auto.py   # then exp2_fuse.py, exp3_lanes.py, exp4_npdot.py
AP_INCLUDE=$XILINX_HLS/include python csim.py   # or the open github.com/Xilinx/HLS_arbitrary_Precision_Types/include
```

Each experiment writes DaCe's Xilinx C++ to `out/` (ignored by git) and prints one line per variant: its module, its top-level transients (a RAM shows as an `[N]` array) and the HLS pragmas it carries. `csim.py` compiles every device file in `out/dev/` with g++ in hlslib's simulation mode, runs it on random int64 data (N = 2048, rowsum 16 × 128) and compares with NumPy. It checks the result, not cycles or area.

| Script | What it tries |
|---|---|
| `exp1_auto.py` | today's flow (`FPGATransformSDFG` only) against `auto_optimize(sdfg, DeviceType.FPGA)`, W = 1, six kernels |
| `exp2_fuse.py` | `MapReduceFusion` on dot and rowsum, then the plain flow or `auto_optimize` |
| `exp3_lanes.py` | W = 4 the DaCe way: `Vectorization` before or after the fusion, BLAS `Dot` and `Axpy` nodes on `dace.vector` arrays, vsum and relu |
| `exp4_npdot.py` | dot written as `np.dot`: which expansion `auto_optimize` picks by itself |

## Findings (DaCe 1.0.2, 12 Nov 2026)

W = 1:

| Kernel | Today | `auto_optimize(FPGA)` | With `MapReduceFusion` | C-sim |
|---|---|---|---|---|
| dot | product loop into `__tmp0[N]`, then a sum loop | `__tmp0[N]` kept; the sum becomes `FPGAPartialReduction`: 16 partial sums, `i % 16` indexing, a 16-add drain | one loop, `out += A[i] * B[i]`, no RAM | PASS all |
| axpy | `alpha * x` into `__tmp0[N]`, then `+ y` | fusion removes `__tmp0`: one loop `alpha * x + y` | — | PASS |
| vsum, rowsum | one accumulator | 16 partial sums and the drain | does not apply to rowsum | PASS |
| vecadd, relu | one loop | unchanged | — | PASS (vecadd) |

W = 4:

| Route | Result |
|---|---|
| dot: `MapReduceFusion`, then `Vectorization` | invalid SDFG (memlet out of bounds) |
| dot: `Vectorization`, then the `Reduce` | wrong code: N iterations over N/4 vectors; C-sim segfaults |
| dot: `Dot` node on `dace.vector` arrays, `FPGA_Accumulate` | PASS: per beat W multipliers, an unrolled chain of W − 1 adds, one accumulator |
| dot: the same, `FPGA_PartialSums` | PASS: adds 8 partial sums and a drain |
| dot as `np.dot` | the frontend gives a `Dot` node; `auto_optimize` picks `FPGA_PartialSums`; lanes still need vector-typed arrays |
| axpy: `Vectorization` after fusion | does not match (the scalar `alpha`) |
| axpy: `Axpy` node, `fpga` expansion | PASS: W multiply-adds per beat |
| vsum | `Vectorization` does not match; `Reduce`'s FPGA expansion refuses vectors (`reduce.py`: "Vectorization currently not implemented") |
| relu | `Vectorization` applies; `max(vec, 0)` does not compile |

Why: `Vectorization` matches only when every memlet of the tasklet indexes the innermost map variable in its last dimension, so a reduction's `out[0]` and a scalar `alpha` never match. The partial-sum expansions hide floating-point adder latency; on int64 they only add flops and a drain. `Dot` and `Axpy` need `n` set and the symbol named `n`, as in DaCe's tests (`node.n = n`), or the loop runs n / W² times.

## What `dace_tuned` would be

| Kernel | W = 1 | W > 1 |
|---|---|---|
| dot | `MapReduceFusion` | `np.dot` on `dace.vector` arrays, `Dot` → `FPGA_Accumulate` (int64 needs no partial sums) |
| axpy | fusion (`auto_optimize` or `MapFusion`) | `Axpy` node, `fpga` |
| vsum, rowsum | as today (one accumulator) | none in DaCe |
| relu | as today | none unless a NumPy rewrite vectorizes |
| vecadd, vecmul, matadd | as today | as today (`Vectorization` already works) |

The lane forms restate the kernel (`np.sum(A * B)` → `np.dot`, arrays typed as vectors); forge gets W from a recipe step on the unchanged kernel.
