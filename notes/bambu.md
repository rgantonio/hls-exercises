# Bambu in hls-exercises (BAM1, BAM2)

Summary of Bambu as the second HLS tool next to Vitis (and Google XLS in dslx-exercises), for the HLS side of the snax-forge comparison. It covers what was set up, how to run it, what worked, the results of tier done and untiered, how they compare with XLS and Vitis, and the differences to keep in mind. BAM1 brought Bambu up and found its limits (`notes/bambu_probe.md`, rounds R0 to R0c, and `results_staging/runs/2026-11-03_bambu_done.md`). BAM2 rebuilt the flow to match XLS1: one case, RTL only, our own testbenches in Questa (`docs/BAMBU_PLAN.md`; runs in `results_staging/runs/2026-11-04_bambu_r0.md`, `2026-11-05_bambu_r1.md` and `2026-11-05_bambu_r3.md`). BAM1's two cases (`bambu_unopt`, `bambu_opt`), its co-simulation results and their RTL folders were removed in BAM2's clean-up; commit 28be6ef is the last one that has them.

## What it is

- **Tool**: Bambu 2024.10 (PandA, Politecnico di Milano), revision c2ba6936ca2ed63137095fea0b630a1c66e20e63, with its own Clang 16.0.0 front end (`--compiler=I386_CLANG16`). It comes from the release AppImage `https://release.bambuhls.eu/bambu-2024.10.AppImage` (the GitHub release has no assets), sha256 `e4f0214496a5d35de1932975b0f41cd95bc33a53a904fc565d6c2cb01df40773`. `bench/tools/get_bambu.sh` (`pixi run get-bambu`) pins that hash and extracts the AppImage into `tools/bambu/` (git-ignored); the wrapper `tools/bin/bambu` sets the `APPDIR`, `ARGV0` and `OWD` that the extracted `AppRun` needs. `notes/bambu_help_2024.10.txt` is its `--help`. Versions in `notes/env.md`.
- **Where it runs**: Bambu builds its front end with `-m32`, and the EL8 servers lack `glibc-devel.i686`, so Bambu runs in the rootless podman image `localhost/hls-exercises-bambu:4` (`container/bambu/Containerfile`: Ubuntu 24.04, gcc multilib, `libtinfo5`). The repo, with `tools/bambu/`, is bind-mounted at its own path; `bench/tools/in_bambu.sh <cmd>` runs a command in it as the user, in the caller's directory. Details in `notes/env.md`.
- **Simulator**: Questa Sim-64 2022.4 on the host, with plain SystemVerilog testbenches (no DPI), so nothing simulates in the container. Icarus Verilog 12.0 runs the same testbenches (`--sim icarus`); Claude checks with it before Questa. Bambu's own co-simulation (Verilator in the container) is no longer used.
- **Settings** (`docs/BAMBU_PLAN.md` section 2): `--device-name=nangate45`, `--clock-period=10`, `--generate-interface=INFER` with `#pragma HLS interface port=<p> mode=axis` per array argument, `-DBAMBU_LANES=<W>` and `bench/include/bambu/lanes.h` (one `ac_int<64W>` per beat, lane 0 low), RTL only (no `--simulate`), built once per W at the largest size.
- **The case** `bambu`: Bambu's default setup (BAMBU-BALANCED-MP, `-O2`) plus `#pragma HLS unroll` on the line after the `LANE:` label. It is BAM1's `bambu_opt`.

## How to run

```bash
pixi install && pixi run get-bambu && podman build -t hls-exercises-bambu:4 container/bambu   # once
pixi run python bench/bambu.py run --dry-run                                     # every command
pixi run python bench/bambu.py run -j$(nproc) --sim questa --sim-jobs <free Questa licences>
pixi run python bench/bambu.py run --kernel dot --w 8 --size n64                 # one point
pixi run python bench/bambu.py run --sim-only --sim icarus                       # simulate rtl/ again, no Bambu
pixi run python bench/bambu.py report                                            # rewrite the reports from the CSV
```

A point is a kernel at one W. `bench/bambu.py` writes `build/<tier>/<kernel>/w<W>/<kernel>.cpp`, a copy of the source with only `#pragma` lines added (asserted), runs Bambu on it in the container (15 minutes at most), and copies the Verilog to `rtl/<tier>/<kernel>/bambu_w<W>/` with `filelist.f` (`# top:`, Bambu's mangled module name), `sizes.txt` and `cmd.txt` (Bambu version, FSM states, the added pragmas, the command). Then, on the host, it runs `tb/<kernel>_tb.sv` twice per size: without stalls (the cycle counts) and with random stalls and two tasks back to back (pass/fail). One row per (kernel, size, W) in `results_staging/bambu_cycles.csv` (columns as dslx-exercises' `xls_cycles.csv`); tables in `results_staging/report_bambu_<tier>.md`. `build/` is scratch (git-ignored). No step needs a licence except Questa; R1 and R3 took 52 s and 24 s at `-j$(nproc) --sim-jobs 32`.

By hand, for one point (vecadd, W = 8), RTL only:

```bash
mkdir -p build/hand && cd build/hand
sed -e 's/^void vecadd(/#pragma HLS interface port=A mode=axis\n#pragma HLS interface port=B mode=axis\n#pragma HLS interface port=C mode=axis\nvoid vecadd(/' \
    -e '/^\s*LANE:\s*$/a #pragma HLS unroll' ../../bench/tier_done/vecadd/src/vecadd.cpp > vecadd.cpp
../../bench/tools/in_bambu.sh bambu vecadd.cpp --top-fname=vecadd --device-name=nangate45 --clock-period=10 \
  --compiler=I386_CLANG16 --generate-interface=INFER \
  -DDATA_T=int64_t -DSIZE_N=512 -DBAMBU_LANES=8 --std=c++14 \
  -I../../bench/include/bambu -I../../bench/tier_done/vecadd/src -I../../bench/tier_done/vecadd/vectors/n512
```

`cmd.txt` in each `rtl/` folder has the exact command `bambu.py` ran, and `build/.../<size>_<run>/sim.sh` the simulation command.

## Testbench

`tb/common.svh` comes unchanged from dslx-exercises (`tb/SOURCE` names the commit): `beat_src` streams a `.hex` file in W-lane beats and `beat_chk` checks the output against one, both with optional random gaps. `tb/bambu.svh` adds `bambu_ctl` in place of XLS's `cfg` source: it pulses `start_port` right after reset and again on the cycle after each `done_port`, TASKS times. The pins (`loop_count`, `len`, `alpha`) are constants for the whole run. Bambu's reset is active low and synchronous, so the testbench connects `.reset(~rst)`. Each testbench prints one `PASS`/`FAIL` line, and nothing else decides pass or fail.

$$\text{cycles} = t_{\text{last output}} - t_{\text{start}}, \qquad \text{cycles done} = t_{\text{done}} - t_{\text{start}}, \qquad \text{latency} = t_{\text{first output}} - t_{\text{first input}}$$

`cycles` is comparable with XLS's (`cfg` transfer to last output); `cycles_done` with Vitis's `ap_start` to `ap_done`. `cycles_done` is one less than BAM1's co-simulation "Total cycles" at every point compared (Bambu counts both end cycles).

## What worked

- **Every point passes**: 95 of 95 (tier done 48, untiered 47; rowsum m4_n16 at W = 32 is left out by its valid rule), each in both runs, in Questa. Every output lane matches the reference exactly. The four untiered testbenches passed on their first run.
- **W = 32 works**: all 2048-bit points build and pass both runs. BAM1 recorded them as `failed: timeout` or `failed: sim`; that was Bambu's co-simulation harness (Verilator hung, or hit its 200M-cycle limit), not the RTL (R1).
- **LANE always unrolls**: with the pragma every lane index is a constant, so no point needs a wide variable shift and nothing fails to build (BAM1's `bambu_unopt` failed at W ≥ 16 there).
- **One Verilog per W**: the size reaches the hardware only through `loop_count` (and `len`), so Verilog built at the largest size runs every size (checked in R0 and by every R1 and R3 point). The R1 rebuild matched BAM1's `bambu_opt` Verilog except for the operand order inside some `SIMPLEJOIN_FU` `.ops({...})`, which follows the command (build size, `--simulate`) and can also change between two builds of the same command (BAM3 probe A, `results_staging/runs/2026-11-05_bambu_probe_a.md`); the joins combine the same done signals either way.
- **Plain RTL**: no point instantiates a memory module (no `# ram:` line), and every Verilog is portable (no vendor primitives).

## Results

From `results_staging/bambu_cycles.csv` (Questa, R1 and R3). Cycles from the start pulse to the last output at each kernel's first size, with cycles per beat in brackets.

| Kernel | Sizes | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 | FSM states (W = 1 … 32) |
|---|---|---|---|---|---|---|---|---|
| vecadd, vecmul | n64, n512 | 95 (1.48) | 95 (2.97) | 47 (2.94) | 23 (2.88) | 11 (2.75) | 5 (2.50) | 21, then 8 |
| matadd | m8_n16, m16_n32 | 191 (1.49) | 191 (2.98) | 95 (2.97) | 47 (2.94) | 23 (2.88) | 11 (2.75) | 21, then 8 |
| relu, axpy | n64, n512 | 127 (1.98) | 95 (2.97) | 47 (2.94) | 23 (2.88) | 11 (2.75) | 5 (2.50) | 15, then 8 |
| vsum | n64, n512 | 160 (2.50) | 96 (3.00) | 48 (3.00) | 24 (3.00) | 16 (4.00) | 8 (4.00) | 21, 9, 9, 9, 10, 10 |
| dot | n64, n512 | 192 (3.00) | 96 (3.00) | 48 (3.00) | 32 (4.00) | 16 (4.00) | 8 (4.00) | 9, 9, 9, 10, 10, 10 |
| rowsum | m4_n16, m8_n64 | 163 (2.55) | 99 (3.09) | 51 (3.19) | 27 (3.38) | 19 (4.75) | (left out) | 21, 9, 9, 9, 10, 10 |

Every count, at both sizes, fits one line per kind of kernel, with $b = N / W$ the beats and $M$ rowsum's rows:

$$\text{elementwise: } \text{cycles} = c_W \thinspace b - 1, \qquad \text{reduction: } \text{cycles} = c_W \thinspace b \thickspace (+ \thinspace M - 1 \text{ for rowsum})$$

| $c_W$ | W = 1 | W = 2, 4 | W = 8 | W = 16, 32 |
|---|---|---|---|---|
| vecadd, vecmul, matadd | 1.5 | 3 | 3 | 3 |
| relu, axpy | 2 | 3 | 3 | 3 |
| vsum, rowsum | 2.5 | 3 | 3 | 4 |
| dot | 3 | 3 | 4 | 4 |

`cycles_done` is `cycles + 2` everywhere except vecadd, vecmul and matadd at W = 1 (`+ 3`). `latency` is 1 for the elementwise kernels; for reductions it spans the whole first sum, so it is not a pipeline depth.

## Against XLS and Vitis

Tier done at n64, cycles (cycles per beat). XLS from dslx-exercises' `notes/xls.md` (10 ns, delay model `unit`). Vitis `opt` (3.33 ns, FPGA delays) is known here only at vecadd W = 4: 16 cycles (`docs/HLS_VS_FORGE.md` section 2); its full rows are in snax-forge-experiments.

| Kernel | Tool | W = 1 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| vecadd | Bambu | 95 (1.48) | 47 (2.94) | 23 (2.88) | 11 (2.75) | 5 (2.50) |
| vecadd | XLS | 64 (1.00) | 16 (1.00) | 8 (1.00) | 4 (1.00) | 2 (1.00) |
| dot | Bambu | 192 (3.00) | 48 (3.00) | 32 (4.00) | 16 (4.00) | 8 (4.00) |
| dot | XLS | 64 (1.00) | 16 (1.00) | 8 (1.00) | 4 (1.00) | 2 (1.00) |

Bambu cannot pipeline loops, so each beat goes through its FSM in 3 or 4 states; XLS gives one beat per cycle by default, and Vitis needs `opt`'s pipeline directive for it. Area and timing at 45 nm are for synthesis.

## Differences to keep in mind

Each with where it was found.

- **No loop pipelining.** `#pragma HLS pipeline` inside a loop stops the front end (`Loop pipelining pragma not supported.`), and `--pipelining` applies to functions only. Every beat goes through the FSM: 3 cycles per beat, 4 for the wider reductions (dot from W = 8, vsum and rowsum from W = 16; likely the adder tree taking one more state, not checked). Evidence: `--help`; `notes/bambu_probe.md`, R0 Findings; R1 and R3.
- **W = 1 unrolls BEAT on its own.** At W = 1 the BEAT loop is unrolled into a main loop plus a one-beat remainder loop for counts that are not a multiple: 4× for vecadd, vecmul and matadd (6 states per 4 beats, 1.5 cycles per beat, 21 FSM states) and 2× for relu and axpy (2 cycles per beat, 15 states). Read from the controller in R3 (step 7), and it matches the cycles. That it is LLVM's runtime unrolling in Bambu's Clang front end, not our pragma, is likely but not checked.
- **One extra cycle per rowsum row.** rowsum is vsum plus $M - 1$ cycles at every W, one per row boundary (R3).
- **Scalar pins take no handshake mode and are never registered.** `loop_count`, `len` and `alpha` are plain input wires that feed the loop's comparators in every iteration, so the driver must hold them for the whole task (Vitis registers them with `ap_vld`; XLS loads them on a `cfg` channel). `mode=ap_vld`, `ap_hs` and `ap_ack` on these by-value scalars all stop Bambu (`Interface type '...' for parameter 'loop_count' is not supported`). Evidence: `notes/bambu_probe.md`, R0 to R0c Findings.
- **Control ports.** `start_port`/`done_port` and a synchronous, active-low `reset`, not `ap_ctrl_hs`. A task starts with a one-cycle `start_port` pulse; the next may start on the cycle after `done_port` (the stall runs check two tasks back to back).
- **Top module name.** `--top-rtldesign-name` has no effect on C++ tops: the top keeps its mangled name (e.g. `_Z6vecaddPK6ac_intILi512ELb0EES2_PS0_j`), which changes with W. `filelist.f`'s `# top:` is the module no other one instantiates. Evidence: BAM1 R1 run note.
- **An unconnected output in every point.** The write module of the output stream (`<port>_bambu_artificial_ParmMgr_Write_axis_modgen`) has an `out1` output that Bambu leaves unconnected. Questa warns twice per run (`Too few port connections`, `Missing connection for port 'out1'`) and nothing else; it does not affect simulation, and DC may report it as an unconnected pin. Evidence: R0, R1, R3.
- **No unit for wide variable shifts.** Without the unroll pragma, LANE stays a loop above W = 8, and writing a lane at a run-time index needs a variable shift of the 64W-bit beat; at 1024 and 2048 bits Bambu has no unit (`Vertices not completely allocated`). The `bambu` case avoids it; it is one reason `bambu_unopt` was dropped. Evidence: `notes/bambu_probe.md`, R0c Findings; BAM1 R1.
- **Front-end constraints.** A struct `vec_t` is split into its fields (one lane per transfer, 17.25 cycles per beat at W = 8); any HLS pragma in an included header breaks the interface pragmas (`Unassociated HLS pragma`); `-DW` clashes with `ac_int.h`, so the lanes come as `BAMBU_LANES`; `-O0` compiles as `-O1`; BAMBU-AREA (`-Os`) does not unroll LANE and fails at W = 8. Evidence: `notes/bambu_probe.md`, R0 to R0c.
- **Questa's transcript** starts every line with `# `; `bench/bambu.py` strips it before reading the testbench's line.

## Open

- Synthesis and power of the 95 points in snax-forge-experiments, from `rtl/<tier>/<kernel>/bambu_w<W>/filelist.f` (top = the mangled module name, no memories).
- Merging `results_staging/bambu_cycles.csv` into snax-forge-experiments' `results/hls/` next to Vitis's and XLS's rows.
- Whether Vitis's `unopt` stays in the comparison (Bambu and XLS now have one case each).
- Tier A, if Bambu is kept for it.
