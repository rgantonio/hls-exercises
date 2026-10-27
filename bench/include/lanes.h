// bench/include/lanes.h
// One beat of W lanes, the shape of forge's Decoupled(Vec(lanes, UInt(64))):
// one valid-ready handshake around all W lanes. With an axis interface on the
// array argument it becomes one AXI4-Stream port, TDATA = W x 64 bits, lane 0 in
// the low bits (as Chisel packs a Vec).
//
// vec_t is DaCe's own type, dace::vec<T, W>: T itself when W = 1 and
// hlslib::DataPack<T, W> (one ap_uint<W*64>) above, so case 3's generated module
// takes exactly the type cases 1 and 2 use.
#pragma once
#include <cstdint>

// hlslib's DataPack bounds-checks Get/Set with std::stringstream unless
// HLSLIB_SYNTHESIS is set, and Vitis's csynth front end cannot parse that.
// params.json passes -DHLSLIB_SYNTHESIS to every case.
#ifndef HLSLIB_SYNTHESIS
#error "HLSLIB_SYNTHESIS must be set (params.json cflags); hlslib's DataPack does not synthesize without it"
#endif
#include "dace/xilinx/vec.h"

#ifndef W
#error "W must be set with -DW=<lanes> (bench.py does this)"
#endif

typedef dace::vec<data_t, W> vec_t;

// A run-time configuration pin, as forge's 32-bit config fields (loopCount, len): the
// CSR manager drives them and the block samples them at start (forge D130). A scalar
// argument of the top becomes an ap_none input, a plain wire with no handshake.
// run_bench.tcl gives each pin -register, so Vitis loads it into a register at
// ap_start; a local copy in the C++ alone is not enough (Vitis reads the port directly).
// Lanes (W) and the dtype stay compile-time: they decide what hardware exists.
typedef uint32_t cfg_t;

template <typename T>
inline T lane(const T &v, int) { return v; }
template <typename T, int L>
inline T lane(const hlslib::DataPack<T, L> &v, int i) { return v.Get(i); }

template <typename T>
inline void set_lane(T &v, int, T x) { v = x; }
template <typename T, int L>
inline void set_lane(hlslib::DataPack<T, L> &v, int i, T x) { v.Set(i, x); }
