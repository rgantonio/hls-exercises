# Latency: accf_proj (top: accumulate)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| pipe | 3.33 ns | 2.719 ns | 0.90 ns | 7172 | 7172 | 7173 | 7173 | no |
| seq | 3.33 ns | 2.262 ns | 0.90 ns | 14337 | 14337 | 14338 | 14338 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| pipe | accumulate | 7172 | 7172 | 7173 | 7173 | no |
| seq | accumulate | 14337 | 14337 | 14338 | 14338 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| pipe | accumulate | - ACC | 7170 | 7170 | 10 | 7 | 1 | 1024 | yes |
| seq | accumulate | - ACC | 14336 | 14336 | 14 | - | - | 1024 | no |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| pipe | accumulate | fadd_32ns_32ns_32_8_no_dsp_1_U1 | acc_1 | fadd | fabric |  | 7 |
| seq | accumulate | fadd_32ns_32ns_32_11_full_dsp_1_U1 | acc_1 | fadd | fulldsp | 2 | 10 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| pipe | Pass | 7170 | 7170 | 7170 | 7171 | 7171 | 7171 |
| seq | Pass | 14337 | 14337 | 14337 | 14338 | 14338 | 14338 |
