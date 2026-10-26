// bench/tier_done/vecmul/src/vecmul.cpp
// Top for cases unopt and opt; only the directives differ. BEAT walks the beats,
// LANE the W lanes of one beat.
#include "vecmul.h"

void vecmul(const vec_t A[NB], const vec_t B[NB], vec_t C[NB]) {
BEAT:
    for (int b = 0; b < NB; b++) {
        vec_t a = A[b], bb = B[b], c;
    LANE:
        for (int l = 0; l < W; l++) {
            set_lane(c, l, (data_t)(lane(a, l) * lane(bb, l)));
        }
        C[b] = c;
    }
}
