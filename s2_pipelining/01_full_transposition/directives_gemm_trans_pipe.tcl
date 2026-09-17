# directives_gemm_trans_pipe.tcl
set_directive_bind_storage -type ram_2p "gemm_trans" acc
set_directive_pipeline -II 1 "gemm_trans/COL"
