// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-03T11:15:19
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=vecadd --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --simulate --simulator=VERILATOR --generate-tb=/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/src/tb_vecadd.cpp --tb-extra-gcc-options=-DDUT=vecadd -DCFG_LOOP_COUNT=8 --tb-param-size=A:512,B:512,C:512 --generate-interface=INFER -DDATA_T=int64_t -DSIZE_N=64 -DW=8 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/probe/bambu/include_stream -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/vectors/n64 --std=c++14 -DHLSLIB_SYNTHESIS -DAP_INT_MAX_W=4096 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/gen/dace_include /users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/probe/bambu/runs/D_w8_def_fifo_lcnone/vecadd.cpp 
// 
// Send any bug to: panda-info@polimi.it
// ************************************************************************
// The following text holds for all the components tagged with PANDA_LGPLv3.
// They are all part of the BAMBU/PANDA IP LIBRARY.
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 3 of the License, or (at your option) any later version.
// 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public
// License along with the PandA framework; see the files COPYING.LIB
// If not, see <http://www.gnu.org/licenses/>.
// ************************************************************************


`ifdef __ICARUS__
  `define _SIM_HAVE_CLOG2
`endif
`ifdef VERILATOR
  `define _SIM_HAVE_CLOG2
`endif
`ifdef MODEL_TECH
  `define _SIM_HAVE_CLOG2
`endif
`ifdef VCS
  `define _SIM_HAVE_CLOG2
`endif
`ifdef NCVERILOG
  `define _SIM_HAVE_CLOG2
`endif
`ifdef XILINX_SIMULATOR
  `define _SIM_HAVE_CLOG2
`endif
`ifdef XILINX_ISIM
  `define _SIM_HAVE_CLOG2
`endif

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>, Christian Pilato <christian.pilato@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module constant_value(out1);
  parameter BITSIZE_out1=1,
    value=1'b0;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  assign out1 = value;
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module register_SE(clock,
  reset,
  in1,
  wenable,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_out1=1;
  // IN
  input clock;
  input reset;
  input [BITSIZE_in1-1:0] in1;
  input wenable;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  
  reg [BITSIZE_out1-1:0] reg_out1 =0;
  assign out1 = reg_out1;
  always @(posedge clock)
    if (wenable)
      reg_out1 <= in1;
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module UUdata_converter_FU(in1,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_out1=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  generate
  if (BITSIZE_out1 <= BITSIZE_in1)
  begin
    assign out1 = in1[BITSIZE_out1-1:0];
  end
  else
  begin
    assign out1 = {{(BITSIZE_out1-BITSIZE_in1){1'b0}},in1};
  end
  endgenerate
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module read_cond_FU(in1,
  out1);
  parameter BITSIZE_in1=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  // OUT
  output out1;
  assign out1 = in1 != {BITSIZE_in1{1'b0}};
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_eq_expr_FU(in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  assign out1 = in1 == in2;
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_lshift_expr_FU(in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1,
    PRECISION=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  `ifndef _SIM_HAVE_CLOG2
    function integer log2;
       input integer value;
       integer temp_value;
      begin
        temp_value = value-1;
        for (log2=0; temp_value>0; log2=log2+1)
          temp_value = temp_value>>1;
      end
    endfunction
  `endif
  `ifdef _SIM_HAVE_CLOG2
    localparam arg2_bitsize = $clog2(PRECISION);
  `else
    localparam arg2_bitsize = log2(PRECISION);
  `endif
  generate
    if(BITSIZE_in2 > arg2_bitsize)
      assign out1 = in1 << in2[arg2_bitsize-1:0];
    else
      assign out1 = in1 << in2;
  endgenerate
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_plus_expr_FU(in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  assign out1 = in1 + in2;
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_pointer_plus_expr_FU(in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1,
    LSB_PARAMETER=-1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  wire [BITSIZE_out1-1:0] in1_tmp;
  wire [BITSIZE_out1-1:0] in2_tmp;
  assign in1_tmp = in1;
  assign in2_tmp = in2;generate if (BITSIZE_out1 > LSB_PARAMETER) assign out1[BITSIZE_out1-1:LSB_PARAMETER] = (in1_tmp[BITSIZE_out1-1:LSB_PARAMETER] + in2_tmp[BITSIZE_out1-1:LSB_PARAMETER]); else assign out1 = 0; endgenerate
  generate if (LSB_PARAMETER != 0 && BITSIZE_out1 > LSB_PARAMETER) assign out1[LSB_PARAMETER-1:0] = 0; endgenerate
endmodule

// Interface module for function: A_bambu_artificial_ParmMgr_Read_fifo
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module A_bambu_artificial_ParmMgr_Read_fifo_modgen(clock,
  reset,
  start_port,
  in1,
  _A_dout,
  _A_empty_n,
  done_port,
  out1,
  _A_read);
  parameter BITSIZE_in1=32,
    BITSIZE_out1=65;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [63:0] _A_dout;
  input _A_empty_n;
  // OUT
  output [0:0] done_port;
  output [BITSIZE_out1-1:0] out1;
  output _A_read;
  reg started, started_0;
  reg done_0;
  
  always @(posedge clock )
  begin
    if (reset == 1'b0)
    begin
      started <= 0;
    end
    else
    begin
      started <= started_0;
    end
  end
  
  always @(*)
  begin
    started_0 = (started | start_port) & ~_A_empty_n;
    done_0 = ( started | start_port) & _A_empty_n;
  end
  
  assign out1 = {_A_empty_n, _A_dout};
  assign done_port = done_0;
  assign _A_read = done_0;

endmodule

// Interface module for function: B_bambu_artificial_ParmMgr_Read_fifo
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module B_bambu_artificial_ParmMgr_Read_fifo_modgen(clock,
  reset,
  start_port,
  in1,
  _B_dout,
  _B_empty_n,
  done_port,
  out1,
  _B_read);
  parameter BITSIZE_in1=32,
    BITSIZE_out1=65;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [63:0] _B_dout;
  input _B_empty_n;
  // OUT
  output [0:0] done_port;
  output [BITSIZE_out1-1:0] out1;
  output _B_read;
  reg started, started_0;
  reg done_0;
  
  always @(posedge clock )
  begin
    if (reset == 1'b0)
    begin
      started <= 0;
    end
    else
    begin
      started <= started_0;
    end
  end
  
  always @(*)
  begin
    started_0 = (started | start_port) & ~_B_empty_n;
    done_0 = ( started | start_port) & _B_empty_n;
  end
  
  assign out1 = {_B_empty_n, _B_dout};
  assign done_port = done_0;
  assign _B_read = done_0;

endmodule

// Interface module for function: C_bambu_artificial_ParmMgr_Write_fifo
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module C_bambu_artificial_ParmMgr_Write_fifo_modgen(clock,
  reset,
  start_port,
  in1,
  in2,
  in3,
  _C_full_n,
  done_port,
  out1,
  _C_din,
  _C_write);
  parameter BITSIZE_in1=7,
    BITSIZE_in2=64,
    BITSIZE_in3=32;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  input [BITSIZE_in3-1:0] in3;
  input _C_full_n;
  // OUT
  output [0:0] done_port;
  output out1;
  output [63:0] _C_din;
  output _C_write;
  reg started, started_0;
  
  always @(posedge clock )
  begin
    if (reset == 1'b0)
    begin
      started <= 0;
    end
    else
    begin
      started <= started_0;
    end
  end
  
  always @(*)
    started_0 = (started | start_port) & ~_C_full_n;
  
  assign done_port = (started | start_port) & _C_full_n;
  assign _C_write = (started | start_port) & _C_full_n;
  assign out1 = _C_full_n;
  assign _C_din = in2;

endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2012-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module SIMPLEJOIN_FU(clock,
  reset,
  enable,
  ops,
  sop);
  parameter BITSIZE_ops=1, PORTSIZE_ops=2;
  // IN
  input clock;
  input reset;
  input enable;
  input [PORTSIZE_ops-1:0] ops;
  // OUT
  output sop;
  
  // synthesis attribute use_sync_reset of current is no;
  reg [PORTSIZE_ops-1:0] current =0;
  reg started =0;
  wire started0;
  wire [PORTSIZE_ops-1:0] or_temp;
  wire sop_temp;
  function reduce_INs;
  input [PORTSIZE_ops-1 : 0] instring;
  integer i;
  begin
     reduce_INs = 1'b1;
     for(i = 0; i < PORTSIZE_ops; i = i + 1)
     begin
        reduce_INs = reduce_INs & instring[i];
     end
  end
  endfunction
  function [PORTSIZE_ops-1:0] NEXT_CURR ;
  input sop_temp1;
  input [PORTSIZE_ops-1 : 0] ops1;
  input [PORTSIZE_ops-1 : 0] current1;
  input st;
  integer i;
  begin
     for(i = 0; i < PORTSIZE_ops; i = i + 1)
     begin
        NEXT_CURR[i] = ~sop_temp1 & ((current1[i]) | (st & ops1[i]));
     end
  end
  endfunction
  always @(posedge clock )
    if (reset == 1'b0)
      started <= 0;
    else
      started <= started0;
  assign started0 = ~sop_temp & (started | enable);
  assign or_temp = current | ops;
  assign sop_temp = reduce_INs(or_temp);
  assign sop = sop_temp;
  always @ (posedge clock )
  begin
  if(reset == 1'b0)
    begin
      current <= {PORTSIZE_ops{1'b0}};
    end
  else
    begin
      current <= NEXT_CURR(sop_temp,ops,current,started0);
    end
  end

endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>, Christian Pilato <christian.pilato@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module MUX_GATE(sel,
  in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1;
  // IN
  input sel;
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  assign out1 = sel ? in1 : in2;
endmodule

// Datapath RTL description for _Z6vecaddPK7lanes_tIxLi8EES2_PS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j(clock,
  reset,
  in_port_A,
  in_port_B,
  in_port_C,
  in_port_loop_count,
  _A_dout,
  _A_empty_n,
  _A_read,
  _B_dout,
  _B_empty_n,
  _B_read,
  _C_full_n,
  _C_din,
  _C_write,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0,
  selector_MUX_11_reg_0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0,
  muenable_mu_S_0,
  muenable_mu_S_10,
  muenable_mu_S_12,
  muenable_mu_S_14,
  muenable_mu_S_2,
  muenable_mu_S_4,
  muenable_mu_S_6,
  muenable_mu_S_8,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_10,
  wrenable_reg_11,
  wrenable_reg_12,
  wrenable_reg_13,
  wrenable_reg_14,
  wrenable_reg_15,
  wrenable_reg_16,
  wrenable_reg_17,
  wrenable_reg_18,
  wrenable_reg_19,
  wrenable_reg_2,
  wrenable_reg_20,
  wrenable_reg_21,
  wrenable_reg_22,
  wrenable_reg_23,
  wrenable_reg_24,
  wrenable_reg_25,
  wrenable_reg_26,
  wrenable_reg_27,
  wrenable_reg_28,
  wrenable_reg_29,
  wrenable_reg_3,
  wrenable_reg_30,
  wrenable_reg_31,
  wrenable_reg_32,
  wrenable_reg_33,
  wrenable_reg_34,
  wrenable_reg_35,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621,
  OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942,
  OUT_mu_S_0_MULTI_UNBOUNDED_0,
  OUT_mu_S_10_MULTI_UNBOUNDED_0,
  OUT_mu_S_12_MULTI_UNBOUNDED_0,
  OUT_mu_S_14_MULTI_UNBOUNDED_0,
  OUT_mu_S_2_MULTI_UNBOUNDED_0,
  OUT_mu_S_4_MULTI_UNBOUNDED_0,
  OUT_mu_S_6_MULTI_UNBOUNDED_0,
  OUT_mu_S_8_MULTI_UNBOUNDED_0);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_A;
  input [31:0] in_port_B;
  input [31:0] in_port_C;
  input [31:0] in_port_loop_count;
  input [63:0] _A_dout;
  input _A_empty_n;
  input [63:0] _B_dout;
  input _B_empty_n;
  input _C_full_n;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937;
  input selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0;
  input selector_MUX_11_reg_0_0_0_0;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0;
  input selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0;
  input selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1;
  input selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2;
  input selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3;
  input selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0;
  input selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1;
  input selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0;
  input muenable_mu_S_0;
  input muenable_mu_S_10;
  input muenable_mu_S_12;
  input muenable_mu_S_14;
  input muenable_mu_S_2;
  input muenable_mu_S_4;
  input muenable_mu_S_6;
  input muenable_mu_S_8;
  input wrenable_reg_0;
  input wrenable_reg_1;
  input wrenable_reg_10;
  input wrenable_reg_11;
  input wrenable_reg_12;
  input wrenable_reg_13;
  input wrenable_reg_14;
  input wrenable_reg_15;
  input wrenable_reg_16;
  input wrenable_reg_17;
  input wrenable_reg_18;
  input wrenable_reg_19;
  input wrenable_reg_2;
  input wrenable_reg_20;
  input wrenable_reg_21;
  input wrenable_reg_22;
  input wrenable_reg_23;
  input wrenable_reg_24;
  input wrenable_reg_25;
  input wrenable_reg_26;
  input wrenable_reg_27;
  input wrenable_reg_28;
  input wrenable_reg_29;
  input wrenable_reg_3;
  input wrenable_reg_30;
  input wrenable_reg_31;
  input wrenable_reg_32;
  input wrenable_reg_33;
  input wrenable_reg_34;
  input wrenable_reg_35;
  input wrenable_reg_4;
  input wrenable_reg_5;
  input wrenable_reg_6;
  input wrenable_reg_7;
  input wrenable_reg_8;
  input wrenable_reg_9;
  // OUT
  output _A_read;
  output _B_read;
  output [63:0] _C_din;
  output _C_write;
  output OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621;
  output OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937;
  output OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942;
  output OUT_mu_S_0_MULTI_UNBOUNDED_0;
  output OUT_mu_S_10_MULTI_UNBOUNDED_0;
  output OUT_mu_S_12_MULTI_UNBOUNDED_0;
  output OUT_mu_S_14_MULTI_UNBOUNDED_0;
  output OUT_mu_S_2_MULTI_UNBOUNDED_0;
  output OUT_mu_S_4_MULTI_UNBOUNDED_0;
  output OUT_mu_S_6_MULTI_UNBOUNDED_0;
  output OUT_mu_S_8_MULTI_UNBOUNDED_0;
  // Component and signal declarations
  wire [64:0] out_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0;
  wire [64:0] out_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0;
  wire [31:0] out_MUX_11_reg_0_0_0_0;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0;
  wire [31:0] out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0;
  wire [31:0] out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1;
  wire [31:0] out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2;
  wire [31:0] out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3;
  wire [31:0] out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0;
  wire [31:0] out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1;
  wire [31:0] out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0;
  wire out_UUdata_converter_FU_3_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428620;
  wire out_UUdata_converter_FU_6_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428765;
  wire out_const_0;
  wire out_const_1;
  wire [5:0] out_const_10;
  wire [3:0] out_const_2;
  wire [4:0] out_const_3;
  wire [5:0] out_const_4;
  wire [6:0] out_const_5;
  wire [5:0] out_const_6;
  wire [2:0] out_const_7;
  wire [4:0] out_const_8;
  wire [5:0] out_const_9;
  wire [63:0] out_conv_out_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_65_64;
  wire [63:0] out_conv_out_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_65_64;
  wire [31:0] out_conv_out_const_0_1_32;
  wire out_read_cond_FU_4_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621;
  wire out_read_cond_FU_7_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766;
  wire [31:0] out_reg_0_reg_0;
  wire [31:0] out_reg_10_reg_10;
  wire [63:0] out_reg_11_reg_11;
  wire [31:0] out_reg_12_reg_12;
  wire [31:0] out_reg_13_reg_13;
  wire [31:0] out_reg_14_reg_14;
  wire [31:0] out_reg_15_reg_15;
  wire [31:0] out_reg_16_reg_16;
  wire [31:0] out_reg_17_reg_17;
  wire [31:0] out_reg_18_reg_18;
  wire [31:0] out_reg_19_reg_19;
  wire [31:0] out_reg_1_reg_1;
  wire [31:0] out_reg_20_reg_20;
  wire [31:0] out_reg_21_reg_21;
  wire [31:0] out_reg_22_reg_22;
  wire [31:0] out_reg_23_reg_23;
  wire [31:0] out_reg_24_reg_24;
  wire [31:0] out_reg_25_reg_25;
  wire [31:0] out_reg_26_reg_26;
  wire out_reg_27_reg_27;
  wire [63:0] out_reg_28_reg_28;
  wire [63:0] out_reg_29_reg_29;
  wire [63:0] out_reg_2_reg_2;
  wire [63:0] out_reg_30_reg_30;
  wire [63:0] out_reg_31_reg_31;
  wire [63:0] out_reg_32_reg_32;
  wire [63:0] out_reg_33_reg_33;
  wire [63:0] out_reg_34_reg_34;
  wire [63:0] out_reg_35_reg_35;
  wire [31:0] out_reg_3_reg_3;
  wire [31:0] out_reg_4_reg_4;
  wire [31:0] out_reg_5_reg_5;
  wire [31:0] out_reg_6_reg_6;
  wire [31:0] out_reg_7_reg_7;
  wire [31:0] out_reg_8_reg_8;
  wire [31:0] out_reg_9_reg_9;
  wire out_ui_eq_expr_FU_32_0_32_8_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428829;
  wire out_ui_eq_expr_FU_32_32_32_9_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428822;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_10_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428786;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_11_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428619;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_12_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428595;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_12_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428596;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_12_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428597;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_12_i3_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428598;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_12_i4_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428599;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_12_i5_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428600;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_12_i6_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428601;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_12_i7_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428602;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_13_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428565;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_13_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428581;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_13_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428605;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_14_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428567;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_14_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428583;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_14_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428607;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_15_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428569;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_15_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428585;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_15_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428609;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_16_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428571;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_16_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428587;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_16_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428611;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_17_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428573;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_17_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428589;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_17_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428613;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_18_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428575;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_18_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428591;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_18_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428615;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_19_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428577;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_19_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428593;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_19_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428617;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_20_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_20_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603;
  wire [31:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0;
  wire s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0;
  wire s_done_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_P0;
  wire s_start_port0;
  wire s_start_port1;
  wire s_start_port2;
  
  A_bambu_artificial_ParmMgr_Read_fifo_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(65)) A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0 (.done_port({s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0}),
    .out1(out_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0),
    ._A_read(_A_read),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port0}),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0),
    ._A_dout(_A_dout),
    ._A_empty_n(_A_empty_n));
  B_bambu_artificial_ParmMgr_Read_fifo_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(65)) B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0 (.done_port({s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0}),
    .out1(out_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0),
    ._B_read(_B_read),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port1}),
    .in1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0),
    ._B_dout(_B_dout),
    ._B_empty_n(_B_empty_n));
  C_bambu_artificial_ParmMgr_Write_fifo_modgen #(.BITSIZE_in1(7),
    .BITSIZE_in2(64),
    .BITSIZE_in3(32)) C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0 (.done_port({s_done_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_P0}),
    ._C_din(_C_din),
    ._C_write(_C_write),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port2}),
    .in1(out_const_5),
    .in2(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0),
    .in3(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0),
    ._C_full_n(_C_full_n));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0),
    .in1(out_reg_9_reg_9),
    .in2(out_reg_8_reg_8));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1),
    .in1(out_reg_7_reg_7),
    .in2(out_reg_6_reg_6));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2),
    .in1(out_reg_5_reg_5),
    .in2(out_reg_4_reg_4));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3),
    .in1(out_reg_3_reg_3),
    .in2(out_reg_1_reg_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1),
    .in2(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3),
    .in2(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0),
    .in2(out_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_11_reg_0_0_0_0 (.out1(out_MUX_11_reg_0_0_0_0),
    .sel(selector_MUX_11_reg_0_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_11_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428619),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0),
    .in1(out_reg_18_reg_18),
    .in2(out_reg_17_reg_17));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1),
    .in1(out_reg_16_reg_16),
    .in2(out_reg_15_reg_15));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2),
    .in1(out_reg_14_reg_14),
    .in2(out_reg_13_reg_13));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3),
    .in1(out_reg_12_reg_12),
    .in2(out_reg_10_reg_10));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0),
    .in1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1),
    .in2(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1),
    .in1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3),
    .in2(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0),
    .in1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0),
    .in2(out_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0),
    .in1(out_reg_35_reg_35),
    .in2(out_reg_34_reg_34));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1),
    .in1(out_reg_33_reg_33),
    .in2(out_reg_32_reg_32));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2),
    .in1(out_reg_31_reg_31),
    .in2(out_reg_30_reg_30));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3),
    .in1(out_reg_29_reg_29),
    .in2(out_reg_28_reg_28));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0),
    .in1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0),
    .in2(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1),
    .in1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2),
    .in2(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0),
    .in1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0),
    .in2(out_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0 (.out1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0),
    .sel(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0),
    .in1(out_reg_26_reg_26),
    .in2(out_reg_25_reg_25));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1 (.out1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1),
    .sel(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1),
    .in1(out_reg_24_reg_24),
    .in2(out_reg_23_reg_23));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2 (.out1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2),
    .sel(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2),
    .in1(out_reg_22_reg_22),
    .in2(out_reg_21_reg_21));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3 (.out1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3),
    .sel(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3),
    .in1(out_reg_20_reg_20),
    .in2(out_reg_19_reg_19));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0 (.out1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0),
    .sel(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0),
    .in1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0),
    .in2(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1 (.out1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1),
    .sel(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1),
    .in1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2),
    .in2(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0 (.out1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0),
    .sel(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0),
    .in1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0),
    .in2(out_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) UUdata_converter_FU_uu_conv_0 (.out1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in1(out_conv_out_const_0_1_32));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b0)) const_0 (.out1(out_const_0));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b1)) const_1 (.out1(out_const_1));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b111000)) const_10 (.out1(out_const_10));
  constant_value #(.BITSIZE_out1(4),
    .value(4'b1000)) const_2 (.out1(out_const_2));
  constant_value #(.BITSIZE_out1(5),
    .value(5'b10000)) const_3 (.out1(out_const_3));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b100000)) const_4 (.out1(out_const_4));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1000000)) const_5 (.out1(out_const_5));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b101000)) const_6 (.out1(out_const_6));
  constant_value #(.BITSIZE_out1(3),
    .value(3'b110)) const_7 (.out1(out_const_7));
  constant_value #(.BITSIZE_out1(5),
    .value(5'b11000)) const_8 (.out1(out_const_8));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b110000)) const_9 (.out1(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(65),
    .BITSIZE_out1(64)) conv_out_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_65_64 (.out1(out_conv_out_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_65_64),
    .in1(out_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0));
  UUdata_converter_FU #(.BITSIZE_in1(65),
    .BITSIZE_out1(64)) conv_out_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_65_64 (.out1(out_conv_out_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_65_64),
    .in1(out_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_10_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428786));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(4),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428565 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_13_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428565),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_2));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(5),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428567 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_14_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428567),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_3));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(5),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428569 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_15_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428569),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_8));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428571 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_16_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428571),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_4));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428573 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_17_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428573),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_6));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428575 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_18_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428575),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_9));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428577 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_19_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428577),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_10));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_20_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_10_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428786));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(4),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428581 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_13_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428581),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_2));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(5),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428583 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_14_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428583),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_3));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(5),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428585 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_15_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428585),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_8));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428587 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_16_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428587),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_4));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428589 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_17_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428589),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_6));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428591 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_18_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428591),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_9));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428593 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_19_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428593),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_10));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428595 (.out1(out_ui_plus_expr_FU_64_64_64_12_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428595),
    .in1(out_reg_11_reg_11),
    .in2(out_reg_2_reg_2));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428596 (.out1(out_ui_plus_expr_FU_64_64_64_12_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428596),
    .in1(out_reg_11_reg_11),
    .in2(out_reg_2_reg_2));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428597 (.out1(out_ui_plus_expr_FU_64_64_64_12_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428597),
    .in1(out_reg_11_reg_11),
    .in2(out_reg_2_reg_2));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428598 (.out1(out_ui_plus_expr_FU_64_64_64_12_i3_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428598),
    .in1(out_reg_11_reg_11),
    .in2(out_reg_2_reg_2));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428599 (.out1(out_ui_plus_expr_FU_64_64_64_12_i4_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428599),
    .in1(out_reg_11_reg_11),
    .in2(out_reg_2_reg_2));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428600 (.out1(out_ui_plus_expr_FU_64_64_64_12_i5_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428600),
    .in1(out_reg_11_reg_11),
    .in2(out_reg_2_reg_2));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428601 (.out1(out_ui_plus_expr_FU_64_64_64_12_i6_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428601),
    .in1(out_reg_11_reg_11),
    .in2(out_reg_2_reg_2));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428602 (.out1(out_ui_plus_expr_FU_64_64_64_12_i7_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428602),
    .in1(out_reg_11_reg_11),
    .in2(out_reg_2_reg_2));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_20_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in1(in_port_C),
    .in2(out_ui_lshift_expr_FU_32_0_32_10_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428786));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(4),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428605 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_13_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428605),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_2));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(5),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428607 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_14_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428607),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_3));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(5),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428609 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_15_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428609),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_8));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428611 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_16_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428611),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_4));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428613 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_17_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428613),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_6));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428615 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_18_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428615),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_9));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428617 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_19_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428617),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_10));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428619 (.out1(out_ui_plus_expr_FU_32_0_32_11_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428619),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428620 (.out1(out_UUdata_converter_FU_3_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428620),
    .in1(out_ui_eq_expr_FU_32_32_32_9_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428822));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621 (.out1(out_read_cond_FU_4_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621),
    .in1(out_reg_27_reg_27));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428765 (.out1(out_UUdata_converter_FU_6_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428765),
    .in1(out_ui_eq_expr_FU_32_0_32_8_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428829));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766 (.out1(out_read_cond_FU_7_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766),
    .in1(out_UUdata_converter_FU_6_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428765));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(3),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428786 (.out1(out_ui_lshift_expr_FU_32_0_32_10_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428786),
    .in1(out_reg_0_reg_0),
    .in2(out_const_7));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428822 (.out1(out_ui_eq_expr_FU_32_32_32_9_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428822),
    .in1(out_ui_plus_expr_FU_32_0_32_11_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428619),
    .in2(in_port_loop_count));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428829 (.out1(out_ui_eq_expr_FU_32_0_32_8_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428829),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_0 (.sop(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_0),
    .ops({s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0,
      s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_10 (.sop(OUT_mu_S_10_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_10),
    .ops({s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0,
      s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_12 (.sop(OUT_mu_S_12_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_12),
    .ops({s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0,
      s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_14 (.sop(OUT_mu_S_14_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_14),
    .ops({s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0,
      s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_2 (.sop(OUT_mu_S_2_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_2),
    .ops({s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0,
      s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_4 (.sop(OUT_mu_S_4_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_4),
    .ops({s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0,
      s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_6 (.sop(OUT_mu_S_6_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_6),
    .ops({s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0,
      s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_8 (.sop(OUT_mu_S_8_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_8),
    .ops({s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0,
      s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0}));
  or or_or_start_port0( s_start_port0, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578);
  or or_or_start_port1( s_start_port1, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594);
  or or_or_start_port2( s_start_port2, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937, selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942);
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_11_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_10 (.out1(out_reg_10_reg_10),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .wenable(wrenable_reg_10));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_conv_out_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_65_64),
    .wenable(wrenable_reg_11));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_12 (.out1(out_reg_12_reg_12),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_13_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428581),
    .wenable(wrenable_reg_12));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_13 (.out1(out_reg_13_reg_13),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_14_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428583),
    .wenable(wrenable_reg_13));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_14 (.out1(out_reg_14_reg_14),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_15_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428585),
    .wenable(wrenable_reg_14));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_15 (.out1(out_reg_15_reg_15),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_16_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428587),
    .wenable(wrenable_reg_15));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_16 (.out1(out_reg_16_reg_16),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_17_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428589),
    .wenable(wrenable_reg_16));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_17 (.out1(out_reg_17_reg_17),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_18_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428591),
    .wenable(wrenable_reg_17));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_18 (.out1(out_reg_18_reg_18),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_19_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428593),
    .wenable(wrenable_reg_18));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_19 (.out1(out_reg_19_reg_19),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_20_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .wenable(wrenable_reg_19));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_conv_out_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_65_64),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_20 (.out1(out_reg_20_reg_20),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_13_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428605),
    .wenable(wrenable_reg_20));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_21 (.out1(out_reg_21_reg_21),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_14_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428607),
    .wenable(wrenable_reg_21));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_22 (.out1(out_reg_22_reg_22),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_15_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428609),
    .wenable(wrenable_reg_22));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_23 (.out1(out_reg_23_reg_23),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_16_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428611),
    .wenable(wrenable_reg_23));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_24 (.out1(out_reg_24_reg_24),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_17_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428613),
    .wenable(wrenable_reg_24));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_25 (.out1(out_reg_25_reg_25),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_18_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428615),
    .wenable(wrenable_reg_25));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_26 (.out1(out_reg_26_reg_26),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_19_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428617),
    .wenable(wrenable_reg_26));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_27 (.out1(out_reg_27_reg_27),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_3_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428620),
    .wenable(wrenable_reg_27));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_28 (.out1(out_reg_28_reg_28),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_12_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428595),
    .wenable(wrenable_reg_28));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_29 (.out1(out_reg_29_reg_29),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_12_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428596),
    .wenable(wrenable_reg_29));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_13_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428565),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_30 (.out1(out_reg_30_reg_30),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_12_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428597),
    .wenable(wrenable_reg_30));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_31 (.out1(out_reg_31_reg_31),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_12_i3_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428598),
    .wenable(wrenable_reg_31));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_32 (.out1(out_reg_32_reg_32),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_12_i4_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428599),
    .wenable(wrenable_reg_32));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_33 (.out1(out_reg_33_reg_33),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_12_i5_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428600),
    .wenable(wrenable_reg_33));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_34 (.out1(out_reg_34_reg_34),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_12_i6_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428601),
    .wenable(wrenable_reg_34));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_35 (.out1(out_reg_35_reg_35),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_12_i7_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428602),
    .wenable(wrenable_reg_35));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_14_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428567),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_15_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428569),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_16_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428571),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_17_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428573),
    .wenable(wrenable_reg_7));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_18_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428575),
    .wenable(wrenable_reg_8));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_19_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428577),
    .wenable(wrenable_reg_9));
  // io-signal post fix
  assign OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621 = out_read_cond_FU_4_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621;
  assign OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766 = out_read_cond_FU_7_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564 = s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566 = s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568 = s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570 = s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572 = s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574 = s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576 = s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578 = s_done_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580 = s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582 = s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584 = s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586 = s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588 = s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590 = s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592 = s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594 = s_done_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907 = s_done_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912 = s_done_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917 = s_done_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922 = s_done_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927 = s_done_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932 = s_done_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937 = s_done_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942 = s_done_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_P0;

endmodule

// FSM based controller description for _Z6vecaddPK7lanes_tIxLi8EES2_PS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j(done_port,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937,
  selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0,
  selector_MUX_11_reg_0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0,
  muenable_mu_S_0,
  muenable_mu_S_10,
  muenable_mu_S_12,
  muenable_mu_S_14,
  muenable_mu_S_2,
  muenable_mu_S_4,
  muenable_mu_S_6,
  muenable_mu_S_8,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_10,
  wrenable_reg_11,
  wrenable_reg_12,
  wrenable_reg_13,
  wrenable_reg_14,
  wrenable_reg_15,
  wrenable_reg_16,
  wrenable_reg_17,
  wrenable_reg_18,
  wrenable_reg_19,
  wrenable_reg_2,
  wrenable_reg_20,
  wrenable_reg_21,
  wrenable_reg_22,
  wrenable_reg_23,
  wrenable_reg_24,
  wrenable_reg_25,
  wrenable_reg_26,
  wrenable_reg_27,
  wrenable_reg_28,
  wrenable_reg_29,
  wrenable_reg_3,
  wrenable_reg_30,
  wrenable_reg_31,
  wrenable_reg_32,
  wrenable_reg_33,
  wrenable_reg_34,
  wrenable_reg_35,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621,
  OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937,
  OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942,
  OUT_mu_S_0_MULTI_UNBOUNDED_0,
  OUT_mu_S_10_MULTI_UNBOUNDED_0,
  OUT_mu_S_12_MULTI_UNBOUNDED_0,
  OUT_mu_S_14_MULTI_UNBOUNDED_0,
  OUT_mu_S_2_MULTI_UNBOUNDED_0,
  OUT_mu_S_4_MULTI_UNBOUNDED_0,
  OUT_mu_S_6_MULTI_UNBOUNDED_0,
  OUT_mu_S_8_MULTI_UNBOUNDED_0,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621;
  input OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937;
  input OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942;
  input OUT_mu_S_0_MULTI_UNBOUNDED_0;
  input OUT_mu_S_10_MULTI_UNBOUNDED_0;
  input OUT_mu_S_12_MULTI_UNBOUNDED_0;
  input OUT_mu_S_14_MULTI_UNBOUNDED_0;
  input OUT_mu_S_2_MULTI_UNBOUNDED_0;
  input OUT_mu_S_4_MULTI_UNBOUNDED_0;
  input OUT_mu_S_6_MULTI_UNBOUNDED_0;
  input OUT_mu_S_8_MULTI_UNBOUNDED_0;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937;
  output selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0;
  output selector_MUX_11_reg_0_0_0_0;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0;
  output selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0;
  output selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1;
  output selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2;
  output selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3;
  output selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0;
  output selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1;
  output selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0;
  output muenable_mu_S_0;
  output muenable_mu_S_10;
  output muenable_mu_S_12;
  output muenable_mu_S_14;
  output muenable_mu_S_2;
  output muenable_mu_S_4;
  output muenable_mu_S_6;
  output muenable_mu_S_8;
  output wrenable_reg_0;
  output wrenable_reg_1;
  output wrenable_reg_10;
  output wrenable_reg_11;
  output wrenable_reg_12;
  output wrenable_reg_13;
  output wrenable_reg_14;
  output wrenable_reg_15;
  output wrenable_reg_16;
  output wrenable_reg_17;
  output wrenable_reg_18;
  output wrenable_reg_19;
  output wrenable_reg_2;
  output wrenable_reg_20;
  output wrenable_reg_21;
  output wrenable_reg_22;
  output wrenable_reg_23;
  output wrenable_reg_24;
  output wrenable_reg_25;
  output wrenable_reg_26;
  output wrenable_reg_27;
  output wrenable_reg_28;
  output wrenable_reg_29;
  output wrenable_reg_3;
  output wrenable_reg_30;
  output wrenable_reg_31;
  output wrenable_reg_32;
  output wrenable_reg_33;
  output wrenable_reg_34;
  output wrenable_reg_35;
  output wrenable_reg_4;
  output wrenable_reg_5;
  output wrenable_reg_6;
  output wrenable_reg_7;
  output wrenable_reg_8;
  output wrenable_reg_9;
  parameter [5:0] S_33 = 6'd33,
    S_35 = 6'd35,
    S_0 = 6'd0,
    S_1 = 6'd1,
    S_2 = 6'd2,
    S_3 = 6'd3,
    S_4 = 6'd4,
    S_5 = 6'd5,
    S_6 = 6'd6,
    S_7 = 6'd7,
    S_8 = 6'd8,
    S_9 = 6'd9,
    S_10 = 6'd10,
    S_11 = 6'd11,
    S_12 = 6'd12,
    S_13 = 6'd13,
    S_14 = 6'd14,
    S_15 = 6'd15,
    S_16 = 6'd16,
    S_17 = 6'd17,
    S_18 = 6'd18,
    S_19 = 6'd19,
    S_20 = 6'd20,
    S_21 = 6'd21,
    S_22 = 6'd22,
    S_23 = 6'd23,
    S_24 = 6'd24,
    S_25 = 6'd25,
    S_26 = 6'd26,
    S_27 = 6'd27,
    S_28 = 6'd28,
    S_29 = 6'd29,
    S_30 = 6'd30,
    S_31 = 6'd31,
    S_32 = 6'd32,
    S_34 = 6'd34;
  reg [5:0] _present_state=S_33, _next_state;
  reg done_port;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937;
  reg selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0;
  reg selector_MUX_11_reg_0_0_0_0;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0;
  reg selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0;
  reg selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1;
  reg selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2;
  reg selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3;
  reg selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0;
  reg selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1;
  reg selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0;
  reg muenable_mu_S_0;
  reg muenable_mu_S_10;
  reg muenable_mu_S_12;
  reg muenable_mu_S_14;
  reg muenable_mu_S_2;
  reg muenable_mu_S_4;
  reg muenable_mu_S_6;
  reg muenable_mu_S_8;
  reg wrenable_reg_0;
  reg wrenable_reg_1;
  reg wrenable_reg_10;
  reg wrenable_reg_11;
  reg wrenable_reg_12;
  reg wrenable_reg_13;
  reg wrenable_reg_14;
  reg wrenable_reg_15;
  reg wrenable_reg_16;
  reg wrenable_reg_17;
  reg wrenable_reg_18;
  reg wrenable_reg_19;
  reg wrenable_reg_2;
  reg wrenable_reg_20;
  reg wrenable_reg_21;
  reg wrenable_reg_22;
  reg wrenable_reg_23;
  reg wrenable_reg_24;
  reg wrenable_reg_25;
  reg wrenable_reg_26;
  reg wrenable_reg_27;
  reg wrenable_reg_28;
  reg wrenable_reg_29;
  reg wrenable_reg_3;
  reg wrenable_reg_30;
  reg wrenable_reg_31;
  reg wrenable_reg_32;
  reg wrenable_reg_33;
  reg wrenable_reg_34;
  reg wrenable_reg_35;
  reg wrenable_reg_4;
  reg wrenable_reg_5;
  reg wrenable_reg_6;
  reg wrenable_reg_7;
  reg wrenable_reg_8;
  reg wrenable_reg_9;
  
  always @(posedge clock)
    if (reset == 1'b0) _present_state <= S_33;
    else _present_state <= _next_state;
  
  always @(*)
  begin
    done_port = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0 = 1'b0;
    selector_MUX_11_reg_0_0_0_0 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0 = 1'b0;
    selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0 = 1'b0;
    selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1 = 1'b0;
    selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2 = 1'b0;
    selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3 = 1'b0;
    selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0 = 1'b0;
    selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1 = 1'b0;
    selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0 = 1'b0;
    muenable_mu_S_0 = 1'b0;
    muenable_mu_S_10 = 1'b0;
    muenable_mu_S_12 = 1'b0;
    muenable_mu_S_14 = 1'b0;
    muenable_mu_S_2 = 1'b0;
    muenable_mu_S_4 = 1'b0;
    muenable_mu_S_6 = 1'b0;
    muenable_mu_S_8 = 1'b0;
    wrenable_reg_0 = 1'b0;
    wrenable_reg_1 = 1'b0;
    wrenable_reg_10 = 1'b0;
    wrenable_reg_11 = 1'b0;
    wrenable_reg_12 = 1'b0;
    wrenable_reg_13 = 1'b0;
    wrenable_reg_14 = 1'b0;
    wrenable_reg_15 = 1'b0;
    wrenable_reg_16 = 1'b0;
    wrenable_reg_17 = 1'b0;
    wrenable_reg_18 = 1'b0;
    wrenable_reg_19 = 1'b0;
    wrenable_reg_2 = 1'b0;
    wrenable_reg_20 = 1'b0;
    wrenable_reg_21 = 1'b0;
    wrenable_reg_22 = 1'b0;
    wrenable_reg_23 = 1'b0;
    wrenable_reg_24 = 1'b0;
    wrenable_reg_25 = 1'b0;
    wrenable_reg_26 = 1'b0;
    wrenable_reg_27 = 1'b0;
    wrenable_reg_28 = 1'b0;
    wrenable_reg_29 = 1'b0;
    wrenable_reg_3 = 1'b0;
    wrenable_reg_30 = 1'b0;
    wrenable_reg_31 = 1'b0;
    wrenable_reg_32 = 1'b0;
    wrenable_reg_33 = 1'b0;
    wrenable_reg_34 = 1'b0;
    wrenable_reg_35 = 1'b0;
    wrenable_reg_4 = 1'b0;
    wrenable_reg_5 = 1'b0;
    wrenable_reg_6 = 1'b0;
    wrenable_reg_7 = 1'b0;
    wrenable_reg_8 = 1'b0;
    wrenable_reg_9 = 1'b0;
    case (_present_state)
      S_33 :
        if(start_port == 1'b1)
        begin
          wrenable_reg_0 = 1'b1;
          if (OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766 == 1'b0)
            begin
              _next_state = S_0;
            end
          else
            begin
              _next_state = S_35;
              done_port = 1'b1;
              wrenable_reg_0 = 1'b0;
            end
        end
        else
        begin
          _next_state = S_33;
        end
      S_35 :
        begin
          _next_state = S_33;
        end
      S_0 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4 = 1'b1;
          selector_MUX_11_reg_0_0_0_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_13 = 1'b1;
          wrenable_reg_14 = 1'b1;
          wrenable_reg_15 = 1'b1;
          wrenable_reg_16 = 1'b1;
          wrenable_reg_17 = 1'b1;
          wrenable_reg_18 = 1'b1;
          wrenable_reg_19 = 1'b1;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564;
          wrenable_reg_20 = 1'b1;
          wrenable_reg_21 = 1'b1;
          wrenable_reg_22 = 1'b1;
          wrenable_reg_23 = 1'b1;
          wrenable_reg_24 = 1'b1;
          wrenable_reg_25 = 1'b1;
          wrenable_reg_26 = 1'b1;
          wrenable_reg_27 = 1'b1;
          wrenable_reg_3 = 1'b1;
          wrenable_reg_4 = 1'b1;
          wrenable_reg_5 = 1'b1;
          wrenable_reg_6 = 1'b1;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = 1'b1;
          wrenable_reg_9 = 1'b1;
          if (OUT_mu_S_0_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_1;
              muenable_mu_S_0 = 1'b1;
            end
          else
            begin
              _next_state = S_2;
              muenable_mu_S_0 = 1'b1;
            end
        end
      S_1 :
        begin
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564;
          if (OUT_mu_S_0_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_1;
            end
          else
            begin
              _next_state = S_2;
            end
        end
      S_2 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566;
          wrenable_reg_28 = 1'b1;
          if (OUT_mu_S_2_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_3;
              muenable_mu_S_2 = 1'b1;
            end
          else
            begin
              _next_state = S_4;
              muenable_mu_S_2 = 1'b1;
            end
        end
      S_3 :
        begin
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566;
          if (OUT_mu_S_2_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_3;
            end
          else
            begin
              _next_state = S_4;
            end
        end
      S_4 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568;
          wrenable_reg_29 = 1'b1;
          if (OUT_mu_S_4_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_5;
              muenable_mu_S_4 = 1'b1;
            end
          else
            begin
              _next_state = S_6;
              muenable_mu_S_4 = 1'b1;
            end
        end
      S_5 :
        begin
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568;
          if (OUT_mu_S_4_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_5;
            end
          else
            begin
              _next_state = S_6;
            end
        end
      S_6 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570;
          wrenable_reg_30 = 1'b1;
          if (OUT_mu_S_6_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_7;
              muenable_mu_S_6 = 1'b1;
            end
          else
            begin
              _next_state = S_8;
              muenable_mu_S_6 = 1'b1;
            end
        end
      S_7 :
        begin
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570;
          if (OUT_mu_S_6_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_7;
            end
          else
            begin
              _next_state = S_8;
            end
        end
      S_8 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572;
          wrenable_reg_31 = 1'b1;
          if (OUT_mu_S_8_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_9;
              muenable_mu_S_8 = 1'b1;
            end
          else
            begin
              _next_state = S_10;
              muenable_mu_S_8 = 1'b1;
            end
        end
      S_9 :
        begin
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572;
          if (OUT_mu_S_8_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_9;
            end
          else
            begin
              _next_state = S_10;
            end
        end
      S_10 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574;
          wrenable_reg_32 = 1'b1;
          if (OUT_mu_S_10_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_11;
              muenable_mu_S_10 = 1'b1;
            end
          else
            begin
              _next_state = S_12;
              muenable_mu_S_10 = 1'b1;
            end
        end
      S_11 :
        begin
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574;
          if (OUT_mu_S_10_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_11;
            end
          else
            begin
              _next_state = S_12;
            end
        end
      S_12 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576;
          wrenable_reg_33 = 1'b1;
          if (OUT_mu_S_12_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_13;
              muenable_mu_S_12 = 1'b1;
            end
          else
            begin
              _next_state = S_14;
              muenable_mu_S_12 = 1'b1;
            end
        end
      S_13 :
        begin
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576;
          if (OUT_mu_S_12_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_13;
            end
          else
            begin
              _next_state = S_14;
            end
        end
      S_14 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578;
          wrenable_reg_34 = 1'b1;
          if (OUT_mu_S_14_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_15;
              muenable_mu_S_14 = 1'b1;
            end
          else
            begin
              _next_state = S_16;
              muenable_mu_S_14 = 1'b1;
            end
        end
      S_15 :
        begin
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0 = 1'b1;
          wrenable_reg_11 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578;
          if (OUT_mu_S_14_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_15;
            end
          else
            begin
              _next_state = S_16;
            end
        end
      S_16 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907 = 1'b1;
          wrenable_reg_35 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907 == 1'b0)
            begin
              _next_state = S_17;
            end
          else
            begin
              _next_state = S_18;
            end
        end
      S_17 :
        begin
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907 == 1'b0)
            begin
              _next_state = S_17;
            end
          else
            begin
              _next_state = S_18;
            end
        end
      S_18 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912 == 1'b0)
            begin
              _next_state = S_19;
            end
          else
            begin
              _next_state = S_20;
            end
        end
      S_19 :
        begin
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912 == 1'b0)
            begin
              _next_state = S_19;
            end
          else
            begin
              _next_state = S_20;
            end
        end
      S_20 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917 == 1'b0)
            begin
              _next_state = S_21;
            end
          else
            begin
              _next_state = S_22;
            end
        end
      S_21 :
        begin
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917 == 1'b0)
            begin
              _next_state = S_21;
            end
          else
            begin
              _next_state = S_22;
            end
        end
      S_22 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922 == 1'b0)
            begin
              _next_state = S_23;
            end
          else
            begin
              _next_state = S_24;
            end
        end
      S_23 :
        begin
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922 == 1'b0)
            begin
              _next_state = S_23;
            end
          else
            begin
              _next_state = S_24;
            end
        end
      S_24 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927 == 1'b0)
            begin
              _next_state = S_25;
            end
          else
            begin
              _next_state = S_26;
            end
        end
      S_25 :
        begin
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927 == 1'b0)
            begin
              _next_state = S_25;
            end
          else
            begin
              _next_state = S_26;
            end
        end
      S_26 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932 == 1'b0)
            begin
              _next_state = S_27;
            end
          else
            begin
              _next_state = S_28;
            end
        end
      S_27 :
        begin
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932 == 1'b0)
            begin
              _next_state = S_27;
            end
          else
            begin
              _next_state = S_28;
            end
        end
      S_28 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937 == 1'b0)
            begin
              _next_state = S_29;
            end
          else
            begin
              _next_state = S_30;
            end
        end
      S_29 :
        begin
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937 == 1'b0)
            begin
              _next_state = S_29;
            end
          else
            begin
              _next_state = S_30;
            end
        end
      S_30 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942 == 1'b0)
            begin
              _next_state = S_31;
            end
          else
            begin
              _next_state = S_32;
            end
        end
      S_31 :
        begin
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942 == 1'b0)
            begin
              _next_state = S_31;
            end
          else
            begin
              _next_state = S_32;
            end
        end
      S_32 :
        begin
          if (OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621 == 1'b0)
            begin
              _next_state = S_0;
            end
          else
            begin
              _next_state = S_34;
              done_port = 1'b1;
            end
        end
      S_34 :
        begin
          _next_state = S_33;
        end
      default :
        begin
          _next_state = S_33;
        end
    endcase
  end
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Marco Lattuada <marco.lattuada@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module flipflop_AR(clock,
  reset,
  in1,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_out1=1;
  // IN
  input clock;
  input reset;
  input in1;
  // OUT
  output out1;
  
  reg reg_out1 =0;
  assign out1 = reg_out1;
  always @(posedge clock or negedge reset)
    if (reset == 1'b0)
      reg_out1 <= {BITSIZE_out1{1'b0}};
    else
      reg_out1 <= in1;
endmodule

// Top component for _Z6vecaddPK7lanes_tIxLi8EES2_PS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z6vecaddPK7lanes_tIxLi8EES2_PS0_j(clock,
  reset,
  start_port,
  done_port,
  A,
  B,
  C,
  loop_count,
  _A_dout,
  _A_empty_n,
  _B_dout,
  _B_empty_n,
  _C_full_n,
  _A_read,
  _B_read,
  _C_din,
  _C_write);
  // IN
  input clock;
  input reset;
  input start_port;
  input [31:0] A;
  input [31:0] B;
  input [31:0] C;
  input [31:0] loop_count;
  input [63:0] _A_dout;
  input _A_empty_n;
  input [63:0] _B_dout;
  input _B_empty_n;
  input _C_full_n;
  // OUT
  output done_port;
  output _A_read;
  output _B_read;
  output [63:0] _C_din;
  output _C_write;
  // Component and signal declarations
  wire OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621;
  wire OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937;
  wire OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942;
  wire OUT_mu_S_0_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_10_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_12_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_14_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_2_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_4_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_6_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_8_MULTI_UNBOUNDED_0;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire muenable_mu_S_0;
  wire muenable_mu_S_10;
  wire muenable_mu_S_12;
  wire muenable_mu_S_14;
  wire muenable_mu_S_2;
  wire muenable_mu_S_4;
  wire muenable_mu_S_6;
  wire muenable_mu_S_8;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937;
  wire selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0;
  wire selector_MUX_11_reg_0_0_0_0;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0;
  wire selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0;
  wire selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1;
  wire selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2;
  wire selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3;
  wire selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0;
  wire selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1;
  wire selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0;
  wire wrenable_reg_0;
  wire wrenable_reg_1;
  wire wrenable_reg_10;
  wire wrenable_reg_11;
  wire wrenable_reg_12;
  wire wrenable_reg_13;
  wire wrenable_reg_14;
  wire wrenable_reg_15;
  wire wrenable_reg_16;
  wire wrenable_reg_17;
  wire wrenable_reg_18;
  wire wrenable_reg_19;
  wire wrenable_reg_2;
  wire wrenable_reg_20;
  wire wrenable_reg_21;
  wire wrenable_reg_22;
  wire wrenable_reg_23;
  wire wrenable_reg_24;
  wire wrenable_reg_25;
  wire wrenable_reg_26;
  wire wrenable_reg_27;
  wire wrenable_reg_28;
  wire wrenable_reg_29;
  wire wrenable_reg_3;
  wire wrenable_reg_30;
  wire wrenable_reg_31;
  wire wrenable_reg_32;
  wire wrenable_reg_33;
  wire wrenable_reg_34;
  wire wrenable_reg_35;
  wire wrenable_reg_4;
  wire wrenable_reg_5;
  wire wrenable_reg_6;
  wire wrenable_reg_7;
  wire wrenable_reg_8;
  wire wrenable_reg_9;
  
  controller__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0),
    .selector_MUX_11_reg_0_0_0_0(selector_MUX_11_reg_0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0),
    .muenable_mu_S_0(muenable_mu_S_0),
    .muenable_mu_S_10(muenable_mu_S_10),
    .muenable_mu_S_12(muenable_mu_S_12),
    .muenable_mu_S_14(muenable_mu_S_14),
    .muenable_mu_S_2(muenable_mu_S_2),
    .muenable_mu_S_4(muenable_mu_S_4),
    .muenable_mu_S_6(muenable_mu_S_6),
    .muenable_mu_S_8(muenable_mu_S_8),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_10(wrenable_reg_10),
    .wrenable_reg_11(wrenable_reg_11),
    .wrenable_reg_12(wrenable_reg_12),
    .wrenable_reg_13(wrenable_reg_13),
    .wrenable_reg_14(wrenable_reg_14),
    .wrenable_reg_15(wrenable_reg_15),
    .wrenable_reg_16(wrenable_reg_16),
    .wrenable_reg_17(wrenable_reg_17),
    .wrenable_reg_18(wrenable_reg_18),
    .wrenable_reg_19(wrenable_reg_19),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_20(wrenable_reg_20),
    .wrenable_reg_21(wrenable_reg_21),
    .wrenable_reg_22(wrenable_reg_22),
    .wrenable_reg_23(wrenable_reg_23),
    .wrenable_reg_24(wrenable_reg_24),
    .wrenable_reg_25(wrenable_reg_25),
    .wrenable_reg_26(wrenable_reg_26),
    .wrenable_reg_27(wrenable_reg_27),
    .wrenable_reg_28(wrenable_reg_28),
    .wrenable_reg_29(wrenable_reg_29),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_30(wrenable_reg_30),
    .wrenable_reg_31(wrenable_reg_31),
    .wrenable_reg_32(wrenable_reg_32),
    .wrenable_reg_33(wrenable_reg_33),
    .wrenable_reg_34(wrenable_reg_34),
    .wrenable_reg_35(wrenable_reg_35),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9),
    .OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621(OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621),
    .OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766(OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942),
    .OUT_mu_S_0_MULTI_UNBOUNDED_0(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .OUT_mu_S_10_MULTI_UNBOUNDED_0(OUT_mu_S_10_MULTI_UNBOUNDED_0),
    .OUT_mu_S_12_MULTI_UNBOUNDED_0(OUT_mu_S_12_MULTI_UNBOUNDED_0),
    .OUT_mu_S_14_MULTI_UNBOUNDED_0(OUT_mu_S_14_MULTI_UNBOUNDED_0),
    .OUT_mu_S_2_MULTI_UNBOUNDED_0(OUT_mu_S_2_MULTI_UNBOUNDED_0),
    .OUT_mu_S_4_MULTI_UNBOUNDED_0(OUT_mu_S_4_MULTI_UNBOUNDED_0),
    .OUT_mu_S_6_MULTI_UNBOUNDED_0(OUT_mu_S_6_MULTI_UNBOUNDED_0),
    .OUT_mu_S_8_MULTI_UNBOUNDED_0(OUT_mu_S_8_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j Datapath_i (._A_read(_A_read),
    ._B_read(_B_read),
    ._C_din(_C_din),
    ._C_write(_C_write),
    .OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621(OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621),
    .OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766(OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937),
    .OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942(OUT_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942),
    .OUT_mu_S_0_MULTI_UNBOUNDED_0(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .OUT_mu_S_10_MULTI_UNBOUNDED_0(OUT_mu_S_10_MULTI_UNBOUNDED_0),
    .OUT_mu_S_12_MULTI_UNBOUNDED_0(OUT_mu_S_12_MULTI_UNBOUNDED_0),
    .OUT_mu_S_14_MULTI_UNBOUNDED_0(OUT_mu_S_14_MULTI_UNBOUNDED_0),
    .OUT_mu_S_2_MULTI_UNBOUNDED_0(OUT_mu_S_2_MULTI_UNBOUNDED_0),
    .OUT_mu_S_4_MULTI_UNBOUNDED_0(OUT_mu_S_4_MULTI_UNBOUNDED_0),
    .OUT_mu_S_6_MULTI_UNBOUNDED_0(OUT_mu_S_6_MULTI_UNBOUNDED_0),
    .OUT_mu_S_8_MULTI_UNBOUNDED_0(OUT_mu_S_8_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .in_port_A(A),
    .in_port_B(B),
    .in_port_C(C),
    .in_port_loop_count(loop_count),
    ._A_dout(_A_dout),
    ._A_empty_n(_A_empty_n),
    ._B_dout(_B_dout),
    ._B_empty_n(_B_empty_n),
    ._C_full_n(_C_full_n),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428564),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428566),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428568),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428570),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428572),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428574),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428576),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428578),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428580),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428582),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428584),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428586),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428588),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428590),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428592),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428594),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428907),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428912),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428917),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428922),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428927),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428932),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428937),
    .selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942(selector_IN_UNBOUNDED__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428942),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_0),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_1),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_2),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_3),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_0_4),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_0),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_1_1),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_fifo_modgen_21_i0_0_2_0),
    .selector_MUX_11_reg_0_0_0_0(selector_MUX_11_reg_0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_1),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_2),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_3),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_0_4),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_1_1),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_fifo_modgen_22_i0_0_2_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_1),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_2),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_0_3),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_1_1),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_1_2_0),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_0),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_1),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_2),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_0_3),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_0),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_1_1),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_fifo_modgen_23_i0_2_2_0),
    .muenable_mu_S_0(muenable_mu_S_0),
    .muenable_mu_S_10(muenable_mu_S_10),
    .muenable_mu_S_12(muenable_mu_S_12),
    .muenable_mu_S_14(muenable_mu_S_14),
    .muenable_mu_S_2(muenable_mu_S_2),
    .muenable_mu_S_4(muenable_mu_S_4),
    .muenable_mu_S_6(muenable_mu_S_6),
    .muenable_mu_S_8(muenable_mu_S_8),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_10(wrenable_reg_10),
    .wrenable_reg_11(wrenable_reg_11),
    .wrenable_reg_12(wrenable_reg_12),
    .wrenable_reg_13(wrenable_reg_13),
    .wrenable_reg_14(wrenable_reg_14),
    .wrenable_reg_15(wrenable_reg_15),
    .wrenable_reg_16(wrenable_reg_16),
    .wrenable_reg_17(wrenable_reg_17),
    .wrenable_reg_18(wrenable_reg_18),
    .wrenable_reg_19(wrenable_reg_19),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_20(wrenable_reg_20),
    .wrenable_reg_21(wrenable_reg_21),
    .wrenable_reg_22(wrenable_reg_22),
    .wrenable_reg_23(wrenable_reg_23),
    .wrenable_reg_24(wrenable_reg_24),
    .wrenable_reg_25(wrenable_reg_25),
    .wrenable_reg_26(wrenable_reg_26),
    .wrenable_reg_27(wrenable_reg_27),
    .wrenable_reg_28(wrenable_reg_28),
    .wrenable_reg_29(wrenable_reg_29),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_30(wrenable_reg_30),
    .wrenable_reg_31(wrenable_reg_31),
    .wrenable_reg_32(wrenable_reg_32),
    .wrenable_reg_33(wrenable_reg_33),
    .wrenable_reg_34(wrenable_reg_34),
    .wrenable_reg_35(wrenable_reg_35),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9));
  flipflop_AR #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) done_delayed_REG (.out1(done_delayed_REG_signal_out),
    .clock(clock),
    .reset(reset),
    .in1(done_delayed_REG_signal_in));
  // io-signal post fix
  assign done_port = done_delayed_REG_signal_out;

endmodule

// Minimal interface for function: _Z6vecaddPK7lanes_tIxLi8EES2_PS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z6vecaddPK7lanes_tIxLi8EES2_PS0_j(clock,
  reset,
  start_port,
  A_dout,
  B_dout,
  loop_count,
  A_empty_n,
  B_empty_n,
  C_full_n,
  done_port,
  A_read,
  B_read,
  C_din,
  C_write);
  // IN
  input clock;
  input reset;
  input start_port;
  input [63:0] A_dout;
  input [63:0] B_dout;
  input [31:0] loop_count;
  input A_empty_n;
  input B_empty_n;
  input C_full_n;
  // OUT
  output done_port;
  output A_read;
  output B_read;
  output [63:0] C_din;
  output C_write;
  // Component and signal declarations
  
  __Z6vecaddPK7lanes_tIxLi8EES2_PS0_j __Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_i0 (.done_port(done_port),
    ._A_read(A_read),
    ._B_read(B_read),
    ._C_din(C_din),
    ._C_write(C_write),
    .clock(clock),
    .reset(reset),
    .start_port(start_port),
    .A(32'b00000000000000000000000000000000),
    .B(32'b00000000000000000000000000000000),
    .C(32'b00000000000000000000000000000000),
    .loop_count(loop_count),
    ._A_dout(A_dout),
    ._A_empty_n(A_empty_n),
    ._B_dout(B_dout),
    ._B_empty_n(B_empty_n),
    ._C_full_n(C_full_n));

endmodule


