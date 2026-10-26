# directives_gemm_tile_reg_dist.tcl   (fallback, only if the pass-1 gate fails)
# $T is set by run_hls.tcl before this file is sourced.
set_directive_array_partition -type complete -dim 1 "gemm_tile" acc
set_directive_pipeline -II 1 "gemm_tile/TCOL"
set_directive_dependence -variable acc -type inter -dependent true -distance $T "gemm_tile/TCOL"
