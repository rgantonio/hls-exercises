# BAM3 probe A: Bambu 2024.10 directives and flags, 2026-11-05

Probe A of BAM3 (docs/BAMBU_PLAN.md section 8): can Bambu 2024.10 do better than our `bambu` case (3 to 4 cycles per beat) with its own directives and flags? `bench/bambu_probe.py` built 8 configs for vecadd and dot at W = 1, 8, 32 (48 builds, at n512, in the podman container), and our testbenches simulated each build in Questa 2022.4 at n64 and n512, no-stall and random-stall runs (192 simulations planned, 176 run: 4 builds failed). Every config is the `bambu` case (axis pragmas plus `#pragma HLS unroll` on LANE) plus:

| config | change |
|---|---|
| a0 | none (the `bambu` case, baseline) |
| a1_u2, a1_u4, a1_u8 | `#pragma HLS unroll factor=<U>` on BEAT, U = 2, 4, 8 |
| a2_sdc | `--speculative-sdc-scheduling` |
| a3_perf | `--experimental-setup=BAMBU-PERFORMANCE-MP` |
| a4_u4_sdc | a1_u4 and a2_sdc |
| a4_u4_perf | a1_u4 and a3_perf |

Outputs: `results_staging/probe_bam3a.csv` and `probe_bam3a.md` only. `rtl/` and `results_staging/bambu_cycles.csv` are unchanged (checksum before and after). Code at 44913cf.

## Commands

```bash
git pull                       # main at 4235e07
rm -rf build
lmutil lmstat -a -c 1717@licserv     # msimhdlsim: 75 issued, 3 in use -> --sim-jobs 32
pixi run python bench/bambu_probe.py run --dry-run     # "# 48 builds, 192 simulations"
pixi run python bench/bambu_probe.py run -j32 --sim questa --sim-jobs 32   # crashed in write(), see below
# fix: 44913cf, then from a clean build/probe and without the CSV:
rm -rf build/probe results_staging/probe_bam3a.csv
pixi run python bench/bambu_probe.py run -j32 --sim questa --sim-jobs 32
```

The first run built and simulated everything, wrote the CSV, then stopped with `KeyError: 'stall_run'` in `write()` before writing `probe_bam3a.md`: a failed-build row has no `stall_run`, `cycles`, `cycles_per_beat` or `reg_bits` key, and the table code indexes them. 44913cf makes `write()` fill every column first (`rows = [{c: r.get(c, "") for c in COLUMNS} for r in rows]`, as `bambu.py`'s `write_csv` does). I checked the fix on the first run's rows in scratch, then re-ran the whole probe. The second run's per-row results (status, cycles, cycles per beat, FSM states, reg bits) are identical to the first's.

## Results

44 of 48 builds ok; 88 of 96 rows ok; all 176 simulations that ran PASS, the stall runs included, each with only the known `out1` pair of Questa warnings (`Errors: 0, Warnings: 2`). The 4 failed builds are `--speculative-sdc-scheduling` on vecadd W = 8 and W = 32 (a2_sdc and a4_u4_sdc): Bambu segfaults right after the SDC scheduler's LP solve (`Long-step dual simplex will be used`, then `tool_select.sh: line 14: ... Segmentation fault (core dumped) $BINARY_PATH "$@"`). The CSV's `fail_reason` says only "Bambu wrote no Verilog": `bambu.py`'s `fail_reason_compile` does not pick up the segfault line.

Tables from `probe_bam3a.md` (largest size; stall is n64/n512):

### dot, W = 1 (n512)

| config | status | cycles | cycles/beat | stall | FSM states | reg bits | Bambu s |
|---|---|---|---|---|---|---|---|
| a0 | ok | 1536 | 3.00 | PASS/PASS | 9 | 514 | 9.0 |
| a1_u2 | ok | 1280 | 2.50 | PASS/PASS | 21 | 1216 | 8.7 |
| a1_u4 | ok | 1152 | 2.25 | PASS/PASS | 32 | 2056 | 11.7 |
| a1_u8 | ok | 1088 | 2.12 | PASS/PASS | 52 | 3343 | 8.4 |
| a2_sdc | ok | 1536 | 3.00 | PASS/PASS | 9 | 514 | 9.6 |
| a3_perf | ok | 1536 | 3.00 | PASS/PASS | 9 | 514 | 8.5 |
| a4_u4_sdc | ok | 1152 | 2.25 | PASS/PASS | 32 | 1931 | 8.8 |
| a4_u4_perf | ok | 1152 | 2.25 | PASS/PASS | 32 | 2056 | 8.4 |

### dot, W = 8 (n512)

| config | status | cycles | cycles/beat | stall | FSM states | reg bits | Bambu s |
|---|---|---|---|---|---|---|---|
| a0 | ok | 256 | 4.00 | PASS/PASS | 10 | 1538 | 12.2 |
| a1_u2 | ok | 224 | 3.50 | PASS/PASS | 24 | 2368 | 10.9 |
| a1_u4 | ok | 208 | 3.25 | PASS/PASS | 37 | 3336 | 11.7 |
| a1_u8 | ok | 200 | 3.12 | PASS/PASS | 61 | 4879 | 13.3 |
| a2_sdc | ok | 256 | 4.00 | PASS/PASS | 10 | 1538 | 9.9 |
| a3_perf | ok | 256 | 4.00 | PASS/PASS | 10 | 1538 | 10.6 |
| a4_u4_sdc | ok | 208 | 3.25 | PASS/PASS | 37 | 3211 | 41.9 |
| a4_u4_perf | ok | 208 | 3.25 | PASS/PASS | 37 | 3336 | 11.9 |

### dot, W = 32 (n512)

| config | status | cycles | cycles/beat | stall | FSM states | reg bits | Bambu s |
|---|---|---|---|---|---|---|---|
| a0 | ok | 64 | 4.00 | PASS/PASS | 10 | 4930 | 11.2 |
| a1_u2 | ok | 56 | 3.50 | PASS/PASS | 27 | 11905 | 15.4 |
| a1_u4 | ok | 52 | 3.25 | PASS/PASS | 37 | 8008 | 17.0 |
| a1_u8 | ok | 50 | 3.12 | PASS/PASS | 61 | 10831 | 25.7 |
| a2_sdc | ok | 64 | 4.00 | PASS/PASS | 10 | 4930 | 13.7 |
| a3_perf | ok | 64 | 4.00 | PASS/PASS | 10 | 4930 | 9.9 |
| a4_u4_sdc | ok | 52 | 3.25 | PASS/PASS | 37 | 7883 | 27.3 |
| a4_u4_perf | ok | 52 | 3.25 | PASS/PASS | 37 | 8008 | 18.5 |

### vecadd, W = 1 (n512)

| config | status | cycles | cycles/beat | stall | FSM states | reg bits | Bambu s |
|---|---|---|---|---|---|---|---|
| a0 | ok | 767 | 1.50 | PASS/PASS | 21 | 1091 | 10.9 |
| a1_u2 | ok | 1023 | 2.00 | PASS/PASS | 15 | 703 | 9.2 |
| a1_u4 | ok | 767 | 1.50 | PASS/PASS | 21 | 1091 | 12.5 |
| a1_u8 | ok | 639 | 1.25 | PASS/PASS | 29 | 1731 | 9.9 |
| a2_sdc | ok | 767 | 1.50 | PASS/PASS | 21 | 1091 | 11.0 |
| a3_perf | ok | 767 | 1.50 | PASS/PASS | 21 | 1091 | 8.6 |
| a4_u4_sdc | ok | 767 | 1.50 | PASS/PASS | 21 | 1091 | 12.2 |
| a4_u4_perf | ok | 767 | 1.50 | PASS/PASS | 21 | 1091 | 10.9 |

### vecadd, W = 8 (n512)

| config | status | cycles | cycles/beat | stall | FSM states | reg bits | Bambu s |
|---|---|---|---|---|---|---|---|
| a0 | ok | 191 | 2.98 | PASS/PASS | 8 | 1665 | 9.6 |
| a1_u2 | ok | 127 | 1.98 | PASS/PASS | 15 | 2940 | 10.3 |
| a1_u4 | ok | 95 | 1.48 | PASS/PASS | 21 | 4227 | 9.7 |
| a1_u8 | ok | 79 | 1.23 | PASS/PASS | 29 | 6659 | 11.8 |
| a2_sdc | failed: compile | - | - | -/- | - | - | 10.3 |
| a3_perf | ok | 191 | 2.98 | PASS/PASS | 8 | 1665 | 9.5 |
| a4_u4_sdc | failed: compile | - | - | -/- | - | - | 11.2 |
| a4_u4_perf | ok | 95 | 1.48 | PASS/PASS | 21 | 4227 | 10.0 |

### vecadd, W = 32 (n512)

| config | status | cycles | cycles/beat | stall | FSM states | reg bits | Bambu s |
|---|---|---|---|---|---|---|---|
| a0 | ok | 47 | 2.94 | PASS/PASS | 8 | 6273 | 10.3 |
| a1_u2 | ok | 31 | 1.94 | PASS/PASS | 15 | 10618 | 15.4 |
| a1_u4 | ok | 23 | 1.44 | PASS/PASS | 21 | 14979 | 24.0 |
| a1_u8 | ok | 19 | 1.19 | PASS/PASS | 29 | 23555 | 40.0 |
| a2_sdc | failed: compile | - | - | -/- | - | - | 11.1 |
| a3_perf | ok | 47 | 2.94 | PASS/PASS | 8 | 6273 | 10.6 |
| a4_u4_sdc | failed: compile | - | - | -/- | - | - | 41.8 |
| a4_u4_perf | ok | 23 | 1.44 | PASS/PASS | 21 | 14979 | 22.0 |

At n64 (from the CSV), the unrolled configs are slower than a0 when the loop has fewer beats than U: vecadd W = 32 n64 (2 beats) takes 3 cycles with u2 but 6 with u4 and u8 (a0: 5), and dot W = 32 n64 takes 9 with u4 and u8 (a0: 8; u2: 7). Those 2 beats run through the remainder loop.

## Step 5: a0 against bambu_cycles.csv

a0 matches the committed `bambu` rows at all 12 points on cycles, cycles_done, latency, FSM states and stall result: vecadd n512 767 (W = 1), 191 (W = 8), 47 (W = 32); dot n512 1536, 256, 64; and the n64 rows. a0's Verilog is identical to `rtl/done/<k>/bambu_w<W>/` at vecadd W = 8 and 32 and dot W = 8, and differs only in SIMPLEJOIN_FU `.ops` operand order at vecadd W = 1, dot W = 1 and dot W = 32 (checked per instance: same operand sets, rest identical). The Bambu command is the same in both (same `bambu_cmd`); only the build folder differs (`build/probe/a0/<k>/w<W>` against `build/done/<k>/w<W>`). So the operand order can change between two builds of the same command. R1's note (`2026-11-05_bambu_r1.md`) concluded from vecadd W = 8 alone that it changes only with the command; that is not right in general.

## Step 6: did the BEAT unroll factor take effect?

Bambu's log (default verbosity) has no unroll remark, pragma message or warning for any config: no line mentions `unroll`, `pragma`, `factor` or `warning`. The answer comes from the RTL. "Start states per stream" counts the FSM states that start each stream module (the selectors ORed into its `start_port`). A loop unrolled U times with a remainder loop gives U + 1 (U in the main loop, 1 in the remainder loop).

| kernel | W | config | FSM states | reg bits | start states per stream | complex ops | mem alloc (internal bits) | RAM modules | Verilog lines |
|---|---|---|---|---|---|---|---|---|---|
| vecadd | 1 | a0 | 21 | 1091 | A:5 B:5 C:5 | 15 | 0/0 | - | 3038 |
| vecadd | 1 | a1_u2 | 15 | 703 | A:3 B:3 C:3 | 9 | 0/0 | - | 2258 |
| vecadd | 1 | a1_u4 | 21 | 1091 | A:5 B:5 C:5 | 15 | 0/0 | - | 3038 |
| vecadd | 1 | a1_u8 | 29 | 1731 | A:9 B:9 C:9 | 27 | 0/0 | - | 4300 |
| vecadd | 1 | a2_sdc | 21 | 1091 | A:5 B:5 C:5 | 15 | 0/0/0 | - | 3038 |
| vecadd | 1 | a3_perf | 21 | 1091 | A:5 B:5 C:5 | 15 | 0/0 | - | 3038 |
| vecadd | 1 | a4_u4_sdc | 21 | 1091 | A:5 B:5 C:5 | 15 | 0/0/0 | - | 3038 |
| vecadd | 1 | a4_u4_perf | 21 | 1091 | A:5 B:5 C:5 | 15 | 0/0 | - | 3038 |
| vecadd | 8 | a0 | 8 | 1665 | A:1 B:1 C:1 | 3 | 0 | - | 2425 |
| vecadd | 8 | a1_u2 | 15 | 2940 | A:3 B:3 C:3 | 9 | 0/0 | - | 5442 |
| vecadd | 8 | a1_u4 | 21 | 4227 | A:5 B:5 C:5 | 15 | 0/0 | - | 8303 |
| vecadd | 8 | a1_u8 | 29 | 6659 | A:9 B:9 C:9 | 27 | 0/0 | - | 13718 |
| vecadd | 8 | a2_sdc | segfault | - | - | 3 | 0 | - | - |
| vecadd | 8 | a3_perf | 8 | 1665 | A:1 B:1 C:1 | 3 | 0 | - | 2425 |
| vecadd | 8 | a4_u4_sdc | segfault | - | - | 15 | 0/0 | - | - |
| vecadd | 8 | a4_u4_perf | 21 | 4227 | A:5 B:5 C:5 | 15 | 0/0 | - | 8303 |
| vecadd | 32 | a0 | 8 | 6273 | A:1 B:1 C:1 | 3 | 0 | - | 5785 |
| vecadd | 32 | a1_u2 | 15 | 10618 | A:3 B:3 C:3 | 9 | 0/0 | - | 15234 |
| vecadd | 32 | a1_u4 | 21 | 14979 | A:5 B:5 C:5 | 15 | 0/0 | - | 24527 |
| vecadd | 32 | a1_u8 | 29 | 23555 | A:9 B:9 C:9 | 27 | 0/0 | - | 42806 |
| vecadd | 32 | a2_sdc | segfault | - | - | 3 | 0 | - | - |
| vecadd | 32 | a3_perf | 8 | 6273 | A:1 B:1 C:1 | 3 | 0 | - | 5785 |
| vecadd | 32 | a4_u4_sdc | segfault | - | - | 15 | 0/0 | - | - |
| vecadd | 32 | a4_u4_perf | 21 | 14979 | A:5 B:5 C:5 | 15 | 0/0 | - | 24527 |
| dot | 1 | a0 | 9 | 514 | A:1 B:1 out:1 | 3 | 0 | - | 1588 |
| dot | 1 | a1_u2 | 21 | 1216 | A:3 B:3 out:3 | 9 | 0/0 | - | 3134 |
| dot | 1 | a1_u4 | 32 | 2056 | A:5 B:5 out:5 | 15 | 0/0 | - | 4563 |
| dot | 1 | a1_u8 | 52 | 3343 | A:9 B:9 out:9 | 27 | 0/0 | - | 6821 |
| dot | 1 | a2_sdc | 9 | 514 | A:1 B:1 out:1 | 3 | 0/0 | - | 1588 |
| dot | 1 | a3_perf | 9 | 514 | A:1 B:1 out:1 | 3 | 0 | - | 1588 |
| dot | 1 | a4_u4_sdc | 32 | 1931 | A:5 B:5 out:5 | 15 | 0/0/0 | - | 4474 |
| dot | 1 | a4_u4_perf | 32 | 2056 | A:5 B:5 out:5 | 15 | 0/0 | - | 4563 |
| dot | 8 | a0 | 10 | 1538 | A:1 B:1 out:1 | 3 | 0 | - | 2542 |
| dot | 8 | a1_u2 | 24 | 2368 | A:3 B:3 out:3 | 9 | 0/0 | - | 5637 |
| dot | 8 | a1_u4 | 37 | 3336 | A:5 B:5 out:5 | 15 | 0/0 | - | 8707 |
| dot | 8 | a1_u8 | 61 | 4879 | A:9 B:9 out:9 | 27 | 0/0 | - | 14242 |
| dot | 8 | a2_sdc | 10 | 1538 | A:1 B:1 out:1 | 3 | 0/0 | - | 2542 |
| dot | 8 | a3_perf | 10 | 1538 | A:1 B:1 out:1 | 3 | 0 | - | 2542 |
| dot | 8 | a4_u4_sdc | 37 | 3211 | A:5 B:5 out:5 | 15 | 0/0/0 | - | 8618 |
| dot | 8 | a4_u4_perf | 37 | 3336 | A:5 B:5 out:5 | 15 | 0/0 | - | 8707 |
| dot | 32 | a0 | 10 | 4930 | A:1 B:1 out:1 | 3 | 0 | - | 5067 |
| dot | 32 | a1_u2 | 27 | 11905 | A:3 B:3 out:3 | 9 | 0/0 | - | 15475 |
| dot | 32 | a1_u4 | 37 | 8008 | A:5 B:5 out:5 | 15 | 0/0 | - | 22740 |
| dot | 32 | a1_u8 | 61 | 10831 | A:9 B:9 out:9 | 27 | 0/0 | - | 39879 |
| dot | 32 | a2_sdc | 10 | 4930 | A:1 B:1 out:1 | 3 | 0/0 | - | 5067 |
| dot | 32 | a3_perf | 10 | 4930 | A:1 B:1 out:1 | 3 | 0 | - | 5067 |
| dot | 32 | a4_u4_sdc | 37 | 7883 | A:5 B:5 out:5 | 15 | 0/0/0 | - | 22651 |
| dot | 32 | a4_u4_perf | 37 | 8008 | A:5 B:5 out:5 | 15 | 0/0 | - | 22740 |

- a1_u2, a1_u4, a1_u8: the factor took effect at every kernel and W: U + 1 = 3, 5, 9 start states per stream, FSM states and register bits growing with U. One exception in kind: at vecadd W = 1 a0 is already a 4× loop (R3's side look: Bambu's front end unrolls it by itself). There `factor=4` gives the same design as a0 (16 lines differ, SIMPLEJOIN order and numbering), `factor=2` replaces the default 4 and makes it slower (2.00 cycles per beat instead of 1.50), and `factor=8` makes it faster (1.25).
- a4_u4_perf: identical to a1_u4 (4 to 16 lines differ); BAMBU-PERFORMANCE-MP adds nothing on top of the unroll.
- a4_u4_sdc: same structure and cycles as a1_u4 where it builds (dot, vecadd W = 1); 125 fewer register bits for dot at every W; segfault at vecadd W = 8 and 32.
- a2_sdc and a3_perf (no unroll): same cycles, FSM states and register bits as a0 everywhere they build. a3_perf's Verilog is a0's up to 4 lines; a2_sdc's differs in many lines (212 to 3318) but not in cycles or register bits.
- No config allocates a memory (`Internally allocated memory: 0`, no RAM module). The u2/u4/u8 logs print an extra "Memory allocation information" block, with 0.

## Step 7: best config per kernel and W

By n512 cycles, the best is a1_u8 at every kernel and W (no ties):

| kernel | W | config | n512 cycles (a0) | cycles per beat (a0) | reg bits (a0) |
|---|---|---|---|---|---|
| vecadd | 1 | a1_u8 | 639 (767) | 1.25 (1.50) | 1731 (1091) |
| vecadd | 8 | a1_u8 | 79 (191) | 1.23 (2.98) | 6659 (1665) |
| vecadd | 32 | a1_u8 | 19 (47) | 1.19 (2.94) | 23555 (6273) |
| dot | 1 | a1_u8 | 1088 (1536) | 2.12 (3.00) | 3343 (514) |
| dot | 8 | a1_u8 | 200 (256) | 3.12 (4.00) | 4879 (1538) |
| dot | 32 | a1_u8 | 50 (64) | 3.12 (4.00) | 10831 (4930) |

Controllers (`module controller_*`, read with a script that maps each state's selectors to the stream module it starts):

- vecadd a1_u8, same FSM at W = 1, 8 and 32 (29 states): the main loop is the even states S_6 to S_24. S_6 reads A and B (beat 1); S_8 to S_20 each read the next beat and write C for the previous one; S_22 writes the last C; S_24 branches back to S_6 or on to the remainder check. One pass is 10 states for 8 beats (1.25 cycles per beat), and the odd states are wait states taken only on a stall. Checks: W = 8 n512 is 8 passes × 10 = 80 (measured 79), W = 1 n512 64 × 10 = 640 (639), W = 32 n512 2 × 10 = 20 (19). In general a pass is U + 2 states for U beats, which gives u2 2.00 and u4 1.50 as measured. The remainder loop (S_0, S_2, S_4: one beat per 3 states) is what W = 32 n64 runs.
- dot a1_u8 at W = 8 and 32 (61 states): no overlap between beats. Each beat is three states: read A and B (S_34), compute (S_36), then a branch state (S_37) that either goes to an `out` write (S_38, the `if (cnt + 1 == T || b + 1 == beats)` in the source) or to the next beat's read (S_30). After the 8th beat, S_5 closes the pass. One pass is 3 × 8 + 1 = 25 states for 8 beats (3.125 cycles per beat): 8 passes × 25 = 200 at W = 8 n512, as measured. a0 takes 4 states per beat, so unrolling only removes the loop back edge, once per pass instead of once per beat. Each unrolled copy keeps its own `out` branch, hence the 8 `out` write states plus 1 in the remainder loop.
- dot a1_u8 at W = 1 (52 states): the same shape with two states per beat (read S_26, branch S_28 to `out` or the next read) plus one per pass: 17 states for 8 beats (2.125 cycles per beat), 64 passes × 17 = 1088 as measured. In general (2U + 1) / U at W = 1 and (3U + 1) / U at W = 8 and 32, which matches u2 and u4.

How sure: high. The state maps come from the controllers, and the pass lengths match the measured cycles at every a1 point. I did not look at waveforms.

## Bambu wall times

Seconds per build (`bambu_s`, container start to exit), second run:

| config | vecadd W=1 | vecadd W=8 | vecadd W=32 | dot W=1 | dot W=8 | dot W=32 |
|---|---|---|---|---|---|---|
| a0 | 10.9 | 9.6 | 10.3 | 9.0 | 12.2 | 11.2 |
| a1_u2 | 9.2 | 10.3 | 15.4 | 8.7 | 10.9 | 15.4 |
| a1_u4 | 12.5 | 9.7 | 24.0 | 11.7 | 11.7 | 17.0 |
| a1_u8 | 9.9 | 11.8 | 40.0 | 8.4 | 13.3 | 25.7 |
| a2_sdc | 11.0 | 10.3 (segfault) | 11.1 (segfault) | 9.6 | 9.9 | 13.7 |
| a3_perf | 8.6 | 9.5 | 10.6 | 8.5 | 10.6 | 9.9 |
| a4_u4_sdc | 12.2 | 11.2 (segfault) | 41.8 (segfault) | 8.8 | 41.9 | 27.3 |
| a4_u4_perf | 10.9 | 10.0 | 22.0 | 8.4 | 11.9 | 18.5 |

Sum of the 48 builds: 677 s. Whole run (48 builds at `-j32`, then 176 simulations at 32 at a time): 76 s, both runs.

## Unexpected

- `bambu_probe.py` crashed in `write()` on failed-build rows (fixed in 44913cf, rerun, same results).
- `--speculative-sdc-scheduling` segfaults Bambu on vecadd W = 8 and 32 (512- and 2048-bit vectors), with and without the unroll; dot and vecadd W = 1 build. Where it builds it never changes cycles. The CSV's fail reason does not say segfault.
- BAMBU-PERFORMANCE-MP changes nothing for these kernels.
- At vecadd W = 1, `factor=2` is slower than no factor: the pragma replaces the front end's own 4× unroll.
- The gain differs by kernel: vecadd's unrolled beats overlap (U + 2 states for U beats), dot's do not (each beat keeps its `out` branch), so dot only drops to 3.12 cycles per beat at W = 8 and 32 even with u8.
- Register bits are not monotonic in U for dot W = 32: u2 11905, u4 8008, u8 10831 (a0 4930).
- With U above the beat count, the unrolled designs are slower than a0 (W = 32 n64).
- SIMPLEJOIN_FU operand order can differ between two builds of the same command (step 5).
- Untracked `rtl/done/vecadd/opt_w8_c10/` and `rtl/done/vecmul/opt_w8_c10/` are left untouched and not committed.
