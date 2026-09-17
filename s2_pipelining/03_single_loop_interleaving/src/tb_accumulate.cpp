// src/tb_accumulate.cpp
#include <cstdio>
#include <limits>
#include <random>
#include "accumulate.h"

#define STR_(s) #s
#define STR(s)  STR_(s)

// One count for csim and cosim: __RTL_SIMULATION__ is not defined for the
// testbench during cosim on 2023.2.2 (notes/env.md, Probe E).
static const int N_RANDOM = 64;

static const data_t POISON = (data_t)-12345;
// Integer builds use raw ints; float builds scale to fractional values.
static const data_t SCALE  = std::numeric_limits<data_t>::is_integer ? 1 : 1000;

static data_t ref(const data_t x[N]) {
    data_t acc = 0;
    for (int i = 0; i < N; i++) acc += x[i];   // same order as the kernel
    return acc;
}

static int check(const char *name, const data_t x[N]) {
    data_t got = POISON;
    accumulate(x, &got);
    data_t exp = ref(x);
    // Exact compare on purpose: same order of additions, so bit-exact is expected.
    if (got != exp) {
        std::printf("FAIL %-10s got %.9g expected %.9g\n", name, (double)got, (double)exp);
        return 1;
    }
    return 0;
}

int main() {
    std::printf("tb_accumulate: dtype=%s N=%d N_RANDOM=%d\n", STR(DATA_T), N, N_RANDOM);
    int errors = 0;
    data_t x[N];

    // --- directed ------------------------------------------------------
    for (int i = 0; i < N; i++) x[i] = 0;
    errors += check("zeros", x);

    for (int i = 0; i < N; i++) x[i] = 1;
    errors += check("ones", x);

    // Order-sensitive in float: 1e8 + 1 rounds back to 1e8 in single precision,
    // so the ones in the middle vanish. A different order would not lose them.
    x[0] = (data_t)100000000;
    for (int i = 1; i < N - 1; i++) x[i] = 1;
    x[N - 1] = (data_t)-100000000;
    errors += check("cancel", x);
    std::printf("cancel vector: ref sum = %.9g (int build: 1022)\n", (double)ref(x));

    for (int i = 0; i < N; i++) x[i] = (i % 2) ? (data_t)-1000 : (data_t)1000;
    errors += check("alt", x);

    // --- random (fixed seed: cosim replays the same stimulus) ---------
    std::mt19937 rng(42);
    for (int v = 0; v < N_RANDOM; v++) {
        for (int i = 0; i < N; i++) {
            int r = (int)(rng() % 2001) - 1000;   // bounded: no int overflow over 1024 terms
            x[i] = (data_t)r / SCALE;
        }
        errors += check("random", x);
    }

    std::printf("%s: %d error(s)\n", errors ? "FAILED" : "PASSED", errors);
    return errors ? 1 : 0;
}