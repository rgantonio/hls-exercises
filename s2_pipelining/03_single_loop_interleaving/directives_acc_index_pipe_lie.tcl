# directives_acc_index_pipe_lie.tcl
# No array_partition, for the same reason as pipe_dist.
set_directive_pipeline -II 1 "acc_index/ACC"
set_directive_dependence -variable lane -type inter -dependent true -distance 10 "acc_index/ACC"
