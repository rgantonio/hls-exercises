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

**Cycles first.** Each run point records the csynth estimate (latency min and max, II) and the cosim latency, which is the RTL cycle count. Area and fmax come from synthesis of the same Verilog (section 6).

**Hardware points and sizes.** A hardware point is a case and a W (and the HLS clock). The size is not part of it: it reaches the block on run-time pins, as in forge (section 2), so every size runs on the same Verilog, and synthesis runs once per hardware point.

**The forge side.** Forge's number is its accelerator window, the `forge counter`, on SNAX-GVSoC and on snax_cluster's RTL (forge `docs/ARCHITECTURE.md` §7, `docs/RUN.md` §8). It goes into `results/forge_cycles.csv`, copied from forge's runs until forge has an export command.

---

## 2. Ground rules

These keep the two sides comparable. Where a difference can't be removed, it is written down next to the data.

**Same kernels.** Forge's kernel files (`kernels/<group>/<kernel>.py`) are the source. The HLS C++ follows their NumPy body, at `int64` through tier C and `int8` in with `int32` accumulate from tier P (forge D113).

**Same sizes.** The first size of every kernel is the one forge's recipe runs (`recipes/<kernel>.json`). After that come the sizes the plan sets per tier (section 7). `docs/SIZES.md` lists them, with PolyBench's and NPBench's sizes for later.

**Same split between design time and run time.** Forge's blocks take their lanes and data width at elaboration, and the run's length on 32-bit configuration pins that the CSR manager drives and the block samples at start (forge D130, `CtrlAdapter`): `loopCount`, the beats in the run, and for the `Accumulator` also `len`, the beats per result (T). M13 B1 renames them per unit to JOB_BEATS and JOBS (forge open item 83). The HLS tops follow that:

| Kind | Parameter | HLS form |
|---|---|---|
| Design time | W, dtype, case, HLS clock | compile flags (`-DW=4`) and directives: one Verilog each |
| Run time | `loop_count` = N / W beats | a `cfg_t` (`uint32_t`) argument of the top |
| Run time | `len` = beats per result (`vsum`, `dot`; `rowsum` later) | a `cfg_t` argument |

- `run_bench.tcl` gives every pin `set_directive_interface -mode ap_vld`: the data plus one valid bit. Vitis keeps the pin in a register (`<pin>_preg`) loaded whenever `<pin>_ap_vld` is high, and uses the port itself in that cycle. **Protocol: the driver raises `ap_vld` for one cycle, together with the accepted start, and keeps it low for the rest of the run.** That is forge's rule exactly: `ElementwiseTiledSpatial` and `Accumulator` load `target := io.loopCount` (and `len`) on `io.start`, which is `ctrl.fire`, a one-cycle pulse (`CtrlAdapter`). So both sides hold one 32-bit register per pin, loaded on a one-cycle start event. `ap_vld` cannot be tied to `ap_start`, which stays high until `ap_ready` (at the end of the run in `vsum`); an integrator derives the pulse from the start handshake. Cosim drives one transaction per pin per call. Two attempts did not do that: as a plain `ap_none` wire (`f6426a6`), Vitis compared the port directly inside the loop, although the C++ copies it into a local; with `ap_none -register` (`0b3c268`), the register reloaded every cycle, so a pin changed mid-run still moved the loop bound, and opt cost 3 more cycles.
- The values come from `params.json`'s `config` (e.g. `"loop_count": "n // W"`). `bench.py` passes them to the testbench only (`-DCFG_LOOP_COUNT=16`), never to the design, so the design cannot fold them into constants.
- `SIZE_N` stays a compile flag for the C side: the testbench's arrays and the depth of the axis arrays in the top's signature need it, so each size is still its own Vitis run. It should not reach the Verilog, and `bench.py` checks that: every size's Verilog of a hardware point is compared with the first one's (the `rtl_same` column), and a size whose Verilog differs keeps its own folder in `rtl/`.
- A loop bounded by a pin has no trip count for csynth's estimate. `params.json`'s `tripcount` (e.g. `"BEAT": "loop_count"`) gives it one per size with `set_directive_loop_tripcount`, which changes no hardware. DaCe's loops are unlabelled, so the `dace` case's estimate shows `?`; its cosim count is unaffected.

**Same data.** `bench/gen/gen_data.py` runs in forge's pixi environment. It calls each kernel's `make_inputs` with a fixed seed and forge's reference, and writes `vectors/<size>/data.h`. The testbench checks every output exactly.

**Same block boundary: axis ports.**
- Forge's units take their data as `Decoupled(Vec(lanes, UInt(64)))`: one valid-ready handshake around all W lanes, with the streamers outside the unit (forge D112). The HLS tops match that. Every array argument is one AXI4-Stream port (`TDATA`, `TVALID`, `TREADY`) whose `TDATA` holds one beat of W lanes, W × 64 bits with lane 0 in the low bits.
- A beat is `vec_t` from `bench/include/lanes.h`. It is DaCe's own `dace::vec<T, W>`: `T` itself at W = 1, `hlslib::DataPack<T, W>` (one `ap_uint<64W>`) above. So case 3's generated module takes exactly the type cases 1 and 2 use.
- A reduction's result is an axis port of one element per beat (`out[NOUT]`), as forge's accumulator has `Decoupled(UInt)`. With `len = loop_count` there is one result, `NOUT = 1`.
- **No register slices.** By default Vitis puts a register slice on every axis port, a two-entry skid buffer that registers `TDATA`/`TVALID` and `TREADY` (2 × W × 64 flops per port). Forge's units have none: their handshake is plain logic (`io.a.ready := busy && io.b.valid && io.out.ready`). So the bench sets `"axis_register_mode": "off"`, and the `iface` column says which mode a row used. In the first synthesis run (`vecadd` `unopt_n512_w8`, with the slices on), they were 3,072 of the 4,843 flops.
- `params.json` lists the axis ports, and `run_bench.tcl` sets them with `set_directive_interface -mode axis -register_mode <mode>` for every case. Axis on an array argument needs every element read or written once, in order, which the tier done kernels do. The testbench's arrays hold exactly the beats the pins ask for, so cosim's transaction counts match.
- The testbench plays the streamer: it packs forge's inputs into beats, and cosim drives the streams with no stalls.
- Control is `ap_ctrl_hs` (start, done, idle, ready). There are no CSRs and no AXI memory-mapped ports.

**Known differences.** These are kept, not removed:
- HLS has no CSR file. Its latency runs from `ap_start` to `ap_done`. Forge's per-task counter (for example `add_acc`) also leaves the CSR programming out, so the two are compared. Forge's whole-program window (`forge cycles`) is not. Forge's CSR module is shown apart in area (its split into control, CSR and datapath modules).
- Cosim feeds a beat every cycle. Forge's streamers feed from the TCDM, so their start-up and any bank conflicts land in forge's counter. The `overhead` column (cycles minus beats) shows that cost on both sides.
- **Open, for the analysis:** where forge's extra cycles come from. Without register slices, HLS `opt` has no overhead on elementwise kernels (vecadd n64 W = 4: 16 cycles for 16 beats), while forge's `add_acc` counts 19. The likely parts are streamer fill and drain, the start and done handshakes, and bank conflicts that depend on placement. SNAX-GVSoC's `--trace stall` can split them. A shared harness that drives both units with the same ideal or stalled streams would compare the units alone.

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

Vitis's own FPGA timing estimate is recorded (`clock_est_ns`) but not used: the RTL is judged by ASIC synthesis (section 6). The 64-bit fabric multiplier (`vecmul`, `dot`) is estimated at 3.648 ns on the FPGA, which matters only for an FPGA view.

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

`bench/gen/gen_dace.py` runs in forge's environment. It builds forge's own SDFG (`snax_forge.sdfg.build`) and keeps its sizes symbolic, so DaCe passes the symbol `N` to its module as an `int` argument: DaCe's own run-time pin. At W > 1 it applies DaCe's `Vectorization` with `vector_len` W. Then it applies `FPGATransformSDFG` and writes `dace/w<W>/` per kernel, one per hardware point, for every size. Here is what comes out on DaCe 1.0.2:

- **Vectorization works on the elementwise kernels** (`vecadd`, `vecmul`): the arrays become `dace::vec<int64_t, W>` words and the loop runs one word per cycle. It needs `preamble=False` and `postamble=False`; otherwise DaCe adds a remainder step that reads one word past the end, even when W divides N.
- **It does not work on reductions.** On `vsum` it fails with a `KeyError`, and on `dot` it doesn't finish. So their `dace` case runs at W = 1 only (`"W": [1]` in the case), which is what DaCe gives without hand work.

- **The device file is plain Vitis C++ with pragmas in it.** Every map already has `PIPELINE II=1` and `LOOP_FLATTEN`. So `asic.tcl`'s `pipeline_loops 0` doesn't matter for this case; what DaCe chose is what runs.
- **DaCe's entry function is a DATAFLOW region over raw pointers,** with `m_axi` and `s_axilite` pragmas and hlslib macros. Its device file is kept unchanged as `dace/<size>_w<W>/<kernel>_0_0.cpp`, and that entry function is left unused.
- **The generator writes a small top, `dace/w<W>/<kernel>_dace.cpp`.** It has the same arguments as the hand-written top in `src/<kernel>.h`, so the ports (axis), the pins and the testbench are the same as in cases 1 and 2, and it calls DaCe's `module_<kernel>_0_0` function directly.
- **Symbols from pins.** `params.json`'s `dace.symbols` says how each DaCe symbol comes from the top's pins, e.g. `{"N": "loop_count * W"}` (DaCe counts elements, the pin counts beats). A symbol with no entry stops the generator. DaCe has no restart, so a `len` pin goes unused in this case.
- **Includes and flags.** The device file includes `<dace/fpga_device.h>`. So the generator copies DaCe's runtime headers and hlslib into `bench/gen/dace_include/`, and the Vitis machine needs no DaCe install. The case compiles with DaCe's own synthesis flags, `-DDACE_SYNTHESIS -DDACE_XILINX -DDACE_XILINX_DEVICE_CODE`. Every case includes `bench/gen/dace_include/` anyway, for `vec_t`, and gets `-DHLSLIB_SYNTHESIS`: without it hlslib's `DataPack` bounds-checks with `std::stringstream`, which Vitis's csynth front end rejects (csim still passes). `lanes.h` stops the build when the flag is missing.
- **Reductions** (`vsum`, `dot`). `np.sum` becomes a loop at II = 1 that writes through DaCe's write-conflict resolution into a scalar transient, which DaCe's module takes by value. DaCe's `dot` is two loops: `A * B` into a transient array of N, then the sum over it, which is forge's "vmul then vsum through L1" inside one block.
- **Transients in the generated top.** A scalar is a local variable. An array is a local static array, so it is a RAM inside the block. Its size depends on the symbols, so it is sized for the largest size in `params.json`: that depth is a design-time bound of DaCe's hardware (`dot`'s `__tmp0[512]`).
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
    SIZES.md                     the sizes run, PolyBench's and NPBench's, and what to update later
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
    synth_dc.csv                 section 6: a copy of syn/runs/summary.csv
    runs/<date>_<tier>.md        Claude Code's note of each bench run (section 8)
  rtl/                           Vitis's generated Verilog per hardware point, kept for synthesis (5.2)
    done/vecadd/opt_w4/*.v, filelist.f, sizes.txt
  syn/                           ASIC synthesis with DC on FreePDK45 (section 6, syn/README.md)
    syn.py, scripts/             the driver, dc_syn.tcl and constraints.sdc
    runs/                        every DC run, local only (git ignores it)
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
        dace/w4/vecadd_0_0.cpp       DaCe's device file, generated, committed
        dace/w4/vecadd_dace.cpp      top for case 3, generated, committed
        opt_n64_w4_proj/         Vitis project (ignored by git, removed by make clean)
        run_opt_n64_w4_proj.log
      vecmul/ vsum/ dot/
    tier_a/
      atax/ bicg/ mvt/ gesummv/
    tier_untiered/
      matadd/ relu/ rowsum/ axpy/ vdiv/
```

**Naming.** Projects are `<case>_<size>_w<W>[_c<clock>]_proj`, each with one solution `sol`. Hardware points in `rtl/` drop the size: `<case>_w<W>[_c<clock>]`. The clock tag appears only for an HLS clock other than the default 3.33 ns. That deviates from the exercises' many-solutions-per-project layout, because `open_project -reset` wipes every solution, and here every point is independent. Each project holds a `point.json` that says what the point was, so `bench.py collect` can rebuild the CSV from the folders.

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
  "axis_register_mode": "off",
  "config": {"loop_count": "n // W"},
  "cflags": ["-std=c++14", "-DHLSLIB_SYNTHESIS", "-I{bench}/include", "-I{bench}/gen/dace_include"],
  "tb": "src/tb_vecadd.cpp",
  "cases": {
    "unopt": {"top": "vecadd", "src": ["src/vecadd.cpp"], "per_w": true, "tripcount": {"BEAT": "loop_count"}},
    "opt": {"top": "vecadd", "src": ["src/vecadd.cpp"], "per_w": true, "tripcount": {"BEAT": "loop_count"}},
    "dace": {
      "top": "vecadd_dace",
      "per_w": true,
      "W": [1, 4, 8],
      "src": ["dace/w{W}/vecadd_dace.cpp", "dace/w{W}/vecadd_0_0.cpp"],
      "cflags": ["-DDACE_SYNTHESIS", "-DDACE_XILINX", "-DDACE_XILINX_DEVICE_CODE"]
    }
  },
  "dace": {"vectorize": true, "passes": [], "expansions": {}, "symbols": {"N": "loop_count * W"}}
}
```

- Size keys are `make_inputs`'s argument names (`n`, `m`). They give the tag (`n64`, `m38_n42`) and the macros (`SIZE_N`, `SIZE_M`).
- `config` gives each run-time pin's value as a Python expression over the size keys and `W`; the testbench gets `-DCFG_<PIN>=<value>`. A case's `tripcount` maps a loop label to an expression over the same names and the pins (section 2).
- `{size}`, `{W}` and `{bench}` (the absolute path of `bench/`) in paths and `cflags` are filled per point. Every path that reaches Vitis is absolute, because cosim compiles from inside the project.
- `iface`, `axis` and `axis_register_mode`: with `"iface": "axis"`, every argument in `axis` gets an axis interface in every case, with register slices set by `axis_register_mode` (`off`, `forward`, `reverse` or `both`; `both` is Vitis's default when the key is missing). The interface and mode are recorded per row.
- `cflags` at the top go to every case, a case's own `cflags` after them. A case's `W` list replaces the kernel's (the reductions' `dace` case runs at W = 1 only).
- Optional keys: `acc_dtype` (tier P, gives `ACC_T`), `clock_ns` (default 3.33), and per case `tb` or `directives` to override the defaults.
- The top-level `dace` key is read by `gen_dace.py` only. `vectorize` allows `Vectorization` at W > 1, `passes` names functions of `dace.transformation.auto.fpga` to apply, `expansions` maps a library node type to its implementation (for example `{"Gemv": "FPGA_Accumulate"}`), and `symbols` maps each DaCe symbol to a C++ expression over the top's pins.

### 5.2 What is kept: `results/`

The Vitis projects and logs are scratch: git ignores them and `make clean` removes them. What is committed is the summaries in `results/`, and the generated Verilog in `rtl/`. `bench.py collect` can rebuild both from projects that still exist.

- `rtl/<tier>/<kernel>/<case>_w<W>/`: the `.v` files of `<proj>/sol/syn/verilog/` for one hardware point, a `filelist.f` (the top module on a `# top:` line, then the files) and `sizes.txt` (the sizes whose Verilog is exactly this). `run` and `collect` place them after all Vitis runs, smallest size first: that size is the reference, and every other size is compared with it, ignoring Vitis's `CORE_GENERATION_INFO` line (it carries the latency estimate). If that differs, it is compared again with Vitis's numbered ids masked (`add_ln9_fu_126_p2`, `add_ln9_reg_232`, `..._U1`): equal then is `renamed`, the same circuit with shifted net names, as `unopt` n512 W = 8 was on 27 Oct (DC gave the same area). A size whose Verilog still differs gets its own folder, `<case>_<size>_w<W>/`, and `rtl_same` says which files differ. A memory Vitis built (a `*_RAM_*.v` file) is named on a `# ram:` line of `filelist.f`. That is enough for a synthesis run (section 6) on a machine without Vitis. It is plain text with no timestamps, so it diffs cleanly.

- `hls_cycles.csv`: one row per point.
- `hls_loops.csv`: one row per loop per point (module, loop, trips, iteration latency, II achieved and target, pipelined). This is enough to explain a cycle count without the reports.
- `report_<tier>.md`: per kernel, a table of the points with cycles, cycles per element and the ratio to `unopt`, then the loop table, then forge's rows from `forge_cycles.csv` when there are any. `run` and `collect` rewrite it, and `bench.py report` rewrites it on demand.

Both CSVs are keyed by `tier, kernel, case, size, W, clock_ns`; a rerun replaces its rows. The columns of `hls_cycles.csv`:

| Columns | Meaning |
|---|---|
| `iface` | The ports' interface (`axis` from now on) |
| `config` | The run-time pins' values the testbench drove (`loop_count=16 len=16`) |
| `status` | `ok`, or `failed: csim / cosim / no csynth report` |
| `csim_errors` | From the log |
| `clock_est_ns`, `clock_unc_ns`, `timing` | Vitis's FPGA clock estimate, kept for reference only. The report leaves them out: timing comes from ASIC synthesis (section 6). |
| `lat_min`, `lat_max`, `ii_min`, `ii_max`, `pipeline` | csynth estimate for the top |
| `cosim_status`, `cosim_lat_min/avg/max` | RTL cycles from cosim (Verilog) |
| `LUT`, `FF`, `DSP`, `BRAM_18K` | csynth estimates. Only a sanity check here: DSP should be 0, and BRAM shows a RAM inside the block (DaCe's `dot`). |
| `portable` | `yes`, or what was found (section 3.2) |
| `rtl`, `rtl_same` | The `rtl/` folder of the point's Verilog, and `ref`, `yes`, `renamed` or `no: <files>` (5.2) |
| `vitis`, `git`, `date`, `proj` | Where the row came from |

---

## 6. Synthesis (ASIC)

The comparison is made on ASIC synthesis only; the FPGA's timing is not a concern. The flow is in `syn/` (`syn/README.md`): Design Compiler on FreePDK45 (OSU `gscl45nm`), with FreePDK45 next to hls-exercises.

- **Input:** a point's `rtl/<tier>/<kernel>/<point>/filelist.f`, so only Vitis's Verilog, no Vitis.
- **Run:** `python3 syn/syn.py run 'done/*/*' [--clock NS]`, once per hardware point. `compile_ultra -no_autoungroup` keeps the hierarchy, so control, CSR and datapath can be read apart. The clock is `ap_clk`, 10 ns by default.
- **Memories are parked.** `gscl45nm` has no RAM cells, so DC would build a memory out of flops: DaCe's `dot` buffer (64 × 512) became 32,832 flops, took 14 minutes to elaborate and gives no fair area. `syn.py` skips every point whose `filelist.f` has a `# ram:` line and writes a `skipped: needs a RAM macro` row for it; `--with-ram` runs it anyway. Later, an OpenRAM macro for FreePDK45 (`.lib` converted to `.db`, with its Verilog model left out of the filelist) gives the memory's area, and the logic is synthesized around it. Forge's dot through L1 does not count the TCDM in the accelerator either, so the logic alone is the like-for-like number.
- **Output:** the runs stay in `syn/runs/`, which git ignores, with one row per point and clock in `syn/runs/summary.csv` (area, cells, critical path, slack, dynamic and leakage power). `syn.py` copies that summary to `results/synth_dc.csv`, which is committed.
- **Forge's side** goes through the same `dc_syn.tcl` once forge's `gen-rtl` output (`out/rtl/<kernel>/sv/*.sv`) gets a `filelist.f` of its own. That will need `-format sverilog`. TSMC 16 nm is the same flow with another library.

This extends forge PAPER E7 (one unit in Chisel against Vitis HLS at equal II and clock) to the kernel set.

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
| `vsum` | n64, n512 | 1, 4, 8 | W = 1 is the `vsum` recipe, W = 4 is `vsum_tree`. `opt` adds the W lanes of a beat in a tree into one accumulator. `loop_count` and `len` pins, as forge's `Accumulator`. |
| `dot` | n64 (recipe), n512 | 1, 4, 8 | Forge's dot study runs N = 512 at W = 4 and 8. Forge's dot variants (vmul + vsum through L1, FIFO link, MAC lanes) are the forge-side rows of this one HLS kernel. |

Every case runs at every W, except the reductions' `dace` case, which runs at W = 1 (section 4.3): 64 run points (two sizes each) on 32 hardware points.

The first runs had the size fixed at compile time, so every size was its own hardware. They are in git history up to commit b2ddd1a. The rerun of 27 Oct 2026 has the run-time pins.


### Tier A — `atax`, `bicg`, `mvt`, `gesummv`

| Kernel | Sizes | What `opt` needs |
|---|---|---|
| `atax` | m256_n256 (forge's default), MINI, SMALL | The second product reads $A^T$: reorder so the row-wise pass accumulates into `y` (S2.1.1's swap) |
| `bicg` | m256_n256, MINI, SMALL | One pass over $A$ feeds both `q` and `s` |
| `mvt` | n256, MINI, SMALL | One product row-wise, one column-wise; the column-wise one needs the same swap as `atax` |
| `gesummv` | n30 (forge's default, = MINI), SMALL | Both products share `x`: one pass, two accumulators |

The sizes are a proposal until forge's tier A recipes set theirs (`docs/SIZES.md`). Reused operands (`x` once per row, $A$ in two orders) are streamed again by the testbench rather than buffered in the block, as forge's streamers would fetch them (D112). In case 3 the library-node expansions are where the choices are (section 4.3).

### Untiered — `matadd`, `relu`, `rowsum`, `axpy`

These are added as forge picks them up. `rowsum` is `vsum` with `len` < `loop_count` (one result per row). `axpy` gets separate `y` in and `y_out` ports, since an axis port cannot be read and written in place (forge open item 47).

### Later tiers

B (`vdiv`, the divider unit, and `covariance`'s mean; `vdiv` checks that the divider module stays portable, section 3.2), C (`covariance`, `softmax`), P (int8 in, int32 out: `acc_dtype`), D (`gemm`, `k2mm`, `k3mm`, `doitgen`, `gemver`, `jacobi`). These follow forge's order (forge `docs/ARCHITECTURE.md` §8).

---

## 8. Working with Claude Code

The loop is the same as in the snax-forge work:

1. The plan and the code are made in the chat and pushed here (sources, `params.json`, generated vectors and DaCe files).
2. The chat gives a prompt for Claude Code on the machine with Vitis.
3. Claude Code runs the bench, commits `results/` and kernel README updates, and pushes.
4. The report (`results/report_<tier>.md`) and any failures go back to the chat, which plans the next step.

Claude Code runs and reports; it does not redesign kernels or directives on its own. When a run fails, it reports the error lines from the log and stops, unless the prompt says what to fix.

**Reports go in the repo.** Whatever the chat needs to read is committed, so nothing has to be pasted back: `results/` (the CSVs, `report_<tier>.md`, `synth_dc.csv`) and a run note `results/runs/<date>_<tier>.md` with the commands run, the tool versions, the counts of ok and failed points, the `rtl_same` outcome, and for every failure the log's error lines (at most 30 per failure). Vitis projects, logs and `syn/runs/` stay local.

- **Start.** Every prompt starts with `git pull` in hls-exercises (and in snax-forge when vectors or DaCe sources are generated).
- **Environments.** The Vitis side needs `vitis_hls` on the path (Vitis's `settings64.sh`) and Python 3.7 or newer, standard library only (the ESAT host's `python3` is 3.6; use `python3.11`). The generators need snax-forge's pixi environment:

  ```bash
  FORGE=/path/to/snax-forge
  pixi run --manifest-path $FORGE/pixi.toml python $PWD/bench/gen/gen_data.py --forge $FORGE --tier done
  ```

- **Order of runs.** One kernel and one case first with `--dry-run`, then for real, then the rest of the tier. Once a single run works, run the rest with `-j$(nproc)` (each Vitis run with cosim holds about 1–2 GB of memory, so use less on a machine short of RAM).
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
