// bench/tier_untiered/relu/src/relu.cpp
// Top for cases unopt and opt; only the directives differ. BEAT walks the beats,
// LANE the W lanes of one beat. The beat count is the run-time pin loop_count.
#include "relu.h"

void relu(const vec_t A[NB], vec_t B[NB], cfg_t loop_count) {
    const cfg_t beats = loop_count;  // read once per run (ap_vld, run_bench.tcl)
BEAT:
    for (cfg_t b = 0; b < beats; b++) {
        vec_t a = A[b], o;
    LANE:
        for (int l = 0; l < W; l++) {
            data_t v = lane(a, l);
            set_lane(o, l, (data_t)(v > 0 ? v : 0));
        }
        B[b] = o;
    }
}
