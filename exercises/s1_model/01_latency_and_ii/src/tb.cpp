#include <cstdio>
#include <cstdlib>
#include "vec_scale.h"

#ifdef __RTL_SIMULATION__
static const int NUM_CALLS = 2;
#else
static const int NUM_CALLS = 8;
#endif

static const data_t POISON = (data_t)0xDEADBEEF;

// Reference model. The unsigned cast makes overflow well-defined in C++;
// the RTL just wraps. If you switch data_t to float, drop the casts.
static void ref(data_t a, data_t b, const data_t x[N], data_t y[N]) {
    for (int i = 0; i < N; i++)
        y[i] = (data_t)((unsigned)a * (unsigned)x[i] + (unsigned)b);
}

int main() {
    printf("NUM_CALLS = %d\n", NUM_CALLS);   // first line: confirms the macro from run.log

    static data_t x[N], y[N], y_ref[N];
    int errors = 0;

    for (int call = 0; call < NUM_CALLS; call++) {
        data_t a, b;

        if (call == 0)      { a = 0;  b = 0;  for (int i=0;i<N;i++) x[i] = i; }
        else if (call == 1) { a = 1;  b = -1; for (int i=0;i<N;i++) x[i] = -i; }
        else if (call == 2) { a = (data_t)0x7FFFFFFF; b = 1;          // force overflow
                              for (int i=0;i<N;i++) x[i] = 3; }
        else                { srand(1234 + call);
                              a = rand(); b = rand();
                              for (int i=0;i<N;i++) x[i] = rand() - RAND_MAX/2; }

        for (int i = 0; i < N; i++) y[i] = POISON;   // catch "kernel never wrote"

        ref(a, b, x, y_ref);
        vec_scale(a, b, x, y);

        for (int i = 0; i < N; i++) {
            if (y[i] != y_ref[i]) {
                if (errors < 10)
                    printf("call %d idx %d: got %d expected %d\n",
                           call, i, (int)y[i], (int)y_ref[i]);
                errors++;
            }
        }
    }

    printf(errors ? "FAIL: %d mismatches\n" : "PASS\n", errors);
    return errors ? 1 : 0;
}