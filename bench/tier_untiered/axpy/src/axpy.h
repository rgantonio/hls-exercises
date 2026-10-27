// bench/tier_untiered/axpy/src/axpy.h
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

// snax-forge kernels/blas/axpy.py:  y += alpha * x
// An axis port cannot be read and written in place (forge open item 47), so y comes in
// on y and leaves on y_out. alpha is a scalar: forge would hold it in a CSR, so here it
// is a run-time pin like loop_count (data plus ap_vld, read once per run).
// loop_count: beats in the run (N / W), forge's loopCount.
void axpy(const vec_t x[NB], const vec_t y[NB], vec_t y_out[NB], data_t alpha, cfg_t loop_count);

// Case 3 top, generated into dace/w<W>/axpy_dace.cpp by bench/gen/gen_dace.py.
void axpy_dace(const vec_t x[NB], const vec_t y[NB], vec_t y_out[NB], data_t alpha, cfg_t loop_count);
