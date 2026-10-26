// bench/tier_done/dot/src/tb_dot.cpp
// One call on forge's inputs (vectors/<size>/data.h), the result checked exactly.
// DUT is the case's top, set by run_bench.tcl (-DDUT=dot or -DDUT=dot_dace).
#include <cstdio>
#include "dot.h"
#include "data.h"

#ifndef DUT
#error "compile with -DDUT=<top> (run_bench.tcl does this)"
#endif
#define STR2(x) #x
#define STR(x) STR2(x)

static data_t out[1];

int main() {
    out[0] = IN_out[0];

    DUT(IN_A, IN_B, out);

    int bad = out[0] != EXP_out[0];
    if (bad)
        std::printf("  out: got %lld expected %lld\n", (long long)out[0], (long long)EXP_out[0]);
    std::printf("%s %s N=%d: out = %lld\n", bad ? "FAIL" : "PASS", STR(DUT), N, (long long)out[0]);
    return bad;
}
