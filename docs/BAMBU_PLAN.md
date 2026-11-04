# Plan: Bambu against snax-forge (BAM2)

BAM2 redoes the Bambu side of this repo so it matches the XLS setup in dslx-exercises (`docs/PLAN.md` there): one case per kernel, tier done and untiered, the RTL measured by our own SystemVerilog testbench in Questa with a no-stall run for cycles and a random-stall run for correctness, and one CSV row per point with the same columns as `xls_cycles.csv`. BAM1 (`notes/bambu.md`, its probe notes and the 2026-11-03 run note) found what Bambu can and cannot do; BAM2 keeps those findings and replaces how the points are built and measured.

## 1. What is compared

The block's boundary matches snax-forge and the other tools; everything inside is what Bambu produces as is.

- One axis (ready/valid) port per stream, one beat of W lanes per transfer; lane l in bits [64l, 64l+63], lane 0 low (`bench/include/bambu/lanes.h`).
- int64 data; W = 1, 2, 4, 8, 16, 32 per hardware point.
- The run-time pins (`loop_count`, and `len` or `alpha`) are plain input wires on a Bambu top (no handshake mode is accepted, BAM1), held for the whole task. A task starts with a one-cycle `start_port` pulse and ends with `done_port`.
- The same inputs and expected outputs: each size's `data.h` in `bench/tier_<tier>/<kernel>/vectors/<size>/`, written to `.hex` files per simulation.

## 2. Settings

| Setting | Value | Why |
|---|---|---|
| Tool | Bambu 2024.10 (rev c2ba6936), in the podman image `localhost/hls-exercises-bambu:4` | BAM1: the EL8 host lacks 32-bit glibc-devel (`notes/env.md`) |
| Clock | `--clock-period=10` | The same 10 ns HLS clock for every tool |
| Device | `--device-name=nangate45` | Bambu's ASIC library; the RTL is judged in DC at 45 nm later |
| Front end | `--compiler=I386_CLANG16`, `--std=c++14`, `-DBAMBU_LANES=<W>` | BAM1 (`lanes.h` says why not `-DW`) |
| Interface | `--generate-interface=INFER`, `#pragma HLS interface port=<p> mode=axis` per array argument | Axis ports, no memory inside the block (BAM1) |
| RTL only | no `--simulate`, no `--generate-tb` | Our testbench measures; Bambu's co-simulation is no longer used |
| Build size | the largest size the point runs | The C arrays need a depth; the size reaches the hardware only through `loop_count`, so one Verilog per W serves every size (checked in R0: n64-built Verilog runs n512) |

## 3. The case

One case per kernel, `bambu`: Bambu's default setup (BAMBU-BALANCED-MP, `-O2`) plus `#pragma HLS unroll` on the line after the `LANE:` label. It is BAM1's `bambu_opt`. `bambu_unopt` is dropped: Bambu's default already unrolled LANE up to W = 8 (the same cycles as `bambu_opt` there), and above W = 8 it left LANE as a loop and failed on the wide variable shift (`failed: compile`). With LANE unrolled every lane index is a constant, so no point needs that shift. Bambu cannot pipeline loops (BAM1), so a beat still takes about 3 cycles; that is Bambu's, not the case's.

## 4. Testbench and cycles

`tb/<kernel>_tb.sv` on `tb/common.svh` (unchanged from dslx-exercises) and `tb/bambu.svh` (`tb/SOURCE` names the commit). `bambu_ctl` replaces `cfg_src`: it pulses `start_port` right after reset and again on the cycle after each `done_port`, TASKS times; the pins are constants. Bambu's reset is active low and synchronous, so the testbench connects `.reset(~rst)`. The top module is Bambu's mangled C++ name (it changes with W), passed as the `DUT` define from `filelist.f`. Plain SystemVerilog, no DPI: Questa by default, Icarus Verilog as Claude's sandbox check.

| Run | Streams | Gives |
|---|---|---|
| cycles | every input valid and every output ready on every cycle | pass/fail, `cycles`, `cycles_done`, `latency` |
| stall | random gaps on valid and ready, two tasks back to back | pass/fail only (handshakes, restart between tasks) |

$$\text{cycles} = t_{\text{last output}} - t_{\text{start}}, \qquad \text{cycles done} = t_{\text{done}} - t_{\text{start}}$$

$$\text{beats} = \frac{N}{W}, \qquad \text{overhead} = \text{cycles} - \text{beats}, \qquad \text{latency} = t_{\text{first output}} - t_{\text{first input}}$$

`cycles` is comparable with XLS's (`cfg` transfer to last output); `cycles_done` with Vitis's `ap_start` to `ap_done`. Bambu's own co-simulation reported `cycles_done + 1` at every point checked in R0 (its "Total cycles" counts both end cycles). For a reduction, `latency` spans the whole first sum, so it is not a pipeline depth.

## 5. Files

| Path | What |
|---|---|
| `bench/bambu.py` | Builds (container) and simulates (host) every point; `run`, `report`; `--sim-only` reuses `rtl/` |
| `tb/` | `common.svh`, `bambu.svh`, one testbench per kernel, `SOURCE` |
| `build/<tier>/<kernel>/w<W>/` | Scratch: the source copy, Bambu's output and log, one folder per simulation (git-ignored) |
| `rtl/<tier>/<kernel>/bambu_w<W>/` | The Verilog, `filelist.f` (`# top:`), `sizes.txt`, `cmd.txt` (Bambu version, FSM states, the added pragmas, the command) |
| `results_staging/bambu_cycles.csv` | One row per (kernel, size, W); columns as dslx-exercises' `xls_cycles.csv`, with `cycles_done`, `fsm_states`, `device` and `bambu_version` in place of `stages`, `flops`, `delay_model` and `xls_version` |
| `results_staging/report_bambu_<tier>.md` | Cycles per kernel and W, then FSM states, `cycles_done`, latency and portability |
| `results_staging/runs/` | One note per round |
| `notes/bambu.md` | Rewritten in R4 in the shape of dslx-exercises' `notes/xls.md` |

## 6. Kernels and rounds

| Kernel | Streams | Pins | Pattern |
|---|---|---|---|
| vecadd, vecmul | A, B → C | `loop_count` | elementwise |
| vsum | A → out | `loop_count`, `len` | reduction |
| dot | A, B → out | `loop_count`, `len` | reduction with a multiply |
| matadd | A, B → C | `loop_count` (m·n / W) | elementwise |
| relu | A → B | `loop_count` | elementwise |
| axpy | x, y → y_out | `loop_count`, `alpha` | elementwise |
| rowsum | A → y | `loop_count` (m·n / W), `len` (n / W) | reduction per row; W must divide n |

| Round | Where | What |
|---|---|---|
| R0 | sandbox, then server | `tb/` and `bench/bambu.py`. Sandbox (done): the 48 tier-done points on BAM1's `bambu_opt` Verilog in Icarus, all pass in both runs. Server: Bambu RTL-only build of vecadd W = 8, compared with BAM1's `bambu_opt_w8` Verilog, then both runs in Questa |
| R1 | server | Tier done (48 points): Bambu builds and Questa runs; W = 32 included |
| R2 | server | Questa on the W = 32 points' BAM1 co-simulation folder, only if R1 leaves the cause of BAM1's W = 32 failures unclear |
| R3 | server | Untiered (47 points): matadd, relu, axpy, rowsum |
| R4 | sandbox | Clean-up: Bambu out of `bench/bench.py` and the `bambu_*` cases out of params.json; `rtl/*/*/bambu_opt*`, `bambu_unopt*` and the Bambu rows of `results_staging/hls_cycles.csv` and `report_done.md` removed (a line in `notes/bambu.md` names the last commit with them); `notes/bambu.md`, `docs/HLS_VS_FORGE.md` section 3B and the README updated |

## 7. Working rules

Claude writes and checks the code in its sandbox (Icarus Verilog on Verilog already in `rtl/`) and pushes it once Ryan says so; Claude Code runs on the MICAS server for what needs it (the Bambu container, Questa, the recorded results), in this repo only. Every Claude Code prompt starts with `git pull` and a clean (`rm -rf build`), uses `-j$(nproc)` for Bambu and sets `--sim-jobs` from the free Questa licences. Commits are one short line with no co-author trailer, pushed to main. Markdown has no hard wrapping. Failures are kept as rows with a status and a reason.
