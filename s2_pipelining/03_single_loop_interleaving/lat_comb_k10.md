# Latency: comb_k10_proj (top: acc_shift)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| pipe_comb | 3.33 ns | 2.719 ns | 0.90 ns | 1111 | 1111 | 1112 | 1112 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| pipe_comb | acc_shift | 1111 | 1111 | 1112 | 1112 | no |
| pipe_comb | acc_shift_Pipeline_ACC | 1034 | 1034 | 1034 | 1034 | no |
| pipe_comb | acc_shift_Pipeline_COMBINE | 73 | 73 | 73 | 73 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| pipe_comb | acc_shift_Pipeline_ACC | - ACC | 1032 | 1032 | 10 | 1 | 1 | 1024 | yes |
| pipe_comb | acc_shift_Pipeline_COMBINE | - COMBINE | 71 | 71 | 9 | 7 | 1 | 10 | yes |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| pipe_comb | | (none) | | | | | |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| pipe_comb | (no cosim report) | | | | | | |
