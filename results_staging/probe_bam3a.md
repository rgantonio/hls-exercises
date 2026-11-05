# BAM3 probe A: Bambu 2024.10 configs

Written by `bench/bambu_probe.py` from `probe_bam3a.csv`. Each config is the `bambu` case plus its change; cycles from our testbench (start pulse to last output, no stalls) at the largest size, with cycles per beat; `stall` is the random-stall, two-task run at both sizes; `reg bits` sums Bambu's register instances.

## dot, W = 1 (n512)

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

## dot, W = 8 (n512)

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

## dot, W = 32 (n512)

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

## vecadd, W = 1 (n512)

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

## vecadd, W = 8 (n512)

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

## vecadd, W = 32 (n512)

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
