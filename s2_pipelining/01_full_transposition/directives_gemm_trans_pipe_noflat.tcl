# directives_gemm_trans_pipe_noflat.tcl   (extra 5.5a)
set_directive_bind_storage -type ram_2p "gemm_trans" acc
set_directive_pipeline -II 1 "gemm_trans/COL"
set_directive_loop_flatten -off "gemm_trans/COL"
