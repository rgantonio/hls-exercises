# exercises/s0_flow/04_interfaces/run_hls.tcl
open_project -reset iface_proj
set_top iface
add_files     src/iface.cpp -cflags "-I./src"
add_files -tb src/tb.cpp    -cflags "-I./src"

# --- solution 1: tool defaults. The only solution that runs csim. --------
open_solution -reset "default" -flow_target vivado
source ../../../common/part.tcl
csim_design
csynth_design

# --- solutions 2..7: same source, different interface directives --------
foreach sol {ctrl_chain ctrl_none axilite fifo maxi scalar_vld} {
  open_solution -reset $sol -flow_target vivado
  source ../../../common/part.tcl
  source ./directives_$sol.tcl
  csynth_design
}

close_project