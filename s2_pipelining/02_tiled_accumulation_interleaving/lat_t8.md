# Latency: tile_t8_proj (top: gemm_tile)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| ram | 3.33 ns | 2.730 ns | 0.90 ns | 70273 | 70273 | 70274 | 70274 | no |
| reg | 3.33 ns | 3.940 ns | 0.90 ns | 232321 | 232321 | 232322 | 232322 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| ram | gemm_tile | 70273 | 70273 | 70274 | 70274 | no |
| ram | gemm_tile_Pipeline_PROD_TCOL | 530 | 530 | 530 | 530 | no |
| reg | gemm_tile | 232321 | 232321 | 232322 | 232322 | no |
| reg | gemm_tile_Pipeline_PROD_TCOL | 1802 | 1802 | 1802 | 1802 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| ram | gemm_tile | - ROW_TILE | 70272 | 70272 | 549 | - | - | 128 | no |
| ram | gemm_tile | + WRITE | 16 | 16 | 2 | - | - | 8 | no |
| ram | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 528 | 528 | 19 | 2 | 1 | 256 | yes |
| reg | gemm_tile | - ROW_TILE | 232320 | 232320 | 1815 | - | - | 128 | no |
| reg | gemm_tile | + WRITE | 8 | 8 | 1 | - | - | 8 | no |
| reg | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 1800 | 1800 | 16 | 7 | 1 | 256 | yes |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| ram | gemm_tile_Pipeline_PROD_TCOL | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| ram | gemm_tile_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U1 | add | fadd | fabric |  | 7 |
| reg | gemm_tile_Pipeline_PROD_TCOL | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| reg | gemm_tile_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U1 | acc | fadd | fabric |  | 7 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| ram | Pass | 70017 | 70017 | 70017 | 70018 | 70018 | 70018 |
| reg | Pass | 232065 | 232065 | 232065 | 232066 | 232066 | 232066 |
