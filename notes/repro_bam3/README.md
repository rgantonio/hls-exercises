# Bambu 2026.11 wide-beat bug: one-beat reproducer (BAM3)

Fault 2 of BAM3 probe B (`results_staging/runs/2026-11-05_bambu_probe_b2.md`): Bambu 2026.11 computes wrong low words in the upper lanes of a beat wider than 24 lanes. This is one beat of vecadd with no loop over beats and no loop pipelining involved, and a well-defined source (the output beat is `= 0`).

- `repro.cpp`: `void vadd(const vec_t A[1], const vec_t B[1], vec_t C[1])`, A, B and C axis ports as in our kernels, `vec_t` = `ac_int<64*LANES, false>`; it adds lane by lane with `slc<64>` / `set_slc` (our `lane` / `set_lane`). `-DLANES=<n>` sets the lanes, `-DINIT=1` declares `c = 0` (`-DINIT=0` leaves it uninitialized, which is fault 1, our source's bug, fixed in 542fa32).
- `tb.sv`: drives one beat (both 32-bit words of every lane nonzero, no carry between words) and compares every 32-bit word of C.
- `build1.sh <dir> <bambu binary> <LANES> <INIT>`: copies `repro.cpp` into `<dir>` (inside the repo) and runs Bambu there through `bench/tools/in_bambu.sh`, with the `bambu` case's flags (nangate45, 10 ns, I386_CLANG16, `--generate-interface=INFER`).
- `sim1.sh <dir> <LANES>`: Questa on the host (vlog, vsim) on that Verilog; prints PASS or FAIL and the wrong words.

What it shows, with `c = 0`:

| Bambu | LANES | result |
|---|---|---|
| 2026.11 | 8, 16, 24 | PASS |
| 2026.11 | 28 | FAIL: lane 26's low word is 0x000000a8, expected 0x000012ba (1 of 56 words) |
| 2026.11 | 32 | FAIL: lane 26's low word wrong (0xa8), lanes 27 to 30 low words 0 (5 of 64 words) |
| 2024.10 | 28, 32 | PASS |

With loop pipelining off (`--bambu-parameter=LP-BB-list=0`) the full kernels show the same words. A lane-by-lane copy (C = A) instead of the add passes at 32 lanes. Checked on the native build of 2026.11 (probe B round 2) and again on the generic x86-64 build (BAM3 R1, 2026-11-05).

Run (from the repo root; Bambu 2026.11 from `bench/tools/build_bambu_2611.sh`, 2024.10 from `pixi run get-bambu`):

```bash
bash notes/repro_bam3/build1.sh build/repro_bam3/2611_L28 bambu-2026.11 28 1
bash notes/repro_bam3/sim1.sh   build/repro_bam3/2611_L28 28
#   FAIL LANES=28 beats_out=1: 1 of 56 words differ | lane 26 lo word: got 000000a8 expected 000012ba;
bash notes/repro_bam3/build1.sh build/repro_bam3/2410_L28 bambu 28 1
bash notes/repro_bam3/sim1.sh   build/repro_bam3/2410_L28 28
#   PASS LANES=28 beats_out=1: 0 of 56 words differ
```
