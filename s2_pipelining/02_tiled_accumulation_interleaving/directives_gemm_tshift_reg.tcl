# directives_gemm_tshift_reg.tcl   (extra 5.5c)
set_directive_array_partition -type complete -dim 1 "gemm_tshift" acc
set_directive_pipeline -II 1 "gemm_tshift/TCOL"
