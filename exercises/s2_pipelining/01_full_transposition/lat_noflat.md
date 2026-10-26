# Latency: noflat_proj (top: gemm_trans)

## Timing and function latency (top module)

| solution | clock target | clock est. | uncertainty | Fn lat min | Fn lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|---|---|
| pipe_noflat | 3.33 ns | 2.451 ns | 0.90 ns | 61537 | 61537 | 61538 | 61538 | no |

## Module latency (all modules)

| solution | module | lat min | lat max | interval min | interval max | pipeline type |
|---|---|---|---|---|---|---|
| pipe_noflat | gemm_trans | 61537 | 61537 | 61538 | 61538 | no |
| pipe_noflat | gemm_trans_Pipeline_COL | 53 | 53 | 53 | 53 | no |

## Loops

Pipelined rows: `iter lat` read one more than the effective depth $L_p$ on the S1.1 kernels; check it again here. II achieved and target are separate columns.

| solution | module | loop | lat min | lat max | iter lat | II achieved | II target | trips | pipelined |
|---|---|---|---|---|---|---|---|---|---|
| pipe_noflat | gemm_trans | - ROW | 61536 | 61536 | 1923 | - | - | 32 | no |
| pipe_noflat | gemm_trans | + PROD | 1824 | 1824 | 57 | - | - | 32 | no |
| pipe_noflat | gemm_trans | + WRITE | 96 | 96 | 3 | - | - | 32 | no |
| pipe_noflat | gemm_trans_Pipeline_COL | - COL | 51 | 51 | 21 | 1 | 1 | 32 | yes |

## Operator latency (Bind Op Report)

Operators with latency > 0 only (set ALL_OPS=1 for all).

| solution | module | instance | variable | op | impl | DSP | latency |
|---|---|---|---|---|---|---|---|
| pipe_noflat | gemm_trans_Pipeline_COL | fmul_32ns_32ns_32_7_max_dsp_1_U2 | mul | fmul | maxdsp | 3 | 6 |
| pipe_noflat | gemm_trans_Pipeline_COL | fadd_32ns_32ns_32_11_full_dsp_1_U1 | add | fadd | fulldsp | 2 | 10 |

## Cosim latency (Verilog)

| solution | status | lat min | lat avg | lat max | interval min | interval avg | interval max |
|---|---|---|---|---|---|---|---|
| pipe_noflat | (no cosim report) | | | | | | |
