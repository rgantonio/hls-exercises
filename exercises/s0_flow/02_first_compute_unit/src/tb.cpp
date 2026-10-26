#include <cstdio>
#include <cstdlib>
#include <climits>
#include "scale.h"

// ---------------------------------------------------------------------
// Reference model — kept separate from the kernel on purpose.
// Computed through unsigned so it wraps exactly like the RTL does.
// Signed overflow is UB in C++; the hardware just truncates.
// ---------------------------------------------------------------------
static data_t ref(data_t x, data_t a, data_t b) {
  unsigned ux = (unsigned)x;
  unsigned ua = (unsigned)a;
  unsigned ub = (unsigned)b;
  return (data_t)(ua * ux + ub);
}

// Written into the output before every call. If the kernel never writes,
// the poison survives and the comparison fails loudly.
static const data_t POISON = (data_t)0xDEADBEEF;

#ifdef __RTL_SIMULATION__
static const int N_RAND = 16;      // cosim: one RTL transaction per vector
#else
static const int N_RAND = 1000;    // csim: free
#endif

static const int MAX_REPORTED = 10;

static void check(data_t x, data_t a, data_t b, int *errors) {
  data_t y = POISON;
  scale(x, a, b, &y);
  data_t expected = ref(x, a, b);
  if (y != expected) {
    if (*errors < MAX_REPORTED) {
      printf("FAIL  x=%d a=%d b=%d  got=%d  expected=%d\n",
             x, a, b, y, expected);
    }
    (*errors)++;
  }
}

// Full 32-bit random: rand() only gives 31 bits on glibc.
static data_t rand32(void) {
  return (data_t)(((unsigned)rand() << 16) ^ (unsigned)rand());
}

int main() {
  int errors = 0;
  printf("scale tb: N_RAND = %d\n", N_RAND);

  // ---- directed vectors first: edge cases you chose on purpose --------
  static const data_t directed[][3] = {
    {       0,       0,       0},   // everything zero
    {       1,       1,       0},   // identity
    {       0,       5,       7},   // x = 0, b passes through
    {       1,       0,      -3},   // a = 0, b passes through
    {      -1,      -1,       0},   // sign handling
    {INT_MAX,        1,       0},   // largest input, no overflow
    {INT_MIN,        1,       0},   // smallest input, no overflow
    {INT_MAX,        2,       0},   // multiply overflow
    {       2, INT_MAX,       1},   // multiply overflow, other operand
    {INT_MAX,        1, INT_MAX},   // add overflow
    {  -7,           3,      11},   // mixed signs
  };
  const int n_directed = (int)(sizeof(directed) / sizeof(directed[0]));
  for (int i = 0; i < n_directed; ++i) {
    check(directed[i][0], directed[i][1], directed[i][2], &errors);
  }

  // ---- then seeded randoms -------------------------------------------
  srand(1);   // FIXED seed. Cosim replays this exact stimulus.
  for (int i = 0; i < N_RAND; ++i) {
    check(rand32(), rand32(), rand32(), &errors);
  }

  const int total = n_directed + N_RAND;
  if (errors) {
    printf("TEST FAILED: %d of %d vectors wrong\n", errors, total);
    return 1;
  }
  printf("TEST PASSED: %d vectors\n", total);
  return 0;
}