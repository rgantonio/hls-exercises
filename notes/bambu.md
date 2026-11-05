# Bambu in hls-exercises (BAM1, BAM2, BAM3)

Summary of Bambu as the second HLS tool next to Vitis (and Google XLS in dslx-exercises), for the HLS side of the snax-forge comparison. It covers what was set up, how to run it, what worked, the results of tier done and untiered, how they compare with XLS and Vitis, and the differences to keep in mind. BAM1 brought Bambu 2024.10 up and found its limits (`notes/bambu_probe.md`, rounds R0 to R0c). BAM2 rebuilt the flow to match XLS1: one case, RTL only, our own testbenches in Questa (`docs/BAMBU_PLAN.md`). BAM3 found that 2024.10 cannot pipeline loops and moved the `bambu` case to Bambu 2026.11, which can (`docs/BAMBU_PLAN.md` section 8; probes in `notes/bambu_probe.md`, rounds A and B; run in `results_staging/runs/2026-11-05_bambu_bam3_r1.md`). The 2024.10 results are in git history: commit 3a6c189 is the last with them in `rtl/` and `results_staging/bambu_cycles.csv` (28be6ef for BAM1's two cases and co-simulation rows).

## What it is

- **Tool**: Bambu 2026.11 (PandA, Politecnico di Milano), tag `2026.11`, commit cda4db2e724df357f749c0c41b12bdc065462ced (4 Nov 2026), with its bundled Clang 16.0.6 front end (`--compiler=I386_CLANG16`). There is no release AppImage for 2026.11, so `bench/tools/build_bambu_2611.sh` builds one from the tag with Bambu's own containerized AppImage route (inside `bambuhls/dev:xenial-24.08`, for a generic x86-64 target) and installs it as `tools/bambu-2026.11/` with the wrapper `tools/bin/bambu-2026.11`. Details, hashes and the fixes the build needed in `notes/env.md`, section Bambu 2026.11.
- **Earlier version**: Bambu 2024.10 (`bench/tools/get_bambu.sh`, `tools/bin/bambu`) stays installed; `BAMBU_BIN=bambu python3 bench/bambu.py ...` reruns the old flow. `notes/bambu_help_2024.10.txt` is its `--help`.
- **Where it runs**: Bambu builds kernels with `-m32`, and the EL8 servers lack `glibc-devel.i686`, so Bambu runs in the rootless podman image `localhost/hls-exercises-bambu:4` (`container/bambu/Containerfile`: Ubuntu 24.04, gcc multilib, `libtinfo5`). The repo, with `tools/`, is bind-mounted at its own path; `bench/tools/in_bambu.sh <cmd>` runs a command in it as the user, in the caller's directory.
- **Simulator**: Questa Sim-64 2022.4 on the host, with plain SystemVerilog testbenches (no DPI), so nothing simulates in the container. Icarus Verilog 12.0 runs the same testbenches (`--sim icarus`); Claude checks with it before Questa. Bambu's own co-simulation is not used.
- **Settings** (`docs/BAMBU_PLAN.md` section 2): `--device-name=nangate45`, `--clock-period=10`, `--generate-interface=INFER` with `#pragma HLS interface port=<p> mode=axis` per array argument, `-DBAMBU_LANES=<W>` and `bench/include/bambu/lanes.h` (one `ac_int<64W>` per beat, lane 0 low), RTL only, built once per W at the largest size.
- **The case** `bambu`: Bambu's default setup (BAMBU-BALANCED-MP, `-O2`) plus `#pragma HLS unroll` on the line after the `LANE:` label. With LANE unrolled, BEAT is an innermost single-block loop, and 2026.11 pipelines it by itself (no pragma; a loop pipeline pragma is still rejected).

## How to run

```bash
pixi install && podman build -t hls-exercises-bambu:4 container/bambu         # once
pixi run bash bench/tools/build_bambu_2611.sh                                   # once: Bambu 2026.11 (about 12 min)
pixi run python bench/bambu.py run --dry-run                                     # every command
pixi run python bench/bambu.py run -j$(nproc) --sim questa --sim-jobs <free Questa licences>
pixi run python bench/bambu.py run --kernel dot --w 8 --size n64                 # one point
pixi run python bench/bambu.py run --sim-only --sim icarus                       # simulate rtl/ again, no Bambu
pixi run python bench/bambu.py report                                            # rewrite the reports from the CSV
```

A point is a kernel at one W. `bench/bambu.py` writes `build/<tier>/<kernel>/w<W>/<kernel>.cpp`, a copy of the source with only `#pragma` lines added (asserted), runs Bambu on it in the container (15 minutes at most), and copies the Verilog to `rtl/<tier>/<kernel>/bambu_w<W>/`: `<kernel>.v`, `panda_libtech.v` (2026.11 puts its library modules there; all are used), `filelist.f` (`# top:`, Bambu's top module, e.g. `p_Z6vecaddPK6ac_intILi512ELb0EES2_PS0_j`), `sizes.txt` and `cmd.txt` (Bambu version, FSM states, loop pipelining, the added pragmas, the command). Then, on the host, it runs `tb/<kernel>_tb.sv` twice per size: without stalls (the cycle counts) and with random stalls and two tasks back to back (pass/fail). One row per (kernel, size, W) in `results_staging/bambu_cycles.csv` (columns as dslx-exercises' `xls_cycles.csv`, plus `cycles_done`, `fsm_states` and `loop_ii`); tables in `results_staging/report_bambu_<tier>.md`. `build/` is scratch (git-ignored). Both tiers take about a minute at `-j$(nproc) --sim-jobs 32`.

`cmd.txt` in each `rtl/` folder has the exact command, and `build/.../<size>_<run>/sim.sh` the simulation command.

## Testbench

`tb/common.svh` comes unchanged from dslx-exercises (`tb/SOURCE` names the commit): `beat_src` streams a `.hex` file in W-lane beats and `beat_chk` checks the output against one, both with optional random gaps. `tb/bambu.svh` adds `bambu_ctl` in place of XLS's `cfg` source: it pulses `start_port` right after reset and again on the cycle after each `done_port`, TASKS times. The pins (`loop_count`, `len`, `alpha`) are constants for the whole run. Bambu's reset is active low and synchronous, so the testbench connects `.reset(~rst)`. 2026.11's top also has an `idle_port` output, left unconnected (Questa's two warnings per run). Each testbench prints one `PASS`/`FAIL` line, and nothing else decides pass or fail.

$$\text{cycles} = t_{\text{last output}} - t_{\text{start}}, \qquad \text{cycles done} = t_{\text{done}} - t_{\text{start}}, \qquad \text{latency} = t_{\text{first output}} - t_{\text{first input}}$$

`cycles` is comparable with XLS's (`cfg` transfer to last output); `cycles_done` with Vitis's `ap_start` to `ap_done`.

## What worked

- **85 of 95 points pass**, each in both runs (tier done 48, untiered 47; rowsum m4_n16 at W = 32 is left out by its valid rule). The 10 failures are vecadd, vecmul, matadd, relu and axpy at W = 32, both sizes: a Bambu 2026.11 bug (Differences, fault 2), kept as `failed: sim` rows whose `fail_reason` names it.
- **Loop pipelining by default**: every kernel's BEAT loop is pipelined (`loop_ii`), reductions included (their conditional result write is folded into the loop block). II = 1 everywhere except dot at W = 4 and 8 (II = 2, no reason in Bambu's log).
- **Stalls**: a stall on any stream stops the whole pipeline (no draining) and it resumes cleanly; every passing point passes its random-stall, two-task run.
- **One Verilog per W**: the size reaches the hardware only through `loop_count` (and `len`), so Verilog built at the largest size runs every size.
- **Plain RTL**: no point instantiates a memory module (no `# ram:` line), and every Verilog is portable (no vendor primitives).

## Results

From `results_staging/bambu_cycles.csv` (Questa, BAM3 R1). Cycles from the start pulse to the last output at each kernel's first size, with cycles per beat in brackets.

| Kernel | Sizes | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|---|
| vecadd, vecmul, relu, axpy | n64, n512 | 65 (1.02) | 33 (1.03) | 17 (1.06) | 9 (1.12) | 5 (1.25) | failed: sim (fault 2) |
| matadd | m8_n16, m16_n32 | 129 (1.01) | 65 (1.02) | 33 (1.03) | 17 (1.06) | 9 (1.12) | failed: sim (fault 2) |
| vsum | n64, n512 | 65 (1.02) | 33 (1.03) | 17 (1.06) | 9 (1.12) | 6 (1.50) | 4 (2.00) |
| dot | n64, n512 | 65 (1.02) | 33 (1.03) | 32 (2.00) | 16 (2.00) | 6 (1.50) | 4 (2.00) |
| rowsum | m4_n16, m8_n64 | 65 (1.02) | 33 (1.03) | 17 (1.06) | 9 (1.12) | 6 (1.50) | (left out) |

Every passing count, at both sizes, fits the pipeline's II and iteration latency from Bambu's log, with $b = N / W$ the beats:

$$\text{cycles} = b + \text{lat} - 1 \quad (\text{II} = 1), \qquad \text{cycles} = 2b \quad (\text{II} = 2: \text{dot at W} = 4, 8)$$

The iteration latency is 2, or 3 for the reductions from W = 16 (the adder tree takes one more stage). `cycles_done` is `cycles + 1` or `+ 2`. FSM states: 8, or 11 (dot II = 2) and 15 (reductions at W ≥ 16). Against 2024.10 (1.5 to 4.4 cycles per beat), 2026.11 is 1.0 to 1.5 everywhere it passes except dot's II = 2 points; and in the 2024.10 flow rowsum paid one extra cycle per row, which the pipelined loop does not.

Register bits (sum of Bambu's register instances, `rtl/`): the elementwise kernels still latch both input beats and the output beat, about $3 \cdot 64W$ (vecadd W = 8: 1666, as 2024.10's 1665); at W = 1 2026.11 needs a third (322 against 1091, no runtime unrolling of BEAT any more); the reductions need 5 to 12 % fewer than 2024.10 at W ≥ 8.

## Against XLS and Vitis

Tier done at n64, cycles (cycles per beat). XLS from dslx-exercises' `notes/xls.md` (10 ns, delay model `unit`). Vitis `opt` (3.33 ns, FPGA delays) is known here only at vecadd W = 4: 16 cycles (`docs/HLS_VS_FORGE.md` section 2); its full rows are in snax-forge-experiments.

| Kernel | Tool | W = 1 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| vecadd | Bambu | 65 (1.02) | 17 (1.06) | 9 (1.12) | 5 (1.25) | failed: sim |
| vecadd | XLS | 64 (1.00) | 16 (1.00) | 8 (1.00) | 4 (1.00) | 2 (1.00) |
| dot | Bambu | 65 (1.02) | 32 (2.00) | 16 (2.00) | 6 (1.50) | 4 (2.00) |
| dot | XLS | 64 (1.00) | 16 (1.00) | 8 (1.00) | 4 (1.00) | 2 (1.00) |

With 2026.11 Bambu reaches one beat per cycle like XLS and Vitis `opt`, plus a fill of `lat - 1` cycles; the differences that remain are structural: Bambu registers the beats (XLS's datapath is combinational from port to port), and its FSM still waits on `start_port`/`done_port` per task. Area and timing at 45 nm are for synthesis.

## Differences to keep in mind

Each with where it was found.

- **Fault 2, a Bambu 2026.11 bug: wide computed beats.** When a beat wider than 24 lanes is computed (not copied) lane by lane, the low 32-bit words of lanes 26 to 30 (31 for relu) come out wrong, most of them 0. It hits every elementwise kernel at W = 32, with or without loop pipelining; 2024.10 builds the same source correctly. One-beat reproducer at 28 lanes in `notes/repro_bam3/`. Recorded, not pursued (not reported upstream yet). Evidence: `results_staging/runs/2026-11-05_bambu_probe_b2.md`, BAM3 R1.
- **The output beat must be initialized.** `set_lane` is ac_int's `set_slc`, which computes a slice's first and last 32-bit word from the old value, so an output beat declared without a value (`vec_t ..., c;`) gives an indeterminate result. 2024.10 happened to produce the intended value; 2026.11 did not (fault 1, W ≥ 8). The five elementwise kernels now declare it `= 0` (542fa32); the sources are shared with Vitis. Evidence: probe B round 2.
- **II = 2 for dot at W = 4 and 8.** Bambu reports `minII=1 maxII=3` and settles on II = 2 with no reason given; it is not short of multipliers (one per lane). W = 2 and W ≥ 16 get II = 1. Evidence: BAM3 R1.
- **Scalar pins take no handshake mode and are never registered.** `loop_count`, `len` and `alpha` are plain input wires read in every iteration, so the driver must hold them for the whole task (Vitis registers them with `ap_vld`; XLS loads them on a `cfg` channel). Handshake modes on these by-value scalars stop Bambu 2024.10 (`Interface type '...' for parameter 'loop_count' is not supported`); not rechecked on 2026.11. Evidence: `notes/bambu_probe.md`, R0 to R0c.
- **Control ports.** `start_port`/`done_port`, an `idle_port` output (2026.11) and a synchronous, active-low `reset`, not `ap_ctrl_hs`. A task starts with a one-cycle `start_port` pulse; the next may start on the cycle after `done_port` (the stall runs check two tasks back to back).
- **Top module name.** The top keeps a mangled C++ name, which changes with W; 2026.11 prefixes it with `p` (`p_Z6vecadd...`). `filelist.f`'s `# top:` is the module no other one instantiates, ignoring `panda_libtech.v`.
- **An unconnected output in every point (2024.10).** 2024.10's output-stream write module had an `out1` output left unconnected; with 2026.11 Questa's only warnings are the testbench's unconnected `idle_port`.
- **Front-end constraints** (2024.10, BAM1; not all rechecked on 2026.11). A struct `vec_t` is split into its fields (one lane per transfer); any HLS pragma in an included header breaks the interface pragmas (`Unassociated HLS pragma`); `-DW` clashes with `ac_int.h`, so the lanes come as `BAMBU_LANES`; without the LANE unroll pragma LANE stays a loop above W = 8 and the wide variable shift has no unit. Evidence: `notes/bambu_probe.md`, R0 to R0c.
- **Option names changed in 2026.11.** `--panda-parameter=` is `--bambu-parameter=` (e.g. `--bambu-parameter=LP-BB-list=0` turns loop pipelining off); `--speculative-sdc-scheduling` crashed 2024.10 on wide vecadd beats. Evidence: `notes/bambu_probe.md`, rounds A and B.
- **Questa's transcript** starts every line with `# `; `bench/bambu.py` strips it before reading the testbench's line.

## Open

- Synthesis and power in snax-forge-experiments (HSYN1: the 40 points up to W = 16, all passing; W = 32 is outside its comparison), from `rtl/<tier>/<kernel>/bambu_w<W>/filelist.f` (two Verilog files, top from `# top:`, no memories).
- Merging `results_staging/bambu_cycles.csv` into snax-forge-experiments' `results/hls/` next to Vitis's and XLS's rows.
- Fault 2 upstream: the reproducer is ready if it is to be reported (ferrandi/PandA-bambu), or rechecked on a later Bambu release.
- Vitis: settled in HSYN1 (snax-forge-experiments, 5 Nov 2026). Its R0 found that the `= 0` change leaves Vitis's `opt` Verilog unchanged (relu: one wire renamed), and Vitis's `unopt` case is retired; the Vitis points are rebuilt at 10 ns, W = 1 to 16.
- Tier A, if Bambu is kept for it.
