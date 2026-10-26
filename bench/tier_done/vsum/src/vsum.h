// bench/tier_done/vsum/src/vsum.h
#pragma once
#include <cstdint>

#ifndef DATA_T
#error "DATA_T must be set with -DDATA_T=<type> (bench.py does this)"
#endif
#ifndef SIZE_N
#error "SIZE_N must be set with -DSIZE_N=<n> (bench.py does this)"
#endif
typedef DATA_T data_t;

#include "lanes.h"  // vec_t: one beat of W lanes

const int N = SIZE_N;
const int NB = N / W;  // beats per array
static_assert(N % W == 0, "N must be a multiple of W");

// NPBench / snax-forge kernels/polybench/vsum.py:  out[0] = np.sum(A)
// Every array is one axis port of W-lane beats, read or written once, in order.
void vsum(const vec_t A[NB], data_t out[1]);

// Case 3 top, generated into dace/<size>_w<W>/vsum_dace.cpp by bench/gen/gen_dace.py.
void vsum_dace(const vec_t A[NB], data_t out[1]);
