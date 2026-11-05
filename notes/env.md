# Probe A: Version

```bash
****** Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2.2 (64-bit)
  **** SW Build 4101106 on Feb  9 2024
  **** IP Build 4126054 on Fri Feb  9 11:39:09 MST 2024
  **** SharedData Build 4115275 on Tue Jan 30 00:40:57 MST 2024
    ** Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
    ** Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
```

# Probe B: Part

Note that the `xcku5p-ffvb676-2-e` exists in the system.

```bash
INFO: [HLS 200-1510] Running: set_part xcku5p-ffvb676-2-e 
INFO: [HLS 200-1611] Setting target device to 'xcku5p-ffvb676-2-e'
INFO: [HLS 200-1510] Running: create_clock -period 3.33 -name default 
INFO: [SYN 201-201] Setting up clock 'default' with a period of 3.33ns.
INFO: [HLS 200-1510] Running: config_compile -pipeline_loops 0 
INFO: [HLS 200-1510] Running: csim_design 
```

# Probe C: Clock Uncertainty

You get this from `*_csynth.rpt`. So we have enough uncertainty.
Note that this example was taken from `tiny_csynth.rpt`

```bash
+ Timing: 
    * Summary: 
    +--------+---------+----------+------------+
    |  Clock |  Target | Estimated| Uncertainty|
    +--------+---------+----------+------------+
    |ap_clk  |  3.33 ns|  1.016 ns|     0.90 ns|
    +--------+---------+----------+------------+
```

# Probe D: 

Check the `run_hls_probe.tcl` inside the `hls-exercises/exercises/s0_flow/01_project_anatomy` and you will see the comparison with and without the `config_compile -pipeline_loops 0`.

# You can probe or see the RTL schematic in vivado

Try:

```tcl
# schem.tcl
# vivado -mode batch -source schem.tcl -tclargs fir_proj/pipe fir3
set sol [lindex $argv 0]
set top [lindex $argv 1]
read_verilog [glob $sol/syn/verilog/*.v]
synth_design -rtl -top $top -part xcku5p-ffvb676-2-e
# Line below only works when available
# write_schematic -format pdf -force $sol/${top}_rtl.pdf
start_gui
```


# Probe E: `__RTL_SIMULATION__` in cosim

Not defined for the testbench on 2023.2.2. In S2.1.1 the testbench guarded `N_RANDOM` with `#ifdef __RTL_SIMULATION__` (1 in cosim, 16 in csim). Cosim still printed `N_RANDOM=16` and ran 20 transactions (`// RTL Simulation : 0 / 20`), and the preprocessed copy in `<proj>/<sol>/sim/wrapc/*_pre.cpp.tb.cpp` holds `N_RANDOM = 16`. Use one constant sized for cosim instead of the `#ifdef`. Confirmed again in S2.1.3: every cosim ran 68 transactions (4 directed + 64 random) although the `#ifdef` asked for 4 random vectors.

# Bambu (BAM1, BAM2)

Bambu (PandA, Politecnico di Milano) is the second HLS tool, with an ASIC target (`--device-name=nangate45`).

| Item | Value |
|---|---|
| Bambu | PandA 2024.10, revision c2ba6936ca2ed63137095fea0b630a1c66e20e63 |
| AppImage | `https://release.bambuhls.eu/bambu-2024.10.AppImage` (the 2024.10 GitHub release has no assets; its notes link here), 1405510848 bytes |
| AppImage sha256 | `e4f0214496a5d35de1932975b0f41cd95bc33a53a904fc565d6c2cb01df40773` (pinned in `bench/tools/get_bambu.sh`) |
| Front end | Bambu's own Clang 16.0.0 (`--compiler=I386_CLANG16`) |
| Container | image `localhost/hls-exercises-bambu:4`, Ubuntu 24.04.5, glibc 2.39, gcc 13.3.0 with multilib |
| Simulator (BAM2) | Questa Sim-64 2022.4 on the host for `tb/` (`bench/bambu.py --sim questa`); Icarus Verilog 12.0 in Claude's sandbox (`--sim icarus`) |
| Simulator (BAM1) | Verilator 5.020 (Ubuntu's package, in the image), through Bambu's `--simulate`; not used from BAM2 on |

Setup:

```bash
pixi install                                   # Python 3.11 on the host
pixi run get-bambu                             # download, check sha256, extract into tools/bambu/, write tools/bin/bambu
podman build -t hls-exercises-bambu:4 container/bambu
bench/tools/in_bambu.sh bambu --version        # every Bambu call goes through the container
```

- `get_bambu.sh` extracts the AppImage with `--appimage-extract` (no FUSE). The wrapper `tools/bin/bambu` sets `APPDIR`, `ARGV0=bambu` and `OWD`, which the AppImage runtime would normally set and which the extracted `AppRun` (`usr/bin/tool_select.sh`) needs.
- Why a container: Bambu compiles the kernel and builds its co-simulation driver and testbench with `-m32`. This EL8 server has the 32-bit glibc runtime but not `glibc-devel.i686` (no `gnu/stubs-32.h`, `crti.o`, `Scrt1.o`, 32-bit `libm.so`), and nothing is installed on the host. The container also keeps Bambu off the host PATH, where another project's pixi `ld` came first.
- `container/bambu/Containerfile`: `ubuntu:24.04` with `gcc-multilib g++-multilib libc6-dev-i386 make python3 verilator ca-certificates`, plus `libtinfo5` 6.3-2ubuntu0.3 from Ubuntu 22.04 (jammy-updates `.deb`, sha256 pinned in the Containerfile). Bambu's own `clang++-16`, `opt-16`, `llvm-link-16` and `ld.lld-16` link `libtinfo.so.5`; Bambu's generated simulate script clears `LD_LIBRARY_PATH`, so they do not find the AppImage's copy, and Ubuntu 24.04 packages only libtinfo6. Bambu is not copied into the image: `tools/bambu/` comes with the repo mount.
- `bench/tools/in_bambu.sh <cmd> [args]`: `podman run --rm -i --userns=keep-id` (files stay owned by the user), the repo bind-mounted at its host path, `HOME=/tmp`, PATH `tools/bin:/usr/bin:/bin`. It starts in the repo root and does the `cd` to the caller's directory inside, as the user: the repo is mode 700 on NFS, and runc resolves `-w` as the container's root, so `-w <subdirectory>` fails with `mkdir ...: permission denied`. `BAMBU_IMAGE` overrides the image, `BAMBU_CONTAINER_NAME` names the container.
- Questa is not used in the container (from BAM2 on it runs `tb/` on the host, no DPI). Questa 2022.4's bundled gcc 7.4 cannot link its DPI auto-compile against Ubuntu 24.04's glibc 2.39 (`unknown type [0x13] section '.relr.dyn'`, then `cannot find /lib/x86_64-linux-gnu/libc.so.6`). Questa runs on the host, in snax-forge-experiments, for gate-level and power runs, as for the Vitis points.
- Bambu prints `Warning: Mentor license file has not been specified. User must set LM_LICENSE_FILE ...` when it looks for Modelsim; it can be ignored.
- Bambu spells the C++ standard `--std=c++14` (not `-std=`) and has no `-isystem`.
- (BAM1, Bambu's co-simulation) Co-simulation of array arguments needs `--tb-param-size=<param>:<bytes>`: for statically allocated arrays Bambu maps 1 byte per parameter, extended to 4, and its driver then segfaults (`MDPI driver: Abrupt exception: Segmentation fault`, `Sim: Read operation on uninitialized interface 2`).
- (BAM1, Bambu's co-simulation) Bambu does not pass the C testbench's exit code through: with a failing `main()` it still logs `Sim: Testbench returned: 0` and exits 0, adding only `Warning: Returned error code!`. Pass or fail is the testbench's own `PASS`/`FAIL` line in `HLS_output/simulation/testbench.log`.

# Bambu 2026.11 (BAM3)

Bambu 2026.11 pipelines innermost single-block loops (2024.10 cannot), so BAM3 builds it from its git tag and keeps it next to 2024.10. It runs in the same container (`localhost/hls-exercises-bambu:4`) through `bench/tools/in_bambu.sh bambu-2026.11 ...`.

| Item | Value |
|---|---|
| Bambu | PandA 2026.11, tag `2026.11`, commit cda4db2e724df357f749c0c41b12bdc065462ced (2026-11-04) |
| Build route | Bambu's containerized AppImage build (README "AppImage (Docker) quick commands"): `etc/scripts/appimage_build_in_container.sh`, run by `bench/tools/build_bambu_2611.sh` |
| Build image | `docker.io/bambuhls/dev:xenial-24.08` (digest sha256:5480449bfeb5826b57ab562780297f989da5dab424ec93078855589c19a35d0f), Ubuntu 16.04, gcc 13.3.0, cmake 3.26.6, appimagetool in /opt |
| Bundled compiler | clang 16.0.6 (`PANDA_DIST_COMPILERS=clang-16`, downloaded inside the container); `--compiler=I386_CLANG16` is the only choice in `--help`; libbambu falls back from I386_CLANG13 to I386_CLANG16 |
| AppImage | `tools/bambu-2026.11/bambu-2026.11.AppImage`, 341906624 bytes, sha256 `1fdc0ea0b11c0bbdc0c137ee6a8516154a82137de53a57450c36a62a934a48a0`; GLIBC audit max GLIBC_2.17 |
| Installed | `tools/bambu-2026.11/squashfs-root/` (1.1 GB) and the wrapper `tools/bin/bambu-2026.11` (APPDIR, ARGV0=bambu, OWD, as for 2024.10) |
| Disk | sources with submodules 396 MB; build tree `tools/src/build-2026.11/` 4.3 GB (clang bundles 2.1 GB, AppDir 1.4 GB, cmake build 583 MB, ccache 289 MB); 1.4 TB free on the volume |
| Build time | 743 s for the container step (configure, 2383 ninja steps, install, audit, appimagetool) on 32 cores, empty ccache, clang-16 already downloaded by the first attempt |

Rebuild: `pixi run bash bench/tools/build_bambu_2611.sh` (stages `sources`, `bundle`, `install`; log `tools/src/build-2026.11.log`). `pixi run` provides cmake 4.4.5 (the host has 3.3.2).

What had to be fixed against the README's two commands (no Bambu source changed):
- The README's host `cmake -S . -B build -DPANDA_APPIMAGE_BUILD_ENV=container ...` runs the whole project configure on the host before the container starts. It stops on GCC < 13 (host 8.5.0), then wants Boost, zlib, flex/bison and a host clang with headers for the plugin probe. That configure only renders `etc/appimage/appimage_compat_cache_init.cmake.in` and calls the container script, so the build script renders the template with `cmake -P` (`configure_file @ONLY`, the values of a default configure plus `PANDA_APPIMAGE_NAME=bambu-2026.11`, `PANDA_DIST_COMPILERS=clang-16`; the template forces `PANDA_SYNC_PARAMETER_METADATA=OFF`) and calls `appimage_build_in_container.sh` with the arguments the `appimage_bundle` target passes. The configure, build and install that matter run inside the container, as in the README.
- The container script runs `podman run --user $(id -u):$(id -g)` with no user namespace option. Rootless podman maps that uid to a subuid, which can neither read `/src` nor write `/build` on the mode-700 NFS tree (`Permission denied`). `PODMAN_USERNS=keep-id` in the script's environment fixes it.
- The top `CMakeLists.txt` stops when `git submodule status --recursive` shows any uninitialized submodule, so the four `examples/` submodules (CHStone, MachSuite, GAPBS, PolyBenchC) are checked out too (`--depth 1`), though the build does not use them.

Notes:
- `PANDA_ENABLE_OPT=ON` (the default) builds with `-Ofast -march=native`: this binary is tuned to the build server's CPU (Skylake). Rebuild it on a machine with an older CPU if it stops with an illegal instruction there.
- appimagetool writes the AppImage inside the AppDir it packs, so the extracted tree holds a 0-byte `bambu-2026.11.AppImage`; it is harmless.
- 2026.11 writes `panda_libtech.v` (library modules) next to `<kernel>.v`; 2024.10 wrote one file.
- Smoke test (not recorded), vecadd W = 8 with the `bambu` case's source copy and command, binary `bambu-2026.11`: builds in 13 s, 8 FSM states (2024.10: 8), and the LANE-unrolled loop is pipelined: `II=1 solution found for loop (BB2)`, iteration latency 2, `Initiation Interval (II) ... BB2 = 1`.
