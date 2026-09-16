// src/accumulate.cpp
#include "accumulate.h"

void accumulate(const data_t x[N], data_t *sum) {
    data_t acc = 0;
ACC:
    for (int i = 0; i < N; i++) {
        acc += x[i];
    }
    *sum = acc;
}