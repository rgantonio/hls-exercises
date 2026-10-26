#!/usr/bin/env python3
"""bench/gen/gen_dace.py - case 3 sources from DaCe's FPGA backend.

Runs in snax-forge's pixi environment, so the SDFG is the one forge builds
(snax_forge.sdfg.build, same DaCe pin):

  pixi run --manifest-path $FORGE/pixi.toml \\
      python $PWD/bench/gen/gen_dace.py --forge $FORGE [--tier done] [--kernel vecadd]

For every kernel whose params.json has a "dace" case, and every size:

  1. build forge's simplified SDFG and specialize it to the size;
  2. FPGATransformSDFG, then the passes listed in params["dace"]["passes"];
  3. expand library nodes (implementations from params["dace"]["expansions"]);
  4. generate code only (v++ is never called) and keep DaCe's device file
     as dace/<size>/<kernel>_0_0.cpp, unchanged apart from a header comment;
  5. write dace/<size>/<kernel>_dace.cpp, a small top with the same
     arguments as the kernel's hand-written top (src/<kernel>.h), which calls
     DaCe's module function directly. The top gets ap_memory ports; DaCe's
     own entry function (m_axi, s_axilite, DATAFLOW) is left unused.

It also copies DaCe's runtime headers and hlslib into bench/gen/dace_include/,
so the Vitis machine needs no DaCe install. docs/HLS_VS_FORGE.md, section 4.3.
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BENCH = ROOT / "bench"
INCLUDE = BENCH / "gen" / "dace_include"

sys.path.insert(0, str(Path(__file__).resolve().parent))
from gen_data import load_spec, size_tag  # noqa: E402


def copy_includes() -> None:
    import dace

    pkg = Path(dace.__file__).resolve().parent
    pairs = [
        (pkg / "runtime" / "include" / "dace", INCLUDE / "dace"),
        (pkg / "external" / "hlslib" / "include" / "hlslib", INCLUDE / "hlslib"),
    ]
    for src, dst in pairs:
        if dst.exists():
            shutil.rmtree(dst)
        shutil.copytree(src, dst, ignore=shutil.ignore_patterns("cuda", "intel_fpga", "__pycache__"))
    lic = pkg / "external" / "hlslib" / "LICENSE.md"
    if lic.is_file():
        shutil.copy(lic, INCLUDE / "hlslib" / "LICENSE.md")
    (INCLUDE / "README.md").write_text(
        "# DaCe runtime headers\n\n"
        f"Copied by `bench/gen/gen_dace.py` from DaCe {dace.__version__} (BSD-3-Clause, "
        "https://github.com/spcl/dace) and its hlslib (BSD-3-Clause, `hlslib/LICENSE.md`). "
        "The case 3 device files include them. Do not edit; rerun the generator instead.\n"
    )
    print(f"copied DaCe {dace.__version__} headers to {INCLUDE.relative_to(ROOT)}")


def top_params(header: Path, kernel: str) -> str:
    """The parameter list of `void <kernel>(...);` in the kernel's header."""
    text = header.read_text()
    m = re.search(rf"void\s+{re.escape(kernel)}\s*\(([^)]*)\)\s*;", text)
    if not m:
        sys.exit(f"{header}: no declaration 'void {kernel}(...);' to copy the arguments from")
    return " ".join(m.group(1).split())


def param_names(params: str) -> list[str]:
    names = []
    for p in params.split(","):
        m = re.search(r"([A-Za-z_]\w*)\s*(\[|$)", p.strip())
        if not m:
            sys.exit(f"cannot read a parameter name from '{p}'")
        names.append(m.group(1))
    return names


def wrapper(kernel: str, params: str, module_sig: str, module_name: str, sdfg, symbols: dict) -> str:
    """The top <kernel>_dace: the hand-written top's arguments, DaCe's module inside.

    Module arguments named fpga_<X>, with X an argument of the hand-written top,
    become that argument (an ap_memory port). Everything else is a DaCe
    transient: an array becomes a local static array, a scalar a local
    variable passed by value (DaCe's module takes scalar transients by value).
    """
    import dace

    args = [a.strip() for a in module_sig.split(",") if a.strip()]
    names = param_names(params)
    lines, call, notes = [], [], []
    for a in args:
        ptr = re.match(r"(.+?)\s*\*\s*(?:__restrict__\s*)?([A-Za-z_]\w*)$", a)
        scalar = re.match(r"(.+?)\s+([A-Za-z_]\w*)$", a)
        if ptr:
            ctype, name = ptr.group(1).strip(), ptr.group(2)
            plain = name.removeprefix("fpga_")
            if name.startswith("fpga_") and plain in names:
                call.append(f"({ctype} *){plain}")
                continue
            desc = sdfg.arrays.get(name)
            size = int(dace.symbolic.evaluate(desc.total_size, symbols)) if desc is not None else 1
            lines.append(f"    static {ctype} {name}[{size}];  // DaCe transient array, kept inside the block")
            notes.append(f"{name}[{size}]")
            call.append(name)
        elif scalar:
            ctype, name = scalar.group(1).strip(), scalar.group(2)
            lines.append(f"    {ctype} {name} = 0;  // DaCe transient scalar, passed by value")
            notes.append(name)
            call.append(name)
        else:
            sys.exit(f"{module_name}: cannot read argument '{a}'")
    body = "\n".join(lines + [f"    {module_name}({', '.join(call)});"])
    extra = ""
    if notes:
        extra = ("// DaCe transients " + ", ".join(notes) + " stay inside the block for now; whether\n"
                 "// transient arrays become ports instead is open (docs/HLS_VS_FORGE.md, section 4.3).\n")
    return (
        f"// Generated by bench/gen/gen_dace.py. Do not edit.\n"
        f"// Top for case 3: same arguments as {kernel}() in src/{kernel}.h, so the testbench\n"
        f"// and the ap_memory ports are the same as in cases 1 and 2.\n{extra}"
        f'#include <cstdint>\n#include "{kernel}.h"\n\n'
        f"void {module_name}({', '.join(args)});\n\n"
        f"void {kernel}_dace({params}) {{\n{body}\n}}\n"
    )


def generate(kdir: Path, params: dict, forge: Path) -> None:
    import dace
    from dace.transformation.interstate import FPGATransformSDFG

    from snax_forge.sdfg.build import build

    kernel = params["kernel"]
    spec = load_spec(forge, params["forge_kernel"])
    cfg = params.get("dace", {})
    header = kdir / "src" / f"{kernel}.h"
    tparams = top_params(header, kernel)
    dace.Config.set("compiler", "fpga", "vendor", value="xilinx")
    # DaCe writes a build folder even for generate_code(); keep it out of the repo.
    import tempfile
    dace.Config.set("default_build_folder", value=tempfile.mkdtemp(prefix="gen_dace_"))

    for size in params["sizes"]:
        tag = size_tag(size)
        import numpy as np

        symbols = spec.bind_symbols(spec.make_inputs(np.random.default_rng(0), **size))
        sdfg = build(spec, simplify=True)
        sdfg.name = kernel
        sdfg.specialize(symbols)
        applied = sdfg.apply_transformations(FPGATransformSDFG)
        if not applied:
            sys.exit(f"{kernel} {tag}: FPGATransformSDFG did not apply")
        for name in cfg.get("passes", []):
            from dace.transformation.auto import fpga as fpga_auto

            getattr(fpga_auto, name)(sdfg)
        expansions = cfg.get("expansions", {})
        if expansions:
            sdfg.expand_library_nodes(recursive=False)
            for node, _ in sdfg.all_nodes_recursive():
                impl = expansions.get(type(node).__name__)
                if impl and isinstance(node, dace.nodes.LibraryNode):
                    node.implementation = impl
        sdfg.expand_library_nodes()

        codes = sdfg.generate_code()
        device = [c for c in codes if c.target.target_name == "xilinx" and c.language == "cpp"
                  and "module_" in c.clean_code]
        if len(device) != 1:
            sys.exit(f"{kernel} {tag}: expected one Xilinx device file, got {len(device)}")
        code = device[0].clean_code
        mods = re.findall(r"^void (module_\w+)\(([^)]*)\)\s*\{", code, re.M)
        if len(mods) != 1:
            sys.exit(f"{kernel} {tag}: expected one module function, got {[m[0] for m in mods]}; "
                     "kernels with several DaCe modules need a wrapper by hand")
        module_name, module_sig = mods[0]

        out = kdir / "dace" / tag
        out.mkdir(parents=True, exist_ok=True)
        stamp = (f"// Generated by bench/gen/gen_dace.py from snax-forge kernels/{params['forge_kernel']}.py\n"
                 f"// DaCe {dace.__version__}, symbols {symbols}, FPGATransformSDFG, "
                 f"passes {cfg.get('passes', [])}, expansions {expansions or 'default'}.\n"
                 f"// DaCe's device file, unchanged below this header. Do not edit.\n\n")
        (out / f"{kernel}_0_0.cpp").write_text(stamp + code)
        (out / f"{kernel}_dace.cpp").write_text(wrapper(kernel, tparams, module_sig, module_name, sdfg, symbols))
        print(f"wrote {out.relative_to(ROOT)}/{kernel}_0_0.cpp and {kernel}_dace.cpp ({module_name})")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--forge", type=Path, required=True, help="snax-forge checkout")
    ap.add_argument("--tier")
    ap.add_argument("--kernel")
    args = ap.parse_args()
    forge = args.forge.resolve()
    sys.path.insert(0, str(forge))
    copy_includes()
    n = 0
    for p in sorted(BENCH.glob("tier_*/*/params.json")):
        params = json.loads(p.read_text())
        params.setdefault("kernel", p.parent.name)
        tier = params.get("tier", p.parent.parent.name.removeprefix("tier_"))
        if (args.tier and tier != args.tier) or (args.kernel and params["kernel"] != args.kernel):
            continue
        if "dace" not in params.get("cases", {}):
            continue
        generate(p.parent, params, forge)
        n += 1
    if not n:
        sys.exit("no kernel folder with a dace case matched")
    return 0


if __name__ == "__main__":
    sys.exit(main())
