# Latency: bigm_t16_proj (top: gemm_tile)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| ram | 3.33 ns | 2.778 ns | 0.90 ns | 1165313 | 1165313 | 1165314 | 1165314 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| ram | gemm_tile | 1165313 | 1165313 | 1165314 | 1165314 | no |
| ram | gemm_tile_Pipeline_PROD_TCOL | 534 | 534 | 534 | 534 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| ram | gemm_tile | - ROW_TILE | 1165312 | 1165312 | 569 | - | - | 2048 | no |
| ram | gemm_tile | + WRITE | 32 | 32 | 2 | - | - | 16 | no |
| ram | gemm_tile_Pipeline_PROD_TCOL | - PROD_TCOL | 532 | 532 | 22 | 1 | 1 | 512 | yes |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| ram | gemm_tile_Pipeline_PROD_TCOL | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| ram | gemm_tile_Pipeline_PROD_TCOL | fadd_32ns_32ns_32_11_full_dsp_1_U1 | add | fadd | fulldsp | 2 | 10 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| ram | (no cosim report) | | | | | | |
