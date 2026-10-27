// bench/tier_done/vsum/src/tb_vsum.cpp
// Plays forge's streamer: packs forge's inputs (vectors/<size>/data.h) into W-lane
// beats, makes one call, and checks every output exactly. Cosim turns the arrays
// into axis transactions with no stalls.
// The run-time pins come from params.json's "config", which bench.py passes to the
// testbench only (-DCFG_LOOP_COUNT=... -DCFG_LEN=...).
// DUT is the case's top, set by run_bench.tcl (-DDUT=vsum or -DDUT=vsum_dace).
#include <cstdio>
#include "vsum.h"
#include "data.h"

#ifndef DUT
#error "compile with -DDUT=<top> (run_bench.tcl does this)"
#endif
#if !defined(CFG_LOOP_COUNT) || !defined(CFG_LEN)
#error "CFG_LOOP_COUNT and CFG_LEN must be set (bench.py, from params.json's config)"
#endif
#define STR2(x) #x
#define STR(x) STR2(x)

static vec_t A[NB];
static data_t out[NOUT];

int main() {
    for (int b = 0; b < NB; b++)
        for (int l = 0; l < W; l++) {
            set_lane(A[b], l, (data_t)IN_A[b * W + l]);
        }
    out[0] = IN_out[0];

    DUT(A, out, (cfg_t)CFG_LOOP_COUNT, (cfg_t)CFG_LEN);

    int bad = out[0] != EXP_out[0];
    if (bad)
        std::printf("  out: got %lld expected %lld\n", (long long)out[0], (long long)EXP_out[0]);
    std::printf("%s %s N=%d W=%d loop_count=%u len=%u: out = %lld\n", bad ? "FAIL" : "PASS", STR(DUT), N, W,
                (unsigned)CFG_LOOP_COUNT, (unsigned)CFG_LEN, (long long)out[0]);
    return bad;
}
