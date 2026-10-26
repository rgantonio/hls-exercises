# directives_gemm_tile_reg_prod.tcl   (T = 1 only, blocker 4)
# With TILE_T = 1 the one-trip TCOL is removed before the pipeline directive
# on gemm_tile/TCOL is applied, silently. PROD is the same work at T = 1.
set_directive_array_partition -type complete -dim 1 "gemm_tile" acc
set_directive_pipeline -II 1 "gemm_tile/PROD"
