# hls-exercises

Two things live here:

- **Exercises** (`exercises/`): self-learning steps on how Vitis HLS works and what its optimizations do. [`exercises/README.md`](exercises/README.md) lists them and says how to run them.
- **Bench** (`bench/`): the HLS side of a comparison with [snax-forge](https://github.com/KULeuven-MICAS/snax-forge). The kernels forge builds accelerators for are written here as unoptimized HLS, optimized HLS and DaCe-generated HLS, all with axis (valid-ready) ports as SNAX's units have. Their cycle counts are summarised in `results/`, and the generated Verilog is kept in `rtl/` for synthesis. The plan and the conventions are in [`docs/HLS_VS_FORGE.md`](docs/HLS_VS_FORGE.md).

Tool: Vitis HLS 2023.2.2 on `xcku5p-ffvb676-2-e` (`notes/env.md`). Run everything from the repo root unless a section says otherwise.

## Setup

```bash
source /path/to/Vitis/2023.2/settings64.sh   # puts vitis_hls on the path
vitis_hls -version                           # expect v2023.2.2
```

The bench driver needs Python 3, standard library only. The bench generators need a snax-forge checkout and its pixi environment.

## Exercises

```bash
make list                                   # every exercise
make run EX=s1_model/01_latency_and_ii      # one exercise
make clean                                  # delete all tool output
```

More in [`exercises/README.md`](exercises/README.md).

## Bench

### 1. Generate sources (snax-forge's environment)

Test vectors and the case 3 (DaCe) sources come from forge's own kernel files, so both sides work on the same kernel and the same data. Run these once per new kernel or size, then commit the generated `vectors/`, `dace/` and `bench/gen/dace_include/` files:

```bash
FORGE=/path/to/snax-forge
pixi run --manifest-path $FORGE/pixi.toml python $PWD/bench/gen/gen_data.py --forge $FORGE --kernel vecadd
pixi run --manifest-path $FORGE/pixi.toml python $PWD/bench/gen/gen_dace.py --forge $FORGE --kernel vecadd
```

Both take `--tier T` instead of `--kernel K` for a whole tier.

### 2. Run (Vitis machine)

```bash
python3 bench/bench.py list                                          # every kernel and run point
python3 bench/bench.py run --kernel vecadd --case unopt --dry-run    # print the commands only
python3 bench/bench.py run --kernel vecadd --case unopt              # one case
python3 bench/bench.py run --kernel vecadd                           # every case, size and W
python3 bench/bench.py run --tier done -j$(nproc)                    # a whole tier, one Vitis run per core
python3 bench/bench.py run --tier done --case opt --w 4 --no-cosim   # narrower and faster
```

`make bench ARGS="run --kernel vecadd"` does the same through make.

### 3. Read the results

A run writes three files in `results/` and copies each point's generated Verilog to `rtl/<tier>/<kernel>/<point>/`. These are what gets committed:

| File | What it holds |
|---|---|
| `hls_cycles.csv` | One row per run point: csynth estimate, cosim (RTL) cycles, csim and cosim status, portability check |
| `hls_loops.csv` | One row per loop per point: trips, iteration latency, II achieved and target |
| `report_<tier>.md` | Per kernel, the points side by side with cycles per element, overhead beyond one beat per cycle, timing and the ratio to `unopt`, then the loops |
| `rtl/.../*.v` | Vitis's Verilog for the point, the input to a later synthesis run |

```bash
python3 bench/bench.py report --tier done   # rewrite report_done.md from the CSVs
python3 bench/bench.py collect --tier done  # re-read the projects that still exist into the CSVs
python3 bench/bench.py check                # portability of the generated Verilog
```

The Vitis projects (`<case>_<size>[_w<W>]_c<clock>_proj` in each kernel's folder) and their logs (`run_<project>.log`) are scratch. Git ignores them and `make clean` removes them. To look at one in detail before cleaning:

```bash
cd bench/tier_done/vecadd
PROJ=opt_n64_w4_c3p33_proj TOP=vecadd SOLS=sol OUT=/tmp/lat.md ../../../common/collect_latency.sh
```

To run one point by hand, take the `export` lines that `--dry-run` prints, then:

```bash
cd bench/tier_done/vecadd
vitis_hls -f ../../run_bench.tcl 2>&1 | tee run_manual.log
```

## Layout

```
docs/        HLS_VS_FORGE.md: the plan and conventions of the bench
exercises/   the self-learning steps (s0_flow, s1_model, s2_pipelining)
common/      part.tcl (exercises), asic.tcl (bench), report scripts
notes/       env.md, directive reference, exercise results.csv
bench/       bench.py, run_bench.tcl, gen/, tier_<T>/<kernel>/
results/     bench summaries: hls_cycles.csv, hls_loops.csv, report_<tier>.md
rtl/         Vitis's generated Verilog per bench point
```
