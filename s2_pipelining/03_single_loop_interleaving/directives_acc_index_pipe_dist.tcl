# directives_acc_index_pipe_dist.tcl
# No array_partition: a complete partition turns lane[c] into registers named
# mux_case_0..K-1, and set_directive_dependence -variable lane then silently
# matches nothing (II stays 7). Kept as an array, the directive applies.
set_directive_pipeline -II 1 "acc_index/ACC"
set_directive_dependence -variable lane -type inter -dependent true -distance $K "acc_index/ACC"
