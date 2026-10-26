// bench/tier_done/vecmul/src/vecmul.h
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

// NPBench / snax-forge kernels/polybench/vecmul.py:  C[:] = A * B
void vecmul(const data_t A[N], const data_t B[N], data_t C[N]);

// Case 3 top, generated into dace/<size>/vecmul_dace.cpp by bench/gen/gen_dace.py.
void vecmul_dace(const data_t A[N], const data_t B[N], data_t C[N]);
