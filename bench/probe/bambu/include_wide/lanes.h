// bench/probe/bambu/include_wide/lanes.h
// Probe-only lanes.h for Bambu with beat-wide ports (BAM1 R0c, probe.py group E). Same names
// as bench/include/lanes.h: vec_t, cfg_t, lane, set_lane. No `#pragma HLS INLINE` lines:
// with any HLS pragma in an included header, Bambu 2024.10 rejects the interface pragmas
// before the top with "Unassociated HLS pragma" (R0, notes/bambu_probe.md).
//
// vec_t is data_t at W = 1 and one ac_int<64*W, false> above, so a beat is one value and one
// transfer on a fifo or axis port. With R0b's struct of W lanes (include_stream/), Bambu
// split the struct into its fields: 64-bit ports, one lane per transfer. Lane i is bits
// [64i, 64i+63], lane 0 in the low bits, as hlslib's DataPack (bench/include/lanes.h).
//
// The lane count comes as -DBAMBU_LANES=<lanes>, not -DW=<lanes>, and this header defines W
// from it after including ac_int.h. Bambu's ac_int.h stops with "One or more of the
// following is defined: W, I, S, W2, I2, S2" when W is a macro, and Bambu's generated
// co-simulation files (HLS_output/simulation/mdpi_wrapper.cpp, generated_tb.c) include
// ac_int.h directly, compiled with the command's -D flags, so a -DW on the command line
// breaks them whatever this header does. The kernel source stays unchanged: vecadd.h and
// tb_vecadd.cpp use W only after including lanes.h.
#pragma once
#include <cstdint>

#ifdef W
#error "include_wide/lanes.h takes the lane count as -DBAMBU_LANES=<lanes>, not -DW (Bambu's co-simulation files include ac_int.h with the command's -D flags)"
#endif
#ifndef BAMBU_LANES
#error "BAMBU_LANES must be set with -DBAMBU_LANES=<lanes> (probe.py group E does this)"
#endif
#ifndef DATA_T
#error "DATA_T must be set with -DDATA_T=<type> (bench.py does this)"
#endif

#include <ac_int.h>
#define W BAMBU_LANES

// Bambu's co-simulation wrapper (HLS_output/simulation/mdpi_wrapper.cpp) includes the
// header that declares the top's argument types on its own, without vecadd.h, so data_t is
// declared here too. vecadd.h declares it the same way first; repeating a typedef of the
// same type is legal C++.
typedef DATA_T data_t;

// A run-time configuration pin, as in the original.
typedef uint32_t cfg_t;

template <typename T>
inline T lane(const T &v, int) {
    return v;
}
template <typename T>
inline void set_lane(T &v, int, T x) {
    v = x;
}

#if W > 1
typedef ac_int<64 * W, false> vec_t;

// WB, not W: W is a macro here.
template <int WB>
inline data_t lane(const ac_int<WB, false> &v, int i) {
    return (data_t)v.template slc<64>(64 * i).to_uint64();
}
template <int WB>
inline void set_lane(ac_int<WB, false> &v, int i, data_t x) {
    v.set_slc(64 * i, ac_int<64, false>((unsigned long long)x));
}
#else
typedef data_t vec_t;
#endif
