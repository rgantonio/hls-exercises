# hls-exercises

Two things live here:

- **Exercises** (`s0_flow/` to `s2_pipelining/`): self-learning steps on how Vitis HLS works and what its optimizations do. Notes and results are in `notes/`.
- **Bench** (`bench/`): the HLS side of a comparison with [snax-forge](https://github.com/KULeuven-MICAS/snax-forge). The kernels forge builds accelerators for are written here as unoptimized HLS, optimized HLS and DaCe-generated HLS, and their RTL cycle counts go into `results/`. The plan and the conventions are in [`docs/HLS_VS_FORGE.md`](docs/HLS_VS_FORGE.md).

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
make run EX=s1_model/01_latency_and_ii      # one exercise (vitis_hls -f run_hls.tcl)
make check                                  # what clean would delete
make clean                                  # delete all tool output
make clean EX=s1_model/01_latency_and_ii    # one exercise only
```

Each exercise's `README.md` says what to run and what to look at. Results go into `notes/results.csv` by hand.

## Bench

### Generate inputs (snax-forge's environment)

Test vectors come from forge's own kernel files, so both sides compute on the same data. Run this once per new kernel or size, then commit the generated `vectors/` files:

```bash
FORGE=/path/to/snax-forge
pixi run --manifest-path $FORGE/pixi.toml \
    python $PWD/bench/gen/gen_data.py --forge $FORGE --tier done
```

Case 3 sources come from `bench/gen/gen_dace.py` the same way, once it exists (tier done, step D4).

### Run (Vitis machine)

```bash
python3 bench/bench.py list                          # every kernel and run point
python3 bench/bench.py run --kernel vecadd --case unopt --dry-run   # print, don't run
python3 bench/bench.py run --kernel vecadd --case unopt             # one case
python3 bench/bench.py run --tier done                              # a whole tier
python3 bench/bench.py run --tier done --case opt --w 4 --no-cosim  # narrower, faster
python3 bench/bench.py run --tier done -j 4                         # 4 Vitis runs at once
python3 bench/bench.py collect --tier done           # re-read existing projects into the CSV
python3 bench/bench.py check                         # portability of the generated Verilog
```

`make bench ARGS="run --kernel vecadd"` does the same through make.

Each point is one Vitis project inside the kernel's folder: `<case>_<size>[_w<W>]_c<clock>_proj`, plus its log `run_<project>.log`. Results land in `results/hls_cycles.csv`, one row per point. A rerun replaces its row.

To run one point by hand, take the `export` lines that `--dry-run` prints, then:

```bash
cd bench/tier_done/vecadd
vitis_hls -f ../../run_bench.tcl 2>&1 | tee run_manual.log
```

The exercises' latency script also works on a bench project:

```bash
cd bench/tier_done/vecadd
PROJ=opt_n64_w4_c3p33_proj TOP=vecadd SOLS=sol OUT=lat_opt.md ../../../common/collect_latency.sh
```

### Clean

`make clean` also removes the bench projects and logs (`*_proj`, `run_*.log`). Generated sources (`vectors/`, `dace/`) and `results/` are tracked and stay.

## Layout

```
common/      part.tcl (exercises), asic.tcl (bench), report scripts
notes/       exercise notes, directive reference, results.csv
s*_*/        exercises
bench/       bench.py, run_bench.tcl, gen/, tier_<T>/<kernel>/
results/     hls_cycles.csv and, later, forge and synthesis results
docs/        HLS_VS_FORGE.md
```
