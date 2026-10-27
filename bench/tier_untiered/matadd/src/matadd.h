// bench/tier_untiered/matadd/src/matadd.h
#pragma once
#include <cstdint>

#ifndef DATA_T
#error "DATA_T must be set with -DDATA_T=<type> (bench.py does this)"
#endif
#ifndef SIZE_M
#error "SIZE_M must be set with -DSIZE_M=<n> (bench.py does this)"
#endif
#ifndef SIZE_N
#error "SIZE_N must be set with -DSIZE_N=<n> (bench.py does this)"
#endif
typedef DATA_T data_t;

#include "lanes.h"  // vec_t: one beat of W lanes; cfg_t: a run-time pin

// The size sets the testbench's arrays only (the C side of the axis ports). The hardware
// takes the run's length on the run-time pins; bench.py checks that every size's Verilog
// is the same (rtl_same in results/hls_cycles.csv).
const int M = SIZE_M, NC = SIZE_N;  // rows, columns
const int N = M * NC;  // elements
const int NB = N / W;  // beats per array
static_assert(N % W == 0, "the elements must be a multiple of W");

// snax-forge kernels/elementwise/matadd.py:  C[:] = A + B, A, B, C of M x N
// The rows are contiguous, so the block sees one flat run of M * N / W beats, as forge's
// recipe programs it (a temporal row loop and a split column loop in the streamer, one
// loopCount for the unit). Every array is one axis port of W-lane beats.
// loop_count: beats in the run (M * N / W), forge's loopCount.
void matadd(const vec_t A[NB], const vec_t B[NB], vec_t C[NB], cfg_t loop_count);

// Case 3 top, generated into dace/w<W>/matadd_dace.cpp by bench/gen/gen_dace.py.
void matadd_dace(const vec_t A[NB], const vec_t B[NB], vec_t C[NB], cfg_t loop_count);
