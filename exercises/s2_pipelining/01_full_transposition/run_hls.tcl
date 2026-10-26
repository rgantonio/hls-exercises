# exercises/s2_pipelining/01_full_transposition/run_hls.tcl
# Run:  vitis_hls -f run_hls.tcl 2>&1 | tee run.log
# Extras without editing this file:
#   ONLY="noflat_proj naive_int_proj" DO_COSIM=0 vitis_hls -f run_hls.tcl 2>&1 | tee run_extras.log

# ---- knobs ------------------------------------------------------------
# Main run: ONLY {naive_proj trans_proj}, DO_COSIM 1.
# Environment variables ONLY and DO_COSIM override these.
set ONLY     {naive_proj trans_proj}
set DO_COSIM 1
if {[info exists ::env(ONLY)]}     { set ONLY     $::env(ONLY) }
if {[info exists ::env(DO_COSIM)]} { set DO_COSIM $::env(DO_COSIM) }

# cosim = solutions that also run cosim_design when DO_COSIM is 1
set RUNS {
    naive_proj     {top gemm_naive tb tb_gemm dtype float sols {seq pipe}    cosim {pipe}}
    trans_proj     {top gemm_trans tb tb_gemm dtype float sols {seq pipe}    cosim {pipe}}
    noflat_proj    {top gemm_trans tb tb_gemm dtype float sols {pipe_noflat} cosim {}}
    naive_int_proj {top gemm_naive tb tb_gemm dtype int   sols {pipe}        cosim {}}
    dist_proj      {top gemm_trans tb tb_gemm dtype float sols {pipe_dist}   cosim {pipe_dist}}
}
# Extras live in their own projects, because open_project -reset wipes every solution.
#   noflat_proj:    extra 5.5a
#   naive_int_proj: extra 5.5b
#   dist_proj:      fallback only, if trans_proj/pipe misses II = 1 on acc (not needed on 2023.2.2)
# -----------------------------------------------------------------------

foreach {proj cfg} $RUNS {
    if {[llength $ONLY] > 0 && [lsearch -exact $ONLY $proj] < 0} { continue }

    set top   [dict get $cfg top]
    set tb    [dict get $cfg tb]
    set dtype [dict get $cfg dtype]
    set sols  [dict get $cfg sols]
    set cosim [dict get $cfg cosim]

    set cflags "-DDATA_T=$dtype"

    open_project -reset $proj
    set_top $top
    add_files     src/${top}.cpp -cflags $cflags
    add_files -tb src/${tb}.cpp  -cflags "$cflags -DUSE_$top"

    set first 1
    foreach sol $sols {
        open_solution -reset $sol -flow_target vivado
        source ../../../common/part.tcl

        set dfile ./directives_${top}_${sol}.tcl
        if {[file exists $dfile]} { source $dfile }

        if {$first} { csim_design; set first 0 }
        csynth_design
        if {$DO_COSIM && [lsearch -exact $cosim $sol] >= 0} { cosim_design }
    }
    close_project
}
exit
