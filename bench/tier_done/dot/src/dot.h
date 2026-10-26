// bench/tier_done/dot/src/dot.h
#pragma once
#include <cstdint>

#ifndef DATA_T
#error "DATA_T must be set with -DDATA_T=<type> (bench.py does this)"
#endif
#ifndef SIZE_N
#error "SIZE_N must be set with -DSIZE_N=<n> (bench.py does this)"
#endif
typedef DATA_T data_t;

const int N = SIZE_N;

// NPBench / snax-forge kernels/polybench/dot.py:  out[0] = np.sum(A * B)
void dot(const data_t A[N], const data_t B[N], data_t out[1]);

// Case 3 top, generated into dace/<size>/dot_dace.cpp by bench/gen/gen_dace.py.
void dot_dace(const data_t A[N], const data_t B[N], data_t out[1]);
