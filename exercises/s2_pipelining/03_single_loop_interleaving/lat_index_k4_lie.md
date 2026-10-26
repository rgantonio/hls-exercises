# Latency: index_k4_proj (top: acc_index)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| pipe_lie | 3.33 ns | 2.969 ns | 0.90 ns | 1097 | 1097 | 1098 | 1098 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| pipe_lie | acc_index | 1097 | 1097 | 1098 | 1098 | no |
| pipe_lie | acc_index_Pipeline_ACC | 1034 | 1034 | 1034 | 1034 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| pipe_lie | acc_index | - INIT | 4 | 4 | 1 | - | - | 4 | no |
| pipe_lie | acc_index | - COMBINE | 56 | 56 | 14 | - | - | 4 | no |
| pipe_lie | acc_index_Pipeline_ACC | - ACC | 1032 | 1032 | 10 | 1 | 1 | 1024 | yes |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| pipe_lie | acc_index | fadd_32ns_32ns_32_11_full_dsp_1_U5 | total_1 | fadd | fulldsp | 2 | 10 |
| pipe_lie | acc_index_Pipeline_ACC | fadd_32ns_32ns_32_8_no_dsp_1_U1 | add | fadd | fabric |  | 7 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| pipe_lie | Fail | 1095 | 1095 | 1095 | 1096 | 1096 | 1096 |
