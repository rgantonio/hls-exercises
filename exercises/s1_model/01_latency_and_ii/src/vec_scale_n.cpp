#include "vec_scale.h"

void vec_scale_n(data_t a, data_t b, const data_t x[N], data_t y[N], int n) {
VSN_LOOP:
    for (int i = 0; i < n; i++) {
        y[i] = a * x[i] + b;
    }
}