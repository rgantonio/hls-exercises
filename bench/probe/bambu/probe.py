"""bench/probe/bambu/probe.py: what Bambu 2024.10 generates for vecadd at n64 (BAM1 R0).

Runs Bambu in the container (bench/tools/in_bambu.sh), each run in its own folder
bench/probe/bambu/runs/<id>/ with a generated copy of vecadd.cpp in which only pragma lines
are added (vecadd.cpp.diff records the diff against the original). Co-simulation with
Verilator, testbench bench/tier_done/vecadd/src/tb_vecadd.cpp (every output checked
against EXP_C). Writes notes/bambu_probe.csv.

    pixi run probe-bambu [--only <id-prefix>] [-j N]
    pixi run probe-bambu --keep-rtl <id> [<id> ...]   # copy runs' Verilog to notes/bambu_rtl/

Groups (n64 only):
  A  W {1, 8} x setup {default, BAMBU-AREA, BAMBU-PERFORMANCE} x pragmas {none, unroll,
     unroll+pipeline}; Bambu's default ports.
  B  W {1, 8} x -O {-O0, -O3}; default setup, no pragmas, default ports.
  C  W {1, 8} x pragmas {none, unroll+pipeline} x port mode {fifo, axis};
     --generate-interface=INFER and an interface pragma on A, B and C.
  D  (R0b, streams) W {1, 8, 32} x setup {default, BAMBU-AREA} x port mode {fifo, axis} x
     loop_count {no pragma, mode=ap_vld}; --generate-interface=INFER, an interface pragma on
     A, B and C, no unroll or pipeline pragmas, header include_stream/lanes.h.
  E  (R0c, beat-wide ports) as D with header include_wide/lanes.h (vec_t one ac_int<64W>)
     and loop_count {no pragma, mode=ap_hs, mode=ap_ack}; the lane count is passed as
     -DBAMBU_LANES=<W>, not -DW (include_wide/lanes.h says why). Plus two runs at W = 32,
     default setup, no loop_count pragma, `#pragma HLS unroll` on LANE, fifo and axis.
A, B and C use include/lanes.h (R0). A run with --only replaces its rows in the CSV and keeps
the others.
"""

from __future__ import annotations

import argparse
import csv
import difflib
import os
import re
import shlex
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

PROBE = Path(__file__).resolve().parent
REPO = PROBE.parents[2]
BENCH = REPO / "bench"
KDIR = BENCH / "tier_done" / "vecadd"
RUNS = PROBE / "runs"
IN_BAMBU = BENCH / "tools" / "in_bambu.sh"
CSV_OUT = REPO / "notes" / "bambu_probe.csv"
RTL_OUT = REPO / "notes" / "bambu_rtl"

N = 64
TIMEOUT_S = 600
COMPILER = "I386_CLANG16"
DEFAULT_SETUP = "BAMBU-BALANCED-MP"  # Bambu's default --experimental-setup (--help)

COLUMNS = [
    "id", "group", "W", "setup", "opt_level", "pragmas", "ports", "simulator", "lanes_header",
    "status", "cycles", "cycles_per_beat", "adders", "adder_widths", "beat_pipelined", "II",
    "fsm_states", "top_ports", "memory_modules", "loop_count_sinks", "runtime_s", "warnings",
    "message", "bambu_cmd", "loop_count_registered", "port_width",
]

# --------------------------------------------------------------- pragma variants
SRC = (KDIR / "src" / "vecadd.cpp").read_text()
LANE_FOR = "    LANE:\n        for (int l = 0; l < W; l++) {\n"
BEAT_FOR = "BEAT:\n    for (cfg_t b = 0; b < beats; b++) {\n"
TOP_DEF = "void vecadd(const vec_t A[NB]"
# Clang's loop hints (Bambu maps `#pragma HLS unroll` onto them) must come right before the
# loop: inside the body clang stops with "expected a for, while, or do-while loop to follow
# '#pragma unroll'". The pipeline pragma goes first in BEAT's body, as Vitis takes it.
# Interface pragmas go before the function, as in Bambu's own tests
# (panda_regressions/hls/bambu_interface_test/simple_c4_fifo.c).
UNROLL = (LANE_FOR, "    LANE:\n#pragma HLS unroll\n        for (int l = 0; l < W; l++) {\n")
PIPELINE = (BEAT_FOR, BEAT_FOR + "#pragma HLS pipeline II=1\n")


def interface(mode: str, lc: str = "none") -> tuple[str, str]:
    lines = [f"#pragma HLS interface port={p} mode={mode}\n" for p in "ABC"]
    if lc != "none":
        lines.append(f"#pragma HLS interface port=loop_count mode={lc}\n")
    return (TOP_DEF, "".join(lines) + TOP_DEF)


PRAGMAS = {"none": [], "unroll": [UNROLL], "unroll+pipeline": [UNROLL, PIPELINE]}


def variant(edits: list[tuple[str, str]]) -> str:
    s = SRC
    for old, new in edits:
        assert s.count(old) == 1, old
        s = s.replace(old, new)
    added = [ln for ln in difflib.ndiff(SRC.splitlines(), s.splitlines()) if ln.startswith(("+ ", "- "))]
    assert all(ln.startswith("+ #pragma ") for ln in added), added  # only pragma lines added
    return s


# --------------------------------------------------------------- the runs
def runs() -> list[dict]:
    out = []
    for w in (1, 8):
        for setup in ("default", "BAMBU-AREA", "BAMBU-PERFORMANCE"):
            for prag in PRAGMAS:
                tag = {"default": "def", "BAMBU-AREA": "area", "BAMBU-PERFORMANCE": "perf"}[setup]
                out.append(dict(id=f"A_w{w}_{tag}_{prag.replace('+', '_')}", group="A", W=w, setup=setup,
                                opt=None, pragmas=prag, ports="default"))
    for w in (1, 8):
        for opt in ("-O0", "-O3"):
            out.append(dict(id=f"B_w{w}_{opt[1:]}", group="B", W=w, setup="default", opt=opt,
                            pragmas="none", ports="default"))
    for w in (1, 8):
        for prag in ("none", "unroll+pipeline"):
            for mode in ("fifo", "axis"):
                out.append(dict(id=f"C_w{w}_{mode}_{prag.replace('+', '_')}", group="C", W=w,
                                setup="default", opt=None, pragmas=prag, ports=mode))
    for w in (1, 8, 32):
        for setup in ("default", "BAMBU-AREA"):
            for mode in ("fifo", "axis"):
                for lc in ("none", "ap_vld"):
                    tag = {"default": "def", "BAMBU-AREA": "area"}[setup]
                    out.append(dict(id=f"D_w{w}_{tag}_{mode}_lc{'vld' if lc == 'ap_vld' else 'none'}",
                                    group="D", W=w, setup=setup, opt=None, pragmas="none", ports=mode,
                                    lc=lc, header="include_stream"))
    for w in (1, 8, 32):
        for setup in ("default", "BAMBU-AREA"):
            for mode in ("fifo", "axis"):
                for lc in ("none", "ap_hs", "ap_ack"):
                    tag = {"default": "def", "BAMBU-AREA": "area"}[setup]
                    out.append(dict(id=f"E_w{w}_{tag}_{mode}_lc{lc.replace('ap_', '')}", group="E", W=w,
                                    setup=setup, opt=None, pragmas="none", ports=mode, lc=lc,
                                    header="include_wide"))
    for mode in ("fifo", "axis"):
        out.append(dict(id=f"E_w32_def_{mode}_lcnone_unroll", group="E", W=32, setup="default", opt=None,
                        pragmas="unroll", ports=mode, lc="none", header="include_wide"))
    return out


def bambu_args(r: dict, src: Path) -> list[str]:
    w = r["W"]
    args = [
        "bambu", str(src), "--top-fname=vecadd", "--device-name=nangate45", "--clock-period=10",
        f"--compiler={COMPILER}", "--simulate", "--simulator=VERILATOR",
        f"--generate-tb={KDIR / 'src' / 'tb_vecadd.cpp'}",
        f"--tb-extra-gcc-options=-DDUT=vecadd -DCFG_LOOP_COUNT={N // w}",
        # Bambu cannot size statically allocated arrays: without this the co-simulation maps
        # 4 bytes per array and its driver segfaults (BAM1 R0 step 2).
        f"--tb-param-size=A:{N * 8},B:{N * 8},C:{N * 8}",
    ]
    if r["setup"] != "default":
        args.append(f"--experimental-setup={r['setup']}")
    if r["opt"]:
        args.append(r["opt"])
    if r["ports"] != "default":
        args.append("--generate-interface=INFER")
    # bench.py's flags for vecadd at n64 (point_env, params.json), DaCe-only flags dropped;
    # Bambu spells -std as --std. The probe header comes first on the include path.
    args += [
        "-DDATA_T=int64_t", f"-DSIZE_N={N}",
        # include_wide/lanes.h takes the lanes as BAMBU_LANES and defines W itself: Bambu's
        # co-simulation files include ac_int.h directly with these -D flags (R0c).
        f"-DBAMBU_LANES={w}" if r.get("header") == "include_wide" else f"-DW={w}",
        f"-I{PROBE / r.get('header', 'include')}", f"-I{KDIR / 'src'}", f"-I{KDIR / 'vectors' / 'n64'}",
        "--std=c++14", "-DHLSLIB_SYNTHESIS", "-DAP_INT_MAX_W=4096",
        f"-I{BENCH / 'include'}", f"-I{BENCH / 'gen' / 'dace_include'}",
    ]
    return args


# --------------------------------------------------------------- parsing
def verilog_modules(text: str) -> dict[str, str]:
    """module name -> its text up to endmodule."""
    return {m.group(1): m.group(0) for m in re.finditer(r"^module\s+(\w+)\s*\(.*?^endmodule", text, re.S | re.M)}


def instances(body: str, name: str) -> list[str]:
    """Parameter lists of each instance of module `name` in `body` ('' if none given)."""
    pat = re.compile(rf"^\s*{re.escape(name)}\s*(?:#\(((?:[^()]|\([^()]*\))*)\))?\s*\w+\s*\(", re.M)
    return [m.group(1) or "" for m in pat.finditer(body)]


def analyse_verilog(path: Path) -> dict:
    text = path.read_text(errors="replace")
    mods = verilog_modules(text)
    inst = {n: [] for n in mods}
    for owner, body in mods.items():
        for n in mods:
            if n != owner:
                inst[n] += instances(body, n)
    tops = [n for n in mods if not inst[n]]
    top = tops[-1] if tops else ""
    ports = []
    if top:
        m = re.search(rf"^module\s+{re.escape(top)}\s*\((.*?)\);", text, re.S | re.M)
        ports = [p.strip() for p in m.group(1).split(",")] if m else []
    adders = [n for n in mods if "plus_expr" in n and "pointer" not in n]
    widths: dict[str, int] = {}
    for n in adders:
        for params in inst[n]:
            mw = re.search(r"BITSIZE_out1\((\d+)\)", params)
            key = f"{n}:{mw.group(1) if mw else '?'}"
            widths[key] = widths.get(key, 0) + 1
    # Memories only: the interface managers of fifo ports (*_ParmMgr_*_fifo_modgen) are not.
    mem = {n: len(inst[n]) for n in mods
           if re.search(r"(?i)(bram|memory|ram|rom|fifo|array)", n) and "ParmMgr" not in n and inst[n]}
    # What the top's loop_count port feeds inside the datapath (one level).
    sinks: dict[str, int] = {}
    for body in mods.values():
        for m in re.finditer(r"^\s*(\w+)\s*(?:#\((?:[^()]|\([^()]*\))*\))?\s*\w+\s*\(((?:[^;])*?)\);", body, re.S | re.M):
            if re.search(r"\.\w+\(in_port_loop_count\)", m.group(2)):
                sinks[m.group(1)] = sinks.get(m.group(1), 0) + 1
    return {
        "adders": sum(widths.values()),
        "adder_widths": "; ".join(f"{k} x{v}" for k, v in sorted(widths.items())),
        "top_ports": " ".join(ports),
        # Bit width of A's data port on the top (A_dout for fifo, A_TDATA for axis).
        "port_width": next((str(int(m.group(1)) + 1) for m in re.finditer(
            r"^\s*input\s*\[(\d+):0\]\s*A_(?:dout|TDATA)\s*;", mods.get(top, ""), re.M)), ""),
        "memory_modules": "; ".join(f"{k} x{v}" for k, v in sorted(mem.items())) or "none",
        "loop_count_sinks": "; ".join(f"{k} x{v}" for k, v in sorted(sinks.items())),
        # yes when a register takes the datapath's loop_count port as an input (one level, as
        # loop_count_sinks); no when only combinational units do.
        "loop_count_registered": ("yes" if any(re.match(r"(?i)(register|flipflop)", k) for k in sinks) else "no")
                                 if sinks else "",
    }


def first_errors(log: str, n: int = 3) -> str:
    lines = [ln.strip() for ln in log.splitlines() if re.search(r"(?i)\berror\b", ln)]
    lines = [ln for ln in lines if ln not in ("Error in compilation",)]
    lines = [ln.replace(str(REPO) + "/", "") for ln in lines]
    return " | ".join(dict.fromkeys(lines))[:600] if lines else ""


def parse(r: dict, rdir: Path, rc: int | None, timed_out: bool) -> dict:
    log = (rdir / "bambu.log").read_text(errors="replace") if (rdir / "bambu.log").is_file() else ""
    tblog = rdir / "HLS_output" / "simulation" / "testbench.log"
    tb = tblog.read_text(errors="replace") if tblog.is_file() else ""
    sim_started = bool(list(rdir.glob("simulate_*.sh")))
    verdict = re.search(r"^(PASS|FAIL) vecadd .*$", tb, re.M)
    if timed_out:
        status = "timeout"
    elif not sim_started:
        status = "fail: compile"
    elif verdict and verdict.group(1) == "FAIL":
        status = "mismatch"
    elif verdict and verdict.group(1) == "PASS" and rc == 0 and "Returned error code" not in log:
        status = "pass"
    else:
        status = "fail: sim"
    out = {k: "" for k in COLUMNS}
    m = re.search(r"Total cycles\s*:\s*(\d+) cycles", log)
    if m:
        out["cycles"] = int(m.group(1))
        out["cycles_per_beat"] = round(int(m.group(1)) / (N // r["W"]), 3)
    states = re.findall(r"Number of states:\s*(\d+)", log)
    out["fsm_states"] = " ".join(states)
    # Bambu pipelines functions only (--pipelining); its log reports no loop pipelining.
    pipe = [ln.strip() for ln in log.splitlines()
            if re.search(r"(?i)pipelin", ln) and "#pragma" not in ln and not re.search(r"(?i)\berror\b", ln)]
    if sim_started:
        out["beat_pipelined"] = "; ".join(pipe) if pipe else "no (none reported)"
    out["II"] = ""
    sim_sh = next(iter(rdir.glob("simulate_*.sh")), None)
    if sim_sh:
        mo = re.search(r'CFLAGS=" (-O\w+)', sim_sh.read_text(errors="replace"))
        out["opt_level"] = mo.group(1) if mo else ""
    else:
        out["opt_level"] = r["opt"] or ""
    vfile = rdir / "vecadd.v"
    if vfile.is_file():
        out.update(analyse_verilog(vfile))
    warns = [ln.strip() for ln in log.splitlines() if ln.strip().startswith("Warning:")]
    out["warnings"] = " | ".join(dict.fromkeys(warns))
    msg = first_errors(log)
    if status != "pass" and verdict:
        msg = (msg + " | " if msg else "") + verdict.group(0)
    if timed_out:
        msg = f"killed after {TIMEOUT_S} s"
    out["message"] = msg
    out["status"] = status
    return out


def cmd_text(rdir: Path, cmd: list[str]) -> str:
    return (f"# Run from {rdir}; its vecadd.cpp is written by bench/probe/bambu/probe.py\n"
            f"# (pixi run probe-bambu --only {rdir.name}).\ncd {shlex.quote(str(rdir))}\n{shlex.join(cmd)}\n")


def keep_rtl(run_id: str) -> None:
    """Copy one run's Verilog (no simulation files) to notes/bambu_rtl/<id>/ with a filelist.f
    in the form of rtl/ and cmd.txt holding the exact Bambu command."""
    r = next(x for x in runs() if x["id"] == run_id)
    rdir = RUNS / run_id
    vfiles = sorted(f for f in rdir.glob("*.v"))  # Bambu writes every module into <src>.v here
    if not vfiles:
        raise SystemExit(f"{run_id}: no Verilog in {rdir} (run it first)")
    mods = verilog_modules(vfiles[0].read_text(errors="replace"))
    inst = {n for owner, body in mods.items() for n in mods if n != owner and instances(body, n)}
    top = [n for n in mods if n not in inst][-1]
    out = RTL_OUT / run_id
    if out.exists():
        subprocess.run(["rm", "-rf", str(out)], check=True)
    out.mkdir(parents=True)
    for f in vfiles:
        (out / f.name).write_bytes(f.read_bytes())
    (out / "filelist.f").write_text(
        "# Generated by bench/probe/bambu/probe.py --keep-rtl: one Bambu probe run's Verilog\n"
        f"# (bench/probe/bambu/runs/{run_id}/, BAM1). Paths are relative to this folder.\n"
        f"# top: {top}\n" + "".join(f"{f.name}\n" for f in vfiles))
    cmd = [str(IN_BAMBU)] + bambu_args(r, rdir / "vecadd.cpp")
    (out / "cmd.txt").write_text(cmd_text(rdir, cmd))
    print(f"kept {run_id}: {', '.join(f.name for f in vfiles)}, top {top}")


# --------------------------------------------------------------- one run
def run_one(r: dict) -> dict:
    rdir = RUNS / r["id"]
    if rdir.exists():
        subprocess.run(["rm", "-rf", str(rdir)], check=True)
    rdir.mkdir(parents=True)
    edits = list(PRAGMAS[r["pragmas"]])
    if r["ports"] != "default":
        edits.append(interface(r["ports"], r.get("lc", "none")))
    src_text = variant(edits)
    src = rdir / "vecadd.cpp"
    src.write_text(src_text)
    diff = "".join(difflib.unified_diff(SRC.splitlines(True), src_text.splitlines(True),
                                        "bench/tier_done/vecadd/src/vecadd.cpp", f"runs/{r['id']}/vecadd.cpp"))
    (rdir / "vecadd.cpp.diff").write_text(diff)
    args = bambu_args(r, src)
    cmd = [str(IN_BAMBU)] + args
    (rdir / "cmd.txt").write_text(cmd_text(rdir, cmd))
    name = f"bam1-probe-{r['id'].lower().replace('_', '-')}-{os.getpid()}"
    env = dict(os.environ, BAMBU_CONTAINER_NAME=name)
    t0 = time.monotonic()
    timed_out, rc = False, None
    with open(rdir / "bambu.log", "w") as logf:
        p = subprocess.Popen(cmd, cwd=rdir, stdout=logf, stderr=subprocess.STDOUT, stdin=subprocess.DEVNULL, env=env)
        try:
            rc = p.wait(timeout=TIMEOUT_S)
        except subprocess.TimeoutExpired:
            timed_out = True
            subprocess.run(["podman", "rm", "-f", "-t", "0", name], capture_output=True)
            p.kill()
            p.wait()
    runtime = round(time.monotonic() - t0, 1)
    row = parse(r, rdir, rc, timed_out)
    row.update(id=r["id"], group=r["group"], W=r["W"],
               setup=r["setup"] if r["setup"] != "default" else f"default ({DEFAULT_SETUP})",
               pragmas=r["pragmas"] + (f"; loop_count {r['lc']}" if r.get("lc", "none") != "none" else ""),
               ports=r["ports"], simulator="VERILATOR",
               lanes_header=f"bench/probe/bambu/{r.get('header', 'include')}/lanes.h", runtime_s=runtime,
               bambu_cmd="bench/tools/in_bambu.sh " + shlex.join(a.replace(str(REPO) + "/", "") for a in args))
    print(f"{r['id']:28s} {row['status']:14s} cycles={row['cycles']!s:5s} adders={row['adders']!s:3s} {runtime:6.1f} s",
          flush=True)
    return row


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("-j", type=int, default=os.cpu_count(), help="runs at once (default: nproc)")
    ap.add_argument("--only", default="", help="only runs whose id starts with this")
    ap.add_argument("--csv", default=str(CSV_OUT))
    ap.add_argument("--keep-rtl", nargs="+", metavar="ID", help="copy these runs' Verilog to notes/bambu_rtl/ and exit")
    a = ap.parse_args()
    if a.keep_rtl:
        for run_id in a.keep_rtl:
            keep_rtl(run_id)
        return 0
    todo = [r for r in runs() if r["id"].startswith(a.only)]
    print(f"{len(todo)} runs, {a.j} at once, timeout {TIMEOUT_S} s", flush=True)
    with ThreadPoolExecutor(max_workers=a.j) as ex:
        rows = list(ex.map(run_one, todo))
    # Merge: rows of this call replace those with the same id; the others are kept.
    old = list(csv.DictReader(open(a.csv))) if Path(a.csv).is_file() else []
    new = {row["id"]: row for row in rows}
    merged = [new.pop(o["id"], o) for o in old] + list(new.values())
    with open(a.csv, "w", newline="") as f:
        wr = csv.DictWriter(f, fieldnames=COLUMNS, restval="")
        wr.writeheader()
        wr.writerows(merged)
    counts: dict[str, dict[str, int]] = {}
    for row in rows:
        counts.setdefault(row["group"], {}).setdefault(row["status"], 0)
        counts[row["group"]][row["status"]] += 1
    for g, c in sorted(counts.items()):
        print(g, ", ".join(f"{k}: {v}" for k, v in sorted(c.items())))
    print(f"wrote {a.csv}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
