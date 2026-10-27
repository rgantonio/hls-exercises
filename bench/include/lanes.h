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
// CSR manager drives them and the block samples them at start (forge D130). run_bench.tcl
// gives each pin an ap_vld interface (data plus a valid bit): Vitis holds it in a register
// loaded while ap_vld is high, and the driver pulses ap_vld for one cycle with the start, as
// forge loads its config on io.start. As a plain ap_none wire, Vitis read the port inside the
// loop; with ap_none -register, the register reloaded every cycle.
// Lanes (W) and the dtype stay compile-time: they decide what hardware exists.
typedef uint32_t cfg_t;

// The lane accessors are packing, not part of any kernel's algorithm, so they are always
// inlined. Without the pragma, Vitis kept lane<long, 32> as a module at W = 32 in the opt
// tops with two inputs, instantiated it 64 times and registered both 2048-bit beats and
// every lane: 5.5x the area of W = 16 for the same cycles (07f5dec, results/runs/
// 2026-10-27_wsweep.md). At W <= 16 Vitis inlined it on its own.
template <typename T>
inline T lane(const T &v, int) {
#pragma HLS INLINE
    return v;
}
template <typename T, int L>
inline T lane(const hlslib::DataPack<T, L> &v, int i) {
#pragma HLS INLINE
    return v.Get(i);
}

template <typename T>
inline void set_lane(T &v, int, T x) {
#pragma HLS INLINE
    v = x;
}
template <typename T, int L>
inline void set_lane(hlslib::DataPack<T, L> &v, int i, T x) {
#pragma HLS INLINE
    v.Set(i, x);
}
