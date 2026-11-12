"""C-simulate DaCe's generated device code with g++ (hlslib's simulation mode, no HLSLIB_SYNTHESIS): call each
module function in out/dev/ on random int64 data (N = 2048; rowsum 16 x 128) and compare with NumPy. Not Vitis:
it checks the C++ computes the right result, not cycles or area."""
import os
import re
import subprocess
import tempfile
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
DEV = HERE / "out" / "dev"
# DaCe's runtime and hlslib as gen_dace.py copies them, and Xilinx's ap_int headers: Vitis's own
# ($XILINX_HLS/include) or the open github.com/Xilinx/HLS_arbitrary_Precision_Types (AP_INCLUDE).
AP = os.environ.get("AP_INCLUDE") or os.path.join(os.environ.get("XILINX_HLS", ""), "include")
INC = [f"-I{HERE.parents[0] / 'gen' / 'dace_include'}", f"-I{AP}"]
TMP = Path(tempfile.mkdtemp(prefix="dace_csim_"))
N, W, ALPHA = 2048, 4, 3
rng = np.random.default_rng(0)
A = rng.integers(-1000, 1000, N)
B = rng.integers(-1000, 1000, N)


def arr(name, vals):
    return f"static int64_t {name}[{len(vals)}] = {{{', '.join(map(str, vals))}}};"


def call(sig: str) -> tuple[str, str, str]:
    """Decls, the call and what to print, from the module's argument list (by argument name)."""
    fn, args = re.match(r"void (module_\w+)\((.*)\)", sig).groups()
    decls, actual = [arr("A_", A), arr("B_", B), f"static int64_t T_[{N}]; static int64_t O_[{N}];"], []
    vec = "dace::vec" in args
    for a in [x.strip() for x in re.split(r",(?![^<]*>)", args)]:
        name = a.split()[-1].lstrip("*&")
        typ = a.rsplit(name, 1)[0].strip()
        cast = f"({typ})"
        if name in ("N", "n"):
            actual.append("128" if "int M" in args else str(N))
        elif name == "M":
            actual.append("16")
        elif name == "alpha":
            actual.append(str(ALPHA))
        elif name == "__tmp1":
            actual.append("0")
        elif name in ("fpga_A", "fpga_x"):
            actual.append(f"{cast}A_")
        elif name == "fpga_y" and "int M" in args:
            actual.append(f"{cast}O_")
        elif name in ("fpga_B", "fpga_y") and "y_out" not in args:
            actual.append(f"{cast}B_")
        elif name == "fpga_y":
            actual.append(f"{cast}B_")
        elif name == "__tmp0":
            actual.append(f"{cast}T_")
        else:  # outputs: fpga_out, fpga_C, fpga_y_out, fpga_B of relu
            actual.append(f"{cast}O_")
    return "\n".join(decls), f"{fn}({', '.join(actual)});", vec


def expected(stem: str):
    if stem.startswith("dot"):
        return int(A @ B), "O_[0]"
    if stem.startswith("vsum"):
        return int(A.sum()), "O_[0]"
    if stem.startswith("axpy") and "w4" in stem:
        return int((ALPHA * A + B).sum()), "sum(O_)"
    if stem.startswith("axpy"):
        return int((ALPHA * A + B).sum()), "sum(B_)"  # y in place
    if stem.startswith("vecadd"):
        return int((A + B).sum()), "sum(O_)"
    if stem.startswith("rowsum"):
        return int(A.reshape(16, -1).sum(1).sum()), "sum16(O_)"
    return None, None


for f in sorted(DEV.glob("*.cpp")):
    text = f.read_text()
    sig = re.search(r"^void module_\w+\([^)]*\)", text, re.M).group(0)
    want, what = expected(f.stem)
    if want is None:
        continue
    decls, the_call, _ = call(sig)
    pr = {"O_[0]": "O_[0]", "sum(O_)": "s(O_, 2048)", "sum(B_)": "s(B_, 2048)", "sum16(O_)": "s(O_, 16)"}[what]
    main = (f"#include \"{f}\"\n#include <cstdio>\n{decls}\n"
            "static long long s(int64_t *p, int n) { long long t = 0; for (int i = 0; i < n; ++i) t += p[i]; return t; }\n"
            f"int main() {{ {the_call} std::printf(\"%lld\\n\", (long long){pr}); return 0; }}\n")
    src = TMP / f"csim_{f.stem}.cpp"
    src.write_text(main)
    exe = str(TMP / f"csim_{f.stem}")
    r = subprocess.run(["g++", "-std=c++14", "-O1", *INC, "-DDACE_XILINX", "-DDACE_XILINX_DEVICE_CODE", str(src),
                        "-o", exe], capture_output=True, text=True)
    if r.returncode:
        err = [line for line in r.stderr.splitlines() if "error" in line][:1]
        print(f"{f.stem:28s} compile error: {err[0][:160] if err else r.stderr[:160]}")
        continue
    r = subprocess.run([exe], capture_output=True, text=True, timeout=60)
    got = r.stdout.strip() or r.stderr.strip()[:80] or f"exit {r.returncode}"
    ok = got == str(want)
    print(f"{f.stem:28s} {sig.split('(')[0][5:]:22s} got {got:>12s} want {want:>12d} {'PASS' if ok else 'FAIL'}")
