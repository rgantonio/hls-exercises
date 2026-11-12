"""Experiment 4: dot written as np.dot (a BLAS Dot node from the frontend), int64, through auto_optimize(FPGA):
which expansion does DaCe pick by itself, and what does it build?"""
import dace
import numpy as np
from dace.transformation.auto.auto_optimize import auto_optimize

from common import device_code, summary

N = dace.symbol("N")


@dace.program
def dot(A: dace.int64[N], B: dace.int64[N], out: dace.int64[1]):
    out[0] = np.dot(A, B)


s = dot.to_sdfg(simplify=True)
print("library nodes:", {type(n).__name__ for n, _ in s.all_nodes_recursive() if isinstance(n, dace.nodes.LibraryNode)})
auto_optimize(s, dace.DeviceType.FPGA)
print("implementations:", {f"{type(n).__name__}:{n.implementation}" for n, _ in s.all_nodes_recursive()
                           if isinstance(n, dace.nodes.LibraryNode)})
s.expand_library_nodes()
summary(s, device_code(s, "dot_npdot_auto"), "np.dot + auto_optimize(FPGA)")
