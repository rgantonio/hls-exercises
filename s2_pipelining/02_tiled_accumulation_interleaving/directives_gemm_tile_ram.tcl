# directives_gemm_tile_ram.tcl
set_directive_bind_storage -type ram_2p "gemm_tile" acc
set_directive_pipeline -II 1 "gemm_tile/TCOL"
