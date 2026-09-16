// src/tb_acc_il.cpp
#include <cmath>
#include <cstdio>
#include <random>
#include "acc_il.h"

#if defined(USE_acc_shift)
#  define DUT  acc_shift
#  define FORM "shift"
#elif defined(USE_acc_index)
#  define DUT  acc_index
#  define FORM "index"
#else
#  error "tb_acc_il: compile with -DUSE_acc_shift or -DUSE_acc_index"
#endif

#ifdef __RTL_SIMULATION__
static const int N_RANDOM = 4;
#else
static const int N_RANDOM = 64;
#endif

static const data_t POISON = (data_t)-12345;

// part[r] = x[r] + x[r+K] + x[r+2K] + ..., added in index order from 0.
static void lane_sums(const data_t x[N], data_t part[K]) {
    for (int r = 0; r < K; r++) part[r] = 0;
    for (int i = 0; i < N; i++) part[i % K] += x[i];
}

// Same lanes and same combine order as the DUT, so the result must be bit-exact.
static data_t ref(const data_t x[N]) {
    data_t part[K];
    lane_sums(x, part);
    data_t total = 0;
    for (int j = 0; j < K; j++) {
#if defined(USE_acc_shift)
        total += part[(N - 1 - j) % K];   // shift form: lane[j] holds class (N-1-j) mod K
#else
        total += part[j];                 // index form: lane[j] holds class j
#endif
    }
    return total;
}

// The untransformed order. Printed for comparison, never checked.
static data_t ref_sequential(const data_t x[N]) {
    data_t acc = 0;
    for (int i = 0; i < N; i++) acc += x[i];
    return acc;
}

static int check(const char *name, const data_t x[N]) {
    data_t got = POISON;
    DUT(x, &got);
    data_t exp = ref(x);
    if (got != exp) {
        std::printf("FAIL %-8s got %.9g expected %.9g\n", name, (double)got, (double)exp);
        return 1;
    }
    return 0;
}

int main() {
    std::printf("tb_acc_il: form=%s K=%d N=%d N_RANDOM=%d\n", FORM, K, N, N_RANDOM);
    int errors = 0;
    data_t x[N];

    // --- directed ------------------------------------------------------
    for (int i = 0; i < N; i++) x[i] = 0;
    errors += check("zeros", x);

    for (int i = 0; i < N; i++) x[i] = 1;
    errors += check("ones", x);

    // Order-sensitive: 1e8 + 1 rounds back to 1e8 in single precision.
    x[0] = (data_t)100000000;
    for (int i = 1; i < N - 1; i++) x[i] = 1;
    x[N - 1] = (data_t)-100000000;
    errors += check("cancel", x);
    std::printf("cancel: interleaved=%.9g sequential=%.9g exact=1022\n",
                (double)ref(x), (double)ref_sequential(x));

    for (int i = 0; i < N; i++) x[i] = (i % 2) ? (data_t)-1000 : (data_t)1000;
    errors += check("alt", x);

    // --- random (fixed seed: cosim replays the same stimulus) ---------
    std::mt19937 rng(42);
    double max_rel = 0;
    for (int v = 0; v < N_RANDOM; v++) {
        for (int i = 0; i < N; i++) {
            int r = (int)(rng() % 2001) - 1000;
            x[i] = (data_t)r / 1000;
        }
        errors += check("random", x);
        double s  = ref_sequential(x);
        double il = ref(x);
        if (s != 0) {
            double rel = std::fabs(il - s) / std::fabs(s);
            if (rel > max_rel) max_rel = rel;
        }
    }
    std::printf("random: max |interleaved - sequential| / |sequential| = %.3g\n", max_rel);

    std::printf("%s: %d error(s)\n", errors ? "FAILED" : "PASSED", errors);
    return errors ? 1 : 0;
}
