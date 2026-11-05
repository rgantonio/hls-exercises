# BAM3 probe B: Bambu 2026.11

Written by `bench/bambu_probe.py` from `probe_bam3b.csv`. Each config is the `bambu` case plus its change; cycles from our testbench (start pulse to last output, no stalls) at the largest size, with cycles per beat; `stall` is the random-stall, two-task run at both sizes; `reg bits` sums Bambu's register instances; `2024.10` is the `bambu` case's cycles from `bambu_cycles.csv`; `loop pipelining` is Bambu's log (2026.11 only).

## dot, W = 1 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 513 | 1.00 | 1536 | PASS/PASS | 8 | 452 | BB2 II=1 lat=2 | 13.6 |

## dot, W = 8 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 128 | 2.00 | 256 | PASS/PASS | 11 | 1347 | BB2 II=2 lat=3 | 16.4 |

## dot, W = 32 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 18 | 1.12 | 64 | PASS/PASS | 15 | 4805 | BB2 II=1 lat=3 | 15.9 |

## relu, W = 1 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 513 | 1.00 | 1023 | PASS/PASS | 8 | 225 | BB2 II=1 lat=2 | 15.2 |

## relu, W = 8 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | failed: sim | - | - | 191 | FAIL/FAIL | 8 | 1121 | BB2 II=1 lat=2 | 13.8 |

## relu, W = 32 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | failed: sim | - | - | 47 | FAIL/FAIL | 8 | 4193 | BB2 II=1 lat=2 | 15.1 |

## rowsum, W = 1 (m8_n64)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 513 | 1.00 | 1287 | PASS/PASS | 8 | 356 | BB2 II=1 lat=2 | 15.2 |

## rowsum, W = 8 (m8_n64)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 65 | 1.02 | 199 | PASS/PASS | 8 | 804 | BB2 II=1 lat=2 | 15.0 |

## rowsum, W = 32 (m8_n64)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 18 | 1.12 | 71 | PASS | 15 | 2469 | BB2 II=1 lat=3 | 14.2 |

## vecadd, W = 1 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | ok | 513 | 1.00 | 767 | PASS/PASS | 8 | 322 | BB2 II=1 lat=2 | 13.7 |

## vecadd, W = 8 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | failed: sim | - | - | 191 | FAIL/FAIL | 8 | 1666 | BB2 II=1 lat=2 | 14.9 |

## vecadd, W = 32 (n512)

| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |
|---|---|---|---|---|---|---|---|---|---|
| b0 | failed: sim | - | - | 47 | FAIL/FAIL | 8 | 6274 | BB2 II=1 lat=2 | 15.0 |
