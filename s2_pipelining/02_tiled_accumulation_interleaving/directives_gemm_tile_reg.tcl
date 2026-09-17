# directives_gemm_tile_reg.tcl
set_directive_array_partition -type complete -dim 1 "gemm_tile" acc
set_directive_pipeline -II 1 "gemm_tile/TCOL"
