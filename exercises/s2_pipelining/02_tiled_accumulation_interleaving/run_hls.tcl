# exercises/s2_pipelining/02_tiled_accumulation_interleaving/run_hls.tcl
# Run:       vitis_hls -f run_hls.tcl 2>&1 | tee run_pass1.log
# Override:  ONLY="tile_t8_proj" DO_COSIM=1 vitis_hls -f run_hls.tcl 2>&1 | tee run_cosim.log

# ---- knobs ------------------------------------------------------------
# Pass 1 (stage B): ONLY {base_proj tile_t32_proj}                          DO_COSIM 0
# Pass 2 (sweep):   ONLY {tile_t1_proj tile_t2_proj tile_t4_proj
#                         tile_t8_proj tile_t16_proj}                        DO_COSIM 0
# Pass 3 (cosim):   ONLY {tile_t8_proj}                                     DO_COSIM 1
# Extras:           ONLY {bigm_t1024_proj bigm_t16_proj tshift_t8_proj}     DO_COSIM 0
set ONLY     {base_proj tile_t32_proj}
set DO_COSIM 0
if {[info exists ::env(ONLY)]}     { set ONLY     $::env(ONLY) }
if {[info exists ::env(DO_COSIM)]} { set DO_COSIM $::env(DO_COSIM) }

set DTYPE float

# M is the matrix width (GEMM_M). T {} means the kernel does not take TILE_T.
set RUNS {
    base_proj       {top gemm_naive  M 32   T {}   sols {pipe}             cosim {}}
    tile_t1_proj    {top gemm_tile   M 32   T 1    sols {reg reg_prod}     cosim {}}
    tile_t2_proj    {top gemm_tile   M 32   T 2    sols {ram reg}          cosim {}}
    tile_t4_proj    {top gemm_tile   M 32   T 4    sols {ram reg reg_dist} cosim {}}
    tile_t8_proj    {top gemm_tile   M 32   T 8    sols {ram reg}          cosim {ram reg}}
    tile_t16_proj   {top gemm_tile   M 32   T 16   sols {ram reg}          cosim {}}
    tile_t32_proj   {top gemm_tile   M 32   T 32   sols {ram reg reg_dist} cosim {}}
    bigm_t1024_proj {top gemm_tile   M 1024 T 1024 sols {ram}              cosim {}}
    bigm_t16_proj   {top gemm_tile   M 1024 T 16   sols {ram}              cosim {}}
    tshift_t8_proj  {top gemm_tshift M 32   T 8    sols {reg}              cosim {}}
}
# Tcl does not allow comments inside the braces above, so the notes are here:
#   tile_t1_proj reg_prod:   blocker 4; the TCOL directive is dropped at T = 1, so PROD is pipelined
#   tile_t32_proj reg_dist:  the pass-1 gate fallback (it did not help, see 5.1)
#   tile_t4_proj reg_dist:   extra 5.5b
#   bigm_*_proj:             extra 5.5a (M = 1024)
#   tshift_t8_proj:          extra 5.5c (shift-register tile buffer)
# -----------------------------------------------------------------------

foreach {proj cfg} $RUNS {
    if {[llength $ONLY] > 0 && [lsearch -exact $ONLY $proj] < 0} { continue }

    set top   [dict get $cfg top]
    set M     [dict get $cfg M]
    set T     [dict get $cfg T]
    set sols  [dict get $cfg sols]
    set cosim [dict get $cfg cosim]

    set cflags "-DDATA_T=$DTYPE -DGEMM_M=$M"
    if {$T ne ""} { append cflags " -DTILE_T=$T" }

    open_project -reset $proj
    set_top $top
    add_files     src/${top}.cpp   -cflags $cflags
    add_files -tb src/tb_gemm.cpp  -cflags "$cflags -DUSE_$top"

    set first 1
    foreach sol $sols {
        open_solution -reset $sol -flow_target vivado
        source ../../../common/part.tcl

        # Directive files may use $T (reg_dist does).
        set dfile ./directives_${top}_${sol}.tcl
        if {[file exists $dfile]} { source $dfile }

        if {$first} { csim_design; set first 0 }
        csynth_design
        if {$DO_COSIM && [lsearch -exact $cosim $sol] >= 0} { cosim_design }
    }
    close_project
}
exit
