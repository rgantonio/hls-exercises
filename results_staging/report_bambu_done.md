# Bambu, tier done

Written by `bench/bambu.py` from `results_staging/bambu_cycles.csv`. Case `bambu`: Bambu's default setup plus `#pragma HLS unroll` on LANE, `--device-name=nangate45`, 10 ns. Cycles from the start pulse to the last output beat (or result), every stream without stalls; cycles per beat in brackets. `cycles_done` (start to `done_port`) is in the second table. A failed point shows its status.

## dot

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| n64 | 192 (3.00) | 96 (3.00) | 48 (3.00) | 32 (4.00) | 16 (4.00) | 8 (4.00) |
| n512 | 1536 (3.00) | 768 (3.00) | 384 (3.00) | 256 (4.00) | 128 (4.00) | 64 (4.00) |

| W | FSM states | cycles_done (n64 / n512) | latency (n64 / n512) | portable |
|---|---|---|---|---|
| 1 | 9 | 194 / 1538 | 191 / 1535 | yes |
| 2 | 9 | 98 / 770 | 95 / 767 | yes |
| 4 | 9 | 50 / 386 | 47 / 383 | yes |
| 8 | 10 | 34 / 258 | 31 / 255 | yes |
| 16 | 10 | 18 / 130 | 15 / 127 | yes |
| 32 | 10 | 10 / 66 | 7 / 63 | yes |

## vecadd

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| n64 | 95 (1.48) | 95 (2.97) | 47 (2.94) | 23 (2.88) | 11 (2.75) | 5 (2.50) |
| n512 | 767 (1.50) | 767 (3.00) | 383 (2.99) | 191 (2.98) | 95 (2.97) | 47 (2.94) |

| W | FSM states | cycles_done (n64 / n512) | latency (n64 / n512) | portable |
|---|---|---|---|---|
| 1 | 21 | 98 / 770 | 1 / 1 | yes |
| 2 | 8 | 97 / 769 | 1 / 1 | yes |
| 4 | 8 | 49 / 385 | 1 / 1 | yes |
| 8 | 8 | 25 / 193 | 1 / 1 | yes |
| 16 | 8 | 13 / 97 | 1 / 1 | yes |
| 32 | 8 | 7 / 49 | 1 / 1 | yes |

## vecmul

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| n64 | 95 (1.48) | 95 (2.97) | 47 (2.94) | 23 (2.88) | 11 (2.75) | 5 (2.50) |
| n512 | 767 (1.50) | 767 (3.00) | 383 (2.99) | 191 (2.98) | 95 (2.97) | 47 (2.94) |

| W | FSM states | cycles_done (n64 / n512) | latency (n64 / n512) | portable |
|---|---|---|---|---|
| 1 | 21 | 98 / 770 | 1 / 1 | yes |
| 2 | 8 | 97 / 769 | 1 / 1 | yes |
| 4 | 8 | 49 / 385 | 1 / 1 | yes |
| 8 | 8 | 25 / 193 | 1 / 1 | yes |
| 16 | 8 | 13 / 97 | 1 / 1 | yes |
| 32 | 8 | 7 / 49 | 1 / 1 | yes |

## vsum

| size | W = 1 | W = 2 | W = 4 | W = 8 | W = 16 | W = 32 |
|---|---|---|---|---|---|---|
| n64 | 160 (2.50) | 96 (3.00) | 48 (3.00) | 24 (3.00) | 16 (4.00) | 8 (4.00) |
| n512 | 1280 (2.50) | 768 (3.00) | 384 (3.00) | 192 (3.00) | 128 (4.00) | 64 (4.00) |

| W | FSM states | cycles_done (n64 / n512) | latency (n64 / n512) | portable |
|---|---|---|---|---|
| 1 | 21 | 162 / 1282 | 159 / 1279 | yes |
| 2 | 9 | 98 / 770 | 95 / 767 | yes |
| 4 | 9 | 50 / 386 | 47 / 383 | yes |
| 8 | 9 | 26 / 194 | 23 / 191 | yes |
| 16 | 10 | 18 / 130 | 15 / 127 | yes |
| 32 | 10 | 10 / 66 | 7 / 63 | yes |
