// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-04T22:52:39
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=vsum --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER -DDATA_T=int64_t -DSIZE_N=512 -DBAMBU_LANES=16 --std=c++14 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include/bambu -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/vectors/n512 vsum.cpp 
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
module register_STD(clock,
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

// This component is part of the BAMBU/PANDA IP LIBRARY
// Copyright (C) 2004-2024 Politecnico di Milano
// Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
// License: PANDA_LGPLv3
`timescale 1ns / 1ps
module ui_ternary_plus_expr_FU(in1,
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
  assign out1 = in1 + in2 + in3;
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
    BITSIZE_out1=1024;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [1023:0] _A_TDATA;
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

// Datapath RTL description for _Z4vsumPK6ac_intILi1024ELb0EEPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z4vsumPK6ac_intILi1024ELb0EEPxjj(clock,
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
  selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566,
  selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0,
  selector_MUX_28_reg_0_0_0_0,
  selector_MUX_29_reg_1_0_0_0,
  selector_MUX_36_reg_2_0_0_0,
  selector_MUX_37_reg_3_0_0_0,
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
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667,
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950,
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953,
  OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566,
  OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_A;
  input [31:0] in_port_out;
  input [31:0] in_port_loop_count;
  input [31:0] in_port_len;
  input [1023:0] _A_TDATA;
  input _A_TVALID;
  input _out_TREADY;
  input selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  input selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0;
  input selector_MUX_28_reg_0_0_0_0;
  input selector_MUX_29_reg_1_0_0_0;
  input selector_MUX_36_reg_2_0_0_0;
  input selector_MUX_37_reg_3_0_0_0;
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
  output [63:0] _out_TDATA;
  output _out_TVALID;
  output OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667;
  output OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950;
  output OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953;
  output OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  output OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047;
  // Component and signal declarations
  wire [1023:0] out_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0;
  wire [31:0] out_MUX_28_reg_0_0_0_0;
  wire [63:0] out_MUX_29_reg_1_0_0_0;
  wire [31:0] out_MUX_36_reg_2_0_0_0;
  wire [31:0] out_MUX_37_reg_3_0_0_0;
  wire [63:0] out_UUdata_converter_FU_10_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428576;
  wire [63:0] out_UUdata_converter_FU_11_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428580;
  wire [63:0] out_UUdata_converter_FU_12_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428584;
  wire [63:0] out_UUdata_converter_FU_13_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428588;
  wire [63:0] out_UUdata_converter_FU_14_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428592;
  wire [63:0] out_UUdata_converter_FU_15_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428596;
  wire [63:0] out_UUdata_converter_FU_16_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428600;
  wire [63:0] out_UUdata_converter_FU_17_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428604;
  wire [63:0] out_UUdata_converter_FU_18_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428608;
  wire [63:0] out_UUdata_converter_FU_19_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428612;
  wire [63:0] out_UUdata_converter_FU_20_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428616;
  wire [63:0] out_UUdata_converter_FU_21_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428620;
  wire [63:0] out_UUdata_converter_FU_22_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428624;
  wire [63:0] out_UUdata_converter_FU_23_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428628;
  wire out_UUdata_converter_FU_24_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428665;
  wire out_UUdata_converter_FU_27_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428949;
  wire [63:0] out_UUdata_converter_FU_8_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428567;
  wire [63:0] out_UUdata_converter_FU_9_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428572;
  wire out_const_0;
  wire out_const_1;
  wire [9:0] out_const_10;
  wire [1:0] out_const_11;
  wire [7:0] out_const_12;
  wire [8:0] out_const_13;
  wire [9:0] out_const_14;
  wire [9:0] out_const_15;
  wire [2:0] out_const_16;
  wire [8:0] out_const_17;
  wire [9:0] out_const_18;
  wire [9:0] out_const_19;
  wire [5:0] out_const_2;
  wire [31:0] out_const_20;
  wire [6:0] out_const_3;
  wire [7:0] out_const_4;
  wire [8:0] out_const_5;
  wire [9:0] out_const_6;
  wire [9:0] out_const_7;
  wire [8:0] out_const_8;
  wire [9:0] out_const_9;
  wire [31:0] out_conv_out_const_0_1_32;
  wire [63:0] out_conv_out_const_0_1_64;
  wire out_read_cond_FU_25_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667;
  wire out_read_cond_FU_28_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950;
  wire out_read_cond_FU_34_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953;
  wire [31:0] out_reg_0_reg_0;
  wire out_reg_10_reg_10;
  wire [31:0] out_reg_11_reg_11;
  wire [31:0] out_reg_12_reg_12;
  wire [63:0] out_reg_13_reg_13;
  wire [63:0] out_reg_14_reg_14;
  wire [63:0] out_reg_15_reg_15;
  wire [63:0] out_reg_1_reg_1;
  wire [31:0] out_reg_2_reg_2;
  wire [31:0] out_reg_3_reg_3;
  wire [31:0] out_reg_4_reg_4;
  wire [31:0] out_reg_5_reg_5;
  wire [31:0] out_reg_6_reg_6;
  wire [31:0] out_reg_7_reg_7;
  wire [1023:0] out_reg_8_reg_8;
  wire out_reg_9_reg_9;
  wire out_truth_and_expr_FU_1_0_1_35_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428989;
  wire out_truth_and_expr_FU_1_0_1_35_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429365;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428568;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428609;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428613;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i12_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428617;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i13_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428621;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i14_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428625;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i15_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428629;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428573;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428577;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428581;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428585;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428589;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428593;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428597;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428601;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428605;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428569;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428610;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428614;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i12_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428618;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i13_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428622;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i14_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428626;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i15_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428630;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i16_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429176;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i17_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429189;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i18_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429201;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i19_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429213;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428574;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i20_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429225;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i21_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429237;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i22_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429249;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i23_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429283;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i24_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429299;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i25_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429314;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i26_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429340;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i27_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429355;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428578;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428582;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428586;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428590;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428594;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428598;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428602;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428606;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_38_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428631;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_38_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428656;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_38_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428659;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_38_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428632;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_38_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428633;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_38_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428634;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_38_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428635;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_38_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428636;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_38_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428637;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_38_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428644;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_38_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428649;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_38_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428650;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_39_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428570;
  wire [0:0] out_ui_cond_expr_FU_1_1_1_1_40_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428666;
  wire out_ui_eq_expr_FU_32_0_32_41_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428993;
  wire out_ui_eq_expr_FU_32_32_32_42_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428980;
  wire out_ui_eq_expr_FU_32_32_32_42_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428983;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_43_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428971;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_44_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428996;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429057;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429127;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429134;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i12_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429141;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i13_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429148;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i14_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429155;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i15_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429162;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i16_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429173;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i17_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429186;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i18_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429198;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i19_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429210;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429064;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i20_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429222;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i21_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429234;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i22_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429246;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i23_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429261;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i24_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429272;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i25_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429280;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i26_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429296;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i27_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429311;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i28_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429326;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i29_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429337;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429071;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i30_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429352;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429078;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429085;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429092;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429099;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429106;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429113;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_45_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429120;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_46_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428662;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_46_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428664;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_46_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428694;
  wire [32:0] out_ui_plus_expr_FU_32_32_32_47_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428640;
  wire [32:0] out_ui_plus_expr_FU_32_32_32_47_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428641;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_47_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429170;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_47_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429258;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_47_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429269;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_47_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429293;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_47_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429308;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_47_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429323;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_47_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429334;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_47_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429349;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_48_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428646;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_48_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428661;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_49_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428565;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_49_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428678;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_50_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428571;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_51_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428575;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_52_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428579;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_53_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428583;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_54_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428587;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_55_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428591;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_56_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428595;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_57_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428599;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_58_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428603;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_59_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428607;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_60_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428611;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_61_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428615;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_62_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428619;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_63_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428623;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_64_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428627;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429051;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429123;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429130;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i12_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429137;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i13_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429144;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i14_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429151;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i15_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429158;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i16_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429165;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i17_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429168;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i18_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429181;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i19_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429193;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429060;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i20_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429205;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i21_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429217;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i22_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429229;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i23_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429241;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i24_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429253;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i25_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429256;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i26_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429264;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i27_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429267;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i28_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429275;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i29_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429287;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429067;
  wire [0:0] out_ui_rshift_expr_FU_64_0_64_65_i30_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429290;
  wire [0:0] out_ui_rshift_expr_FU_64_0_64_65_i31_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429303;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i32_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429306;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i33_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429318;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i34_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429321;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i35_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429329;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i36_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429332;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i37_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429344;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i38_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429347;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429074;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429081;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429088;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429095;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429102;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429109;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_65_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429116;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_66_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428648;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_66_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428651;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_66_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428653;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_66_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428654;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_66_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428658;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_66_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428660;
  wire [63:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire [31:0] out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1;
  wire s_done_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566_P0;
  wire s_done_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047_P0;
  
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0),
    .in1(out_reg_7_reg_7),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_49_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428565));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_28_reg_0_0_0_0 (.out1(out_MUX_28_reg_0_0_0_0),
    .sel(selector_MUX_28_reg_0_0_0_0),
    .in1(out_reg_5_reg_5),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_29_reg_1_0_0_0 (.out1(out_MUX_29_reg_1_0_0_0),
    .sel(selector_MUX_29_reg_1_0_0_0),
    .in1(out_ui_plus_expr_FU_64_64_64_48_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428661),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_36_reg_2_0_0_0 (.out1(out_MUX_36_reg_2_0_0_0),
    .sel(selector_MUX_36_reg_2_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_46_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428664),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_37_reg_3_0_0_0 (.out1(out_MUX_37_reg_3_0_0_0),
    .sel(selector_MUX_37_reg_3_0_0_0),
    .in1(out_reg_6_reg_6),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) UUdata_converter_FU_uu_conv_0 (.out1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in1(out_conv_out_const_0_1_64));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) UUdata_converter_FU_uu_conv_1 (.out1(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1),
    .in1(out_conv_out_const_0_1_32));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b0)) const_0 (.out1(out_const_0));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b1)) const_1 (.out1(out_const_1));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1011000000)) const_10 (.out1(out_const_10));
  constant_value #(.BITSIZE_out1(2),
    .value(2'b11)) const_11 (.out1(out_const_11));
  constant_value #(.BITSIZE_out1(8),
    .value(8'b11000000)) const_12 (.out1(out_const_12));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b110000000)) const_13 (.out1(out_const_13));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1100000000)) const_14 (.out1(out_const_14));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1101000000)) const_15 (.out1(out_const_15));
  constant_value #(.BITSIZE_out1(3),
    .value(3'b111)) const_16 (.out1(out_const_16));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b111000000)) const_17 (.out1(out_const_17));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1110000000)) const_18 (.out1(out_const_18));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1111000000)) const_19 (.out1(out_const_19));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b100000)) const_2 (.out1(out_const_2));
  constant_value #(.BITSIZE_out1(32),
    .value(32'b11111111111111111111111111111111)) const_20 (.out1(out_const_20));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1000000)) const_3 (.out1(out_const_3));
  constant_value #(.BITSIZE_out1(8),
    .value(8'b10000000)) const_4 (.out1(out_const_4));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b100000000)) const_5 (.out1(out_const_5));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1000000000)) const_6 (.out1(out_const_6));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1001000000)) const_7 (.out1(out_const_7));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b101000000)) const_8 (.out1(out_const_8));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1010000000)) const_9 (.out1(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(64)) conv_out_const_0_1_64 (.out1(out_conv_out_const_0_1_64),
    .in1(out_const_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428565 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_49_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428565),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_43_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428971));
  A_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566 (.done_port({s_done_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566_P0}),
    .out1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566),
    ._A_TREADY(_A_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566}),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID));
  UUdata_converter_FU #(.BITSIZE_in1(1024),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428567 (.out1(out_UUdata_converter_FU_8_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428567),
    .in1(out_reg_8_reg_8));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428568 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428568),
    .in1(out_UUdata_converter_FU_8_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428567),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428569 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428569),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429051),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428570 (.out1(out_ui_bit_ior_expr_FU_0_64_64_39_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428570),
    .in1(out_ui_bit_and_expr_FU_32_0_32_36_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428568),
    .in2(out_ui_lshift_expr_FU_64_0_64_45_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429057));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(7),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428571 (.out1(out_ui_rshift_expr_FU_64_0_64_50_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428571),
    .in1(out_reg_8_reg_8),
    .in2(out_const_3));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428572 (.out1(out_UUdata_converter_FU_9_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428572),
    .in1(out_ui_rshift_expr_FU_64_0_64_50_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428571));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428573 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428573),
    .in1(out_UUdata_converter_FU_9_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428572),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428574 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428574),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429060),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(8),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428575 (.out1(out_ui_rshift_expr_FU_64_0_64_51_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428575),
    .in1(out_reg_8_reg_8),
    .in2(out_const_4));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428576 (.out1(out_UUdata_converter_FU_10_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428576),
    .in1(out_ui_rshift_expr_FU_64_0_64_51_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428575));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428577 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428577),
    .in1(out_UUdata_converter_FU_10_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428576),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428578 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428578),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429067),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(8),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428579 (.out1(out_ui_rshift_expr_FU_64_0_64_52_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428579),
    .in1(out_reg_8_reg_8),
    .in2(out_const_12));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428580 (.out1(out_UUdata_converter_FU_11_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428580),
    .in1(out_ui_rshift_expr_FU_64_0_64_52_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428579));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428581 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428581),
    .in1(out_UUdata_converter_FU_11_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428580),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428582 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428582),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429074),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428583 (.out1(out_ui_rshift_expr_FU_64_0_64_53_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428583),
    .in1(out_reg_8_reg_8),
    .in2(out_const_5));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428584 (.out1(out_UUdata_converter_FU_12_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428584),
    .in1(out_ui_rshift_expr_FU_64_0_64_53_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428583));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428585 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428585),
    .in1(out_UUdata_converter_FU_12_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428584),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428586 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428586),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429081),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428587 (.out1(out_ui_rshift_expr_FU_64_0_64_54_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428587),
    .in1(out_reg_8_reg_8),
    .in2(out_const_8));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428588 (.out1(out_UUdata_converter_FU_13_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428588),
    .in1(out_ui_rshift_expr_FU_64_0_64_54_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428587));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428589 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428589),
    .in1(out_UUdata_converter_FU_13_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428588),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428590 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428590),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429088),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428591 (.out1(out_ui_rshift_expr_FU_64_0_64_55_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428591),
    .in1(out_reg_8_reg_8),
    .in2(out_const_13));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428592 (.out1(out_UUdata_converter_FU_14_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428592),
    .in1(out_ui_rshift_expr_FU_64_0_64_55_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428591));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428593 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428593),
    .in1(out_UUdata_converter_FU_14_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428592),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428594 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428594),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429095),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428595 (.out1(out_ui_rshift_expr_FU_64_0_64_56_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428595),
    .in1(out_reg_8_reg_8),
    .in2(out_const_17));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428596 (.out1(out_UUdata_converter_FU_15_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428596),
    .in1(out_ui_rshift_expr_FU_64_0_64_56_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428595));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428597 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428597),
    .in1(out_UUdata_converter_FU_15_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428596),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428598 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428598),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429102),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428599 (.out1(out_ui_rshift_expr_FU_64_0_64_57_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428599),
    .in1(out_reg_8_reg_8),
    .in2(out_const_6));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428600 (.out1(out_UUdata_converter_FU_16_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428600),
    .in1(out_ui_rshift_expr_FU_64_0_64_57_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428599));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428601 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428601),
    .in1(out_UUdata_converter_FU_16_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428600),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428602 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428602),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429109),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428603 (.out1(out_ui_rshift_expr_FU_64_0_64_58_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428603),
    .in1(out_reg_8_reg_8),
    .in2(out_const_7));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428604 (.out1(out_UUdata_converter_FU_17_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428604),
    .in1(out_ui_rshift_expr_FU_64_0_64_58_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428603));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428605 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428605),
    .in1(out_UUdata_converter_FU_17_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428604),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428606 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428606),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429116),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428607 (.out1(out_ui_rshift_expr_FU_64_0_64_59_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428607),
    .in1(out_reg_8_reg_8),
    .in2(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428608 (.out1(out_UUdata_converter_FU_18_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428608),
    .in1(out_ui_rshift_expr_FU_64_0_64_59_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428607));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428609 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428609),
    .in1(out_UUdata_converter_FU_18_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428608),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428610 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428610),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429123),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428611 (.out1(out_ui_rshift_expr_FU_64_0_64_60_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428611),
    .in1(out_reg_8_reg_8),
    .in2(out_const_10));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428612 (.out1(out_UUdata_converter_FU_19_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428612),
    .in1(out_ui_rshift_expr_FU_64_0_64_60_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428611));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428613 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428613),
    .in1(out_UUdata_converter_FU_19_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428612),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428614 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428614),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429130),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428615 (.out1(out_ui_rshift_expr_FU_64_0_64_61_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428615),
    .in1(out_reg_8_reg_8),
    .in2(out_const_14));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428616 (.out1(out_UUdata_converter_FU_20_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428616),
    .in1(out_ui_rshift_expr_FU_64_0_64_61_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428615));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428617 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i12_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428617),
    .in1(out_UUdata_converter_FU_20_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428616),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428618 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i12_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428618),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i12_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429137),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428619 (.out1(out_ui_rshift_expr_FU_64_0_64_62_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428619),
    .in1(out_reg_8_reg_8),
    .in2(out_const_15));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428620 (.out1(out_UUdata_converter_FU_21_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428620),
    .in1(out_ui_rshift_expr_FU_64_0_64_62_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428619));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428621 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i13_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428621),
    .in1(out_UUdata_converter_FU_21_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428620),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428622 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i13_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428622),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i13_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429144),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428623 (.out1(out_ui_rshift_expr_FU_64_0_64_63_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428623),
    .in1(out_reg_8_reg_8),
    .in2(out_const_18));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428624 (.out1(out_UUdata_converter_FU_22_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428624),
    .in1(out_ui_rshift_expr_FU_64_0_64_63_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428623));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428625 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i14_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428625),
    .in1(out_UUdata_converter_FU_22_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428624),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428626 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i14_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428626),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i14_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429151),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428627 (.out1(out_ui_rshift_expr_FU_64_0_64_64_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428627),
    .in1(out_reg_8_reg_8),
    .in2(out_const_19));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428628 (.out1(out_UUdata_converter_FU_23_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428628),
    .in1(out_ui_rshift_expr_FU_64_0_64_64_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428627));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428629 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i15_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428629),
    .in1(out_UUdata_converter_FU_23_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428628),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428630 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i15_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428630),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i15_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429158),
    .in2(out_const_20));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428631 (.out1(out_ui_bit_ior_concat_expr_FU_38_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428631),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i16_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429173),
    .in2(out_ui_bit_and_expr_FU_32_0_32_37_i16_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429176),
    .in3(out_const_2));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428632 (.out1(out_ui_bit_ior_concat_expr_FU_38_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428632),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i17_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429186),
    .in2(out_ui_bit_and_expr_FU_32_0_32_37_i17_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429189),
    .in3(out_const_2));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428633 (.out1(out_ui_bit_ior_concat_expr_FU_38_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428633),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i18_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429198),
    .in2(out_ui_bit_and_expr_FU_32_0_32_37_i18_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429201),
    .in3(out_const_2));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428634 (.out1(out_ui_bit_ior_concat_expr_FU_38_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428634),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i19_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429210),
    .in2(out_ui_bit_and_expr_FU_32_0_32_37_i19_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429213),
    .in3(out_const_2));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428635 (.out1(out_ui_bit_ior_concat_expr_FU_38_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428635),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i20_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429222),
    .in2(out_ui_bit_and_expr_FU_32_0_32_37_i20_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429225),
    .in3(out_const_2));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428636 (.out1(out_ui_bit_ior_concat_expr_FU_38_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428636),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i21_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429234),
    .in2(out_ui_bit_and_expr_FU_32_0_32_37_i21_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429237),
    .in3(out_const_2));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428637 (.out1(out_ui_bit_ior_concat_expr_FU_38_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428637),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i22_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429246),
    .in2(out_ui_bit_and_expr_FU_32_0_32_37_i22_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429249),
    .in3(out_const_2));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(33)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428640 (.out1(out_ui_plus_expr_FU_32_32_32_47_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428640),
    .in1(out_ui_bit_and_expr_FU_32_0_32_36_i13_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428621),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428593));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(33)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428641 (.out1(out_ui_plus_expr_FU_32_32_32_47_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428641),
    .in1(out_ui_bit_and_expr_FU_32_0_32_36_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428597),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i15_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428629));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428644 (.out1(out_ui_bit_ior_concat_expr_FU_38_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428644),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i25_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429280),
    .in2(out_ui_bit_and_expr_FU_32_0_32_37_i23_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429283),
    .in3(out_const_2));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428646 (.out1(out_ui_plus_expr_FU_64_64_64_48_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428646),
    .in1(out_ui_bit_ior_concat_expr_FU_38_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428633),
    .in2(out_ui_bit_ior_concat_expr_FU_38_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428634));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(32),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428648 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428648),
    .in1(out_ui_bit_ior_concat_expr_FU_38_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428637),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428589),
    .in3(out_ui_bit_and_expr_FU_32_0_32_36_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428573));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428649 (.out1(out_ui_bit_ior_concat_expr_FU_38_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428649),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i26_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429296),
    .in2(out_ui_bit_and_expr_FU_32_0_32_37_i24_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429299),
    .in3(out_const_2));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428650 (.out1(out_ui_bit_ior_concat_expr_FU_38_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428650),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i27_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429311),
    .in2(out_ui_bit_and_expr_FU_32_0_32_37_i25_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429314),
    .in3(out_const_2));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428651 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428651),
    .in1(out_ui_bit_and_expr_FU_32_0_32_36_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428601),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428605),
    .in3(out_ui_bit_ior_concat_expr_FU_38_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428644));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428653 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428653),
    .in1(out_ui_bit_ior_concat_expr_FU_38_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428631),
    .in2(out_ui_bit_ior_concat_expr_FU_38_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428632),
    .in3(out_ui_plus_expr_FU_64_64_64_48_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428646));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428654 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428654),
    .in1(out_ui_bit_ior_concat_expr_FU_38_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428635),
    .in2(out_ui_bit_ior_concat_expr_FU_38_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428636),
    .in3(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428648));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428656 (.out1(out_ui_bit_ior_concat_expr_FU_38_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428656),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i29_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429337),
    .in2(out_ui_bit_and_expr_FU_32_0_32_37_i26_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429340),
    .in3(out_const_2));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428658 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428658),
    .in1(out_ui_bit_ior_concat_expr_FU_38_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428649),
    .in2(out_ui_bit_ior_concat_expr_FU_38_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428650),
    .in3(out_ui_bit_ior_concat_expr_FU_38_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428656));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428659 (.out1(out_ui_bit_ior_concat_expr_FU_38_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428659),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i30_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429352),
    .in2(out_reg_12_reg_12),
    .in3(out_const_2));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428660 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428660),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428653),
    .in2(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428654),
    .in3(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428658));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428661 (.out1(out_ui_plus_expr_FU_64_64_64_48_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428661),
    .in1(out_reg_13_reg_13),
    .in2(out_reg_14_reg_14));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428662 (.out1(out_ui_plus_expr_FU_32_0_32_46_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428662),
    .in1(out_reg_3_reg_3),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428664 (.out1(out_ui_plus_expr_FU_32_0_32_46_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428664),
    .in1(out_reg_2_reg_2),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428665 (.out1(out_UUdata_converter_FU_24_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428665),
    .in1(out_ui_eq_expr_FU_32_32_32_42_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428983));
  ui_cond_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_in3(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428666 (.out1(out_ui_cond_expr_FU_1_1_1_1_40_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428666),
    .in1(out_truth_and_expr_FU_1_0_1_35_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428989),
    .in2(out_const_1),
    .in3(out_UUdata_converter_FU_24_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428665));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667 (.out1(out_read_cond_FU_25_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667),
    .in1(out_reg_10_reg_10));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428678 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_49_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428678),
    .in1(in_port_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_44_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428996));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428694 (.out1(out_ui_plus_expr_FU_32_0_32_46_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428694),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428949 (.out1(out_UUdata_converter_FU_27_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428949),
    .in1(out_ui_eq_expr_FU_32_0_32_41_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428993));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950 (.out1(out_read_cond_FU_28_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950),
    .in1(out_UUdata_converter_FU_27_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428949));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953 (.out1(out_read_cond_FU_34_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953),
    .in1(out_reg_9_reg_9));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(3),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428971 (.out1(out_ui_lshift_expr_FU_32_0_32_43_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428971),
    .in1(out_reg_2_reg_2),
    .in2(out_const_16));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428980 (.out1(out_ui_eq_expr_FU_32_32_32_42_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428980),
    .in1(out_ui_plus_expr_FU_32_0_32_46_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428662),
    .in2(in_port_len));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428983 (.out1(out_ui_eq_expr_FU_32_32_32_42_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428983),
    .in1(out_ui_plus_expr_FU_32_0_32_46_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428664),
    .in2(in_port_loop_count));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428989 (.out1(out_truth_and_expr_FU_1_0_1_35_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428989),
    .in1(out_truth_and_expr_FU_1_0_1_35_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429365),
    .in2(out_const_1));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428993 (.out1(out_ui_eq_expr_FU_32_0_32_41_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428993),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428996 (.out1(out_ui_lshift_expr_FU_32_0_32_44_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428996),
    .in1(out_reg_0_reg_0),
    .in2(out_const_11));
  out_bambu_artificial_ParmMgr_Write_axis_modgen #(.BITSIZE_in1(7),
    .BITSIZE_in2(64),
    .BITSIZE_in3(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047 (.done_port({s_done_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047_P0}),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047}),
    .in1(out_const_3),
    .in2(out_reg_15_reg_15),
    .in3(out_reg_4_reg_4),
    ._out_TREADY(_out_TREADY));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429051 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429051),
    .in1(out_UUdata_converter_FU_8_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428567),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429057 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429057),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428569),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429060 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429060),
    .in1(out_UUdata_converter_FU_9_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428572),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429064 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429064),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428574),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429067 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429067),
    .in1(out_UUdata_converter_FU_10_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428576),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429071 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429071),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428578),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429074 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429074),
    .in1(out_UUdata_converter_FU_11_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428580),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429078 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429078),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428582),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429081 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429081),
    .in1(out_UUdata_converter_FU_12_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428584),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429085 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429085),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428586),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429088 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429088),
    .in1(out_UUdata_converter_FU_13_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428588),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429092 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429092),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428590),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429095 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429095),
    .in1(out_UUdata_converter_FU_14_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428592),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429099 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429099),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428594),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429102 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429102),
    .in1(out_UUdata_converter_FU_15_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428596),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429106 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429106),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428598),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429109 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429109),
    .in1(out_UUdata_converter_FU_16_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428600),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429113 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429113),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428602),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429116 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429116),
    .in1(out_UUdata_converter_FU_17_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428604),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429120 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429120),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428606),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429123 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429123),
    .in1(out_UUdata_converter_FU_18_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428608),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429127 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429127),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428610),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429130 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429130),
    .in1(out_UUdata_converter_FU_19_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428612),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429134 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429134),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428614),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429137 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i12_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429137),
    .in1(out_UUdata_converter_FU_20_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428616),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429141 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i12_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429141),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i12_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428618),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429144 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i13_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429144),
    .in1(out_UUdata_converter_FU_21_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428620),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429148 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i13_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429148),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i13_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428622),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429151 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i14_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429151),
    .in1(out_UUdata_converter_FU_22_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428624),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429155 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i14_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429155),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i14_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428626),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429158 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i15_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429158),
    .in1(out_UUdata_converter_FU_23_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428628),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429162 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i15_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429162),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i15_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428630),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429165 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i16_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429165),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429134),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429168 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i17_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429168),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_39_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428570),
    .in2(out_const_2));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429170 (.out1(out_ui_plus_expr_FU_32_32_32_47_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429170),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i16_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429165),
    .in2(out_ui_rshift_expr_FU_64_0_64_65_i17_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429168));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429173 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i16_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429173),
    .in1(out_ui_plus_expr_FU_32_32_32_47_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429170),
    .in2(out_const_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429176 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i16_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429176),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_39_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428570),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429181 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i18_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429181),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429071),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429186 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i17_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429186),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i18_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429181),
    .in2(out_const_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429189 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i17_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429189),
    .in1(out_ui_bit_and_expr_FU_32_0_32_36_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428613),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429193 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i19_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429193),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429120),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429198 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i18_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429198),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i19_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429193),
    .in2(out_const_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429201 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i18_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429201),
    .in1(out_ui_bit_and_expr_FU_32_0_32_36_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428585),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429205 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i20_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429205),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429099),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429210 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i19_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429210),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i20_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429205),
    .in2(out_const_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429213 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i19_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429213),
    .in1(out_ui_bit_and_expr_FU_32_0_32_36_i12_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428617),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429217 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i21_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429217),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429127),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429222 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i20_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429222),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i21_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429217),
    .in2(out_const_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429225 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i20_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429225),
    .in1(out_ui_bit_and_expr_FU_32_0_32_36_i14_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428625),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429229 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i22_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429229),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i15_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429162),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429234 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i21_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429234),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i22_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429229),
    .in2(out_const_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429237 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i21_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429237),
    .in1(out_ui_bit_and_expr_FU_32_0_32_36_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428577),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429241 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i23_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429241),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i14_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429155),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429246 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i22_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429246),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i23_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429241),
    .in2(out_const_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429249 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i22_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429249),
    .in1(out_ui_bit_and_expr_FU_32_0_32_36_i10_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428609),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429253 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i24_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429253),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429113),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429256 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i25_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429256),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i12_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429141),
    .in2(out_const_2));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429258 (.out1(out_ui_plus_expr_FU_32_32_32_47_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429258),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i24_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429253),
    .in2(out_ui_rshift_expr_FU_64_0_64_65_i25_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429256));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429261 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i23_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429261),
    .in1(out_ui_plus_expr_FU_32_32_32_47_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429258),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429264 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i26_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429264),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429064),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429267 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i27_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429267),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i13_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429148),
    .in2(out_const_2));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429269 (.out1(out_ui_plus_expr_FU_32_32_32_47_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429269),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i26_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429264),
    .in2(out_ui_rshift_expr_FU_64_0_64_65_i27_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429267));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429272 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i24_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429272),
    .in1(out_ui_plus_expr_FU_32_32_32_47_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429269),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429275 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i28_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429275),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429078),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429280 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i25_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429280),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i28_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429275),
    .in2(out_const_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429283 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i23_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429283),
    .in1(out_ui_bit_and_expr_FU_32_0_32_36_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428581),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429287 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i29_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429287),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i23_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429261),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(33),
    .BITSIZE_in2(6),
    .BITSIZE_out1(1),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429290 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i30_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429290),
    .in1(out_ui_plus_expr_FU_32_32_32_47_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428640),
    .in2(out_const_2));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429293 (.out1(out_ui_plus_expr_FU_32_32_32_47_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429293),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i29_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429287),
    .in2(out_ui_rshift_expr_FU_64_0_64_65_i30_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429290));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429296 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i26_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429296),
    .in1(out_ui_plus_expr_FU_32_32_32_47_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429293),
    .in2(out_const_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(33),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429299 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i24_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429299),
    .in1(out_ui_plus_expr_FU_32_32_32_47_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428640),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(33),
    .BITSIZE_in2(6),
    .BITSIZE_out1(1),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429303 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i31_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429303),
    .in1(out_ui_plus_expr_FU_32_32_32_47_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428641),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429306 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i32_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429306),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i24_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429272),
    .in2(out_const_2));
  ui_plus_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429308 (.out1(out_ui_plus_expr_FU_32_32_32_47_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429308),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i31_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429303),
    .in2(out_ui_rshift_expr_FU_64_0_64_65_i32_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429306));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429311 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i27_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429311),
    .in1(out_ui_plus_expr_FU_32_32_32_47_i6_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429308),
    .in2(out_const_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(33),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429314 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i25_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429314),
    .in1(out_ui_plus_expr_FU_32_32_32_47_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428641),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429318 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i33_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429318),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429106),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429321 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i34_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429321),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429092),
    .in2(out_const_2));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429323 (.out1(out_ui_plus_expr_FU_32_32_32_47_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429323),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i33_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429318),
    .in2(out_ui_rshift_expr_FU_64_0_64_65_i34_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429321));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429326 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i28_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429326),
    .in1(out_ui_plus_expr_FU_32_32_32_47_i7_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429323),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429329 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i35_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429329),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428651),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429332 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i36_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429332),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i28_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429326),
    .in2(out_const_2));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429334 (.out1(out_ui_plus_expr_FU_32_32_32_47_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429334),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i35_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429329),
    .in2(out_ui_rshift_expr_FU_64_0_64_65_i36_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429332));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429337 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i29_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429337),
    .in1(out_ui_plus_expr_FU_32_32_32_47_i8_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429334),
    .in2(out_const_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429340 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i26_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429340),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428651),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429344 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i37_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429344),
    .in1(out_reg_1_reg_1),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429347 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i38_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429347),
    .in1(out_ui_lshift_expr_FU_64_0_64_45_i4_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429085),
    .in2(out_const_2));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429349 (.out1(out_ui_plus_expr_FU_32_32_32_47_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429349),
    .in1(out_reg_11_reg_11),
    .in2(out_ui_rshift_expr_FU_64_0_64_65_i38_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429347));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429352 (.out1(out_ui_lshift_expr_FU_64_0_64_45_i30_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429352),
    .in1(out_ui_plus_expr_FU_32_32_32_47_i9_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429349),
    .in2(out_const_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429355 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i27_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429355),
    .in1(out_reg_1_reg_1),
    .in2(out_const_20));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429365 (.out1(out_truth_and_expr_FU_1_0_1_35_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429365),
    .in1(out_ui_eq_expr_FU_32_32_32_42_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428980),
    .in2(out_const_1));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_28_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_29_reg_1_0_0_0),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_10 (.out1(out_reg_10_reg_10),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_cond_expr_FU_1_1_1_1_40_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428666),
    .wenable(wrenable_reg_10));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i37_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429344),
    .wenable(wrenable_reg_11));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_12 (.out1(out_reg_12_reg_12),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i27_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429355),
    .wenable(wrenable_reg_12));
  register_STD #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_13 (.out1(out_reg_13_reg_13),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_bit_ior_concat_expr_FU_38_i11_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428659),
    .wenable(wrenable_reg_13));
  register_STD #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_14 (.out1(out_reg_14_reg_14),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_66_i5_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428660),
    .wenable(wrenable_reg_14));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_15 (.out1(out_reg_15_reg_15),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_48_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428661),
    .wenable(wrenable_reg_15));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_36_reg_2_0_0_0),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_37_reg_3_0_0_0),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_49_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428678),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_46_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428694),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_46_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428662),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_49_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428565),
    .wenable(wrenable_reg_7));
  register_SE #(.BITSIZE_in1(1024),
    .BITSIZE_out1(1024)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566),
    .wenable(wrenable_reg_8));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_24_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428665),
    .wenable(wrenable_reg_9));
  // io-signal post fix
  assign OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667 = out_read_cond_FU_25_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667;
  assign OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950 = out_read_cond_FU_28_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950;
  assign OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953 = out_read_cond_FU_34_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953;
  assign OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566 = s_done_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566_P0;
  assign OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047 = s_done_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047_P0;

endmodule

// FSM based controller description for _Z4vsumPK6ac_intILi1024ELb0EEPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z4vsumPK6ac_intILi1024ELb0EEPxjj(done_port,
  selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566,
  selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0,
  selector_MUX_28_reg_0_0_0_0,
  selector_MUX_29_reg_1_0_0_0,
  selector_MUX_36_reg_2_0_0_0,
  selector_MUX_37_reg_3_0_0_0,
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
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667,
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950,
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953,
  OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566,
  OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667;
  input OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950;
  input OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953;
  input OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  input OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  output selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0;
  output selector_MUX_28_reg_0_0_0_0;
  output selector_MUX_29_reg_1_0_0_0;
  output selector_MUX_36_reg_2_0_0_0;
  output selector_MUX_37_reg_3_0_0_0;
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
  parameter [3:0] S_4 = 4'd4,
    S_9 = 4'd9,
    S_0 = 4'd0,
    S_1 = 4'd1,
    S_2 = 4'd2,
    S_3 = 4'd3,
    S_6 = 4'd6,
    S_7 = 4'd7,
    S_5 = 4'd5,
    S_8 = 4'd8;
  reg [3:0] _present_state=S_4, _next_state;
  reg done_port;
  reg selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  reg selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0;
  reg selector_MUX_28_reg_0_0_0_0;
  reg selector_MUX_29_reg_1_0_0_0;
  reg selector_MUX_36_reg_2_0_0_0;
  reg selector_MUX_37_reg_3_0_0_0;
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
    if (reset == 1'b0) _present_state <= S_4;
    else _present_state <= _next_state;
  
  always @(*)
  begin
    done_port = 1'b0;
    selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566 = 1'b0;
    selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0 = 1'b0;
    selector_MUX_28_reg_0_0_0_0 = 1'b0;
    selector_MUX_29_reg_1_0_0_0 = 1'b0;
    selector_MUX_36_reg_2_0_0_0 = 1'b0;
    selector_MUX_37_reg_3_0_0_0 = 1'b0;
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
      S_4 :
        if(start_port == 1'b1)
        begin
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950 == 1'b0)
            begin
              _next_state = S_0;
            end
          else
            begin
              _next_state = S_9;
              done_port = 1'b1;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_2 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
        end
        else
        begin
          _next_state = S_4;
        end
      S_9 :
        begin
          _next_state = S_4;
        end
      S_0 :
        begin
          selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566 = 1'b1;
          selector_MUX_36_reg_2_0_0_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_4 = 1'b1;
          wrenable_reg_5 = 1'b1;
          wrenable_reg_6 = 1'b1;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
          wrenable_reg_9 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566 == 1'b0)
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0 = 1'b1;
          wrenable_reg_8 = OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
          if (OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566 == 1'b0)
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
          wrenable_reg_13 = 1'b1;
          wrenable_reg_14 = 1'b1;
          _next_state = S_3;
        end
      S_3 :
        begin
          selector_MUX_29_reg_1_0_0_0 = 1'b1;
          selector_MUX_37_reg_3_0_0_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_15 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667 == 1'b1)
            begin
              _next_state = S_6;
              selector_MUX_29_reg_1_0_0_0 = 1'b0;
              selector_MUX_37_reg_3_0_0_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
          else
            begin
              _next_state = S_5;
            end
        end
      S_6 :
        begin
          selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047 = 1'b1;
          selector_MUX_28_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047 == 1'b0)
            begin
              _next_state = S_7;
              selector_MUX_28_reg_0_0_0_0 = 1'b0;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
          else
            begin
              _next_state = S_5;
            end
        end
      S_7 :
        begin
          selector_MUX_28_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047 == 1'b0)
            begin
              _next_state = S_7;
              selector_MUX_28_reg_0_0_0_0 = 1'b0;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
          else
            begin
              _next_state = S_5;
            end
        end
      S_5 :
        begin
          if (OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953 == 1'b0)
            begin
              _next_state = S_0;
            end
          else
            begin
              _next_state = S_8;
              done_port = 1'b1;
            end
        end
      S_8 :
        begin
          _next_state = S_4;
        end
      default :
        begin
          _next_state = S_4;
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

// Top component for _Z4vsumPK6ac_intILi1024ELb0EEPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z4vsumPK6ac_intILi1024ELb0EEPxjj(clock,
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
  input [1023:0] _A_TDATA;
  input _A_TVALID;
  input _out_TREADY;
  // OUT
  output done_port;
  output _A_TREADY;
  output [63:0] _out_TDATA;
  output _out_TVALID;
  // Component and signal declarations
  wire OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667;
  wire OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950;
  wire OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953;
  wire OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  wire OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  wire selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0;
  wire selector_MUX_28_reg_0_0_0_0;
  wire selector_MUX_29_reg_1_0_0_0;
  wire selector_MUX_36_reg_2_0_0_0;
  wire selector_MUX_37_reg_3_0_0_0;
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
  
  controller__Z4vsumPK6ac_intILi1024ELb0EEPxjj Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566(selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566),
    .selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047(selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0),
    .selector_MUX_28_reg_0_0_0_0(selector_MUX_28_reg_0_0_0_0),
    .selector_MUX_29_reg_1_0_0_0(selector_MUX_29_reg_1_0_0_0),
    .selector_MUX_36_reg_2_0_0_0(selector_MUX_36_reg_2_0_0_0),
    .selector_MUX_37_reg_3_0_0_0(selector_MUX_37_reg_3_0_0_0),
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
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953),
    .OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566(OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566),
    .OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047(OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z4vsumPK6ac_intILi1024ELb0EEPxjj Datapath_i (._A_TREADY(_A_TREADY),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428667),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428950),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428953),
    .OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566(OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566),
    .OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047(OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047),
    .clock(clock),
    .reset(reset),
    .in_port_A(A),
    .in_port_out(out),
    .in_port_loop_count(loop_count),
    .in_port_len(len),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID),
    ._out_TREADY(_out_TREADY),
    .selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566(selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566),
    .selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047(selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_429047),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_67_i0_0_0_0),
    .selector_MUX_28_reg_0_0_0_0(selector_MUX_28_reg_0_0_0_0),
    .selector_MUX_29_reg_1_0_0_0(selector_MUX_29_reg_1_0_0_0),
    .selector_MUX_36_reg_2_0_0_0(selector_MUX_36_reg_2_0_0_0),
    .selector_MUX_37_reg_3_0_0_0(selector_MUX_37_reg_3_0_0_0),
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

// Minimal interface for function: _Z4vsumPK6ac_intILi1024ELb0EEPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z4vsumPK6ac_intILi1024ELb0EEPxjj(clock,
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
  input [1023:0] A_TDATA;
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
  
  __Z4vsumPK6ac_intILi1024ELb0EEPxjj __Z4vsumPK6ac_intILi1024ELb0EEPxjj_i0 (.done_port(done_port),
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


