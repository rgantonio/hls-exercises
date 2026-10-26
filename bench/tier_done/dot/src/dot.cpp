// bench/tier_done/dot/src/dot.cpp
// Top for cases unopt and opt; only the directives differ. BEAT walks the beats,
// LANE the W lanes of one beat.
#include "dot.h"

void dot(const vec_t A[NB], const vec_t B[NB], data_t out[1]) {
    data_t acc = 0;
BEAT:
    for (int b = 0; b < NB; b++) {
        vec_t a = A[b], bb = B[b];
    LANE:
        for (int l = 0; l < W; l++) {
            acc += lane(a, l) * lane(bb, l);
        }
    }
    out[0] = acc;
}
