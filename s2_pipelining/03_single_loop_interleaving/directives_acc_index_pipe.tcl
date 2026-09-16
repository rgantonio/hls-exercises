# directives_acc_index_pipe.tcl
# No array_partition: lane stays an array (1R1W LUTRAM), same as pipe_dist,
# so pipe vs pipe_dist differs only by the dependence directive.
set_directive_pipeline -II 1 "acc_index/ACC"
