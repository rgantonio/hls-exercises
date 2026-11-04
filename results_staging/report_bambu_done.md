# Bambu, tier done

Written by `bench/bambu.py` from `results_staging/bambu_cycles.csv`. Case `bambu`: Bambu's default setup plus `#pragma HLS unroll` on LANE, `--device-name=nangate45`, 10 ns. Cycles from the start pulse to the last output beat (or result), every stream without stalls; cycles per beat in brackets. `cycles_done` (start to `done_port`) is in the second table. A failed point shows its status.

## vecadd

| size | W = 8 |
|---|---|
| n64 | 23 (2.88) |
| n512 | 191 (2.98) |

| W | FSM states | cycles_done (n64 / n512) | latency (n64 / n512) | portable |
|---|---|---|---|---|
| 8 | 8 | 25 / 193 | 1 / 1 | yes |
