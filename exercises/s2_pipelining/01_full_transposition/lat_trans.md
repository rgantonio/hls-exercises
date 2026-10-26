# Latency: trans_proj (top: gemm_trans)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| pipe | 3.33 ns | 2.781 ns | 0.90 ns | 36641 | 36641 | 36642 | 36642 | no |
| seq | 3.33 ns | 2.416 ns | 0.90 ns | 694369 | 694369 | 694370 | 694370 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| pipe | gemm_trans | 36641 | 36641 | 36642 | 36642 | no |
| pipe | gemm_trans_Pipeline_PROD_COL | 1046 | 1046 | 1046 | 1046 | no |
| seq | gemm_trans | 694369 | 694369 | 694370 | 694370 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| pipe | gemm_trans | - ROW | 36640 | 36640 | 1145 | - | - | 32 | no |
| pipe | gemm_trans | + WRITE | 96 | 96 | 3 | - | - | 32 | no |
| pipe | gemm_trans_Pipeline_PROD_COL | - PROD_COL | 1044 | 1044 | 22 | 1 | 1 | 1024 | yes |
| seq | gemm_trans | - ROW | 694368 | 694368 | 21699 | - | - | 32 | no |
| seq | gemm_trans | + PROD | 21600 | 21600 | 675 | - | - | 32 | no |
| seq | gemm_trans | ++ COL | 672 | 672 | 21 | - | - | 32 | no |
| seq | gemm_trans | + WRITE | 96 | 96 | 3 | - | - | 32 | no |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| pipe | gemm_trans_Pipeline_PROD_COL | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| pipe | gemm_trans_Pipeline_PROD_COL | fadd_32ns_32ns_32_11_full_dsp_1_U1 | add | fadd | fulldsp | 2 | 10 |
| seq | gemm_trans | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| seq | gemm_trans | fadd_32ns_32ns_32_11_full_dsp_1_U1 | add | fadd | fulldsp | 2 | 10 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| pipe | Pass | 36577 | 36577 | 36577 | 36578 | 36578 | 36578 |
| seq | (no cosim report) | | | | | | |
