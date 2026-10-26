// bench/tier_done/vsum/src/vsum.cpp
// Top for cases unopt and opt; only the directives differ.
#include "vsum.h"

void vsum(const data_t A[N], data_t out[1]) {
    data_t acc = 0;
SUM:
    for (int i = 0; i < N; i++) {
        acc += A[i];
    }
    out[0] = acc;
}
