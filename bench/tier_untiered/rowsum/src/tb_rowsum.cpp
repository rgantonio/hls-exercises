// bench/tier_untiered/rowsum/src/tb_rowsum.cpp
// Plays forge's streamer: packs forge's inputs (vectors/<size>/data.h) into W-lane
// beats, makes one call, and checks every output exactly. Cosim turns the arrays
// into axis transactions with no stalls. The run-time pins come from params.json's
// "config", which bench.py passes to the testbench only (-DCFG_...).
// DUT is the case's top, set by run_bench.tcl (-DDUT=rowsum or -DDUT=rowsum_dace).
#include <cstdio>
#include "rowsum.h"
#include "data.h"

#ifndef DUT
#error "compile with -DDUT=<top> (run_bench.tcl does this)"
#endif
#if !defined(CFG_LOOP_COUNT) || !defined(CFG_LEN)
#error "CFG_LOOP_COUNT, CFG_LEN must be set (bench.py, from params.json's config)"
#endif
#define STR2(x) #x
#define STR(x) STR2(x)

static vec_t A[NB];
static data_t y[NOUT];

int main() {
    const data_t *ia = &IN_A[0][0];  // rows are contiguous
    for (int b = 0; b < NB; b++)
        for (int l = 0; l < W; l++) set_lane(A[b], l, ia[b * W + l]);

    DUT(A, y, (cfg_t)CFG_LOOP_COUNT, (cfg_t)CFG_LEN);

    int bad = 0;
    for (int i = 0; i < NOUT; i++)
        if (y[i] != EXP_y[i]) {
            if (bad < 3) std::printf("  y[%d]: got %lld expected %lld\n", i, (long long)y[i], (long long)EXP_y[i]);
            bad++;
        }
    std::printf("%s %s M=%d N=%d W=%d loop_count=%u len=%u: %d of %d outputs differ\n", bad ? "FAIL" : "PASS",
                STR(DUT), M, NC, W, (unsigned)CFG_LOOP_COUNT, (unsigned)CFG_LEN, bad, NOUT);
    return bad ? 1 : 0;
}
