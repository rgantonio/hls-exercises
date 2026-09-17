// src/gemm_tile.cpp
#include "gemm.h"

#ifndef TILE_T
#error "TILE_T is not defined: pass -DTILE_T=<T> in add_files -cflags"
#endif

static_assert(M % TILE_T == 0, "TILE_T must divide M");

// Loop order n, tile, k, t (paper Sec. 2.1.2, Lst. 1c). One accumulator per
// column of the current tile. acc[t] is written in trip (k, t) and read again
// in trip (k+1, t), TILE_T trips later.
void gemm_tile(const data_t A[N][K], const data_t B[K][M], data_t C[N][M]) {
    // Tile buffer: its size depends on TILE_T only, not on M.
    // Left uninitialised: it is restarted from C when k == 0, as in gemm_trans.
    data_t acc[TILE_T];

ROW:
    for (int n = 0; n < N; n++) {
    TILE:
        for (int m = 0; m < M / TILE_T; m++) {
        PROD:
            for (int k = 0; k < K; k++) {
            TCOL:
                for (int t = 0; t < TILE_T; t++) {
                    data_t prev = (k == 0) ? C[n][m * TILE_T + t] : acc[t];
                    acc[t] = prev + A[n][k] * B[k][m * TILE_T + t];
                }
            }
        WRITE:
            for (int t = 0; t < TILE_T; t++) {
                C[n][m * TILE_T + t] = acc[t];
            }
        }
    }
}
