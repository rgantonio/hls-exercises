# Benchmark sizes

Which sizes the bench runs, and the sizes the two benchmark suites define. For now the bench follows snax-forge: the size its recipe runs, then the sizes `docs/HLS_VS_FORGE.md` section 7 adds per tier. Since the size is a run-time pin (section 2 there), a new size costs only Vitis runs, never another hardware point.

## What the bench runs now

| Kernel | Sizes | Where they come from |
|---|---|---|
| `vecadd`, `vecmul` | n64, n512 | forge `recipes/vecadd.json` and `vecmul.json` (N = 64, W = 4); n512 from forge's dot study |
| `vsum` | n64, n512 | forge `recipes/vsum.json` (W = 1) and `vsum_tree.json` (W = 4), N = 64; n512 as above |
| `dot` | n64, n512 | forge `recipes/dot.json` and `dot_serial.json` (N = 64); n512 is forge's dot study (M13 B3) |

`vecadd`, `vecmul`, `vsum`, `dot`, `rowsum`, `matadd`, `relu`, `axpy` and `vdiv` are forge's own kernels. Neither PolyBench nor NPBench has them, so forge's recipes are the only reference.

forge's `make_inputs` defaults are not what its flow runs: 1024 for `vecadd`, `vsum` and `dot`, and 256 × 256 for `atax`, `bicg` and `mvt`. Their `sweep_sizes` go from 128 to 512 for the mat-vecs. The flow runs the recipe's size.

## PolyBench/C 4.2.1

From each kernel's `<kernel>.h` (`MINI_DATASET` to `EXTRALARGE_DATASET`).

| Kernel | MINI | SMALL | MEDIUM | LARGE | EXTRALARGE |
|---|---|---|---|---|---|
| `atax`, `bicg` (M, N) | 38, 42 | 116, 124 | 390, 410 | 1900, 2100 | 1800, 2200 |
| `mvt`, `gemver` (N) | 40 | 120 | 400 | 2000 | 4000 |
| `gesummv` (N) | 30 | 90 | 250 | 1300 | 2800 |
| `covariance` (M, N) | 28, 32 | 80, 100 | 240, 260 | 1200, 1400 | 2600, 3000 |
| `gemm` (NI, NJ, NK) | 20, 25, 30 | 60, 70, 80 | 200, 220, 240 | 1000, 1100, 1200 | 2000, 2300, 2600 |
| `2mm` (NI, NJ, NK, NL) | 16, 18, 22, 24 | 40, 50, 70, 80 | 180, 190, 210, 220 | 800, 900, 1100, 1200 | 1600, 1800, 2200, 2400 |
| `3mm` (NI, NJ, NK, NL, NM) | 16, 18, 20, 22, 24 | 40, 50, 60, 70, 80 | 180, 190, 200, 210, 220 | 800, 900, 1000, 1100, 1200 | 1600, 1800, 2000, 2200, 2400 |
| `doitgen` (NQ, NR, NP) | 8, 10, 12 | 20, 25, 30 | 40, 50, 60 | 140, 150, 160 | 220, 250, 270 |
| `jacobi-1d` (TSTEPS, N) | 20, 30 | 40, 120 | 100, 400 | 500, 2000 | 1000, 4000 |
| `jacobi-2d` (TSTEPS, N) | 20, 30 | 40, 90 | 100, 250 | 500, 1300 | 1000, 2800 |

## NPBench

From `bench_info/<kernel>.json` (presets S, M, L and the paper's).

| Kernel | S | M | L | paper |
|---|---|---|---|---|
| `atax`, `bicg` (M, N) | 4000, 5000 | 10000, 12500 | 20000, 25000 | 18000, 22000 |
| `mvt` (N) | 5500 | 11000 | 22000 | 16000 |
| `gesummv` (N) | 2000 | 4000 | 14000 | 11200 |
| `gemver` (N) | 1000 | 3000 | 10000 | 8000 |
| `covariance` (M, N) | 500, 600 | 1400, 1800 | 3200, 4000 | 1200, 1400 |
| `gemm` (NI, NJ, NK) | 1000, 1100, 1200 | 2500, 2750, 3000 | 7000, 7500, 8000 | 2000, 2300, 2600 |
| `k2mm` (NI, NJ, NK, NL) | 800, 850, 900, 950 | 2000, 2250, 2500, 2750 | 6000, 6500, 7000, 7500 | 3200, 3600, 4400, 4800 |
| `k3mm` (NI, NJ, NK, NL, NM) | 800, 850, 900, 950, 1000 | 2000, 2200, 2400, 2600, 2800 | 5500, 6000, 6500, 7000, 7500 | 3200, 3600, 4000, 4400, 4800 |
| `doitgen` (NR, NQ, NP) | 60, 60, 128 | 110, 125, 256 | 220, 250, 512 | 220, 250, 270 |
| `jacobi_1d` (TSTEPS, N) | 800, 3200 | 3000, 12000 | 8500, 34000 | 4000, 32000 |
| `jacobi_2d` (TSTEPS, N) | 50, 150 | 80, 350 | 200, 700 | 1000, 2800 |
| `softmax` (N, H, SM) | 16, 16, 128 | 32, 8, 256 | 64, 16, 448 | 64, 16, 512 |

NPBench's presets are sized for CPUs and GPUs. `atax` S is 20 M elements, about 160 MB at int64, so on forge it needs tiling (M15) first. PolyBench MINI and SMALL fit a TCDM and run quickly in cosim; MEDIUM is still fine for cosim.

## To do later

- **Pick the sizes per tier.** Forge's recipe size first, then probably PolyBench MINI and SMALL. Tier A would take forge's default (256 × 256) and MINI and SMALL at no extra synthesis.
- **Update snax-forge** (not now, while M13 is in progress):
  - `kernels/README.md` says the kernels are at PolyBench's MINI sizes, but `make_inputs` defaults to 256 × 256 for `atax`, `bicg` and `mvt` (`gesummv`'s 30 is MINI). Either change the defaults to MINI or fix the sentence.
  - Give the tier A kernels recipe sizes once B4 runs them, and say in `kernels/README.md` which PolyBench or NPBench size each one stands for.
