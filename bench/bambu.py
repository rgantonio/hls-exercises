#!/usr/bin/env python3
"""Builds and simulates the Bambu points: one row per (kernel, size, W). Plan: docs/BAMBU_PLAN.md.

For every kernel in bench/tier_<tier>/<kernel>/ (its params.json and src/<kernel>.cpp) and every W:

  1. build/<tier>/<kernel>/w<W>/<kernel>.cpp   a copy of the source with only #pragma lines added:
     `#pragma HLS interface port=<p> mode=axis` above `void <kernel>(` for every axis port, and
     `#pragma HLS unroll` on the line after the `LANE:` label (case `bambu`)
  2. Bambu 2024.10 in its container (bench/tools/in_bambu.sh), RTL only, at the largest size
     the point runs (the C arrays need a depth; the run's length is the loop_count pin)
  3. rtl/<tier>/<kernel>/bambu_w<W>/            the Verilog, filelist.f (# top:), sizes.txt, cmd.txt

then, on the host, for every size, two simulations of tb/<kernel>_tb.sv with that Verilog, in
build/<tier>/<kernel>/w<W>/<size>_<run>/ with the size's vectors written as .hex from data.h:
"cycles" (STALL=0, the cycle counts) and "stall" (STALL=1, random stalls and two tasks, pass/fail
only). The testbench prints one PASS/FAIL line; nothing else decides pass or fail.

The rows go to results_staging/bambu_cycles.csv (keyed tier, kernel, case, size, W, clock_ns; a
rerun replaces its rows) and results_staging/report_bambu_<tier>.md. A failure is a row with a
status and a fail_reason; the run carries on.

  python3 bench/bambu.py run [--tier done] [--kernel vecadd ...] [--w 4 8] [--size n64] [-j N]
                             [--sim-jobs M] [--sim questa|icarus] [--sim-only] [--dry-run]
  python3 bench/bambu.py report

-j sets the parallel Bambu builds (default: all CPUs; no licences); --sim-jobs the parallel
simulations (default: -j; with Questa, set it from the free licences). --sim-only skips Bambu and
simulates the Verilog already in rtl/. Standard library only, Python 3.11.
"""
from __future__ import annotations

import argparse
import csv
import datetime
import difflib
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BENCH = ROOT / "bench"
TB = ROOT / "tb"
BUILD = ROOT / "build"
RESULTS = ROOT / "results_staging"
IN_BAMBU = BENCH / "tools" / "in_bambu.sh"
BAMBU_INCLUDE = BENCH / "include" / "bambu"
IMAGE = os.environ.get("BAMBU_IMAGE", "localhost/hls-exercises-bambu:4")
CASE = "bambu"
CLOCK_NS = 10
DEVICE = "nangate45"
TIMEOUT_S = 15 * 60
CTYPES = {"int64": "int64_t", "int32": "int32_t", "int16": "int16_t", "int8": "int8_t"}

COLUMNS = ["tier", "kernel", "case", "size", "W", "clock_ns", "tool", "config", "status", "fail_reason",
           "cycles", "cycles_done", "beats", "overhead", "latency", "stall_run", "portable", "fsm_states",
           "device", "bambu_version", "rtl", "git", "date"]
KEY = ["tier", "kernel", "case", "size", "W", "clock_ns"]
CSV = RESULTS / "bambu_cycles.csv"
ARRAY = re.compile(r"static\s+const\s+data_t\s+(\w+)((?:\[\d+\])+)\s*=\s*\{(.*?)\};", re.S)
TB_LINE = re.compile(r"^(PASS|FAIL) (\S+) .*$", re.M)
ERR_LINE = re.compile(r"error|fail|fatal|cannot|invalid", re.I)
# Verilog that ties the RTL to a vendor or to SystemVerilog-only tools.
NOT_PORTABLE = [(re.compile(r"DSP48"), "DSP48 primitive"), (re.compile(r"\bxpm_\w+"), "XPM macro"),
                (re.compile(r"\b(always_ff|always_comb|logic)\b"), "SystemVerilog")]
# A memory module Bambu instantiated: filelist.f names it on a '# ram:' line (syn.py parks the point).
BAMBU_RAM = re.compile(r"^(ARRAY_1D_STD_BRAM\w*|BRAM_MEMORY\w*|TRUE_DUAL_PORT\w*)$")
INSTANCE = re.compile(r"^\s*(\w+)\s*(?:#\(|\w+\s*\()", re.M)


# ---------------------------------------------------------------- kernels and points
def load_kernels(tiers: list[str] | None, names: list[str] | None) -> list[tuple[Path, dict]]:
    out = []
    for pfile in sorted(BENCH.glob("tier_*/*/params.json")):
        params = json.loads(pfile.read_text())
        if (tiers and params["tier"] not in tiers) or (names and params["kernel"] not in names):
            continue
        out.append((pfile.parent, params))
    if names:
        missing = set(names) - {p["kernel"] for _, p in out}
        if missing:
            sys.exit(f"no bench/tier_*/<kernel>/params.json for: {', '.join(sorted(missing))}")
    return out


def size_tag(size: dict) -> str:
    """{"m": 8, "n": 16} -> "m8_n16", as the vector folders are named."""
    return "_".join(f"{k.lower()}{v}" for k, v in size.items())


def elems(size: dict) -> int:
    n = 1
    for v in size.values():
        n *= int(v)
    return n


def evaluate(exprs: dict, names: dict) -> dict:
    out: dict = {}
    for k, expr in exprs.items():
        out[k] = int(eval(str(expr), {"__builtins__": {}}, {**names, **out}))
    return out


def size_names(size: dict, w: int) -> dict:
    return {**{k.lower(): int(v) for k, v in size.items()}, "W": w}


def valid(params: dict, size: dict, w: int) -> bool:
    """As bench.py's point_valid: whole beats, plus params.json's optional "valid" rule (rowsum:
    "n % W == 0"). Such points are left out, not failed."""
    if elems(size) % w:
        return False
    return bool(evaluate({"v": params["valid"]}, size_names(size, w))["v"]) if "valid" in params else True


def vectors(kdir: Path, size: dict) -> dict[str, list[int]]:
    """The size's data.h arrays (IN_*, EXP_*), 2-D arrays flattened row-major."""
    text = (kdir / "vectors" / size_tag(size) / "data.h").read_text()
    arrays = {}
    for name, dims, body in ARRAY.findall(text):
        vals = [int(v) for v in re.findall(r"-?\d+", re.sub(r"//[^\n]*", "", body))]
        n = 1
        for d in re.findall(r"\d+", dims):
            n *= int(d)
        if len(vals) != n:
            sys.exit(f"{kdir.name}/{size_tag(size)}: {name} has {len(vals)} values for {dims}")
        arrays[name] = vals
    return arrays


def pins(kdir: Path, params: dict, size: dict, w: int) -> dict:
    """The run-time pins of one point: params.json's config (loop_count, len), then every scalar
    argument filled from a one-element IN_<name> array that is not an axis port (axpy's alpha)."""
    out = evaluate(params.get("config", {}), size_names(size, w))
    for name, vals in vectors(kdir, size).items():
        arg = name.removeprefix("IN_")
        if name.startswith("IN_") and len(vals) == 1 and arg not in params.get("axis", []):
            out[arg] = vals[0]
    return out


def build_size(params: dict, w: int) -> dict:
    """The size Bambu builds a W at: the largest valid one (so no array depth is too small)."""
    return max((s for s in params["sizes"] if valid(params, s, w)), key=elems)


# ---------------------------------------------------------------- shell helpers
def run_cmd(cmd: list[str] | str, cwd: Path, log: Path, timeout: int | None = None,
            env: dict | None = None) -> int | None:
    """The command's return code, or None when it ran past the timeout."""
    with open(log, "a") as lf:
        lf.write(f"$ {cmd if isinstance(cmd, str) else shlex.join(cmd)}\n")
        lf.flush()
        p = subprocess.Popen(cmd, cwd=cwd, stdout=lf, stderr=subprocess.STDOUT, stdin=subprocess.DEVNULL,
                             shell=isinstance(cmd, str), env=env)
        try:
            return p.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            p.kill()
            p.wait()
            return None


def error_lines(text: str, limit: int = 20) -> str:
    lines = [l.strip() for l in text.splitlines() if ERR_LINE.search(l) and not l.startswith("$ ")]
    return " | ".join(lines[:limit])[:2000]


def git_rev() -> str:
    r = subprocess.run(["git", "-C", str(ROOT), "rev-parse", "--short", "HEAD"], capture_output=True, text=True)
    dirty = subprocess.run(["git", "-C", str(ROOT), "status", "--porcelain", "--", "bench", "tb"],
                           capture_output=True, text=True).stdout.strip()
    return r.stdout.strip() + ("+dirty" if dirty else "")


# ---------------------------------------------------------------- build (Bambu, in the container)
def bdir(params: dict, w: int) -> Path:
    return BUILD / params["tier"] / params["kernel"] / f"w{w}"


def rtl_dir(params: dict, w: int) -> Path:
    return ROOT / "rtl" / params["tier"] / params["kernel"] / f"{CASE}_w{w}"


def source_copy(kdir: Path, params: dict) -> tuple[str, list[str]]:
    """The kernel's source with only #pragma lines added (the case `bambu`); asserted below."""
    k = params["kernel"]
    text = (kdir / "src" / f"{k}.cpp").read_text()
    lines, out, added = text.splitlines(keepends=True), [], []
    top_re = re.compile(rf"^void\s+{re.escape(k)}\s*\(")
    for i, ln in enumerate(lines):
        if top_re.match(ln):
            new = [f"#pragma HLS interface port={p} mode=axis\n" for p in params["axis"]]
            out += new
            added += new
        out.append(ln)
        if re.match(r"^\s*LANE:\s*$", ln):
            if i + 1 >= len(lines) or not re.match(r"^\s*for\s*\(", lines[i + 1]):
                sys.exit(f"{kdir.name}: the LANE label is not followed by its for loop")
            out.append("#pragma HLS unroll\n")
            added.append("#pragma HLS unroll\n")
    new_text = "".join(out)
    if len(added) != len(params["axis"]) + 1:
        sys.exit(f"{kdir.name}: expected one `void {k}(` and one `LANE:` label, added {added}")
    changed = [d for d in difflib.ndiff(text.splitlines(), new_text.splitlines()) if d[:2] in ("+ ", "- ")]
    assert all(d.startswith("+ #pragma ") for d in changed), changed
    return new_text, [a.rstrip("\n") for a in added]


def bambu_cmd(kdir: Path, params: dict, w: int) -> list[str]:
    k, size = params["kernel"], build_size(params, w)
    dtype = params.get("dtype", "int64")
    flags = [f"-DDATA_T={CTYPES.get(dtype, dtype)}"]
    if "acc_dtype" in params:
        flags.append(f"-DACC_T={CTYPES.get(params['acc_dtype'], params['acc_dtype'])}")
    flags += [f"-DSIZE_{d.upper()}={v}" for d, v in size.items()]
    # The lanes as BAMBU_LANES, never W: bench/include/bambu/lanes.h says why.
    flags += [f"-DBAMBU_LANES={w}", "--std=c++14", f"-I{BAMBU_INCLUDE}", f"-I{kdir.resolve() / 'src'}",
              f"-I{kdir.resolve() / 'vectors' / size_tag(size)}"]
    return [str(IN_BAMBU), "bambu", f"{k}.cpp", f"--top-fname={k}", f"--device-name={DEVICE}",
            f"--clock-period={CLOCK_NS}", "--compiler=I386_CLANG16", "--generate-interface=INFER"] + flags


def container_name(params: dict, w: int) -> str:
    return f"bambu-{params['tier']}-{params['kernel']}-w{w}-{os.getpid()}"


def verilog_files(folder: Path) -> list[Path]:
    return sorted(f for f in folder.iterdir() if f.is_file() and f.suffix in (".v", ".sv")) if folder.is_dir() else []


def top_module(files: list[Path]) -> str:
    """The module no other one instantiates: for a C++ top, Bambu's mangled name
    (e.g. _Z6vecaddPK6ac_intILi512ELb0EES2_PS0_j), which changes with W."""
    text = "\n".join(f.read_text(errors="replace") for f in files)
    mods = re.findall(r"^module\s+(\w+)", text, re.M)
    used = {m.group(1) for m in INSTANCE.finditer(text)}
    tops = [m for m in mods if m not in used]
    return tops[-1] if tops else ""


def portable(files: list[Path]) -> str:
    hits = {f"{what} in {f.name}" for f in files for pat, what in NOT_PORTABLE if pat.search(f.read_text(errors="replace"))}
    return "yes" if not hits else "no: " + "; ".join(sorted(hits))


def fail_reason_compile(log: str, w: int) -> str:
    m = re.search(r"does not exist a functional unit in the resource library: (\w+).*?prec: (\d+)", log, re.S)
    if m:
        return f"no unit for {m.group(2)}-bit {m.group(1)}"
    errs = [l.strip() for l in log.splitlines() if "error" in l.lower() and not l.startswith("$ ")]
    return errs[0][:200] if errs else "Bambu wrote no Verilog"


def build_point(kdir: Path, params: dict, w: int, dry: bool) -> dict:
    k, b = params["kernel"], bdir(params, w)
    text, added = source_copy(kdir, params)
    cmd = bambu_cmd(kdir, params, w)
    if dry:
        print(f"\n# {k} W={w}: {b.relative_to(ROOT)}, built at {size_tag(build_size(params, w))}")
        print(f"# {k}.cpp = {kdir.relative_to(ROOT)}/src/{k}.cpp with: " + "; ".join(added))
        print(f"cd {b} && BAMBU_CONTAINER_NAME={container_name(params, w)} {shlex.join(cmd)}  # timeout {TIMEOUT_S} s")
        return {"status": "dry"}
    if b.exists():
        shutil.rmtree(b)
    b.mkdir(parents=True)
    (b / f"{k}.cpp").write_text(text)
    log = b / "bambu.log"
    cname = container_name(params, w)
    rc = run_cmd(cmd, b, log, TIMEOUT_S, dict(os.environ, BAMBU_CONTAINER_NAME=cname))
    out = log.read_text(errors="replace")
    meta = {"fsm_states": " ".join(re.findall(r"Number of states:\s*(\d+)", out))}
    m = re.search(r"Version: (PandA \S+) - Revision (\w+)", out)
    meta["bambu_version"] = f"{m.group(1)} rev {m.group(2)[:8]}" if m else ""
    if rc is None:
        subprocess.run(["podman", "rm", "-f", "-t", "0", cname], capture_output=True, check=False)
        return {"status": "failed: timeout", "fail_reason": f"no Verilog within {TIMEOUT_S // 60} min", **meta}
    files = verilog_files(b)
    if rc != 0 or not files:
        return {"status": "failed: compile", "fail_reason": fail_reason_compile(out, w), **meta}
    lines = [f"# Bambu {meta['bambu_version']}; FSM states: {meta['fsm_states']}",
             f"# built at {size_tag(build_size(params, w))}; {k}.cpp is {kdir.relative_to(ROOT)}/src/{k}.cpp with:"]
    lines += [f"#   {a}" for a in added]
    lines.append(shlex.join(["bench/tools/in_bambu.sh"] + cmd[1:]).replace(str(ROOT) + "/", ""))
    (b / "cmd.txt").write_text("\n".join(lines) + "\n")
    return {"status": "ok", **meta}


def place_rtl(params: dict, w: int) -> str:
    """rtl/<tier>/<kernel>/bambu_w<W>/: one folder per W serves every size (the size is the
    loop_count pin)."""
    b, dst = bdir(params, w), rtl_dir(params, w)
    files = verilog_files(b)
    if dst.exists():
        shutil.rmtree(dst)
    dst.mkdir(parents=True)
    for f in files:
        shutil.copy(f, dst / f.name)
    shutil.copy(b / "cmd.txt", dst / "cmd.txt")
    placed = verilog_files(dst)
    text = "\n".join(f.read_text(errors="replace") for f in placed)
    rams = sorted({m.group(1) for m in INSTANCE.finditer(text) if BAMBU_RAM.match(m.group(1))})
    (dst / "filelist.f").write_text(
        "# Generated by bench/bambu.py: one Bambu point's Verilog for synthesis (syn/syn.py).\n"
        "# Paths are relative to this folder. A '# ram:' line names a memory module Bambu instantiated.\n"
        f"# top: {top_module(placed)}\n" + "".join(f"# ram: {r}\n" for r in rams)
        + "".join(f.name + "\n" for f in placed))
    sizes = [size_tag(s) for s in params["sizes"] if valid(params, s, w)]
    (dst / "sizes.txt").write_text("".join(s + "\n" for s in sizes))
    return str(dst.relative_to(ROOT))


def read_rtl(params: dict, w: int) -> dict:
    """What a --sim-only run knows of a point: its folder, top, portability and cmd.txt's header."""
    dst = rtl_dir(params, w)
    files = verilog_files(dst)
    if not files:
        return {"status": "failed: compile", "fail_reason": f"no Verilog in {dst.relative_to(ROOT)}"}
    out = {"status": "ok", "rtl": str(dst.relative_to(ROOT)), "portable": portable(files)}
    cmdtxt = (dst / "cmd.txt").read_text() if (dst / "cmd.txt").is_file() else ""
    m = re.search(r"^# Bambu (.*?); FSM states: (.*)$", cmdtxt, re.M)
    if m:
        out.update(bambu_version=m.group(1), fsm_states=m.group(2))
    return out


# ---------------------------------------------------------------- simulation (host)
def sim_defines(kdir: Path, params: dict, w: int, size: dict, stall: int) -> dict:
    arrays = vectors(kdir, size)
    n = elems(size)
    nout = next(len(v) for name, v in arrays.items() if name.startswith("EXP_"))
    d = {"W": w, "N": n, "NOUT": nout, "STALL": stall, "MAXCYC": 50 * (n + nout) + 1000}
    d.update({k.upper(): v for k, v in pins(kdir, params, size, w).items()})
    return d


def sim_cmd(params: dict, w: int, defines: dict, sim: str) -> str:
    dst = rtl_dir(params, w)
    files = [str(f) for f in verilog_files(dst)] or [f"{dst}/*.v"]  # placeholder before a build
    top = top_module(verilog_files(dst)) or "<top from filelist.f>"
    tbfile = TB / f"{params['kernel']}_tb.sv"
    defs = {"DUT": top, **defines}
    if sim == "questa":
        dflags = " ".join(f"+define+{n}={v}" for n, v in defs.items())
        # vsim -c starts every transcript line with "# "; strip it so the testbench's lines parse.
        return (f"rm -rf work && vlib work > /dev/null && "
                f"vlog -sv -quiet {dflags} +incdir+{TB} {tbfile} {' '.join(files)} && "
                f"vsim -c -quiet tb -do 'run -all; quit -f' | sed 's/^# //'")
    dflags = " ".join(f"-D{n}={v}" for n, v in defs.items())
    return f"iverilog -g2012 -I {TB} {dflags} -o sim.vvp {tbfile} {' '.join(files)} && vvp -n sim.vvp"


def sim_point(kdir: Path, params: dict, w: int, size: dict, stall: int, sim: str, dry: bool) -> dict:
    s = bdir(params, w) / f"{size_tag(size)}_{'stall' if stall else 'cycles'}"
    defines = sim_defines(kdir, params, w, size, stall)
    cmd = sim_cmd(params, w, defines, sim)
    if dry:
        print(f"cd {s.relative_to(ROOT)} && {cmd}")
        return {}
    if s.exists():
        shutil.rmtree(s)
    s.mkdir(parents=True)
    for name, vals in vectors(kdir, size).items():
        (s / f"{name}.hex").write_text("".join(format(v & (2**64 - 1), "016x") + "\n" for v in vals))
    (s / "sim.sh").write_text(f"#!/usr/bin/env bash\n# {sim}\n{cmd}\n")
    log = s / "sim.log"
    run_cmd(cmd, s, log)
    text = log.read_text(errors="replace")
    line = next((l for l in text.splitlines() if TB_LINE.match(l)), "")
    if not line:
        return {"result": "FAIL", "line": "no PASS/FAIL line: " + error_lines(text)}
    out = {"result": line.split()[0], "line": line}
    for f in ("cycles", "cycles_done", "latency"):
        v = re.search(rf"\b{f}=(-?\d+)", line)
        if v:
            out[f] = int(v.group(1))
    if out["result"] == "FAIL":
        mism = [l.strip() for l in text.splitlines() if re.match(r"\s+\w+\[\d+\]: got", l)]
        out["line"] = " | ".join([line] + mism[:3])
    return out


# ---------------------------------------------------------------- rows and reports
def make_row(kdir: Path, params: dict, w: int, size: dict, build: dict, cyc: dict, stl: dict, meta: dict) -> dict:
    p = pins(kdir, params, size, w)
    row = {"tier": params["tier"], "kernel": params["kernel"], "case": CASE, "size": size_tag(size), "W": w,
           "clock_ns": CLOCK_NS, "tool": "bambu", "config": " ".join(f"{n}={v}" for n, v in p.items()),
           "beats": elems(size) // w, "device": DEVICE, **meta}
    row.update({k: build.get(k, "") for k in ("fsm_states", "bambu_version", "portable", "rtl")})
    if build["status"] != "ok":
        row.update(status=build["status"], fail_reason=build.get("fail_reason", ""))
        return row
    row["stall_run"] = stl.get("result", "")
    if cyc.get("result") == "PASS":
        row.update(cycles=cyc["cycles"], cycles_done=cyc.get("cycles_done", ""), latency=cyc.get("latency", ""),
                   overhead=cyc["cycles"] - row["beats"])
        row["status"] = "ok" if stl.get("result") == "PASS" else "failed: stall"
        if row["status"] != "ok":
            row["fail_reason"] = stl.get("line", "")
    else:
        row.update(status="failed: sim", fail_reason=cyc.get("line", ""))
    return row


def read_csv(path: Path) -> list[dict]:
    if not path.exists():
        return []
    with open(path, newline="") as f:
        return list(csv.DictReader(f))


def sort_key(r: dict) -> tuple:
    order = {"done": 0, "untiered": 1}
    return (order.get(r["tier"], 9), r["tier"], r["kernel"], r["case"],
            [int(x) for x in re.findall(r"\d+", r["size"])], int(r["W"]))


def write_csv(rows: list[dict]) -> None:
    new_keys = {tuple(str(r[k]) for k in KEY) for r in rows}
    keep = [r for r in read_csv(CSV) if tuple(str(r[k]) for k in KEY) not in new_keys]
    allrows = sorted(keep + [{c: r.get(c, "") for c in COLUMNS} for r in rows], key=sort_key)
    CSV.parent.mkdir(parents=True, exist_ok=True)
    with open(CSV, "w", newline="") as f:
        wr = csv.DictWriter(f, fieldnames=COLUMNS)
        wr.writeheader()
        wr.writerows(allrows)


def write_reports() -> list[Path]:
    rows = read_csv(CSV)
    out = []
    for tier in sorted({r["tier"] for r in rows}, key=lambda t: {"done": 0, "untiered": 1}.get(t, 9)):
        trows = [r for r in rows if r["tier"] == tier]
        lines = [f"# Bambu, tier {tier}", "",
                 f"Written by `bench/bambu.py` from `results_staging/bambu_cycles.csv`. Case `{CASE}`: Bambu's default "
                 f"setup plus `#pragma HLS unroll` on LANE, `--device-name={DEVICE}`, {CLOCK_NS} ns. Cycles from the "
                 "start pulse to the last output beat (or result), every stream without stalls; cycles per beat in "
                 "brackets. `cycles_done` (start to `done_port`) is in the second table. A failed point shows its status.",
                 ""]
        for k in sorted({r["kernel"] for r in trows}):
            krows = [r for r in trows if r["kernel"] == k]
            ws = sorted({int(r["W"]) for r in krows})
            sizes = sorted({r["size"] for r in krows}, key=lambda s: [int(x) for x in re.findall(r"\d+", s)])
            lines += [f"## {k}", "", "| size | " + " | ".join(f"W = {w}" for w in ws) + " |", "|---" * (len(ws) + 1) + "|"]
            for s in sizes:
                cells = []
                for w in ws:
                    r = next((r for r in krows if r["size"] == s and int(r["W"]) == w), None)
                    if r is None:
                        cells.append("")
                    elif r["status"] != "ok":
                        cells.append(r["status"])
                    else:
                        cells.append(f"{r['cycles']} ({int(r['cycles']) / int(r['beats']):.2f})")
                lines.append(f"| {s} | " + " | ".join(cells) + " |")
            lines += ["", f"| W | FSM states | cycles_done ({' / '.join(sizes)}) | latency ({' / '.join(sizes)}) | portable |",
                      "|---|---|---|---|---|"]
            for w in ws:
                r = next((r for r in krows if int(r["W"]) == w), None)
                if r is None:
                    continue
                pick = lambda f: " / ".join(next((x[f] or "-" for x in krows if x["size"] == s and int(x["W"]) == w), "-")
                                            for s in sizes)
                lines.append(f"| {w} | {r['fsm_states'] or '-'} | {pick('cycles_done')} | {pick('latency')} | {r['portable'] or '-'} |")
            lines.append("")
        p = RESULTS / f"report_bambu_{tier}.md"
        p.write_text("\n".join(lines))
        out.append(p)
    return out


# ---------------------------------------------------------------- main
def cmd_run(args) -> None:
    points = []  # (kdir, params, w, [sizes])
    for kdir, params in load_kernels(args.tier, args.kernel):
        for w in params["W"]:
            if args.w and w not in args.w:
                continue
            sizes = [s for s in params["sizes"] if valid(params, s, w) and (not args.size or size_tag(s) in args.size)]
            if sizes:
                points.append((kdir, params, w, sizes))
    if not points:
        sys.exit("no points match")
    if args.dry_run:
        for kdir, params, w, sizes in points:
            if not args.sim_only:
                build_point(kdir, params, w, True)
            for s in sizes:
                for stall in (0, 1):
                    sim_point(kdir, params, w, s, stall, args.sim, True)
        return
    if not args.sim_only:
        if not (ROOT / "tools" / "bin" / "bambu").is_file():
            sys.exit("tools/bin/bambu not found: run `pixi run get-bambu`")
        if subprocess.run(["podman", "image", "exists", IMAGE]).returncode != 0:
            sys.exit(f"podman image {IMAGE} not found: build it from container/bambu/ (README.md)")
    meta = {"git": git_rev(), "date": datetime.date.today().isoformat()}

    if args.sim_only:
        builds = [read_rtl(p[1], p[2]) for p in points]
    else:
        with ThreadPoolExecutor(args.jobs) as ex:
            builds = list(ex.map(lambda p: build_point(p[0], p[1], p[2], False), points))
        for (kdir, params, w, sizes), b in zip(points, builds):
            if b["status"] == "ok":
                b["rtl"] = place_rtl(params, w)
                b["portable"] = portable(verilog_files(rtl_dir(params, w)))
    for (kdir, params, w, sizes), b in zip(points, builds):
        print(f"build {params['kernel']} W={w}: {b['status']}"
              + (f" (FSM states {b.get('fsm_states') or '-'})" if b["status"] == "ok" else f": {b.get('fail_reason', '')[:200]}"),
              flush=True)

    sims = [(kdir, params, w, s, stall) for (kdir, params, w, sizes), b in zip(points, builds) if b["status"] == "ok"
            for s in sizes for stall in (0, 1)]
    with ThreadPoolExecutor(args.sim_jobs or args.jobs) as ex:
        results = list(ex.map(lambda p: sim_point(*p, args.sim, False), sims))
    res = {(p[1]["kernel"], p[2], size_tag(p[3]), p[4]): r for p, r in zip(sims, results)}

    rows = []
    for (kdir, params, w, sizes), b in zip(points, builds):
        for s in sizes:
            key = (params["kernel"], w, size_tag(s))
            row = make_row(kdir, params, w, s, b, res.get(key + (0,), {}), res.get(key + (1,), {}), meta)
            rows.append(row)
            print(f"{row['kernel']} {row['size']} W={w}: {row['status']}"
                  + (f", cycles {row['cycles']}, cycles_done {row['cycles_done']}, latency {row['latency']}"
                     if row["status"] == "ok" else f": {row.get('fail_reason', '')[:300]}"), flush=True)
    write_csv(rows)
    for p in write_reports():
        print(f"wrote {p.relative_to(ROOT)}")
    print(f"wrote {CSV.relative_to(ROOT)}: {sum(r['status'] == 'ok' for r in rows)} of {len(rows)} points ok")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    r = sub.add_parser("run", help="build, simulate and record")
    r.add_argument("--tier", nargs="+", help="done, untiered")
    r.add_argument("--kernel", nargs="+")
    r.add_argument("--w", nargs="+", type=int)
    r.add_argument("--size", nargs="+", help="size tags, e.g. n64")
    r.add_argument("-j", "--jobs", type=int, default=os.cpu_count() or 1)
    r.add_argument("--sim-jobs", type=int, default=0, help="parallel simulations (default: -j)")
    r.add_argument("--sim", choices=["questa", "icarus"], default="questa")
    r.add_argument("--sim-only", action="store_true", help="simulate the Verilog already in rtl/")
    r.add_argument("--dry-run", action="store_true", help="print the commands only")
    sub.add_parser("report", help="rewrite results_staging/report_bambu_<tier>.md from the CSV")
    args = ap.parse_args()
    if args.cmd == "run":
        cmd_run(args)
    else:
        for p in write_reports():
            print(f"wrote {p.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
