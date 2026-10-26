// bench/tier_done/dot/src/dot.cpp
// Top for cases unopt and opt; only the directives differ.
#include "dot.h"

void dot(const data_t A[N], const data_t B[N], data_t out[1]) {
    data_t acc = 0;
DOT:
    for (int i = 0; i < N; i++) {
        acc += A[i] * B[i];
    }
    out[0] = acc;
}
