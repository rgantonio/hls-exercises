// bench/probe/bambu/include/lanes.h
// Probe-only stand-in for bench/include/lanes.h under Bambu (BAM1 R0). It is first on the
// include path, so vecadd.h's #include "lanes.h" finds it. Same names as the original:
// vec_t, cfg_t, lane, set_lane, with #pragma HLS INLINE kept.
//
// Why: the original's vec_t is hlslib::DataPack over Xilinx ap_uint. Under Bambu that
// pulls in Bambu's own ap_int.h -> ac_int.h, which stops with "One or more of the
// following is defined: W, I, S, W2, I2, S2" because bench.py passes -DW=<lanes>.
//
// vec_t is a struct of W data_t lanes, data_t itself at W = 1. Lane 0 is v[0], the lowest
// address and so the low lane, as in the original (lane 0 in the low bits).
#pragma once
#include <cstdint>

#ifndef W
#error "W must be set with -DW=<lanes> (bench.py does this)"
#endif
#ifndef DATA_T
#error "DATA_T must be set with -DDATA_T=<type> (bench.py does this)"
#endif

// Bambu's co-simulation wrapper (HLS_output/simulation/mdpi_wrapper.cpp) includes the
// header that declares the top's argument types on its own, without vecadd.h, so data_t is
// declared here too. vecadd.h declares it the same way first; repeating a typedef of the
// same type is legal C++.
typedef DATA_T data_t;

// A run-time configuration pin, as in the original.
typedef uint32_t cfg_t;

template <typename T>
inline T lane(const T &v, int) {
#pragma HLS INLINE
    return v;
}
template <typename T>
inline void set_lane(T &v, int, T x) {
#pragma HLS INLINE
    v = x;
}

// The struct and its overloads exist only at W > 1: Bambu's front end stops with
// "Unassociated HLS pragma" on the INLINE pragma of a template that is never instantiated.
#if W > 1
// L, not W: W is a macro here.
template <typename T, int L>
struct lanes_t {
    T v[L];
};
typedef lanes_t<data_t, W> vec_t;

template <typename T, int L>
inline T lane(const lanes_t<T, L> &v, int i) {
#pragma HLS INLINE
    return v.v[i];
}
template <typename T, int L>
inline void set_lane(lanes_t<T, L> &v, int i, T x) {
#pragma HLS INLINE
    v.v[i] = x;
}
#else
typedef data_t vec_t;
#endif
