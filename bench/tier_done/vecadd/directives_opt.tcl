# bench/tier_done/vecadd/directives_opt.tcl
# opt: W lanes. Each array is split cyclic by W into W ports, one bank each
# (forge's W one-bank streamer ports), and the loop runs W elements per cycle.
# run_bench.tcl sets $W before sourcing this file.
set_directive_array_partition -type cyclic -factor $W -dim 1 "vecadd" A
set_directive_array_partition -type cyclic -factor $W -dim 1 "vecadd" B
set_directive_array_partition -type cyclic -factor $W -dim 1 "vecadd" C
set_directive_unroll -factor $W "vecadd/ADD"
set_directive_pipeline -II 1 "vecadd/ADD"
