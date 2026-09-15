#include "vec_scale.h"

void vec_scale(data_t a, data_t b, const data_t x[N], data_t y[N]) {
VS_LOOP:
    for (int i = 0; i < N; i++) {
        y[i] = a * x[i] + b;
    }
}