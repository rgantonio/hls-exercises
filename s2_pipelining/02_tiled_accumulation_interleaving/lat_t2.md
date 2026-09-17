# Latency: tile_t2_proj (top: gemm_tile)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| ram | 3.33 ns | 3.337 ns | 0.90 ns | 175105 | 175105 | 175106 | 175106 | no |
| reg | 3.33 ns | 3.597 ns | 0.90 ns | 238593 | 238593 | 238594 | 238594 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| ram | gemm_tile | 175105 | 175105 | 175106 | 175106 | no |
| ram | gemm_tile_Pipeline_PROD_TCOL | 334 | 334 | 334 | 334 | no |
| reg | gemm_tile | 238593 | 238593 | 238594 | 238594 | no |
| reg | gemm_tile_Pipeline_PROD_TCOL | 459 | 459 | 459 | 459 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| ram | gemm_tile | - ROW_TILE | 175104 | 175104 | 342 | - | - | 512 | no |
| ram | gemm_tile | + WRITE | 4 | 4 | 2 | - | - | 2 | no |
| ram | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 332 | 332 | 18 | 5 | 1 | 64 | yes |
| reg | gemm_tile | - ROW_TILE | 238592 | 238592 | 466 | - | - | 512 | no |
| reg | gemm_tile | + WRITE | 2 | 2 | 1 | - | - | 2 | no |
| reg | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 457 | 457 | 17 | 7 | 1 | 64 | yes |

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
| ram | (no cosim report) | | | | | | |
| reg | (no cosim report) | | | | | | |
