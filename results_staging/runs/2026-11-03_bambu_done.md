# Bambu on tier done (BAM1 R1), 2026-11-03

The two Bambu cases, `bambu_unopt` and `bambu_opt`, on vecadd, vecmul, vsum and dot: W in {1, 2, 4, 8, 16, 32}, sizes n64 and n512, 96 points. Settings: docs/HLS_VS_FORGE.md section 3B. Evidence for the settings: notes/bambu_probe.md (R0 to R0c).

## Commands

```bash
podman image exists localhost/hls-exercises-bambu:4
python3 bench/bench.py run --tier done --dry-run        # and --tier untiered: Vitis blocks unchanged (below)
python3 bench/bench.py run --tier done --kernel vecadd --case bambu_unopt bambu_opt --dry-run
HLS_RESULTS=$PWD/results_staging python3 bench/bench.py run --tier done --kernel vecadd --case bambu_unopt --size n64 --w 8
HLS_RESULTS=$PWD/results_staging python3 bench/bench.py run --tier done --kernel vecadd --case bambu_unopt bambu_opt -j32
HLS_RESULTS=$PWD/results_staging python3 bench/bench.py run --tier done --kernel <vecmul|vsum|dot> --case bambu_unopt bambu_opt -j32
```

Each point runs, from its folder `bench/tier_done/<kernel>/<case>_<size>_w<W>_proj/`, `bench/tools/in_bambu.sh bambu <copy of src/<kernel>.cpp> --top-fname=<top> --top-rtldesign-name=<top> --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER --simulate --simulator=VERILATOR --generate-tb=src/tb_<kernel>.cpp --tb-extra-gcc-options="-DDUT=<top> -DCFG_LOOP_COUNT=... [-DCFG_LEN=...]" --tb-param-size=A:<n*8>,B:<n*8>,<C|out>:<n*8|8> -DDATA_T=int64_t -DSIZE_N=<n> -DBAMBU_LANES=<W> --std=c++14 -I bench/include/bambu -I <kernel>/src -I <kernel>/vectors/<size>`. The full command of each point is in its `point.json` (`cmd`). The copy adds only `#pragma HLS interface port=<p> mode=axis` above `void <top>(`, and for `bambu_opt` `#pragma HLS unroll` before LANE's `for`.

## Versions

| Item | Version |
|---|---|
| Bambu | PandA 2024.10, revision c2ba6936 (`hls_cycles.csv`'s version column), AppImage sha256 `e4f02144…0773` |
| Front end | Bambu's Clang 16.0.0 |
| Container | `localhost/hls-exercises-bambu:4`, Ubuntu 24.04, glibc 2.39 |
| Simulator | Verilator 5.020 (in the container) |
| bench.py | hls-exercises `b7cb6ba` (vecadd), `ccaa987` (vecmul, vsum, dot; adds only the filelist's top from the Verilog) |

## Vitis side unchanged

`bench.py run --dry-run` for tier done and tier untiered, before and after the change: the 124 Vitis blocks of tier done and the 112 of tier untiered are identical and in the same order. Tier done gains 96 Bambu blocks, after the Vitis ones of each kernel. No Vitis point ran in R1. No existing `rtl/` folder changed.

## Counts

| | ok | failed: compile | failed: sim | timeout |
|---|---|---|---|---|
| vecadd | 18 | 4 | 0 | 2 |
| vecmul | 18 | 4 | 0 | 2 |
| vsum | 20 | 0 | 4 | 0 |
| dot | 20 | 0 | 4 | 0 |
| total | 76 | 8 | 8 | 4 |

rtl_same: 44 `ref`, 24 `yes`, 20 `no`, 8 without Verilog (the compile failures). Every `no` differs from its reference only in the order of the operands of a `SIMPLEJOIN_FU`'s `.ops({...})` concatenation (the same done signals, listed in another order). Checked for all 20 by comparing the files with every `.ops` list sorted, Bambu's header comment lines dropped. The same command gives the same Verilog when rerun (vecadd `bambu_unopt_n64_w8` run twice more: identical to its reference). So the order follows the size, not chance. Each `no` point has its own folder `rtl/done/<kernel>/<case>_n512_w<W>/`. No Bambu point instantiated a memory module (no `# ram:` line), and every Verilog is portable (`portable` yes, no vendor primitives).

## Results

### vecadd

failed: compile 4, ok 18, timeout 2

| case | W | size | status | cycles | cycles per beat | FSM states | rtl_same |
|---|---|---|---|---|---|---|---|
| bambu_unopt | 1 | n64 | ok | 99 | 1.55 | 21 | ref |
| bambu_unopt | 1 | n512 | ok | 771 | 1.51 | 21 | no: vecadd.v |
| bambu_unopt | 2 | n64 | ok | 98 | 3.06 | 8 | ref |
| bambu_unopt | 2 | n512 | ok | 770 | 3.01 | 8 | no: vecadd.v |
| bambu_unopt | 4 | n64 | ok | 50 | 3.12 | 8 | ref |
| bambu_unopt | 4 | n512 | ok | 386 | 3.02 | 8 | yes |
| bambu_unopt | 8 | n64 | ok | 26 | 3.25 | 8 | ref |
| bambu_unopt | 8 | n512 | ok | 194 | 3.03 | 8 | no: vecadd.v |
| bambu_unopt | 16 | n64 | failed: compile | - | - | - | - |
| bambu_unopt | 16 | n512 | failed: compile | - | - | - | - |
| bambu_unopt | 32 | n64 | failed: compile | - | - | - | - |
| bambu_unopt | 32 | n512 | failed: compile | - | - | - | - |
| bambu_opt | 1 | n64 | ok | 99 | 1.55 | 21 | ref |
| bambu_opt | 1 | n512 | ok | 771 | 1.51 | 21 | no: vecadd.v |
| bambu_opt | 2 | n64 | ok | 98 | 3.06 | 8 | ref |
| bambu_opt | 2 | n512 | ok | 770 | 3.01 | 8 | no: vecadd.v |
| bambu_opt | 4 | n64 | ok | 50 | 3.12 | 8 | ref |
| bambu_opt | 4 | n512 | ok | 386 | 3.02 | 8 | yes |
| bambu_opt | 8 | n64 | ok | 26 | 3.25 | 8 | ref |
| bambu_opt | 8 | n512 | ok | 194 | 3.03 | 8 | yes |
| bambu_opt | 16 | n64 | ok | 14 | 3.5 | 8 | ref |
| bambu_opt | 16 | n512 | ok | 98 | 3.06 | 8 | no: vecadd.v |
| bambu_opt | 32 | n64 | timeout | - | - | 8 | ref |
| bambu_opt | 32 | n512 | timeout | - | - | 8 | no: vecadd.v |

### vecmul

failed: compile 4, ok 18, timeout 2

| case | W | size | status | cycles | cycles per beat | FSM states | rtl_same |
|---|---|---|---|---|---|---|---|
| bambu_unopt | 1 | n64 | ok | 99 | 1.55 | 21 | ref |
| bambu_unopt | 1 | n512 | ok | 771 | 1.51 | 21 | no: vecmul.v |
| bambu_unopt | 2 | n64 | ok | 98 | 3.06 | 8 | ref |
| bambu_unopt | 2 | n512 | ok | 770 | 3.01 | 8 | no: vecmul.v |
| bambu_unopt | 4 | n64 | ok | 50 | 3.12 | 8 | ref |
| bambu_unopt | 4 | n512 | ok | 386 | 3.02 | 8 | yes |
| bambu_unopt | 8 | n64 | ok | 26 | 3.25 | 8 | ref |
| bambu_unopt | 8 | n512 | ok | 194 | 3.03 | 8 | no: vecmul.v |
| bambu_unopt | 16 | n64 | failed: compile | - | - | - | - |
| bambu_unopt | 16 | n512 | failed: compile | - | - | - | - |
| bambu_unopt | 32 | n64 | failed: compile | - | - | - | - |
| bambu_unopt | 32 | n512 | failed: compile | - | - | - | - |
| bambu_opt | 1 | n64 | ok | 99 | 1.55 | 21 | ref |
| bambu_opt | 1 | n512 | ok | 771 | 1.51 | 21 | no: vecmul.v |
| bambu_opt | 2 | n64 | ok | 98 | 3.06 | 8 | ref |
| bambu_opt | 2 | n512 | ok | 770 | 3.01 | 8 | yes |
| bambu_opt | 4 | n64 | ok | 50 | 3.12 | 8 | ref |
| bambu_opt | 4 | n512 | ok | 386 | 3.02 | 8 | no: vecmul.v |
| bambu_opt | 8 | n64 | ok | 26 | 3.25 | 8 | ref |
| bambu_opt | 8 | n512 | ok | 194 | 3.03 | 8 | no: vecmul.v |
| bambu_opt | 16 | n64 | ok | 14 | 3.5 | 8 | ref |
| bambu_opt | 16 | n512 | ok | 98 | 3.06 | 8 | yes |
| bambu_opt | 32 | n64 | timeout | - | - | 8 | ref |
| bambu_opt | 32 | n512 | timeout | - | - | 8 | yes |

### vsum

failed: sim 4, ok 20

| case | W | size | status | cycles | cycles per beat | FSM states | rtl_same |
|---|---|---|---|---|---|---|---|
| bambu_unopt | 1 | n64 | ok | 163 | 2.55 | 21 | ref |
| bambu_unopt | 1 | n512 | ok | 1283 | 2.51 | 21 | yes |
| bambu_unopt | 2 | n64 | ok | 99 | 3.09 | 9 | ref |
| bambu_unopt | 2 | n512 | ok | 771 | 3.01 | 9 | yes |
| bambu_unopt | 4 | n64 | ok | 51 | 3.19 | 9 | ref |
| bambu_unopt | 4 | n512 | ok | 387 | 3.02 | 9 | yes |
| bambu_unopt | 8 | n64 | ok | 27 | 3.38 | 9 | ref |
| bambu_unopt | 8 | n512 | ok | 195 | 3.05 | 9 | yes |
| bambu_unopt | 16 | n64 | ok | 47 | 11.8 | 10 | ref |
| bambu_unopt | 16 | n512 | ok | 355 | 11.1 | 10 | yes |
| bambu_unopt | 32 | n64 | failed: sim | - | - | 10 | ref |
| bambu_unopt | 32 | n512 | failed: sim | - | - | 10 | yes |
| bambu_opt | 1 | n64 | ok | 163 | 2.55 | 21 | ref |
| bambu_opt | 1 | n512 | ok | 1283 | 2.51 | 21 | yes |
| bambu_opt | 2 | n64 | ok | 99 | 3.09 | 9 | ref |
| bambu_opt | 2 | n512 | ok | 771 | 3.01 | 9 | yes |
| bambu_opt | 4 | n64 | ok | 51 | 3.19 | 9 | ref |
| bambu_opt | 4 | n512 | ok | 387 | 3.02 | 9 | yes |
| bambu_opt | 8 | n64 | ok | 27 | 3.38 | 9 | ref |
| bambu_opt | 8 | n512 | ok | 195 | 3.05 | 9 | yes |
| bambu_opt | 16 | n64 | ok | 19 | 4.75 | 10 | ref |
| bambu_opt | 16 | n512 | ok | 131 | 4.09 | 10 | yes |
| bambu_opt | 32 | n64 | failed: sim | - | - | 10 | ref |
| bambu_opt | 32 | n512 | failed: sim | - | - | 10 | yes |

### dot

failed: sim 4, ok 20

| case | W | size | status | cycles | cycles per beat | FSM states | rtl_same |
|---|---|---|---|---|---|---|---|
| bambu_unopt | 1 | n64 | ok | 195 | 3.05 | 9 | ref |
| bambu_unopt | 1 | n512 | ok | 1539 | 3.01 | 9 | no: dot.v |
| bambu_unopt | 2 | n64 | ok | 99 | 3.09 | 9 | ref |
| bambu_unopt | 2 | n512 | ok | 771 | 3.01 | 9 | yes |
| bambu_unopt | 4 | n64 | ok | 51 | 3.19 | 9 | ref |
| bambu_unopt | 4 | n512 | ok | 387 | 3.02 | 9 | no: dot.v |
| bambu_unopt | 8 | n64 | ok | 35 | 4.38 | 10 | ref |
| bambu_unopt | 8 | n512 | ok | 259 | 4.05 | 10 | no: dot.v |
| bambu_unopt | 16 | n64 | ok | 79 | 19.8 | 10 | ref |
| bambu_unopt | 16 | n512 | ok | 611 | 19.1 | 10 | yes |
| bambu_unopt | 32 | n64 | failed: sim | - | - | 10 | ref |
| bambu_unopt | 32 | n512 | failed: sim | - | - | 10 | no: dot.v |
| bambu_opt | 1 | n64 | ok | 195 | 3.05 | 9 | ref |
| bambu_opt | 1 | n512 | ok | 1539 | 3.01 | 9 | no: dot.v |
| bambu_opt | 2 | n64 | ok | 99 | 3.09 | 9 | ref |
| bambu_opt | 2 | n512 | ok | 771 | 3.01 | 9 | yes |
| bambu_opt | 4 | n64 | ok | 51 | 3.19 | 9 | ref |
| bambu_opt | 4 | n512 | ok | 387 | 3.02 | 9 | yes |
| bambu_opt | 8 | n64 | ok | 35 | 4.38 | 10 | ref |
| bambu_opt | 8 | n512 | ok | 259 | 4.05 | 10 | no: dot.v |
| bambu_opt | 16 | n64 | ok | 19 | 4.75 | 10 | ref |
| bambu_opt | 16 | n512 | ok | 131 | 4.09 | 10 | yes |
| bambu_opt | 32 | n64 | failed: sim | - | - | 10 | ref |
| bambu_opt | 32 | n512 | failed: sim | - | - | 10 | no: dot.v |
## Failures

### failed: compile — vecadd and vecmul, bambu_unopt, W = 16 and 32 (8 points)

LANE is not unrolled at W >= 16 under the default setup, and the loop's `set_lane` needs a variable shift of the 64W-bit `ac_int` that no unit implements. Log lines (vecadd `bambu_unopt_n64_w16`; the W = 32 points say `prec: 2048 2048 2048`, vecmul the same with `_Z6vecmul...`):

```
Warning: A bad estimation of the timing of the rshift_expr operator will happen. This may occur when a non-constant bit reference of a long ac_type is used. Unrolling such a part may fix the issue.   (240 times)
    Operation for which does not exist a functional unit in the resource library: lshift_expr in vertex: _Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428599 with vertex type: UINT and vertex prec: 1024 1024 1024
    Operation for which does not exist a functional unit in the resource library: lshift_expr in vertex: _Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428694 with vertex type: UINT and vertex prec: 1024 1024 1024
error -> Vertices not completely allocated
```

### timeout — vecadd and vecmul, bambu_opt, W = 32 (4 points)

Synthesis completes (vecadd: 8 FSM states, 6273 flip-flops; the Verilog is in `rtl/done/<kernel>/bambu_opt_w32/` and `_n512_w32/`). Verilator builds its model. Then the co-simulation produces no output until bench.py removes the container after 900 s. No error line: the log ends with Bambu's binding summary (`Total number of flip-flops in function _Z6vecaddPK6ac_intILi2048ELb0EES2_PS0_j: 6273`). This is the hang of R0c (E_w32_*_unroll), where the Verilator process was seen waiting with 0 s of CPU.

### failed: sim — vsum and dot, both cases, W = 32 (8 points)

The simulation runs to Bambu's limit of 200,000,000 cycles without the design raising `done`. The testbench then reads 0. Log lines (dot `bambu_unopt_n512_w32`; the others the same with their expected value):

```
error -> Simulation not terminated!
Warning: Returned error code!
testbench.log:
Sim: Simulation exceeds 200000000 cycles
  out: got 0 expected 18796510
FAIL dot N=512 W=32 loop_count=16 len=16: out = 0
```

## Against R0c

- vecadd's points match R0c's group E where they overlap: `bambu_unopt` n64 W = 8, 26 cycles and 8 FSM states (R0c E_w8_def_axis_lcnone: 26, 8); W = 1, 99 cycles and 21 states (E_w1_def_*: 99, 21). W = 32 with unroll hangs again.
- Different from R0c: the top module keeps its mangled C++ name although R1 passes `--top-rtldesign-name=<top>`, which R0c did not pass. So `filelist.f`'s `# top:` takes the name from the Verilog (`ccaa987`). The first vecadd run (`e9853ea`) already wrote the mangled name.
- New in R1 (not in the probe): n512, W = 2, 4 and 16, and the kernels vecmul, vsum and dot. At W = 16 `bambu_opt` passes everywhere. `bambu_unopt` fails to compile on vecadd and vecmul, but passes on vsum and dot, whose LANE loop only reads lanes: 11.8 and 19.8 cycles per beat at n64, against 4.75 with unroll. At W = 32, vsum and dot fail in a way R0c did not show: the run reaches the cycle limit rather than waiting.

## Other

- `bench/probe/bambu/runs/` was already absent from disk when R1 began, so the cleanup freed nothing there. `make clean` does not match it (tested). No container from the Bambu image was left before or after the runs.
- The rows are in `results_staging/hls_cycles.csv` (columns `tool` and `fsm_states` added at the end; no Bambu rows in `hls_loops.csv`) and `results_staging/report_done.md`.
