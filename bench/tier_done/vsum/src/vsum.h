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

#include "lanes.h"  // vec_t: one beat of W lanes; cfg_t: a run-time pin

// N sizes the testbench's arrays only (the C side of the axis ports). The hardware
// takes the run's length on the loop_count pin; bench.py checks that every size's
// Verilog is the same (rtl_same in results/hls_cycles.csv).
const int N = SIZE_N;
const int NB = N / W;  // beats per array
static_assert(N % W == 0, "N must be a multiple of W");
const int NOUT = 1;  // results per run here: len = loop_count, so one sum

// NPBench / snax-forge kernels/polybench/vsum.py:  out[0] = np.sum(A)
// Every array is one axis port of W-lane beats, read or written once, in order.
// Run-time pins, as forge's Accumulator: loop_count, the beats in the run (N / W),
// and len, the beats per result (T). A result leaves every len beats and at the
// last beat, and the sum restarts. The testbench sets len = loop_count (one sum).
void vsum(const vec_t A[NB], data_t out[NOUT], cfg_t loop_count, cfg_t len);

// Case 3 top, generated into dace/w<W>/vsum_dace.cpp by bench/gen/gen_dace.py.
void vsum_dace(const vec_t A[NB], data_t out[NOUT], cfg_t loop_count, cfg_t len);
