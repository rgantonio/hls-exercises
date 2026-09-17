# Latency: index_k10_proj (top: acc_index)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| pipe_dist | 3.33 ns | 2.969 ns | 0.90 ns | 1187 | 1187 | 1188 | 1188 | no |
| pipe | 3.33 ns | 2.969 ns | 0.90 ns | 7325 | 7325 | 7326 | 7326 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| pipe_dist | acc_index | 1187 | 1187 | 1188 | 1188 | no |
| pipe_dist | acc_index_Pipeline_ACC | 1034 | 1034 | 1034 | 1034 | no |
| pipe | acc_index | 7325 | 7325 | 7326 | 7326 | no |
| pipe | acc_index_Pipeline_ACC | 7172 | 7172 | 7172 | 7172 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| pipe_dist | acc_index | - INIT | 10 | 10 | 1 | - | - | 10 | no |
| pipe_dist | acc_index | - COMBINE | 140 | 140 | 14 | - | - | 10 | no |
| pipe_dist | acc_index_Pipeline_ACC | - ACC | 1032 | 1032 | 10 | 1 | 1 | 1024 | yes |
| pipe | acc_index | - INIT | 10 | 10 | 1 | - | - | 10 | no |
| pipe | acc_index | - COMBINE | 140 | 140 | 14 | - | - | 10 | no |
| pipe | acc_index_Pipeline_ACC | - ACC | 7170 | 7170 | 10 | 7 | 1 | 1024 | yes |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| pipe_dist | acc_index | fadd_32ns_32ns_32_11_full_dsp_1_U5 | total_1 | fadd | fulldsp | 2 | 10 |
| pipe_dist | acc_index_Pipeline_ACC | fadd_32ns_32ns_32_8_no_dsp_1_U1 | add | fadd | fabric |  | 7 |
| pipe | acc_index | fadd_32ns_32ns_32_11_full_dsp_1_U5 | total_1 | fadd | fulldsp | 2 | 10 |
| pipe | acc_index_Pipeline_ACC | fadd_32ns_32ns_32_8_no_dsp_1_U1 | add | fadd | fabric |  | 7 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| pipe_dist | Pass | 1185 | 1185 | 1185 | 1186 | 1186 | 1186 |
| pipe | (no cosim report) | | | | | | |
