// bench/tier_done/vecadd/src/tb_vecadd.cpp
// Plays forge's streamer: packs forge's inputs (vectors/<size>/data.h) into W-lane
// beats, makes one call, and checks every output exactly. Cosim turns the arrays
// into axis transactions with no stalls.
// The run-time pins come from params.json's "config", which bench.py passes to the
// testbench only (-DCFG_LOOP_COUNT=...).
// DUT is the case's top, set by run_bench.tcl (-DDUT=vecadd or -DDUT=vecadd_dace).
#include <cstdio>
#include "vecadd.h"
#include "data.h"

#ifndef DUT
#error "compile with -DDUT=<top> (run_bench.tcl does this)"
#endif
#ifndef CFG_LOOP_COUNT
#error "CFG_LOOP_COUNT must be set (bench.py, from params.json's config)"
#endif
#define STR2(x) #x
#define STR(x) STR2(x)

static vec_t A[NB], B[NB], C[NB];

int main() {
    for (int b = 0; b < NB; b++)
        for (int l = 0; l < W; l++) {
            set_lane(A[b], l, (data_t)IN_A[b * W + l]);
            set_lane(B[b], l, (data_t)IN_B[b * W + l]);
        }

    DUT(A, B, C, (cfg_t)CFG_LOOP_COUNT);

    int bad = 0;
    for (int b = 0; b < NB; b++)
        for (int l = 0; l < W; l++) {
            int i = b * W + l;
            if (lane(C[b], l) != EXP_C[i]) {
                if (bad < 3)
                    std::printf("  C[%d]: got %lld expected %lld\n", i, (long long)lane(C[b], l), (long long)EXP_C[i]);
                bad++;
            }
        }
    std::printf("%s %s N=%d W=%d loop_count=%u: %d of %d outputs differ\n", bad ? "FAIL" : "PASS", STR(DUT), N, W,
                (unsigned)CFG_LOOP_COUNT, bad, N);
    return bad ? 1 : 0;
}
