# Bambu probe: vecadd at n64 (BAM1 R0)

What Bambu 2024.10 generates for `bench/tier_done/vecadd` under its settings, measured before the Bambu cases are chosen. This note measures and reports; it decides nothing. Data: `notes/bambu_probe.csv` (one row per run), written by `bench/probe/bambu/probe.py` (`pixi run probe-bambu`). The run folders are in `bench/probe/bambu/runs/<id>/` (not tracked).

## What was run

- Bambu: PandA 2024.10 (revision c2ba6936), front end Clang 16.0.0 (`--compiler=I386_CLANG16`), in container `localhost/hls-exercises-bambu:4` (Ubuntu 24.04, `bench/tools/in_bambu.sh`). Simulator: Verilator 5.020 in the container. Setup and versions: `notes/env.md`, section Bambu.
- Kernel: `bench/tier_done/vecadd/src/vecadd.cpp`, `tb_vecadd.cpp` and `vectors/n64/data.h`, unchanged. Each run compiles a generated copy of `vecadd.cpp` in its run folder in which only pragma lines are added (`runs/<id>/vecadd.cpp.diff`; probe.py asserts that every changed line is an added `#pragma` line).
- Header: every run uses the probe header `bench/probe/bambu/include/lanes.h` (vec_t a struct of W int64 lanes, int64 at W = 1; same names as `bench/include/lanes.h`, `#pragma HLS INLINE` kept). The original header cannot be used: hlslib's DataPack pulls in Bambu's `ap_int.h` -> `ac_int.h`, which stops with `One or more of the following is defined: W, I, S, W2, I2, S2` because of `-DW`.
- Base options of every run: `--top-fname=vecadd --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --simulate --simulator=VERILATOR --generate-tb=tb_vecadd.cpp --tb-extra-gcc-options="-DDUT=vecadd -DCFG_LOOP_COUNT=<64/W>" --tb-param-size=A:512,B:512,C:512`, plus bench.py's flags for vecadd at n64 with the DaCe-only flags dropped: `-DDATA_T=int64_t -DSIZE_N=64 -DW=<W> -I<probe include> -I<vecadd/src> -I<vectors/n64> --std=c++14 -DHLSLIB_SYNTHESIS -DAP_INT_MAX_W=4096 -I<bench/include> -I<bench/gen/dace_include>`. The full command of each run is the CSV's `bambu_cmd`.
- `--tb-param-size` is needed: without it Bambu maps 4 bytes per array argument and its co-simulation driver segfaults (`MDPI driver: Abrupt exception: Segmentation fault`). Bambu notes that the option disables its own automated check of the top function. The check is `tb_vecadd.cpp`: every output against `EXP_C`, and the run passes only on its `PASS vecadd ...: 0 of 64 outputs differ` line in `HLS_output/simulation/testbench.log` (Bambu itself exits 0 and logs `Testbench returned: 0` even when the testbench prints `FAIL`, step 2).
- Parallelism: all 30 runs at once (J = nproc = 32), timeout 10 minutes per run.
- Groups:
  - A (18): W in {1, 8} x `--experimental-setup` in {default (BAMBU-BALANCED-MP), BAMBU-AREA, BAMBU-PERFORMANCE} x pragmas in {none, unroll on LANE, unroll on LANE plus pipeline II=1 on BEAT}; Bambu's default ports.
  - B (4): W in {1, 8} x {-O0, -O3}, default setup, no pragmas, default ports.
  - C (8): W in {1, 8} x pragmas in {none, unroll plus pipeline} x port mode in {fifo, axis}, with `--generate-interface=INFER` and an interface pragma on A, B and C.
  - X (Questa against Verilator) was dropped: Questa is not used in the container (`notes/env.md`).
- Pragma placement (the diffs, as in `runs/<id>/vecadd.cpp.diff`):
  - `#pragma HLS unroll` on the line after the `LANE:` label, right before LANE's `for`. Bambu maps it onto Clang's loop hint, which must come before the loop; first in the loop body, Clang stops with `expected a for, while, or do-while loop to follow '#pragma unroll'` (tried once, compile only).
  - `#pragma HLS pipeline II=1` first in BEAT's body, where Vitis takes it.
  - `#pragma HLS interface port=<A|B|C> mode=<fifo|axis>` on the three lines before `void vecadd(`, where Bambu's own tests put them (`panda_regressions/hls/bambu_interface_test/simple_c4_fifo.c`, `simple_c4_axis.c`).
- Columns of the CSV beyond the requested ones: `adder_widths` (every adder instance by module and output width), `loop_count_sinks` (the instances whose port is wired to the datapath's `in_port_loop_count`), `warnings` (Bambu's distinct `Warning:` lines) and `message` (the error lines of a failed run). `adders` counts the instances of `*plus_expr_FU` modules in the generated Verilog other than `ui_pointer_plus_expr_FU` (address arithmetic); the table shows the total and, in brackets, the 64-bit ones (the data adds). `opt_level` is the level in Bambu's compile flags (`CFLAGS` of the generated `simulate_*.sh`). `cycles` is Bambu's `Total cycles` of the simulation (start to done). `beat_pipelined` and `II` come from Bambu's log, which never mentions pipelining in these runs; `II` is empty throughout.

## Results

Counts:

- A: fail: compile 6, pass 12
- B: pass 4
- C: fail: compile 8

| id | W | setup | -O | pragmas | ports | status | cycles | cycles/beat | adders (64-bit) | FSM states | memory modules | Bambu's message |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A_w1_def_none | 1 | default | -O2 | none | default | pass | 195 | 3.047 | 8 (5) | 20 | BMEMORY_CTRLN x1 |  |
| A_w1_def_unroll | 1 | default | -O2 | unroll | default | pass | 195 | 3.047 | 8 (5) | 20 | BMEMORY_CTRLN x1 |  |
| A_w1_def_unroll_pipeline | 1 | default |  | unroll+pipeline | default | fail: compile |  |  |  |  |  | line 10: Unassociated HLS pragma |
| A_w1_area_none | 1 | BAMBU-AREA | -Os | none | default | pass | 258 | 4.031 | 2 (1) | 7 | BMEMORY_CTRL x1 |  |
| A_w1_area_unroll | 1 | BAMBU-AREA | -Os | unroll | default | pass | 258 | 4.031 | 2 (1) | 7 | BMEMORY_CTRL x1 |  |
| A_w1_area_unroll_pipeline | 1 | BAMBU-AREA |  | unroll+pipeline | default | fail: compile |  |  |  |  |  | line 10: Unassociated HLS pragma |
| A_w1_perf_none | 1 | BAMBU-PERFORMANCE | -O3 | none | default | pass | 259 | 4.047 | 8 (5) | 25 | BMEMORY_CTRL x1 |  |
| A_w1_perf_unroll | 1 | BAMBU-PERFORMANCE | -O3 | unroll | default | pass | 259 | 4.047 | 8 (5) | 25 | BMEMORY_CTRL x1 |  |
| A_w1_perf_unroll_pipeline | 1 | BAMBU-PERFORMANCE |  | unroll+pipeline | default | fail: compile |  |  |  |  |  | line 10: Unassociated HLS pragma |
| A_w8_def_none | 8 | default | -O2 | none | default | pass | 106 | 13.25 | 9 (8) | 16 | BMEMORY_CTRLN x1 |  |
| A_w8_def_unroll | 8 | default | -O2 | unroll | default | pass | 106 | 13.25 | 9 (8) | 16 | BMEMORY_CTRLN x1 |  |
| A_w8_def_unroll_pipeline | 8 | default |  | unroll+pipeline | default | fail: compile |  |  |  |  |  | line 10: Unassociated HLS pragma |
| A_w8_area_none | 8 | BAMBU-AREA | -Os | none | default | pass | 4754 | 594.25 | 6 (1) | 16 | ARRAY_1D_STD_BRAM x3, ARRAY_1D_STD_BRAM_SP x1, BMEMORY_CTRL x1, BRAM_MEMORY_CORE x1, BRAM_MEMORY_CORE_SMALL x1, TRUE_DUAL_PORT_BYTE_ENABLING_RAM x1 |  |
| A_w8_area_unroll | 8 | BAMBU-AREA | -Os | unroll | default | pass | 202 | 25.25 | 9 (8) | 28 | BMEMORY_CTRL x1 |  |
| A_w8_area_unroll_pipeline | 8 | BAMBU-AREA |  | unroll+pipeline | default | fail: compile |  |  |  |  |  | line 10: Unassociated HLS pragma |
| A_w8_perf_none | 8 | BAMBU-PERFORMANCE | -O3 | none | default | pass | 202 | 25.25 | 9 (8) | 28 | BMEMORY_CTRL x1 |  |
| A_w8_perf_unroll | 8 | BAMBU-PERFORMANCE | -O3 | unroll | default | pass | 202 | 25.25 | 9 (8) | 28 | BMEMORY_CTRL x1 |  |
| A_w8_perf_unroll_pipeline | 8 | BAMBU-PERFORMANCE |  | unroll+pipeline | default | fail: compile |  |  |  |  |  | line 10: Unassociated HLS pragma |
| B_w1_O0 | 1 | default | -O1 | none | default | pass | 194 | 3.031 | 2 (1) | 6 | BMEMORY_CTRLN x1 |  |
| B_w1_O3 | 1 | default | -O3 | none | default | pass | 195 | 3.047 | 8 (5) | 20 | BMEMORY_CTRLN x1 |  |
| B_w8_O0 | 8 | default | -O1 | none | default | pass | 4754 | 594.25 | 6 (1) | 16 | ARRAY_1D_STD_BRAM_NN x3, ARRAY_1D_STD_BRAM_NN_SP x1, BMEMORY_CTRLN x1, BRAM_MEMORY_NN_CORE x1 |  |
| B_w8_O3 | 8 | default | -O3 | none | default | pass | 106 | 13.25 | 9 (8) | 16 | BMEMORY_CTRLN x1 |  |
| C_w1_fifo_none | 1 | default |  | none | fifo | fail: compile |  |  |  |  |  | line 6: Unassociated HLS pragma; line 7: Unassociated HLS pragma; line 8: Unassociated HLS pragma |
| C_w1_axis_none | 1 | default |  | none | axis | fail: compile |  |  |  |  |  | line 6: Unassociated HLS pragma; line 7: Unassociated HLS pragma; line 8: Unassociated HLS pragma |
| C_w1_fifo_unroll_pipeline | 1 | default |  | unroll+pipeline | fifo | fail: compile |  |  |  |  |  | line 6: Unassociated HLS pragma; line 7: Unassociated HLS pragma; line 8: Unassociated HLS pragma; line 13: Unassociated HLS pragma |
| C_w1_axis_unroll_pipeline | 1 | default |  | unroll+pipeline | axis | fail: compile |  |  |  |  |  | line 6: Unassociated HLS pragma; line 7: Unassociated HLS pragma; line 8: Unassociated HLS pragma; line 13: Unassociated HLS pragma |
| C_w8_fifo_none | 8 | default |  | none | fifo | fail: compile |  |  |  |  |  | line 6: Unassociated HLS pragma; line 7: Unassociated HLS pragma; line 8: Unassociated HLS pragma |
| C_w8_axis_none | 8 | default |  | none | axis | fail: compile |  |  |  |  |  | line 6: Unassociated HLS pragma; line 7: Unassociated HLS pragma; line 8: Unassociated HLS pragma |
| C_w8_fifo_unroll_pipeline | 8 | default |  | unroll+pipeline | fifo | fail: compile |  |  |  |  |  | line 6: Unassociated HLS pragma; line 7: Unassociated HLS pragma; line 8: Unassociated HLS pragma; line 13: Unassociated HLS pragma |
| C_w8_axis_unroll_pipeline | 8 | default |  | unroll+pipeline | axis | fail: compile |  |  |  |  |  | line 6: Unassociated HLS pragma; line 7: Unassociated HLS pragma; line 8: Unassociated HLS pragma; line 13: Unassociated HLS pragma |

Every passing run has the same top ports (Bambu's MINIMAL interface): `clock reset start_port A B C loop_count M_Rdata_ram M_DataRdy done_port Mout_oe_ram Mout_we_ram Mout_addr_ram Mout_Wdata_ram Mout_data_ram_size`. A, B and C are 32-bit base addresses, and the arrays are read and written through the `M*_ram` memory master ports. Default setup (BAMBU-BALANCED-MP, `--channels-type=MEM_ACC_NN --channels-number=2`) and -O0/-O3: two channels, `M_Rdata_ram` 128 bits, controller `BMEMORY_CTRLN`. BAMBU-AREA and BAMBU-PERFORMANCE: one channel, `M_Rdata_ram` 64 bits, `BMEMORY_CTRL`.

## Findings

- Default setup unrolls LANE at W = 8 by itself: A_w8_def_none has eight 64-bit adders, and `#pragma HLS unroll` changes nothing (same 106 cycles, 9 adders, 16 states). BAMBU-PERFORMANCE also unrolls it without the pragma (eight 64-bit adders, 202 cycles). BAMBU-AREA (-Os) does not: A_w8_area_none has one 64-bit adder, keeps the beat's lanes in local memories (`ARRAY_1D_STD_BRAM` x3 and more) and takes 4754 cycles; with the unroll pragma it gets eight adders, no local memories and 202 cycles.
- At W = 1, LANE has one iteration and the unroll pragma changes nothing in any setup. Default and PERFORMANCE at W = 1 instantiate five 64-bit adders and wire `loop_count` into a right shift, a bit-and, a less-than and an equality. That is what runtime unrolling of BEAT by four plus a remainder loop produces (4 + 1 adds; trip count >> 2 and & 3). AREA, and B's -O0, keep one 64-bit adder.
- No setting pipelines BEAT. Bambu's log has no pipelining report in any run, and Bambu pipelines only functions (`--pipelining=<func>[=II]`, `--help`). `#pragma HLS pipeline II=1` in BEAT stops the front end in all six A runs and all four C runs that have it: `vecadd.cpp:10:13: error: Unassociated HLS pragma` (line 13 in C). In a compile-only check with no HLS pragma in any included header (lanes.h replaced by the same typedefs and templates without `#pragma HLS INLINE`, W = 1), the same pragma gives `error: Loop pipelining pragma not supported.` (`runs/explore/f5_pipe`).
- What changes cycles: the memory channels and the optimisation level. W = 8: default 106 cycles (13.25 per beat), PERFORMANCE and AREA with unroll 202 (25.25 per beat: one 64-bit channel against two), AREA without unroll and -O0 4754. W = 1: default 195 (3.05 per beat), -O0 194 with two adders against eight, AREA 258, PERFORMANCE 259. -O3 under the default setup gives the same cycles, adders and states as -O2 at both widths.
- What changes adders: LANE unrolling at W = 8 (8 against 1 64-bit adders) and BEAT's runtime unrolling at W = 1 (5 against 1). The 32-bit and 30-bit adders are loop counters and trip-count arithmetic: up to five 32-bit adders in the non-unrolled W = 8 runs.
- `-O0` is not what Bambu compiles with: B_w1_O0 and B_w8_O0 show `-O1` in Bambu's compile flags (`CFLAGS` of `simulate_*.sh`), although the command has `-O0`. Their results match AREA's at W = 8 (4754 cycles, local memories) and differ from it at W = 1 (194 against 258 cycles: two channels against one).
- Port modes: none worked. All eight C runs stop in the front end with `Unassociated HLS pragma` on the three interface pragma lines (6 to 8). The front end stops before Bambu checks the argument types, so these runs do not show whether fifo or axis would need `hls::stream` or `ac_channel` arguments; the compile-only fifo check below accepted the array arguments. Cause, found by bisecting (compile only, `runs/explore/`): the `#pragma HLS INLINE` lines in the included `lanes.h`. With lanes.h replaced by the same typedefs and templates without those pragmas, the same fifo pragmas are accepted (`f4_nolanes`, W = 1). Its top ports are then `clock reset start_port A_dout B_dout loop_count A_empty_n B_empty_n C_full_n done_port A_read B_read C_din C_write`. Small C++ files with the pragmas before the function pass with and without a prior declaration, a declaration in a header, typedef'd types, a `const int` array size, loop labels, `<cstdint>`, `--std=c++14`, the bench's -D flags, or a template with `#pragma HLS INLINE` in the same file (`m_*`, `v_*`). The original `bench/include/lanes.h` has the same INLINE pragmas.
- loop_count is read inside the loop, not sampled once. Checked on A_w1_def_none and A_w8_def_none. A_w1_def_unroll_pipeline and A_w8_def_unroll_pipeline produced no Verilog (front-end error), so A_w1_def_unroll and A_w8_def_unroll were checked in their place. In all four, the datapath input `in_port_loop_count` goes straight into the loop's comparison units, with no register between the port and them. At W = 8: `ui_eq_expr_FU` x2, the exit test `b + 1 == loop_count` taken in every iteration and `loop_count == 0` at entry. At W = 1: `ui_eq_expr_FU`, `ui_lt_expr_FU`, `ui_rshift_expr_FU`, `ui_bit_and_expr_FU`. No `register_*` instance takes `in_port_loop_count` as an input, in these four or in any other passing run (`loop_count_sinks` in the CSV, from the connections in the Verilog; the W = 8 datapath was also read by hand, `vecadd.v` lines 1203–1212 of step 2's run). The value on the port is used from start to done.
- Questa against Verilator: not done (group X dropped). Questa does not run in the container (`notes/env.md`).
- Warnings: the only `Warning:` line in the passing runs is `This function uses unknown addresses: <top>`, one per run. Bambu's memory allocation also notes `Spec may not exploit DATA bus width`, `Spec accesses data having an address unknown at compile time` and `Code has LOADs or STOREs with unaligned accesses` (log lines without `Warning:`).

## Round 2: streams (R0b)

R0's default interface puts a memory controller inside the block (`BMEMORY_CTRLN`, `M*_ram` master ports). R0b measures the stream form: A, B and C as fifo or AXI4-Stream ports, as at the Vitis axis points. It decides nothing.

### What was run

- Group D, 24 runs, n64: W in {1, 8, 32} x setup in {default (BAMBU-BALANCED-MP), BAMBU-AREA} x port mode in {fifo, axis} x loop_count in {no pragma, `#pragma HLS interface port=loop_count mode=ap_vld`}. No unroll or pipeline pragmas.
- Same base options, testbench, `--tb-param-size=A:512,B:512,C:512` and pass/fail rule as R0, plus `--generate-interface=INFER`. The pragmas are added before `void vecadd(` in the run's copy of vecadd.cpp: `#pragma HLS interface port=A mode=<fifo|axis>`, the same for B and C, and the loop_count line in the ap_vld runs.
- Header: `bench/probe/bambu/include_stream/lanes.h`, the R0 probe header without its four `#pragma HLS INLINE` lines (plain `inline`). With them, the interface pragmas fail with `Unassociated HLS pragma` (R0, group C). R0's header and rows are unchanged.
- probe.py: `pixi run probe-bambu --only D` (all 24 at once, J = 32). Its rows are merged into `notes/bambu_probe.csv`, which gains a column `loop_count_registered`: yes when a register takes the datapath's `in_port_loop_count` as an input, no when only combinational units do (the same one-level connection check as `loop_count_sinks`).
- RTL kept for review in `notes/bambu_rtl/<id>/` (`pixi run probe-bambu --keep-rtl <id> ...`): Bambu's `vecadd.v` (every module in one file; no simulation files), `filelist.f` in the form of rtl/ (`# top:` line, then the file) and `cmd.txt` with the exact Bambu command. Kept: `A_w8_def_none` (R0, memory ports), `D_w1_def_fifo_lcnone`, `D_w8_def_fifo_lcnone` and `D_w8_def_axis_lcnone`. The runs named for review had loop_count with ap_vld (default setup, fifo at W = 1 and 8, axis at W = 8), and all of them failed in the front end (below). So the same runs without the ap_vld pragma are kept in their place. For axis that is the axis run, not the fifo one named as the fallback, since axis itself passed.

### Results

Counts: D: pass 12, fail: compile 12 (every ap_vld run), timeout 0.

| id | W | setup | -O | ports | loop_count pragma | status | cycles | cycles/beat | adders (64-bit) | FSM states | memory modules | loop_count registered | Bambu's message |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| D_w1_def_fifo_lcnone | 1 | default | -O2 | fifo | none | pass | 99 | 1.547 | 8 (5) | 21 | none | no |  |
| D_w1_def_fifo_lcvld | 1 | default |  | fifo | ap_vld | fail: compile |  |  |  |  |  |  | Interface type 'valid' for parameter 'loop_count' is not supported |
| D_w1_def_axis_lcnone | 1 | default | -O2 | axis | none | pass | 99 | 1.547 | 8 (5) | 21 | none | no |  |
| D_w1_def_axis_lcvld | 1 | default |  | axis | ap_vld | fail: compile |  |  |  |  |  |  | Interface type 'valid' for parameter 'loop_count' is not supported |
| D_w1_area_fifo_lcnone | 1 | BAMBU-AREA | -Os | fifo | none | pass | 194 | 3.031 | 2 (1) | 8 | none | no |  |
| D_w1_area_fifo_lcvld | 1 | BAMBU-AREA |  | fifo | ap_vld | fail: compile |  |  |  |  |  |  | Interface type 'valid' for parameter 'loop_count' is not supported |
| D_w1_area_axis_lcnone | 1 | BAMBU-AREA | -Os | axis | none | pass | 194 | 3.031 | 2 (1) | 8 | none | no |  |
| D_w1_area_axis_lcvld | 1 | BAMBU-AREA |  | axis | ap_vld | fail: compile |  |  |  |  |  |  | Interface type 'valid' for parameter 'loop_count' is not supported |
| D_w8_def_fifo_lcnone | 8 | default | -O2 | fifo | none | pass | 138 | 17.25 | 9 (8) | 36 | none | no |  |
| D_w8_def_fifo_lcvld | 8 | default |  | fifo | ap_vld | fail: compile |  |  |  |  |  |  | Interface type 'valid' for parameter 'loop_count' is not supported |
| D_w8_def_axis_lcnone | 8 | default | -O2 | axis | none | pass | 138 | 17.25 | 9 (8) | 36 | none | no |  |
| D_w8_def_axis_lcvld | 8 | default |  | axis | ap_vld | fail: compile |  |  |  |  |  |  | Interface type 'valid' for parameter 'loop_count' is not supported |
| D_w8_area_fifo_lcnone | 8 | BAMBU-AREA | -Os | fifo | none | pass | 3730 | 466.25 | 6 (1) | 17 | ARRAY_1D_STD_BRAM x3, ARRAY_1D_STD_BRAM_SP x1, BRAM_MEMORY_CORE x1, BRAM_MEMORY_CORE_SMALL x1, TRUE_DUAL_PORT_BYTE_ENABLING_RAM x1 | no |  |
| D_w8_area_fifo_lcvld | 8 | BAMBU-AREA |  | fifo | ap_vld | fail: compile |  |  |  |  |  |  | Interface type 'valid' for parameter 'loop_count' is not supported |
| D_w8_area_axis_lcnone | 8 | BAMBU-AREA | -Os | axis | none | pass | 3730 | 466.25 | 6 (1) | 17 | ARRAY_1D_STD_BRAM x3, ARRAY_1D_STD_BRAM_SP x1, BRAM_MEMORY_CORE x1, BRAM_MEMORY_CORE_SMALL x1, TRUE_DUAL_PORT_BYTE_ENABLING_RAM x1 | no |  |
| D_w8_area_axis_lcvld | 8 | BAMBU-AREA |  | axis | ap_vld | fail: compile |  |  |  |  |  |  | Interface type 'valid' for parameter 'loop_count' is not supported |
| D_w32_def_fifo_lcnone | 32 | default | -O2 | fifo | none | pass | 3654 | 1827.0 | 9 (4) | 19 | ARRAY_1D_STD_BRAM_NN x3, ARRAY_1D_STD_BRAM_NN_SP x1, BRAM_MEMORY_NN_CORE x1 | no |  |
| D_w32_def_fifo_lcvld | 32 | default |  | fifo | ap_vld | fail: compile |  |  |  |  |  |  | Interface type 'valid' for parameter 'loop_count' is not supported |
| D_w32_def_axis_lcnone | 32 | default | -O2 | axis | none | pass | 3654 | 1827.0 | 9 (4) | 19 | ARRAY_1D_STD_BRAM_NN x3, ARRAY_1D_STD_BRAM_NN_SP x1, BRAM_MEMORY_NN_CORE x1 | no |  |
| D_w32_def_axis_lcvld | 32 | default |  | axis | ap_vld | fail: compile |  |  |  |  |  |  | Interface type 'valid' for parameter 'loop_count' is not supported |
| D_w32_area_fifo_lcnone | 32 | BAMBU-AREA | -Os | fifo | none | pass | 3718 | 1859.0 | 6 (1) | 17 | ARRAY_1D_STD_BRAM x3, ARRAY_1D_STD_BRAM_SP x1, BRAM_MEMORY_CORE x1, BRAM_MEMORY_CORE_SMALL x1, TRUE_DUAL_PORT_BYTE_ENABLING_RAM x1 | no |  |
| D_w32_area_fifo_lcvld | 32 | BAMBU-AREA |  | fifo | ap_vld | fail: compile |  |  |  |  |  |  | Interface type 'valid' for parameter 'loop_count' is not supported |
| D_w32_area_axis_lcnone | 32 | BAMBU-AREA | -Os | axis | none | pass | 3718 | 1859.0 | 6 (1) | 17 | ARRAY_1D_STD_BRAM x3, ARRAY_1D_STD_BRAM_SP x1, BRAM_MEMORY_CORE x1, BRAM_MEMORY_CORE_SMALL x1, TRUE_DUAL_PORT_BYTE_ENABLING_RAM x1 | no |  |
| D_w32_area_axis_lcvld | 32 | BAMBU-AREA |  | axis | ap_vld | fail: compile |  |  |  |  |  |  | Interface type 'valid' for parameter 'loop_count' is not supported |

Top ports of the passing runs (widths from the top module's declarations):

| ports | W = 1 and W = 8 | W = 32 |
|---|---|---|
| fifo | `clock reset start_port A_dout[63:0] B_dout[63:0] loop_count[31:0] A_empty_n B_empty_n C_full_n done_port A_read B_read C_din[63:0] C_write` | the same with `A_dout`, `B_dout`, `C_din` 8 bits wide |
| axis | `clock reset start_port A_TDATA[63:0] B_TDATA[63:0] loop_count[31:0] A_TVALID B_TVALID C_TREADY done_port A_TREADY B_TREADY C_TDATA[63:0] C_TVALID` | the same with `A_TDATA`, `B_TDATA`, `C_TDATA` 8 bits wide |

### Findings

- Both port modes passed, with the kernel's array arguments: Bambu asked for no `hls::stream` or `ac_channel` argument. Every combination without the loop_count pragma passed (12 of 12). fifo and axis give the same cycles, adders, FSM states and memories in each of the six W x setup pairs. They differ only in the port protocol: fifo uses `_dout/_empty_n/_read` and `_din/_full_n/_write`, axis uses `_TDATA/_TVALID/_TREADY`. With these interfaces the block has no memory controller and no `M*_ram` ports.
- The stream ports are not a beat wide. `A`, `B` and `C` are 64 bits at W = 1 and W = 8 and 8 bits at W = 32. So a W = 8 beat (512 bits) does not cross the boundary in one transfer. At W = 32 the data crosses as single bytes. Every passing D log also has the memory-allocation notes `Spec may not exploit DATA bus width` and `Code has LOADs or STOREs with unaligned accesses`.
- Cycles against W, default setup: W = 1 99 cycles (1.547 per beat), W = 8 138 (17.25 per beat), W = 32 3654 (1827 per beat). BAMBU-AREA: W = 1 194 (3.031), W = 8 3730 (466.25), W = 32 3718 (1859). For comparison, R0's memory interface at the default setup gave 195 at W = 1 and 106 at W = 8.
- Datapath under the default setup: at W = 1, five 64-bit adders, and loop_count feeds `ui_eq_expr_FU`, `ui_lt_expr_FU`, `ui_rshift_expr_FU` and `ui_bit_and_expr_FU`, the same signature of BEAT's runtime unrolling by four as in R0. At W = 8, eight 64-bit adders (LANE unrolled) and no local memory. At W = 32, four 64-bit adders, and the beats are kept in local memories (`ARRAY_1D_STD_BRAM_NN` x3, `ARRAY_1D_STD_BRAM_NN_SP`, `BRAM_MEMORY_NN_CORE`).
- ap_vld on loop_count: every one of the 12 runs stops with `Interface type 'valid' for parameter 'loop_count' is not supported` (Bambu maps `ap_vld` to its `valid` type and does not accept it on this by-value scalar). So whether ap_vld registers loop_count could not be measured. In all 12 passing runs loop_count is not registered: the port goes straight into the loop's comparators (`ui_eq_expr_FU` x2 at W = 8 and 32, and at W = 1 under AREA; the four units above at W = 1 under the default setup).
- What AREA (-Os) changes: one 64-bit adder at every W (against 5, 8 and 4). Local memories at W = 8 and 32 (`ARRAY_1D_STD_BRAM` x3, `ARRAY_1D_STD_BRAM_SP`, `BRAM_MEMORY_CORE`, `BRAM_MEMORY_CORE_SMALL`, `TRUE_DUAL_PORT_BYTE_ENABLING_RAM`); none at W = 1. Fewer FSM states at W = 1 and 8 (8 and 17 against 21 and 36), 17 against 19 at W = 32. Cycles: 194 against 99 at W = 1, 3730 against 138 at W = 8, 3718 against 3654 at W = 32.
- Warnings: the passing D runs print no `Warning:` line; R0's `This function uses unknown addresses` does not appear. The only other notes are the two memory-allocation lines above.

## Round 3: beat-wide ports (R0c)

R0b's stream ports were 64 bits wide: its vec_t is a struct of W int64 lanes, and Bambu splits a struct into its fields, so every lane is a separate transfer. R0c gives Bambu what Vitis gets, one value per beat: vec_t as one `ac_int<64*W, false>`. It also tries the remaining handshake modes on loop_count. It decides nothing.

### What was run

- Header: `bench/probe/bambu/include_wide/lanes.h`. vec_t is data_t at W = 1 and `ac_int<64*W, false>` above. `lane(v, i)` and `set_lane(v, i, x)` go through `slc<64>(64*i)` and `set_slc(64*i, ...)`, lane 0 in the low bits as hlslib's DataPack. cfg_t is as before, and there are no `#pragma HLS INLINE` lines.
- The E runs pass the lane count as `-DBAMBU_LANES=<W>`, not `-DW=<W>`, and include_wide/lanes.h defines `W` from it after including Bambu's `ac_int.h`. Why: `ac_int.h` stops with `One or more of the following is defined: W, I, S, W2, I2, S2` when W is a macro. Bambu's generated co-simulation files (`HLS_output/simulation/mdpi_wrapper.cpp`, `generated_tb.c`) include `ac_int.h` directly, because the top's argument type is an ac_int, and they are compiled with the command's -D flags. With `-DW=8` on the command line they failed whatever the header did (tried first, with W saved in an enum, `#undef`'d around the include and defined again: the kernel compiled, the co-simulation build stopped on that error). The kernel source is unchanged: vecadd.h and tb_vecadd.cpp use W only after including lanes.h. Every other flag is as in R0.
- Group E, 38 runs, n64, `--generate-interface=INFER`, no pipeline pragmas:
  - 36: W in {1, 8, 32} x setup in {default (BAMBU-BALANCED-MP), BAMBU-AREA} x ports in {fifo, axis} on A, B and C x loop_count in {no pragma, `#pragma HLS interface port=loop_count mode=ap_hs`, the same with `mode=ap_ack`}; no unroll pragma.
  - 2 more: W = 32, default setup, no loop_count pragma, `#pragma HLS unroll` on LANE (as in R0), fifo and axis. With LANE unrolled, lane i is a constant, which is meant to remove the variable shift on which the W = 32 runs stop (below).
- The CSV gains a column `port_width`: the bit width of A's data port on the top (`A_dout` for fifo, `A_TDATA` for axis).
- RTL kept in `notes/bambu_rtl/`: `E_w1_def_fifo_lcnone` and `E_w8_def_fifo_lcnone`. The W = 32 run of the same kind (`E_w32_def_fifo_lcnone`) produced no Verilog. No passing E run registers loop_count. The W = 32 fifo run with unroll did not pass (timeout), so it is not kept.

### Results

Counts: E: pass 6, fail: compile 30, timeout 2.

| id | W | setup | -O | ports | loop_count pragma | LANE pragma | status | cycles | cycles/beat | port width | adders (64-bit) | FSM states | memory modules | loop_count registered | Bambu's message |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| E_w1_def_fifo_lcnone | 1 | default | -O2 | fifo | none | none | pass | 99 | 1.547 | 64 | 8 (5) | 21 | none | no |  |
| E_w1_def_fifo_lchs | 1 | default |  | fifo | ap_hs | none | fail: compile |  |  |  |  |  |  |  | Interface type 'handshake' for parameter 'loop_count' is not supported |
| E_w1_def_fifo_lcack | 1 | default |  | fifo | ap_ack | none | fail: compile |  |  |  |  |  |  |  | Interface type 'acknowledge' for parameter 'loop_count' is not supported |
| E_w1_def_axis_lcnone | 1 | default | -O2 | axis | none | none | pass | 99 | 1.547 | 64 | 8 (5) | 21 | none | no |  |
| E_w1_def_axis_lchs | 1 | default |  | axis | ap_hs | none | fail: compile |  |  |  |  |  |  |  | Interface type 'handshake' for parameter 'loop_count' is not supported |
| E_w1_def_axis_lcack | 1 | default |  | axis | ap_ack | none | fail: compile |  |  |  |  |  |  |  | Interface type 'acknowledge' for parameter 'loop_count' is not supported |
| E_w1_area_fifo_lcnone | 1 | BAMBU-AREA | -Os | fifo | none | none | pass | 194 | 3.031 | 64 | 2 (1) | 8 | none | no |  |
| E_w1_area_fifo_lchs | 1 | BAMBU-AREA |  | fifo | ap_hs | none | fail: compile |  |  |  |  |  |  |  | Interface type 'handshake' for parameter 'loop_count' is not supported |
| E_w1_area_fifo_lcack | 1 | BAMBU-AREA |  | fifo | ap_ack | none | fail: compile |  |  |  |  |  |  |  | Interface type 'acknowledge' for parameter 'loop_count' is not supported |
| E_w1_area_axis_lcnone | 1 | BAMBU-AREA | -Os | axis | none | none | pass | 194 | 3.031 | 64 | 2 (1) | 8 | none | no |  |
| E_w1_area_axis_lchs | 1 | BAMBU-AREA |  | axis | ap_hs | none | fail: compile |  |  |  |  |  |  |  | Interface type 'handshake' for parameter 'loop_count' is not supported |
| E_w1_area_axis_lcack | 1 | BAMBU-AREA |  | axis | ap_ack | none | fail: compile |  |  |  |  |  |  |  | Interface type 'acknowledge' for parameter 'loop_count' is not supported |
| E_w8_def_fifo_lcnone | 8 | default | -O2 | fifo | none | none | pass | 26 | 3.25 | 512 | 17 (8) | 8 | none | no |  |
| E_w8_def_fifo_lchs | 8 | default |  | fifo | ap_hs | none | fail: compile |  |  |  |  |  |  |  | Interface type 'handshake' for parameter 'loop_count' is not supported |
| E_w8_def_fifo_lcack | 8 | default |  | fifo | ap_ack | none | fail: compile |  |  |  |  |  |  |  | Interface type 'acknowledge' for parameter 'loop_count' is not supported |
| E_w8_def_axis_lcnone | 8 | default | -O2 | axis | none | none | pass | 26 | 3.25 | 512 | 17 (8) | 8 | none | no |  |
| E_w8_def_axis_lchs | 8 | default |  | axis | ap_hs | none | fail: compile |  |  |  |  |  |  |  | Interface type 'handshake' for parameter 'loop_count' is not supported |
| E_w8_def_axis_lcack | 8 | default |  | axis | ap_ack | none | fail: compile |  |  |  |  |  |  |  | Interface type 'acknowledge' for parameter 'loop_count' is not supported |
| E_w8_area_fifo_lcnone | 8 | BAMBU-AREA |  | fifo | none | none | fail: compile |  |  |  |  |  |  |  | Vertices not completely allocated |
| E_w8_area_fifo_lchs | 8 | BAMBU-AREA |  | fifo | ap_hs | none | fail: compile |  |  |  |  |  |  |  | Interface type 'handshake' for parameter 'loop_count' is not supported |
| E_w8_area_fifo_lcack | 8 | BAMBU-AREA |  | fifo | ap_ack | none | fail: compile |  |  |  |  |  |  |  | Interface type 'acknowledge' for parameter 'loop_count' is not supported |
| E_w8_area_axis_lcnone | 8 | BAMBU-AREA |  | axis | none | none | fail: compile |  |  |  |  |  |  |  | Vertices not completely allocated |
| E_w8_area_axis_lchs | 8 | BAMBU-AREA |  | axis | ap_hs | none | fail: compile |  |  |  |  |  |  |  | Interface type 'handshake' for parameter 'loop_count' is not supported |
| E_w8_area_axis_lcack | 8 | BAMBU-AREA |  | axis | ap_ack | none | fail: compile |  |  |  |  |  |  |  | Interface type 'acknowledge' for parameter 'loop_count' is not supported |
| E_w32_def_fifo_lcnone | 32 | default |  | fifo | none | none | fail: compile |  |  |  |  |  |  |  | Vertices not completely allocated |
| E_w32_def_fifo_lchs | 32 | default |  | fifo | ap_hs | none | fail: compile |  |  |  |  |  |  |  | Interface type 'handshake' for parameter 'loop_count' is not supported |
| E_w32_def_fifo_lcack | 32 | default |  | fifo | ap_ack | none | fail: compile |  |  |  |  |  |  |  | Interface type 'acknowledge' for parameter 'loop_count' is not supported |
| E_w32_def_axis_lcnone | 32 | default |  | axis | none | none | fail: compile |  |  |  |  |  |  |  | Vertices not completely allocated |
| E_w32_def_axis_lchs | 32 | default |  | axis | ap_hs | none | fail: compile |  |  |  |  |  |  |  | Interface type 'handshake' for parameter 'loop_count' is not supported |
| E_w32_def_axis_lcack | 32 | default |  | axis | ap_ack | none | fail: compile |  |  |  |  |  |  |  | Interface type 'acknowledge' for parameter 'loop_count' is not supported |
| E_w32_area_fifo_lcnone | 32 | BAMBU-AREA |  | fifo | none | none | fail: compile |  |  |  |  |  |  |  | Vertices not completely allocated |
| E_w32_area_fifo_lchs | 32 | BAMBU-AREA |  | fifo | ap_hs | none | fail: compile |  |  |  |  |  |  |  | Interface type 'handshake' for parameter 'loop_count' is not supported |
| E_w32_area_fifo_lcack | 32 | BAMBU-AREA |  | fifo | ap_ack | none | fail: compile |  |  |  |  |  |  |  | Interface type 'acknowledge' for parameter 'loop_count' is not supported |
| E_w32_area_axis_lcnone | 32 | BAMBU-AREA |  | axis | none | none | fail: compile |  |  |  |  |  |  |  | Vertices not completely allocated |
| E_w32_area_axis_lchs | 32 | BAMBU-AREA |  | axis | ap_hs | none | fail: compile |  |  |  |  |  |  |  | Interface type 'handshake' for parameter 'loop_count' is not supported |
| E_w32_area_axis_lcack | 32 | BAMBU-AREA |  | axis | ap_ack | none | fail: compile |  |  |  |  |  |  |  | Interface type 'acknowledge' for parameter 'loop_count' is not supported |
| E_w32_def_fifo_lcnone_unroll | 32 | default | -O2 | fifo | none | unroll | timeout |  |  | 2048 | 65 (32) | 8 | none | no | killed after 600 s |
| E_w32_def_axis_lcnone_unroll | 32 | default | -O2 | axis | none | unroll | timeout |  |  | 2048 | 65 (32) | 8 | none | no | killed after 600 s |

Registers and flip-flops of the passing and timed-out runs, from Bambu's log (`Register allocation ... N registers`, `Total number of flip-flops`). fifo and axis give the same numbers.

| run (fifo and axis) | registers | flip-flops |
|---|---|---|
| E_w1_def | 31 | 1091 |
| E_w1_area | 8 | 321 |
| E_w8_def | 8 | 1665 |
| E_w32_def, unroll (timeout) | 8 | 6273 |
| for comparison: D_w8_def_fifo_lcnone (R0b, struct) | 36 | 1441 |
| for comparison: A_w8_def_none (R0, memory ports) | 38 | 1633 |

### Findings

- Port widths: A's data port is 64 bits at W = 1, 512 bits at W = 8 and 2048 bits at W = 32 with unroll, in both fifo (`A_dout`, `B_dout`, `C_din`) and axis (`A_TDATA`, `B_TDATA`, `C_TDATA`). So one beat is one transfer. The port names are those of R0b. fifo and axis give the same cycles, adders, states and registers in every pair.
- Cycles against W, default setup: W = 1 99 cycles (1.547 per beat; at W = 1 vec_t is int64, as in R0b), W = 8 26 cycles (3.25 per beat). R0b's struct gave 17.25 per beat at W = 8 and R0's memory interface 13.25. W = 32 gave no cycle count. Without unroll, the runs without a loop_count pragma stop in synthesis under both setups (the ap_hs and ap_ack runs stop earlier, on the interface error below) with `Vertices not completely allocated`, preceded by `Operation for which does not exist a functional unit in the resource library: lshift_expr ... vertex prec: 2048 2048 2048` (two such vertices). With `#pragma HLS unroll` on LANE, synthesis completes: the variable shift is gone, with 32 64-bit adders, 8 FSM states and 2048-bit ports. But the co-simulation of both runs (fifo and axis) did not end within the 10-minute timeout. Verilator built its model 13 s after Bambu wrote the Verilog. Then no testbench output came. A separate rerun of the fifo run with `--max-sim-cycles=20000` (64 lanes in two beats) also did not end within 19 minutes, and its Verilator process had used 0 s of CPU after 18 minutes: it was waiting, not simulating. The cause was not found.
- Adders and registers: W = 1 default has five 64-bit adders (the BEAT runtime-unrolling signature of R0 and R0b), 31 registers and 1091 flip-flops. W = 8 default has eight 64-bit adders plus nine 32-bit ones, 8 registers and 1665 flip-flops, against R0b's 36 registers and 1441 flip-flops at the same W. W = 32 with unroll has 32 64-bit and 33 32-bit adders, 8 registers and 6273 flip-flops. No passing E run instantiates a memory module.
- loop_count: no mode registers the pin. `mode=ap_hs` stops all 12 of its runs with `Interface type 'handshake' for parameter 'loop_count' is not supported`, and `mode=ap_ack` all 12 with `Interface type 'acknowledge' for parameter 'loop_count' is not supported`. With R0b's `ap_vld` (`'valid'`), all three handshake modes tried are rejected for this by-value scalar. In every passing and timed-out E run, `loop_count_registered` is no: the port goes straight into the loop's comparators (`ui_eq_expr_FU` x2; at W = 1 under the default setup `ui_eq_expr_FU`, `ui_lt_expr_FU`, `ui_rshift_expr_FU`, `ui_bit_and_expr_FU`).
- What AREA (-Os) changes: W = 1 passes with one 64-bit adder, 8 registers, 321 flip-flops and 8 states, at 194 cycles against 99. W = 8 fails under AREA: LANE is not unrolled, and synthesis stops on the same missing unit for a 512-bit variable shift (`lshift_expr ... prec: 512 512 512`, `Vertices not completely allocated`). The default setup unrolls LANE at W = 8 and passes. W = 32 fails under both setups without the unroll pragma.
- Warnings: the passing E runs print no `Warning:` line. Every run that stops on the variable shift prints `Warning: A bad estimation of the timing of the rshift_expr operator will happen. This may occur when a non-constant bit reference of a long ac_type is used. Unrolling such a part may fix the issue.` 240 times. The passing and timed-out runs' logs also have R0b's memory-allocation notes (`Spec may not exploit DATA bus width`, `Code has LOADs or STOREs with unaligned accesses`).
