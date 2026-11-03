// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-03T13:32:07
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=vsum --top-rtldesign-name=vsum --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER --simulate --simulator=VERILATOR --generate-tb=/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/src/tb_vsum.cpp --tb-extra-gcc-options=-DDUT=vsum -DCFG_LOOP_COUNT=64 -DCFG_LEN=64 --tb-param-size=A:512,out:8 -DDATA_T=int64_t -DSIZE_N=64 -DBAMBU_LANES=1 --std=c++14 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include/bambu -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/vectors/n64 /users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/bambu_opt_n64_w1_proj/vsum.cpp 
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
// Copyright (C) 2016-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_bit_ior_concat_expr_FU(in1,
  in2,
  in3,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_in3=1,
    BITSIZE_out1=1,
    OFFSET_PARAMETER=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  input [BITSIZE_in3-1:0] in3;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  localparam nbit_out = BITSIZE_out1 > OFFSET_PARAMETER ? BITSIZE_out1 : 1+OFFSET_PARAMETER;
  wire [nbit_out-1:0] tmp_in1;
  wire [OFFSET_PARAMETER-1:0] tmp_in2;
  generate
    if(BITSIZE_in1 >= nbit_out)
      assign tmp_in1=in1[nbit_out-1:0];
    else
      assign tmp_in1={{(nbit_out-BITSIZE_in1){1'b0}},in1};
  endgenerate
  generate
    if(BITSIZE_in2 >= OFFSET_PARAMETER)
      assign tmp_in2=in2[OFFSET_PARAMETER-1:0];
    else
      assign tmp_in2={{(OFFSET_PARAMETER-BITSIZE_in2){1'b0}},in2};
  endgenerate
  assign out1 = {tmp_in1[nbit_out-1:OFFSET_PARAMETER] , tmp_in2};
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
module ui_cond_expr_FU(in1,
  in2,
  in3,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_in3=1,
    BITSIZE_out1=1;
  // IN
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  input [BITSIZE_in3-1:0] in3;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  assign out1 = in1 != 0 ? in2 : in3;
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

// Interface module for function: out_bambu_artificial_ParmMgr_Write_axis
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module out_bambu_artificial_ParmMgr_Write_axis_modgen(clock,
  reset,
  start_port,
  in1,
  in2,
  in3,
  _out_TREADY,
  done_port,
  out1,
  _out_TDATA,
  _out_TVALID);
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
  input _out_TREADY;
  // OUT
  output [0:0] done_port;
  output out1;
  output [63:0] _out_TDATA;
  output _out_TVALID;
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
    started_0 = (started | start_port) & ~_out_TREADY;
  end
  
  assign done_port = (started | start_port) & _out_TREADY;
  assign _out_TVALID = started | start_port;
  assign out1 = _out_TREADY;
  assign _out_TDATA = in2;

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

// Datapath RTL description for _Z4vsumPKxPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z4vsumPKxPxjj(clock,
  reset,
  in_port_A,
  in_port_out,
  in_port_loop_count,
  in_port_len,
  _A_TDATA,
  _A_TVALID,
  _A_TREADY,
  _out_TREADY,
  _out_TDATA,
  _out_TVALID,
  selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609,
  selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631,
  selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745,
  selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893,
  selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898,
  selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0,
  selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0,
  selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1,
  selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0,
  selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0,
  selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1,
  selector_MUX_23_reg_0_0_0_0,
  selector_MUX_23_reg_0_0_0_1,
  selector_MUX_24_reg_1_0_0_0,
  selector_MUX_25_reg_10_0_0_0,
  selector_MUX_30_reg_15_0_0_0,
  selector_MUX_35_reg_2_0_0_0,
  selector_MUX_40_reg_24_0_0_0,
  selector_MUX_41_reg_25_0_0_0,
  selector_MUX_42_reg_26_0_0_0,
  selector_MUX_43_reg_27_0_0_0,
  selector_MUX_46_reg_3_0_0_0,
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
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z4vsumPKxPxjj_428532_428570,
  OUT_CONDITION__Z4vsumPKxPxjj_428532_428706,
  OUT_CONDITION__Z4vsumPKxPxjj_428532_428716,
  OUT_MULTIIF__Z4vsumPKxPxjj_428532_428964,
  OUT_MULTIIF__Z4vsumPKxPxjj_428532_428977,
  OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609,
  OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631,
  OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745,
  OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428893,
  OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428898,
  OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428903);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_A;
  input [31:0] in_port_out;
  input [31:0] in_port_loop_count;
  input [31:0] in_port_len;
  input [63:0] _A_TDATA;
  input _A_TVALID;
  input _out_TREADY;
  input selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609;
  input selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631;
  input selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745;
  input selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893;
  input selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898;
  input selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0;
  input selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0;
  input selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1;
  input selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0;
  input selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0;
  input selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1;
  input selector_MUX_23_reg_0_0_0_0;
  input selector_MUX_23_reg_0_0_0_1;
  input selector_MUX_24_reg_1_0_0_0;
  input selector_MUX_25_reg_10_0_0_0;
  input selector_MUX_30_reg_15_0_0_0;
  input selector_MUX_35_reg_2_0_0_0;
  input selector_MUX_40_reg_24_0_0_0;
  input selector_MUX_41_reg_25_0_0_0;
  input selector_MUX_42_reg_26_0_0_0;
  input selector_MUX_43_reg_27_0_0_0;
  input selector_MUX_46_reg_3_0_0_0;
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
  input wrenable_reg_4;
  input wrenable_reg_5;
  input wrenable_reg_6;
  input wrenable_reg_7;
  input wrenable_reg_8;
  input wrenable_reg_9;
  // OUT
  output _A_TREADY;
  output [63:0] _out_TDATA;
  output _out_TVALID;
  output OUT_CONDITION__Z4vsumPKxPxjj_428532_428570;
  output OUT_CONDITION__Z4vsumPKxPxjj_428532_428706;
  output OUT_CONDITION__Z4vsumPKxPxjj_428532_428716;
  output [1:0] OUT_MULTIIF__Z4vsumPKxPxjj_428532_428964;
  output [1:0] OUT_MULTIIF__Z4vsumPKxPxjj_428532_428977;
  output OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609;
  output OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631;
  output OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745;
  output OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428893;
  output OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428898;
  output OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428903;
  // Component and signal declarations
  wire [63:0] out_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0;
  wire [63:0] out_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0;
  wire [63:0] out_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1;
  wire [63:0] out_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0;
  wire [31:0] out_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0;
  wire [31:0] out_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1;
  wire [31:0] out_MUX_23_reg_0_0_0_0;
  wire [31:0] out_MUX_23_reg_0_0_0_1;
  wire [63:0] out_MUX_24_reg_1_0_0_0;
  wire [31:0] out_MUX_25_reg_10_0_0_0;
  wire [63:0] out_MUX_30_reg_15_0_0_0;
  wire [31:0] out_MUX_35_reg_2_0_0_0;
  wire [31:0] out_MUX_40_reg_24_0_0_0;
  wire [28:0] out_MUX_41_reg_25_0_0_0;
  wire [31:0] out_MUX_42_reg_26_0_0_0;
  wire [63:0] out_MUX_43_reg_27_0_0_0;
  wire [31:0] out_MUX_46_reg_3_0_0_0;
  wire out_UUdata_converter_FU_25_i0_fu__Z4vsumPKxPxjj_428532_428704;
  wire out_UUdata_converter_FU_26_i0_fu__Z4vsumPKxPxjj_428532_428695;
  wire out_UUdata_converter_FU_36_i0_fu__Z4vsumPKxPxjj_428532_428714;
  wire out_UUdata_converter_FU_38_i0_fu__Z4vsumPKxPxjj_428532_428727;
  wire out_UUdata_converter_FU_39_i0_fu__Z4vsumPKxPxjj_428532_428689;
  wire out_UUdata_converter_FU_40_i0_fu__Z4vsumPKxPxjj_428532_428723;
  wire out_UUdata_converter_FU_8_i0_fu__Z4vsumPKxPxjj_428532_428568;
  wire out_const_0;
  wire out_const_1;
  wire [6:0] out_const_2;
  wire [1:0] out_const_3;
  wire [30:0] out_const_4;
  wire [28:0] out_conv_out_const_0_1_29;
  wire [31:0] out_conv_out_const_0_1_32;
  wire [63:0] out_conv_out_const_0_1_64;
  wire [28:0] out_conv_out_reg_0_reg_0_32_29;
  wire [1:0] out_multi_read_cond_FU_17_i0_fu__Z4vsumPKxPxjj_428532_428977;
  wire [1:0] out_multi_read_cond_FU_41_i0_fu__Z4vsumPKxPxjj_428532_428964;
  wire out_read_cond_FU_27_i0_fu__Z4vsumPKxPxjj_428532_428706;
  wire out_read_cond_FU_37_i0_fu__Z4vsumPKxPxjj_428532_428716;
  wire out_read_cond_FU_9_i0_fu__Z4vsumPKxPxjj_428532_428570;
  wire [31:0] out_reg_0_reg_0;
  wire [31:0] out_reg_10_reg_10;
  wire out_reg_11_reg_11;
  wire [31:0] out_reg_12_reg_12;
  wire [30:0] out_reg_13_reg_13;
  wire [63:0] out_reg_14_reg_14;
  wire [63:0] out_reg_15_reg_15;
  wire [31:0] out_reg_16_reg_16;
  wire [31:0] out_reg_17_reg_17;
  wire [31:0] out_reg_18_reg_18;
  wire [31:0] out_reg_19_reg_19;
  wire [63:0] out_reg_1_reg_1;
  wire out_reg_20_reg_20;
  wire out_reg_21_reg_21;
  wire out_reg_22_reg_22;
  wire [63:0] out_reg_23_reg_23;
  wire [31:0] out_reg_24_reg_24;
  wire [28:0] out_reg_25_reg_25;
  wire [31:0] out_reg_26_reg_26;
  wire [63:0] out_reg_27_reg_27;
  wire [31:0] out_reg_28_reg_28;
  wire [31:0] out_reg_29_reg_29;
  wire [31:0] out_reg_2_reg_2;
  wire [63:0] out_reg_30_reg_30;
  wire [31:0] out_reg_3_reg_3;
  wire out_reg_4_reg_4;
  wire [30:0] out_reg_5_reg_5;
  wire [31:0] out_reg_6_reg_6;
  wire [31:0] out_reg_7_reg_7;
  wire [63:0] out_reg_8_reg_8;
  wire [31:0] out_reg_9_reg_9;
  wire out_truth_and_expr_FU_1_0_1_42_i0_fu__Z4vsumPKxPxjj_428532_428778;
  wire out_truth_and_expr_FU_1_0_1_42_i1_fu__Z4vsumPKxPxjj_428532_428798;
  wire out_truth_and_expr_FU_1_0_1_42_i2_fu__Z4vsumPKxPxjj_428532_428812;
  wire out_truth_and_expr_FU_1_0_1_42_i3_fu__Z4vsumPKxPxjj_428532_428924;
  wire out_truth_and_expr_FU_1_0_1_42_i4_fu__Z4vsumPKxPxjj_428532_428942;
  wire out_truth_and_expr_FU_1_0_1_42_i5_fu__Z4vsumPKxPxjj_428532_428946;
  wire out_truth_and_expr_FU_1_1_1_43_i0_fu__Z4vsumPKxPxjj_428532_428970;
  wire out_truth_and_expr_FU_1_1_1_43_i1_fu__Z4vsumPKxPxjj_428532_428983;
  wire out_truth_not_expr_FU_1_1_44_i0_fu__Z4vsumPKxPxjj_428532_428967;
  wire out_truth_not_expr_FU_1_1_44_i1_fu__Z4vsumPKxPxjj_428532_428980;
  wire [0:0] out_ui_bit_and_expr_FU_1_0_1_45_i0_fu__Z4vsumPKxPxjj_428532_428688;
  wire [30:0] out_ui_bit_and_expr_FU_32_0_32_46_i0_fu__Z4vsumPKxPxjj_428532_428700;
  wire [31:0] out_ui_bit_ior_concat_expr_FU_47_i0_fu__Z4vsumPKxPxjj_428532_428567;
  wire [31:0] out_ui_bit_ior_expr_FU_32_0_32_48_i0_fu__Z4vsumPKxPxjj_428532_428638;
  wire [0:0] out_ui_cond_expr_FU_1_1_1_1_49_i0_fu__Z4vsumPKxPxjj_428532_428569;
  wire [0:0] out_ui_cond_expr_FU_1_1_1_1_49_i1_fu__Z4vsumPKxPxjj_428532_428705;
  wire [0:0] out_ui_cond_expr_FU_1_1_1_1_49_i2_fu__Z4vsumPKxPxjj_428532_428715;
  wire out_ui_eq_expr_FU_1_0_1_50_i0_fu__Z4vsumPKxPxjj_428532_428823;
  wire out_ui_eq_expr_FU_32_0_32_51_i0_fu__Z4vsumPKxPxjj_428532_428780;
  wire out_ui_eq_expr_FU_32_0_32_52_i0_fu__Z4vsumPKxPxjj_428532_428826;
  wire out_ui_eq_expr_FU_32_32_32_53_i0_fu__Z4vsumPKxPxjj_428532_428769;
  wire out_ui_eq_expr_FU_32_32_32_53_i1_fu__Z4vsumPKxPxjj_428532_428772;
  wire out_ui_eq_expr_FU_32_32_32_53_i2_fu__Z4vsumPKxPxjj_428532_428783;
  wire out_ui_eq_expr_FU_32_32_32_53_i3_fu__Z4vsumPKxPxjj_428532_428791;
  wire out_ui_eq_expr_FU_32_32_32_53_i4_fu__Z4vsumPKxPxjj_428532_428794;
  wire out_ui_eq_expr_FU_32_32_32_53_i5_fu__Z4vsumPKxPxjj_428532_428805;
  wire out_ui_eq_expr_FU_32_32_32_53_i6_fu__Z4vsumPKxPxjj_428532_428808;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_54_i0_fu__Z4vsumPKxPxjj_428532_428786;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_54_i1_fu__Z4vsumPKxPxjj_428532_428802;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_54_i2_fu__Z4vsumPKxPxjj_428532_428815;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_54_i3_fu__Z4vsumPKxPxjj_428532_428819;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_54_i4_fu__Z4vsumPKxPxjj_428532_428829;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_54_i5_fu__Z4vsumPKxPxjj_428532_428832;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_55_i0_fu__Z4vsumPKxPxjj_428532_428914;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_55_i1_fu__Z4vsumPKxPxjj_428532_428939;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_55_i2_fu__Z4vsumPKxPxjj_428532_428954;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_56_i0_fu__Z4vsumPKxPxjj_428532_428565;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_56_i1_fu__Z4vsumPKxPxjj_428532_428598;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_56_i2_fu__Z4vsumPKxPxjj_428532_428603;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_56_i3_fu__Z4vsumPKxPxjj_428532_428653;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_56_i4_fu__Z4vsumPKxPxjj_428532_428658;
  wire [30:0] out_ui_plus_expr_FU_32_0_32_57_i0_fu__Z4vsumPKxPxjj_428532_428936;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_58_i0_fu__Z4vsumPKxPxjj_428532_428605;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_58_i1_fu__Z4vsumPKxPxjj_428532_428627;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_58_i2_fu__Z4vsumPKxPxjj_428532_428742;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_59_i0_fu__Z4vsumPKxPxjj_428532_428586;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_59_i1_fu__Z4vsumPKxPxjj_428532_428612;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_59_i2_fu__Z4vsumPKxPxjj_428532_428634;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_59_i3_fu__Z4vsumPKxPxjj_428532_428644;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_59_i4_fu__Z4vsumPKxPxjj_428532_428739;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_59_i5_fu__Z4vsumPKxPxjj_428532_428748;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_60_i0_fu__Z4vsumPKxPxjj_428532_428907;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_60_i1_fu__Z4vsumPKxPxjj_428532_428928;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_60_i2_fu__Z4vsumPKxPxjj_428532_428931;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_60_i3_fu__Z4vsumPKxPxjj_428532_428934;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_60_i4_fu__Z4vsumPKxPxjj_428532_428950;
  wire [31:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire [28:0] out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1;
  wire [28:0] out_uu_conv_conn_obj_2_UUdata_converter_FU_uu_conv_2;
  wire [63:0] out_uu_conv_conn_obj_3_UUdata_converter_FU_uu_conv_3;
  wire s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_P0;
  wire s_done_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_P0;
  wire s_start_port0;
  wire s_start_port1;
  
  A_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(64)) A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0 (.done_port({s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_P0}),
    .out1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0),
    ._A_TREADY(_A_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port0}),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0),
    .in1(out_reg_9_reg_9),
    .in2(out_reg_29_reg_29));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1),
    .in1(out_reg_17_reg_17),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_59_i1_fu__Z4vsumPKxPxjj_428532_428612));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_59_i2_fu__Z4vsumPKxPxjj_428532_428634),
    .in2(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1),
    .in2(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0 (.out1(out_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0),
    .sel(selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0),
    .in1(out_reg_30_reg_30),
    .in2(out_reg_23_reg_23));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1 (.out1(out_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1),
    .sel(selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1),
    .in1(out_reg_14_reg_14),
    .in2(out_ui_plus_expr_FU_64_64_64_58_i2_fu__Z4vsumPKxPxjj_428532_428742));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0 (.out1(out_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0),
    .sel(selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0),
    .in1(out_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0),
    .in2(out_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0 (.out1(out_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0),
    .sel(selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0),
    .in1(out_reg_6_reg_6),
    .in2(out_reg_28_reg_28));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1 (.out1(out_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1),
    .sel(selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1),
    .in1(out_reg_18_reg_18),
    .in2(out_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_23_reg_0_0_0_0 (.out1(out_MUX_23_reg_0_0_0_0),
    .sel(selector_MUX_23_reg_0_0_0_0),
    .in1(out_reg_7_reg_7),
    .in2(out_reg_16_reg_16));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_23_reg_0_0_0_1 (.out1(out_MUX_23_reg_0_0_0_1),
    .sel(selector_MUX_23_reg_0_0_0_1),
    .in1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in2(out_MUX_23_reg_0_0_0_0));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_24_reg_1_0_0_0 (.out1(out_MUX_24_reg_1_0_0_0),
    .sel(selector_MUX_24_reg_1_0_0_0),
    .in1(out_ui_plus_expr_FU_64_64_64_58_i1_fu__Z4vsumPKxPxjj_428532_428627),
    .in2(out_uu_conv_conn_obj_3_UUdata_converter_FU_uu_conv_3));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_25_reg_10_0_0_0 (.out1(out_MUX_25_reg_10_0_0_0),
    .sel(selector_MUX_25_reg_10_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_56_i4_fu__Z4vsumPKxPxjj_428532_428658),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_30_reg_15_0_0_0 (.out1(out_MUX_30_reg_15_0_0_0),
    .sel(selector_MUX_30_reg_15_0_0_0),
    .in1(out_ui_plus_expr_FU_64_64_64_58_i0_fu__Z4vsumPKxPxjj_428532_428605),
    .in2(out_uu_conv_conn_obj_3_UUdata_converter_FU_uu_conv_3));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_35_reg_2_0_0_0 (.out1(out_MUX_35_reg_2_0_0_0),
    .sel(selector_MUX_35_reg_2_0_0_0),
    .in1(out_ui_lshift_expr_FU_32_0_32_55_i1_fu__Z4vsumPKxPxjj_428532_428939),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_40_reg_24_0_0_0 (.out1(out_MUX_40_reg_24_0_0_0),
    .sel(selector_MUX_40_reg_24_0_0_0),
    .in1(out_reg_3_reg_3),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(29),
    .BITSIZE_in2(29),
    .BITSIZE_out1(29)) MUX_41_reg_25_0_0_0 (.out1(out_MUX_41_reg_25_0_0_0),
    .sel(selector_MUX_41_reg_25_0_0_0),
    .in1(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1),
    .in2(out_uu_conv_conn_obj_2_UUdata_converter_FU_uu_conv_2));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_42_reg_26_0_0_0 (.out1(out_MUX_42_reg_26_0_0_0),
    .sel(selector_MUX_42_reg_26_0_0_0),
    .in1(out_reg_2_reg_2),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_43_reg_27_0_0_0 (.out1(out_MUX_43_reg_27_0_0_0),
    .sel(selector_MUX_43_reg_27_0_0_0),
    .in1(out_reg_1_reg_1),
    .in2(out_uu_conv_conn_obj_3_UUdata_converter_FU_uu_conv_3));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_46_reg_3_0_0_0 (.out1(out_MUX_46_reg_3_0_0_0),
    .sel(selector_MUX_46_reg_3_0_0_0),
    .in1(out_reg_19_reg_19),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) UUdata_converter_FU_uu_conv_0 (.out1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in1(out_conv_out_const_0_1_32));
  UUdata_converter_FU #(.BITSIZE_in1(29),
    .BITSIZE_out1(29)) UUdata_converter_FU_uu_conv_1 (.out1(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1),
    .in1(out_conv_out_reg_0_reg_0_32_29));
  UUdata_converter_FU #(.BITSIZE_in1(29),
    .BITSIZE_out1(29)) UUdata_converter_FU_uu_conv_2 (.out1(out_uu_conv_conn_obj_2_UUdata_converter_FU_uu_conv_2),
    .in1(out_conv_out_const_0_1_29));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) UUdata_converter_FU_uu_conv_3 (.out1(out_uu_conv_conn_obj_3_UUdata_converter_FU_uu_conv_3),
    .in1(out_conv_out_const_0_1_64));
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
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(29)) conv_out_const_0_1_29 (.out1(out_conv_out_const_0_1_29),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(64)) conv_out_const_0_1_64 (.out1(out_conv_out_const_0_1_64),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(29)) conv_out_reg_0_reg_0_32_29 (.out1(out_conv_out_reg_0_reg_0_32_29),
    .in1(out_reg_0_reg_0));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPKxPxjj_428532_428565 (.out1(out_ui_plus_expr_FU_32_0_32_56_i0_fu__Z4vsumPKxPxjj_428532_428565),
    .in1(out_reg_24_reg_24),
    .in2(out_const_1));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_in3(1),
    .BITSIZE_out1(32),
    .OFFSET_PARAMETER(1)) fu__Z4vsumPKxPxjj_428532_428567 (.out1(out_ui_bit_ior_concat_expr_FU_47_i0_fu__Z4vsumPKxPxjj_428532_428567),
    .in1(out_ui_lshift_expr_FU_32_0_32_55_i0_fu__Z4vsumPKxPxjj_428532_428914),
    .in2(out_const_1),
    .in3(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428568 (.out1(out_UUdata_converter_FU_8_i0_fu__Z4vsumPKxPxjj_428532_428568),
    .in1(out_ui_eq_expr_FU_32_32_32_53_i1_fu__Z4vsumPKxPxjj_428532_428772));
  ui_cond_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_in3(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428569 (.out1(out_ui_cond_expr_FU_1_1_1_1_49_i0_fu__Z4vsumPKxPxjj_428532_428569),
    .in1(out_truth_and_expr_FU_1_0_1_42_i0_fu__Z4vsumPKxPxjj_428532_428778),
    .in2(out_const_1),
    .in3(out_UUdata_converter_FU_8_i0_fu__Z4vsumPKxPxjj_428532_428568));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPKxPxjj_428532_428570 (.out1(out_read_cond_FU_9_i0_fu__Z4vsumPKxPxjj_428532_428570),
    .in1(out_ui_cond_expr_FU_1_1_1_1_49_i0_fu__Z4vsumPKxPxjj_428532_428569));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4vsumPKxPxjj_428532_428586 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_59_i0_fu__Z4vsumPKxPxjj_428532_428586),
    .in1(in_port_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_54_i2_fu__Z4vsumPKxPxjj_428532_428815));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPKxPxjj_428532_428598 (.out1(out_ui_plus_expr_FU_32_0_32_56_i1_fu__Z4vsumPKxPxjj_428532_428598),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPKxPxjj_428532_428603 (.out1(out_ui_plus_expr_FU_32_0_32_56_i2_fu__Z4vsumPKxPxjj_428532_428603),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z4vsumPKxPxjj_428532_428605 (.out1(out_ui_plus_expr_FU_64_64_64_58_i0_fu__Z4vsumPKxPxjj_428532_428605),
    .in1(out_reg_8_reg_8),
    .in2(out_reg_1_reg_1));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4vsumPKxPxjj_428532_428612 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_59_i1_fu__Z4vsumPKxPxjj_428532_428612),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_54_i1_fu__Z4vsumPKxPxjj_428532_428802));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z4vsumPKxPxjj_428532_428627 (.out1(out_ui_plus_expr_FU_64_64_64_58_i1_fu__Z4vsumPKxPxjj_428532_428627),
    .in1(out_reg_8_reg_8),
    .in2(out_reg_15_reg_15));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4vsumPKxPxjj_428532_428634 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_59_i2_fu__Z4vsumPKxPxjj_428532_428634),
    .in1(in_port_A),
    .in2(out_reg_12_reg_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPKxPxjj_428532_428638 (.out1(out_ui_bit_ior_expr_FU_32_0_32_48_i0_fu__Z4vsumPKxPxjj_428532_428638),
    .in1(out_reg_2_reg_2),
    .in2(out_const_1));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4vsumPKxPxjj_428532_428644 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_59_i3_fu__Z4vsumPKxPxjj_428532_428644),
    .in1(in_port_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_54_i3_fu__Z4vsumPKxPxjj_428532_428819));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPKxPxjj_428532_428653 (.out1(out_ui_plus_expr_FU_32_0_32_56_i3_fu__Z4vsumPKxPxjj_428532_428653),
    .in1(out_reg_10_reg_10),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPKxPxjj_428532_428658 (.out1(out_ui_plus_expr_FU_32_0_32_56_i4_fu__Z4vsumPKxPxjj_428532_428658),
    .in1(out_reg_3_reg_3),
    .in2(out_const_1));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428688 (.out1(out_ui_bit_and_expr_FU_1_0_1_45_i0_fu__Z4vsumPKxPxjj_428532_428688),
    .in1(in_port_loop_count),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428689 (.out1(out_UUdata_converter_FU_39_i0_fu__Z4vsumPKxPxjj_428532_428689),
    .in1(out_ui_eq_expr_FU_32_0_32_51_i0_fu__Z4vsumPKxPxjj_428532_428780));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428695 (.out1(out_UUdata_converter_FU_26_i0_fu__Z4vsumPKxPxjj_428532_428695),
    .in1(out_ui_eq_expr_FU_32_32_32_53_i2_fu__Z4vsumPKxPxjj_428532_428783));
  ui_bit_and_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(31),
    .BITSIZE_out1(31)) fu__Z4vsumPKxPxjj_428532_428700 (.out1(out_ui_bit_and_expr_FU_32_0_32_46_i0_fu__Z4vsumPKxPxjj_428532_428700),
    .in1(out_ui_rshift_expr_FU_32_0_32_60_i4_fu__Z4vsumPKxPxjj_428532_428950),
    .in2(out_const_4));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428704 (.out1(out_UUdata_converter_FU_25_i0_fu__Z4vsumPKxPxjj_428532_428704),
    .in1(out_ui_eq_expr_FU_32_32_32_53_i4_fu__Z4vsumPKxPxjj_428532_428794));
  ui_cond_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_in3(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428705 (.out1(out_ui_cond_expr_FU_1_1_1_1_49_i1_fu__Z4vsumPKxPxjj_428532_428705),
    .in1(out_truth_and_expr_FU_1_0_1_42_i1_fu__Z4vsumPKxPxjj_428532_428798),
    .in2(out_const_1),
    .in3(out_UUdata_converter_FU_25_i0_fu__Z4vsumPKxPxjj_428532_428704));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPKxPxjj_428532_428706 (.out1(out_read_cond_FU_27_i0_fu__Z4vsumPKxPxjj_428532_428706),
    .in1(out_reg_20_reg_20));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428714 (.out1(out_UUdata_converter_FU_36_i0_fu__Z4vsumPKxPxjj_428532_428714),
    .in1(out_ui_eq_expr_FU_32_32_32_53_i6_fu__Z4vsumPKxPxjj_428532_428808));
  ui_cond_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_in3(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428715 (.out1(out_ui_cond_expr_FU_1_1_1_1_49_i2_fu__Z4vsumPKxPxjj_428532_428715),
    .in1(out_truth_and_expr_FU_1_0_1_42_i2_fu__Z4vsumPKxPxjj_428532_428812),
    .in2(out_const_1),
    .in3(out_UUdata_converter_FU_36_i0_fu__Z4vsumPKxPxjj_428532_428714));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPKxPxjj_428532_428716 (.out1(out_read_cond_FU_37_i0_fu__Z4vsumPKxPxjj_428532_428716),
    .in1(out_reg_11_reg_11));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428723 (.out1(out_UUdata_converter_FU_40_i0_fu__Z4vsumPKxPxjj_428532_428723),
    .in1(out_ui_eq_expr_FU_1_0_1_50_i0_fu__Z4vsumPKxPxjj_428532_428823));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428727 (.out1(out_UUdata_converter_FU_38_i0_fu__Z4vsumPKxPxjj_428532_428727),
    .in1(out_ui_eq_expr_FU_32_0_32_52_i0_fu__Z4vsumPKxPxjj_428532_428826));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4vsumPKxPxjj_428532_428739 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_59_i4_fu__Z4vsumPKxPxjj_428532_428739),
    .in1(in_port_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_54_i5_fu__Z4vsumPKxPxjj_428532_428832));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z4vsumPKxPxjj_428532_428742 (.out1(out_ui_plus_expr_FU_64_64_64_58_i2_fu__Z4vsumPKxPxjj_428532_428742),
    .in1(out_reg_8_reg_8),
    .in2(out_reg_27_reg_27));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4vsumPKxPxjj_428532_428748 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_59_i5_fu__Z4vsumPKxPxjj_428532_428748),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_54_i4_fu__Z4vsumPKxPxjj_428532_428829));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428769 (.out1(out_ui_eq_expr_FU_32_32_32_53_i0_fu__Z4vsumPKxPxjj_428532_428769),
    .in1(out_ui_plus_expr_FU_32_0_32_56_i0_fu__Z4vsumPKxPxjj_428532_428565),
    .in2(in_port_len));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428772 (.out1(out_ui_eq_expr_FU_32_32_32_53_i1_fu__Z4vsumPKxPxjj_428532_428772),
    .in1(out_ui_bit_ior_concat_expr_FU_47_i0_fu__Z4vsumPKxPxjj_428532_428567),
    .in2(in_port_loop_count));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428778 (.out1(out_truth_and_expr_FU_1_0_1_42_i0_fu__Z4vsumPKxPxjj_428532_428778),
    .in1(out_truth_and_expr_FU_1_0_1_42_i3_fu__Z4vsumPKxPxjj_428532_428924),
    .in2(out_const_1));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428780 (.out1(out_ui_eq_expr_FU_32_0_32_51_i0_fu__Z4vsumPKxPxjj_428532_428780),
    .in1(in_port_loop_count),
    .in2(out_const_1));
  ui_eq_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(31),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428783 (.out1(out_ui_eq_expr_FU_32_32_32_53_i2_fu__Z4vsumPKxPxjj_428532_428783),
    .in1(out_reg_13_reg_13),
    .in2(out_reg_5_reg_5));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428786 (.out1(out_ui_lshift_expr_FU_32_0_32_54_i0_fu__Z4vsumPKxPxjj_428532_428786),
    .in1(out_ui_bit_ior_expr_FU_32_0_32_48_i0_fu__Z4vsumPKxPxjj_428532_428638),
    .in2(out_const_3));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428791 (.out1(out_ui_eq_expr_FU_32_32_32_53_i3_fu__Z4vsumPKxPxjj_428532_428791),
    .in1(out_ui_plus_expr_FU_32_0_32_56_i3_fu__Z4vsumPKxPxjj_428532_428653),
    .in2(in_port_len));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428794 (.out1(out_ui_eq_expr_FU_32_32_32_53_i4_fu__Z4vsumPKxPxjj_428532_428794),
    .in1(out_reg_2_reg_2),
    .in2(in_port_loop_count));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428798 (.out1(out_truth_and_expr_FU_1_0_1_42_i1_fu__Z4vsumPKxPxjj_428532_428798),
    .in1(out_truth_and_expr_FU_1_0_1_42_i4_fu__Z4vsumPKxPxjj_428532_428942),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428802 (.out1(out_ui_lshift_expr_FU_32_0_32_54_i1_fu__Z4vsumPKxPxjj_428532_428802),
    .in1(out_reg_2_reg_2),
    .in2(out_const_3));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428805 (.out1(out_ui_eq_expr_FU_32_32_32_53_i5_fu__Z4vsumPKxPxjj_428532_428805),
    .in1(out_ui_plus_expr_FU_32_0_32_56_i4_fu__Z4vsumPKxPxjj_428532_428658),
    .in2(in_port_len));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428808 (.out1(out_ui_eq_expr_FU_32_32_32_53_i6_fu__Z4vsumPKxPxjj_428532_428808),
    .in1(out_ui_bit_ior_expr_FU_32_0_32_48_i0_fu__Z4vsumPKxPxjj_428532_428638),
    .in2(in_port_loop_count));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428812 (.out1(out_truth_and_expr_FU_1_0_1_42_i2_fu__Z4vsumPKxPxjj_428532_428812),
    .in1(out_truth_and_expr_FU_1_0_1_42_i5_fu__Z4vsumPKxPxjj_428532_428946),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428815 (.out1(out_ui_lshift_expr_FU_32_0_32_54_i2_fu__Z4vsumPKxPxjj_428532_428815),
    .in1(out_reg_0_reg_0),
    .in2(out_const_3));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428819 (.out1(out_ui_lshift_expr_FU_32_0_32_54_i3_fu__Z4vsumPKxPxjj_428532_428819),
    .in1(out_reg_0_reg_0),
    .in2(out_const_3));
  ui_eq_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428823 (.out1(out_ui_eq_expr_FU_1_0_1_50_i0_fu__Z4vsumPKxPxjj_428532_428823),
    .in1(out_ui_bit_and_expr_FU_1_0_1_45_i0_fu__Z4vsumPKxPxjj_428532_428688),
    .in2(out_const_0));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428826 (.out1(out_ui_eq_expr_FU_32_0_32_52_i0_fu__Z4vsumPKxPxjj_428532_428826),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428829 (.out1(out_ui_lshift_expr_FU_32_0_32_54_i4_fu__Z4vsumPKxPxjj_428532_428829),
    .in1(out_reg_26_reg_26),
    .in2(out_const_3));
  ui_lshift_expr_FU #(.BITSIZE_in1(29),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428832 (.out1(out_ui_lshift_expr_FU_32_0_32_54_i5_fu__Z4vsumPKxPxjj_428532_428832),
    .in1(out_reg_25_reg_25),
    .in2(out_const_3));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428907 (.out1(out_ui_rshift_expr_FU_32_0_32_60_i0_fu__Z4vsumPKxPxjj_428532_428907),
    .in1(out_reg_26_reg_26),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428914 (.out1(out_ui_lshift_expr_FU_32_0_32_55_i0_fu__Z4vsumPKxPxjj_428532_428914),
    .in1(out_ui_rshift_expr_FU_32_0_32_60_i0_fu__Z4vsumPKxPxjj_428532_428907),
    .in2(out_const_1));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428924 (.out1(out_truth_and_expr_FU_1_0_1_42_i3_fu__Z4vsumPKxPxjj_428532_428924),
    .in1(out_ui_eq_expr_FU_32_32_32_53_i0_fu__Z4vsumPKxPxjj_428532_428769),
    .in2(out_const_1));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428928 (.out1(out_ui_rshift_expr_FU_32_0_32_60_i1_fu__Z4vsumPKxPxjj_428532_428928),
    .in1(out_ui_lshift_expr_FU_32_0_32_55_i1_fu__Z4vsumPKxPxjj_428532_428939),
    .in2(out_const_1));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428931 (.out1(out_ui_rshift_expr_FU_32_0_32_60_i2_fu__Z4vsumPKxPxjj_428532_428931),
    .in1(out_ui_lshift_expr_FU_32_0_32_55_i2_fu__Z4vsumPKxPxjj_428532_428954),
    .in2(out_const_1));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428934 (.out1(out_ui_rshift_expr_FU_32_0_32_60_i3_fu__Z4vsumPKxPxjj_428532_428934),
    .in1(out_reg_2_reg_2),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31)) fu__Z4vsumPKxPxjj_428532_428936 (.out1(out_ui_plus_expr_FU_32_0_32_57_i0_fu__Z4vsumPKxPxjj_428532_428936),
    .in1(out_ui_rshift_expr_FU_32_0_32_60_i3_fu__Z4vsumPKxPxjj_428532_428934),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428939 (.out1(out_ui_lshift_expr_FU_32_0_32_55_i1_fu__Z4vsumPKxPxjj_428532_428939),
    .in1(out_ui_plus_expr_FU_32_0_32_57_i0_fu__Z4vsumPKxPxjj_428532_428936),
    .in2(out_const_1));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428942 (.out1(out_truth_and_expr_FU_1_0_1_42_i4_fu__Z4vsumPKxPxjj_428532_428942),
    .in1(out_ui_eq_expr_FU_32_32_32_53_i3_fu__Z4vsumPKxPxjj_428532_428791),
    .in2(out_const_1));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428946 (.out1(out_truth_and_expr_FU_1_0_1_42_i5_fu__Z4vsumPKxPxjj_428532_428946),
    .in1(out_ui_eq_expr_FU_32_32_32_53_i5_fu__Z4vsumPKxPxjj_428532_428805),
    .in2(out_const_1));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428950 (.out1(out_ui_rshift_expr_FU_32_0_32_60_i4_fu__Z4vsumPKxPxjj_428532_428950),
    .in1(in_port_loop_count),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPKxPxjj_428532_428954 (.out1(out_ui_lshift_expr_FU_32_0_32_55_i2_fu__Z4vsumPKxPxjj_428532_428954),
    .in1(out_ui_bit_and_expr_FU_32_0_32_46_i0_fu__Z4vsumPKxPxjj_428532_428700),
    .in2(out_const_1));
  multi_read_cond_FU #(.BITSIZE_in1(1),
    .PORTSIZE_in1(2),
    .BITSIZE_out1(2)) fu__Z4vsumPKxPxjj_428532_428964 (.out1(out_multi_read_cond_FU_41_i0_fu__Z4vsumPKxPxjj_428532_428964),
    .in1({out_truth_and_expr_FU_1_1_1_43_i0_fu__Z4vsumPKxPxjj_428532_428970,
      out_UUdata_converter_FU_38_i0_fu__Z4vsumPKxPxjj_428532_428727}));
  truth_not_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428967 (.out1(out_truth_not_expr_FU_1_1_44_i0_fu__Z4vsumPKxPxjj_428532_428967),
    .in1(out_UUdata_converter_FU_38_i0_fu__Z4vsumPKxPxjj_428532_428727));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428970 (.out1(out_truth_and_expr_FU_1_1_1_43_i0_fu__Z4vsumPKxPxjj_428532_428970),
    .in1(out_UUdata_converter_FU_39_i0_fu__Z4vsumPKxPxjj_428532_428689),
    .in2(out_truth_not_expr_FU_1_1_44_i0_fu__Z4vsumPKxPxjj_428532_428967));
  multi_read_cond_FU #(.BITSIZE_in1(1),
    .PORTSIZE_in1(2),
    .BITSIZE_out1(2)) fu__Z4vsumPKxPxjj_428532_428977 (.out1(out_multi_read_cond_FU_17_i0_fu__Z4vsumPKxPxjj_428532_428977),
    .in1({out_reg_22_reg_22,
      out_reg_21_reg_21}));
  truth_not_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428980 (.out1(out_truth_not_expr_FU_1_1_44_i1_fu__Z4vsumPKxPxjj_428532_428980),
    .in1(out_UUdata_converter_FU_26_i0_fu__Z4vsumPKxPxjj_428532_428695));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPKxPxjj_428532_428983 (.out1(out_truth_and_expr_FU_1_1_1_43_i1_fu__Z4vsumPKxPxjj_428532_428983),
    .in1(out_UUdata_converter_FU_26_i0_fu__Z4vsumPKxPxjj_428532_428695),
    .in2(out_reg_4_reg_4));
  or or_or_start_port0( s_start_port0, selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609, selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631, selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745);
  or or_or_start_port1( s_start_port1, selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893, selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898, selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903);
  out_bambu_artificial_ParmMgr_Write_axis_modgen #(.BITSIZE_in1(7),
    .BITSIZE_in2(64),
    .BITSIZE_in3(32)) out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0 (.done_port({s_done_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_P0}),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port1}),
    .in1(out_const_2),
    .in2(out_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0),
    .in3(out_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1),
    ._out_TREADY(_out_TREADY));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_23_reg_0_0_0_1),
    .wenable(wrenable_reg_0));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_24_reg_1_0_0_0),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_10 (.out1(out_reg_10_reg_10),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_25_reg_10_0_0_0),
    .wenable(wrenable_reg_10));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_cond_expr_FU_1_1_1_1_49_i2_fu__Z4vsumPKxPxjj_428532_428715),
    .wenable(wrenable_reg_11));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_12 (.out1(out_reg_12_reg_12),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_lshift_expr_FU_32_0_32_54_i0_fu__Z4vsumPKxPxjj_428532_428786),
    .wenable(wrenable_reg_12));
  register_SE #(.BITSIZE_in1(31),
    .BITSIZE_out1(31)) reg_13 (.out1(out_reg_13_reg_13),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_rshift_expr_FU_32_0_32_60_i1_fu__Z4vsumPKxPxjj_428532_428928),
    .wenable(wrenable_reg_13));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_14 (.out1(out_reg_14_reg_14),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_58_i0_fu__Z4vsumPKxPxjj_428532_428605),
    .wenable(wrenable_reg_14));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_15 (.out1(out_reg_15_reg_15),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_30_reg_15_0_0_0),
    .wenable(wrenable_reg_15));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_16 (.out1(out_reg_16_reg_16),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_56_i1_fu__Z4vsumPKxPxjj_428532_428598),
    .wenable(wrenable_reg_16));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_17 (.out1(out_reg_17_reg_17),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_59_i2_fu__Z4vsumPKxPxjj_428532_428634),
    .wenable(wrenable_reg_17));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_18 (.out1(out_reg_18_reg_18),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_59_i3_fu__Z4vsumPKxPxjj_428532_428644),
    .wenable(wrenable_reg_18));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_19 (.out1(out_reg_19_reg_19),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_56_i3_fu__Z4vsumPKxPxjj_428532_428653),
    .wenable(wrenable_reg_19));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_35_reg_2_0_0_0),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_20 (.out1(out_reg_20_reg_20),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_cond_expr_FU_1_1_1_1_49_i1_fu__Z4vsumPKxPxjj_428532_428705),
    .wenable(wrenable_reg_20));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_21 (.out1(out_reg_21_reg_21),
    .clock(clock),
    .reset(reset),
    .in1(out_truth_not_expr_FU_1_1_44_i1_fu__Z4vsumPKxPxjj_428532_428980),
    .wenable(wrenable_reg_21));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_22 (.out1(out_reg_22_reg_22),
    .clock(clock),
    .reset(reset),
    .in1(out_truth_and_expr_FU_1_1_1_43_i1_fu__Z4vsumPKxPxjj_428532_428983),
    .wenable(wrenable_reg_22));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_23 (.out1(out_reg_23_reg_23),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_58_i1_fu__Z4vsumPKxPxjj_428532_428627),
    .wenable(wrenable_reg_23));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_24 (.out1(out_reg_24_reg_24),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_40_reg_24_0_0_0),
    .wenable(wrenable_reg_24));
  register_SE #(.BITSIZE_in1(29),
    .BITSIZE_out1(29)) reg_25 (.out1(out_reg_25_reg_25),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_41_reg_25_0_0_0),
    .wenable(wrenable_reg_25));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_26 (.out1(out_reg_26_reg_26),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_42_reg_26_0_0_0),
    .wenable(wrenable_reg_26));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_27 (.out1(out_reg_27_reg_27),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_43_reg_27_0_0_0),
    .wenable(wrenable_reg_27));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_28 (.out1(out_reg_28_reg_28),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_59_i4_fu__Z4vsumPKxPxjj_428532_428739),
    .wenable(wrenable_reg_28));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_29 (.out1(out_reg_29_reg_29),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_59_i5_fu__Z4vsumPKxPxjj_428532_428748),
    .wenable(wrenable_reg_29));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_46_reg_3_0_0_0),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_30 (.out1(out_reg_30_reg_30),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_58_i2_fu__Z4vsumPKxPxjj_428532_428742),
    .wenable(wrenable_reg_30));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_40_i0_fu__Z4vsumPKxPxjj_428532_428723),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(31),
    .BITSIZE_out1(31)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_rshift_expr_FU_32_0_32_60_i2_fu__Z4vsumPKxPxjj_428532_428931),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_59_i0_fu__Z4vsumPKxPxjj_428532_428586),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_56_i2_fu__Z4vsumPKxPxjj_428532_428603),
    .wenable(wrenable_reg_7));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0),
    .wenable(wrenable_reg_8));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_59_i1_fu__Z4vsumPKxPxjj_428532_428612),
    .wenable(wrenable_reg_9));
  // io-signal post fix
  assign OUT_CONDITION__Z4vsumPKxPxjj_428532_428570 = out_read_cond_FU_9_i0_fu__Z4vsumPKxPxjj_428532_428570;
  assign OUT_CONDITION__Z4vsumPKxPxjj_428532_428706 = out_read_cond_FU_27_i0_fu__Z4vsumPKxPxjj_428532_428706;
  assign OUT_CONDITION__Z4vsumPKxPxjj_428532_428716 = out_read_cond_FU_37_i0_fu__Z4vsumPKxPxjj_428532_428716;
  assign OUT_MULTIIF__Z4vsumPKxPxjj_428532_428964 = out_multi_read_cond_FU_41_i0_fu__Z4vsumPKxPxjj_428532_428964;
  assign OUT_MULTIIF__Z4vsumPKxPxjj_428532_428977 = out_multi_read_cond_FU_17_i0_fu__Z4vsumPKxPxjj_428532_428977;
  assign OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609 = s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_P0;
  assign OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631 = s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_P0;
  assign OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745 = s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_P0;
  assign OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428893 = s_done_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_P0;
  assign OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428898 = s_done_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_P0;
  assign OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428903 = s_done_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_P0;

endmodule

// FSM based controller description for _Z4vsumPKxPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z4vsumPKxPxjj(done_port,
  selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609,
  selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631,
  selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745,
  selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893,
  selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898,
  selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0,
  selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0,
  selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1,
  selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0,
  selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0,
  selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1,
  selector_MUX_23_reg_0_0_0_0,
  selector_MUX_23_reg_0_0_0_1,
  selector_MUX_24_reg_1_0_0_0,
  selector_MUX_25_reg_10_0_0_0,
  selector_MUX_30_reg_15_0_0_0,
  selector_MUX_35_reg_2_0_0_0,
  selector_MUX_40_reg_24_0_0_0,
  selector_MUX_41_reg_25_0_0_0,
  selector_MUX_42_reg_26_0_0_0,
  selector_MUX_43_reg_27_0_0_0,
  selector_MUX_46_reg_3_0_0_0,
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
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z4vsumPKxPxjj_428532_428570,
  OUT_CONDITION__Z4vsumPKxPxjj_428532_428706,
  OUT_CONDITION__Z4vsumPKxPxjj_428532_428716,
  OUT_MULTIIF__Z4vsumPKxPxjj_428532_428964,
  OUT_MULTIIF__Z4vsumPKxPxjj_428532_428977,
  OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609,
  OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631,
  OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745,
  OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428893,
  OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428898,
  OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428903,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z4vsumPKxPxjj_428532_428570;
  input OUT_CONDITION__Z4vsumPKxPxjj_428532_428706;
  input OUT_CONDITION__Z4vsumPKxPxjj_428532_428716;
  input [1:0] OUT_MULTIIF__Z4vsumPKxPxjj_428532_428964;
  input [1:0] OUT_MULTIIF__Z4vsumPKxPxjj_428532_428977;
  input OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609;
  input OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631;
  input OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745;
  input OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428893;
  input OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428898;
  input OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428903;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609;
  output selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631;
  output selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745;
  output selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893;
  output selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898;
  output selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0;
  output selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0;
  output selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1;
  output selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0;
  output selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0;
  output selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1;
  output selector_MUX_23_reg_0_0_0_0;
  output selector_MUX_23_reg_0_0_0_1;
  output selector_MUX_24_reg_1_0_0_0;
  output selector_MUX_25_reg_10_0_0_0;
  output selector_MUX_30_reg_15_0_0_0;
  output selector_MUX_35_reg_2_0_0_0;
  output selector_MUX_40_reg_24_0_0_0;
  output selector_MUX_41_reg_25_0_0_0;
  output selector_MUX_42_reg_26_0_0_0;
  output selector_MUX_43_reg_27_0_0_0;
  output selector_MUX_46_reg_3_0_0_0;
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
  output wrenable_reg_4;
  output wrenable_reg_5;
  output wrenable_reg_6;
  output wrenable_reg_7;
  output wrenable_reg_8;
  output wrenable_reg_9;
  parameter [4:0] S_12 = 5'd12,
    S_19 = 5'd19,
    S_5 = 5'd5,
    S_6 = 5'd6,
    S_7 = 5'd7,
    S_8 = 5'd8,
    S_9 = 5'd9,
    S_2 = 5'd2,
    S_3 = 5'd3,
    S_4 = 5'd4,
    S_10 = 5'd10,
    S_11 = 5'd11,
    S_1 = 5'd1,
    S_20 = 5'd20,
    S_0 = 5'd0,
    S_18 = 5'd18,
    S_13 = 5'd13,
    S_14 = 5'd14,
    S_15 = 5'd15,
    S_16 = 5'd16,
    S_17 = 5'd17;
  reg [4:0] _present_state=S_12, _next_state;
  reg done_port;
  reg selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609;
  reg selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631;
  reg selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745;
  reg selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893;
  reg selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898;
  reg selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0;
  reg selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0;
  reg selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1;
  reg selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0;
  reg selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0;
  reg selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1;
  reg selector_MUX_23_reg_0_0_0_0;
  reg selector_MUX_23_reg_0_0_0_1;
  reg selector_MUX_24_reg_1_0_0_0;
  reg selector_MUX_25_reg_10_0_0_0;
  reg selector_MUX_30_reg_15_0_0_0;
  reg selector_MUX_35_reg_2_0_0_0;
  reg selector_MUX_40_reg_24_0_0_0;
  reg selector_MUX_41_reg_25_0_0_0;
  reg selector_MUX_42_reg_26_0_0_0;
  reg selector_MUX_43_reg_27_0_0_0;
  reg selector_MUX_46_reg_3_0_0_0;
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
    selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609 = 1'b0;
    selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631 = 1'b0;
    selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745 = 1'b0;
    selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893 = 1'b0;
    selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898 = 1'b0;
    selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0 = 1'b0;
    selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0 = 1'b0;
    selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1 = 1'b0;
    selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0 = 1'b0;
    selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0 = 1'b0;
    selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1 = 1'b0;
    selector_MUX_23_reg_0_0_0_0 = 1'b0;
    selector_MUX_23_reg_0_0_0_1 = 1'b0;
    selector_MUX_24_reg_1_0_0_0 = 1'b0;
    selector_MUX_25_reg_10_0_0_0 = 1'b0;
    selector_MUX_30_reg_15_0_0_0 = 1'b0;
    selector_MUX_35_reg_2_0_0_0 = 1'b0;
    selector_MUX_40_reg_24_0_0_0 = 1'b0;
    selector_MUX_41_reg_25_0_0_0 = 1'b0;
    selector_MUX_42_reg_26_0_0_0 = 1'b0;
    selector_MUX_43_reg_27_0_0_0 = 1'b0;
    selector_MUX_46_reg_3_0_0_0 = 1'b0;
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
          selector_MUX_23_reg_0_0_0_1 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_24 = 1'b1;
          wrenable_reg_25 = 1'b1;
          wrenable_reg_26 = 1'b1;
          wrenable_reg_27 = 1'b1;
          wrenable_reg_3 = 1'b1;
          wrenable_reg_4 = 1'b1;
          wrenable_reg_5 = 1'b1;
          casez (OUT_MULTIIF__Z4vsumPKxPxjj_428532_428964)
            2'b10 :
              begin
                _next_state = S_0;
                selector_MUX_23_reg_0_0_0_1 = 1'b0;
                wrenable_reg_0 = 1'b0;
                wrenable_reg_1 = 1'b0;
                wrenable_reg_2 = 1'b0;
                wrenable_reg_3 = 1'b0;
                wrenable_reg_4 = 1'b0;
                wrenable_reg_5 = 1'b0;
              end
            2'b01 :
              begin
                _next_state = S_19;
                done_port = 1'b1;
                selector_MUX_23_reg_0_0_0_1 = 1'b0;
                wrenable_reg_0 = 1'b0;
                wrenable_reg_1 = 1'b0;
                wrenable_reg_2 = 1'b0;
                wrenable_reg_24 = 1'b0;
                wrenable_reg_25 = 1'b0;
                wrenable_reg_26 = 1'b0;
                wrenable_reg_27 = 1'b0;
                wrenable_reg_3 = 1'b0;
                wrenable_reg_4 = 1'b0;
                wrenable_reg_5 = 1'b0;
              end
            default:
              begin
                _next_state = S_5;
                wrenable_reg_24 = 1'b0;
                wrenable_reg_25 = 1'b0;
                wrenable_reg_26 = 1'b0;
                wrenable_reg_27 = 1'b0;
              end
          endcase
        end
        else
        begin
          _next_state = S_12;
        end
      S_19 :
        begin
          _next_state = S_12;
        end
      S_5 :
        begin
          selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0 = 1'b1;
          selector_MUX_25_reg_10_0_0_0 = 1'b1;
          selector_MUX_35_reg_2_0_0_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_13 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_6 = 1'b1;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609;
          wrenable_reg_9 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609 == 1'b0)
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0 = 1'b1;
          wrenable_reg_8 = OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609;
          if (OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609 == 1'b0)
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
          selector_MUX_30_reg_15_0_0_0 = 1'b1;
          wrenable_reg_14 = 1'b1;
          wrenable_reg_15 = 1'b1;
          if (OUT_CONDITION__Z4vsumPKxPxjj_428532_428716 == 1'b1)
            begin
              _next_state = S_8;
              selector_MUX_30_reg_15_0_0_0 = 1'b0;
              wrenable_reg_15 = 1'b0;
            end
          else
            begin
              _next_state = S_2;
            end
        end
      S_8 :
        begin
          selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893 = 1'b1;
          selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1 = 1'b1;
          selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0 = 1'b1;
          selector_MUX_23_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_15 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428893 == 1'b0)
            begin
              _next_state = S_9;
              selector_MUX_23_reg_0_0_0_0 = 1'b0;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_10 = 1'b0;
              wrenable_reg_15 = 1'b0;
            end
          else
            begin
              _next_state = S_2;
            end
        end
      S_9 :
        begin
          selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1 = 1'b1;
          selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0 = 1'b1;
          selector_MUX_23_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_15 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428893 == 1'b0)
            begin
              _next_state = S_9;
              selector_MUX_23_reg_0_0_0_0 = 1'b0;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_10 = 1'b0;
              wrenable_reg_15 = 1'b0;
            end
          else
            begin
              _next_state = S_2;
            end
        end
      S_2 :
        begin
          selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2 = 1'b1;
          wrenable_reg_16 = 1'b1;
          wrenable_reg_17 = 1'b1;
          wrenable_reg_18 = 1'b1;
          wrenable_reg_19 = 1'b1;
          wrenable_reg_20 = 1'b1;
          wrenable_reg_21 = 1'b1;
          wrenable_reg_22 = 1'b1;
          wrenable_reg_8 = OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631;
          if (OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631 == 1'b0)
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0 = 1'b1;
          wrenable_reg_8 = OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631;
          if (OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631 == 1'b0)
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
          selector_MUX_24_reg_1_0_0_0 = 1'b1;
          selector_MUX_46_reg_3_0_0_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_23 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_CONDITION__Z4vsumPKxPxjj_428532_428706 == 1'b1)
            begin
              _next_state = S_10;
              selector_MUX_24_reg_1_0_0_0 = 1'b0;
              selector_MUX_46_reg_3_0_0_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
          else
            begin
              _next_state = S_1;
            end
        end
      S_10 :
        begin
          selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898 = 1'b1;
          selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0 = 1'b1;
          selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428898 == 1'b0)
            begin
              _next_state = S_11;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
          else
            begin
              _next_state = S_1;
            end
        end
      S_11 :
        begin
          selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0 = 1'b1;
          selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428898 == 1'b0)
            begin
              _next_state = S_11;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
          else
            begin
              _next_state = S_1;
            end
        end
      S_1 :
        begin
          selector_MUX_40_reg_24_0_0_0 = 1'b1;
          selector_MUX_41_reg_25_0_0_0 = 1'b1;
          selector_MUX_42_reg_26_0_0_0 = 1'b1;
          selector_MUX_43_reg_27_0_0_0 = 1'b1;
          wrenable_reg_24 = 1'b1;
          wrenable_reg_25 = 1'b1;
          wrenable_reg_26 = 1'b1;
          wrenable_reg_27 = 1'b1;
          casez (OUT_MULTIIF__Z4vsumPKxPxjj_428532_428977)
            2'b01 :
              begin
                _next_state = S_5;
                selector_MUX_40_reg_24_0_0_0 = 1'b0;
                selector_MUX_41_reg_25_0_0_0 = 1'b0;
                selector_MUX_42_reg_26_0_0_0 = 1'b0;
                selector_MUX_43_reg_27_0_0_0 = 1'b0;
                wrenable_reg_24 = 1'b0;
                wrenable_reg_25 = 1'b0;
                wrenable_reg_26 = 1'b0;
                wrenable_reg_27 = 1'b0;
              end
            2'b10 :
              begin
                _next_state = S_20;
                done_port = 1'b1;
                selector_MUX_40_reg_24_0_0_0 = 1'b0;
                selector_MUX_41_reg_25_0_0_0 = 1'b0;
                selector_MUX_42_reg_26_0_0_0 = 1'b0;
                selector_MUX_43_reg_27_0_0_0 = 1'b0;
                wrenable_reg_24 = 1'b0;
                wrenable_reg_25 = 1'b0;
                wrenable_reg_26 = 1'b0;
                wrenable_reg_27 = 1'b0;
              end
            default:
              begin
                _next_state = S_0;
              end
          endcase
        end
      S_20 :
        begin
          _next_state = S_12;
        end
      S_0 :
        begin
          wrenable_reg_28 = 1'b1;
          wrenable_reg_29 = 1'b1;
          if (OUT_CONDITION__Z4vsumPKxPxjj_428532_428570 == 1'b1)
            begin
              _next_state = S_13;
            end
          else
            begin
              _next_state = S_18;
              done_port = 1'b1;
              wrenable_reg_28 = 1'b0;
              wrenable_reg_29 = 1'b0;
            end
        end
      S_18 :
        begin
          _next_state = S_12;
        end
      S_13 :
        begin
          selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745 = 1'b1;
          wrenable_reg_8 = OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745;
          if (OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745 == 1'b0)
            begin
              _next_state = S_14;
            end
          else
            begin
              _next_state = S_15;
            end
        end
      S_14 :
        begin
          wrenable_reg_8 = OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745;
          if (OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745 == 1'b0)
            begin
              _next_state = S_14;
            end
          else
            begin
              _next_state = S_15;
            end
        end
      S_15 :
        begin
          selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903 = 1'b1;
          wrenable_reg_30 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428903 == 1'b0)
            begin
              _next_state = S_16;
            end
          else
            begin
              _next_state = S_17;
              done_port = 1'b1;
            end
        end
      S_16 :
        begin
          selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0 = 1'b1;
          selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428903 == 1'b0)
            begin
              _next_state = S_16;
            end
          else
            begin
              _next_state = S_17;
              done_port = 1'b1;
            end
        end
      S_17 :
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

// Top component for _Z4vsumPKxPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z4vsumPKxPxjj(clock,
  reset,
  start_port,
  done_port,
  A,
  out,
  loop_count,
  len,
  _A_TDATA,
  _A_TVALID,
  _out_TREADY,
  _A_TREADY,
  _out_TDATA,
  _out_TVALID);
  // IN
  input clock;
  input reset;
  input start_port;
  input [31:0] A;
  input [31:0] out;
  input [31:0] loop_count;
  input [31:0] len;
  input [63:0] _A_TDATA;
  input _A_TVALID;
  input _out_TREADY;
  // OUT
  output done_port;
  output _A_TREADY;
  output [63:0] _out_TDATA;
  output _out_TVALID;
  // Component and signal declarations
  wire OUT_CONDITION__Z4vsumPKxPxjj_428532_428570;
  wire OUT_CONDITION__Z4vsumPKxPxjj_428532_428706;
  wire OUT_CONDITION__Z4vsumPKxPxjj_428532_428716;
  wire [1:0] OUT_MULTIIF__Z4vsumPKxPxjj_428532_428964;
  wire [1:0] OUT_MULTIIF__Z4vsumPKxPxjj_428532_428977;
  wire OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609;
  wire OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631;
  wire OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745;
  wire OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428893;
  wire OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428898;
  wire OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428903;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609;
  wire selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631;
  wire selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745;
  wire selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893;
  wire selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898;
  wire selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0;
  wire selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0;
  wire selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1;
  wire selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0;
  wire selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0;
  wire selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1;
  wire selector_MUX_23_reg_0_0_0_0;
  wire selector_MUX_23_reg_0_0_0_1;
  wire selector_MUX_24_reg_1_0_0_0;
  wire selector_MUX_25_reg_10_0_0_0;
  wire selector_MUX_30_reg_15_0_0_0;
  wire selector_MUX_35_reg_2_0_0_0;
  wire selector_MUX_40_reg_24_0_0_0;
  wire selector_MUX_41_reg_25_0_0_0;
  wire selector_MUX_42_reg_26_0_0_0;
  wire selector_MUX_43_reg_27_0_0_0;
  wire selector_MUX_46_reg_3_0_0_0;
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
  wire wrenable_reg_4;
  wire wrenable_reg_5;
  wire wrenable_reg_6;
  wire wrenable_reg_7;
  wire wrenable_reg_8;
  wire wrenable_reg_9;
  
  controller__Z4vsumPKxPxjj Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609(selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609),
    .selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631(selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631),
    .selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745(selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745),
    .selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893(selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893),
    .selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898(selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898),
    .selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903(selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0),
    .selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0(selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0),
    .selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1(selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1),
    .selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0(selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0),
    .selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0(selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0),
    .selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1(selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1),
    .selector_MUX_23_reg_0_0_0_0(selector_MUX_23_reg_0_0_0_0),
    .selector_MUX_23_reg_0_0_0_1(selector_MUX_23_reg_0_0_0_1),
    .selector_MUX_24_reg_1_0_0_0(selector_MUX_24_reg_1_0_0_0),
    .selector_MUX_25_reg_10_0_0_0(selector_MUX_25_reg_10_0_0_0),
    .selector_MUX_30_reg_15_0_0_0(selector_MUX_30_reg_15_0_0_0),
    .selector_MUX_35_reg_2_0_0_0(selector_MUX_35_reg_2_0_0_0),
    .selector_MUX_40_reg_24_0_0_0(selector_MUX_40_reg_24_0_0_0),
    .selector_MUX_41_reg_25_0_0_0(selector_MUX_41_reg_25_0_0_0),
    .selector_MUX_42_reg_26_0_0_0(selector_MUX_42_reg_26_0_0_0),
    .selector_MUX_43_reg_27_0_0_0(selector_MUX_43_reg_27_0_0_0),
    .selector_MUX_46_reg_3_0_0_0(selector_MUX_46_reg_3_0_0_0),
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
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9),
    .OUT_CONDITION__Z4vsumPKxPxjj_428532_428570(OUT_CONDITION__Z4vsumPKxPxjj_428532_428570),
    .OUT_CONDITION__Z4vsumPKxPxjj_428532_428706(OUT_CONDITION__Z4vsumPKxPxjj_428532_428706),
    .OUT_CONDITION__Z4vsumPKxPxjj_428532_428716(OUT_CONDITION__Z4vsumPKxPxjj_428532_428716),
    .OUT_MULTIIF__Z4vsumPKxPxjj_428532_428964(OUT_MULTIIF__Z4vsumPKxPxjj_428532_428964),
    .OUT_MULTIIF__Z4vsumPKxPxjj_428532_428977(OUT_MULTIIF__Z4vsumPKxPxjj_428532_428977),
    .OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609(OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609),
    .OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631(OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631),
    .OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745(OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745),
    .OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428893(OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428893),
    .OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428898(OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428898),
    .OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428903(OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428903),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z4vsumPKxPxjj Datapath_i (._A_TREADY(_A_TREADY),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .OUT_CONDITION__Z4vsumPKxPxjj_428532_428570(OUT_CONDITION__Z4vsumPKxPxjj_428532_428570),
    .OUT_CONDITION__Z4vsumPKxPxjj_428532_428706(OUT_CONDITION__Z4vsumPKxPxjj_428532_428706),
    .OUT_CONDITION__Z4vsumPKxPxjj_428532_428716(OUT_CONDITION__Z4vsumPKxPxjj_428532_428716),
    .OUT_MULTIIF__Z4vsumPKxPxjj_428532_428964(OUT_MULTIIF__Z4vsumPKxPxjj_428532_428964),
    .OUT_MULTIIF__Z4vsumPKxPxjj_428532_428977(OUT_MULTIIF__Z4vsumPKxPxjj_428532_428977),
    .OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609(OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428609),
    .OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631(OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428631),
    .OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745(OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428745),
    .OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428893(OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428893),
    .OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428898(OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428898),
    .OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428903(OUT_UNBOUNDED__Z4vsumPKxPxjj_428532_428903),
    .clock(clock),
    .reset(reset),
    .in_port_A(A),
    .in_port_out(out),
    .in_port_loop_count(loop_count),
    .in_port_len(len),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID),
    ._out_TREADY(_out_TREADY),
    .selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609(selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428609),
    .selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631(selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428631),
    .selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745(selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428745),
    .selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893(selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428893),
    .selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898(selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428898),
    .selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903(selector_IN_UNBOUNDED__Z4vsumPKxPxjj_428532_428903),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_0),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_1),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_0_2),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_61_i0_0_1_0),
    .selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0(selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_0),
    .selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1(selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_0_1),
    .selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0(selector_MUX_18_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_1_1_0),
    .selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0(selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_0),
    .selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1(selector_MUX_19_out_bambu_artificial_ParmMgr_Write_axis_modgen_62_i0_2_0_1),
    .selector_MUX_23_reg_0_0_0_0(selector_MUX_23_reg_0_0_0_0),
    .selector_MUX_23_reg_0_0_0_1(selector_MUX_23_reg_0_0_0_1),
    .selector_MUX_24_reg_1_0_0_0(selector_MUX_24_reg_1_0_0_0),
    .selector_MUX_25_reg_10_0_0_0(selector_MUX_25_reg_10_0_0_0),
    .selector_MUX_30_reg_15_0_0_0(selector_MUX_30_reg_15_0_0_0),
    .selector_MUX_35_reg_2_0_0_0(selector_MUX_35_reg_2_0_0_0),
    .selector_MUX_40_reg_24_0_0_0(selector_MUX_40_reg_24_0_0_0),
    .selector_MUX_41_reg_25_0_0_0(selector_MUX_41_reg_25_0_0_0),
    .selector_MUX_42_reg_26_0_0_0(selector_MUX_42_reg_26_0_0_0),
    .selector_MUX_43_reg_27_0_0_0(selector_MUX_43_reg_27_0_0_0),
    .selector_MUX_46_reg_3_0_0_0(selector_MUX_46_reg_3_0_0_0),
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

// Minimal interface for function: _Z4vsumPKxPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z4vsumPKxPxjj(clock,
  reset,
  start_port,
  A_TDATA,
  loop_count,
  len,
  A_TVALID,
  out_TREADY,
  done_port,
  A_TREADY,
  out_TDATA,
  out_TVALID);
  // IN
  input clock;
  input reset;
  input start_port;
  input [63:0] A_TDATA;
  input [31:0] loop_count;
  input [31:0] len;
  input A_TVALID;
  input out_TREADY;
  // OUT
  output done_port;
  output A_TREADY;
  output [63:0] out_TDATA;
  output out_TVALID;
  // Component and signal declarations
  
  __Z4vsumPKxPxjj __Z4vsumPKxPxjj_i0 (.done_port(done_port),
    ._A_TREADY(A_TREADY),
    ._out_TDATA(out_TDATA),
    ._out_TVALID(out_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port(start_port),
    .A(32'b00000000000000000000000000000000),
    .out(32'b00000000000000000000000000000000),
    .loop_count(loop_count),
    .len(len),
    ._A_TDATA(A_TDATA),
    ._A_TVALID(A_TVALID),
    ._out_TREADY(out_TREADY));

endmodule


