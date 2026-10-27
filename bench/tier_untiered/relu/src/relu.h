// bench/tier_untiered/relu/src/relu.h
#pragma once
#include <cstdint>

#ifndef DATA_T
#error "DATA_T must be set with -DDATA_T=<type> (bench.py does this)"
#endif
#ifndef SIZE_N
#error "SIZE_N must be set with -DSIZE_N=<n> (bench.py does this)"
#endif
typedef DATA_T data_t;

#include "lanes.h"  // vec_t: one beat of W lanes; cfg_t: a run-time pin

// The size sets the testbench's arrays only (the C side of the axis ports). The hardware
// takes the run's length on the run-time pins; bench.py checks that every size's Verilog
// is the same (rtl_same in results/hls_cycles.csv).
const int N = SIZE_N;
const int NB = N / W;  // beats per array
static_assert(N % W == 0, "the elements must be a multiple of W");

// snax-forge kernels/elementwise/relu.py:  B[:] = np.maximum(A, 0)
// A compare-and-select per lane. Every array is one axis port of W-lane beats.
// loop_count: beats in the run (N / W), forge's loopCount.
void relu(const vec_t A[NB], vec_t B[NB], cfg_t loop_count);

// Case 3 top, generated into dace/w<W>/relu_dace.cpp by bench/gen/gen_dace.py.
void relu_dace(const vec_t A[NB], vec_t B[NB], cfg_t loop_count);
