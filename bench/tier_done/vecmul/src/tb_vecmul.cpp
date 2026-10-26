// bench/tier_done/vecmul/src/tb_vecmul.cpp
// One call on forge's inputs (vectors/<size>/data.h), every output checked exactly.
// DUT is the case's top, set by run_bench.tcl (-DDUT=vecmul or -DDUT=vecmul_dace).
#include <cstdio>
#include "vecmul.h"
#include "data.h"

#ifndef DUT
#error "compile with -DDUT=<top> (run_bench.tcl does this)"
#endif
#define STR2(x) #x
#define STR(x) STR2(x)

static data_t C[N];

int main() {
    for (int i = 0; i < N; i++) C[i] = IN_C[i];

    DUT(IN_A, IN_B, C);

    int bad = 0;
    for (int i = 0; i < N; i++) {
        if (C[i] != EXP_C[i]) {
            if (bad < 3)
                std::printf("  C[%d]: got %lld expected %lld\n", i, (long long)C[i], (long long)EXP_C[i]);
            bad++;
        }
    }
    std::printf("%s %s N=%d: %d of %d outputs differ\n", bad ? "FAIL" : "PASS", STR(DUT), N, bad, N);
    return bad ? 1 : 0;
}
