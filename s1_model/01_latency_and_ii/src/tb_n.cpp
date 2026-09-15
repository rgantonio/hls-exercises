#include <cstdio>
#include <cstdlib>
#include "vec_scale.h"

// csynth-only exercise — no cosim on this project, so no __RTL_SIMULATION__ guard.
static const int NUM_TRIPS = 4;
static const int TRIPS[NUM_TRIPS] = {1, 17, 512, 1024};

static const data_t POISON = (data_t)0xDEADBEEF;

// Reference model. Unsigned cast makes overflow well-defined in C++;
// the RTL just wraps. If you switch data_t to float, drop the casts.
static void ref_n(data_t a, data_t b, const data_t x[N], data_t y[N], int n) {
    for (int i = 0; i < n; i++)
        y[i] = (data_t)((unsigned)a * (unsigned)x[i] + (unsigned)b);
}

int main() {
    static data_t x[N], y[N], y_ref[N];
    int errors = 0;

    for (int call = 0; call < NUM_TRIPS; call++) {
        const int n = TRIPS[call];

        srand(1234 + call);
        data_t a = rand();
        data_t b = rand();
        for (int i = 0; i < N; i++) x[i] = rand() - RAND_MAX / 2;

        for (int i = 0; i < N; i++) y[i] = POISON;

        ref_n(a, b, x, y_ref, n);
        vec_scale_n(a, b, x, y, n);

        // in range: must match the reference
        for (int i = 0; i < n; i++) {
            if (y[i] != y_ref[i]) {
                if (errors < 10)
                    printf("n=%d idx %d: got %d expected %d\n",
                           n, i, (int)y[i], (int)y_ref[i]);
                errors++;
            }
        }

        // past the bound: must still be poison
        for (int i = n; i < N; i++) {
            if (y[i] != POISON) {
                if (errors < 10)
                    printf("n=%d idx %d: wrote past the bound (%d)\n",
                           n, i, (int)y[i]);
                errors++;
            }
        }

        printf("n=%4d checked\n", n);
    }

    printf(errors ? "FAIL: %d mismatches\n" : "PASS\n", errors);
    return errors ? 1 : 0;
}