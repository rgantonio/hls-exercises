################################
# Derive some default settings #
################################

#-----------------------------
# Set design rules
#-----------------------------

# Setting as low as possible is nice for high speed
set_max_transition 0.25 [current_design]

# Lower fanout means less delay on critical paths
set_max_fanout 32 [current_design]

#-----------------------------
# Declare clocks
#-----------------------------
create_clock -period 10 [get_ports clk_i]

#-----------------------------
# Setup and hold time uncertainties
#-----------------------------

# Set between 0.05 and 0.2
set_clock_uncertainty 0.1 -setup [get_clocks clk_i]

# Set between 0.05 and 0.1
set_clock_uncertainty 0.02 -hold [get_clocks clk_i]

#-----------------------------
# IO constraints
#-----------------------------

# Get from the FreePDK45nm
set_driving_cell -lib_cell INVX4 [all_inputs]

# Set some generic.
set_load 0.03 [all_outputs]

set_input_delay -max 0.01 -clock clk_i [all_inputs]
set_output_delay -max 0.01 -clock clk_i  [all_outputs]

