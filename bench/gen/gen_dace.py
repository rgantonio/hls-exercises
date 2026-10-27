#!/usr/bin/env python3
"""bench/gen/gen_dace.py - case 3 sources from DaCe's FPGA backend.

Runs in snax-forge's pixi environment, so the SDFG is the one forge builds
(snax_forge.sdfg.build, same DaCe pin):

  pixi run --manifest-path $FORGE/pixi.toml \\
      python $PWD/bench/gen/gen_dace.py --forge $FORGE [--tier done] [--kernel vecadd]

For every kernel whose params.json has a "dace" case, and every W of that case
(params["cases"]["dace"]["W"]):

  1. build forge's simplified SDFG and keep its sizes symbolic: DaCe passes a
     free symbol (N) to its module as a scalar argument, so the size is a
     run-time pin, as forge's loopCount, and one hardware serves every size;
  2. at W > 1, DaCe's Vectorization with vector_len W, so the arrays become
     W-lane words of dace::vec<T, W> (params["dace"]["vectorize"] must be true:
     DaCe 1.0.2 cannot vectorize reductions);
  3. FPGATransformSDFG, then the passes listed in params["dace"]["passes"];
  4. expand library nodes (implementations from params["dace"]["expansions"]);
  5. generate code only (v++ is never called) and keep DaCe's device file
     as dace/w<W>/<kernel>_0_0.cpp, unchanged apart from a header comment;
  6. write dace/w<W>/<kernel>_dace.cpp, a small top with the same arguments
     as the kernel's hand-written top (src/<kernel>.h), which calls DaCe's
     module function directly. Its ports get the same interface as cases 1 and
     2 (axis, from params.json); DaCe's own entry function (m_axi, s_axilite,
     DATAFLOW) is left unused. DaCe's symbols are computed from the top's pins
     with params["dace"]["symbols"] (e.g. {"N": "loop_count * W"}), and a
     transient array is sized for the largest size in params.json, a
     design-time bound of DaCe's hardware.

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
    for p in split_args(params):
        m = re.search(r"([A-Za-z_]\w*)\s*(\[|$)", p.strip())
        if not m:
            sys.exit(f"cannot read a parameter name from '{p}'")
        names.append(m.group(1))
    return names


def split_args(sig: str) -> list[str]:
    """Split a C++ parameter list on top-level commas (not those inside <...>)."""
    out, depth, cur = [], 0, ""
    for ch in sig:
        depth += (ch == "<") - (ch == ">")
        if ch == "," and depth == 0:
            out.append(cur.strip())
            cur = ""
        else:
            cur += ch
    if cur.strip():
        out.append(cur.strip())
    return out


def split_inout(sdfg, renames: dict) -> None:
    """An inout array (axpy's y) becomes two: reads keep the name, writes go to the new one
    (y_out), because an axis port cannot be read and written in place. Every access node
    that is written to, and the memlets into it, take the new name."""
    import copy

    for old, new in renames.items():
        if old not in sdfg.arrays:
            sys.exit(f"split_inout: no array '{old}' in the SDFG")
        sdfg.add_datadesc(new, copy.deepcopy(sdfg.arrays[old]))
        written = 0
        for state in sdfg.states():
            for node in state.data_nodes():
                if node.data == old and state.in_degree(node) > 0:
                    node.data = new
                    for e in state.in_edges(node):  # the whole path, through map exits
                        for pe in state.memlet_path(e):
                            if pe.data.data == old:
                                pe.data.data = new
                    written += 1
        if not written:
            sys.exit(f"split_inout: '{old}' is never written")


def wrapper(kernel: str, params: str, module_sig: str, module_name: str, sdfg, symbols: dict,
            sym_map: dict, max_tag: str, buffers: dict) -> str:
    """The top <kernel>_dace: the hand-written top's arguments, DaCe's module inside.

    Module arguments named fpga_<X>, with X an argument of the hand-written top,
    become that argument (an axis port). A scalar argument that is one of DaCe's
    symbols gets its value from the top's pins through sym_map (a C++
    expression, e.g. "loop_count * W"). Everything else is a DaCe transient: an
    array becomes a local static array sized at `symbols` (the largest size), a
    scalar a local variable passed by value (DaCe's module takes scalar
    transients by value). A scalar argument named like an argument of the top (axpy's
    alpha) is passed through. An output listed in `buffers` (name -> element count,
    a C++ expression) is written by DaCe more than once or out of order (rowsum's
    reduction adds into y[i] every cycle), so it goes to a local buffer, which the top
    then streams out in order.
    """
    import dace

    args = split_args(module_sig)
    names = param_names(params)
    lines, call, notes, post = [], [], [], []
    for a in args:
        ptr = re.match(r"(.+?)\s*\*\s*(?:__restrict__\s*)?([A-Za-z_]\w*)$", a)
        scalar = re.match(r"(.+?)\s+([A-Za-z_]\w*)$", a)
        if ptr:
            ctype, name = ptr.group(1).strip(), ptr.group(2)
            plain = name.removeprefix("fpga_")
            if name.startswith("fpga_") and plain in buffers:
                desc = sdfg.arrays.get(plain)
                size = int(dace.symbolic.evaluate(desc.total_size, symbols)) if desc is not None else 1
                lines.append(f"    static {ctype} {plain}_buf[{size}];  // DaCe adds into {plain} in place: buffered, "
                             f"sized for {max_tag}")
                call.append(f"{plain}_buf")
                post.append(f"OUT_{plain}:\n    for (int i = 0; i < (int)({buffers[plain]}); i++) {plain}[i] = {plain}_buf[i];")
                notes.append(f"{plain}_buf[{size}] (the output, buffered)")
                continue
            if name.startswith("fpga_") and plain in names:
                call.append(f"({ctype} *){plain}")
                continue
            desc = sdfg.arrays.get(name)
            size = int(dace.symbolic.evaluate(desc.total_size, symbols)) if desc is not None else 1
            lines.append(f"    static {ctype} {name}[{size}];  // DaCe transient array, inside the block, sized for {max_tag}")
            notes.append(f"{name}[{size}]")
            call.append(name)
        elif scalar and scalar.group(2) in sym_map:
            ctype, name = scalar.group(1).strip(), scalar.group(2)
            lines.append(f"    {ctype} {name} = ({ctype})({sym_map[name]});  // DaCe symbol, from the run-time pins")
            call.append(name)
        elif scalar and scalar.group(2) in names:
            call.append(scalar.group(2))  # a scalar argument of the top, e.g. axpy's alpha
        elif scalar and scalar.group(2) in {str(s) for s in sdfg.free_symbols} | set(sdfg.symbols):
            sys.exit(f"{module_name}: argument '{a}' is a DaCe symbol with no entry in params['dace']['symbols']")
        elif scalar:
            ctype, name = scalar.group(1).strip(), scalar.group(2)
            lines.append(f"    {ctype} {name} = 0;  // DaCe transient scalar, passed by value")
            notes.append(name)
            call.append(name)
        else:
            sys.exit(f"{module_name}: cannot read argument '{a}'")
    body = "\n".join(lines + [f"    {module_name}({', '.join(call)});"] + post)
    extra = ""
    if notes:
        extra = ("// DaCe transients " + ", ".join(notes) + f" stay inside the block for now (arrays sized for\n"
                 f"// {max_tag}, the largest size in params.json); whether\n"
                 "// transient arrays become ports instead is open (docs/HLS_VS_FORGE.md, section 4.3).\n")
    return (
        f"// Generated by bench/gen/gen_dace.py. Do not edit.\n"
        f"// Top for case 3: same arguments as {kernel}() in src/{kernel}.h, so the testbench,\n"
        f"// the axis ports and the run-time pins are the same as in cases 1 and 2.\n{extra}"
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

    import numpy as np
    from dace.transformation.dataflow import Vectorization

    widths = params["cases"]["dace"].get("W", [1])
    sym_map = cfg.get("symbols", {})
    # Transient arrays get the largest size's extent; the sizes themselves stay symbolic.
    biggest = max(params["sizes"], key=lambda s: int(np.prod(list(s.values()))))
    max_tag = size_tag(biggest)
    symbols = spec.bind_symbols(spec.make_inputs(np.random.default_rng(0), **biggest))
    for width in widths:
        tag = f"w{width}"
        sdfg = build(spec, simplify=True)
        sdfg.name = kernel
        split_inout(sdfg, cfg.get("split_inout", {}))
        if width > 1:
            if not cfg.get("vectorize", False):
                sys.exit(f"{kernel}: dace case asks for W = {width} but params['dace']['vectorize'] is false")
            # N is a multiple of W (the kernel header and the pins keep it so), so no remainder: without
            # preamble=False and postamble=False DaCe 1.0.2 adds a step that reads past the end.
            if not sdfg.apply_transformations(Vectorization, options={"vector_len": width, "propagate_parent": True,
                                                                       "preamble": False, "postamble": False}):
                sys.exit(f"{kernel} {tag}: Vectorization did not apply")
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
                 f"// DaCe {dace.__version__}, sizes symbolic ({', '.join(sorted(sym_map)) or 'none'}), "
                 f"{'Vectorization ' + str(width) + ', ' if width > 1 else ''}FPGATransformSDFG, "
                 f"passes {cfg.get('passes', [])}, expansions {expansions or 'default'}.\n"
                 f"// DaCe's device file, unchanged below this header. Do not edit.\n\n")
        (out / f"{kernel}_0_0.cpp").write_text(stamp + code)
        (out / f"{kernel}_dace.cpp").write_text(wrapper(kernel, tparams, module_sig, module_name, sdfg, symbols,
                                                        sym_map, max_tag, cfg.get("buffer_outputs", {})))
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
