// bench/tier_done/dot/src/tb_dot.cpp
// Plays forge's streamer: packs forge's inputs (vectors/<size>/data.h) into W-lane
// beats, makes one call, and checks every output exactly. Cosim turns the arrays
// into axis transactions with no stalls.
// DUT is the case's top, set by run_bench.tcl (-DDUT=dot or -DDUT=dot_dace).
#include <cstdio>
#include "dot.h"
#include "data.h"

#ifndef DUT
#error "compile with -DDUT=<top> (run_bench.tcl does this)"
#endif
#define STR2(x) #x
#define STR(x) STR2(x)

static vec_t A[NB], B[NB];
static data_t out[1];

int main() {
    for (int b = 0; b < NB; b++)
        for (int l = 0; l < W; l++) {
            set_lane(A[b], l, (data_t)IN_A[b * W + l]);
            set_lane(B[b], l, (data_t)IN_B[b * W + l]);
        }
    out[0] = IN_out[0];

    DUT(A, B, out);

    int bad = out[0] != EXP_out[0];
    if (bad)
        std::printf("  out: got %lld expected %lld\n", (long long)out[0], (long long)EXP_out[0]);
    std::printf("%s %s N=%d W=%d: out = %lld\n", bad ? "FAIL" : "PASS", STR(DUT), N, W, (long long)out[0]);
    return bad;
}
