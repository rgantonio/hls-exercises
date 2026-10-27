// bench/tier_done/vecadd/src/vecadd.cpp
// Top for cases unopt and opt; only the directives differ. BEAT walks the beats,
// LANE the W lanes of one beat. The beat count is the run-time pin loop_count.
#include "vecadd.h"

void vecadd(const vec_t A[NB], const vec_t B[NB], vec_t C[NB], cfg_t loop_count) {
    const cfg_t beats = loop_count;  // registered at start by run_bench.tcl (ap_none -register)
BEAT:
    for (cfg_t b = 0; b < beats; b++) {
        vec_t a = A[b], bb = B[b], c;
    LANE:
        for (int l = 0; l < W; l++) {
            set_lane(c, l, (data_t)(lane(a, l) + lane(bb, l)));
        }
        C[b] = c;
    }
}
