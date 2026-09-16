// src/tb_fir3.cpp
#include <cstdio>
#include <random>
#include "fir3.h"

#define STR_(s) #s
#define STR(s)  STR_(s)

#ifdef __RTL_SIMULATION__
static const int N_RANDOM = 4;
#else
static const int N_RANDOM = 64;
#endif

static const data_t POISON = (data_t)-12345;

static void ref(const data_t x[N], data_t y[M]) {
    for (int i = 0; i < M; i++) y[i] = x[i] + x[i + 1] + x[i + 2];
}

static int check(const char *name, const data_t x[N]) {
    data_t got[M], exp[M];
    for (int i = 0; i < M; i++) got[i] = POISON;
    fir3(x, got);
    ref(x, exp);
    int bad = 0;
    for (int i = 0; i < M; i++) {
        if (got[i] != exp[i]) {
            if (bad < 4) std::printf("FAIL %-8s y[%d] got %d expected %d\n",
                                     name, i, (int)got[i], (int)exp[i]);
            bad++;
        }
    }
    return bad ? 1 : 0;
}

int main() {
    std::printf("tb_fir3: dtype=%s N=%d M=%d N_RANDOM=%d\n", STR(DATA_T), N, M, N_RANDOM);
    int errors = 0;
    data_t x[N];

    // --- directed ------------------------------------------------------
    for (int i = 0; i < N; i++) x[i] = 0;
    errors += check("zeros", x);

    // Impulse at k: y[k-2], y[k-1], y[k] must be 1, all else 0. Checks every tap position.
    for (int i = 0; i < N; i++) x[i] = 0;
    x[100] = 1;
    errors += check("impulse", x);

    for (int i = 0; i < N; i++) x[i] = i;
    errors += check("ramp", x);

    for (int i = 0; i < N; i++) x[i] = 1000000;     // 3e6: large but no overflow
    errors += check("const", x);

    // --- random -------------------------------------------------------
    std::mt19937 rng(42);
    for (int v = 0; v < N_RANDOM; v++) {
        for (int i = 0; i < N; i++) x[i] = (int)(rng() % 2000001) - 1000000;
        errors += check("random", x);
    }

    std::printf("%s: %d error(s)\n", errors ? "FAILED" : "PASSED", errors);
    return errors ? 1 : 0;
}