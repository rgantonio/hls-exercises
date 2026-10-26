// bench/tier_done/vsum/src/vsum.cpp
// Top for cases unopt and opt; only the directives differ. BEAT walks the beats,
// LANE the W lanes of one beat.
#include "vsum.h"

void vsum(const vec_t A[NB], data_t out[1]) {
    data_t acc = 0;
BEAT:
    for (int b = 0; b < NB; b++) {
        vec_t a = A[b];
    LANE:
        for (int l = 0; l < W; l++) {
            acc += lane(a, l);
        }
    }
    out[0] = acc;
}
