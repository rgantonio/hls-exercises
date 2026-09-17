// src/gemm_tshift.cpp   (extra 5.5c)
#include "gemm.h"

#ifndef TILE_T
#error "TILE_T is not defined: pass -DTILE_T=<T> in add_files -cflags"
#endif

static_assert(M % TILE_T == 0, "TILE_T must divide M");

// gemm_tile with the tile buffer written as a shift register (the S2.1.3
// acc_shift form). acc[TILE_T-1] holds the sum of the same column one k earlier,
// so the distance is visible in the code instead of hidden in the index t.
void gemm_tshift(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]) {
    data_t acc[TILE_T];

ROW:
    for (int n = 0; n < N; n++) {
    TILE:
        for (int m = 0; m < M / TILE_T; m++) {
        PROD:
            for (int k = 0; k < K; k++) {
            TCOL:
                for (int t = 0; t < TILE_T; t++) {
                    data_t prev = (k == 0) ? C[n][m * TILE_T + t] : acc[TILE_T - 1];
                    data_t s = prev + A[n][k] * B[k][m * TILE_T + t];
                SHIFT:
                    for (int j = TILE_T - 1; j > 0; j--) acc[j] = acc[j - 1];
                    acc[0] = s;
                }
            }
        WRITE:
            // After the last k, column t sits TILE_T-1-t places down the chain.
            for (int t = 0; t < TILE_T; t++) {
                C[n][m * TILE_T + t] = acc[TILE_T - 1 - t];
            }
        }
    }
}
