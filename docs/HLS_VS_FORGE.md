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
| 2 | `opt` | The same kernel tuned to forge's design point: the beat loop pipelined at II = 1 and the W lanes of a beat unrolled. The C++ changes only where II = 1 needs it (e.g. `atax`'s transposed pass, as in S2.1.1). |
| 3 | `dace` | The kernel's SDFG sent through DaCe's FPGA backend (`Vectorization` at W where DaCe can, `FPGATransformSDFG`, the FPGA passes, FPGA expansions of library nodes). Only the code is generated; v++ is never called. |

All three cases have the same ports: **axis**, the valid-ready interface of SNAX's units (section 2).

**Cycles first.** Each run point records the csynth estimate (latency min and max, II) and the cosim latency, which is the RTL cycle count. Area and fmax come later, from synthesis of the same Verilog (section 6).

**The forge side.** Forge's number is its accelerator window, the `forge counter`, on SNAX-GVSoC and on snax_cluster's RTL (forge `docs/ARCHITECTURE.md` §7, `docs/RUN.md` §8). It goes into `results/forge_cycles.csv`, copied from forge's runs until forge has an export command.

---

## 2. Ground rules

These keep the two sides comparable. Where a difference can't be removed, it is written down next to the data.

**Same kernels.** Forge's kernel files (`kernels/<group>/<kernel>.py`) are the source. The HLS C++ follows their NumPy body, at `int64` through tier C and `int8` in with `int32` accumulate from tier P (forge D113).

**Same sizes.** The first size of every kernel is the one forge's recipe runs (`recipes/<kernel>.json`). After that come the sizes the plan sets per tier (section 7). Sizes and W are compile-time constants (`-DSIZE_N=64 -DW=4`).

**Same data.** `bench/gen/gen_data.py` runs in forge's pixi environment. It calls each kernel's `make_inputs` with a fixed seed and forge's reference, and writes `vectors/<size>/data.h`. The testbench checks every output exactly.

**Same block boundary: axis ports.**
- Forge's units take their data as `Decoupled(Vec(lanes, UInt(64)))`: one valid-ready handshake around all W lanes, with the streamers outside the unit (forge D112). The HLS tops match that. Every array argument is one AXI4-Stream port (`TDATA`, `TVALID`, `TREADY`) whose `TDATA` holds one beat of W lanes, W × 64 bits with lane 0 in the low bits.
- A beat is `vec_t` from `bench/include/lanes.h`. It is DaCe's own `dace::vec<T, W>`: `T` itself at W = 1, `hlslib::DataPack<T, W>` (one `ap_uint<64W>`) above. So case 3's generated module takes exactly the type cases 1 and 2 use.
- A reduction's result is a one-beat axis port of one element (`out[1]`), as forge's accumulator has `Decoupled(UInt)`.
- `params.json` lists the axis ports, and `run_bench.tcl` sets them with `set_directive_interface -mode axis` for every case. Axis on an array argument needs every element read or written once, in order, which the tier done kernels do.
- The testbench plays the streamer: it packs forge's inputs into beats, and cosim drives the streams with no stalls.
- Control is `ap_ctrl_hs` (start, done, idle, ready). There are no CSRs and no AXI memory-mapped ports.

**Known differences.** These are kept, not removed:
- HLS has no CSR file. Its latency runs from `ap_start` to `ap_done`. Forge's per-task counter (for example `add_acc`) also leaves the CSR programming out, so the two are compared. Forge's whole-program window (`forge cycles`) is not. Forge's CSR module is shown apart in area (its split into control, CSR and datapath modules).
- Cosim feeds a beat every cycle. Forge's streamers feed from the TCDM, so their start-up and any bank conflicts land in forge's counter. The `overhead` column (cycles minus beats) shows that cost on both sides.

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
| `ap_ctrl_hs`, `axis` | Plain handshake and valid-ready ports | Yes |

`bench.py` checks every run's Verilog for DSP48, XPM macros, floating-point IP, `use_dsp="yes"` and `*_ip.tcl` files. The result goes in the `portable` column; `bench.py check` re-runs the check on demand.

### 3.3 The clock

Vitis chains operations using the FPGA's delays, so a cycle count belongs to the clock period it was scheduled at. Each point records its clock (`clock_ns`), and the default runs use 3.33 ns. One tighter period per tier shows how much the count moves.

The `timing` column applies Vitis's own rule (HLS 200-871): the estimate has to fit in the target minus the clock uncertainty. In the first `ap_memory` run, the 64-bit fabric multiplier (`vecmul`, `dot`) was estimated at 3.648 ns against a budget of 2.43 ns. So those cycle counts come from a schedule that does not close on the FPGA, although a 64-bit multiplier at 300 MHz is easy on TSMC 16 nm. Whether the FPGA view should force a deeper multiplier (`config_op mul -impl fabric -latency N`) is open.

Synthesis in DC (section 6) then says whether that RTL closes at the ASIC clock. Run time is

$$t = C \cdot T_{\text{clk}}$$

so it is reported per target, not per HLS run.

---

## 4. The cases in detail

### 4.1 `unopt`

- The C++ keeps NPBench's loops, every loop labelled (repo convention). With W-lane beats, an elementwise loop or a sum is two loops: `BEAT` over the beats and `LANE` over the W lanes of one beat.
- There is no `directives_unopt.tcl`, so the run is `common/asic.tcl` alone, and the lanes of a beat run one after the other.
- One run per W, because W sets the ports.

### 4.2 `opt`

- Directives live in `directives_opt.tcl`. One file covers every W, because the lane loop's trip count comes from the source:

  ```tcl
  set_directive_pipeline -II 1 "vecadd/BEAT"
  set_directive_unroll "vecadd/LANE"
  ```

- One run per W in `params.json`. W = 1 is a plain pipelined loop (forge's accumulator for `vsum`).
- A file can still read `$W`, which `run_bench.tcl` sets before sourcing it.
- When II = 1 needs a code change, the kernel gets `src/<kernel>_opt.cpp`, and its `README.md` says why.

### 4.3 `dace`

`bench/gen/gen_dace.py` runs in forge's environment. It builds forge's own SDFG (`snax_forge.sdfg.build`) and specializes it to the size. At W > 1 it applies DaCe's `Vectorization` with `vector_len` W. Then it applies `FPGATransformSDFG` and writes `dace/<size>_w<W>/` per kernel. Here is what comes out on DaCe 1.0.2:

- **Vectorization works on the elementwise kernels** (`vecadd`, `vecmul`): the arrays become `dace::vec<int64_t, W>` words and the loop runs one word per cycle. It needs `preamble=False` and `postamble=False`; otherwise DaCe adds a remainder step that reads one word past the end, even when W divides N.
- **It does not work on reductions.** On `vsum` it fails with a `KeyError`, and on `dot` it doesn't finish. So their `dace` case runs at W = 1 only (`"W": [1]` in the case), which is what DaCe gives without hand work.

- **The device file is plain Vitis C++ with pragmas in it.** Every map already has `PIPELINE II=1` and `LOOP_FLATTEN`. So `asic.tcl`'s `pipeline_loops 0` doesn't matter for this case; what DaCe chose is what runs.
- **DaCe's entry function is a DATAFLOW region over raw pointers,** with `m_axi` and `s_axilite` pragmas and hlslib macros. Its device file is kept unchanged as `dace/<size>_w<W>/<kernel>_0_0.cpp`, and that entry function is left unused.
- **The generator writes a small top, `dace/<size>_w<W>/<kernel>_dace.cpp`.** It has the same arguments as the hand-written top in `src/<kernel>.h`, so the ports (axis) and the testbench are the same as in cases 1 and 2, and it calls DaCe's `module_<kernel>_0_0` function directly.
- **Includes and flags.** The device file includes `<dace/fpga_device.h>`. So the generator copies DaCe's runtime headers and hlslib into `bench/gen/dace_include/`, and the Vitis machine needs no DaCe install. The case compiles with DaCe's own synthesis flags: `-DDACE_SYNTHESIS -DDACE_XILINX -DDACE_XILINX_DEVICE_CODE -DHLSLIB_SYNTHESIS`. Every case includes `bench/gen/dace_include/` anyway, for `vec_t`.
- **Reductions** (`vsum`, `dot`). `np.sum` becomes a loop at II = 1 that writes through DaCe's write-conflict resolution into a scalar transient, which DaCe's module takes by value. DaCe's `dot` is two loops: `A * B` into a transient array of N, then the sum over it, which is forge's "vmul then vsum through L1" inside one block.
- **Transients in the generated top.** A scalar is a local variable. An array is a local static array, so it is a RAM inside the block.
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
  results/                       the bench summaries that are kept (5.2)
    hls_cycles.csv               one row per run point
    hls_loops.csv                one row per loop per run point
    report_<tier>.md             tables from the CSVs, rewritten by bench.py
    forge_cycles.csv             forge's counters, same keys (kernel, size, W)
    synth_vivado.csv             section 6, later
    synth_dc.csv                 section 6, later
  rtl/                           Vitis's generated Verilog per point, kept for synthesis (5.2)
    done/vecadd/opt_n64_w4_c3p33/*.v
  bench/
    bench.py                     the driver: list, run, collect, check, report
    run_bench.tcl                one Vitis run, everything from the environment
    include/lanes.h              vec_t (one W-lane beat) and its lane accessors
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
        directives_opt.tcl       pipeline BEAT, unroll LANE
        vectors/n64/data.h       generated by gen_data.py, committed
        dace/n64_w4/vecadd_0_0.cpp   DaCe's device file, generated, committed
        dace/n64_w4/vecadd_dace.cpp  top for case 3, generated, committed
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
  "W": [1, 4, 8],
  "iface": "axis",
  "axis": ["A", "B", "C"],
  "cflags": ["-std=c++14", "-I{bench}/include", "-I{bench}/gen/dace_include"],
  "tb": "src/tb_vecadd.cpp",
  "cases": {
    "unopt": {"top": "vecadd", "src": ["src/vecadd.cpp"], "per_w": true},
    "opt": {"top": "vecadd", "src": ["src/vecadd.cpp"], "per_w": true},
    "dace": {
      "top": "vecadd_dace",
      "per_w": true,
      "W": [1, 4, 8],
      "src": ["dace/{size}_w{W}/vecadd_dace.cpp", "dace/{size}_w{W}/vecadd_0_0.cpp"],
      "cflags": ["-DDACE_SYNTHESIS", "-DDACE_XILINX", "-DDACE_XILINX_DEVICE_CODE", "-DHLSLIB_SYNTHESIS"]
    }
  },
  "dace": {"vectorize": true, "passes": [], "expansions": {}}
}
```

- Size keys are `make_inputs`'s argument names (`n`, `m`). They give the tag (`n64`, `m38_n42`) and the macros (`SIZE_N`, `SIZE_M`).
- `{size}`, `{W}` and `{bench}` (the absolute path of `bench/`) in paths and `cflags` are filled per point. Every path that reaches Vitis is absolute, because cosim compiles from inside the project.
- `iface` and `axis`: with `"iface": "axis"`, every argument in `axis` gets an axis interface in every case. The interface is recorded per row.
- `cflags` at the top go to every case, a case's own `cflags` after them. A case's `W` list replaces the kernel's (the reductions' `dace` case runs at W = 1 only).
- Optional keys: `acc_dtype` (tier P, gives `ACC_T`), `clock_ns` (default 3.33), and per case `tb` or `directives` to override the defaults.
- The top-level `dace` key is read by `gen_dace.py` only. `vectorize` allows `Vectorization` at W > 1, `passes` names functions of `dace.transformation.auto.fpga` to apply, and `expansions` maps a library node type to its implementation (for example `{"Gemv": "FPGA_Accumulate"}`).

### 5.2 What is kept: `results/`

The Vitis projects and logs are scratch: git ignores them and `make clean` removes them. What is committed is the summaries in `results/`, and the generated Verilog in `rtl/`. `bench.py collect` can rebuild both from projects that still exist.

- `rtl/<tier>/<kernel>/<point>/`: the `.v` files of `<proj>/sol/syn/verilog/` for every run point, copied by `run` and `collect`. That is enough for a synthesis run (section 6) on a machine without Vitis. It is plain text with no timestamps, a few files per point, so it diffs cleanly.

- `hls_cycles.csv`: one row per point.
- `hls_loops.csv`: one row per loop per point (module, loop, trips, iteration latency, II achieved and target, pipelined). This is enough to explain a cycle count without the reports.
- `report_<tier>.md`: per kernel, a table of the points with cycles, cycles per element and the ratio to `unopt`, then the loop table, then forge's rows from `forge_cycles.csv` when there are any. `run` and `collect` rewrite it, and `bench.py report` rewrites it on demand.

Both CSVs are keyed by `tier, kernel, case, size, W, clock_ns`; a rerun replaces its rows. The columns of `hls_cycles.csv`:

| Columns | Meaning |
|---|---|
| `iface` | The ports' interface (`axis` from now on) |
| `status` | `ok`, or `failed: csim / cosim / no csynth report` |
| `csim_errors` | From the log |
| `clock_est_ns`, `clock_unc_ns`, `timing` | Vitis's clock estimate and uncertainty for the top, and `met` or `missed` (section 3.3) |
| `lat_min`, `lat_max`, `ii_min`, `ii_max`, `pipeline` | csynth estimate for the top |
| `cosim_status`, `cosim_lat_min/avg/max` | RTL cycles from cosim (Verilog) |
| `LUT`, `FF`, `DSP`, `BRAM_18K` | csynth estimates. Only a sanity check here: DSP should be 0, and BRAM shows a RAM inside the block (DaCe's `dot`). |
| `portable` | `yes`, or what was found (section 3.2) |
| `vitis`, `git`, `date`, `proj` | Where the row came from |

---

## 6. Synthesis (per tier, after its cycles)

The same Verilog from both sides goes through the same two flows. Both flows run with hierarchy kept, so control, CSR and datapath can be read apart.

| Flow | HLS side | Forge side | Settings |
|---|---|---|---|
| Vivado, out of context | `rtl/<tier>/<kernel>/<point>/*.v` (not `export_design`, which runs its own flow) | `out/rtl/<kernel>/sv/*.sv` from forge's `gen-rtl` | `synth_design -mode out_of_context -flatten_hierarchy none -max_dsp 0`, same part and clock |
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

- `config_op mul -impl fabric` and `config_array_partition -complete_threshold 0` are accepted on 2023.2.2. (Done in the first `ap_memory` run.)
- Vitis takes DaCe's unused entry function (interface pragmas on a non-top function). (Done.)
- The report parsing fills every column, and `report_done.md` reads well. (Done.)

The first runs used `ap_memory` ports (commits 4b7b617 and 99e6c80, in git history). Tier done was then moved to axis ports, the interface of SNAX's units. Those are the numbers that count.

### Tier done — `vecadd`, `vecmul`, `vsum`, `dot`

| Kernel | Sizes | W (`opt`) | Notes |
|---|---|---|---|
| `vecadd` | n64 (recipe), n512 | 1, 4, 8 | The pipe-cleaner for every step |
| `vecmul` | n64, n512 | 1, 4, 8 | First fabric multiplier: check `DSP = 0` |
| `vsum` | n64, n512 | 1, 4, 8 | W = 1 is the `vsum` recipe, W = 4 is `vsum_tree`. `opt` adds the W lanes of a beat in a tree into one accumulator. |
| `dot` | n64 (recipe), n512 | 1, 4, 8 | Forge's dot study runs N = 512 at W = 4 and 8. Forge's dot variants (vmul + vsum through L1, FIFO link, MAC lanes) are the forge-side rows of this one HLS kernel. |

Every case runs at every W (64 points), except the reductions' `dace` case, which runs at W = 1 (section 4.3).


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
