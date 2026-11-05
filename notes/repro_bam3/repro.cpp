// notes/repro_bam3/repro.cpp: one beat of vecadd, no loop over beats; A, B, C are axis ports as in our kernels.
// LANES 64-bit lanes in one ac_int; c is either uninitialized (INIT=0, as our kernels before 542fa32) or = 0 (INIT=1).
#include <ac_int.h>
typedef ac_int<64 * LANES, false> vec_t;
#pragma HLS interface port=A mode=axis
#pragma HLS interface port=B mode=axis
#pragma HLS interface port=C mode=axis
void vadd(const vec_t A[1], const vec_t B[1], vec_t C[1]) {
    vec_t a = A[0], b = B[0];
#if INIT
    vec_t c = 0;
#else
    vec_t c;
#endif
#pragma HLS unroll
    for (int l = 0; l < LANES; l++) {
        long long x = (long long)a.slc<64>(64 * l).to_uint64() + (long long)b.slc<64>(64 * l).to_uint64();
        c.set_slc(64 * l, ac_int<64, false>((unsigned long long)x));
    }
    C[0] = c;
}
