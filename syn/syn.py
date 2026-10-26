#!/usr/bin/env python3
"""syn/syn.py - ASIC synthesis of bench points with Design Compiler on FreePDK45.

A point is a folder in rtl/, named <tier>/<kernel>/<point> (e.g.
done/vecadd/unopt_n512_w8), holding Vitis's Verilog and a filelist.f that
bench/bench.py writes. Patterns are shell globs over those names.

  python3 syn/syn.py list    [PATTERN ...]
  python3 syn/syn.py run     PATTERN ... [--clock NS] [--cores N] [-j N] [--dry-run]
  python3 syn/syn.py summary [PATTERN ...]

Each run works in syn/runs/<tier>/<kernel>/<point>[_c<clock>]/ (the clock tag
only for a clock other than the default): WORK/, logs/, reports/ and out/ (the
mapped netlist, ddc, sdf and sdc). Every run also writes one row into
syn/runs/summary.csv: area, critical path, slack and power. git ignores
syn/runs/ entirely, so nothing here is committed.

Tools and files, all overridable from the environment:
  DC_SHELL        dc_shell                               (Design Compiler)
  SYN_LIB         ../FreePDK45/osu_soc/lib/files/gscl45nm.db, next to hls-exercises
Standard library only.
"""

from __future__ import annotations

import argparse
import csv
import datetime as dt
import fnmatch
import os
import re
import shutil
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

SYN = Path(__file__).resolve().parent
ROOT = SYN.parent
RTL = ROOT / "rtl"
RUNS = SYN / "runs"
SCRIPT = SYN / "scripts" / "dc_syn.tcl"
SUMMARY = RUNS / "summary.csv"
DEFAULT_LIB = ROOT.parent / "FreePDK45" / "osu_soc" / "lib" / "files" / "gscl45nm.db"
DEFAULT_CLOCK = "10"

COLUMNS = ["point", "top", "clock_ns", "status", "errors", "area", "comb_area", "seq_area", "cells",
           "crit_path_ns", "slack_ns", "dyn_power", "leak_power", "date", "run"]


# ---------------------------------------------------------------- points
def all_points() -> list[str]:
    return sorted(str(f.parent.relative_to(RTL)) for f in RTL.glob("*/*/*/filelist.f"))


def select(patterns: list[str]) -> list[str]:
    pts = all_points()
    if not patterns:
        return pts
    return [p for p in pts if any(fnmatch.fnmatchcase(p, pat) for pat in patterns)]


def top_of(point: str) -> str:
    m = re.search(r"^#\s*top:\s*(\S+)", (RTL / point / "filelist.f").read_text(), re.M)
    return m.group(1) if m else ""


def run_dir(point: str, clock: str) -> Path:
    tag = "" if clock == DEFAULT_CLOCK else "_c" + clock.replace(".", "p")
    return RUNS / f"{point}{tag}"


# ---------------------------------------------------------------- reports
def _first(text: str, pattern: str) -> str:
    m = re.search(pattern, text, re.M)
    return m.group(1) if m else ""


def _power(text: str, label: str) -> str:
    """'Total Dynamic Power    = 108.5871 uW  (100%)' -> '108.5871 uW'."""
    m = re.search(rf"{label}\s*=\s*([0-9.eE+-]+)\s*([munpf]?W)", text)
    return f"{m.group(1)} {m.group(2)}" if m else ""


def read_run(point: str, clock: str) -> dict:
    rdir = run_dir(point, clock)
    rep = rdir / "reports"

    def text(name: str) -> str:
        f = rep / name
        return f.read_text(errors="replace") if f.is_file() else ""

    area, qor, power = text("area.rpt"), text("qor.rpt"), text("power.rpt")
    log = rdir / "logs" / "dc_shell.log"
    errors = len(re.findall(r"^Error:", log.read_text(errors="replace"), re.M)) if log.is_file() else ""
    row = {
        "point": point, "top": top_of(point), "clock_ns": clock,
        "errors": errors,
        "area": _first(area, r"Total cell area:\s*([0-9.]+)"),
        "comb_area": _first(area, r"Combinational area:\s*([0-9.]+)"),
        "seq_area": _first(area, r"Noncombinational area:\s*([0-9.]+)"),
        "cells": _first(area, r"Number of cells:\s*([0-9]+)"),
        "crit_path_ns": _first(qor, r"Critical Path Length:\s*([0-9.-]+)"),
        "slack_ns": _first(qor, r"Critical Path Slack:\s*([0-9.-]+)"),
        "dyn_power": _power(power, "Total Dynamic Power"),
        "leak_power": _power(power, "Cell Leakage Power"),
        "date": dt.datetime.now().isoformat(timespec="seconds"),
        "run": str(rdir.relative_to(ROOT)),
    }
    if not row["area"]:
        row["status"] = "failed: no area report"
    elif row["slack_ns"] and float(row["slack_ns"]) < 0:
        row["status"] = "ok, timing violated"
    else:
        row["status"] = "ok"
    return row


def write_summary(rows: list[dict]) -> None:
    RUNS.mkdir(parents=True, exist_ok=True)
    table = {}
    if SUMMARY.is_file():
        with SUMMARY.open(newline="") as fh:
            table = {(r["point"], r["clock_ns"]): r for r in csv.DictReader(fh)}
    for r in rows:
        table[(r["point"], r["clock_ns"])] = r
    with SUMMARY.open("w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=COLUMNS, extrasaction="ignore")
        w.writeheader()
        w.writerows(sorted(table.values(), key=lambda r: (r["point"], float(r["clock_ns"] or 0))))


def print_rows(rows: list[dict]) -> None:
    cols = ["point", "clock_ns", "status", "area", "cells", "crit_path_ns", "slack_ns", "dyn_power", "leak_power"]
    t = [[str(r.get(c, "")) for c in cols] for r in rows]
    w = [max(len(c), *(len(x[i]) for x in t)) for i, c in enumerate(cols)] if t else [len(c) for c in cols]
    print("  ".join(c.ljust(n) for c, n in zip(cols, w)))
    for x in t:
        print("  ".join(v.ljust(n) for v, n in zip(x, w)))


# ---------------------------------------------------------------- commands
def cmd_list(args) -> int:
    for p in select(args.patterns):
        print(f"{p}  (top {top_of(p)})")
    return 0


def run_one(point: str, args, dc: str, lib: Path) -> dict | None:
    rdir = run_dir(point, args.clock)
    env = dict(os.environ, SYN_FILELIST=str(RTL / point / "filelist.f"), SYN_LIB=str(lib),
               SYN_CLOCK_NS=args.clock, SYN_CORES=str(args.cores))
    cmd = [dc, "-f", str(SCRIPT), "-output_log_file", "logs/dc_shell.log"]
    if args.dry_run:
        print(f"\n# {point}")
        for k in ("SYN_FILELIST", "SYN_LIB", "SYN_CLOCK_NS", "SYN_CORES"):
            print(f"export {k}='{env[k]}'")
        print(f"mkdir -p {rdir}/logs && cd {rdir} && {' '.join(cmd)}")
        return None
    if rdir.exists():
        shutil.rmtree(rdir)
    (rdir / "logs").mkdir(parents=True)
    print(f"run  {point} at {args.clock} ns in {rdir.relative_to(ROOT)}", flush=True)
    with (rdir / "logs" / "dc_stdout.log").open("w") as fh:
        subprocess.run(cmd, cwd=rdir, env=env, stdout=fh, stderr=subprocess.STDOUT, check=False)
    row = read_run(point, args.clock)
    print(f"done {point}: {row['status']}  area {row['area'] or '-'}  slack {row['slack_ns'] or '-'} ns"
          f"  errors {row['errors']}", flush=True)
    return row


def cmd_run(args) -> int:
    points = select(args.patterns)
    if not points:
        sys.exit("no rtl point matches (syn.py list shows them)")
    lib = Path(os.environ.get("SYN_LIB", DEFAULT_LIB)).resolve()
    dc = os.environ.get("DC_SHELL", "dc_shell")
    if not args.dry_run:
        if shutil.which(dc) is None:
            sys.exit(f"'{dc}' not found: load Design Compiler or set DC_SHELL")
        if not lib.is_file():
            sys.exit(f"no library at {lib}: put FreePDK45 next to hls-exercises or set SYN_LIB")
    with ThreadPoolExecutor(max_workers=max(1, args.jobs)) as pool:
        rows = [r for r in pool.map(lambda p: run_one(p, args, dc, lib), points) if r]
    if rows:
        write_summary(rows)
        print(f"\nwrote {SUMMARY.relative_to(ROOT)}")
        print_rows(rows)
    return 0 if rows and all(r["status"].startswith("ok") for r in rows) or args.dry_run else 1


def cmd_summary(args) -> int:
    if not SUMMARY.is_file():
        sys.exit("no syn/runs/summary.csv yet")
    with SUMMARY.open(newline="") as fh:
        rows = [r for r in csv.DictReader(fh)
                if not args.patterns or any(fnmatch.fnmatchcase(r["point"], p) for p in args.patterns)]
    print_rows(rows)
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    for name in ("list", "run", "summary"):
        p = sub.add_parser(name)
        p.add_argument("patterns", nargs="*", help="globs over <tier>/<kernel>/<point>, e.g. done/vecadd/unopt_*")
        if name == "run":
            p.add_argument("--clock", default=DEFAULT_CLOCK, help=f"clock period in ns (default {DEFAULT_CLOCK})")
            p.add_argument("--cores", type=int, default=16, help="cores per DC run (default 16)")
            p.add_argument("-j", "--jobs", type=int, default=1, help="DC runs at once (each takes a license)")
            p.add_argument("--dry-run", action="store_true", help="print the commands, run nothing")
    args = ap.parse_args()
    if args.cmd == "run" and not args.patterns:
        ap.error("run needs at least one pattern, e.g. done/vecadd/unopt_n512_w8")
    return {"list": cmd_list, "run": cmd_run, "summary": cmd_summary}[args.cmd](args)


if __name__ == "__main__":
    sys.exit(main())
