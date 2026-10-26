# Exercises

Self-learning steps on how Vitis HLS schedules code and what its optimizations do. Each folder is one step, with its own `README.md` that walks through the run and what to read in the reports.

| Step | Folder | Topic |
|---|---|---|
| S0.1 | `s0_flow/01_project_anatomy` | What a Vitis HLS project is made of |
| S0.2 | `s0_flow/02_first_compute_unit` | First compute unit (`scale`) and first cosim |
| S0.3 | `s0_flow/03_reading_reports` | Reading the reports (no run) |
| S0.4 | `s0_flow/04_interfaces` | Interfaces and control protocols |
| S1.1 | `s1_model/01_latency_and_ii` | Latency, II and $C = L + I(N-1)$ |
| S1.2 | `s1_model/02_pipeline_blockers` | What blocks pipelining |
| S2.1.1 | `s2_pipelining/01_full_transposition` | Loop swap to reach II = 1 |
| S2.1.2 | `s2_pipelining/02_tiled_accumulation_interleaving` | Tiled accumulation interleaving |
| S2.1.3 | `s2_pipelining/03_single_loop_interleaving` | Single-loop accumulation interleaving |

## Setup

```bash
source /path/to/Vitis/2023.2/settings64.sh   # puts vitis_hls on the path
vitis_hls -version                           # expect v2023.2.2 (notes/env.md)
```

## Running

From the repo root:

```bash
make list                                   # every exercise with a run_hls.tcl
make run EX=s1_model/01_latency_and_ii      # one exercise; log in its run.log
make check EX=s1_model/01_latency_and_ii    # what clean would delete there
make clean EX=s1_model/01_latency_and_ii    # delete its tool output
make clean                                  # delete all tool output in the repo
```

`EX` works with or without the `exercises/` prefix.

Or from the exercise's own folder, which is what the step READMEs show:

```bash
cd exercises/s2_pipelining/01_full_transposition
vitis_hls -f run_hls.tcl 2>&1 | tee run.log
ONLY="noflat_proj" DO_COSIM=0 vitis_hls -f run_hls.tcl 2>&1 | tee run_extras.log   # knobs, where a step has them
```

## Reading the results

The report scripts in `common/` run from inside an exercise folder:

```bash
cd exercises/s2_pipelining/01_full_transposition
PROJ=trans_proj TOP=gemm_trans OUT=lat_trans.md bash ../../../common/collect_latency.sh
PROJ=trans_proj TOP=gemm_trans OUT=res_trans.md bash ../../../common/collect_resources.sh
```

Each step keeps its `lat_*.md` and `res_*.md` next to its README. The numbers worth keeping go by hand into `notes/results.csv`.

## Conventions

- **Settings.** Every `run_hls.tcl` sources `common/part.tcl`: `xcku5p-ffvb676-2-e`, 3.33 ns, and nothing pipelined unless asked (`config_compile -pipeline_loops 0`).
- **Directives.** They live in `directives_<top>_<solution>.tcl`, not as pragmas, so the C code stays the same across solutions (`notes/directives.md`).
- **Loops.** Every loop is labelled, because directives address loops by label.
- **Projects.** They are named `*_proj`, which `make clean` and `.gitignore` both rely on.
