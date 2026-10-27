// bench/tier_untiered/rowsum/src/rowsum.h
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
const int NB = N / W;  // beats in A
const int NOUT = M;  // results: one per row
static_assert(N % W == 0, "the elements must be a multiple of W");

// snax-forge kernels/elementwise/rowsum.py:  y[:] = np.sum(A, axis=1)
// vsum's top with len < loop_count: the sum restarts every row, as forge's Accumulator
// runs recipes/rowsum.json (T = N / W beats per sum, M sums per run).
// Run-time pins: loop_count, the beats in the run (M * N / W), and len, the beats per
// result (N / W). y is one axis port of one element per beat, M beats.
void rowsum(const vec_t A[NB], data_t y[NOUT], cfg_t loop_count, cfg_t len);

// Case 3 top, generated into dace/w<W>/rowsum_dace.cpp by bench/gen/gen_dace.py.
void rowsum_dace(const vec_t A[NB], data_t y[NOUT], cfg_t loop_count, cfg_t len);
