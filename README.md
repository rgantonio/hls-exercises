# hls-exercises

Two things live here:

- **Exercises** (`exercises/`): self-learning steps on how Vitis HLS works and what its optimizations do. [`exercises/README.md`](exercises/README.md) lists them and says how to run them.
- **Bench** (`bench/`): the HLS side of a comparison with [snax-forge](https://github.com/KULeuven-MICAS/snax-forge). The kernels forge builds accelerators for are written here as unoptimized HLS, optimized HLS and DaCe-generated HLS, all with axis (valid-ready) ports as SNAX's units have. Their cycle counts are summarised in `snax-forge-experiments/results/hls/`, and the generated Verilog is kept in `rtl/` for synthesis. The plan and the conventions are in [`docs/HLS_VS_FORGE.md`](docs/HLS_VS_FORGE.md), the sizes in [`docs/SIZES.md`](docs/SIZES.md) and the lane sweep in [`notes/w_sweep.md`](notes/w_sweep.md).

Tool: Vitis HLS 2023.2.2 on `xcku5p-ffvb676-2-e` (`notes/env.md`). Run everything from the repo root unless a section says otherwise.

## Setup

```bash
source /path/to/Vitis/2023.2/settings64.sh   # puts vitis_hls on the path
vitis_hls -version                           # expect v2023.2.2
```

The bench driver needs Python 3.7 or newer, standard library only. Where `python3` is older (3.6 on the ESAT servers), run it with `python3.11`. The bench generators need a snax-forge checkout and its pixi environment.

The bench's summaries and the synthesis flow live in [snax-forge-experiments](https://github.com/KULeuven-MICAS/snax-forge-experiments), checked out next to this repo. `bench.py` writes into its `results/hls/` (`HLS_RESULTS` points elsewhere):

```
<parent>/
  hls-exercises/            this repo: bench/ and rtl/
  snax-forge-experiments/   results/hls/ (the summaries) and syn/ (synthesis of rtl/)
```

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

A run writes three files in `snax-forge-experiments/results/hls/` and puts the generated Verilog in this repo's `rtl/<tier>/<kernel>/<case>_w<W>/`, one folder per hardware point: the size is a run-time pin (`loop_count`, and `len` for reductions), so every size runs on the same Verilog, and `bench.py` checks that it is the same. These are what gets committed, the Verilog here and the rest in snax-forge-experiments:

| File | What it holds |
|---|---|
| `hls_cycles.csv` | One row per run point: csynth estimate, cosim (RTL) cycles, csim and cosim status, portability check |
| `hls_loops.csv` | One row per loop per point: trips, iteration latency, II achieved and target |
| `report_<tier>.md` | Per kernel, the points side by side with cycles per element, overhead beyond one beat per cycle, timing and the ratio to `unopt`, then the loops |
| `rtl/.../*.v` | Vitis's Verilog per hardware point, with `filelist.f` and `sizes.txt`, the input to synthesis |
| `synth_dc.csv` | Written by snax-forge-experiments' `syn/syn.py`: area, timing and power per hardware point |
| `runs/<date>_<tier>.md` | Claude Code's note of a bench run: commands, versions, failures with their log lines |

```bash
python3 bench/bench.py report --tier done   # rewrite report_done.md from the CSVs
python3 bench/bench.py collect --tier done  # re-read the projects that still exist into the CSVs
python3 bench/bench.py check                # portability of the generated Verilog
```

The Vitis projects (`<case>_<size>_w<W>_proj` in each kernel's folder) and their logs (`run_<project>.log`) are scratch. Git ignores them and `make clean` removes them. To look at one in detail before cleaning:

```bash
cd bench/tier_done/vecadd
PROJ=opt_n64_w4_proj TOP=vecadd SOLS=sol OUT=/tmp/lat.md ../../../common/collect_latency.sh
```

To run one point by hand, take the `export` lines that `--dry-run` prints, then:

```bash
cd bench/tier_done/vecadd
vitis_hls -f ../../run_bench.tcl 2>&1 | tee run_manual.log
```

## Synthesis

ASIC synthesis of the hardware points in `rtl/` moved to snax-forge-experiments, which reads this repo's `rtl/<point>/filelist.f` from the checkout next to it. Run it from that repo's root:

```bash
cd ../snax-forge-experiments
python3 syn/syn.py run done/vecadd/opt_w8            # one hardware point, 10 ns
python3 syn/syn.py run 'done/*/*' -j 2               # a whole tier, 2 DC runs at once
python3 syn/syn.py summary                           # area, slack, power of every run
```

More in its `syn/README.md`.

## Layout

```
docs/        HLS_VS_FORGE.md: the plan and conventions of the bench; SIZES.md: sizes
exercises/   the self-learning steps (s0_flow, s1_model, s2_pipelining)
common/      part.tcl (exercises), asic.tcl (bench), report scripts
notes/       env.md, directive reference, exercise results.csv
bench/       bench.py, run_bench.tcl, gen/, tier_<T>/<kernel>/
rtl/         Vitis's generated Verilog per hardware point, with a filelist.f and sizes.txt each
             (the summaries and synthesis are in snax-forge-experiments)
```
