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
