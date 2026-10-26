# directives_fir3_pipe_2p.tcl
set_directive_pipeline -II 1 "fir3/TAPS"
set_directive_interface -mode ap_memory -storage_type ram_2p "fir3" x