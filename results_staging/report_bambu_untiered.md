# Bambu, tier untiered

Written by `bench/bambu.py` from `results_staging/bambu_cycles.csv`. Case `bambu`: Bambu's default setup plus `#pragma HLS unroll` on LANE, `--device-name=nangate45`, 10 ns. Cycles from the start pulse to the last output beat (or result), every stream without stalls; cycles per beat in brackets. `cycles_done` (start to `done_port`) is in the second table. A failed point shows its status.

## axpy

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| n64 | 127 (1.98) | 95 (2.97) | 47 (2.94) | 23 (2.88) | 11 (2.75) | 5 (2.50) |
| n512 | 1023 (2.00) | 767 (3.00) | 383 (2.99) | 191 (2.98) | 95 (2.97) | 47 (2.94) |

| W | FSM states | cycles_done (n64 / n512) | latency (n64 / n512) | portable |
|---|---|---|---|---|
| 1 | 15 | 129 / 1025 | 1 / 1 | yes |
| 2 | 8 | 97 / 769 | 1 / 1 | yes |
| 4 | 8 | 49 / 385 | 1 / 1 | yes |
| 8 | 8 | 25 / 193 | 1 / 1 | yes |
| 16 | 8 | 13 / 97 | 1 / 1 | yes |
| 32 | 8 | 7 / 49 | 1 / 1 | yes |

## matadd

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| m8_n16 | 191 (1.49) | 191 (2.98) | 95 (2.97) | 47 (2.94) | 23 (2.88) | 11 (2.75) |
| m16_n32 | 767 (1.50) | 767 (3.00) | 383 (2.99) | 191 (2.98) | 95 (2.97) | 47 (2.94) |

| W | FSM states | cycles_done (m8_n16 / m16_n32) | latency (m8_n16 / m16_n32) | portable |
|---|---|---|---|---|
| 1 | 21 | 194 / 770 | 1 / 1 | yes |
| 2 | 8 | 193 / 769 | 1 / 1 | yes |
| 4 | 8 | 97 / 385 | 1 / 1 | yes |
| 8 | 8 | 49 / 193 | 1 / 1 | yes |
| 16 | 8 | 25 / 97 | 1 / 1 | yes |
| 32 | 8 | 13 / 49 | 1 / 1 | yes |

## relu

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| n64 | 127 (1.98) | 95 (2.97) | 47 (2.94) | 23 (2.88) | 11 (2.75) | 5 (2.50) |
| n512 | 1023 (2.00) | 767 (3.00) | 383 (2.99) | 191 (2.98) | 95 (2.97) | 47 (2.94) |

| W | FSM states | cycles_done (n64 / n512) | latency (n64 / n512) | portable |
|---|---|---|---|---|
| 1 | 15 | 129 / 1025 | 1 / 1 | yes |
| 2 | 8 | 97 / 769 | 1 / 1 | yes |
| 4 | 8 | 49 / 385 | 1 / 1 | yes |
| 8 | 8 | 25 / 193 | 1 / 1 | yes |
| 16 | 8 | 13 / 97 | 1 / 1 | yes |
| 32 | 8 | 7 / 49 | 1 / 1 | yes |

## rowsum

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| m4_n16 | 163 (2.55) | 99 (3.09) | 51 (3.19) | 27 (3.38) | 19 (4.75) |  |
| m8_n64 | 1287 (2.51) | 775 (3.03) | 391 (3.05) | 199 (3.11) | 135 (4.22) | 71 (4.44) |

| W | FSM states | cycles_done (m4_n16 / m8_n64) | latency (m4_n16 / m8_n64) | portable |
|---|---|---|---|---|
| 1 | 21 | 165 / 1289 | 39 / 159 | yes |
| 2 | 9 | 101 / 777 | 23 / 95 | yes |
| 4 | 9 | 53 / 393 | 11 / 47 | yes |
| 8 | 9 | 29 / 201 | 5 / 23 | yes |
| 16 | 10 | 21 / 137 | 3 / 15 | yes |
| 32 | 10 | - / 73 | - / 7 | yes |
