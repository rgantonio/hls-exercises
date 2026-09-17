# Latency: tshift_t8_proj (top: gemm_tshift)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| reg | 3.33 ns | 4.708 ns | 0.90 ns | 232193 | 232193 | 232194 | 232194 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| reg | gemm_tshift | 232193 | 232193 | 232194 | 232194 | no |
| reg | gemm_tshift_Pipeline_PROD_TCOL | 1801 | 1801 | 1801 | 1801 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| reg | gemm_tshift | - ROW_TILE | 232192 | 232192 | 1814 | - | - | 128 | no |
| reg | gemm_tshift | + WRITE | 8 | 8 | 1 | - | - | 8 | no |
| reg | gemm_tshift_Pipeline_PROD_TCOL | - PROD_TCOL | 1799 | 1799 | 15 | 7 | 1 | 256 | yes |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| reg | gemm_tshift_Pipeline_PROD_TCOL | fmul_32ns_32ns_32_7_max_dsp_1_U9 | mul | fmul | maxdsp | 3 | 6 |
| reg | gemm_tshift_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U1 | acc_8 | fadd | fabric |  | 7 |
| reg | gemm_tshift_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U2 | acc_6_add | fadd | fabric |  | 7 |
| reg | gemm_tshift_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U3 | acc_5_add | fadd | fabric |  | 7 |
| reg | gemm_tshift_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U4 | acc_4_add | fadd | fabric |  | 7 |
| reg | gemm_tshift_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U5 | acc_3_add | fadd | fabric |  | 7 |
| reg | gemm_tshift_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U6 | acc_2_add | fadd | fabric |  | 7 |
| reg | gemm_tshift_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U7 | acc_1_add | fadd | fabric |  | 7 |
| reg | gemm_tshift_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U8 | acc_add | fadd | fabric |  | 7 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| reg | (no cosim report) | | | | | | |
