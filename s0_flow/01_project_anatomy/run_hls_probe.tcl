open_project -reset probe_proj
set_top probe
add_files src/probe.cpp

# --- solution A: tool defaults, auto-pipelining active ---------------
open_solution -reset "auto" -flow_target vivado
set_part xcku5p-ffvb676-2-e
create_clock -period 3.33 -name default
csynth_design

# --- solution B: auto-pipelining suppressed --------------------------
open_solution -reset "off" -flow_target vivado
set_part xcku5p-ffvb676-2-e
create_clock -period 3.33 -name default
config_compile -pipeline_loops 0
csynth_design

close_project
exit