# Latency: tile_t16_proj (top: gemm_tile)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| ram | 3.33 ns | 2.778 ns | 0.90 ns | 36417 | 36417 | 36418 | 36418 | no |
| reg | 3.33 ns | 3.605 ns | 0.90 ns | 231425 | 231425 | 231426 | 231426 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| ram | gemm_tile | 36417 | 36417 | 36418 | 36418 | no |
| ram | gemm_tile_Pipeline_PROD_TCOL | 534 | 534 | 534 | 534 | no |
| reg | gemm_tile | 231425 | 231425 | 231426 | 231426 | no |
| reg | gemm_tile_Pipeline_PROD_TCOL | 3595 | 3595 | 3595 | 3595 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| ram | gemm_tile | - ROW_TILE | 36416 | 36416 | 569 | - | - | 64 | no |
| ram | gemm_tile | + WRITE | 32 | 32 | 2 | - | - | 16 | no |
| ram | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 532 | 532 | 22 | 1 | 1 | 512 | yes |
| reg | gemm_tile | - ROW_TILE | 231424 | 231424 | 3616 | - | - | 64 | no |
| reg | gemm_tile | + WRITE | 16 | 16 | 1 | - | - | 16 | no |
| reg | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 3593 | 3593 | 17 | 7 | 1 | 512 | yes |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| ram | gemm_tile_Pipeline_PROD_TCOL | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| ram | gemm_tile_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_11_full_dsp_1_U1 | add | fadd | fulldsp | 2 | 10 |
| reg | gemm_tile_Pipeline_PROD_TCOL | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| reg | gemm_tile_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_8_no_dsp_1_U1 | acc | fadd | fabric |  | 7 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| ram | (no cosim report) | | | | | | |
| reg | (no cosim report) | | | | | | |
