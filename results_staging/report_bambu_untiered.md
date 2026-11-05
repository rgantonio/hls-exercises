# Bambu, tier untiered

Written by `bench/bambu.py` from `results_staging/bambu_cycles.csv`. Case `bambu` on `bambu-2026.11`: Bambu's default setup plus `#pragma HLS unroll` on LANE, `--device-name=nangate45`, 10 ns. Cycles from the start pulse to the last output beat (or result), every stream without stalls; cycles per beat in brackets. `cycles_done` (start to `done_port`) is in the second table. A failed point shows its status.

## axpy

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| n64 | 65 (1.02) | 33 (1.03) | 17 (1.06) | 9 (1.12) | 5 (1.25) | failed: sim |
| n512 | 513 (1.00) | 257 (1.00) | 129 (1.01) | 65 (1.02) | 33 (1.03) | failed: sim |

| W | FSM states | loop pipelining | cycles_done (n64 / n512) | latency (n64 / n512) | portable |
|---|---|---|---|---|---|
| 1 | 8 | BB2 II=1 lat=2 | 66 / 514 | 1 / 1 | yes |
| 2 | 8 | BB2 II=1 lat=2 | 34 / 258 | 1 / 1 | yes |
| 4 | 8 | BB2 II=1 lat=2 | 18 / 130 | 1 / 1 | yes |
| 8 | 8 | BB2 II=1 lat=2 | 10 / 66 | 1 / 1 | yes |
| 16 | 8 | BB2 II=1 lat=2 | 6 / 34 | 1 / 1 | yes |
| 32 | 8 | BB2 II=1 lat=2 | - / - | - / - | yes |

## matadd

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| m8_n16 | 129 (1.01) | 65 (1.02) | 33 (1.03) | 17 (1.06) | 9 (1.12) | failed: sim |
| m16_n32 | 513 (1.00) | 257 (1.00) | 129 (1.01) | 65 (1.02) | 33 (1.03) | failed: sim |

| W | FSM states | loop pipelining | cycles_done (m8_n16 / m16_n32) | latency (m8_n16 / m16_n32) | portable |
|---|---|---|---|---|---|
| 1 | 8 | BB2 II=1 lat=2 | 130 / 514 | 1 / 1 | yes |
| 2 | 8 | BB2 II=1 lat=2 | 66 / 258 | 1 / 1 | yes |
| 4 | 8 | BB2 II=1 lat=2 | 34 / 130 | 1 / 1 | yes |
| 8 | 8 | BB2 II=1 lat=2 | 18 / 66 | 1 / 1 | yes |
| 16 | 8 | BB2 II=1 lat=2 | 10 / 34 | 1 / 1 | yes |
| 32 | 8 | BB2 II=1 lat=2 | - / - | - / - | yes |

## relu

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| n64 | 65 (1.02) | 33 (1.03) | 17 (1.06) | 9 (1.12) | 5 (1.25) | failed: sim |
| n512 | 513 (1.00) | 257 (1.00) | 129 (1.01) | 65 (1.02) | 33 (1.03) | failed: sim |

| W | FSM states | loop pipelining | cycles_done (n64 / n512) | latency (n64 / n512) | portable |
|---|---|---|---|---|---|
| 1 | 8 | BB2 II=1 lat=2 | 66 / 514 | 1 / 1 | yes |
| 2 | 8 | BB2 II=1 lat=2 | 34 / 258 | 1 / 1 | yes |
| 4 | 8 | BB2 II=1 lat=2 | 18 / 130 | 1 / 1 | yes |
| 8 | 8 | BB2 II=1 lat=2 | 10 / 66 | 1 / 1 | yes |
| 16 | 8 | BB2 II=1 lat=2 | 6 / 34 | 1 / 1 | yes |
| 32 | 8 | BB2 II=1 lat=2 | - / - | - / - | yes |

## rowsum

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| m4_n16 | 65 (1.02) | 33 (1.03) | 17 (1.06) | 9 (1.12) | 6 (1.50) |  |
| m8_n64 | 513 (1.00) | 257 (1.00) | 129 (1.01) | 65 (1.02) | 34 (1.06) | 18 (1.12) |

| W | FSM states | loop pipelining | cycles_done (m4_n16 / m8_n64) | latency (m4_n16 / m8_n64) | portable |
|---|---|---|---|---|---|
| 1 | 8 | BB2 II=1 lat=2 | 66 / 514 | 16 / 64 | yes |
| 2 | 8 | BB2 II=1 lat=2 | 34 / 258 | 8 / 32 | yes |
| 4 | 8 | BB2 II=1 lat=2 | 18 / 130 | 4 / 16 | yes |
| 8 | 8 | BB2 II=1 lat=2 | 10 / 66 | 2 / 8 | yes |
| 16 | 15 | BB2 II=1 lat=3 | 7 / 35 | 2 / 5 | yes |
| 32 | 15 | BB2 II=1 lat=3 | - / 19 | - / 3 | yes |
