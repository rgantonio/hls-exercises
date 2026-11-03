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

# Bambu (BAM1)

Bambu (PandA, Politecnico di Milano) is the second HLS tool, with an ASIC target (`--device-name=nangate45`).

| Item | Value |
|---|---|
| Bambu | PandA 2024.10, revision c2ba6936ca2ed63137095fea0b630a1c66e20e63 |
| AppImage | `https://release.bambuhls.eu/bambu-2024.10.AppImage` (the 2024.10 GitHub release has no assets; its notes link here), 1405510848 bytes |
| AppImage sha256 | `e4f0214496a5d35de1932975b0f41cd95bc33a53a904fc565d6c2cb01df40773` (pinned in `bench/tools/get_bambu.sh`) |
| Front end | Bambu's own Clang 16.0.0 (`--compiler=I386_CLANG16`) |
| Container | image `localhost/hls-exercises-bambu:4`, Ubuntu 24.04.5, glibc 2.39, gcc 13.3.0 with multilib |
| Simulator | Verilator 5.020 (Ubuntu's package, in the image) |

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
- Questa is not used in the container. Questa 2022.4's bundled gcc 7.4 cannot link its DPI auto-compile against Ubuntu 24.04's glibc 2.39 (`unknown type [0x13] section '.relr.dyn'`, then `cannot find /lib/x86_64-linux-gnu/libc.so.6`). Questa runs on the host, in snax-forge-experiments, for gate-level and power runs, as for the Vitis points.
- Bambu prints `Warning: Mentor license file has not been specified. User must set LM_LICENSE_FILE ...` when it looks for Modelsim; it can be ignored, nothing here uses Questa.
- Bambu spells the C++ standard `--std=c++14` (not `-std=`) and has no `-isystem`.
- Co-simulation of array arguments needs `--tb-param-size=<param>:<bytes>`: for statically allocated arrays Bambu maps 1 byte per parameter, extended to 4, and its driver then segfaults (`MDPI driver: Abrupt exception: Segmentation fault`, `Sim: Read operation on uninitialized interface 2`).
- Bambu does not pass the C testbench's exit code through: with a failing `main()` it still logs `Sim: Testbench returned: 0` and exits 0, adding only `Warning: Returned error code!`. Pass or fail is the testbench's own `PASS`/`FAIL` line in `HLS_output/simulation/testbench.log`.
