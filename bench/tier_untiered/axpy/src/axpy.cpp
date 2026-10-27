// bench/tier_untiered/axpy/src/axpy.cpp
// Top for cases unopt and opt; only the directives differ. BEAT walks the beats,
// LANE the W lanes of one beat: a multiply and an add per lane.
#include "axpy.h"

void axpy(const vec_t x[NB], const vec_t y[NB], vec_t y_out[NB], data_t alpha, cfg_t loop_count) {
    const cfg_t beats = loop_count;  // read once per run (ap_vld, run_bench.tcl)
    const data_t a = alpha;          // likewise
BEAT:
    for (cfg_t b = 0; b < beats; b++) {
        vec_t xb = x[b], yb = y[b], o;
    LANE:
        for (int l = 0; l < W; l++) {
            set_lane(o, l, (data_t)(lane(yb, l) + a * lane(xb, l)));
        }
        y_out[b] = o;
    }
}
