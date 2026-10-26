# Latency: fir_proj (top: fir3)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| pipe_2p | 3.33 ns | 2.451 ns | 0.90 ns | 2047 | 2047 | 2048 | 2048 | no |
| pipe_auto | 3.33 ns | 2.451 ns | 0.90 ns | 2047 | 2047 | 2048 | 2048 | no |
| pipe | 3.33 ns | 2.024 ns | 0.90 ns | 3069 | 3069 | 3070 | 3070 | no |
| seq | 3.33 ns | 2.024 ns | 0.90 ns | 4089 | 4089 | 4090 | 4090 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| pipe_2p | fir3 | 2047 | 2047 | 2048 | 2048 | no |
| pipe_auto | fir3 | 2047 | 2047 | 2048 | 2048 | no |
| pipe | fir3 | 3069 | 3069 | 3070 | 3070 | no |
| seq | fir3 | 4089 | 4089 | 4090 | 4090 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| pipe_2p | fir3 | - TAPS | 2045 | 2045 | 4 | 2 | 1 | 1022 | yes |
| pipe_auto | fir3 | - TAPS | 2045 | 2045 | 4 | 2 | 1 | 1022 | yes |
| pipe | fir3 | - TAPS | 3067 | 3067 | 5 | 3 | 1 | 1022 | yes |
| seq | fir3 | - TAPS | 4088 | 4088 | 4 | - | - | 1022 | no |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| pipe_2p | | (none) | | | | | |
| pipe_auto | | (none) | | | | | |
| pipe | | (none) | | | | | |
| seq | | (none) | | | | | |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| pipe_2p | Pass | 2045 | 2045 | 2045 | 2046 | 2046 | 2046 |
| pipe_auto | Pass | 2045 | 2045 | 2045 | 2046 | 2046 | 2046 |
| pipe | Pass | 3067 | 3067 | 3067 | 3068 | 3068 | 3068 |
| seq | Pass | 4089 | 4089 | 4089 | 4090 | 4090 | 4090 |
