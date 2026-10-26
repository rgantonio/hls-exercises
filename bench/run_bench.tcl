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
#   DIRECTIVES  directives file to source, absolute path, or empty
#   W           lane count for the directives (empty when the case has none)
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
add_files -tb $::env(TB) -cflags "$cflags -DDUT=$top"

open_solution -reset sol -flow_target vivado
source [file join $here .. common asic.tcl]
if {$directives ne ""} { source $directives }

if {$do_csim}  { csim_design }
csynth_design
if {$do_cosim} { cosim_design -trace_level none }

close_project
exit
