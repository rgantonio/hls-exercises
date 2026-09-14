#include "scale.h"

void scale(data_t x, data_t a, data_t b, data_t *y) {
  *y = a * x + b;
}