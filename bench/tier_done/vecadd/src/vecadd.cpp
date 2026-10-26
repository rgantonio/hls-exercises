// bench/tier_done/vecadd/src/vecadd.cpp
// Top for cases unopt and opt; only the directives differ.
#include "vecadd.h"

void vecadd(const data_t A[N], const data_t B[N], data_t C[N]) {
ADD:
    for (int i = 0; i < N; i++) {
        C[i] = A[i] + B[i];
    }
}
