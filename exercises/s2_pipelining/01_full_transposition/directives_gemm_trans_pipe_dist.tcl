# directives_gemm_trans_pipe_dist.tcl   (fallback, only if pipe fails on acc)
set_directive_bind_storage -type ram_2p "gemm_trans" acc
set_directive_pipeline -II 1 "gemm_trans/COL"
set_directive_dependence -variable acc -type inter -dependent true -distance 32 "gemm_trans/COL"
