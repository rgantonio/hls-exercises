// bench/tier_untiered/rowsum/src/rowsum.cpp
// Top for cases unopt and opt; only the directives differ. The body is vsum's: a result
// leaves at the len-th beat of a sum or at the run's last beat, and the sum restarts.
#include "rowsum.h"

void rowsum(const vec_t A[NB], data_t y[NOUT], cfg_t loop_count, cfg_t len) {
    const cfg_t beats = loop_count, T = len;  // read once per run (ap_vld, run_bench.tcl)
    data_t acc = 0;
    cfg_t cnt = 0;  // beats in the sum in progress
    int o = 0;      // results written
BEAT:
    for (cfg_t b = 0; b < beats; b++) {
        vec_t a = A[b];
        data_t s = 0;
    LANE:
        for (int l = 0; l < W; l++) {
            s += lane(a, l);
        }
        data_t sum = acc + s;
        if (cnt + 1 == T || b + 1 == beats) {
            y[o++] = sum;
            acc = 0;
            cnt = 0;
        } else {
            acc = sum;
            cnt++;
        }
    }
}
