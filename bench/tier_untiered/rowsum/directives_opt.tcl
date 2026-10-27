# bench/tier_untiered/rowsum/directives_opt.tcl
# opt: one beat per cycle. BEAT is pipelined at II = 1 and the W lanes of a beat
# are unrolled, so all W lanes work in the same cycle (an adder tree into one accumulator).
# The ports are set to axis by run_bench.tcl from params.json, for every case.
set_directive_pipeline -II 1 "rowsum/BEAT"
set_directive_unroll "rowsum/LANE"
