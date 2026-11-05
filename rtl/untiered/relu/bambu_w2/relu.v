// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-05T07:06:20
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=relu --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER -DDATA_T=int64_t -DSIZE_N=512 -DBAMBU_LANES=2 --std=c++14 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include/bambu -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_untiered/relu/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_untiered/relu/vectors/n512 relu.cpp 
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
module UIdata_converter_FU(in1,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_out1=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  // OUT
  output signed [BITSIZE_out1-1:0] out1;
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
module IUdata_converter_FU(in1,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_out1=1;
  // IN
  input signed [BITSIZE_in1-1:0] in1;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  generate
  if (BITSIZE_out1 <= BITSIZE_in1)
  begin
    assign out1 = in1[BITSIZE_out1-1:0];
  end
  else
  begin
    assign out1 = {{(BITSIZE_out1-BITSIZE_in1){in1[BITSIZE_in1-1]}},in1};
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
module max_expr_FU(in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1;
  // IN
  input signed [BITSIZE_in1-1:0] in1;
  input signed [BITSIZE_in2-1:0] in2;
  // OUT
  output signed [BITSIZE_out1-1:0] out1;
  assign out1 = in1 > in2 ? in1 : in2;
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_bit_and_expr_FU(in1,
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
  assign out1 = in1 & in2;
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_bit_ior_expr_FU(in1,
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
  assign out1 = in1 | in2;
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

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_rshift_expr_FU(in1,
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
      assign out1 = in1 >> (in2[arg2_bitsize-1:0]);
    else
      assign out1 = in1 >> in2;
  endgenerate

endmodule

// Interface module for function: A_bambu_artificial_ParmMgr_Read_axis
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module A_bambu_artificial_ParmMgr_Read_axis_modgen(clock,
  reset,
  start_port,
  in1,
  _A_TDATA,
  _A_TVALID,
  done_port,
  out1,
  _A_TREADY);
  parameter BITSIZE_in1=32,
    BITSIZE_out1=128;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [127:0] _A_TDATA;
  input _A_TVALID;
  // OUT
  output [0:0] done_port;
  output [BITSIZE_out1-1:0] out1;
  output _A_TREADY;
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
    started_0 = (started || start_port) & ~_A_TVALID;
    done_0 = (started | start_port) & _A_TVALID;
  end
  
  assign out1 = {_A_TVALID, _A_TDATA};
  assign done_port = done_0;
  assign _A_TREADY = done_0;

endmodule

// Interface module for function: B_bambu_artificial_ParmMgr_Write_axis
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module B_bambu_artificial_ParmMgr_Write_axis_modgen(clock,
  reset,
  start_port,
  in1,
  in2,
  in3,
  _B_TREADY,
  done_port,
  out1,
  _B_TDATA,
  _B_TVALID);
  parameter BITSIZE_in1=8,
    BITSIZE_in2=128,
    BITSIZE_in3=32;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  input [BITSIZE_in3-1:0] in3;
  input _B_TREADY;
  // OUT
  output [0:0] done_port;
  output out1;
  output [127:0] _B_TDATA;
  output _B_TVALID;
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
  begin
    started_0 = (started | start_port) & ~_B_TREADY;
  end
  
  assign done_port = (started | start_port) & _B_TREADY;
  assign _B_TVALID = started | start_port;
  assign out1 = _B_TREADY;
  assign _B_TDATA = in2;

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

// Datapath RTL description for _Z4reluPK6ac_intILi128ELb0EEPS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z4reluPK6ac_intILi128ELb0EEPS0_j(clock,
  reset,
  in_port_A,
  in_port_B,
  in_port_loop_count,
  _A_TDATA,
  _A_TVALID,
  _A_TREADY,
  _B_TREADY,
  _B_TDATA,
  _B_TVALID,
  selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561,
  selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0,
  selector_MUX_24_reg_0_0_0_0,
  selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586,
  OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683,
  OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561,
  OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_A;
  input [31:0] in_port_B;
  input [31:0] in_port_loop_count;
  input [127:0] _A_TDATA;
  input _A_TVALID;
  input _B_TREADY;
  input selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561;
  input selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0;
  input selector_MUX_24_reg_0_0_0_0;
  input selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0;
  input wrenable_reg_0;
  input wrenable_reg_1;
  input wrenable_reg_2;
  input wrenable_reg_3;
  input wrenable_reg_4;
  input wrenable_reg_5;
  // OUT
  output _A_TREADY;
  output [127:0] _B_TDATA;
  output _B_TVALID;
  output OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586;
  output OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683;
  output OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561;
  output OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784;
  // Component and signal declarations
  wire [127:0] out_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561;
  wire [62:0] out_IUdata_converter_FU_11_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428723;
  wire [62:0] out_IUdata_converter_FU_5_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428714;
  wire [31:0] out_IUdata_converter_FU_9_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428720;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0;
  wire [31:0] out_MUX_24_reg_0_0_0_0;
  wire [127:0] out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0;
  wire signed [63:0] out_UIdata_converter_FU_4_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428709;
  wire signed [63:0] out_UIdata_converter_FU_8_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428717;
  wire [31:0] out_UUdata_converter_FU_10_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428575;
  wire [30:0] out_UUdata_converter_FU_12_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428579;
  wire out_UUdata_converter_FU_13_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428585;
  wire out_UUdata_converter_FU_16_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428682;
  wire [63:0] out_UUdata_converter_FU_3_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428562;
  wire [62:0] out_UUdata_converter_FU_6_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428567;
  wire [63:0] out_UUdata_converter_FU_7_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428569;
  wire out_const_0;
  wire out_const_1;
  wire [2:0] out_const_2;
  wire [5:0] out_const_3;
  wire [6:0] out_const_4;
  wire [7:0] out_const_5;
  wire [6:0] out_const_6;
  wire [31:0] out_const_7;
  wire [31:0] out_conv_out_const_0_1_32;
  wire [127:0] out_conv_out_reg_5_reg_5_127_128;
  wire [127:0] out_conv_out_ui_bit_ior_expr_FU_0_64_64_24_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428581_127_128;
  wire signed [63:0] out_max_expr_FU_64_0_64_18_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428566;
  wire signed [63:0] out_max_expr_FU_64_0_64_18_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428573;
  wire out_read_cond_FU_14_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586;
  wire out_read_cond_FU_17_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683;
  wire [31:0] out_reg_0_reg_0;
  wire [31:0] out_reg_1_reg_1;
  wire [127:0] out_reg_2_reg_2;
  wire [31:0] out_reg_3_reg_3;
  wire out_reg_4_reg_4;
  wire [126:0] out_reg_5_reg_5;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_19_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428563;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_19_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428570;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_20_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428564;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_20_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428571;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_20_i2_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428574;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_21_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428565;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_22_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428572;
  wire [95:0] out_ui_bit_ior_expr_FU_0_64_64_23_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428577;
  wire [126:0] out_ui_bit_ior_expr_FU_0_64_64_24_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428581;
  wire out_ui_eq_expr_FU_32_0_32_25_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428738;
  wire out_ui_eq_expr_FU_32_32_32_26_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428732;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_27_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428703;
  wire [95:0] out_ui_lshift_expr_FU_64_0_64_28_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428576;
  wire [126:0] out_ui_lshift_expr_FU_64_0_64_29_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428580;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_30_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428793;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_30_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428800;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_31_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428584;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_32_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428560;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_32_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428582;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_33_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428568;
  wire [30:0] out_ui_rshift_expr_FU_64_0_64_34_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428578;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_35_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428788;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_35_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428796;
  wire [31:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire s_done_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561_P0;
  wire s_done_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784_P0;
  
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0),
    .in1(out_reg_1_reg_1),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_32_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428560));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_24_reg_0_0_0_0 (.out1(out_MUX_24_reg_0_0_0_0),
    .sel(selector_MUX_24_reg_0_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_31_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428584),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(128),
    .BITSIZE_in2(128),
    .BITSIZE_out1(128)) MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0 (.out1(out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0),
    .sel(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0),
    .in1(out_conv_out_reg_5_reg_5_127_128),
    .in2(out_conv_out_ui_bit_ior_expr_FU_0_64_64_24_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428581_127_128));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) UUdata_converter_FU_uu_conv_0 (.out1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in1(out_conv_out_const_0_1_32));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b0)) const_0 (.out1(out_const_0));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b1)) const_1 (.out1(out_const_1));
  constant_value #(.BITSIZE_out1(3),
    .value(3'b100)) const_2 (.out1(out_const_2));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b100000)) const_3 (.out1(out_const_3));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1000000)) const_4 (.out1(out_const_4));
  constant_value #(.BITSIZE_out1(8),
    .value(8'b10000000)) const_5 (.out1(out_const_5));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1100000)) const_6 (.out1(out_const_6));
  constant_value #(.BITSIZE_out1(32),
    .value(32'b11111111111111111111111111111111)) const_7 (.out1(out_const_7));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(127),
    .BITSIZE_out1(128)) conv_out_reg_5_reg_5_127_128 (.out1(out_conv_out_reg_5_reg_5_127_128),
    .in1(out_reg_5_reg_5));
  UUdata_converter_FU #(.BITSIZE_in1(127),
    .BITSIZE_out1(128)) conv_out_ui_bit_ior_expr_FU_0_64_64_24_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428581_127_128 (.out1(out_conv_out_ui_bit_ior_expr_FU_0_64_64_24_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428581_127_128),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_24_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428581));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428560 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_32_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428560),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_27_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428703));
  A_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(128)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561 (.done_port({s_done_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561_P0}),
    .out1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561),
    ._A_TREADY(_A_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561}),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID));
  UUdata_converter_FU #(.BITSIZE_in1(128),
    .BITSIZE_out1(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428562 (.out1(out_UUdata_converter_FU_3_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428562),
    .in1(out_reg_2_reg_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428563 (.out1(out_ui_bit_and_expr_FU_32_0_32_19_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428563),
    .in1(out_ui_rshift_expr_FU_64_0_64_35_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428788),
    .in2(out_const_7));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428564 (.out1(out_ui_bit_and_expr_FU_32_0_32_20_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428564),
    .in1(out_UUdata_converter_FU_3_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428562),
    .in2(out_const_7));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428565 (.out1(out_ui_bit_ior_expr_FU_0_64_64_21_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428565),
    .in1(out_ui_lshift_expr_FU_64_0_64_30_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428793),
    .in2(out_ui_bit_and_expr_FU_32_0_32_20_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428564));
  max_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(1),
    .BITSIZE_out1(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428566 (.out1(out_max_expr_FU_64_0_64_18_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428566),
    .in1(out_UIdata_converter_FU_4_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428709),
    .in2(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(63),
    .BITSIZE_out1(63)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428567 (.out1(out_UUdata_converter_FU_6_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428567),
    .in1(out_IUdata_converter_FU_5_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428714));
  ui_rshift_expr_FU #(.BITSIZE_in1(128),
    .BITSIZE_in2(7),
    .BITSIZE_out1(64),
    .PRECISION(128)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428568 (.out1(out_ui_rshift_expr_FU_64_0_64_33_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428568),
    .in1(out_reg_2_reg_2),
    .in2(out_const_4));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428569 (.out1(out_UUdata_converter_FU_7_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428569),
    .in1(out_ui_rshift_expr_FU_64_0_64_33_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428568));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428570 (.out1(out_ui_bit_and_expr_FU_32_0_32_19_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428570),
    .in1(out_ui_rshift_expr_FU_64_0_64_35_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428796),
    .in2(out_const_7));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428571 (.out1(out_ui_bit_and_expr_FU_32_0_32_20_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428571),
    .in1(out_UUdata_converter_FU_7_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428569),
    .in2(out_const_7));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428572 (.out1(out_ui_bit_ior_expr_FU_0_64_64_22_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428572),
    .in1(out_ui_lshift_expr_FU_64_0_64_30_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428800),
    .in2(out_ui_bit_and_expr_FU_32_0_32_20_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428571));
  max_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(1),
    .BITSIZE_out1(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428573 (.out1(out_max_expr_FU_64_0_64_18_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428573),
    .in1(out_UIdata_converter_FU_8_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428717),
    .in2(out_const_0));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428574 (.out1(out_ui_bit_and_expr_FU_32_0_32_20_i2_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428574),
    .in1(out_IUdata_converter_FU_9_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428720),
    .in2(out_const_7));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428575 (.out1(out_UUdata_converter_FU_10_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428575),
    .in1(out_ui_bit_and_expr_FU_32_0_32_20_i2_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428574));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(7),
    .BITSIZE_out1(96),
    .PRECISION(128)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428576 (.out1(out_ui_lshift_expr_FU_64_0_64_28_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428576),
    .in1(out_UUdata_converter_FU_10_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428575),
    .in2(out_const_4));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(96),
    .BITSIZE_in2(63),
    .BITSIZE_out1(96)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428577 (.out1(out_ui_bit_ior_expr_FU_0_64_64_23_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428577),
    .in1(out_ui_lshift_expr_FU_64_0_64_28_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428576),
    .in2(out_UUdata_converter_FU_6_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428567));
  ui_rshift_expr_FU #(.BITSIZE_in1(63),
    .BITSIZE_in2(6),
    .BITSIZE_out1(31),
    .PRECISION(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428578 (.out1(out_ui_rshift_expr_FU_64_0_64_34_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428578),
    .in1(out_IUdata_converter_FU_11_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428723),
    .in2(out_const_3));
  UUdata_converter_FU #(.BITSIZE_in1(31),
    .BITSIZE_out1(31)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428579 (.out1(out_UUdata_converter_FU_12_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428579),
    .in1(out_ui_rshift_expr_FU_64_0_64_34_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428578));
  ui_lshift_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(7),
    .BITSIZE_out1(127),
    .PRECISION(128)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428580 (.out1(out_ui_lshift_expr_FU_64_0_64_29_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428580),
    .in1(out_UUdata_converter_FU_12_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428579),
    .in2(out_const_6));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(127),
    .BITSIZE_in2(96),
    .BITSIZE_out1(127)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428581 (.out1(out_ui_bit_ior_expr_FU_0_64_64_24_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428581),
    .in1(out_ui_lshift_expr_FU_64_0_64_29_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428580),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_23_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428577));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428582 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_32_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428582),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_27_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428703));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428584 (.out1(out_ui_plus_expr_FU_32_0_32_31_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428584),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428585 (.out1(out_UUdata_converter_FU_13_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428585),
    .in1(out_ui_eq_expr_FU_32_32_32_26_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428732));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586 (.out1(out_read_cond_FU_14_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586),
    .in1(out_reg_4_reg_4));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428682 (.out1(out_UUdata_converter_FU_16_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428682),
    .in1(out_ui_eq_expr_FU_32_0_32_25_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428738));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683 (.out1(out_read_cond_FU_17_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683),
    .in1(out_UUdata_converter_FU_16_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428682));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(3),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428703 (.out1(out_ui_lshift_expr_FU_32_0_32_27_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428703),
    .in1(out_reg_0_reg_0),
    .in2(out_const_2));
  UIdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428709 (.out1(out_UIdata_converter_FU_4_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428709),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_21_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428565));
  IUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(63)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428714 (.out1(out_IUdata_converter_FU_5_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428714),
    .in1(out_max_expr_FU_64_0_64_18_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428566));
  UIdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428717 (.out1(out_UIdata_converter_FU_8_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428717),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_22_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428572));
  IUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(32)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428720 (.out1(out_IUdata_converter_FU_9_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428720),
    .in1(out_max_expr_FU_64_0_64_18_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428573));
  IUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(63)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428723 (.out1(out_IUdata_converter_FU_11_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428723),
    .in1(out_max_expr_FU_64_0_64_18_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428573));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428732 (.out1(out_ui_eq_expr_FU_32_32_32_26_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428732),
    .in1(out_ui_plus_expr_FU_32_0_32_31_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428584),
    .in2(in_port_loop_count));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428738 (.out1(out_ui_eq_expr_FU_32_0_32_25_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428738),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  B_bambu_artificial_ParmMgr_Write_axis_modgen #(.BITSIZE_in1(8),
    .BITSIZE_in2(128),
    .BITSIZE_in3(32)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784 (.done_port({s_done_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784_P0}),
    ._B_TDATA(_B_TDATA),
    ._B_TVALID(_B_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784}),
    .in1(out_const_5),
    .in2(out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0),
    .in3(out_reg_3_reg_3),
    ._B_TREADY(_B_TREADY));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428788 (.out1(out_ui_rshift_expr_FU_64_0_64_35_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428788),
    .in1(out_UUdata_converter_FU_3_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428562),
    .in2(out_const_3));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428793 (.out1(out_ui_lshift_expr_FU_64_0_64_30_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428793),
    .in1(out_ui_bit_and_expr_FU_32_0_32_19_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428563),
    .in2(out_const_3));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428796 (.out1(out_ui_rshift_expr_FU_64_0_64_35_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428796),
    .in1(out_UUdata_converter_FU_7_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428569),
    .in2(out_const_3));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428800 (.out1(out_ui_lshift_expr_FU_64_0_64_30_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428800),
    .in1(out_ui_bit_and_expr_FU_32_0_32_19_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428570),
    .in2(out_const_3));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_24_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_32_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428560),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(128),
    .BITSIZE_out1(128)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_32_i1_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428582),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_13_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428585),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(127),
    .BITSIZE_out1(127)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_24_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428581),
    .wenable(wrenable_reg_5));
  // io-signal post fix
  assign OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586 = out_read_cond_FU_14_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586;
  assign OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683 = out_read_cond_FU_17_i0_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683;
  assign OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561 = s_done_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561_P0;
  assign OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784 = s_done_fu__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784_P0;

endmodule

// FSM based controller description for _Z4reluPK6ac_intILi128ELb0EEPS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z4reluPK6ac_intILi128ELb0EEPS0_j(done_port,
  selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561,
  selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0,
  selector_MUX_24_reg_0_0_0_0,
  selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586,
  OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683,
  OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561,
  OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586;
  input OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683;
  input OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561;
  input OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561;
  output selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0;
  output selector_MUX_24_reg_0_0_0_0;
  output selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0;
  output wrenable_reg_0;
  output wrenable_reg_1;
  output wrenable_reg_2;
  output wrenable_reg_3;
  output wrenable_reg_4;
  output wrenable_reg_5;
  parameter [2:0] S_5 = 3'd5,
    S_7 = 3'd7,
    S_0 = 3'd0,
    S_1 = 3'd1,
    S_2 = 3'd2,
    S_3 = 3'd3,
    S_4 = 3'd4,
    S_6 = 3'd6;
  reg [2:0] _present_state=S_5, _next_state;
  reg done_port;
  reg selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561;
  reg selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0;
  reg selector_MUX_24_reg_0_0_0_0;
  reg selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0;
  reg wrenable_reg_0;
  reg wrenable_reg_1;
  reg wrenable_reg_2;
  reg wrenable_reg_3;
  reg wrenable_reg_4;
  reg wrenable_reg_5;
  
  always @(posedge clock)
    if (reset == 1'b0) _present_state <= S_5;
    else _present_state <= _next_state;
  
  always @(*)
  begin
    done_port = 1'b0;
    selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561 = 1'b0;
    selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0 = 1'b0;
    selector_MUX_24_reg_0_0_0_0 = 1'b0;
    selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0 = 1'b0;
    wrenable_reg_0 = 1'b0;
    wrenable_reg_1 = 1'b0;
    wrenable_reg_2 = 1'b0;
    wrenable_reg_3 = 1'b0;
    wrenable_reg_4 = 1'b0;
    wrenable_reg_5 = 1'b0;
    case (_present_state)
      S_5 :
        if(start_port == 1'b1)
        begin
          wrenable_reg_0 = 1'b1;
          if (OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683 == 1'b0)
            begin
              _next_state = S_0;
            end
          else
            begin
              _next_state = S_7;
              done_port = 1'b1;
              wrenable_reg_0 = 1'b0;
            end
        end
        else
        begin
          _next_state = S_5;
        end
      S_7 :
        begin
          _next_state = S_5;
        end
      S_0 :
        begin
          selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561 = 1'b1;
          selector_MUX_24_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_2 = OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561;
          wrenable_reg_3 = 1'b1;
          wrenable_reg_4 = 1'b1;
          if (OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561 == 1'b0)
            begin
              _next_state = S_1;
            end
          else
            begin
              _next_state = S_2;
            end
        end
      S_1 :
        begin
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0 = 1'b1;
          wrenable_reg_2 = OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561;
          if (OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561 == 1'b0)
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
          selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784 = 1'b1;
          wrenable_reg_5 = 1'b1;
          if (OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784 == 1'b0)
            begin
              _next_state = S_3;
            end
          else
            begin
              _next_state = S_4;
            end
        end
      S_3 :
        begin
          selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0 = 1'b1;
          if (OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784 == 1'b0)
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
          if (OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586 == 1'b0)
            begin
              _next_state = S_0;
            end
          else
            begin
              _next_state = S_6;
              done_port = 1'b1;
            end
        end
      S_6 :
        begin
          _next_state = S_5;
        end
      default :
        begin
          _next_state = S_5;
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

// Top component for _Z4reluPK6ac_intILi128ELb0EEPS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z4reluPK6ac_intILi128ELb0EEPS0_j(clock,
  reset,
  start_port,
  done_port,
  A,
  B,
  loop_count,
  _A_TDATA,
  _A_TVALID,
  _B_TREADY,
  _A_TREADY,
  _B_TDATA,
  _B_TVALID);
  // IN
  input clock;
  input reset;
  input start_port;
  input [31:0] A;
  input [31:0] B;
  input [31:0] loop_count;
  input [127:0] _A_TDATA;
  input _A_TVALID;
  input _B_TREADY;
  // OUT
  output done_port;
  output _A_TREADY;
  output [127:0] _B_TDATA;
  output _B_TVALID;
  // Component and signal declarations
  wire OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586;
  wire OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683;
  wire OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561;
  wire OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561;
  wire selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0;
  wire selector_MUX_24_reg_0_0_0_0;
  wire selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0;
  wire wrenable_reg_0;
  wire wrenable_reg_1;
  wire wrenable_reg_2;
  wire wrenable_reg_3;
  wire wrenable_reg_4;
  wire wrenable_reg_5;
  
  controller__Z4reluPK6ac_intILi128ELb0EEPS0_j Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561(selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561),
    .selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784(selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0),
    .selector_MUX_24_reg_0_0_0_0(selector_MUX_24_reg_0_0_0_0),
    .selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586(OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586),
    .OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683(OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683),
    .OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561(OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561),
    .OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784(OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z4reluPK6ac_intILi128ELb0EEPS0_j Datapath_i (._A_TREADY(_A_TREADY),
    ._B_TDATA(_B_TDATA),
    ._B_TVALID(_B_TVALID),
    .OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586(OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428586),
    .OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683(OUT_CONDITION__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428683),
    .OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561(OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561),
    .OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784(OUT_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784),
    .clock(clock),
    .reset(reset),
    .in_port_A(A),
    .in_port_B(B),
    .in_port_loop_count(loop_count),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID),
    ._B_TREADY(_B_TREADY),
    .selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561(selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428561),
    .selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784(selector_IN_UNBOUNDED__Z4reluPK6ac_intILi128ELb0EEPS0_j_428532_428784),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_36_i0_0_0_0),
    .selector_MUX_24_reg_0_0_0_0(selector_MUX_24_reg_0_0_0_0),
    .selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_37_i0_1_0_0),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5));
  flipflop_AR #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) done_delayed_REG (.out1(done_delayed_REG_signal_out),
    .clock(clock),
    .reset(reset),
    .in1(done_delayed_REG_signal_in));
  // io-signal post fix
  assign done_port = done_delayed_REG_signal_out;

endmodule

// Minimal interface for function: _Z4reluPK6ac_intILi128ELb0EEPS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z4reluPK6ac_intILi128ELb0EEPS0_j(clock,
  reset,
  start_port,
  A_TDATA,
  loop_count,
  A_TVALID,
  B_TREADY,
  done_port,
  A_TREADY,
  B_TDATA,
  B_TVALID);
  // IN
  input clock;
  input reset;
  input start_port;
  input [127:0] A_TDATA;
  input [31:0] loop_count;
  input A_TVALID;
  input B_TREADY;
  // OUT
  output done_port;
  output A_TREADY;
  output [127:0] B_TDATA;
  output B_TVALID;
  // Component and signal declarations
  
  __Z4reluPK6ac_intILi128ELb0EEPS0_j __Z4reluPK6ac_intILi128ELb0EEPS0_j_i0 (.done_port(done_port),
    ._A_TREADY(A_TREADY),
    ._B_TDATA(B_TDATA),
    ._B_TVALID(B_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port(start_port),
    .A(32'b00000000000000000000000000000000),
    .B(32'b00000000000000000000000000000000),
    .loop_count(loop_count),
    ._A_TDATA(A_TDATA),
    ._A_TVALID(A_TVALID),
    ._B_TREADY(B_TREADY));

endmodule


