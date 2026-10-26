# exercises/s1_model/02_pipeline_blockers/run_hls.tcl
# Run:  vitis_hls -f run_hls.tcl 2>&1 | tee run.log

# ---- knobs ------------------------------------------------------------
# Pass 1 (stage B): every sols list = {seq}, DO_COSIM 0.
# Comment uncomment
# set RUNS {
#     accf_proj {kernel accumulate dtype float sols {seq}}
#     acci_proj {kernel accumulate dtype int   sols {seq}}
#     fir_proj  {kernel fir3       dtype int   sols {seq}}
# }
# set DO_COSIM 0
# Pass 2: full lists below, DO_COSIM 1.
# Comment uncomment
set RUNS {
    accf_proj {kernel accumulate dtype float sols {seq pipe}}
    acci_proj {kernel accumulate dtype int   sols {seq pipe}}
    fir_proj  {kernel fir3       dtype int   sols {seq pipe pipe_auto pipe_2p}}
}
set DO_COSIM 1
# -----------------------------------------------------------------------

foreach {proj cfg} $RUNS {
    set kernel [dict get $cfg kernel]
    set dtype  [dict get $cfg dtype]
    set sols   [dict get $cfg sols]

    open_project -reset $proj
    set_top $kernel
    add_files     src/${kernel}.cpp    -cflags "-DDATA_T=$dtype"
    add_files -tb src/tb_${kernel}.cpp -cflags "-DDATA_T=$dtype"

    set first 1
    foreach sol $sols {
        open_solution -reset $sol -flow_target vivado
        source ../../../common/part.tcl

        set dfile ./directives_${kernel}_${sol}.tcl
        if {[file exists $dfile]} { source $dfile }

        if {$first} { csim_design; set first 0 }
        csynth_design
        if {$DO_COSIM} { cosim_design }
    }
    close_project
}
exit