# BAM3 probe B, round 2: uninitialized output beat or loop pipeliner? 2026-11-05

Probe B (`2026-11-05_bambu_probe_b.md`) found that Bambu 2026.11 builds vecadd and relu at W = 8 and 32 with wrong 32-bit words in the output beat. The hypothesis was that our sources leave the output beat uninitialized (`vec_t a = A[b], bb = B[b], c;`), so ac_int's `set_slc` reads an indeterminate old value, and 2026.11's front end folds that differently from 2024.10. This round ran two configs of `bench/bambu_probe.py --probe b` on the five elementwise kernels (vecadd, vecmul, matadd, relu, axpy) at W = 1, 8, 32:

| config | change from b0 |
|---|---|
| b1_init | the output beat declared `= 0` in the probe's source copy (`c = 0;` or `o = 0;`), nothing else |
| b2_nolp | `--panda-parameter=LP-BB-list=0` (loop pipelining off) |

Outputs: `results_staging/probe_bam3b.csv` and `probe_bam3b.md`, with the 23 b0 rows kept. `rtl/`, `results_staging/bambu_cycles.csv` and the kernel sources are unchanged (`git status`). Code at 2e6e5fc.

## Commands

```bash
git pull                       # main at 2e6e5fc
rm -rf build/probe/b1_init build/probe/b2_nolp   # neither existed; build/probe/b0 kept
lmutil lmstat -a -c 1717@licserv     # msimhdlsim: 75 issued, 1 in use -> --sim-jobs 32
pixi run python bench/bambu_probe.py run --probe b --config b1_init b2_nolp --kernel vecadd vecmul matadd relu axpy --w 1 8 32 --dry-run
#   "# 30 builds, 120 simulations"
pixi run python bench/bambu_probe.py run --probe b --config b1_init b2_nolp --kernel vecadd vecmul matadd relu axpy --w 1 8 32 -j32 --sim questa --sim-jobs 32
```

The run took 26 s and wrote 60 rows: b1_init 20 ok, 10 failed: sim; b2_nolp 30 failed: compile. The b1_init source copies differ from the kernel sources only in the pragma lines and the initializer, for example `build/probe/b1_init/vecadd/w8/vecadd.cpp`: the three axis pragmas, `#pragma HLS unroll`, and `vec_t a = A[b], bb = B[b], c = 0;`. relu and axpy name the beat `o` (`vec_t a = A[b], o = 0;`, `vec_t xb = x[b], yb = y[b], o = 0;`).

## Results

- b1_init passes every simulation at W = 1 and W = 8 for all five kernels, the stall runs included, at 1.02 cycles per beat (n512), with the same FSM states (8) and register bits as b0 (vecadd W = 8: 1666). The initializer costs nothing.
- b1_init still fails at W = 32 for all five kernels (79 to 80 of 512 lanes for vecadd, vecmul, matadd and axpy, 50 for relu), with a different, smaller set of wrong words than b0 (step 6).
- b2_nolp did not build: Bambu 2026.11 rejects the option (step 5). The CSV rows say `failed: compile`. To answer step 7 anyway, the same builds were rerun by hand with the option's 2026.11 spelling, outside the script (step 5).

Tables from `probe_bam3b.md` (largest size; `stall` is the random-stall run at each size, smaller size first; `2024.10` is the `bambu` case's cycles from `bambu_cycles.csv`). The b0 rows are probe B's; b0 never ran vecmul, matadd or axpy.

### axpy, W = 1 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b1_init | ok | 513 | 1.00 | 1023 | PASS/PASS | 8 | 322 | BB2 II=1 lat=2 | 15.9 |
| b2_nolp | failed: compile | - | - | 1023 | -/- | - | - | - | 3.1 |

### axpy, W = 8 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b1_init | ok | 65 | 1.02 | 191 | PASS/PASS | 8 | 1666 | BB2 II=1 lat=2 | 16.3 |
| b2_nolp | failed: compile | - | - | 191 | -/- | - | - | - | 3.2 |

### axpy, W = 32 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b1_init | failed: sim | - | - | 47 | FAIL/FAIL | 8 | 6274 | BB2 II=1 lat=2 | 16.3 |
| b2_nolp | failed: compile | - | - | 47 | -/- | - | - | - | 2.9 |

### dot, W = 1 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 513 | 1.00 | 1536 | PASS/PASS | 8 | 452 | BB2 II=1 lat=2 | 13.6 |

### dot, W = 8 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 128 | 2.00 | 256 | PASS/PASS | 11 | 1347 | BB2 II=2 lat=3 | 16.4 |

### dot, W = 32 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 18 | 1.12 | 64 | PASS/PASS | 15 | 4805 | BB2 II=1 lat=3 | 15.9 |

### matadd, W = 1 (m16_n32)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b1_init | ok | 513 | 1.00 | 767 | PASS/PASS | 8 | 322 | BB2 II=1 lat=2 | 15.4 |
| b2_nolp | failed: compile | - | - | 767 | -/- | - | - | - | 2.9 |

### matadd, W = 8 (m16_n32)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b1_init | ok | 65 | 1.02 | 191 | PASS/PASS | 8 | 1666 | BB2 II=1 lat=2 | 17.6 |
| b2_nolp | failed: compile | - | - | 191 | -/- | - | - | - | 3.4 |

### matadd, W = 32 (m16_n32)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b1_init | failed: sim | - | - | 47 | FAIL/FAIL | 8 | 6274 | BB2 II=1 lat=2 | 16.9 |
| b2_nolp | failed: compile | - | - | 47 | -/- | - | - | - | 3.0 |

### relu, W = 1 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 513 | 1.00 | 1023 | PASS/PASS | 8 | 225 | BB2 II=1 lat=2 | 15.2 |
| b1_init | ok | 513 | 1.00 | 1023 | PASS/PASS | 8 | 225 | BB2 II=1 lat=2 | 17.0 |
| b2_nolp | failed: compile | - | - | 1023 | -/- | - | - | - | 3.0 |

### relu, W = 8 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | failed: sim | - | - | 191 | FAIL/FAIL | 8 | 1121 | BB2 II=1 lat=2 | 13.8 |
| b1_init | ok | 65 | 1.02 | 191 | PASS/PASS | 8 | 1121 | BB2 II=1 lat=2 | 15.9 |
| b2_nolp | failed: compile | - | - | 191 | -/- | - | - | - | 2.9 |

### relu, W = 32 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | failed: sim | - | - | 47 | FAIL/FAIL | 8 | 4193 | BB2 II=1 lat=2 | 15.1 |
| b1_init | failed: sim | - | - | 47 | FAIL/FAIL | 8 | 4193 | BB2 II=1 lat=2 | 17.3 |
| b2_nolp | failed: compile | - | - | 47 | -/- | - | - | - | 3.3 |

### rowsum, W = 1 (m8_n64)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 513 | 1.00 | 1287 | PASS/PASS | 8 | 356 | BB2 II=1 lat=2 | 15.2 |

### rowsum, W = 8 (m8_n64)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 65 | 1.02 | 199 | PASS/PASS | 8 | 804 | BB2 II=1 lat=2 | 15.0 |

### rowsum, W = 32 (m8_n64)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 18 | 1.12 | 71 | PASS | 15 | 2469 | BB2 II=1 lat=3 | 14.2 |

### vecadd, W = 1 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 513 | 1.00 | 767 | PASS/PASS | 8 | 322 | BB2 II=1 lat=2 | 13.7 |
| b1_init | ok | 513 | 1.00 | 767 | PASS/PASS | 8 | 322 | BB2 II=1 lat=2 | 15.9 |
| b2_nolp | failed: compile | - | - | 767 | -/- | - | - | - | 2.8 |

### vecadd, W = 8 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | failed: sim | - | - | 191 | FAIL/FAIL | 8 | 1666 | BB2 II=1 lat=2 | 14.9 |
| b1_init | ok | 65 | 1.02 | 191 | PASS/PASS | 8 | 1666 | BB2 II=1 lat=2 | 15.1 |
| b2_nolp | failed: compile | - | - | 191 | -/- | - | - | - | 2.8 |

### vecadd, W = 32 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | failed: sim | - | - | 47 | FAIL/FAIL | 8 | 6274 | BB2 II=1 lat=2 | 15.0 |
| b1_init | failed: sim | - | - | 47 | FAIL/FAIL | 8 | 6274 | BB2 II=1 lat=2 | 19.0 |
| b2_nolp | failed: compile | - | - | 47 | -/- | - | - | - | 2.9 |

### vecmul, W = 1 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b1_init | ok | 513 | 1.00 | 767 | PASS/PASS | 8 | 322 | BB2 II=1 lat=2 | 17.1 |
| b2_nolp | failed: compile | - | - | 767 | -/- | - | - | - | 3.1 |

### vecmul, W = 8 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b1_init | ok | 65 | 1.02 | 191 | PASS/PASS | 8 | 1666 | BB2 II=1 lat=2 | 15.2 |
| b2_nolp | failed: compile | - | - | 191 | -/- | - | - | - | 3.2 |

### vecmul, W = 32 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b1_init | failed: sim | - | - | 47 | FAIL/FAIL | 8 | 6274 | BB2 II=1 lat=2 | 16.7 |
| b2_nolp | failed: compile | - | - | 47 | -/- | - | - | - | 2.9 |

## Step 5: b2_nolp

Bambu 2026.11 does not know `--panda-parameter`. Every b2_nolp log ends:

```
bambu: unrecognized option '--panda-parameter=LP-BB-list=0'
error -> Bad command-line parameter format. Please check the provided options and in case run --help. Please check input options/files and run --help if needed.
```

In 2026.11 the option is `--bambu-parameter=<name>=<value>` (`src/Parameter.hpp:162`, `{"bambu-parameter", required_argument, ...}`; `--list-bambu-parameters` lists the names). `LP-BB-list` itself exists: `parametric_list_based.cpp` makes a loop eligible for pipelining only if its header block number is in the list, so `LP-BB-list=0` leaves no loop eligible, as intended. `bench/bambu_probe.py` is unchanged; its b2_nolp flag would need to read `--bambu-parameter=LP-BB-list=0`.

By hand, in `build/b2_nolp_hand/<kernel>/w<W>/`: the probe's own b2_nolp source copy (the b0 source, pragmas only) and its `cmd.txt` with `--panda-parameter=` replaced by `--bambu-parameter=`, all 15 points; simulated with the probe's Questa commands (copied from the b1_init sim folders, same vectors, both sizes, no-stall and stall) and the raised-print-limit testbench copy in `build/diag_words/tb/`.

- Bambu accepted the option. No loop was pipelined: none of the 15 logs has an `II=... solution found for loop`, `minII`/`maxII`, `Iteration latency` or `Initiation Interval` line. Every build has 6 FSM states.
- Cycles per beat: 2.00 for every kernel at every W (n512: 1024 cycles for 512 beats at W = 1, 128 for 64 beats at W = 8, 32 for 16 beats at W = 32). 2024.10 (`bambu_cycles.csv`, n512) needs 2.94 to 2.98 at W = 8 and 32, where 2026.11 without loop pipelining is faster, but 1.50 (vecadd, vecmul, matadd) or 2.00 (relu, axpy) at W = 1, where it is slower or equal.
- W = 1: all 20 simulations PASS. W = 8 and W = 32: all 20 simulations of each FAIL, with exactly b0's mismatch counts where b0 ran (vecadd W = 8: 94 of 512, relu W = 8: 32, vecadd W = 32: 104, relu W = 32: 57) and the stall runs at twice the no-stall count.

## Step 6: wrong words

From the raised-print-limit testbench (`build/diag_words/tb/`, `bad < 1000000` instead of `bad < 3`; `tb/` unchanged), largest size, no-stall run; "L26 lo" is lane 26's low 32-bit word, and every wrong word is 0 unless marked:

| config | kernel | W | lanes wrong (of 512) | wrong words (times seen) |
|---|---|---|---|---|
| b1_init | vecadd | 32 | 79 | L26 lo, not 0 (15); L27 lo (16); L28 lo (16); L29 lo (16); L30 lo (16) |
| b1_init | vecmul | 32 | 80 | L26 lo (1, and 15 not 0); L27 to L30 lo (16 each) |
| b1_init | matadd | 32 | 79 | L26 lo, not 0 (15); L27 to L30 lo (16 each) |
| b1_init | axpy | 32 | 80 | L26 lo, not 0 (16); L27 to L30 lo (16 each) |
| b1_init | relu | 32 | 50 | L26 lo, not 0 (7); L27 lo (10); L28 lo (8); L29 lo (10); L30 lo (9); L31 lo (6) |
| b2_nolp (by hand) | vecadd | 8 | 94 | L0 hi (30); L1 lo (64) |
| b2_nolp (by hand) | vecmul | 8 | 89 | L0 hi (25); L1 lo (64) |
| b2_nolp (by hand) | matadd | 8 | 94 | L0 hi (30); L1 lo (64) |
| b2_nolp (by hand) | axpy | 8 | 89 | L0 hi (25); L1 lo (64) |
| b2_nolp (by hand) | relu | 8 | 32 | L1 lo (32) |
| b2_nolp (by hand) | vecadd | 32 | 104 | L0 hi (9); L1 lo (16); L26 lo, not 0 (15); L27 to L30 lo (16 each) |
| b2_nolp (by hand) | vecmul | 32 | 104 | L0 hi (8); L1 lo (16); L26 lo (1, and 15 not 0); L27 to L30 lo (16 each) |
| b2_nolp (by hand) | matadd | 32 | 104 | L0 hi (9); L1 lo (16); L26 lo, not 0 (15); L27 to L30 lo (16 each) |
| b2_nolp (by hand) | axpy | 32 | 105 | L0 hi (9); L1 lo (16); L26 lo, not 0 (16); L27 to L30 lo (16 each) |
| b2_nolp (by hand) | relu | 32 | 57 | L1 lo (7); L26 lo, not 0 (7); L27 lo (10); L28 lo (8); L29 lo (10); L30 lo (9); L31 lo (6) |

A zeroed word only shows as a mismatch where the expected word is nonzero, so the counts follow the data (relu outputs 0 for negative lanes, so its counts are lower and its high words are always 0). The words split into two faults:

- Fault 1: lane 0's high word and lane 1's low word. Present at W = 8 and 32 with and without loop pipelining, gone with `= 0`.
- Fault 2: the low words of lanes 26 to 30 (relu: 26 to 31), lane 26's partly wrong rather than 0. Only at W = 32, with and without loop pipelining, and still there with `= 0`.

## Step 7: which hypothesis

By the round's rule it is (c): both configs fail (b1_init at W = 32; b2_nolp, by hand, at W = 8 and 32). The loop pipeliner is not the cause of either fault: b2_nolp shows both with no loop pipelined. In detail:

- Fault 1 is the uninitialized output beat. It is the only fault at W = 8, and `= 0` removes it there for all five kernels. The source reads an indeterminate value (`set_slc` on an uninitialized ac_int), so 2026.11's result is not wrong by C++ rules; 2024.10's front end happened to give the intended value. The kernel sources should initialize the beat.
- Fault 2 is something else in 2026.11: the source is well defined, 2024.10 builds it correctly, and loop pipelining is off.

### Reproducer (build/repro_bam3/)

`repro.cpp` is one beat of vecadd with no loop over beats: `void vadd(const vec_t A[1], const vec_t B[1], vec_t C[1])` with the three axis pragmas, `vec_t a = A[0], b = B[0], c;` (or `c = 0;` with `-DINIT=1`), the unrolled lane loop with `slc<64>` and `set_slc`, and `C[0] = c;`. `-DLANES=<n>` sets the lanes. `tb.sv` drives one beat (both words of every lane nonzero, no carry between words) and compares every 32-bit word of C. `build1.sh` runs Bambu in the container (the probe's flags: nangate45, 10 ns, I386_CLANG16, `--generate-interface=INFER`); `sim1.sh` runs Questa. (By-value `ac_int` arguments instead of axis arrays do not build on either version: 2026.11 stops with `Not matched parameter name: P2`, 2024.10 with `map::at`.)

| Bambu | LANES | output beat | result |
|---|---|---|---|
| 2024.10 | 8 | uninitialized | PASS |
| 2024.10 | 8 | `= 0` | PASS |
| 2024.10 | 32 | uninitialized | PASS |
| 2024.10 | 32 | `= 0` | PASS |
| 2026.11 | 8 | uninitialized | FAIL: L0 hi, L1 lo = 0 (fault 1) |
| 2026.11 | 8 | `= 0` | PASS |
| 2026.11 | 32 | uninitialized | FAIL: L0 hi, L1 lo, L26 to L30 lo (faults 1 and 2) |
| 2026.11 | 32 | `= 0` | FAIL: L26 lo = 0xa8 (expected 0x12ba), L27 to L30 lo = 0 (fault 2) |

Further variants in `build/repro_bam3/v/` (2026.11, `repro_op.cpp`, `-DCOPY=1` copies A's lanes instead of adding):

| variant | result |
|---|---|
| copy, LANES = 8, uninitialized | FAIL: 15 of 16 words wrong (only L0 lo right) |
| copy, LANES = 32, `= 0` | PASS |
| add, LANES = 16, uninitialized | FAIL: L0 hi, L1 lo |
| add, LANES = 16, `= 0` | PASS |
| add, LANES = 24, `= 0` | PASS |
| add, LANES = 28, `= 0` | FAIL: L26 lo only |

So the smallest case of fault 1 is the 8-lane one-beat vecadd with `c` uninitialized (2 wrong words); of fault 2, the 28-lane one-beat vecadd with `c = 0` (1 wrong word, lane 26's low word). Fault 2 needs the add (a plain copy is right) and a beat wider than 24 lanes (1536 bits). The prompt asked for vecadd W = 8; at W = 8 only fault 1 exists, so fault 2's reproducer needs 28 or 32 lanes.

## Unexpected

- `--panda-parameter` is not an option of Bambu 2026.11; it is `--bambu-parameter`. All 30 b2_nolp rows in the CSV are compile failures for that reason only.
- 2026.11 with loop pipelining off takes 2.00 cycles per beat (6 states) at every W: better than 2024.10 at W = 8 and 32 (2.94 to 2.98), worse at W = 1 for vecadd, vecmul and matadd (1.50).
- The fault 1 words are the same two in every kernel and width (lane 0 high, lane 1 low), not the end words of every lane; with a plain copy instead of an add, 15 of 16 words go wrong.
- Fault 2 depends on the beat width (none at 24 lanes, one word at 28, five at 32) and on the add, and leaves lane 26's low word with a small nonzero value.
- The by-hand vecmul W = 8 build took 43 s; the other by-hand builds took 14 to 16 s, the b1_init builds 15.1 to 19.0 s.
