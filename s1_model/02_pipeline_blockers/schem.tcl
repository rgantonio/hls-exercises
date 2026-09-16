# schem.tcl
# vivado -mode batch -source schem.tcl -tclargs fir_proj/pipe fir3
set sol [lindex $argv 0]
set top [lindex $argv 1]
read_verilog [glob $sol/syn/verilog/*.v]
synth_design -rtl -top $top -part xcku5p-ffvb676-2-e
# Line below only works when available
# write_schematic -format pdf -force $sol/${top}_rtl.pdf
start_gui