"""Experiment 1: what the bench does today (FPGATransformSDFG only) against DaCe's own auto_optimize(FPGA),
on forge's SDFGs at W = 1, int64."""
import copy
import sys
import traceback

import dace
from dace.transformation.auto.auto_optimize import auto_optimize
from dace.transformation.interstate import FPGATransformSDFG

from common import device_code, forge_sdfg, summary

KERNELS = {"dot": "polybench/dot", "axpy": "blas/axpy", "vsum": "polybench/vsum", "vecadd": "polybench/vecadd",
           "relu": "elementwise/relu", "rowsum": "elementwise/rowsum"}

for k in (sys.argv[1:] or KERNELS):
    print(f"\n==================== {k}")
    base = forge_sdfg(KERNELS[k], k)
    a = copy.deepcopy(base)
    a.apply_transformations(FPGATransformSDFG)
    a.expand_library_nodes()
    summary(a, device_code(a, f"{k}_today"), "today (FPGATransformSDFG)")
    try:
        b = copy.deepcopy(base)
        auto_optimize(b, dace.DeviceType.FPGA)
        b.expand_library_nodes()
        summary(b, device_code(b, f"{k}_auto"), "auto_optimize(FPGA)")
    except Exception as e:  # noqa: BLE001
        print(f"--- auto_optimize(FPGA) failed: {type(e).__name__}: {str(e)[:300]}")
        traceback.print_exc(limit=3)
