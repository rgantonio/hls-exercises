#!/usr/bin/env python3
"""bench/bench.py - run the HLS side of the snax-forge comparison.

One entry point for people and for Claude Code. Standard library only, so it
runs on the Vitis machine without any environment. Plan and conventions:
docs/HLS_VS_FORGE.md.

  python3 bench/bench.py list    [--tier T] [--kernel K]
  python3 bench/bench.py run     [--tier T] [--kernel K] [--case C ...] [--size TAG ...]
                                 [--w N ...] [--clock NS ...] [--no-csim] [--no-cosim]
                                 [-j N] [--dry-run]
  python3 bench/bench.py collect [--tier T] [--kernel K]   re-read existing projects
  python3 bench/bench.py check   [--tier T] [--kernel K]   portability of the Verilog
  python3 bench/bench.py report  [--tier T]                write results/report_<tier>.md again

Every run point is one Vitis project inside the kernel's folder, named
<case>_<size>[_w<W>]_c<clock>_proj, holding one solution `sol` and a point.json
that says what the point was. The projects are scratch (git ignores them,
make clean removes them). What is kept is the summary in results/:

  hls_cycles.csv     one row per point: estimate, cosim cycles, checks
  hls_loops.csv      one row per loop per point: trips, II, iteration latency
  report_<tier>.md   tables made from the two CSVs (and forge_cycles.csv)

run and collect replace the rows with the same key and write the report again.
"""

from __future__ import annotations

import argparse
import csv
import datetime as dt
import itertools
import json
import os
import re
import shutil
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BENCH = ROOT / "bench"
RUN_TCL = BENCH / "run_bench.tcl"
RESULTS = ROOT / "results"
CSV_PATH = RESULTS / "hls_cycles.csv"
LOOPS_PATH = RESULTS / "hls_loops.csv"
FORGE_PATH = RESULTS / "forge_cycles.csv"

CASES = ("unopt", "opt", "dace")
CTYPES = {"int64": "int64_t", "int32": "int32_t", "int16": "int16_t", "int8": "int8_t",
          "float32": "float", "float64": "double"}
DEFAULT_CLOCK = "3.33"

COLUMNS = [
    "tier", "kernel", "case", "dtype", "size", "W", "clock_ns",
    "status", "csim_errors", "clock_est_ns",
    "lat_min", "lat_max", "ii_min", "ii_max", "pipeline",
    "cosim_status", "cosim_lat_min", "cosim_lat_avg", "cosim_lat_max",
    "LUT", "FF", "DSP", "BRAM_18K", "portable",
    "vitis", "git", "date", "proj",
]
KEY = ("tier", "kernel", "case", "size", "W", "clock_ns")
LOOP_COLUMNS = list(KEY) + ["module", "loop", "lat_min", "lat_max", "iter_lat",
                            "ii_achieved", "ii_target", "trips", "pipelined"]

# Verilog patterns that tie the RTL to Xilinx parts (docs/HLS_VS_FORGE.md, 3.2).
NOT_PORTABLE = [
    (re.compile(r"DSP48"), "DSP48 primitive"),
    (re.compile(r"\bxpm_\w+"), "XPM macro"),
    (re.compile(r"floating_point_v\d"), "floating-point IP"),
    (re.compile(r'use_dsp\s*=\s*"(yes|simd|logic)"', re.I), "use_dsp attribute"),
]


# ---------------------------------------------------------------- kernels
def load_kernels(tier: str | None, kernel: str | None) -> list[tuple[Path, dict]]:
    found = []
    for p in sorted(BENCH.glob("tier_*/*/params.json")):
        params = json.loads(p.read_text())
        params.setdefault("kernel", p.parent.name)
        params.setdefault("tier", p.parent.parent.name.removeprefix("tier_"))
        if tier and params["tier"] != tier:
            continue
        if kernel and params["kernel"] != kernel:
            continue
        found.append((p.parent, params))
    return found


def size_tag(size: dict) -> str:
    """{"m": 38, "n": 42} -> "m38_n42" (keys in the order params.json gives)."""
    return "_".join(f"{k.lower()}{v}" for k, v in size.items())


def clock_tag(clock: str) -> str:
    return "c" + clock.replace(".", "p")


def points(kdir: Path, params: dict, args) -> list[dict]:
    """Every (case, size, W, clock) the arguments select for one kernel."""
    out = []
    clocks = args.clock or [str(params.get("clock_ns", DEFAULT_CLOCK))]
    for case, cfg in params["cases"].items():
        if case not in CASES:
            sys.exit(f"{kdir}: unknown case '{case}' (cases are {', '.join(CASES)})")
        if args.case and case not in args.case:
            continue
        ws = params.get("W", [1]) if cfg.get("per_w", False) else [None]
        for size, w, clock in itertools.product(params["sizes"], ws, clocks):
            tag = size_tag(size)
            if args.size and tag not in args.size:
                continue
            if args.w and w is not None and w not in args.w:
                continue
            name = f"{case}_{tag}" + (f"_w{w}" if w is not None else "") + f"_{clock_tag(clock)}_proj"
            out.append({
                "kdir": kdir, "params": params, "case": case, "cfg": cfg,
                "size": size, "size_tag": tag, "W": w, "clock": clock, "proj": name,
            })
    return out


def point_env(pt: dict, do_csim: bool, do_cosim: bool) -> dict:
    kdir, params, cfg, tag, w = pt["kdir"], pt["params"], pt["cfg"], pt["size_tag"], pt["W"]
    # {size}, {W} and {bench} (absolute path of bench/) may appear in paths and cflags.
    fmt = {"size": tag, "W": w if w is not None else "", "bench": str(BENCH)}

    def path(rel: str) -> str:
        return str((kdir / rel.format(**fmt)).resolve())

    dtype = params.get("dtype", "int64")
    flags = [f"-DDATA_T={CTYPES.get(dtype, dtype)}"]
    if "acc_dtype" in params:
        flags.append(f"-DACC_T={CTYPES.get(params['acc_dtype'], params['acc_dtype'])}")
    flags += [f"-DSIZE_{k.upper()}={v}" for k, v in pt["size"].items()]
    if w is not None:
        flags.append(f"-DW={w}")
    flags += [f"-I{kdir.resolve() / 'src'}", f"-I{kdir.resolve() / 'vectors' / tag}"]
    flags += [f.format(**fmt) for f in cfg.get("cflags", [])]

    directives = cfg.get("directives", f"directives_{pt['case']}.tcl")
    dpath = kdir / directives.format(**fmt)

    env = dict(os.environ)
    env.update({
        "PROJ": pt["proj"],
        "TOP": cfg["top"],
        "SRCS": " ".join(path(s) for s in cfg["src"]),
        "TB": path(cfg.get("tb", params["tb"])),
        "CFLAGS": " ".join(flags),
        "DIRECTIVES": str(dpath.resolve()) if dpath.is_file() else "",
        "W": "" if w is None else str(w),
        "DO_CSIM": "1" if do_csim else "0",
        "DO_COSIM": "1" if do_cosim else "0",
        "CLOCK_NS": pt["clock"],
    })
    return env


def missing_inputs(pt: dict, env: dict) -> list[str]:
    missing = [p for p in env["SRCS"].split() + [env["TB"]] if not Path(p).is_file()]
    data = pt["kdir"] / "vectors" / pt["size_tag"] / "data.h"
    if not data.is_file():
        missing.append(f"{data} (run bench/gen/gen_data.py in snax-forge's env)")
    return missing


# ---------------------------------------------------------------- reports
def _cells(line: str) -> list[str]:
    return [c.strip() for c in line.strip().strip("|").split("|")]


def _num(s: str) -> str:
    """'3.33 ns' -> '3.33'; '1029' -> '1029'; '?' stays '?'."""
    m = re.match(r"^\s*([0-9.]+)", s or "")
    return m.group(1) if m else (s or "").strip()


def parse_csynth(rpt: Path) -> dict:
    """The top module's <top>_csynth.rpt: timing, latency, utilization."""
    row: dict = {}
    if not rpt.is_file():
        return row
    section = None
    util_cols: list[str] | None = None
    for line in rpt.read_text(errors="replace").splitlines():
        if line.startswith("+ Timing:"):
            section = "timing"
        elif line.startswith("+ Latency:"):
            section = "latency"
        elif line.startswith("== Utilization Estimates"):
            section = "util"
        elif line.startswith("== "):
            section = None
        if section == "timing" and "|ap_clk" in line.replace(" ", ""):
            c = _cells(line)
            if len(c) >= 3:
                row["clock_est_ns"] = _num(c[2])
        elif section == "latency" and "lat_min" not in row and re.match(r"^\s*\|\s*[0-9?]", line):
            c = _cells(line)
            if len(c) >= 7:
                row.update(lat_min=c[0], lat_max=c[1], ii_min=c[4], ii_max=c[5], pipeline=c[6])
        elif section == "util":
            c = _cells(line) if line.lstrip().startswith("|") else []
            if c and c[0] == "Name":
                util_cols = c
            elif c and util_cols and c[0] == "Total" and "LUT" not in row:
                vals = dict(zip(util_cols, c))
                for k in ("LUT", "FF", "DSP", "BRAM_18K"):
                    row[k] = vals.get(k, "")
    return row


def parse_loops(sol: Path, top: str) -> list[dict]:
    """The loop table of every module report, top module first (as collect_latency.sh)."""
    rdir = sol / "syn" / "report"
    if not rdir.is_dir():
        return []
    reports = sorted(rdir.glob("*_csynth.rpt"), key=lambda r: (r.name != f"{top}_csynth.rpt", r.name))
    loops = []
    for r in reports:
        module = r.name.removesuffix("_csynth.rpt")
        inside = False
        for line in r.read_text(errors="replace").splitlines():
            if re.match(r"^\s*\* Loop:", line):
                inside = True
                continue
            if inside and (line.startswith("=====") or line.startswith("+ ") or re.match(r"^\s*\* ", line)):
                inside = False
            if inside and re.match(r"^\s*\|\s*[-+]+ ", line):
                c = _cells(line)
                if len(c) >= 8:
                    loops.append({"module": module, "loop": c[0].lstrip("-+ ").strip(),
                                  "lat_min": c[1], "lat_max": c[2], "iter_lat": c[3],
                                  "ii_achieved": c[4], "ii_target": c[5], "trips": c[6],
                                  "pipelined": c[7]})
    return loops


def parse_cosim(sol: Path) -> dict:
    rpts = sorted((sol / "sim" / "report").glob("*cosim.rpt"))
    if not rpts:
        return {}
    for line in rpts[0].read_text(errors="replace").splitlines():
        c = _cells(line) if line.lstrip().startswith("|") else []
        if len(c) >= 5 and c[0] == "Verilog":
            return {"cosim_status": c[1], "cosim_lat_min": c[2], "cosim_lat_avg": c[3],
                    "cosim_lat_max": c[4]}
    return {"cosim_status": "no Verilog row"}


def parse_log(log: Path) -> dict:
    row: dict = {}
    if not log.is_file():
        return row
    text = log.read_text(errors="replace")
    m = re.search(r"CSim done with (\d+) errors", text)
    if m:
        row["csim_errors"] = m.group(1)
    m = re.search(r"Vitis HLS - High-Level Synthesis.*?(v20\d\d\.\d(?:\.\d)?)", text)
    if m:
        row["vitis"] = m.group(1)
    return row


def check_verilog(sol: Path) -> str:
    vdir = sol / "syn" / "verilog"
    if not vdir.is_dir():
        return ""
    hits = set()
    for f in sorted(vdir.iterdir()):
        if f.name.endswith("_ip.tcl"):
            hits.add(f"IP script {f.name}")
            continue
        if f.suffix not in (".v", ".sv", ".vh"):
            continue
        text = f.read_text(errors="replace")
        for pat, what in NOT_PORTABLE:
            if pat.search(text):
                hits.add(f"{what} in {f.name}")
    return "yes" if not hits else "no: " + "; ".join(sorted(hits))


def git_rev() -> str:
    try:
        return subprocess.run(["git", "-C", str(ROOT), "rev-parse", "--short", "HEAD"],
                              capture_output=True, text=True, check=True).stdout.strip()
    except (OSError, subprocess.CalledProcessError):
        return ""


def read_point(kdir: Path, proj: str) -> dict | None:
    """One CSV row from an existing project folder (None if it has no point.json)."""
    pj = kdir / proj / "point.json"
    if not pj.is_file():
        return None
    meta = json.loads(pj.read_text())
    sol = kdir / proj / "sol"
    row = {k: "" for k in COLUMNS}
    row.update({k: meta[k] for k in ("tier", "kernel", "case", "dtype", "size", "W", "clock_ns", "date", "git")})
    row["proj"] = f"{kdir.relative_to(ROOT)}/{proj}"
    row.update(parse_log(kdir / f"run_{proj}.log"))
    row.update(parse_csynth(sol / "syn" / "report" / f"{meta['top']}_csynth.rpt"))
    row.update(parse_cosim(sol))
    row["portable"] = check_verilog(sol)
    row["_loops"] = parse_loops(sol, meta["top"])
    if "lat_min" not in row or row["lat_min"] == "":
        row["status"] = "failed: no csynth report"
    elif meta.get("do_csim") and row.get("csim_errors") not in ("0",):
        row["status"] = "failed: csim"
    elif meta.get("do_cosim") and row.get("cosim_status", "").lower() != "pass":
        row["status"] = "failed: cosim"
    else:
        row["status"] = "ok"
    return row


# ---------------------------------------------------------------- csv
def read_csv(path: Path) -> list[dict]:
    if not path.is_file():
        return []
    with path.open(newline="") as fh:
        return list(csv.DictReader(fh))


def write_loops(rows: list[dict]) -> None:
    keys = {tuple(str(r[k]) for k in KEY) for r in rows}
    kept = [r for r in read_csv(LOOPS_PATH) if tuple(r.get(k, "") for k in KEY) not in keys]
    for r in rows:
        for lp in r.get("_loops", []):
            kept.append({**{k: str(r[k]) for k in KEY}, **lp})
    order = {c: i for i, c in enumerate(CASES)}
    kept.sort(key=lambda r: (r["tier"], r["kernel"], order.get(r["case"], 9), size_count(r["size"]),
                             str(r["W"]).zfill(4), r["clock_ns"]))
    with LOOPS_PATH.open("w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=LOOP_COLUMNS, extrasaction="ignore")
        w.writeheader()
        w.writerows(kept)


def write_rows(rows: list[dict]) -> None:
    if not rows:
        return
    CSV_PATH.parent.mkdir(parents=True, exist_ok=True)
    write_loops(rows)
    table: dict[tuple, dict] = {}
    if CSV_PATH.is_file():
        with CSV_PATH.open(newline="") as fh:
            for r in csv.DictReader(fh):
                table[tuple(r.get(k, "") for k in KEY)] = r
    for r in rows:
        table[tuple(str(r[k]) for k in KEY)] = {k: r.get(k, "") for k in COLUMNS}
    order = {c: i for i, c in enumerate(CASES)}
    keyed = sorted(table.values(), key=lambda r: (r["tier"], r["kernel"], order.get(r["case"], 9),
                                                  size_count(r["size"]), str(r["W"]).zfill(4), r["clock_ns"]))
    with CSV_PATH.open("w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=COLUMNS, extrasaction="ignore")
        w.writeheader()
        w.writerows(keyed)
    print(f"wrote {len(rows)} row(s) to {CSV_PATH.relative_to(ROOT)} and its loops to {LOOPS_PATH.relative_to(ROOT)}")
    write_reports({r["tier"] for r in rows})


# ---------------------------------------------------------------- report
def size_count(tag: str) -> int:
    """'m38_n42' -> 38 * 42: the elements the size names."""
    n = 1
    for v in re.findall(r"[a-z]+(\d+)", tag or ""):
        n *= int(v)
    return n


def _int(s: str) -> int | None:
    try:
        return int(float(s))
    except (TypeError, ValueError):
        return None


def md_table(header: list[str], rows: list[list[str]]) -> list[str]:
    out = ["| " + " | ".join(header) + " |", "|" + "|".join("---" for _ in header) + "|"]
    out += ["| " + " | ".join(str(c) for c in r) + " |" for r in rows]
    return out + [""]


def write_reports(tiers: set[str]) -> None:
    rows = read_csv(CSV_PATH)
    loops = read_csv(LOOPS_PATH)
    forge = read_csv(FORGE_PATH)
    order = {c: i for i, c in enumerate(CASES)}
    for tier in sorted(tiers):
        trows = [r for r in rows if r["tier"] == tier]
        if not trows:
            continue
        out = [f"# Results: tier {tier}", "",
               "Generated by `bench/bench.py` from `results/hls_cycles.csv` and `results/hls_loops.csv`. "
               "Do not edit; rerun `python3 bench/bench.py report`.", "",
               "- **cycles**: cosim latency (RTL simulation, Verilog), or the csynth estimate (marked `est`) "
               "when cosim did not run.",
               "- **cyc/elem**: cycles divided by the elements the size names (n, or m x n).",
               "- **vs unopt**: the unopt cycles at the same size and clock divided by this row's.",
               "- **II**: the top's interval from csynth. The loop table below has each loop's II.", ""]
        for kernel in sorted({r["kernel"] for r in trows}):
            krows = sorted([r for r in trows if r["kernel"] == kernel],
                           key=lambda r: (size_count(r["size"]), order.get(r["case"], 9), str(r["W"]).zfill(4),
                                          r["clock_ns"]))

            def cycles(r: dict) -> tuple[int | None, str]:
                c = _int(r.get("cosim_lat_avg"))
                if c is not None:
                    return c, str(c)
                e = _int(r.get("lat_max"))
                return e, (f"{e} est" if e is not None else "-")

            base = {(r["size"], r["clock_ns"]): cycles(r)[0] for r in krows if r["case"] == "unopt"}
            table = []
            for r in krows:
                c, ctext = cycles(r)
                b = base.get((r["size"], r["clock_ns"]))
                per = f"{c / size_count(r['size']):.2f}" if c else "-"
                vs = f"{b / c:.1f}x" if b and c else "-"
                ok = r["status"] if r["status"] == "ok" else f"**{r['status']}**"
                port = r["portable"] if r["portable"] in ("yes", "") else f"**{r['portable']}**"
                table.append([r["case"], r["size"], r["W"] or "-", r["clock_ns"], ok, ctext, per, vs,
                              f"{r['lat_min']}-{r['lat_max']}", r["ii_max"], r["clock_est_ns"], r["DSP"], port])
            out += [f"## {kernel}", ""]
            out += md_table(["case", "size", "W", "clock ns", "status", "cycles", "cyc/elem", "vs unopt",
                             "est. latency", "II", "est. clock ns", "DSP", "portable"], table)
            klo = [lp for lp in loops if lp["tier"] == tier and lp["kernel"] == kernel]
            if klo:
                klo.sort(key=lambda lp: (size_count(lp["size"]), order.get(lp["case"], 9), str(lp["W"]).zfill(4)))
                out += ["Loops:", ""]
                out += md_table(["case", "size", "W", "module", "loop", "trips", "iter lat", "II (achieved/target)",
                                 "latency", "pipelined"],
                                [[lp["case"], lp["size"], lp["W"] or "-", lp["module"], lp["loop"], lp["trips"],
                                  lp["iter_lat"], f"{lp['ii_achieved']}/{lp['ii_target']}",
                                  f"{lp['lat_min']}-{lp['lat_max']}", lp["pipelined"]] for lp in klo])
            frows = [f for f in forge if f.get("kernel") == kernel]
            if frows:
                cols = [c for c in frows[0].keys()]
                out += ["snax-forge (`results/forge_cycles.csv`):", ""]
                out += md_table(cols, [[f.get(c, "") for c in cols] for f in frows])
        path = RESULTS / f"report_{tier}.md"
        path.write_text("\n".join(out))
        print(f"wrote {path.relative_to(ROOT)}")


def print_rows(rows: list[dict]) -> None:
    cols = ["kernel", "case", "size", "W", "clock_ns", "status", "lat_max", "ii_max",
            "cosim_lat_avg", "DSP", "portable"]
    table = [[str(r.get(c, "")) for c in cols] for r in rows]
    widths = [max(len(c), *(len(t[i]) for t in table)) for i, c in enumerate(cols)]
    print("  ".join(c.ljust(w) for c, w in zip(cols, widths)))
    for t in table:
        print("  ".join(v.ljust(w) for v, w in zip(t, widths)))


# ---------------------------------------------------------------- commands
def cmd_list(args) -> int:
    for kdir, params in load_kernels(args.tier, args.kernel):
        print(f"{kdir.relative_to(ROOT)}  tier={params['tier']}  dtype={params.get('dtype', 'int64')}")
        for pt in points(kdir, params, args):
            print(f"    {pt['proj']}")
    return 0


def run_point(pt: dict, args, vitis: str) -> dict | None:
    kdir, proj = pt["kdir"], pt["proj"]
    env = point_env(pt, not args.no_csim, not args.no_cosim)
    missing = missing_inputs(pt, env)
    if args.dry_run:
        print(f"\n# {kdir.relative_to(ROOT)} / {proj}")
        for k in ("PROJ", "TOP", "SRCS", "TB", "CFLAGS", "DIRECTIVES", "W", "DO_CSIM", "DO_COSIM", "CLOCK_NS"):
            print(f"export {k}='{env[k]}'")
        print(f"cd {kdir} && {vitis} -f {RUN_TCL} 2>&1 | tee run_{proj}.log")
        for m in missing:
            print(f"# missing: {m}")
        return None
    if missing:
        print(f"skip {proj}: missing\n  " + "\n  ".join(missing))
        return None
    log = kdir / f"run_{proj}.log"
    print(f"run  {kdir.relative_to(ROOT)}/{proj}  (log: {log.name})", flush=True)
    with log.open("w") as fh:
        subprocess.run([vitis, "-f", str(RUN_TCL)], cwd=kdir, env=env, stdout=fh,
                       stderr=subprocess.STDOUT, check=False)
    # Written after the run, because open_project -reset wipes the folder.
    meta = {
        "tier": pt["params"]["tier"], "kernel": pt["params"]["kernel"], "case": pt["case"],
        "dtype": pt["params"].get("dtype", "int64"), "size": pt["size_tag"],
        "W": "" if pt["W"] is None else pt["W"], "clock_ns": pt["clock"], "top": pt["cfg"]["top"],
        "do_csim": not args.no_csim, "do_cosim": not args.no_cosim,
        "date": dt.datetime.now().isoformat(timespec="seconds"), "git": git_rev(), "env": {
            k: env[k] for k in ("SRCS", "TB", "CFLAGS", "DIRECTIVES")},
    }
    (kdir / proj).mkdir(exist_ok=True)
    (kdir / proj / "point.json").write_text(json.dumps(meta, indent=1) + "\n")
    row = read_point(kdir, proj)
    print(f"done {proj}: {row['status']}  lat {row['lat_min']}-{row['lat_max']}"
          f"  cosim {row['cosim_lat_avg'] or '-'}  portable {row['portable'] or '-'}", flush=True)
    return row


def cmd_run(args) -> int:
    vitis = os.environ.get("VITIS_HLS", "vitis_hls")
    if not args.dry_run and shutil.which(vitis) is None:
        sys.exit(f"'{vitis}' not found: source Vitis's settings64.sh or set VITIS_HLS")
    pts = [pt for kdir, params in load_kernels(args.tier, args.kernel) for pt in points(kdir, params, args)]
    if not pts:
        sys.exit("no run points match (bench.py list shows them)")
    with ThreadPoolExecutor(max_workers=max(1, args.jobs)) as pool:
        results = list(pool.map(lambda p: run_point(p, args, vitis), pts))
    if args.dry_run:
        return 0
    rows = [r for r in results if r]
    skipped = len(results) - len(rows)
    if rows:
        write_rows(rows)
        print_rows(rows)
    if skipped:
        print(f"{skipped} point(s) skipped for missing inputs (see 'skip' lines above)")
    return 0 if rows and not skipped and all(r["status"] == "ok" for r in rows) else 1


def existing_rows(args) -> list[dict]:
    rows = []
    for kdir, _ in load_kernels(args.tier, args.kernel):
        for proj in sorted(p.name for p in kdir.glob("*_proj") if p.is_dir()):
            r = read_point(kdir, proj)
            if r:
                rows.append(r)
    return rows


def cmd_collect(args) -> int:
    rows = existing_rows(args)
    if not rows:
        sys.exit("no projects with a point.json found")
    write_rows(rows)
    print_rows(rows)
    return 0


def cmd_report(args) -> int:
    tiers = {r["tier"] for r in read_csv(CSV_PATH)}
    if args.tier:
        tiers &= {args.tier}
    if not tiers:
        sys.exit("no rows in results/hls_cycles.csv for that tier")
    write_reports(tiers)
    return 0


def cmd_check(args) -> int:
    bad = 0
    for r in existing_rows(args):
        print(f"{r['proj']}: {r['portable'] or 'no Verilog yet'}")
        bad += r["portable"].startswith("no")
    return 1 if bad else 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    for name in ("list", "run", "collect", "check", "report"):
        p = sub.add_parser(name)
        p.add_argument("--tier", help="done, a, untiered, ... (folder bench/tier_<T>)")
        if name != "report":
            p.add_argument("--kernel")
        if name in ("list", "run"):
            p.add_argument("--case", nargs="+", choices=CASES)
            p.add_argument("--size", nargs="+", help="size tags, e.g. n64 m38_n42")
            p.add_argument("--w", nargs="+", type=int, help="lane counts (cases with per_w)")
            p.add_argument("--clock", nargs="+", help="clock periods in ns (default: params or 3.33)")
        if name == "run":
            p.add_argument("--no-csim", action="store_true")
            p.add_argument("--no-cosim", action="store_true")
            p.add_argument("-j", "--jobs", type=int, default=1, help="Vitis runs in parallel")
            p.add_argument("--dry-run", action="store_true", help="print the commands, run nothing")
    args = ap.parse_args()
    return {"list": cmd_list, "run": cmd_run, "collect": cmd_collect, "check": cmd_check,
            "report": cmd_report}[args.cmd](args)


if __name__ == "__main__":
    sys.exit(main())
