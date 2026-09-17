// src/gemm_trans.cpp
#include "gemm.h"

// Loop order n, k, m (paper Lst. 1b). One accumulator per column, in a buffer.
// acc[m] is written in trip (k, m) and read again in trip (k+1, m), M trips later.
void gemm_trans(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]) {
    data_t acc[M];

ROW:
    for (int n = 0; n < N; n++) {
    PROD:
        for (int k = 0; k < K; k++) {
        COL:
            for (int m = 0; m < M; m++) {
                // k == 0 restarts the column sum from C, so acc needs no reset loop.
                data_t prev = (k == 0) ? C[n][m] : acc[m];
                acc[m] = prev + A[n][k] * B[k][m];
            }
        }
    WRITE:
        for (int m = 0; m < M; m++) {
            C[n][m] = acc[m];
        }
    }
}
