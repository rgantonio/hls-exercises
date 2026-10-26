# Latency: acci_proj (top: accumulate)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| pipe | 3.33 ns | 1.664 ns | 0.90 ns | 1027 | 1027 | 1028 | 1028 | no |
| seq | 3.33 ns | 1.443 ns | 0.90 ns | 3073 | 3073 | 3074 | 3074 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| pipe | accumulate | 1027 | 1027 | 1028 | 1028 | no |
| seq | accumulate | 3073 | 3073 | 3074 | 3074 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| pipe | accumulate | - ACC | 1025 | 1025 | 3 | 1 | 1 | 1024 | yes |
| seq | accumulate | - ACC | 3072 | 3072 | 3 | - | - | 1024 | no |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| pipe | | (none) | | | | | |
| seq | | (none) | | | | | |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| pipe | Pass | 1025 | 1025 | 1025 | 1027 | 1027 | 1027 |
| seq | Pass | 3073 | 3073 | 3073 | 3074 | 3074 | 3074 |
