# S1.1 — latency, II, and C = L + I(N-1)

set CSIM   1
set CSYNTH 1
set COSIM  1

# ---------- project 1: fixed trip count, top = vec_scale ----------
open_project -reset hls_proj
set_top vec_scale
add_files     src/vec_scale.cpp
add_files -tb src/tb.cpp

foreach sol {seq pipe pipe_ii2} {
    open_solution -reset $sol -flow_target vivado
    source ../../../common/part.tcl
    source ./directives_$sol.tcl

    if {$CSIM && $sol eq "seq"} { csim_design }
    if {$CSYNTH}                { csynth_design }
    if {$COSIM}                 { cosim_design -trace_level none }
}
close_project

# ---------- project 2: runtime trip count, top = vec_scale_n ----------
open_project -reset tc_proj
set_top vec_scale_n
add_files     src/vec_scale_n.cpp
add_files -tb src/tb_n.cpp

foreach sol {notc tc} {
    open_solution -reset $sol -flow_target vivado
    source ../../../common/part.tcl
    source ./directives_$sol.tcl
    csynth_design
}
close_project

exit