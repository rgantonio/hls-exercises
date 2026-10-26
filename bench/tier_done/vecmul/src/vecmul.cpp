// bench/tier_done/vecmul/src/vecmul.cpp
// Top for cases unopt and opt; only the directives differ.
#include "vecmul.h"

void vecmul(const data_t A[N], const data_t B[N], data_t C[N]) {
MUL:
    for (int i = 0; i < N; i++) {
        C[i] = A[i] * B[i];
    }
}
