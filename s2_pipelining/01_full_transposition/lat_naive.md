# Latency: naive_proj (top: gemm_naive)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| pipe | 3.33 ns | 2.747 ns | 0.90 ns | 229389 | 229389 | 229390 | 229390 | no |
| seq | 3.33 ns | 2.416 ns | 0.90 ns | 658497 | 658497 | 658498 | 658498 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| pipe | gemm_naive | 229389 | 229389 | 229390 | 229390 | no |
| seq | gemm_naive | 658497 | 658497 | 658498 | 658498 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| pipe | gemm_naive | - ROW_COL_PROD | 229387 | 229387 | 19 | 7 | 1 | 32768 | yes |
| seq | gemm_naive | - ROW | 658496 | 658496 | 20578 | - | - | 32 | no |
| seq | gemm_naive | + COL | 20576 | 20576 | 643 | - | - | 32 | no |
| seq | gemm_naive | ++ PROD | 640 | 640 | 20 | - | - | 32 | no |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| pipe | gemm_naive | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| pipe | gemm_naive | fadd_32ns_32ns_32_8_no_dsp_1_U1 | acc_2 | fadd | fabric |  | 7 |
| seq | gemm_naive | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| seq | gemm_naive | fadd_32ns_32ns_32_11_full_dsp_1_U1 | acc_2 | fadd | fulldsp | 2 | 10 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| pipe | Pass | 229387 | 229387 | 229388 | 229389 | 229389 | 229390 |
| seq | (no cosim report) | | | | | | |
