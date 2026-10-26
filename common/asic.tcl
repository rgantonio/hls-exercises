# common/asic.tcl
# Settings for the bench/ runs: RTL that stays portable to an ASIC flow.
# Sourced by bench/run_bench.tcl right after open_solution.
# The exercises keep using common/part.tcl; this file never changes their numbers.
#
# Environment:
#   CLOCK_NS   clock period in ns (default 3.33, the repo's 300 MHz)

# Same part as the exercises. Vitis still schedules with this part's delays,
# so the cycle counts belong to the clock given here (docs/HLS_VS_FORGE.md, 3.3).
set_part xcku5p-ffvb676-2-e

set clk 3.33
if {[info exists ::env(CLOCK_NS)]} { set clk $::env(CLOCK_NS) }
create_clock -period $clk -name default

# Repo baseline (env.md, probe D): nothing is pipelined unless a case's
# directives ask for it.
config_compile -pipeline_loops 0

# No automatic complete partitioning of small arrays: every partition is a
# directive we wrote.
config_array_partition -complete_threshold 0

# Multipliers in fabric: plain `*` with pipeline registers in the Verilog,
# no DSP48 inference. Check `help config_op` on the first run.
config_op mul -impl fabric
