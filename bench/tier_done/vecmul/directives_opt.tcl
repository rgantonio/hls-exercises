# bench/tier_done/vecmul/directives_opt.tcl
# opt: one beat per cycle. BEAT is pipelined at II = 1 and the W lanes of a beat
# are unrolled, so all W lanes work in the same cycle. The ports are set to axis
# by run_bench.tcl from params.json, for every case.
set_directive_pipeline -II 1 "vecmul/BEAT"
set_directive_unroll "vecmul/LANE"
