// src/fir3.cpp
#include "fir3.h"

void fir3(const data_t x[N], data_t y[M]) {
TAPS:
    for (int i = 0; i < M; i++) {
        y[i] = x[i] + x[i + 1] + x[i + 2];
    }
}