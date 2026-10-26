# Latency: shift_k10_proj (top: acc_shift)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| pipe | 3.33 ns | 2.719 ns | 0.90 ns | 1167 | 1167 | 1168 | 1168 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| pipe | acc_shift | 1167 | 1167 | 1168 | 1168 | no |
| pipe | acc_shift_Pipeline_ACC | 1034 | 1034 | 1034 | 1034 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| pipe | acc_shift | - COMBINE | 130 | 130 | 13 | - | - | 10 | no |
| pipe | acc_shift_Pipeline_ACC | - ACC | 1032 | 1032 | 10 | 1 | 1 | 1024 | yes |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| pipe | acc_shift | fadd_32ns_32ns_32_11_full_dsp_1_U14 | total_1 | fadd | fulldsp | 2 | 10 |
| pipe | acc_shift_Pipeline_ACC | fadd_32ns_32ns_32_8_no_dsp_1_U1 | lane_20 | fadd | fabric |  | 7 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| pipe | Pass | 1165 | 1165 | 1165 | 1166 | 1166 | 1166 |
