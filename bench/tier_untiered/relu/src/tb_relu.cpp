// bench/tier_untiered/relu/src/tb_relu.cpp
// Plays forge's streamer: packs forge's inputs (vectors/<size>/data.h) into W-lane
// beats, makes one call, and checks every output exactly. Cosim turns the arrays
// into axis transactions with no stalls. The run-time pins come from params.json's
// "config", which bench.py passes to the testbench only (-DCFG_...).
// DUT is the case's top, set by run_bench.tcl (-DDUT=relu or -DDUT=relu_dace).
#include <cstdio>
#include "relu.h"
#include "data.h"

#ifndef DUT
#error "compile with -DDUT=<top> (run_bench.tcl does this)"
#endif
#if !defined(CFG_LOOP_COUNT)
#error "CFG_LOOP_COUNT must be set (bench.py, from params.json's config)"
#endif
#define STR2(x) #x
#define STR(x) STR2(x)

static vec_t A[NB], B[NB];

int main() {
    for (int b = 0; b < NB; b++)
        for (int l = 0; l < W; l++) set_lane(A[b], l, (data_t)IN_A[b * W + l]);

    DUT(A, B, (cfg_t)CFG_LOOP_COUNT);

    int bad = 0;
    for (int b = 0; b < NB; b++)
        for (int l = 0; l < W; l++) {
            int i = b * W + l;
            if (lane(B[b], l) != EXP_B[i]) {
                if (bad < 3) std::printf("  B[%d]: got %lld expected %lld\n", i, (long long)lane(B[b], l), (long long)EXP_B[i]);
                bad++;
            }
        }
    std::printf("%s %s N=%d W=%d loop_count=%u: %d of %d outputs differ\n", bad ? "FAIL" : "PASS", STR(DUT), N, W,
                (unsigned)CFG_LOOP_COUNT, bad, N);
    return bad ? 1 : 0;
}
