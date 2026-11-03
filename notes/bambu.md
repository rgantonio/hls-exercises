# Bambu in hls-exercises (BAM1)

Summary of task BAM1: Bambu as a second HLS tool next to Vitis, for the HLS side of the snax-forge comparison. It covers what was set up, how to run it, what worked, the results of tier done and the limitations found. The probe evidence is in `notes/bambu_probe.md` (rounds R0, R0b, R0c, with `notes/bambu_probe.csv`). The tier done run is in `results_staging/runs/2026-11-03_bambu_done.md` (R1). BAM1 is closed: Bambu stays as it is.

## What it is

- **Tool**: Bambu 2024.10 (PandA, Politecnico di Milano), revision c2ba6936ca2ed63137095fea0b630a1c66e20e63, with its own Clang 16.0.0 front end (`--compiler=I386_CLANG16`). It comes from the release AppImage `https://release.bambuhls.eu/bambu-2024.10.AppImage` (the GitHub release has no assets), sha256 `e4f0214496a5d35de1932975b0f41cd95bc33a53a904fc565d6c2cb01df40773`. `bench/tools/get_bambu.sh` pins that hash and extracts the AppImage into `tools/bambu/` (git-ignored). The wrapper `tools/bin/bambu` sets the `APPDIR`, `ARGV0` and `OWD` that the extracted `AppRun` needs. `notes/bambu_help_2024.10.txt` is its `--help`.
- **Target**: ASIC, `--device-name=nangate45` (Nangate 45 nm open cell library) at `--clock-period=10` (10 ns) by default.
- **Container**: Bambu builds its front end and its co-simulation driver with `-m32`. The EL8 servers have the 32-bit glibc runtime but not `glibc-devel.i686` (no `gnu/stubs-32.h`, `crti.o`, `Scrt1.o`), and nothing is installed on them. So Bambu runs in the rootless podman image `localhost/hls-exercises-bambu:4`, built from `container/bambu/Containerfile`: Ubuntu 24.04 with gcc multilib and Verilator, plus `libtinfo5` from Ubuntu 22.04 (pinned `.deb`) for Bambu's Clang tools. Bambu itself is not in the image: the repo, with `tools/bambu/`, is bind-mounted at its own path. `bench/tools/in_bambu.sh <cmd>` runs a command in it, as the user (`--userns=keep-id`), in the caller's directory (which must be inside the repo), with PATH `tools/bin:/usr/bin:/bin`. It starts in the repo root and does the `cd` inside, because the repo is mode 700 on NFS and podman's `-w` on a subdirectory fails. `BAMBU_IMAGE` overrides the image, and `BAMBU_CONTAINER_NAME` names the container so a caller can remove it.
- **Simulator**: Verilator 5.020, the image's Ubuntu package, through Bambu's `--simulate --simulator=VERILATOR`.
- **Why not Questa in the container**: Questa 2022.4 starts in the container (with X11 libraries added), but its bundled gcc 7.4 cannot link its DPI auto-compile against Ubuntu 24.04's glibc 2.39 (`unknown type [0x13] section '.relr.dyn'`). With `DpiCppPath = /usr/bin/gcc` it linked. The segfault that followed turned out to be the missing `--tb-param-size` (below), not Questa. Questa was dropped from the container anyway. It stays on the host, in snax-forge-experiments, for gate-level and power runs. Bambu's warning that `LM_LICENSE_FILE` is unset can be ignored.
- **Versions in one place**: `notes/env.md`, section Bambu.

## How to run

Setup, once per checkout:

```bash
pixi install                                              # Python 3.11 on the host
pixi run get-bambu                                        # Bambu 2024.10 into tools/, sha256-checked
podman build -t hls-exercises-bambu:4 container/bambu     # the image
bench/tools/in_bambu.sh bambu --version                   # check
```

The bench, with the summaries written into this repo's `results_staging/` (not snax-forge-experiments):

```bash
python3 bench/bench.py run --tier done --case bambu_unopt bambu_opt --dry-run      # commands only
HLS_RESULTS=$PWD/results_staging python3 bench/bench.py run --tier done --case bambu_unopt bambu_opt -j$(nproc)
HLS_RESULTS=$PWD/results_staging python3 bench/bench.py run --tier done --kernel vecadd --case bambu_unopt --size n64 --w 8
```

No licences are needed, so `-j$(nproc)` is fine. A point that has not finished after 15 minutes is stopped (its container removed by name) and recorded as `failed: timeout`. Each point runs in `bench/tier_done/<kernel>/<case>_<size>_w<W>_proj/` (git-ignored; `make clean` removes it). Its `point.json` holds the exact command.

By hand, for one kernel (vecadd, n64, W = 8), from a scratch folder named `*_proj` so git ignores it:

```bash
mkdir -p bench/tier_done/vecadd/hand_proj && cd bench/tier_done/vecadd/hand_proj
# a copy of the source with the axis pragmas just above the top (only #pragma lines added)
sed 's/^void vecadd(/#pragma HLS interface port=A mode=axis\n#pragma HLS interface port=B mode=axis\n#pragma HLS interface port=C mode=axis\nvoid vecadd(/' ../src/vecadd.cpp > vecadd.cpp

# RTL only: writes vecadd.v here
../../../tools/in_bambu.sh bambu vecadd.cpp --top-fname=vecadd --device-name=nangate45 --clock-period=10 \
  --compiler=I386_CLANG16 --generate-interface=INFER \
  -DDATA_T=int64_t -DSIZE_N=64 -DBAMBU_LANES=8 --std=c++14 -I../../../include/bambu -I../src -I../vectors/n64

# with co-simulation: the same plus the testbench; pass or fail is the PASS/FAIL line of
# HLS_output/simulation/testbench.log (26 cycles, PASS)
../../../tools/in_bambu.sh bambu vecadd.cpp --top-fname=vecadd --device-name=nangate45 --clock-period=10 \
  --compiler=I386_CLANG16 --generate-interface=INFER --simulate --simulator=VERILATOR \
  --generate-tb=../src/tb_vecadd.cpp "--tb-extra-gcc-options=-DDUT=vecadd -DCFG_LOOP_COUNT=8" \
  --tb-param-size=A:512,B:512,C:512 \
  -DDATA_T=int64_t -DSIZE_N=64 -DBAMBU_LANES=8 --std=c++14 -I../../../include/bambu -I../src -I../vectors/n64
grep -h '^PASS\|^FAIL' HLS_output/simulation/testbench.log
```

Both were checked on 2026-11-03 (8 FSM states; 26 cycles, PASS).

## What worked

- **Axis ports** like the Vitis axis points. `--generate-interface=INFER` with `#pragma HLS interface port=<p> mode=axis` for every array argument, on the lines just above `void <top>(`, gives `<p>_TDATA`, `<p>_TVALID`, `<p>_TREADY` per port, and no memory controller inside the block. bench.py writes these pragmas into a copy of the source in the point's folder and asserts that the copy differs only by added `#pragma` lines. The kernel sources are not changed. (R0b, R0c.)
- **One beat per transfer**: `vec_t` is one `ac_int<64W, false>` from `bench/include/bambu/lanes.h`, lane i in bits [64i, 64i+63], lane 0 low, as hlslib's DataPack on the Vitis side. The lane count is passed as `-DBAMBU_LANES=<W>`, and the header defines `W` itself after including `ac_int.h`. The header carries no HLS pragmas. A W = 8 beat is one 512-bit transfer. (R0c.)
- **LANE unrolled by default** up to W = 8: Bambu's default setup (BAMBU-BALANCED-MP, `-O2`) unrolls LANE by itself, so the two cases give the same cycles there. (R0, R1.)
- **The two cases**: `bambu_unopt` (default setup, the interface pragmas only) and `bambu_opt` (the same plus `#pragma HLS unroll` on the line after the `LANE:` label). `bambu_opt` mirrors Vitis's `opt` only in the LANE unroll; there is no pipelining (Limitations).
- **Correct results**: every passing point (76 of 96 in tier done) matches the reference exactly. The kernel's own testbench checks every output against `data.h`.
- **Plain RTL**: no Bambu point instantiates a memory module (no `# ram:` line in any `filelist.f`), and every Verilog is portable (no vendor primitives; `portable` yes).
- **Same Verilog across sizes**: the same command gives the same Verilog when rerun. Between n64 and n512 the only differences in the 20 `rtl_same = no` rows are the operand order of a `SIMPLEJOIN_FU`'s `.ops({...})` (the same done signals). (R1 run note.)

## Results (tier done, n64)

Cycles from start to done in Bambu's Verilator co-simulation, with cycles per beat (cycles / (64 / W)) in brackets. From `results_staging/hls_cycles.csv`; n512 and the FSM states are in the R1 run note and `results_staging/report_done.md`.

| kernel | case | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|---|
| vecadd | bambu_unopt | 99 (1.55) | 98 (3.06) | 50 (3.12) | 26 (3.25) | failed: compile | failed: compile |
| vecadd | bambu_opt | 99 (1.55) | 98 (3.06) | 50 (3.12) | 26 (3.25) | 14 (3.50) | failed: timeout |
| vecmul | bambu_unopt | 99 (1.55) | 98 (3.06) | 50 (3.12) | 26 (3.25) | failed: compile | failed: compile |
| vecmul | bambu_opt | 99 (1.55) | 98 (3.06) | 50 (3.12) | 26 (3.25) | 14 (3.50) | failed: timeout |
| vsum | bambu_unopt | 163 (2.55) | 99 (3.09) | 51 (3.19) | 27 (3.38) | 47 (11.75) | failed: sim |
| vsum | bambu_opt | 163 (2.55) | 99 (3.09) | 51 (3.19) | 27 (3.38) | 19 (4.75) | failed: sim |
| dot | bambu_unopt | 195 (3.05) | 99 (3.09) | 51 (3.19) | 35 (4.38) | 79 (19.75) | failed: sim |
| dot | bambu_opt | 195 (3.05) | 99 (3.09) | 51 (3.19) | 35 (4.38) | 19 (4.75) | failed: sim |

The failed rows carry a `fail_reason` in the CSV. Counts over the 96 points (both sizes): 76 ok, 8 `failed: compile` (no unit for a 1024- or 2048-bit variable shift, LANE not unrolled), 4 `failed: timeout` (the co-simulation hangs on 2048-bit ports), 8 `failed: sim` (the co-simulation hits the cycle limit on 2048-bit ports).

RTL: `rtl/done/<kernel>/bambu_<unopt|opt>_w<W>/` per hardware point (Bambu's `<kernel>.v`, `filelist.f` with the top module, `sizes.txt`), and `rtl/done/<kernel>/bambu_<case>_n512_w<W>/` where n512's Verilog differs from n64's in the join order. Points with `failed: timeout` or `failed: sim` have Verilog there too (synthesis completed). Points with `failed: compile` have none.

## Limitations

Each with where it was found.

- **No loop pipelining.** `#pragma HLS pipeline` inside a loop stops the front end (`Loop pipelining pragma not supported.`, or `Unassociated HLS pragma` when an included header has HLS pragmas), and `--pipelining` applies to functions only. Every beat goes through the FSM: about 3 cycles per beat from W = 2 on, with 8 to 10 FSM states at W >= 2 (21 at W = 1). Evidence: `--help` (`notes/bambu_help_2024.10.txt`); notes/bambu_probe.md, R0 Findings (pipelining, with the compile-only check that gives the message without header pragmas); R1 run note.
- **Scalar pins take no handshake mode and are never registered.** `loop_count` and `len` are plain input wires that feed the loop's comparators in every iteration, so a driver must hold them for the whole run (Vitis registers them with `ap_vld`). `mode=ap_vld`, `ap_hs` and `ap_ack` on these by-value scalars all stop Bambu: `Interface type '<valid|handshake|acknowledge>' for parameter 'loop_count' is not supported`. Evidence: notes/bambu_probe.md, R0 Findings (loop_count), R0b Findings, R0c Findings.
- **No unit for wide variable shifts.** Without unroll, LANE stays a loop, and writing a lane (`set_slc` with a variable index) needs a variable shift of the 64W-bit value. At 1024 and 2048 bits Bambu has no functional unit: `Vertices not completely allocated`. This is why `bambu_unopt` fails at W >= 16 for vecadd and vecmul. vsum and dot only read lanes and do synthesize, at 11.75 and 19.75 cycles per beat at W = 16. Evidence: notes/bambu_probe.md, R0c Findings; R1 run note, Failures.
- **Co-simulation fails at 2048-bit ports (W = 32)** although synthesis completes. vecadd and vecmul `bambu_opt` hang: the Verilator model waits with 0 s of CPU until the timeout. vsum and dot run to Bambu's limit of 200,000,000 cycles without `done` (`Simulation not terminated!`), and the testbench reads 0. The cause was not found. Evidence: notes/bambu_probe.md, R0c Findings; R1 run note, Failures.
- **Structs are split into their fields.** A `vec_t` that is a struct of W lanes gives 64-bit ports and one lane per transfer (17.25 cycles per beat at W = 8 against 3.25 with one `ac_int`). Evidence: notes/bambu_probe.md, R0b Findings.
- **Any HLS pragma in an included header breaks the interface pragmas.** With `#pragma HLS INLINE` in `lanes.h`, every `#pragma HLS interface` above the top fails with `Unassociated HLS pragma`. Evidence: notes/bambu_probe.md, R0 Findings (port modes, bisected in compile-only checks).
- **`-DW` clashes with `ac_int.h`.** Bambu's `ac_int.h` (also reached through its `ap_int.h`, so through hlslib's DataPack) stops with `One or more of the following is defined: W, I, S, W2, I2, S2`. Bambu's generated co-simulation files include `ac_int.h` directly with the command's -D flags, so no header trick helps: the lane count must come under another name (`BAMBU_LANES`). Evidence: notes/bambu_probe.md, R0 "What was run" and R0c "What was run".
- **`--top-rtldesign-name` has no effect on C++ tops.** The top module keeps its mangled name (e.g. `_Z6vecaddPK6ac_intILi512ELb0EES2_PS0_j`, which changes with W). bench.py takes `filelist.f`'s `# top:` from the Verilog: the module no other one instantiates. Evidence: R1 run note, "Against R0c".
- **`--tb-param-size` is required** for every array argument. Without it, Bambu maps 4 bytes per statically allocated array and its co-simulation driver segfaults (`MDPI driver: Abrupt exception: Segmentation fault`). Evidence: notes/bambu_probe.md, R0 "What was run"; `notes/env.md`.
- **Bambu exits 0 on a failing testbench** and logs `Testbench returned: 0`. Pass or fail comes only from the testbench's `PASS`/`FAIL` line in `HLS_output/simulation/testbench.log`, as bench.py does. Evidence: notes/bambu_probe.md, R0 "What was run"; `notes/env.md`.
- **`-O0` is compiled as `-O1`** (the level in Bambu's compile flags). Evidence: notes/bambu_probe.md, R0 Findings.
- **BAMBU-AREA cannot build W = 8 with beat-wide ports.** Under `-Os` LANE is not unrolled, and the 512-bit variable shift has no unit. With R0's memory ports and struct header it built, at 4754 cycles. Evidence: notes/bambu_probe.md, R0c Findings (AREA) and R0 Findings.

## Open

- The W = 32 points (`failed: timeout`, `failed: sim`) are to be checked with snax-forge-experiments' own testbench, which drives the synthesized netlist independently of Bambu's co-simulation. Their Verilog is in `rtl/`.
- Synthesis and power of the Bambu points in snax-forge-experiments (`syn/syn.py` from the `filelist.f` files; their top is the mangled module name).
- `results_staging/` (hls_cycles.csv with the `tool`, `fsm_states` and `fail_reason` columns, report_done.md, runs/) is to be merged into `snax-forge-experiments/results/hls/` once that checkout is free.
- The untiered kernels (matadd, relu, rowsum, axpy) were not run with Bambu; their params.json have no Bambu cases.
