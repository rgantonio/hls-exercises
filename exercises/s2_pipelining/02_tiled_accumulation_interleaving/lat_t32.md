# Latency: tile_t32_proj (top: gemm_tile)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| ram | 3.33 ns | 2.781 ns | 0.90 ns | 36641 | 36641 | 36642 | 36642 | no |
| reg_dist | 3.33 ns | 3.653 ns | 0.90 ns | 230881 | 230881 | 230882 | 230882 | no |
| reg | 3.33 ns | 3.653 ns | 0.90 ns | 230881 | 230881 | 230882 | 230882 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| ram | gemm_tile | 36641 | 36641 | 36642 | 36642 | no |
| ram | gemm_tile_Pipeline_PROD_TCOL | 1046 | 1046 | 1046 | 1046 | no |
| reg_dist | gemm_tile | 230881 | 230881 | 230882 | 230882 | no |
| reg_dist | gemm_tile_Pipeline_PROD_TCOL | 7178 | 7178 | 7178 | 7178 | no |
| reg | gemm_tile | 230881 | 230881 | 230882 | 230882 | no |
| reg | gemm_tile_Pipeline_PROD_TCOL | 7178 | 7178 | 7178 | 7178 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| ram | gemm_tile | - ROW | 36640 | 36640 | 1145 | - | - | 32 | no |
| ram | gemm_tile | + WRITE | 96 | 96 | 3 | - | - | 32 | no |
| ram | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 1044 | 1044 | 22 | 1 | 1 | 1024 | yes |
| reg_dist | gemm_tile | - ROW | 230880 | 230880 | 7215 | - | - | 32 | no |
| reg_dist | gemm_tile | + WRITE | 32 | 32 | 1 | - | - | 32 | no |
| reg_dist | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 7176 | 7176 | 16 | 7 | 1 | 1024 | yes |
| reg | gemm_tile | - ROW | 230880 | 230880 | 7215 | - | - | 32 | no |
| reg | gemm_tile | + WRITE | 32 | 32 | 1 | - | - | 32 | no |
| reg | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 7176 | 7176 | 16 | 7 | 1 | 1024 | yes |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| ram | gemm_tile_Pipeline_PROD_TCOL | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| ram | gemm_tile_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_11_full_dsp_1_U1 | add | fadd | fulldsp | 2 | 10 |
| reg_dist | gemm_tile_Pipeline_PROD_TCOL | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| reg_dist | gemm_tile_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U1 | add | fadd | fabric |  | 7 |
| reg | gemm_tile_Pipeline_PROD_TCOL | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| reg | gemm_tile_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U1 | acc | fadd | fabric |  | 7 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| ram | (no cosim report) | | | | | | |
| reg_dist | (no cosim report) | | | | | | |
| reg | (no cosim report) | | | | | | |
