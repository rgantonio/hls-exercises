#-----------------------------
# Setting up multiple cores
#-----------------------------

# This sets the max number of cores to be used
set_host_options -max_cores 16

# Need to enable these variables
# To ensure that the cores run in parallel
set disable_multicore_resource_checks true
set dcnxt_adaptive_multithreading true

#-----------------------------
# Defines the work path and directories
#-----------------------------
set target_design "insert name here"

#-----------------------------
# Defines the work path and directories
#-----------------------------
# Make sure to run this on hls-exercises/syn directory
set current_dir [pwd]
puts "Current directory: $current_dir"

# Dump work stuff in hls-exercises/syn/syn-work
define_design_lib WORK -path syn-work

# FreePDK 45nm should be on the same level of hls-exercises
set lib45nm_lib "../../FreePDK45/osu_soc/lib/files/gscl45nm.db"

# Set other dirs
set log_dir "logs"
set out_dir "out"

set search_path "$search_path ./"

#-----------------------------
# Add logic library
#-----------------------------
set target_library [$lib45nm_lib]
set link_library "* $target_library"

#-----------------------------
# Add logic library
#-----------------------------
source "insert source filelist here"
elaborate $target_design
current_design $target_design
link

check_design > $log_dir/check_($target_design)_design.log

#-----------------------------
# Add constraints
#-----------------------------
source $current_dir/scripts/constraints.sdc

#-----------------------------
# Compile
#-----------------------------
compile_ultra -no_autoungroup


#-----------------------------
# Reports
#-----------------------------
report_qor -significant_digits 5 > $report_dir_path/qor.rpt
report_area -hierarchy -nosplit > $report_dir_path/area_hierarchy.rpt
report_constraint -all_violators -nosplit -verbose -significant_digits 5 -max_delay > $report_dir_path/constraint_report_setup.rpt
report_power -hierarchy > $report_dir_path/power_report_hierarchy.rpt
report_power -verbose -hierarchy > $report_dir_path/power_report_verbose_hierarchy.rpt

#-----------------------------
# Outputs
#-----------------------------
write_file -format verilog -hierarchy -output $output_dir_path/snax_hypercorex_cluster_wrapper_mapped.v
write_file -format ddc -hierarchy -output $output_dir_path/snax_hypercorex_cluster_wrapper_mapped.ddc
write_sdf $output_dir_path/snax_hypercorex_cluster_wrapper_mapped.sdf
write_sdc $output_dir_path/snax_hypercorex_cluster_wrapper_mapped.sdc
