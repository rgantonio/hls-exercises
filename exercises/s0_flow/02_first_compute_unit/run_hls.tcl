# ---- project ----------------------------------------------------------
open_project -reset hls_proj
set_top scale
add_files     src/scale.cpp
add_files -tb src/tb.cpp

# ---- solution ---------------------------------------------------------
open_solution -reset "solution1" -flow_target vivado
source ../../../common/part.tcl
source ./directives.tcl

# ---- run --------------------------------------------------------------
csim_design
csynth_design
cosim_design  -rtl verilog -tool xsim -trace_level none
export_design -format ip_catalog -rtl verilog \
              -vendor "hls-exercises" -library "hls" \
              -display_name "scale" -description "y = a*x + b, 32-bit int" \
              -version "1.0.0"

close_project
exit