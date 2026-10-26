# directives_acc_shift_pipe.tcl
set_directive_array_partition -type complete -dim 1 "acc_shift" lane
set_directive_pipeline -II 1 "acc_shift/ACC"
