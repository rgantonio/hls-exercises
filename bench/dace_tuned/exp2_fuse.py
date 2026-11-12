"""Experiment 2: remove dot's 2048-word transient with DaCe's own MapReduceFusion (map followed by a Reduce
-> one map with a WCR output), then FPGATransformSDFG, plain or with auto_optimize(FPGA)."""
import copy

import dace
from dace.transformation.auto.auto_optimize import auto_optimize
from dace.transformation.dataflow import MapReduceFusion
from dace.transformation.interstate import FPGATransformSDFG

from common import device_code, forge_sdfg, summary

for k, rel in (("dot", "polybench/dot"), ("rowsum", "elementwise/rowsum")):
    base = forge_sdfg(rel, k)
    n = base.apply_transformations_repeated(MapReduceFusion)
    print(f"\n==================== {k}: MapReduceFusion applied {n}x")
    a = copy.deepcopy(base)
    a.apply_transformations(FPGATransformSDFG)
    a.expand_library_nodes()
    summary(a, device_code(a, f"{k}_mrf"), "MapReduceFusion + FPGATransformSDFG")
    b = copy.deepcopy(base)
    auto_optimize(b, dace.DeviceType.FPGA)
    b.expand_library_nodes()
    summary(b, device_code(b, f"{k}_mrf_auto"), "MapReduceFusion + auto_optimize(FPGA)")
