# Bambu, tier done

Written by `bench/bambu.py` from `results_staging/bambu_cycles.csv`. Case `bambu` on `bambu-2026.11`: Bambu's default setup plus `#pragma HLS unroll` on LANE, `--device-name=nangate45`, 10 ns. Cycles from the start pulse to the last output beat (or result), every stream without stalls; cycles per beat in brackets. `cycles_done` (start to `done_port`) is in the second table. A failed point shows its status.

## dot

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| n64 | 65 (1.02) | 33 (1.03) | 32 (2.00) | 16 (2.00) | 6 (1.50) | 4 (2.00) |
| n512 | 513 (1.00) | 257 (1.00) | 256 (2.00) | 128 (2.00) | 34 (1.06) | 18 (1.12) |

| W | FSM states | loop pipelining | cycles_done (n64 / n512) | latency (n64 / n512) | portable |
|---|---|---|---|---|---|
| 1 | 8 | BB2 II=1 lat=2 | 66 / 514 | 64 / 512 | yes |
| 2 | 8 | BB2 II=1 lat=2 | 34 / 258 | 32 / 256 | yes |
| 4 | 11 | BB2 II=2 lat=3 | 34 / 258 | 31 / 255 | yes |
| 8 | 11 | BB2 II=2 lat=3 | 18 / 130 | 15 / 127 | yes |
| 16 | 15 | BB2 II=1 lat=3 | 7 / 35 | 5 / 33 | yes |
| 32 | 15 | BB2 II=1 lat=3 | 5 / 19 | 3 / 17 | yes |

## vecadd

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

## vecmul

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

## vsum

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| n64 | 65 (1.02) | 33 (1.03) | 17 (1.06) | 9 (1.12) | 6 (1.50) | 4 (2.00) |
| n512 | 513 (1.00) | 257 (1.00) | 129 (1.01) | 65 (1.02) | 34 (1.06) | 18 (1.12) |

| W | FSM states | loop pipelining | cycles_done (n64 / n512) | latency (n64 / n512) | portable |
|---|---|---|---|---|---|
| 1 | 8 | BB2 II=1 lat=2 | 66 / 514 | 64 / 512 | yes |
| 2 | 8 | BB2 II=1 lat=2 | 34 / 258 | 32 / 256 | yes |
| 4 | 8 | BB2 II=1 lat=2 | 18 / 130 | 16 / 128 | yes |
| 8 | 8 | BB2 II=1 lat=2 | 10 / 66 | 8 / 64 | yes |
| 16 | 15 | BB2 II=1 lat=3 | 7 / 35 | 5 / 33 | yes |
| 32 | 15 | BB2 II=1 lat=3 | 5 / 19 | 3 / 17 | yes |
