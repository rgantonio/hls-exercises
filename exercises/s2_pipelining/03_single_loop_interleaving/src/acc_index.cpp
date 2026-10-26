// src/acc_index.cpp
#include "acc_il.h"

// Index form (paper Lst. 2), with a wrap counter instead of i % K.
void acc_index(const data_t x[N], data_t *sum) {
    data_t lane[K];

INIT:
    for (int k = 0; k < K; k++) lane[k] = 0;

    int c = 0;
ACC:
    for (int i = 0; i < N; i++) {
        lane[c] = lane[c] + x[i];
        c = (c == K - 1) ? 0 : c + 1;   // i % K would build a divider for K = 7, 10
    }

    data_t total = 0;
COMBINE:
    for (int k = 0; k < K; k++) total += lane[k];
    *sum = total;
}
