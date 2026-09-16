// src/acc_shift.cpp
#include "acc_il.h"

// Shift form. lane[K-1] holds the partial sum last updated K iterations ago.
void acc_shift(const data_t x[N], data_t *sum) {
    data_t lane[K];

INIT:
    for (int k = 0; k < K; k++) lane[k] = 0;

ACC:
    for (int i = 0; i < N; i++) {
        data_t s = lane[K - 1] + x[i];
    SHIFT:
        for (int k = K - 1; k > 0; k--) lane[k] = lane[k - 1];
        lane[0] = s;
    }

    data_t total = 0;
COMBINE:
    for (int k = 0; k < K; k++) total += lane[k];
    *sum = total;
}
