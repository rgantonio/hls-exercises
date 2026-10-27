// bench/tier_done/dot/src/dot.cpp
// Top for cases unopt and opt; only the directives differ. BEAT walks the beats,
// LANE the W lanes of one beat. The run-time pins loop_count and len give the
// beats in the run and the beats per result, as forge's Accumulator: a result
// leaves at the len-th beat of a sum or at the run's last beat, and the sum restarts.
#include "dot.h"

void dot(const vec_t A[NB], const vec_t B[NB], data_t out[NOUT], cfg_t loop_count, cfg_t len) {
    const cfg_t beats = loop_count, T = len;  // sampled at start, as forge's blocks do
    data_t acc = 0;
    cfg_t cnt = 0;  // beats in the sum in progress
    int o = 0;      // results written
BEAT:
    for (cfg_t b = 0; b < beats; b++) {
        vec_t a = A[b], bb = B[b];
        data_t s = 0;
    LANE:
        for (int l = 0; l < W; l++) {
            s += lane(a, l) * lane(bb, l);
        }
        data_t sum = acc + s;
        if (cnt + 1 == T || b + 1 == beats) {
            out[o++] = sum;
            acc = 0;
            cnt = 0;
        } else {
            acc = sum;
            cnt++;
        }
    }
}
