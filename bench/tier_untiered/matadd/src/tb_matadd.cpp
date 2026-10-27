// bench/tier_untiered/matadd/src/tb_matadd.cpp
// Plays forge's streamer: packs forge's inputs (vectors/<size>/data.h) into W-lane
// beats, makes one call, and checks every output exactly. Cosim turns the arrays
// into axis transactions with no stalls. The run-time pins come from params.json's
// "config", which bench.py passes to the testbench only (-DCFG_...).
// DUT is the case's top, set by run_bench.tcl (-DDUT=matadd or -DDUT=matadd_dace).
#include <cstdio>
#include "matadd.h"
#include "data.h"

#ifndef DUT
#error "compile with -DDUT=<top> (run_bench.tcl does this)"
#endif
#if !defined(CFG_LOOP_COUNT)
#error "CFG_LOOP_COUNT must be set (bench.py, from params.json's config)"
#endif
#define STR2(x) #x
#define STR(x) STR2(x)

static vec_t A[NB], B[NB], C[NB];

int main() {
    const data_t *ia = &IN_A[0][0], *ib = &IN_B[0][0], *ec = &EXP_C[0][0];  // rows are contiguous
    for (int b = 0; b < NB; b++)
        for (int l = 0; l < W; l++) {
            set_lane(A[b], l, ia[b * W + l]);
            set_lane(B[b], l, ib[b * W + l]);
        }

    DUT(A, B, C, (cfg_t)CFG_LOOP_COUNT);

    int bad = 0;
    for (int b = 0; b < NB; b++)
        for (int l = 0; l < W; l++) {
            int i = b * W + l;
            if (lane(C[b], l) != ec[i]) {
                if (bad < 3) std::printf("  C[%d]: got %lld expected %lld\n", i, (long long)lane(C[b], l), (long long)ec[i]);
                bad++;
            }
        }
    std::printf("%s %s M=%d N=%d W=%d loop_count=%u: %d of %d outputs differ\n", bad ? "FAIL" : "PASS", STR(DUT), M,
                NC, W, (unsigned)CFG_LOOP_COUNT, bad, N);
    return bad ? 1 : 0;
}
