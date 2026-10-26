# HLS against snax-forge

This repo started as self-learning exercises (`exercises/`, see its README). The `bench/` part turns it into the HLS side of a comparison with [snax-forge](https://github.com/KULeuven-MICAS/snax-forge). The kernels snax-forge builds accelerators for are written here as HLS, in three ways, and their cycle counts are kept next to forge's.

This file is the plan and the conventions. `README.md` has the commands.

Tool: Vitis HLS 2023.2.2 (`notes/env.md`). DaCe: 1.0.2, the version snax-forge pins.

---

## 1. What is compared

Every kernel is built in three cases.

| Case | Name in files | What it is |
|---|---|---|
| 1 | `unopt` | C++ that keeps NPBench's loop structure, with no directives. `common/asic.tcl` turns off what Vitis would add by itself (`pipeline_loops 0`, no automatic partitioning). |
| 2 | `opt` | The same kernel tuned to forge's design point: pipeline at II = 1, arrays partitioned cyclic by W, loops unrolled by W. The C++ changes only where II = 1 needs it (e.g. `atax`'s transposed pass, as in S2.1.1). |
| 3 | `dace` | The kernel's SDFG sent through DaCe's FPGA backend (`FPGATransformSDFG`, the FPGA passes, FPGA expansions of library nodes). Only the code is generated; v++ is never called. |

**Cycles first.** Each run point records the csynth estimate (latency min and max, II) and the cosim latency, which is the RTL cycle count. Area and fmax come later, from synthesis of the same Verilog (section 6).

**The forge side.** Forge's number is its accelerator window, the `forge counter`, on SNAX-GVSoC and on snax_cluster's RTL (forge `docs/ARCHITECTURE.md` §7, `docs/RUN.md` §8). It goes into `results/forge_cycles.csv`, copied from forge's runs until forge has an export command.

---

## 2. Ground rules

These keep the two sides comparable. Where a difference can't be removed, it is written down next to the data.

**Same kernels.** Forge's kernel files (`kernels/<group>/<kernel>.py`) are the source. The HLS C++ follows their NumPy body, at `int64` through tier C and `int8` in with `int32` accumulate from tier P (forge D113).

**Same sizes.** The first size of every kernel is the one forge's recipe runs (`recipes/<kernel>.json`). After that come the sizes the plan sets per tier (section 7). Sizes and W are compile-time constants (`-DSIZE_N=64 -DW=4`).

**Same data.** `bench/gen/gen_data.py` runs in forge's pixi environment. It calls each kernel's `make_inputs` with a fixed seed and forge's reference, and writes `vectors/<size>/data.h`. The testbench checks every output exactly.

**Same block boundary.**
- Memory stays outside the block. Every array is a top-level `ap_memory` port, and nothing large is stored inside. Forge's accelerators also leave memory and streamers outside (forge D112).
- In `opt`, an array partitioned cyclic by W becomes W ports, one per bank. That matches forge's W one-bank streamer ports (forge open item 20).
- Control is `ap_ctrl_hs` and scalars are `ap_none`. No AXI.

**Known differences.** These are kept, not removed:
- HLS ports read SRAM with a latency of 1 cycle. Forge reads the TCDM through streamers.
- The HLS block makes its own addresses from its loop counters, so it contains what forge's streamers do. When area is compared, forge's streamer cost for the kernel is added or shown as its own line.
- HLS has no CSR file, because its arguments are ports. Forge's CSR module is shown apart (forge's split into control, CSR and datapath modules).

**Same arithmetic.** Multipliers go in fabric. There is no DSP on either side, in Vivado or in DC.

---

## 3. Vitis settings for portable RTL

### 3.1 `common/asic.tcl`

`bench/run_bench.tcl` sources this file instead of `common/part.tcl`, so the exercises keep their numbers.

| Setting | Why |
|---|---|
| `set_part xcku5p-ffvb676-2-e` | Same part as the exercises. Vitis needs one to schedule. |
| `create_clock -period $CLOCK_NS` | Default 3.33 ns. It is a knob (section 3.3). |
| `config_compile -pipeline_loops 0` | Nothing is pipelined unless a case asks for it (env.md, probe D). |
| `config_array_partition -complete_threshold 0` | No automatic partitioning of small arrays. |
| `config_op mul -impl fabric` | Plain `*` with pipeline registers in the Verilog, no DSP48. |

### 3.2 What stays portable

For integer kernels, the Verilog in `<proj>/sol/syn/verilog/` is plain RTL once these settings are in:

| Item | In the Verilog | Portable? |
|---|---|---|
| Integer add, mul, compare | Behavioural modules | Yes |
| Integer divide (tier B) | Generated divider module | Yes |
| Float operators | Xilinx floating-point IP | No. Floats are a later pass anyway (D113). They will need `ap_fixed`, hand-written units or another tool. |
| Internal arrays | `RAM_AUTO` behavioural modules with Xilinx attributes | They synthesise, but as flip-flops. Keep them small or as ports. |
| `ap_ctrl_hs`, `ap_memory` | Plain handshake and SRAM ports | Yes |

`bench.py` checks every run's Verilog for DSP48, XPM macros, floating-point IP, `use_dsp="yes"` and `*_ip.tcl` files. The result goes in the `portable` column; `bench.py check` re-runs the check on demand.

### 3.3 The clock

Vitis chains operations using the FPGA's delays, so a cycle count belongs to the clock period it was scheduled at. Each point records its clock (`clock_ns`), and the default runs use 3.33 ns. One tighter period per tier shows how much the count moves.

Synthesis in DC (section 6) then says whether that RTL closes at the ASIC clock. Run time is

$$t = C \cdot T_{\text{clk}}$$

so it is reported per target, not per HLS run.

---

## 4. The cases in detail

### 4.1 `unopt`

- The C++ keeps NPBench's loops, every loop labelled (repo convention).
- There is no `directives_unopt.tcl`, so the run is `common/asic.tcl` alone.
- Not per W: one run per size.

### 4.2 `opt`

- Directives live in `directives_opt.tcl`, written with `$W`. `run_bench.tcl` sets `W` before sourcing the file, so one file covers every W:

  ```tcl
  set_directive_array_partition -type cyclic -factor $W -dim 1 "vecadd" A
  set_directive_pipeline -II 1 "vecadd/ADD"
  set_directive_unroll -factor $W "vecadd/ADD"
  ```

- One run per W in `params.json`.
- When II = 1 needs a code change, the kernel gets `src/<kernel>_opt.cpp`, and its `README.md` says why.

### 4.3 `dace`

`bench/gen/gen_dace.py` runs in forge's environment. It builds forge's own SDFG (`snax_forge.sdfg.build`), specializes it to the size, applies `FPGATransformSDFG`, and writes `dace/<size>/` per kernel. Here is what comes out on DaCe 1.0.2:

- **The device file is plain Vitis C++ with pragmas in it.** Every map already has `PIPELINE II=1` and `LOOP_FLATTEN`. So `asic.tcl`'s `pipeline_loops 0` doesn't matter for this case; what DaCe chose is what runs.
- **DaCe's entry function is a DATAFLOW region over raw pointers,** with `m_axi` and `s_axilite` pragmas and hlslib macros. Its device file is kept unchanged as `dace/<size>/<kernel>_0_0.cpp`, and that entry function is left unused.
- **The generator writes a small top, `dace/<size>/<kernel>_dace.cpp`.** It has the same arguments as the hand-written top in `src/<kernel>.h`, so the ports (`ap_memory`) and the testbench are the same as in cases 1 and 2, and it calls DaCe's `module_<kernel>_0_0` function directly.
- **Includes and flags.** The device file includes `<dace/fpga_device.h>`. So the generator copies DaCe's runtime headers and hlslib into `bench/gen/dace_include/`, and the Vitis machine needs no DaCe install. The case compiles with DaCe's own synthesis flags: `-std=c++14 -DDACE_SYNTHESIS -DDACE_XILINX -DDACE_XILINX_DEVICE_CODE -DHLSLIB_SYNTHESIS`.
- **Library nodes** (tier A) expand into loops. `atax`'s transpose is written out to a transient, which DaCe treats as global memory. For now the generated top keeps every transient as a local array inside the block. Tier A decides whether transients become ports instead, which is closer to forge chaining accelerators through L1 (forge D105). `MatMul` expands to `Gemv` first, so an FPGA implementation of `Gemv` (`FPGA_Accumulate`, `FPGA_TilesByColumn`) has to be chosen after that first expansion step.
- **Choices are recorded.** `gen_dace.py` reads the passes and expansions from `params.json` (a `dace` key) and writes them into the generated file's header comment, so every row traces back to what made it.

If DaCe can't take a kernel through, that is a row with its `status` and the error, as forge's coverage table does (FE2).

---

## 5. File organization

```
hls-exercises/
  README.md                      what to run by hand
  Makefile                       exercises: make run/clean; bench: make bench ARGS="..."
  docs/
    HLS_VS_FORGE.md              this file
  exercises/                     the self-learning steps s0_ to s2_, with their README
  common/
    part.tcl                     exercises only (unchanged)
    asic.tcl                     bench runs (section 3.1)
    collect_latency.sh           unchanged, also works on bench projects
    collect_resources.sh         unchanged
  notes/                         env.md, directive reference, exercise results.csv
  results/                       the only bench output that is kept (5.2)
    hls_cycles.csv               one row per run point
    hls_loops.csv                one row per loop per run point
    report_<tier>.md             tables from the CSVs, rewritten by bench.py
    forge_cycles.csv             forge's counters, same keys (kernel, size, W)
    synth_vivado.csv             section 6, later
    synth_dc.csv                 section 6, later
  bench/
    bench.py                     the driver: list, run, collect, check, report
    run_bench.tcl                one Vitis run, everything from the environment
    gen/
      gen_data.py                vectors from forge's kernels (forge's env)
      gen_dace.py                case 3 sources (forge's env)
      dace_include/              DaCe runtime headers and hlslib, copied by gen_dace.py
    tier_done/
      vecadd/
        params.json              what to run (5.1)
        README.md                what each case does and what the run showed
        src/
          vecadd.h               declarations, sizes from -DSIZE_N, #error without DATA_T
          vecadd.cpp             top for unopt and opt
          vecadd_opt.cpp         only when opt needs other code
          tb_vecadd.cpp          testbench, checks against data.h, calls DUT
        directives_opt.tcl       uses $W
        vectors/n64/data.h       generated by gen_data.py, committed
        dace/n64/vecadd_0_0.cpp  DaCe's device file, generated, committed
        dace/n64/vecadd_dace.cpp top for case 3, generated, committed
        opt_n64_w4_c3p33_proj/   Vitis project (ignored by git, removed by make clean)
        run_opt_n64_w4_c3p33_proj.log
      vecmul/ vsum/ dot/
    tier_a/
      atax/ bicg/ mvt/ gesummv/
    tier_untiered/
      matadd/ relu/ rowsum/ axpy/ vdiv/
```

**Naming.** Projects are `<case>_<size>[_w<W>]_c<clock>_proj`, each with one solution `sol`. That deviates from the exercises' many-solutions-per-project layout, because `open_project -reset` wipes every solution, and here every point is independent. Each project holds a `point.json` that says what the point was, so `bench.py collect` can rebuild the CSV from the folders.

Directives files are named `directives_<case>.tcl`, not `directives_<top>_<solution>.tcl`. The top is fixed per kernel, and the case is the solution.

The testbench gets `-DDUT=<top>`, so one testbench serves every case.

### 5.1 `params.json`

```json
{
  "kernel": "vecadd",
  "tier": "done",
  "forge_kernel": "polybench/vecadd",
  "forge_recipe": "recipes/vecadd.json",
  "dtype": "int64",
  "seed": 0,
  "sizes": [{"n": 64}, {"n": 512}],
  "W": [4, 8],
  "tb": "src/tb_vecadd.cpp",
  "cases": {
    "unopt": {"top": "vecadd", "src": ["src/vecadd.cpp"]},
    "opt":   {"top": "vecadd", "src": ["src/vecadd.cpp"], "per_w": true},
    "dace":  {"top": "vecadd_dace",
              "src": ["dace/{size}/vecadd_dace.cpp", "dace/{size}/vecadd_0_0.cpp"],
              "cflags": ["-std=c++14", "-DDACE_SYNTHESIS", "-DDACE_XILINX", "-DDACE_XILINX_DEVICE_CODE",
                         "-DHLSLIB_SYNTHESIS", "-I{bench}/gen/dace_include"]}
  },
  "dace": {"passes": [], "expansions": {}}
}
```

- Size keys are `make_inputs`'s argument names (`n`, `m`). They give the tag (`n64`, `m38_n42`) and the macros (`SIZE_N`, `SIZE_M`).
- `{size}`, `{W}` and `{bench}` (the absolute path of `bench/`) in paths and `cflags` are filled per point. Every path that reaches Vitis is absolute, because cosim compiles from inside the project.
- Optional keys: `acc_dtype` (tier P, gives `ACC_T`), `clock_ns` (default 3.33), and per case `tb`, `cflags` or `directives` to override the defaults.
- The top-level `dace` key is read by `gen_dace.py` only: `passes` names functions of `dace.transformation.auto.fpga` to apply, and `expansions` maps a library node type to its implementation (for example `{"Gemv": "FPGA_Accumulate"}`).

### 5.2 What is kept: `results/`

The Vitis projects, logs and Verilog are scratch: git ignores them and `make clean` removes them. Only summaries are committed. That keeps the repo small and diffable, and `bench.py collect` can always rebuild them from projects that still exist.

- `hls_cycles.csv`: one row per point.
- `hls_loops.csv`: one row per loop per point (module, loop, trips, iteration latency, II achieved and target, pipelined). This is enough to explain a cycle count without the reports.
- `report_<tier>.md`: per kernel, a table of the points with cycles, cycles per element and the ratio to `unopt`, then the loop table, then forge's rows from `forge_cycles.csv` when there are any. `run` and `collect` rewrite it, and `bench.py report` rewrites it on demand.

Both CSVs are keyed by `tier, kernel, case, size, W, clock_ns`; a rerun replaces its rows. The columns of `hls_cycles.csv`:

| Columns | Meaning |
|---|---|
| `status` | `ok`, or `failed: csim / cosim / no csynth report` |
| `csim_errors` | From the log |
| `clock_est_ns` | Vitis's estimate for the top |
| `lat_min`, `lat_max`, `ii_min`, `ii_max`, `pipeline` | csynth estimate for the top |
| `cosim_status`, `cosim_lat_min/avg/max` | RTL cycles from cosim (Verilog) |
| `LUT`, `FF`, `DSP`, `BRAM_18K` | csynth estimates. Only a sanity check here (DSP and BRAM should be 0). |
| `portable` | `yes`, or what was found (section 3.2) |
| `vitis`, `git`, `date`, `proj` | Where the row came from |

---

## 6. Synthesis (per tier, after its cycles)

The same Verilog from both sides goes through the same two flows. Both flows run with hierarchy kept, so control, CSR and datapath can be read apart.

| Flow | HLS side | Forge side | Settings |
|---|---|---|---|
| Vivado, out of context | `<proj>/sol/syn/verilog/*.v` (not `export_design`, which runs its own flow) | `out/rtl/<kernel>/sv/*.sv` from forge's `gen-rtl` | `synth_design -mode out_of_context -flatten_hierarchy none -max_dsp 0`, same part and clock |
| DC, TSMC 16 nm | Same files | Same files | Your scripts, same clock per comparison |

Both report area (LUT and FF, or µm²), timing slack, and fmax where it closes. `bench.py synth` and the two CSVs are added in the first tier that gets here.

This extends forge PAPER E7 (one unit in Chisel against Vitis HLS at equal II and clock) to the kernel set, and adds the FPGA view.

---

## 7. Tiers

Each tier runs the same steps, and each step ends with what changed and the rows it produced, so the plan can change between steps.

1. **Sources.** `params.json`, the C++, the testbench, `directives_opt.tcl`, and vectors from `gen_data.py`.
2. **`unopt`.** Run, check, fill the kernel README's table.
3. **`opt`.** Run per W, check II = 1 on the loops that should have it.
4. **`dace`.** Generate, wrap, run.
5. **Compare.** Add forge's counters to `results/forge_cycles.csv` and write the tier's table: cycles per case against forge's, with the known differences.
6. **Synthesis.** Section 6, both sides.

### H0 — setup and the first run (`vecadd`)

The scripts and `vecadd` are in place for all three cases: sources, vectors from `gen_data.py`, and DaCe sources from `gen_dace.py`. Outside Vitis, a g++ build of the testbench passes for `unopt` and `dace` on forge's vectors. The first Vitis run checks the rest:

- `config_op mul -impl fabric` and `config_array_partition -complete_threshold 0` are accepted on 2023.2.2.
- Array partitioning on top-level `ap_memory` arguments gives W ports.
- Vitis takes DaCe's unused entry function (interface pragmas on a non-top function).
- The report parsing fills every column, and `report_done.md` reads well.

### Tier done — `vecadd`, `vecmul`, `vsum`, `dot`

| Kernel | Sizes | W (`opt`) | Notes |
|---|---|---|---|
| `vecadd` | n64 (recipe), n512 | 4, 8 | The pipe-cleaner for every step |
| `vecmul` | n64, n512 | 4, 8 | First fabric multiplier: check `DSP = 0` |
| `vsum` | n64, n512 | 1, 4, 8 | W = 1 is the `vsum` recipe, W = 4 is `vsum_tree`. `opt` gives W partial sums and a final add. |
| `dot` | n64 (recipe), n512 | 4, 8 | Forge's dot study runs N = 512 at W = 4 and 8. Forge's dot variants (vmul + vsum through L1, FIFO link, MAC lanes) are the forge-side rows of this one HLS kernel. |


### Tier A — `atax`, `bicg`, `mvt`, `gesummv`

| Kernel | Sizes | What `opt` needs |
|---|---|---|
| `atax` | m38_n42 (MINI) | The second product reads $A^T$: reorder so the row-wise pass accumulates into `y` (S2.1.1's swap) |
| `bicg` | m38_n42 | One pass over $A$ feeds both `q` and `s` |
| `mvt` | m40_n40 | One product row-wise, one column-wise; the column-wise one needs the same swap as `atax` |
| `gesummv` | n30 | Both products share `x`: one pass, two accumulators |

Forge's size for tier A is added as the first size once forge runs tier A. In case 3 the library-node expansions are where the choices are (section 4.3).

### Untiered — `matadd`, `relu`, `rowsum`, `axpy`, `vdiv`

These are added as forge picks them up. `vdiv` is the first divider, so it checks that the divider module stays portable (section 3.2).

### Later tiers

B (divider unit, `covariance`'s mean), C (`covariance`, `softmax`), P (int8 in, int32 out: `acc_dtype`), D (`gemm`, `k2mm`, `k3mm`, `doitgen`, `gemver`, `jacobi`). These follow forge's order (forge `docs/ARCHITECTURE.md` §8).

---

## 8. Working with Claude Code

The loop is the same as in the snax-forge work:

1. The plan and the code are made in the chat and pushed here (sources, `params.json`, generated vectors and DaCe files).
2. The chat gives a prompt for Claude Code on the machine with Vitis.
3. Claude Code runs the bench, commits `results/` and kernel README updates, and pushes.
4. The report (`results/report_<tier>.md`) and any failures go back to the chat, which plans the next step.

Claude Code runs and reports; it does not redesign kernels or directives on its own. When a run fails, it reports the error lines from the log and stops, unless the prompt says what to fix.

- **Start.** Every prompt starts with `git pull` in hls-exercises (and in snax-forge when vectors or DaCe sources are generated).
- **Environments.** The Vitis side needs `vitis_hls` on the path (Vitis's `settings64.sh`) and Python 3, standard library only. The generators need snax-forge's pixi environment:

  ```bash
  FORGE=/path/to/snax-forge
  pixi run --manifest-path $FORGE/pixi.toml python $PWD/bench/gen/gen_data.py --forge $FORGE --tier done
  ```

- **Order of runs.** One kernel and one case first with `--dry-run`, then for real, then the rest of the tier. Use `-j N` only once a single run is known to work.
- **What counts as done.** Every row has `status ok` and `portable yes`, or the kernel README says why not.
- **Hands off.** `common/part.tcl` and `exercises/` are never changed by bench work.
- **Commits.** Short, one line per step, no co-author trailer.

---

## 9. Links to snax-forge decisions

| Forge item | Here |
|---|---|
| D113 (NPBench structure, dtype as a parameter, integers first, MINI and SMALL) | Followed: same kernel files, `dtype` in `params.json`, `int64` first |
| D112 (streamers outside the accelerator) | Memory outside the HLS block. Address generation inside it is a known difference (section 2). |
| D105 (accelerators chain through L1) | DaCe's transients as extra memory ports are the HLS counterpart (section 4.3) |
| D123, GEN2b (forge counter on SNAX-GVSoC and RTL) | The forge numbers this compares against |
| PAPER E7, E8 | Section 6 extends E7. E8 (an HLS engine as a BRM) stays in forge. |
| Open items 27, 28 (HLS sources as BRM implementations) | Untouched. Nothing here goes into forge. |
