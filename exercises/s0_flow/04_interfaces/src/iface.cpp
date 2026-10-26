#include "iface.h"

void iface(data_t a, const data_t x[N], data_t y[N], data_t *sum) {
  data_t acc = 0;

SCALE_LOOP:
  for (int i = 0; i < N; i++) {
    data_t v = x[i] * a;
    y[i]     = v;
    acc     += v;
  }

  *sum = acc;
}