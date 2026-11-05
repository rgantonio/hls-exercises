#!/usr/bin/env python3
"""Probes A and B of BAM3: what Bambu can do beyond the `bambu` case on 2024.10 (A) and 2026.11 (B) (docs/BAMBU_PLAN.md, BAM3).

Same flow as bench/bambu.py (RTL only in the container, our testbenches on the host), one build per
(config, kernel, W), at the largest size; both sizes simulated, each with the no-stall and the stall
run. Nothing goes to rtl/ or bambu_cycles.csv: the rows go to results_staging/probe_bam3<a|b>.csv and
the tables to results_staging/probe_bam3<a|b>.md. Scratch in build/probe/ (git-ignored).

Probe A configs (Bambu 2024.10, `bambu`), each on top of the `bambu` case (axis pragmas plus
`#pragma HLS unroll` on LANE):
  a0         the `bambu` case itself (the baseline)
  a1_u<U>    plus `#pragma HLS unroll factor=<U>` on BEAT (U = 2, 4, 8)
  a2_sdc     plus --speculative-sdc-scheduling
  a3_perf    plus --experimental-setup=BAMBU-PERFORMANCE-MP
  a4_u4_sdc  a1_u4 and a2_sdc
  a4_u4_perf a1_u4 and a3_perf

Probe B configs (Bambu 2026.11, `bambu-2026.11` from bench/tools/build_bambu_2611.sh):
  b0         the `bambu` case unchanged; 2026.11 pipelines innermost single-block loops by itself, and
             the `lp` column records its log lines (II per loop, or "not possible")
  b1_init    b0 with the output beat declared with an initial value (`vec_t ..., c = 0;`): the source
             otherwise leaves it uninitialized, and ac_int's set_slc reads the old value of a slice's
             end words, so the result depends on an indeterminate value
  b2_nolp    b0 with loop pipelining turned off (--bambu-parameter=LP-BB-list=0: no loop is eligible)

  python3 bench/bambu_probe.py run [--probe a|b] [--config ...] [--kernel ...] [--w 1 8 32]
                                   [-j N] [--sim-jobs M] [--sim questa|icarus] [--sim-only] [--dry-run]

--sim-only simulates the Verilog already in build/probe/. Standard library only, Python 3.11.
"""
from __future__ import annotations

import argparse
import csv
import datetime
import os
import re
import shlex
import shutil
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import bambu as B  # noqa: E402  (bench/bambu.py)

PROBE = B.BUILD / "probe"
CONFIGS_A = {
    "a0": ([], []),
    "a1_u2": (["unroll factor=2"], []),
    "a1_u4": (["unroll factor=4"], []),
    "a1_u8": (["unroll factor=8"], []),
    "a2_sdc": ([], ["--speculative-sdc-scheduling"]),
    "a3_perf": ([], ["--experimental-setup=BAMBU-PERFORMANCE-MP"]),
    "a4_u4_sdc": (["unroll factor=4"], ["--speculative-sdc-scheduling"]),
    "a4_u4_perf": (["unroll factor=4"], ["--experimental-setup=BAMBU-PERFORMANCE-MP"]),
}
CONFIGS_B = {"b0": ([], []), "b1_init": ([], []), "b2_nolp": ([], ["--bambu-parameter=LP-BB-list=0"])}
BINARY = {"b0": "bambu-2026.11", "b1_init": "bambu-2026.11", "b2_nolp": "bambu-2026.11"}
# Source changes beyond pragmas, per config: b1_init gives the output beat an initial value.
INIT_OUT = re.compile(r"^(\s*vec_t\s.*,\s*)([A-Za-z_]\w*)\s*;\s*$", re.M)
SOURCE_FIX = {"b1_init": "init_out"}  # the Bambu command in the container; default "bambu" (2024.10)
# probe: (configs, output stem, title, default kernels)
PROBES = {"a": (CONFIGS_A, "probe_bam3a", "BAM3 probe A: Bambu 2024.10 configs", ["vecadd", "dot"]),
          "b": (CONFIGS_B, "probe_bam3b", "BAM3 probe B: Bambu 2026.11", ["vecadd", "dot", "relu", "rowsum"])}
CONFIGS, CSV, MD, TITLE = CONFIGS_A, B.RESULTS / "probe_bam3a.csv", B.RESULTS / "probe_bam3a.md", PROBES["a"][2]
LP = re.compile(r"II=(\d+) solution found for loop \(BB(\d+)\)|Loop pipelining not possible for loop \(BB(\d+)\)"
                r"|Iteration latency for function \S+:BB(\d+) = (\d+)")
COLUMNS = ["config", "tier", "kernel", "W", "size", "status", "fail_reason", "cycles", "cycles_done", "beats",
           "cycles_per_beat", "latency", "stall_run", "fsm_states", "reg_bits", "regs", "verilog_lines",
           "bambu_s", "lp", "cycles_2410", "pragmas", "flags", "git", "date"]
REG = re.compile(r"^\s*register_\w+\s*#\(\s*\.BITSIZE_in1\((\d+)\)", re.M)


def pdir(cfg: str, params: dict, w: int) -> Path:
    return PROBE / cfg / params["kernel"] / f"w{w}"


def source(kdir: Path, params: dict, beat: list[str]) -> tuple[str, list[str]]:
    """The `bambu` case's source copy, plus the config's BEAT pragmas on the line after `BEAT:`."""
    text, added = B.source_copy(kdir, params)
    if not beat:
        return text, added
    lines = text.splitlines(keepends=True)
    out, n = [], 0
    for i, ln in enumerate(lines):
        out.append(ln)
        if re.match(r"^\s*BEAT:\s*$", ln):
            if i + 1 >= len(lines) or not re.match(r"^\s*for\s*\(", lines[i + 1]):
                sys.exit(f"{kdir.name}: the BEAT label is not followed by its for loop")
            out += [f"#pragma HLS {p}\n" for p in beat]
            n += 1
    if n != 1:
        sys.exit(f"{kdir.name}: expected one BEAT label, found {n}")
    return "".join(out), added + [f"#pragma HLS {p}" for p in beat]


def build(kdir: Path, params: dict, w: int, cfg: str, dry: bool) -> dict:
    beat, flags = CONFIGS[cfg]
    k, d = params["kernel"], pdir(cfg, params, w)
    text, added = source(kdir, params, beat)
    if SOURCE_FIX.get(cfg) == "init_out":
        text, n = INIT_OUT.subn(r"\1\2 = 0;", text)
        if n != 1:
            sys.exit(f"{k}: b1_init expects one `vec_t ..., <out>;` declaration, found {n}")
        added = added + ["output beat initialized to 0"]
    cmd = B.bambu_cmd(kdir, params, w) + flags
    cmd[1] = BINARY.get(cfg, "bambu")
    name = f"bambu-probe-{cfg.replace('_', '-')}-{k}-w{w}-{os.getpid()}"
    if dry:
        print(f"\n# {cfg} {k} W={w}: {d.relative_to(B.ROOT)}; added: " + "; ".join(added))
        print(f"cd {d} && BAMBU_CONTAINER_NAME={name} {shlex.join(cmd)}")
        return {"status": "dry"}
    if d.exists():
        shutil.rmtree(d)
    d.mkdir(parents=True)
    (d / f"{k}.cpp").write_text(text)
    log = d / "bambu.log"
    t0 = time.time()
    rc = B.run_cmd(cmd, d, log, B.TIMEOUT_S, dict(os.environ, BAMBU_CONTAINER_NAME=name))
    secs = round(time.time() - t0, 1)
    out = log.read_text(errors="replace")
    meta = {"pragmas": " | ".join(added), "flags": " ".join(flags), "bambu_s": secs, "lp": loop_pipelining(out),
            "fsm_states": " ".join(re.findall(r"Number of states:\s*(\d+)", out))}
    (d / "cmd.txt").write_text(shlex.join(cmd) + "\n")
    if rc is None:
        subprocess.run(["podman", "rm", "-f", "-t", "0", name], capture_output=True, check=False)
        return {"status": "failed: timeout", "fail_reason": f"no Verilog within {B.TIMEOUT_S // 60} min", **meta}
    if rc != 0 or not B.verilog_files(d):
        return {"status": "failed: compile", "fail_reason": B.fail_reason_compile(out, w), **meta}
    return {"status": "ok", **meta}


def loop_pipelining(log: str) -> str:
    """2026.11's loop pipelining lines, e.g. "BB2 II=1 lat=2" or "BB5 not possible"; "" when none."""
    bbs: dict[str, str] = {}
    for m in LP.finditer(log):
        if m.group(1):
            bbs[m.group(2)] = f"II={m.group(1)}" + bbs.get(m.group(2), "")
        elif m.group(3):
            bbs[m.group(3)] = "not possible"
        else:
            bbs[m.group(4)] = bbs.get(m.group(4), "") + f" lat={m.group(5)}"
    return "; ".join(f"BB{b} {v.strip()}" for b, v in sorted(bbs.items(), key=lambda x: int(x[0])))


def rtl_facts(d: Path) -> dict:
    files = B.verilog_files(d)
    text = "\n".join(f.read_text(errors="replace") for f in files)
    bits = [int(b) for b in REG.findall(text)]
    log = d / "bambu.log"
    out = log.read_text(errors="replace") if log.is_file() else ""
    states = " ".join(re.findall(r"Number of states:\s*(\d+)", out))
    return {"reg_bits": sum(bits), "regs": len(bits), "verilog_lines": text.count("\n"), "fsm_states": states,
            "lp": loop_pipelining(out)}


def sim(kdir: Path, params: dict, w: int, cfg: str, size: dict, stall: int, simulator: str, dry: bool) -> dict:
    d = pdir(cfg, params, w)
    s = d / f"{B.size_tag(size)}_{'stall' if stall else 'cycles'}"
    files = B.verilog_files(d)
    top = B.top_module(files) or "<top>"
    defs = {"DUT": top, **B.sim_defines(kdir, params, w, size, stall)}
    tbfile = B.TB / f"{params['kernel']}_tb.sv"
    fl = " ".join(str(f) for f in files) or f"{d}/*.v"
    if simulator == "questa":
        dflags = " ".join(f"+define+{n}={v}" for n, v in defs.items())
        cmd = (f"rm -rf work && vlib work > /dev/null && vlog -sv -quiet {dflags} +incdir+{B.TB} {tbfile} {fl} && "
               f"vsim -c -quiet tb -do 'run -all; quit -f' | sed 's/^# //'")
    else:
        dflags = " ".join(f"-D{n}={v}" for n, v in defs.items())
        cmd = f"iverilog -g2012 -I {B.TB} {dflags} -o sim.vvp {tbfile} {fl} && vvp -n sim.vvp"
    if dry:
        print(f"cd {s} && {cmd}")
        return {}
    if s.exists():
        shutil.rmtree(s)
    s.mkdir(parents=True)
    for name, vals in B.vectors(kdir, size).items():
        (s / f"{name}.hex").write_text("".join(format(v & (2**64 - 1), "016x") + "\n" for v in vals))
    log = s / "sim.log"
    B.run_cmd(cmd, s, log)
    text = log.read_text(errors="replace")
    line = next((l for l in text.splitlines() if B.TB_LINE.match(l)), "")
    if not line:
        return {"result": "FAIL", "line": "no PASS/FAIL line: " + B.error_lines(text)}
    r = {"result": line.split()[0], "line": line}
    for f in ("cycles", "cycles_done", "latency"):
        m = re.search(rf"\b{f}=(-?\d+)", line)
        if m:
            r[f] = int(m.group(1))
    return r


def write(rows: list[dict]) -> None:
    base = {}
    if (B.RESULTS / "bambu_cycles.csv").exists():
        with open(B.RESULTS / "bambu_cycles.csv", newline="") as f:
            base = {(r["kernel"], str(r["W"]), r["size"]): r["cycles"] for r in csv.DictReader(f)}
    for r in rows:
        r["cycles_2410"] = base.get((r["kernel"], str(r["W"]), r["size"]), "")
    rows = [{c: r.get(c, "") for c in COLUMNS} for r in rows]  # a failed build has no cycles, stall_run, reg_bits
    key = lambda r: (r["config"], r["kernel"], str(r["W"]), r["size"])  # noqa: E731
    new = {key(r) for r in rows}
    keep = []
    if CSV.exists():
        with open(CSV, newline="") as f:
            keep = [r for r in csv.DictReader(f) if key(r) not in new]
    order = list(CONFIGS)
    allrows = sorted(keep + rows, key=lambda r: (r["kernel"], int(r["W"]), r["size"],
                                                 order.index(r["config"]) if r["config"] in order else 99))
    CSV.parent.mkdir(parents=True, exist_ok=True)
    with open(CSV, "w", newline="") as f:
        wr = csv.DictWriter(f, fieldnames=COLUMNS, extrasaction="ignore")
        wr.writeheader()
        wr.writerows(allrows)
    # Tables: per kernel and W, configs as rows, at the largest size.
    lines = [f"# {TITLE}", "",
             f"Written by `bench/bambu_probe.py` from `{CSV.name}`. Each config is the `bambu` case plus its "
             "change; cycles from our testbench (start pulse to last output, no stalls) at the largest size, with "
             "cycles per beat; `stall` is the random-stall, two-task run at both sizes; `reg bits` sums Bambu's "
             "register instances; `2024.10` is the `bambu` case's cycles from `bambu_cycles.csv`; `loop pipelining` "
             "is Bambu's log (2026.11 only).", ""]
    for k in sorted({r["kernel"] for r in allrows}):
        for w in sorted({int(r["W"]) for r in allrows if r["kernel"] == k}):
            rs = [r for r in allrows if r["kernel"] == k and int(r["W"]) == w]
            big = max({r["size"] for r in rs}, key=lambda s: [int(x) for x in re.findall(r"\d+", s)])
            lines += [f"## {k}, W = {w} ({big})", "",
                      "| config | status | cycles | cycles/beat | 2024.10 | stall | FSM states | reg bits | loop pipelining | Bambu s |",
                      "|---|---|---|---|---|---|---|---|---|---|"]
            for c in order:
                big_r = next((r for r in rs if r["config"] == c and r["size"] == big), None)
                if not big_r:
                    continue
                stall = "/".join(r["stall_run"] or "-" for r in rs if r["config"] == c)
                lines.append(f"| {c} | {big_r['status']} | {big_r['cycles'] or '-'} | {big_r['cycles_per_beat'] or '-'} "
                             f"| {big_r['cycles_2410'] or '-'} | {stall} | {big_r['fsm_states'] or '-'} | {big_r['reg_bits'] or '-'} "
                             f"| {big_r['lp'] or '-'} | {big_r['bambu_s'] or '-'} |")
            lines.append("")
    MD.write_text("\n".join(lines))


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    r = sub.add_parser("run")
    r.add_argument("--probe", choices=list(PROBES), default="a")
    r.add_argument("--config", nargs="+", choices=list(CONFIGS_A) + list(CONFIGS_B))
    r.add_argument("--kernel", nargs="+")
    r.add_argument("--w", nargs="+", type=int, default=[1, 8, 32])
    r.add_argument("-j", "--jobs", type=int, default=os.cpu_count() or 1)
    r.add_argument("--sim-jobs", type=int, default=0)
    r.add_argument("--sim", choices=["questa", "icarus"], default="questa")
    r.add_argument("--sim-only", action="store_true")
    r.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()
    global CONFIGS, CSV, MD, TITLE
    CONFIGS, stem, TITLE, kernels = PROBES[args.probe]
    CSV, MD = B.RESULTS / f"{stem}.csv", B.RESULTS / f"{stem}.md"
    args.config = args.config or list(CONFIGS)
    args.kernel = args.kernel or kernels
    if set(args.config) - set(CONFIGS):
        sys.exit(f"probe {args.probe} has configs {', '.join(CONFIGS)}")

    pts = []
    for kdir, params in B.load_kernels(None, args.kernel):
        for w in args.w:
            if w not in params["W"]:
                continue
            sizes = [s for s in params["sizes"] if B.valid(params, s, w)]
            for c in args.config:
                pts.append((kdir, params, w, c, sizes))
    if args.dry_run:
        for kdir, params, w, c, sizes in pts:
            if not args.sim_only:
                build(kdir, params, w, c, True)
            for s in sizes:
                for st in (0, 1):
                    sim(kdir, params, w, c, s, st, args.sim, True)
        print(f"\n# {len(pts)} builds, {sum(2 * len(p[4]) for p in pts)} simulations")
        return
    if not args.sim_only and subprocess.run(["podman", "image", "exists", B.IMAGE]).returncode != 0:
        sys.exit(f"podman image {B.IMAGE} not found")
    meta = {"git": B.git_rev(), "date": datetime.date.today().isoformat()}
    if args.sim_only:
        builds = [{"status": "ok" if B.verilog_files(pdir(c, p, w)) else "failed: compile",
                   "fail_reason": "" if B.verilog_files(pdir(c, p, w)) else "no Verilog in build/probe",
                   "pragmas": "", "flags": " ".join(CONFIGS[c][1]), "bambu_s": ""} for _, p, w, c, _ in pts]
    else:
        with ThreadPoolExecutor(args.jobs) as ex:
            builds = list(ex.map(lambda p: build(p[0], p[1], p[2], p[3], False), pts))
    for (kdir, params, w, c, sizes), b in zip(pts, builds):
        print(f"build {c} {params['kernel']} W={w}: {b['status']} {b.get('fail_reason', '')[:200]}", flush=True)
    sims = [(kdir, params, w, c, s, st) for (kdir, params, w, c, sizes), b in zip(pts, builds) if b["status"] == "ok"
            for s in sizes for st in (0, 1)]
    with ThreadPoolExecutor(args.sim_jobs or args.jobs) as ex:
        res = list(ex.map(lambda p: sim(*p, args.sim, False), sims))
    got = {(p[1]["kernel"], p[2], p[3], B.size_tag(p[4]), p[5]): r for p, r in zip(sims, res)}
    rows = []
    for (kdir, params, w, c, sizes), b in zip(pts, builds):
        facts = rtl_facts(pdir(c, params, w)) if b["status"] == "ok" else {}
        for s in sizes:
            tag = B.size_tag(s)
            cy, stl = got.get((params["kernel"], w, c, tag, 0), {}), got.get((params["kernel"], w, c, tag, 1), {})
            row = {"config": c, "tier": params["tier"], "kernel": params["kernel"], "W": w, "size": tag,
                   "beats": B.elems(s) // w, **meta, **{k: b.get(k, "") for k in ("pragmas", "flags", "bambu_s")},
                   **facts}
            row["lp"] = facts.get("lp") or b.get("lp", "")
            row["fsm_states"] = facts.get("fsm_states") or b.get("fsm_states", "")
            if b["status"] != "ok":
                row.update(status=b["status"], fail_reason=b.get("fail_reason", ""))
            elif cy.get("result") == "PASS":
                row.update(cycles=cy["cycles"], cycles_done=cy.get("cycles_done", ""), latency=cy.get("latency", ""),
                           cycles_per_beat=f"{cy['cycles'] / row['beats']:.2f}", stall_run=stl.get("result", ""))
                row["status"] = "ok" if stl.get("result") == "PASS" else "failed: stall"
                if row["status"] != "ok":
                    row["fail_reason"] = stl.get("line", "")
            else:
                row.update(status="failed: sim", fail_reason=cy.get("line", ""), stall_run=stl.get("result", ""))
            rows.append(row)
            print(f"{c} {row['kernel']} W={w} {tag}: {row['status']} cycles {row.get('cycles', '-')} "
                  f"({row.get('cycles_per_beat', '-')}/beat) states {row['fsm_states'] or '-'} "
                  f"reg bits {row.get('reg_bits', '-')} {row.get('fail_reason', '')[:200]}", flush=True)
    write(rows)
    print(f"wrote {CSV.relative_to(B.ROOT)} and {MD.relative_to(B.ROOT)}: "
          f"{sum(r['status'] == 'ok' for r in rows)} of {len(rows)} rows ok")


if __name__ == "__main__":
    main()
