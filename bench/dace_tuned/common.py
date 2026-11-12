"""Shared helpers for the DaCe tuning experiments (snax-forge open item 130): forge's SDFG as gen_dace.py builds
it, and the Xilinx device code DaCe writes for it.

Paths: FORGE (snax-forge checkout, default ../snax-forge beside this repo). Generated C++ goes to out/ here
(ignored by git): out/<tag>.cpp holds every Xilinx file DaCe writes, out/dev/<tag>.cpp only the device file.
"""
import os
import sys
import tempfile
from pathlib import Path

import dace

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FORGE = Path(os.environ.get("FORGE", ROOT.parent / "snax-forge")).resolve()
sys.path.insert(0, str(ROOT / "bench" / "gen"))
from gen_data import load_spec  # noqa: E402

from snax_forge.sdfg.build import build  # noqa: E402

dace.Config.set("compiler", "fpga", "vendor", value="xilinx")
dace.Config.set("default_build_folder", value=tempfile.mkdtemp(prefix="dace_tuned_"))
OUT = HERE / "out"
(OUT / "dev").mkdir(parents=True, exist_ok=True)


def forge_sdfg(rel: str, name: str, dtype: str = "int64"):
    """The bench's starting point: forge's SDFG, every container at int64, sizes symbolic."""
    spec = load_spec(FORGE, rel)
    spec = spec.with_dtypes({c: dtype for c in spec.descriptors}, "dace_tuned")
    sdfg = build(spec, simplify=True)
    sdfg.name = name
    return sdfg


def device_code(sdfg, tag: str) -> str:
    """Generate code; write every Xilinx file to out/<tag>.cpp and the device file alone to out/dev/<tag>.cpp."""
    codes = [c.clean_code for c in sdfg.generate_code() if c.target.target_name == "xilinx" and c.language == "cpp"]
    (OUT / f"{tag}.cpp").write_text("\n\n// ======== next file ========\n\n".join(codes))
    dev = [c for c in codes if "fpga_device.h" in c]
    (OUT / "dev" / f"{tag}.cpp").write_text(dev[0] if dev else "")
    return "\n".join(codes)


def summary(sdfg, text: str, tag: str) -> None:
    """One line per variant: its modules, its top-level transients (a RAM shows as an [N] array), library nodes
    left, then the HLS pragmas it carries."""
    import re

    mods = re.findall(r"^void (module_\w+)\(", text, re.M)
    trans = sorted({f"{n}{list(d.shape)}:{d.storage.name}" for n, d in sdfg.arrays.items() if d.transient})
    libs = sorted({type(n).__name__ for n, _ in sdfg.all_nodes_recursive() if isinstance(n, dace.nodes.LibraryNode)})
    print(f"--- {tag}: modules {mods}; top-level transients {trans}; library nodes left {libs}")
    for p in ("PIPELINE", "UNROLL", "DATAFLOW", "ARRAY_PARTITION", "DEPENDENCE"):
        n = text.count(f"#pragma HLS {p}")
        if n:
            print(f"    #pragma HLS {p}: {n}")
