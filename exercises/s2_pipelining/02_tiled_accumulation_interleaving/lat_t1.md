# Latency: tile_t1_proj (top: gemm_tile)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| reg_prod | 3.33 ns | 2.747 ns | 0.90 ns | 229389 | 229389 | 229390 | 229390 | no |
| reg | 3.33 ns | 2.416 ns | 0.90 ns | 658497 | 658497 | 658498 | 658498 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| reg_prod | gemm_tile | 229389 | 229389 | 229390 | 229390 | no |
| reg | gemm_tile | 658497 | 658497 | 658498 | 658498 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| reg_prod | gemm_tile | - ROW_TILE_PROD | 229387 | 229387 | 19 | 7 | 1 | 32768 | yes |
| reg | gemm_tile | - ROW | 658496 | 658496 | 20578 | - | - | 32 | no |
| reg | gemm_tile | + TILE | 20576 | 20576 | 643 | - | - | 32 | no |
| reg | gemm_tile | ++ PROD | 640 | 640 | 20 | - | - | 32 | no |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| reg_prod | gemm_tile | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| reg_prod | gemm_tile | fadd_32ns_32ns_32_8_no_dsp_1_U1 | add | fadd | fabric |  | 7 |
| reg | gemm_tile | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| reg | gemm_tile | fadd_32ns_32ns_32_11_full_dsp_1_U1 | add | fadd | fulldsp | 2 | 10 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| reg_prod | (no cosim report) | | | | | | |
| reg | (no cosim report) | | | | | | |
