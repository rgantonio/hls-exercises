// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-05T07:06:20
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=relu --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER -DDATA_T=int64_t -DSIZE_N=512 -DBAMBU_LANES=1 --std=c++14 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include/bambu -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_untiered/relu/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_untiered/relu/vectors/n512 relu.cpp 
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
module multi_read_cond_FU(in1,
  out1);
  parameter BITSIZE_in1=1, PORTSIZE_in1=2,
    BITSIZE_out1=1;
  // IN
  input [(PORTSIZE_in1*BITSIZE_in1)+(-1):0] in1;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  assign out1 = in1;
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
module truth_and_expr_FU(in1,
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
  assign out1 = in1 && in2;
endmodule

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module truth_not_expr_FU(in1,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_out1=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  assign out1 = !in1;
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
    BITSIZE_out1=64;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [63:0] _A_TDATA;
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
  input _B_TREADY;
  // OUT
  output [0:0] done_port;
  output out1;
  output [63:0] _B_TDATA;
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

// Datapath RTL description for _Z4reluPKxPxj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z4reluPKxPxj(clock,
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
  selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561,
  selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600,
  selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621,
  selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796,
  selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801,
  selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0,
  selector_MUX_26_reg_0_0_0_0,
  selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0,
  selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1,
  selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2,
  selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0,
  selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1,
  selector_MUX_30_reg_12_0_0_0,
  selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0,
  selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1,
  muenable_mu_S_7,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_10,
  wrenable_reg_11,
  wrenable_reg_12,
  wrenable_reg_13,
  wrenable_reg_14,
  wrenable_reg_15,
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_MULTIIF__Z4reluPKxPxj_428532_428837,
  OUT_MULTIIF__Z4reluPKxPxj_428532_428850,
  OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561,
  OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600,
  OUT_UNBOUNDED__Z4reluPKxPxj_428532_428621,
  OUT_UNBOUNDED__Z4reluPKxPxj_428532_428796,
  OUT_UNBOUNDED__Z4reluPKxPxj_428532_428801,
  OUT_UNBOUNDED__Z4reluPKxPxj_428532_428806,
  OUT_mu_S_7_MULTI_UNBOUNDED_0);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_A;
  input [31:0] in_port_B;
  input [31:0] in_port_loop_count;
  input [63:0] _A_TDATA;
  input _A_TVALID;
  input _B_TREADY;
  input selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561;
  input selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600;
  input selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621;
  input selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796;
  input selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801;
  input selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0;
  input selector_MUX_26_reg_0_0_0_0;
  input selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0;
  input selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1;
  input selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2;
  input selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0;
  input selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1;
  input selector_MUX_30_reg_12_0_0_0;
  input selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0;
  input selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1;
  input muenable_mu_S_7;
  input wrenable_reg_0;
  input wrenable_reg_1;
  input wrenable_reg_10;
  input wrenable_reg_11;
  input wrenable_reg_12;
  input wrenable_reg_13;
  input wrenable_reg_14;
  input wrenable_reg_15;
  input wrenable_reg_2;
  input wrenable_reg_3;
  input wrenable_reg_4;
  input wrenable_reg_5;
  input wrenable_reg_6;
  input wrenable_reg_7;
  input wrenable_reg_8;
  input wrenable_reg_9;
  // OUT
  output _A_TREADY;
  output [63:0] _B_TDATA;
  output _B_TVALID;
  output [1:0] OUT_MULTIIF__Z4reluPKxPxj_428532_428837;
  output [1:0] OUT_MULTIIF__Z4reluPKxPxj_428532_428850;
  output OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561;
  output OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600;
  output OUT_UNBOUNDED__Z4reluPKxPxj_428532_428621;
  output OUT_UNBOUNDED__Z4reluPKxPxj_428532_428796;
  output OUT_UNBOUNDED__Z4reluPKxPxj_428532_428801;
  output OUT_UNBOUNDED__Z4reluPKxPxj_428532_428806;
  output OUT_mu_S_7_MULTI_UNBOUNDED_0;
  // Component and signal declarations
  wire [63:0] out_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0;
  wire [62:0] out_IUdata_converter_FU_14_i0_fu__Z4reluPKxPxj_428532_428738;
  wire [62:0] out_IUdata_converter_FU_16_i0_fu__Z4reluPKxPxj_428532_428742;
  wire [62:0] out_IUdata_converter_FU_6_i0_fu__Z4reluPKxPxj_428532_428703;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0;
  wire [31:0] out_MUX_26_reg_0_0_0_0;
  wire [63:0] out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0;
  wire [63:0] out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1;
  wire [63:0] out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2;
  wire [63:0] out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0;
  wire [63:0] out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1;
  wire [28:0] out_MUX_30_reg_12_0_0_0;
  wire [31:0] out_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0;
  wire [31:0] out_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1;
  wire signed [63:0] out_UIdata_converter_FU_13_i0_fu__Z4reluPKxPxj_428532_428719;
  wire signed [63:0] out_UIdata_converter_FU_15_i0_fu__Z4reluPKxPxj_428532_428728;
  wire signed [63:0] out_UIdata_converter_FU_5_i0_fu__Z4reluPKxPxj_428532_428695;
  wire out_UUdata_converter_FU_17_i0_fu__Z4reluPKxPxj_428532_428660;
  wire out_UUdata_converter_FU_19_i0_fu__Z4reluPKxPxj_428532_428668;
  wire out_UUdata_converter_FU_20_i0_fu__Z4reluPKxPxj_428532_428645;
  wire out_UUdata_converter_FU_21_i0_fu__Z4reluPKxPxj_428532_428656;
  wire out_const_0;
  wire out_const_1;
  wire [6:0] out_const_2;
  wire [1:0] out_const_3;
  wire [30:0] out_const_4;
  wire [63:0] out_conv_out_IUdata_converter_FU_14_i0_fu__Z4reluPKxPxj_428532_428738_63_64;
  wire [63:0] out_conv_out_IUdata_converter_FU_16_i0_fu__Z4reluPKxPxj_428532_428742_63_64;
  wire [63:0] out_conv_out_IUdata_converter_FU_6_i0_fu__Z4reluPKxPxj_428532_428703_63_64;
  wire [28:0] out_conv_out_const_0_1_29;
  wire [31:0] out_conv_out_const_0_1_32;
  wire [28:0] out_conv_out_reg_0_reg_0_32_29;
  wire [63:0] out_conv_out_reg_10_reg_10_63_64;
  wire [63:0] out_conv_out_reg_11_reg_11_63_64;
  wire [63:0] out_conv_out_reg_15_reg_15_63_64;
  wire signed [63:0] out_max_expr_FU_64_0_64_23_i0_fu__Z4reluPKxPxj_428532_428562;
  wire signed [63:0] out_max_expr_FU_64_0_64_23_i1_fu__Z4reluPKxPxj_428532_428593;
  wire signed [63:0] out_max_expr_FU_64_0_64_23_i2_fu__Z4reluPKxPxj_428532_428617;
  wire [1:0] out_multi_read_cond_FU_18_i0_fu__Z4reluPKxPxj_428532_428850;
  wire [1:0] out_multi_read_cond_FU_22_i0_fu__Z4reluPKxPxj_428532_428837;
  wire [31:0] out_reg_0_reg_0;
  wire [62:0] out_reg_10_reg_10;
  wire [62:0] out_reg_11_reg_11;
  wire [28:0] out_reg_12_reg_12;
  wire [31:0] out_reg_13_reg_13;
  wire [31:0] out_reg_14_reg_14;
  wire [62:0] out_reg_15_reg_15;
  wire out_reg_1_reg_1;
  wire [30:0] out_reg_2_reg_2;
  wire [31:0] out_reg_3_reg_3;
  wire [63:0] out_reg_4_reg_4;
  wire [31:0] out_reg_5_reg_5;
  wire [31:0] out_reg_6_reg_6;
  wire [31:0] out_reg_7_reg_7;
  wire out_reg_8_reg_8;
  wire out_reg_9_reg_9;
  wire out_truth_and_expr_FU_1_1_1_24_i0_fu__Z4reluPKxPxj_428532_428843;
  wire out_truth_and_expr_FU_1_1_1_24_i1_fu__Z4reluPKxPxj_428532_428856;
  wire out_truth_not_expr_FU_1_1_25_i0_fu__Z4reluPKxPxj_428532_428840;
  wire out_truth_not_expr_FU_1_1_25_i1_fu__Z4reluPKxPxj_428532_428853;
  wire [0:0] out_ui_bit_and_expr_FU_1_0_1_26_i0_fu__Z4reluPKxPxj_428532_428644;
  wire [30:0] out_ui_bit_and_expr_FU_32_0_32_27_i0_fu__Z4reluPKxPxj_428532_428665;
  wire [28:0] out_ui_bit_ior_expr_FU_32_0_32_28_i0_fu__Z4reluPKxPxj_428532_428613;
  wire out_ui_eq_expr_FU_1_0_1_29_i0_fu__Z4reluPKxPxj_428532_428712;
  wire out_ui_eq_expr_FU_32_0_32_30_i0_fu__Z4reluPKxPxj_428532_428709;
  wire out_ui_eq_expr_FU_32_0_32_31_i0_fu__Z4reluPKxPxj_428532_428744;
  wire out_ui_eq_expr_FU_32_32_32_32_i0_fu__Z4reluPKxPxj_428532_428733;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_33_i0_fu__Z4reluPKxPxj_428532_428689;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_33_i1_fu__Z4reluPKxPxj_428532_428715;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_33_i2_fu__Z4reluPKxPxj_428532_428724;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_34_i0_fu__Z4reluPKxPxj_428532_428817;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_34_i1_fu__Z4reluPKxPxj_428532_428830;
  wire [30:0] out_ui_plus_expr_FU_32_0_32_35_i0_fu__Z4reluPKxPxj_428532_428814;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_36_i0_fu__Z4reluPKxPxj_428532_428560;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_36_i1_fu__Z4reluPKxPxj_428532_428563;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_36_i2_fu__Z4reluPKxPxj_428532_428579;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_36_i3_fu__Z4reluPKxPxj_428532_428603;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_36_i4_fu__Z4reluPKxPxj_428532_428609;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_36_i5_fu__Z4reluPKxPxj_428532_428624;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_37_i0_fu__Z4reluPKxPxj_428532_428810;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_37_i1_fu__Z4reluPKxPxj_428532_428820;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_37_i2_fu__Z4reluPKxPxj_428532_428823;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_37_i3_fu__Z4reluPKxPxj_428532_428826;
  wire [28:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire [28:0] out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1;
  wire [31:0] out_uu_conv_conn_obj_2_UUdata_converter_FU_uu_conv_2;
  wire s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_P0;
  wire s_done_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_P0;
  wire s_start_port0;
  wire s_start_port1;
  
  A_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(64)) A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0 (.done_port({s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_P0}),
    .out1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0),
    ._A_TREADY(_A_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port0}),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID));
  B_bambu_artificial_ParmMgr_Write_axis_modgen #(.BITSIZE_in1(7),
    .BITSIZE_in2(64),
    .BITSIZE_in3(32)) B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0 (.done_port({s_done_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_P0}),
    ._B_TDATA(_B_TDATA),
    ._B_TVALID(_B_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port1}),
    .in1(out_const_2),
    .in2(out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1),
    .in3(out_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1),
    ._B_TREADY(_B_TREADY));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0),
    .in1(out_reg_7_reg_7),
    .in2(out_reg_5_reg_5));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1),
    .in1(out_reg_13_reg_13),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_36_i0_fu__Z4reluPKxPxj_428532_428560));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_36_i3_fu__Z4reluPKxPxj_428532_428603),
    .in2(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1),
    .in2(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_26_reg_0_0_0_0 (.out1(out_MUX_26_reg_0_0_0_0),
    .sel(selector_MUX_26_reg_0_0_0_0),
    .in1(out_ui_lshift_expr_FU_32_0_32_34_i0_fu__Z4reluPKxPxj_428532_428817),
    .in2(out_uu_conv_conn_obj_2_UUdata_converter_FU_uu_conv_2));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0 (.out1(out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0),
    .sel(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0),
    .in1(out_conv_out_reg_15_reg_15_63_64),
    .in2(out_conv_out_reg_11_reg_11_63_64));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1 (.out1(out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1),
    .sel(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1),
    .in1(out_conv_out_reg_10_reg_10_63_64),
    .in2(out_conv_out_IUdata_converter_FU_14_i0_fu__Z4reluPKxPxj_428532_428738_63_64));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2 (.out1(out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2),
    .sel(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2),
    .in1(out_conv_out_IUdata_converter_FU_16_i0_fu__Z4reluPKxPxj_428532_428742_63_64),
    .in2(out_conv_out_IUdata_converter_FU_6_i0_fu__Z4reluPKxPxj_428532_428703_63_64));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0 (.out1(out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0),
    .sel(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0),
    .in1(out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0),
    .in2(out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1 (.out1(out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1),
    .sel(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1),
    .in1(out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2),
    .in2(out_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0));
  MUX_GATE #(.BITSIZE_in1(29),
    .BITSIZE_in2(29),
    .BITSIZE_out1(29)) MUX_30_reg_12_0_0_0 (.out1(out_MUX_30_reg_12_0_0_0),
    .sel(selector_MUX_30_reg_12_0_0_0),
    .in1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0 (.out1(out_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0),
    .sel(selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0),
    .in1(out_reg_6_reg_6),
    .in2(out_reg_3_reg_3));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1 (.out1(out_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1),
    .sel(selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1),
    .in1(out_reg_14_reg_14),
    .in2(out_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0));
  UUdata_converter_FU #(.BITSIZE_in1(29),
    .BITSIZE_out1(29)) UUdata_converter_FU_uu_conv_0 (.out1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in1(out_conv_out_reg_0_reg_0_32_29));
  UUdata_converter_FU #(.BITSIZE_in1(29),
    .BITSIZE_out1(29)) UUdata_converter_FU_uu_conv_1 (.out1(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1),
    .in1(out_conv_out_const_0_1_29));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) UUdata_converter_FU_uu_conv_2 (.out1(out_uu_conv_conn_obj_2_UUdata_converter_FU_uu_conv_2),
    .in1(out_conv_out_const_0_1_32));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b0)) const_0 (.out1(out_const_0));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b1)) const_1 (.out1(out_const_1));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1000000)) const_2 (.out1(out_const_2));
  constant_value #(.BITSIZE_out1(2),
    .value(2'b11)) const_3 (.out1(out_const_3));
  constant_value #(.BITSIZE_out1(31),
    .value(31'b1111111111111111111111111111111)) const_4 (.out1(out_const_4));
  UUdata_converter_FU #(.BITSIZE_in1(63),
    .BITSIZE_out1(64)) conv_out_IUdata_converter_FU_14_i0_fu__Z4reluPKxPxj_428532_428738_63_64 (.out1(out_conv_out_IUdata_converter_FU_14_i0_fu__Z4reluPKxPxj_428532_428738_63_64),
    .in1(out_IUdata_converter_FU_14_i0_fu__Z4reluPKxPxj_428532_428738));
  UUdata_converter_FU #(.BITSIZE_in1(63),
    .BITSIZE_out1(64)) conv_out_IUdata_converter_FU_16_i0_fu__Z4reluPKxPxj_428532_428742_63_64 (.out1(out_conv_out_IUdata_converter_FU_16_i0_fu__Z4reluPKxPxj_428532_428742_63_64),
    .in1(out_IUdata_converter_FU_16_i0_fu__Z4reluPKxPxj_428532_428742));
  UUdata_converter_FU #(.BITSIZE_in1(63),
    .BITSIZE_out1(64)) conv_out_IUdata_converter_FU_6_i0_fu__Z4reluPKxPxj_428532_428703_63_64 (.out1(out_conv_out_IUdata_converter_FU_6_i0_fu__Z4reluPKxPxj_428532_428703_63_64),
    .in1(out_IUdata_converter_FU_6_i0_fu__Z4reluPKxPxj_428532_428703));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(29)) conv_out_const_0_1_29 (.out1(out_conv_out_const_0_1_29),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(29)) conv_out_reg_0_reg_0_32_29 (.out1(out_conv_out_reg_0_reg_0_32_29),
    .in1(out_reg_0_reg_0));
  UUdata_converter_FU #(.BITSIZE_in1(63),
    .BITSIZE_out1(64)) conv_out_reg_10_reg_10_63_64 (.out1(out_conv_out_reg_10_reg_10_63_64),
    .in1(out_reg_10_reg_10));
  UUdata_converter_FU #(.BITSIZE_in1(63),
    .BITSIZE_out1(64)) conv_out_reg_11_reg_11_63_64 (.out1(out_conv_out_reg_11_reg_11_63_64),
    .in1(out_reg_11_reg_11));
  UUdata_converter_FU #(.BITSIZE_in1(63),
    .BITSIZE_out1(64)) conv_out_reg_15_reg_15_63_64 (.out1(out_conv_out_reg_15_reg_15_63_64),
    .in1(out_reg_15_reg_15));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4reluPKxPxj_428532_428560 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_36_i0_fu__Z4reluPKxPxj_428532_428560),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_33_i0_fu__Z4reluPKxPxj_428532_428689));
  max_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(1),
    .BITSIZE_out1(64)) fu__Z4reluPKxPxj_428532_428562 (.out1(out_max_expr_FU_64_0_64_23_i0_fu__Z4reluPKxPxj_428532_428562),
    .in1(out_UIdata_converter_FU_5_i0_fu__Z4reluPKxPxj_428532_428695),
    .in2(out_const_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4reluPKxPxj_428532_428563 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_36_i1_fu__Z4reluPKxPxj_428532_428563),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_33_i0_fu__Z4reluPKxPxj_428532_428689));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4reluPKxPxj_428532_428579 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_36_i2_fu__Z4reluPKxPxj_428532_428579),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_33_i1_fu__Z4reluPKxPxj_428532_428715));
  max_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(1),
    .BITSIZE_out1(64)) fu__Z4reluPKxPxj_428532_428593 (.out1(out_max_expr_FU_64_0_64_23_i1_fu__Z4reluPKxPxj_428532_428593),
    .in1(out_UIdata_converter_FU_13_i0_fu__Z4reluPKxPxj_428532_428719),
    .in2(out_const_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4reluPKxPxj_428532_428603 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_36_i3_fu__Z4reluPKxPxj_428532_428603),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_33_i1_fu__Z4reluPKxPxj_428532_428715));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4reluPKxPxj_428532_428609 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_36_i4_fu__Z4reluPKxPxj_428532_428609),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_33_i2_fu__Z4reluPKxPxj_428532_428724));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(29)) fu__Z4reluPKxPxj_428532_428613 (.out1(out_ui_bit_ior_expr_FU_32_0_32_28_i0_fu__Z4reluPKxPxj_428532_428613),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  max_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(1),
    .BITSIZE_out1(64)) fu__Z4reluPKxPxj_428532_428617 (.out1(out_max_expr_FU_64_0_64_23_i2_fu__Z4reluPKxPxj_428532_428617),
    .in1(out_UIdata_converter_FU_15_i0_fu__Z4reluPKxPxj_428532_428728),
    .in2(out_const_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4reluPKxPxj_428532_428624 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_36_i5_fu__Z4reluPKxPxj_428532_428624),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_33_i2_fu__Z4reluPKxPxj_428532_428724));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428644 (.out1(out_ui_bit_and_expr_FU_1_0_1_26_i0_fu__Z4reluPKxPxj_428532_428644),
    .in1(in_port_loop_count),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428645 (.out1(out_UUdata_converter_FU_20_i0_fu__Z4reluPKxPxj_428532_428645),
    .in1(out_ui_eq_expr_FU_32_0_32_30_i0_fu__Z4reluPKxPxj_428532_428709));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428656 (.out1(out_UUdata_converter_FU_21_i0_fu__Z4reluPKxPxj_428532_428656),
    .in1(out_ui_eq_expr_FU_1_0_1_29_i0_fu__Z4reluPKxPxj_428532_428712));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428660 (.out1(out_UUdata_converter_FU_17_i0_fu__Z4reluPKxPxj_428532_428660),
    .in1(out_ui_eq_expr_FU_32_32_32_32_i0_fu__Z4reluPKxPxj_428532_428733));
  ui_bit_and_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(31),
    .BITSIZE_out1(31)) fu__Z4reluPKxPxj_428532_428665 (.out1(out_ui_bit_and_expr_FU_32_0_32_27_i0_fu__Z4reluPKxPxj_428532_428665),
    .in1(out_ui_rshift_expr_FU_32_0_32_37_i3_fu__Z4reluPKxPxj_428532_428826),
    .in2(out_const_4));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428668 (.out1(out_UUdata_converter_FU_19_i0_fu__Z4reluPKxPxj_428532_428668),
    .in1(out_ui_eq_expr_FU_32_0_32_31_i0_fu__Z4reluPKxPxj_428532_428744));
  ui_lshift_expr_FU #(.BITSIZE_in1(29),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4reluPKxPxj_428532_428689 (.out1(out_ui_lshift_expr_FU_32_0_32_33_i0_fu__Z4reluPKxPxj_428532_428689),
    .in1(out_reg_12_reg_12),
    .in2(out_const_3));
  UIdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4reluPKxPxj_428532_428695 (.out1(out_UIdata_converter_FU_5_i0_fu__Z4reluPKxPxj_428532_428695),
    .in1(out_reg_4_reg_4));
  IUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(63)) fu__Z4reluPKxPxj_428532_428703 (.out1(out_IUdata_converter_FU_6_i0_fu__Z4reluPKxPxj_428532_428703),
    .in1(out_max_expr_FU_64_0_64_23_i0_fu__Z4reluPKxPxj_428532_428562));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428709 (.out1(out_ui_eq_expr_FU_32_0_32_30_i0_fu__Z4reluPKxPxj_428532_428709),
    .in1(in_port_loop_count),
    .in2(out_const_1));
  ui_eq_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428712 (.out1(out_ui_eq_expr_FU_1_0_1_29_i0_fu__Z4reluPKxPxj_428532_428712),
    .in1(out_ui_bit_and_expr_FU_1_0_1_26_i0_fu__Z4reluPKxPxj_428532_428644),
    .in2(out_const_0));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4reluPKxPxj_428532_428715 (.out1(out_ui_lshift_expr_FU_32_0_32_33_i1_fu__Z4reluPKxPxj_428532_428715),
    .in1(out_reg_0_reg_0),
    .in2(out_const_3));
  UIdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4reluPKxPxj_428532_428719 (.out1(out_UIdata_converter_FU_13_i0_fu__Z4reluPKxPxj_428532_428719),
    .in1(out_reg_4_reg_4));
  ui_lshift_expr_FU #(.BITSIZE_in1(29),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4reluPKxPxj_428532_428724 (.out1(out_ui_lshift_expr_FU_32_0_32_33_i2_fu__Z4reluPKxPxj_428532_428724),
    .in1(out_ui_bit_ior_expr_FU_32_0_32_28_i0_fu__Z4reluPKxPxj_428532_428613),
    .in2(out_const_3));
  UIdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4reluPKxPxj_428532_428728 (.out1(out_UIdata_converter_FU_15_i0_fu__Z4reluPKxPxj_428532_428728),
    .in1(out_reg_4_reg_4));
  ui_eq_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(31),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428733 (.out1(out_ui_eq_expr_FU_32_32_32_32_i0_fu__Z4reluPKxPxj_428532_428733),
    .in1(out_ui_rshift_expr_FU_32_0_32_37_i1_fu__Z4reluPKxPxj_428532_428820),
    .in2(out_reg_2_reg_2));
  IUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(63)) fu__Z4reluPKxPxj_428532_428738 (.out1(out_IUdata_converter_FU_14_i0_fu__Z4reluPKxPxj_428532_428738),
    .in1(out_max_expr_FU_64_0_64_23_i1_fu__Z4reluPKxPxj_428532_428593));
  IUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(63)) fu__Z4reluPKxPxj_428532_428742 (.out1(out_IUdata_converter_FU_16_i0_fu__Z4reluPKxPxj_428532_428742),
    .in1(out_max_expr_FU_64_0_64_23_i2_fu__Z4reluPKxPxj_428532_428617));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428744 (.out1(out_ui_eq_expr_FU_32_0_32_31_i0_fu__Z4reluPKxPxj_428532_428744),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4reluPKxPxj_428532_428810 (.out1(out_ui_rshift_expr_FU_32_0_32_37_i0_fu__Z4reluPKxPxj_428532_428810),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31)) fu__Z4reluPKxPxj_428532_428814 (.out1(out_ui_plus_expr_FU_32_0_32_35_i0_fu__Z4reluPKxPxj_428532_428814),
    .in1(out_ui_rshift_expr_FU_32_0_32_37_i0_fu__Z4reluPKxPxj_428532_428810),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4reluPKxPxj_428532_428817 (.out1(out_ui_lshift_expr_FU_32_0_32_34_i0_fu__Z4reluPKxPxj_428532_428817),
    .in1(out_ui_plus_expr_FU_32_0_32_35_i0_fu__Z4reluPKxPxj_428532_428814),
    .in2(out_const_1));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4reluPKxPxj_428532_428820 (.out1(out_ui_rshift_expr_FU_32_0_32_37_i1_fu__Z4reluPKxPxj_428532_428820),
    .in1(out_ui_lshift_expr_FU_32_0_32_34_i0_fu__Z4reluPKxPxj_428532_428817),
    .in2(out_const_1));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4reluPKxPxj_428532_428823 (.out1(out_ui_rshift_expr_FU_32_0_32_37_i2_fu__Z4reluPKxPxj_428532_428823),
    .in1(out_ui_lshift_expr_FU_32_0_32_34_i1_fu__Z4reluPKxPxj_428532_428830),
    .in2(out_const_1));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4reluPKxPxj_428532_428826 (.out1(out_ui_rshift_expr_FU_32_0_32_37_i3_fu__Z4reluPKxPxj_428532_428826),
    .in1(in_port_loop_count),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4reluPKxPxj_428532_428830 (.out1(out_ui_lshift_expr_FU_32_0_32_34_i1_fu__Z4reluPKxPxj_428532_428830),
    .in1(out_ui_bit_and_expr_FU_32_0_32_27_i0_fu__Z4reluPKxPxj_428532_428665),
    .in2(out_const_1));
  multi_read_cond_FU #(.BITSIZE_in1(1),
    .PORTSIZE_in1(2),
    .BITSIZE_out1(2)) fu__Z4reluPKxPxj_428532_428837 (.out1(out_multi_read_cond_FU_22_i0_fu__Z4reluPKxPxj_428532_428837),
    .in1({out_truth_and_expr_FU_1_1_1_24_i0_fu__Z4reluPKxPxj_428532_428843,
      out_UUdata_converter_FU_19_i0_fu__Z4reluPKxPxj_428532_428668}));
  truth_not_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428840 (.out1(out_truth_not_expr_FU_1_1_25_i0_fu__Z4reluPKxPxj_428532_428840),
    .in1(out_UUdata_converter_FU_19_i0_fu__Z4reluPKxPxj_428532_428668));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428843 (.out1(out_truth_and_expr_FU_1_1_1_24_i0_fu__Z4reluPKxPxj_428532_428843),
    .in1(out_UUdata_converter_FU_20_i0_fu__Z4reluPKxPxj_428532_428645),
    .in2(out_truth_not_expr_FU_1_1_25_i0_fu__Z4reluPKxPxj_428532_428840));
  multi_read_cond_FU #(.BITSIZE_in1(1),
    .PORTSIZE_in1(2),
    .BITSIZE_out1(2)) fu__Z4reluPKxPxj_428532_428850 (.out1(out_multi_read_cond_FU_18_i0_fu__Z4reluPKxPxj_428532_428850),
    .in1({out_reg_9_reg_9,
      out_reg_8_reg_8}));
  truth_not_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428853 (.out1(out_truth_not_expr_FU_1_1_25_i1_fu__Z4reluPKxPxj_428532_428853),
    .in1(out_UUdata_converter_FU_17_i0_fu__Z4reluPKxPxj_428532_428660));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4reluPKxPxj_428532_428856 (.out1(out_truth_and_expr_FU_1_1_1_24_i1_fu__Z4reluPKxPxj_428532_428856),
    .in1(out_UUdata_converter_FU_17_i0_fu__Z4reluPKxPxj_428532_428660),
    .in2(out_reg_1_reg_1));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_7 (.sop(OUT_mu_S_7_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_7),
    .ops({s_done_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_P0,
      s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_P0}));
  or or_or_start_port0( s_start_port0, selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561, selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600, selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621);
  or or_or_start_port1( s_start_port1, selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796, selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801, selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806);
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_26_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_21_i0_fu__Z4reluPKxPxj_428532_428656),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(63),
    .BITSIZE_out1(63)) reg_10 (.out1(out_reg_10_reg_10),
    .clock(clock),
    .reset(reset),
    .in1(out_IUdata_converter_FU_14_i0_fu__Z4reluPKxPxj_428532_428738),
    .wenable(wrenable_reg_10));
  register_SE #(.BITSIZE_in1(63),
    .BITSIZE_out1(63)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_IUdata_converter_FU_16_i0_fu__Z4reluPKxPxj_428532_428742),
    .wenable(wrenable_reg_11));
  register_SE #(.BITSIZE_in1(29),
    .BITSIZE_out1(29)) reg_12 (.out1(out_reg_12_reg_12),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_30_reg_12_0_0_0),
    .wenable(wrenable_reg_12));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_13 (.out1(out_reg_13_reg_13),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_36_i0_fu__Z4reluPKxPxj_428532_428560),
    .wenable(wrenable_reg_13));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_14 (.out1(out_reg_14_reg_14),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_36_i1_fu__Z4reluPKxPxj_428532_428563),
    .wenable(wrenable_reg_14));
  register_SE #(.BITSIZE_in1(63),
    .BITSIZE_out1(63)) reg_15 (.out1(out_reg_15_reg_15),
    .clock(clock),
    .reset(reset),
    .in1(out_IUdata_converter_FU_6_i0_fu__Z4reluPKxPxj_428532_428703),
    .wenable(wrenable_reg_15));
  register_SE #(.BITSIZE_in1(31),
    .BITSIZE_out1(31)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_rshift_expr_FU_32_0_32_37_i2_fu__Z4reluPKxPxj_428532_428823),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_36_i2_fu__Z4reluPKxPxj_428532_428579),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_36_i3_fu__Z4reluPKxPxj_428532_428603),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_36_i4_fu__Z4reluPKxPxj_428532_428609),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_36_i5_fu__Z4reluPKxPxj_428532_428624),
    .wenable(wrenable_reg_7));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_truth_not_expr_FU_1_1_25_i1_fu__Z4reluPKxPxj_428532_428853),
    .wenable(wrenable_reg_8));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_truth_and_expr_FU_1_1_1_24_i1_fu__Z4reluPKxPxj_428532_428856),
    .wenable(wrenable_reg_9));
  // io-signal post fix
  assign OUT_MULTIIF__Z4reluPKxPxj_428532_428837 = out_multi_read_cond_FU_22_i0_fu__Z4reluPKxPxj_428532_428837;
  assign OUT_MULTIIF__Z4reluPKxPxj_428532_428850 = out_multi_read_cond_FU_18_i0_fu__Z4reluPKxPxj_428532_428850;
  assign OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561 = s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_P0;
  assign OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600 = s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_P0;
  assign OUT_UNBOUNDED__Z4reluPKxPxj_428532_428621 = s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_P0;
  assign OUT_UNBOUNDED__Z4reluPKxPxj_428532_428796 = s_done_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_P0;
  assign OUT_UNBOUNDED__Z4reluPKxPxj_428532_428801 = s_done_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_P0;
  assign OUT_UNBOUNDED__Z4reluPKxPxj_428532_428806 = s_done_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_P0;

endmodule

// FSM based controller description for _Z4reluPKxPxj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z4reluPKxPxj(done_port,
  selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561,
  selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600,
  selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621,
  selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796,
  selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801,
  selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0,
  selector_MUX_26_reg_0_0_0_0,
  selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0,
  selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1,
  selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2,
  selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0,
  selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1,
  selector_MUX_30_reg_12_0_0_0,
  selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0,
  selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1,
  muenable_mu_S_7,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_10,
  wrenable_reg_11,
  wrenable_reg_12,
  wrenable_reg_13,
  wrenable_reg_14,
  wrenable_reg_15,
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_MULTIIF__Z4reluPKxPxj_428532_428837,
  OUT_MULTIIF__Z4reluPKxPxj_428532_428850,
  OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561,
  OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600,
  OUT_UNBOUNDED__Z4reluPKxPxj_428532_428621,
  OUT_UNBOUNDED__Z4reluPKxPxj_428532_428796,
  OUT_UNBOUNDED__Z4reluPKxPxj_428532_428801,
  OUT_UNBOUNDED__Z4reluPKxPxj_428532_428806,
  OUT_mu_S_7_MULTI_UNBOUNDED_0,
  clock,
  reset,
  start_port);
  // IN
  input [1:0] OUT_MULTIIF__Z4reluPKxPxj_428532_428837;
  input [1:0] OUT_MULTIIF__Z4reluPKxPxj_428532_428850;
  input OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561;
  input OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600;
  input OUT_UNBOUNDED__Z4reluPKxPxj_428532_428621;
  input OUT_UNBOUNDED__Z4reluPKxPxj_428532_428796;
  input OUT_UNBOUNDED__Z4reluPKxPxj_428532_428801;
  input OUT_UNBOUNDED__Z4reluPKxPxj_428532_428806;
  input OUT_mu_S_7_MULTI_UNBOUNDED_0;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561;
  output selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600;
  output selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621;
  output selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796;
  output selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801;
  output selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0;
  output selector_MUX_26_reg_0_0_0_0;
  output selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0;
  output selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1;
  output selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2;
  output selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0;
  output selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1;
  output selector_MUX_30_reg_12_0_0_0;
  output selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0;
  output selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1;
  output muenable_mu_S_7;
  output wrenable_reg_0;
  output wrenable_reg_1;
  output wrenable_reg_10;
  output wrenable_reg_11;
  output wrenable_reg_12;
  output wrenable_reg_13;
  output wrenable_reg_14;
  output wrenable_reg_15;
  output wrenable_reg_2;
  output wrenable_reg_3;
  output wrenable_reg_4;
  output wrenable_reg_5;
  output wrenable_reg_6;
  output wrenable_reg_7;
  output wrenable_reg_8;
  output wrenable_reg_9;
  parameter [3:0] S_12 = 4'd12,
    S_13 = 4'd13,
    S_5 = 4'd5,
    S_6 = 4'd6,
    S_7 = 4'd7,
    S_8 = 4'd8,
    S_9 = 4'd9,
    S_10 = 4'd10,
    S_11 = 4'd11,
    S_14 = 4'd14,
    S_0 = 4'd0,
    S_1 = 4'd1,
    S_2 = 4'd2,
    S_3 = 4'd3,
    S_4 = 4'd4;
  reg [3:0] _present_state=S_12, _next_state;
  reg done_port;
  reg selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561;
  reg selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600;
  reg selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621;
  reg selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796;
  reg selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801;
  reg selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0;
  reg selector_MUX_26_reg_0_0_0_0;
  reg selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0;
  reg selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1;
  reg selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2;
  reg selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0;
  reg selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1;
  reg selector_MUX_30_reg_12_0_0_0;
  reg selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0;
  reg selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1;
  reg muenable_mu_S_7;
  reg wrenable_reg_0;
  reg wrenable_reg_1;
  reg wrenable_reg_10;
  reg wrenable_reg_11;
  reg wrenable_reg_12;
  reg wrenable_reg_13;
  reg wrenable_reg_14;
  reg wrenable_reg_15;
  reg wrenable_reg_2;
  reg wrenable_reg_3;
  reg wrenable_reg_4;
  reg wrenable_reg_5;
  reg wrenable_reg_6;
  reg wrenable_reg_7;
  reg wrenable_reg_8;
  reg wrenable_reg_9;
  
  always @(posedge clock)
    if (reset == 1'b0) _present_state <= S_12;
    else _present_state <= _next_state;
  
  always @(*)
  begin
    done_port = 1'b0;
    selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561 = 1'b0;
    selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600 = 1'b0;
    selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621 = 1'b0;
    selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796 = 1'b0;
    selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801 = 1'b0;
    selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0 = 1'b0;
    selector_MUX_26_reg_0_0_0_0 = 1'b0;
    selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0 = 1'b0;
    selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1 = 1'b0;
    selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2 = 1'b0;
    selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0 = 1'b0;
    selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1 = 1'b0;
    selector_MUX_30_reg_12_0_0_0 = 1'b0;
    selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0 = 1'b0;
    selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1 = 1'b0;
    muenable_mu_S_7 = 1'b0;
    wrenable_reg_0 = 1'b0;
    wrenable_reg_1 = 1'b0;
    wrenable_reg_10 = 1'b0;
    wrenable_reg_11 = 1'b0;
    wrenable_reg_12 = 1'b0;
    wrenable_reg_13 = 1'b0;
    wrenable_reg_14 = 1'b0;
    wrenable_reg_15 = 1'b0;
    wrenable_reg_2 = 1'b0;
    wrenable_reg_3 = 1'b0;
    wrenable_reg_4 = 1'b0;
    wrenable_reg_5 = 1'b0;
    wrenable_reg_6 = 1'b0;
    wrenable_reg_7 = 1'b0;
    wrenable_reg_8 = 1'b0;
    wrenable_reg_9 = 1'b0;
    case (_present_state)
      S_12 :
        if(start_port == 1'b1)
        begin
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_2 = 1'b1;
          casez (OUT_MULTIIF__Z4reluPKxPxj_428532_428837)
            2'b10 :
              begin
                _next_state = S_0;
                wrenable_reg_0 = 1'b0;
                wrenable_reg_1 = 1'b0;
                wrenable_reg_2 = 1'b0;
              end
            2'b01 :
              begin
                _next_state = S_13;
                done_port = 1'b1;
                wrenable_reg_0 = 1'b0;
                wrenable_reg_1 = 1'b0;
                wrenable_reg_12 = 1'b0;
                wrenable_reg_2 = 1'b0;
              end
            default:
              begin
                _next_state = S_5;
                wrenable_reg_12 = 1'b0;
              end
          endcase
        end
        else
        begin
          _next_state = S_12;
        end
      S_13 :
        begin
          _next_state = S_12;
        end
      S_5 :
        begin
          selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2 = 1'b1;
          selector_MUX_26_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_3 = 1'b1;
          wrenable_reg_4 = OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600;
          wrenable_reg_5 = 1'b1;
          wrenable_reg_6 = 1'b1;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = 1'b1;
          wrenable_reg_9 = 1'b1;
          if (OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600 == 1'b0)
            begin
              _next_state = S_6;
            end
          else
            begin
              _next_state = S_7;
            end
        end
      S_6 :
        begin
          wrenable_reg_4 = OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600;
          if (OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600 == 1'b0)
            begin
              _next_state = S_6;
            end
          else
            begin
              _next_state = S_7;
            end
        end
      S_7 :
        begin
          selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621 = 1'b1;
          selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_4 = OUT_UNBOUNDED__Z4reluPKxPxj_428532_428621;
          if (OUT_mu_S_7_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_8;
              muenable_mu_S_7 = 1'b1;
            end
          else
            begin
              _next_state = S_9;
              muenable_mu_S_7 = 1'b1;
            end
        end
      S_8 :
        begin
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0 = 1'b1;
          selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1 = 1'b1;
          wrenable_reg_4 = OUT_UNBOUNDED__Z4reluPKxPxj_428532_428621;
          if (OUT_mu_S_7_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_8;
            end
          else
            begin
              _next_state = S_9;
            end
        end
      S_9 :
        begin
          selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806 = 1'b1;
          selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2 = 1'b1;
          selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1 = 1'b1;
          selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0 = 1'b1;
          wrenable_reg_11 = 1'b1;
          if (OUT_UNBOUNDED__Z4reluPKxPxj_428532_428806 == 1'b0)
            begin
              _next_state = S_10;
            end
          else
            begin
              _next_state = S_11;
            end
        end
      S_10 :
        begin
          selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0 = 1'b1;
          selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0 = 1'b1;
          if (OUT_UNBOUNDED__Z4reluPKxPxj_428532_428806 == 1'b0)
            begin
              _next_state = S_10;
            end
          else
            begin
              _next_state = S_11;
            end
        end
      S_11 :
        begin
          selector_MUX_30_reg_12_0_0_0 = 1'b1;
          wrenable_reg_12 = 1'b1;
          casez (OUT_MULTIIF__Z4reluPKxPxj_428532_428850)
            2'b01 :
              begin
                _next_state = S_5;
                selector_MUX_30_reg_12_0_0_0 = 1'b0;
                wrenable_reg_12 = 1'b0;
              end
            2'b10 :
              begin
                _next_state = S_14;
                done_port = 1'b1;
                selector_MUX_30_reg_12_0_0_0 = 1'b0;
                wrenable_reg_12 = 1'b0;
              end
            default:
              begin
                _next_state = S_0;
              end
          endcase
        end
      S_14 :
        begin
          _next_state = S_12;
        end
      S_0 :
        begin
          selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0 = 1'b1;
          wrenable_reg_13 = 1'b1;
          wrenable_reg_14 = 1'b1;
          wrenable_reg_4 = OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561;
          if (OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561 == 1'b0)
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0 = 1'b1;
          wrenable_reg_4 = OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561;
          if (OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561 == 1'b0)
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
          selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796 = 1'b1;
          selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1 = 1'b1;
          selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1 = 1'b1;
          wrenable_reg_15 = 1'b1;
          if (OUT_UNBOUNDED__Z4reluPKxPxj_428532_428796 == 1'b0)
            begin
              _next_state = S_3;
            end
          else
            begin
              _next_state = S_4;
              done_port = 1'b1;
            end
        end
      S_3 :
        begin
          selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0 = 1'b1;
          selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0 = 1'b1;
          selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1 = 1'b1;
          if (OUT_UNBOUNDED__Z4reluPKxPxj_428532_428796 == 1'b0)
            begin
              _next_state = S_3;
            end
          else
            begin
              _next_state = S_4;
              done_port = 1'b1;
            end
        end
      S_4 :
        begin
          _next_state = S_12;
        end
      default :
        begin
          _next_state = S_12;
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

// Top component for _Z4reluPKxPxj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z4reluPKxPxj(clock,
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
  input [63:0] _A_TDATA;
  input _A_TVALID;
  input _B_TREADY;
  // OUT
  output done_port;
  output _A_TREADY;
  output [63:0] _B_TDATA;
  output _B_TVALID;
  // Component and signal declarations
  wire [1:0] OUT_MULTIIF__Z4reluPKxPxj_428532_428837;
  wire [1:0] OUT_MULTIIF__Z4reluPKxPxj_428532_428850;
  wire OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561;
  wire OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600;
  wire OUT_UNBOUNDED__Z4reluPKxPxj_428532_428621;
  wire OUT_UNBOUNDED__Z4reluPKxPxj_428532_428796;
  wire OUT_UNBOUNDED__Z4reluPKxPxj_428532_428801;
  wire OUT_UNBOUNDED__Z4reluPKxPxj_428532_428806;
  wire OUT_mu_S_7_MULTI_UNBOUNDED_0;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire muenable_mu_S_7;
  wire selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561;
  wire selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600;
  wire selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621;
  wire selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796;
  wire selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801;
  wire selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0;
  wire selector_MUX_26_reg_0_0_0_0;
  wire selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0;
  wire selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1;
  wire selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2;
  wire selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0;
  wire selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1;
  wire selector_MUX_30_reg_12_0_0_0;
  wire selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0;
  wire selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1;
  wire wrenable_reg_0;
  wire wrenable_reg_1;
  wire wrenable_reg_10;
  wire wrenable_reg_11;
  wire wrenable_reg_12;
  wire wrenable_reg_13;
  wire wrenable_reg_14;
  wire wrenable_reg_15;
  wire wrenable_reg_2;
  wire wrenable_reg_3;
  wire wrenable_reg_4;
  wire wrenable_reg_5;
  wire wrenable_reg_6;
  wire wrenable_reg_7;
  wire wrenable_reg_8;
  wire wrenable_reg_9;
  
  controller__Z4reluPKxPxj Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561(selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561),
    .selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600(selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600),
    .selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621(selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621),
    .selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796(selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796),
    .selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801(selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801),
    .selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806(selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0),
    .selector_MUX_26_reg_0_0_0_0(selector_MUX_26_reg_0_0_0_0),
    .selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0),
    .selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1),
    .selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2),
    .selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0),
    .selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1),
    .selector_MUX_30_reg_12_0_0_0(selector_MUX_30_reg_12_0_0_0),
    .selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0(selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0),
    .selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1(selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1),
    .muenable_mu_S_7(muenable_mu_S_7),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_10(wrenable_reg_10),
    .wrenable_reg_11(wrenable_reg_11),
    .wrenable_reg_12(wrenable_reg_12),
    .wrenable_reg_13(wrenable_reg_13),
    .wrenable_reg_14(wrenable_reg_14),
    .wrenable_reg_15(wrenable_reg_15),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9),
    .OUT_MULTIIF__Z4reluPKxPxj_428532_428837(OUT_MULTIIF__Z4reluPKxPxj_428532_428837),
    .OUT_MULTIIF__Z4reluPKxPxj_428532_428850(OUT_MULTIIF__Z4reluPKxPxj_428532_428850),
    .OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561(OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561),
    .OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600(OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600),
    .OUT_UNBOUNDED__Z4reluPKxPxj_428532_428621(OUT_UNBOUNDED__Z4reluPKxPxj_428532_428621),
    .OUT_UNBOUNDED__Z4reluPKxPxj_428532_428796(OUT_UNBOUNDED__Z4reluPKxPxj_428532_428796),
    .OUT_UNBOUNDED__Z4reluPKxPxj_428532_428801(OUT_UNBOUNDED__Z4reluPKxPxj_428532_428801),
    .OUT_UNBOUNDED__Z4reluPKxPxj_428532_428806(OUT_UNBOUNDED__Z4reluPKxPxj_428532_428806),
    .OUT_mu_S_7_MULTI_UNBOUNDED_0(OUT_mu_S_7_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z4reluPKxPxj Datapath_i (._A_TREADY(_A_TREADY),
    ._B_TDATA(_B_TDATA),
    ._B_TVALID(_B_TVALID),
    .OUT_MULTIIF__Z4reluPKxPxj_428532_428837(OUT_MULTIIF__Z4reluPKxPxj_428532_428837),
    .OUT_MULTIIF__Z4reluPKxPxj_428532_428850(OUT_MULTIIF__Z4reluPKxPxj_428532_428850),
    .OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561(OUT_UNBOUNDED__Z4reluPKxPxj_428532_428561),
    .OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600(OUT_UNBOUNDED__Z4reluPKxPxj_428532_428600),
    .OUT_UNBOUNDED__Z4reluPKxPxj_428532_428621(OUT_UNBOUNDED__Z4reluPKxPxj_428532_428621),
    .OUT_UNBOUNDED__Z4reluPKxPxj_428532_428796(OUT_UNBOUNDED__Z4reluPKxPxj_428532_428796),
    .OUT_UNBOUNDED__Z4reluPKxPxj_428532_428801(OUT_UNBOUNDED__Z4reluPKxPxj_428532_428801),
    .OUT_UNBOUNDED__Z4reluPKxPxj_428532_428806(OUT_UNBOUNDED__Z4reluPKxPxj_428532_428806),
    .OUT_mu_S_7_MULTI_UNBOUNDED_0(OUT_mu_S_7_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .in_port_A(A),
    .in_port_B(B),
    .in_port_loop_count(loop_count),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID),
    ._B_TREADY(_B_TREADY),
    .selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561(selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428561),
    .selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600(selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428600),
    .selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621(selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428621),
    .selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796(selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428796),
    .selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801(selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428801),
    .selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806(selector_IN_UNBOUNDED__Z4reluPKxPxj_428532_428806),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_1),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_2),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_1_0),
    .selector_MUX_26_reg_0_0_0_0(selector_MUX_26_reg_0_0_0_0),
    .selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_0),
    .selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_1),
    .selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_0_2),
    .selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_0),
    .selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1(selector_MUX_2_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_1_1_1),
    .selector_MUX_30_reg_12_0_0_0(selector_MUX_30_reg_12_0_0_0),
    .selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0(selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_0),
    .selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1(selector_MUX_3_B_bambu_artificial_ParmMgr_Write_axis_modgen_39_i0_2_0_1),
    .muenable_mu_S_7(muenable_mu_S_7),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_10(wrenable_reg_10),
    .wrenable_reg_11(wrenable_reg_11),
    .wrenable_reg_12(wrenable_reg_12),
    .wrenable_reg_13(wrenable_reg_13),
    .wrenable_reg_14(wrenable_reg_14),
    .wrenable_reg_15(wrenable_reg_15),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_3(wrenable_reg_3),
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

// Minimal interface for function: _Z4reluPKxPxj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z4reluPKxPxj(clock,
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
  input [63:0] A_TDATA;
  input [31:0] loop_count;
  input A_TVALID;
  input B_TREADY;
  // OUT
  output done_port;
  output A_TREADY;
  output [63:0] B_TDATA;
  output B_TVALID;
  // Component and signal declarations
  
  __Z4reluPKxPxj __Z4reluPKxPxj_i0 (.done_port(done_port),
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


