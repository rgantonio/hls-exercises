#include <cstdio>
#include <cstdlib>
#include "iface.h"

static const data_t POISON = (data_t)0xDEADBEEF;

// Reference model. Overflow is computed through unsigned so the reference wraps
// the same way the RTL does; signed overflow is UB in C++.
static void ref(data_t a, const data_t x[N], data_t y[N], data_t *sum) {
  unsigned acc = 0u;
  for (int i = 0; i < N; i++) {
    unsigned v = (unsigned)x[i] * (unsigned)a;
    y[i] = (data_t)v;
    acc += v;
  }
  *sum = (data_t)acc;
}

static int check(const char *name, data_t a, const data_t x[N]) {
  data_t y_dut[N], y_ref[N];
  data_t s_dut, s_ref;

  for (int i = 0; i < N; i++) y_dut[i] = POISON;
  s_dut = POISON;

  iface(a, x, y_dut, &s_dut);
  ref(a, x, y_ref, &s_ref);

  int errors = 0;
  for (int i = 0; i < N; i++) {
    if (y_dut[i] != y_ref[i]) {
      if (errors < 5)
        printf("FAIL %-10s y[%2d] got %d want %d\n", name, i, y_dut[i], y_ref[i]);
      errors++;
    }
  }
  if (s_dut != s_ref) {
    printf("FAIL %-10s sum   got %d want %d\n", name, s_dut, s_ref);
    errors++;
  }
  return errors;
}

int main() {
  int errors = 0;
  data_t x[N];

  // ---- directed cases -------------------------------------------------
  for (int i = 0; i < N; i++) x[i] = 0;        errors += check("zeros",   3, x);
  for (int i = 0; i < N; i++) x[i] = 1;        errors += check("ones",    3, x);
  for (int i = 0; i < N; i++) x[i] = i;        errors += check("ramp_a0", 0, x);
  for (int i = 0; i < N; i++) x[i] = i;        errors += check("ramp_a1", 1, x);
  for (int i = 0; i < N; i++) x[i] = i;        errors += check("ramp_an1", -1, x);
  for (int i = 0; i < N; i++) x[i] = 0x7FFFFFFF; errors += check("maxint", 2, x);
  for (int i = 0; i < N; i++) x[i] = (data_t)0x80000000; errors += check("minint", 2, x);

  // ---- randoms, fixed seed -------------------------------------------
  srand(1);
  for (int t = 0; t < 20; t++) {
    for (int i = 0; i < N; i++) x[i] = (data_t)rand() - (data_t)rand();
    data_t a = (data_t)rand() - (data_t)rand();
    errors += check("rand", a, x);
  }

  if (errors) {
    printf("TEST FAILED with %d errors\n", errors);
    return 1;
  }
  printf("TEST PASSED\n");
  return 0;
}