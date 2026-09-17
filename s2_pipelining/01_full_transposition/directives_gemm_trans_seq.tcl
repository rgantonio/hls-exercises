# directives_gemm_trans_seq.tcl
# Same storage as pipe, so that seq -> pipe changes only the pipelining.
set_directive_bind_storage -type ram_2p "gemm_trans" acc
