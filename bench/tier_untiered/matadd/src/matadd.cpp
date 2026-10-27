// bench/tier_untiered/matadd/src/matadd.cpp
// Top for cases unopt and opt; only the directives differ. As vecadd: the 2-D shape
// lives in the streamer, the unit adds a flat run of beats.
#include "matadd.h"

void matadd(const vec_t A[NB], const vec_t B[NB], vec_t C[NB], cfg_t loop_count) {
    const cfg_t beats = loop_count;  // read once per run (ap_vld, run_bench.tcl)
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
