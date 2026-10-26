# bench/tier_done/dot/directives_opt.tcl
# opt: W lanes. Each array is split cyclic by W into W one-bank ports (forge's W
# one-bank streamer ports), and the loop handles W elements per cycle at II = 1.
# run_bench.tcl sets $W before sourcing this file. At W = 1 there is nothing to
# split or unroll, so only the pipeline remains.
if {$W > 1} {
    set_directive_array_partition -type cyclic -factor $W -dim 1 "dot" A
    set_directive_array_partition -type cyclic -factor $W -dim 1 "dot" B
    set_directive_unroll -factor $W "dot/DOT"
}
set_directive_pipeline -II 1 "dot/DOT"
