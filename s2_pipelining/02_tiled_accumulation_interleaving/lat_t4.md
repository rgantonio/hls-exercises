# Latency: tile_t4_proj (top: gemm_tile)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| ram | 3.33 ns | 2.549 ns | 0.90 ns | 105473 | 105473 | 105474 | 105474 | no |
| reg_dist | 3.33 ns | 3.940 ns | 0.90 ns | 234241 | 234241 | 234242 | 234242 | no |
| reg | 3.33 ns | 3.940 ns | 0.90 ns | 234241 | 234241 | 234242 | 234242 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| ram | gemm_tile | 105473 | 105473 | 105474 | 105474 | no |
| ram | gemm_tile_Pipeline_PROD_TCOL | 401 | 401 | 401 | 401 | no |
| reg_dist | gemm_tile | 234241 | 234241 | 234242 | 234242 | no |
| reg_dist | gemm_tile_Pipeline_PROD_TCOL | 906 | 906 | 906 | 906 | no |
| reg | gemm_tile | 234241 | 234241 | 234242 | 234242 | no |
| reg | gemm_tile_Pipeline_PROD_TCOL | 906 | 906 | 906 | 906 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| ram | gemm_tile | - ROW_TILE | 105472 | 105472 | 412 | - | - | 256 | no |
| ram | gemm_tile | + WRITE | 8 | 8 | 2 | - | - | 4 | no |
| ram | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 399 | 399 | 19 | 3 | 1 | 128 | yes |
| reg_dist | gemm_tile | - ROW_TILE | 234240 | 234240 | 915 | - | - | 256 | no |
| reg_dist | gemm_tile | + WRITE | 4 | 4 | 1 | - | - | 4 | no |
| reg_dist | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 904 | 904 | 16 | 7 | 1 | 128 | yes |
| reg | gemm_tile | - ROW_TILE | 234240 | 234240 | 915 | - | - | 256 | no |
| reg | gemm_tile | + WRITE | 4 | 4 | 1 | - | - | 4 | no |
| reg | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 904 | 904 | 16 | 7 | 1 | 128 | yes |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| ram | gemm_tile_Pipeline_PROD_TCOL | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| ram | gemm_tile_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U1 | add | fadd | fabric |  | 7 |
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
