# ---- project ----------------------------------------------------------
open_project -reset hls_proj
set_top tiny
add_files     src/tiny.cpp
add_files -tb src/tb.cpp

# ---- solution ---------------------------------------------------------
open_solution -reset "solution1" -flow_target vivado
source ../../common/part.tcl
source ./directives.tcl

# ---- run --------------------------------------------------------------
csim_design
csynth_design

close_project
exit