// bench/probe/bambu/include_stream/lanes.h
// The R0 probe header (bench/probe/bambu/include/lanes.h) without its four
// `#pragma HLS INLINE` lines; the accessors are plain `inline`. Used by probe.py's group D
// (BAM1 R0b, streams). The R0 header stays as it is, so R0's runs remain reproducible.
//
// Why: with any HLS pragma in an included header, Bambu 2024.10's front end rejects the
// `#pragma HLS interface` lines before the top with "Unassociated HLS pragma" (R0,
// notes/bambu_probe.md). Without them the fifo pragmas are accepted.
//
// Same names as bench/include/lanes.h: vec_t, cfg_t, lane, set_lane. vec_t is a struct of
// W data_t lanes, data_t itself at W = 1. Lane 0 is v[0], the lowest address and so the low
// lane, as in the original (lane 0 in the low bits).
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
    return v;
}
template <typename T>
inline void set_lane(T &v, int, T x) {
    v = x;
}

// The struct and its overloads exist only at W > 1, as in the R0 header.
#if W > 1
// L, not W: W is a macro here.
template <typename T, int L>
struct lanes_t {
    T v[L];
};
typedef lanes_t<data_t, W> vec_t;

template <typename T, int L>
inline T lane(const lanes_t<T, L> &v, int i) {
    return v.v[i];
}
template <typename T, int L>
inline void set_lane(lanes_t<T, L> &v, int i, T x) {
    v.v[i] = x;
}
#else
typedef data_t vec_t;
#endif
