# exercises/s2_pipelining/03_single_loop_interleaving/run_hls.tcl
# Run:  vitis_hls -f run_hls.tcl 2>&1 | tee run.log

# ---- knobs ------------------------------------------------------------
# Pass 1 (stage B): ONLY=base_proj DO_COSIM=0
# Pass 2:           the defaults below (main projects, with cosim)
# Extras (5.5):     ONLY="index_k4_proj comb_k10_proj" DO_COSIM=1
# Environment variables ONLY and DO_COSIM override these.
set ONLY     {base_proj shift_k1_proj shift_k2_proj shift_k4_proj shift_k7_proj shift_k10_proj index_k10_proj}
set DO_COSIM 1
if {[info exists ::env(ONLY)]}     { set ONLY     $::env(ONLY) }
if {[info exists ::env(DO_COSIM)]} { set DO_COSIM $::env(DO_COSIM) }

# K     = number of lanes (0 for the untransformed kernel)
# cosim = solutions that also run cosim_design when DO_COSIM is 1
set RUNS {
    base_proj      {top accumulate tb tb_accumulate K 0  sols {seq pipe}       cosim {pipe}}
    shift_k1_proj  {top acc_shift  tb tb_acc_il     K 1  sols {pipe}           cosim {}}
    shift_k2_proj  {top acc_shift  tb tb_acc_il     K 2  sols {pipe}           cosim {}}
    shift_k4_proj  {top acc_shift  tb tb_acc_il     K 4  sols {pipe}           cosim {}}
    shift_k7_proj  {top acc_shift  tb tb_acc_il     K 7  sols {pipe}           cosim {pipe}}
    shift_k10_proj {top acc_shift  tb tb_acc_il     K 10 sols {pipe}           cosim {pipe}}
    index_k10_proj {top acc_index  tb tb_acc_il     K 10 sols {pipe pipe_dist} cosim {pipe_dist}}
    index_k4_proj  {top acc_index  tb tb_acc_il     K 4  sols {pipe_lie}       cosim {pipe_lie}}
    comb_k10_proj  {top acc_shift  tb tb_acc_il     K 10 sols {pipe_comb}      cosim {}}
}
# Extras live in their own projects, because open_project -reset wipes every solution.
#   index_k4_proj: extra 5.5a (false distance promise)
#   comb_k10_proj: extra 5.5b (COMBINE pipelined)
# -----------------------------------------------------------------------

foreach {proj cfg} $RUNS {
    if {[llength $ONLY] > 0 && [lsearch -exact $ONLY $proj] < 0} { continue }

    set top   [dict get $cfg top]
    set tb    [dict get $cfg tb]
    set K     [dict get $cfg K]
    set sols  [dict get $cfg sols]
    set cosim [dict get $cfg cosim]

    if {$top eq "accumulate"} {
        set cflags "-DDATA_T=float"
    } else {
        set cflags "-DK=$K"
    }

    open_project -reset $proj
    set_top $top
    add_files     src/${top}.cpp -cflags $cflags
    add_files -tb src/${tb}.cpp  -cflags "$cflags -DUSE_$top"

    set first 1
    foreach sol $sols {
        open_solution -reset $sol -flow_target vivado
        source ../../../common/part.tcl

        # Directive files are sourced in this scope, so they can use $K.
        set dfile ./directives_${top}_${sol}.tcl
        if {[file exists $dfile]} { source $dfile }

        if {$first} { csim_design; set first 0 }
        csynth_design
        if {$DO_COSIM && [lsearch -exact $cosim $sol] >= 0} { cosim_design }
    }
    close_project
}
exit
