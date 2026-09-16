# Latency: index_k10_proj (top: acc_index)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| pipe_dist | 3.33 ns | 3.046 ns | 0.90 ns | 7305 | 7305 | 7306 | 7306 | no |
| pipe | 3.33 ns | 3.046 ns | 0.90 ns | 7305 | 7305 | 7306 | 7306 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| pipe_dist | acc_index | 7305 | 7305 | 7306 | 7306 | no |
| pipe_dist | acc_index_Pipeline_ACC | 7172 | 7172 | 7172 | 7172 | no |
| pipe | acc_index | 7305 | 7305 | 7306 | 7306 | no |
| pipe | acc_index_Pipeline_ACC | 7172 | 7172 | 7172 | 7172 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| pipe_dist | acc_index | - COMBINE | 130 | 130 | 13 | - | - | 10 | no |
| pipe_dist | acc_index_Pipeline_ACC | - ACC | 7170 | 7170 | 10 | 7 | 1 | 1024 | yes |
| pipe | acc_index | - COMBINE | 130 | 130 | 13 | - | - | 10 | no |
| pipe | acc_index_Pipeline_ACC | - ACC | 7170 | 7170 | 10 | 7 | 1 | 1024 | yes |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| pipe_dist | acc_index | fadd_32ns_32ns_32_11_full_dsp_1_U16 | total_1 | fadd | fulldsp | 2 | 10 |
| pipe_dist | acc_index_Pipeline_ACC | fadd_32ns_32ns_32_8_no_dsp_1_U1 | add | fadd | fabric |  | 7 |
| pipe | acc_index | fadd_32ns_32ns_32_11_full_dsp_1_U16 | total_1 | fadd | fulldsp | 2 | 10 |
| pipe | acc_index_Pipeline_ACC | fadd_32ns_32ns_32_8_no_dsp_1_U1 | lane | fadd | fabric |  | 7 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| pipe_dist | Pass | 7304 | 7304 | 7304 | 7305 | 7305 | 7305 |
| pipe | (no cosim report) | | | | | | |
