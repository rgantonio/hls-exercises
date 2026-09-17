// src/tb_gemm.cpp
#include <cstdio>
#include <random>
#include "gemm.h"

#if defined(USE_gemm_naive)
#  define DUT  gemm_naive
#  define FORM "naive"
#elif defined(USE_gemm_trans)
#  define DUT  gemm_trans
#  define FORM "trans"
#elif defined(USE_gemm_tile)
#  define DUT  gemm_tile
#  define FORM "tile"
#elif defined(USE_gemm_tshift)
#  define DUT  gemm_tshift
#  define FORM "tshift"
#else
#  error "tb_gemm: compile with -DUSE_gemm_naive, -DUSE_gemm_trans, -DUSE_gemm_tile or -DUSE_gemm_tshift"
#endif

// One count for csim and cosim: __RTL_SIMULATION__ is not defined for the
// testbench during cosim on 2023.2.2 (S2.1.1 cosim ran all 20 calls).
static const int N_RANDOM = 16;

// True for float/double, false for integer types (1/2 truncates to 0).
static const bool IS_REAL = ((data_t)1 / 2) != 0;

static data_t A[N][K], B[K][M], C_in[N][M], C_dut[N][M], C_ref[N][M];

// Reference: loop order n, m, k, each sum starting from C (paper Lst. 1a).
static void ref() {
    for (int n = 0; n < N; n++) {
        for (int m = 0; m < M; m++) {
            data_t acc = C_in[n][m];
            for (int k = 0; k < K; k++) acc += A[n][k] * B[k][m];
            C_ref[n][m] = acc;
        }
    }
}

static int check(const char *name) {
    for (int n = 0; n < N; n++)
        for (int m = 0; m < M; m++) C_dut[n][m] = C_in[n][m];

    DUT(A, B, C_dut);
    ref();

    int bad = 0, unwritten = 0;
    for (int n = 0; n < N; n++) {
        for (int m = 0; m < M; m++) {
            if (C_dut[n][m] != C_ref[n][m]) {
                if (bad < 3)
                    std::printf("  %s C[%d][%d]: got %.9g expected %.9g\n",
                                name, n, m, (double)C_dut[n][m], (double)C_ref[n][m]);
                bad++;
            }
            if (C_ref[n][m] != C_in[n][m] && C_dut[n][m] == C_in[n][m]) unwritten++;
        }
    }
    if (bad)
        std::printf("FAIL %-8s %d of %d elements differ (%d still equal their input)\n",
                    name, bad, N * M, unwritten);
    return bad ? 1 : 0;
}

static data_t rnd(std::mt19937 &g) {
    int r = (int)(g() % 2001) - 1000;              // -1000 .. 1000
    return IS_REAL ? (data_t)r / (data_t)1000 : (data_t)r;
}

static void fill(data_t a, data_t b, data_t c) {
    for (int n = 0; n < N; n++) for (int k = 0; k < K; k++) A[n][k] = a;
    for (int k = 0; k < K; k++) for (int m = 0; m < M; m++) B[k][m] = b;
    for (int n = 0; n < N; n++) for (int m = 0; m < M; m++) C_in[n][m] = c;
}

int main() {
    std::printf("tb_gemm: form=%s N=%d K=%d M=%d N_RANDOM=%d\n", FORM, N, K, M, N_RANDOM);
#ifdef TILE_T
    std::printf("tb_gemm: TILE_T=%d\n", TILE_T);
#endif
    int errors = 0;

    // --- directed: tiling ----------------------------------------------
    // c_passthrough: A = 0, B = 0, C[n][m] = n*M + m + 1.
    // Output must equal the input C exactly. Catches a tile that does not
    // restart from C at k == 0 (it would carry stale sums from the previous tile).
    fill(0, 0, 0);
    for (int n = 0; n < N; n++) for (int m = 0; m < M; m++) C_in[n][m] = (data_t)(n * M + m + 1);
    errors += check("c_pass");

    // col_id: A = 1, B[k][m] = m, C = 0.
    // Expected C[n][m] = K*m exactly (small integers are exact in float).
    // Catches a wrong column address m*T + t.
    fill(1, 0, 0);
    for (int k = 0; k < K; k++) for (int m = 0; m < M; m++) B[k][m] = (data_t)m;
    errors += check("col_id");

    // --- directed ------------------------------------------------------
    fill(0, 0, 0);
    errors += check("zeros");

    // A = identity, so C = B + C_in.
    fill(0, 0, 0);
    for (int n = 0; n < N; n++) A[n][n] = 1;
    for (int k = 0; k < K; k++) for (int m = 0; m < M; m++) B[k][m] = (data_t)(k - m);
    for (int n = 0; n < N; n++) for (int m = 0; m < M; m++) C_in[n][m] = (data_t)(n + m);
    errors += check("identity");

    // A[n][k] = n+1, B = 1, C_in = 0, so C[n][m] = K*(n+1).
    // A transposed kernel that does not restart acc at k == 0 carries the previous row in.
    fill(0, 1, 0);
    for (int n = 0; n < N; n++) for (int k = 0; k < K; k++) A[n][k] = (data_t)(n + 1);
    errors += check("rows");

    // C_in = 1e8, A = B = 1. In float32, 1e8 + 1 rounds back to 1e8, so the
    // naive order (C first, then the ones) gives 1e8. Adding C last would give
    // 1e8 + 32, which is exact. Catches a kernel that sums in a different order.
    fill(1, 1, (data_t)100000000);
    errors += check("order");

    // --- random (fixed seed: cosim replays the same stimulus) ---------
    std::mt19937 rng(42);
    for (int v = 0; v < N_RANDOM; v++) {
        for (int n = 0; n < N; n++) for (int k = 0; k < K; k++) A[n][k] = rnd(rng);
        for (int k = 0; k < K; k++) for (int m = 0; m < M; m++) B[k][m] = rnd(rng);
        for (int n = 0; n < N; n++) for (int m = 0; m < M; m++) C_in[n][m] = rnd(rng);
        errors += check("random");
    }

    std::printf("%s: %d error(s)\n", errors ? "FAILED" : "PASSED", errors);
    return errors ? 1 : 0;
}
