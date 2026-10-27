# bench/run_bench.tcl
# One Vitis HLS run: one project, one solution `sol`. bench/bench.py calls it
# with the working directory set to the kernel's folder and everything else
# in the environment, so this file never changes per kernel.
#
# Manual use (from a kernel folder, e.g. bench/tier_done/vecadd):
#   python3 ../../bench.py run --kernel vecadd --case unopt --dry-run
# prints the exact environment and command for each point.
#
# Environment (all set by bench.py):
#   PROJ        project directory, e.g. opt_n64_w4_c3p33_proj
#   TOP         top function
#   SRCS        design sources, space-separated, absolute paths
#   TB          testbench source, absolute path
#   CFLAGS      flags for design and testbench (-DDATA_T=..., -DSIZE_N=..., -I...)
#   TB_CFLAGS   flags for the testbench only: the run-time pins' values
#               (-DCFG_LOOP_COUNT=..., from params.json's "config")
#   PINS        the run-time pins (params.json "config"), space-separated: each gets an
#               ap_vld interface (data plus a valid bit). Vitis keeps it in a register
#               loaded while ap_vld is high; the driver pulses ap_vld for one cycle with
#               the accepted start, as forge's blocks load their config on io.start
#               (ctrl.fire, one cycle). docs/HLS_VS_FORGE.md section 2.
#   TRIPCOUNT   loop=trips pairs, space-separated (e.g. BEAT=16): a loop bounded by a
#               run-time pin gets set_directive_loop_tripcount at that value, so the
#               csynth estimate is for this size. It changes no hardware.
#   DIRECTIVES  directives file to source, absolute path, or empty
#   W           lane count for the directives (empty when the case has none)
#   AXIS        top-level arguments to give an axis interface, space-separated
#   AXIS_REGMODE  register slices on those ports: off, forward, reverse or both
#                 (Vitis's default is both; the bench uses off, as forge's units have none)
#   DO_CSIM     1 = run csim_design
#   DO_COSIM    1 = run cosim_design
#   CLOCK_NS    read by common/asic.tcl

foreach v {PROJ TOP SRCS TB CFLAGS} {
    if {![info exists ::env($v)] || $::env($v) eq ""} {
        puts "run_bench.tcl: environment variable $v is not set"
        exit 2
    }
}

proc env_or {name default} {
    if {[info exists ::env($name)]} { return $::env($name) }
    return $default
}

set here       [file dirname [file normalize [info script]]]
set proj       $::env(PROJ)
set top        $::env(TOP)
set cflags     $::env(CFLAGS)
set directives [env_or DIRECTIVES ""]
set do_csim    [env_or DO_CSIM 1]
set do_cosim   [env_or DO_COSIM 1]
# Directives files read $W, e.g. set_directive_unroll -factor $W "vecadd/LOOP".
set W          [env_or W ""]

open_project -reset $proj
set_top $top
foreach f $::env(SRCS) { add_files $f -cflags $cflags }
add_files -tb $::env(TB) -cflags "$cflags [env_or TB_CFLAGS {}] -DDUT=$top"

open_solution -reset sol -flow_target vivado
source [file join $here .. common asic.tcl]
# Valid-ready ports, as forge's units have: each listed array argument becomes one
# AXI4-Stream port (TDATA, TVALID, TREADY), read or written once, in order.
set regmode [env_or AXIS_REGMODE both]
foreach port [env_or AXIS ""] { set_directive_interface -mode axis -register_mode $regmode $top $port }
# Run-time pins: data plus a valid bit, read once per run. ap_none -register (35ecc92) gave a
# register that reloads every cycle, so a pin changed mid-run still moved the loop bound.
foreach pin [env_or PINS ""] { set_directive_interface -mode ap_vld $top $pin }
if {$directives ne ""} { source $directives }
foreach pair [env_or TRIPCOUNT ""] {
    lassign [split $pair =] loop trips
    set_directive_loop_tripcount -min $trips -max $trips -avg $trips "$top/$loop"
}

if {$do_csim}  { csim_design }
csynth_design
if {$do_cosim} { cosim_design -trace_level none }

close_project
exit
