// src/gemm_naive.cpp
#include "gemm.h"

// Loop order n, m, k (paper Lst. 1a). One scalar accumulator per output element.
void gemm_naive(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]) {
ROW:
    for (int n = 0; n < N; n++) {
    COL:
        for (int m = 0; m < M; m++) {
            data_t acc = C[n][m];
        PROD:
            for (int k = 0; k < K; k++) {
                acc += A[n][k] * B[k][m];
            }
            C[n][m] = acc;
        }
    }
}
