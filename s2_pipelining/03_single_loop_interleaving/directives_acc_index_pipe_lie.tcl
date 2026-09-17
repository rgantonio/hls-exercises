# directives_acc_index_pipe_lie.tcl
# K = 4 is small enough that Vitis partitions lane into registers on its own
# (XFORM 203-102), which silently drops the dependence directive. -off keeps
# lane an array, so the false distance actually reaches the scheduler.
set_directive_array_partition -off "acc_index" lane
set_directive_pipeline -II 1 "acc_index/ACC"
set_directive_dependence -variable lane -type inter -dependent true -distance 10 "acc_index/ACC"
