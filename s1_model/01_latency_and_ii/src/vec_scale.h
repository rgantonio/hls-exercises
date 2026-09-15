#ifndef VEC_SCALE_H_
#define VEC_SCALE_H_

typedef int data_t;     // one-line change point: float side-experiment, and S4.4
#define N 1024

void vec_scale  (data_t a, data_t b, const data_t x[N], data_t y[N]);
void vec_scale_n(data_t a, data_t b, const data_t x[N], data_t y[N], int n);

#endif