# syn

ASIC synthesis of the bench points with Design Compiler on FreePDK45 (OSU `gscl45nm`). The input is Vitis's Verilog of one point in `rtl/`, nothing else: no FPGA flow, no Vitis needed.

## Setup

- `dc_shell` on the path, or `DC_SHELL=/path/to/dc_shell`.
- FreePDK45 next to hls-exercises, so the library is at `../FreePDK45/osu_soc/lib/files/gscl45nm.db` from the repo root. Elsewhere: `SYN_LIB=/path/to/gscl45nm.db`.

## Run

A point is named `<tier>/<kernel>/<point>`, the folder under `rtl/` (for example `done/vecadd/unopt_n512_w8`). Patterns are shell globs over those names; quote them.

```bash
python3 syn/syn.py list 'done/vecadd/*'                       # the points a pattern picks
python3 syn/syn.py run done/vecadd/unopt_n512_w8 --dry-run    # print the commands only
python3 syn/syn.py run done/vecadd/unopt_n512_w8              # one point at 10 ns
python3 syn/syn.py run 'done/*/opt_n512_w8' --clock 5 -j 2    # several, 2 DC runs at once
python3 syn/syn.py summary                                    # every run so far
```

`--clock` is the ASIC clock period in ns (default 10). `--cores` is the cores per DC run (default 16). `-j` is the number of DC runs at once, each of which holds a license.

## What a run leaves

Everything stays in `syn/runs/`, which git ignores:

```
syn/runs/<tier>/<kernel>/<point>[_c<clock>]/   (clock tag only when not 10 ns)
  WORK/            DC's work library
  logs/            dc_shell.log, dc_stdout.log, check_design.log
  reports/         qor, area, area_hierarchy, timing, constraint_setup, power, power_hierarchy, ...
  out/             <top>_mapped.v, .ddc, .sdf, .sdc
syn/runs/summary.csv   one row per point and clock: area, cells, critical path, slack, power
```

## Files

| File | What it is |
|---|---|
| `syn.py` | The driver: picks points, sets the environment, runs DC in the point's run folder, reads the reports into `summary.csv` |
| `scripts/dc_syn.tcl` | One DC run: reads the point's `filelist.f`, links against `gscl45nm.db` and DesignWare, `compile_ultra -no_autoungroup`, writes reports and the mapped netlist |
| `scripts/constraints.sdc` | Clock on `ap_clk` at `$clock_ns`, uncertainties, `INVX4` input drive, output load, small IO delays |

## The filelist

`bench/bench.py` writes `filelist.f` into every point folder in `rtl/`. It holds the top module on a `# top:` line, then the Verilog files relative to the folder, the top's own file last. Any tool can read it:

```
# top: vecadd
vecadd_regslice_both.v
vecadd.v
```
