"""Experiment 3: W lanes (W = 4) the DaCe way, int64.

  dot  a) Vectorization on forge's SDFG after MapReduceFusion (the generic route)
       b) Vectorization first (the product map), then MapReduceFusion
       c) a BLAS Dot node on dace.vector arrays, FPGA_Accumulate and FPGA_PartialSums (DaCe's dot_test recipe)
  vsum d) Vectorization on forge's SDFG
  axpy e) Vectorization after auto_optimize's fusion (the transient gone)
       f) a BLAS Axpy node on dace.vector arrays, its 'fpga' expansion (DaCe's axpy_test recipe)
  relu g) Vectorization (works in the bench; the C++ does not compile): show the tasklet line
"""
import copy
import re
import traceback

import dace
from dace.libraries.blas import Axpy, Dot
from dace.memlet import Memlet
from dace.transformation.auto.auto_optimize import auto_optimize
from dace.transformation.dataflow import MapReduceFusion, Vectorization
from dace.transformation.interstate import FPGATransformSDFG, InlineSDFG

from common import OUT, device_code, forge_sdfg, summary

W = 4
VEC = {"vector_len": W, "propagate_parent": True, "preamble": False, "postamble": False}


def attempt(tag, fn):
    print(f"\n==================== {tag}")
    try:
        fn()
    except Exception as e:  # noqa: BLE001
        print(f"--- failed: {type(e).__name__}: {str(e)[:400]}")
        traceback.print_exc(limit=2)


def finish(sdfg, tag, label):
    sdfg.apply_transformations(FPGATransformSDFG)
    sdfg.expand_library_nodes()
    summary(sdfg, device_code(sdfg, tag), label)


def dot_a():
    s = forge_sdfg("polybench/dot", "dot")
    print("MapReduceFusion:", s.apply_transformations_repeated(MapReduceFusion))
    print("Vectorization:", s.apply_transformations(Vectorization, options=VEC))


def dot_b():
    s = forge_sdfg("polybench/dot", "dot")
    print("Vectorization:", s.apply_transformations(Vectorization, options=VEC))
    print("MapReduceFusion:", s.apply_transformations_repeated(MapReduceFusion))
    print("arrays:", {n: f"{d.dtype}{list(d.shape)}" for n, d in s.arrays.items()})
    finish(s, "dot_w4_vec_then_mrf", "Vectorization + MapReduceFusion + FPGATransformSDFG")


def dot_graph(impl):
    n = dace.symbol("n")
    sdfg = dace.SDFG(f"dot_{impl.lower()}_w{W}")
    st = sdfg.add_state("dot")
    vt = dace.vector(dace.int64, W)
    sdfg.add_array("A", [n / W], vt)
    sdfg.add_array("B", [n / W], vt)
    sdfg.add_array("out", [1], dace.int64)
    node = Dot("dot")
    node.implementation = impl
    node.n = n  # the element count; without it the expansion loops n / veclen^2 times
    st.add_memlet_path(st.add_read("A"), node, dst_conn="_x", memlet=Memlet(f"A[0:{n}/{W}]"))
    st.add_memlet_path(st.add_read("B"), node, dst_conn="_y", memlet=Memlet(f"B[0:{n}/{W}]"))
    st.add_memlet_path(node, st.add_write("out"), src_conn="_result", memlet=Memlet("out[0]"))
    sdfg.apply_transformations_repeated([FPGATransformSDFG, InlineSDFG])
    sdfg.expand_library_nodes()
    summary(sdfg, device_code(sdfg, f"dot_w{W}_{impl}"), f"Dot node, {impl}, veclen {W}")


def vsum_d():
    s = forge_sdfg("polybench/vsum", "vsum")
    print("Vectorization:", s.apply_transformations(Vectorization, options=VEC))


def axpy_e():
    s = forge_sdfg("blas/axpy", "axpy")
    auto_optimize(s, dace.DeviceType.FPGA)
    print("Vectorization after auto_optimize:", s.apply_transformations(Vectorization, options=VEC))


def axpy_f():
    n = dace.symbol("n")
    a = dace.symbol("alpha")
    sdfg = dace.SDFG(f"axpy_fpga_w{W}")
    sdfg.add_symbol("alpha", dace.int64)
    st = sdfg.add_state("axpy")
    vt = dace.vector(dace.int64, W)
    sdfg.add_array("x", [n / W], vt)
    sdfg.add_array("y", [n / W], vt)
    sdfg.add_array("y_out", [n / W], vt)
    node = Axpy("axpy", a)
    node.implementation = "fpga"
    st.add_memlet_path(st.add_read("x"), node, dst_conn="_x", memlet=Memlet(f"x[0:{n}/{W}]"))
    st.add_memlet_path(st.add_read("y"), node, dst_conn="_y", memlet=Memlet(f"y[0:{n}/{W}]"))
    st.add_memlet_path(node, st.add_write("y_out"), src_conn="_res", memlet=Memlet(f"y_out[0:{n}/{W}]"))
    sdfg.expand_library_nodes()  # DaCe's axpy_test order: expand, then FPGATransformSDFG
    sdfg.apply_transformations_repeated([FPGATransformSDFG, InlineSDFG])
    summary(sdfg, device_code(sdfg, f"axpy_w{W}_fpga"), f"Axpy node, fpga, veclen {W}")


def relu_g():
    s = forge_sdfg("elementwise/relu", "relu")
    print("Vectorization:", s.apply_transformations(Vectorization, options=VEC))
    finish(s, f"relu_w{W}_vec", "Vectorization + FPGATransformSDFG")
    code = (OUT / f"relu_w{W}_vec.cpp").read_text()
    print("tasklet:", [ln.strip() for ln in code.splitlines() if "max(" in ln][:1])


import sys
if len(sys.argv) > 1:
    for name in sys.argv[1:]:
        attempt(name, globals()[name] if name in globals() else (lambda n=name: dot_graph(n)))
    raise SystemExit
attempt("dot a) MapReduceFusion, then Vectorization", dot_a)
attempt("dot b) Vectorization, then MapReduceFusion", dot_b)
attempt("dot c1) Dot node, FPGA_Accumulate", lambda: dot_graph("FPGA_Accumulate"))
attempt("dot c2) Dot node, FPGA_PartialSums", lambda: dot_graph("FPGA_PartialSums"))
attempt("vsum d) Vectorization", vsum_d)
attempt("axpy e) auto_optimize, then Vectorization", axpy_e)
attempt("axpy f) Axpy node, fpga", axpy_f)
attempt("relu g) Vectorization", relu_g)
