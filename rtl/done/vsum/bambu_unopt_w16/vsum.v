// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-03T13:32:03
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=vsum --top-rtldesign-name=vsum --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER --simulate --simulator=VERILATOR --generate-tb=/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/src/tb_vsum.cpp --tb-extra-gcc-options=-DDUT=vsum -DCFG_LOOP_COUNT=4 -DCFG_LEN=4 --tb-param-size=A:512,out:8 -DDATA_T=int64_t -DSIZE_N=64 -DBAMBU_LANES=16 --std=c++14 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include/bambu -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/vectors/n64 /users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/bambu_unopt_n64_w16_proj/vsum.cpp 
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
  selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0,
  selector_MUX_23_reg_0_0_0_0,
  selector_MUX_24_reg_1_0_0_0,
  selector_MUX_25_reg_10_0_0_0,
  selector_MUX_28_reg_2_0_0_0,
  selector_MUX_29_reg_3_0_0_0,
  selector_MUX_35_reg_9_0_0_0,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_10,
  wrenable_reg_11,
  wrenable_reg_12,
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715,
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723,
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729,
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740,
  OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566,
  OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840);
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
  input selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0;
  input selector_MUX_23_reg_0_0_0_0;
  input selector_MUX_24_reg_1_0_0_0;
  input selector_MUX_25_reg_10_0_0_0;
  input selector_MUX_28_reg_2_0_0_0;
  input selector_MUX_29_reg_3_0_0_0;
  input selector_MUX_35_reg_9_0_0_0;
  input wrenable_reg_0;
  input wrenable_reg_1;
  input wrenable_reg_10;
  input wrenable_reg_11;
  input wrenable_reg_12;
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
  output OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715;
  output OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723;
  output OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729;
  output OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740;
  output OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  output OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840;
  // Component and signal declarations
  wire [1023:0] out_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0;
  wire [31:0] out_MUX_23_reg_0_0_0_0;
  wire [63:0] out_MUX_24_reg_1_0_0_0;
  wire [31:0] out_MUX_25_reg_10_0_0_0;
  wire [31:0] out_MUX_28_reg_2_0_0_0;
  wire [31:0] out_MUX_29_reg_3_0_0_0;
  wire [63:0] out_MUX_35_reg_9_0_0_0;
  wire out_UUdata_converter_FU_18_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428725;
  wire [9:0] out_UUdata_converter_FU_22_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428685;
  wire [9:0] out_UUdata_converter_FU_23_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428648;
  wire [31:0] out_UUdata_converter_FU_24_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428679;
  wire [31:0] out_UUdata_converter_FU_25_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428641;
  wire [9:0] out_UUdata_converter_FU_26_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428618;
  wire [9:0] out_UUdata_converter_FU_27_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428669;
  wire [31:0] out_UUdata_converter_FU_28_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428606;
  wire [31:0] out_UUdata_converter_FU_29_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428662;
  wire out_UUdata_converter_FU_30_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428739;
  wire out_UUdata_converter_FU_9_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428714;
  wire out_const_0;
  wire out_const_1;
  wire [3:0] out_const_2;
  wire [5:0] out_const_3;
  wire [6:0] out_const_4;
  wire [1:0] out_const_5;
  wire [2:0] out_const_6;
  wire [6:0] out_const_7;
  wire [2:0] out_const_8;
  wire [31:0] out_const_9;
  wire [31:0] out_conv_out_const_0_1_32;
  wire [63:0] out_conv_out_const_0_1_64;
  wire out_read_cond_FU_10_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715;
  wire out_read_cond_FU_17_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723;
  wire out_read_cond_FU_19_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729;
  wire out_read_cond_FU_31_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740;
  wire [31:0] out_reg_0_reg_0;
  wire [31:0] out_reg_10_reg_10;
  wire [63:0] out_reg_11_reg_11;
  wire out_reg_12_reg_12;
  wire [63:0] out_reg_1_reg_1;
  wire [31:0] out_reg_2_reg_2;
  wire [31:0] out_reg_3_reg_3;
  wire [31:0] out_reg_4_reg_4;
  wire [1023:0] out_reg_5_reg_5;
  wire [31:0] out_reg_6_reg_6;
  wire [31:0] out_reg_7_reg_7;
  wire [31:0] out_reg_8_reg_8;
  wire [63:0] out_reg_9_reg_9;
  wire out_truth_and_expr_FU_1_0_1_32_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428781;
  wire out_truth_and_expr_FU_1_0_1_32_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428849;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_33_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428602;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_33_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428676;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_34_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428864;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_34_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428877;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_35_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428598;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_35_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428655;
  wire [9:0] out_ui_bit_ior_expr_FU_16_0_16_36_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428623;
  wire [9:0] out_ui_bit_ior_expr_FU_16_0_16_37_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428652;
  wire [9:0] out_ui_bit_ior_expr_FU_16_0_16_38_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428673;
  wire [0:0] out_ui_cond_expr_FU_1_1_1_1_39_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428728;
  wire out_ui_eq_expr_FU_32_0_32_40_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428769;
  wire out_ui_eq_expr_FU_32_0_32_41_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428790;
  wire out_ui_eq_expr_FU_32_32_32_42_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428772;
  wire out_ui_eq_expr_FU_32_32_32_42_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428775;
  wire [9:0] out_ui_lshift_expr_FU_32_0_32_43_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428627;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_44_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428758;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_45_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428783;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_46_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428889;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_47_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428637;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_47_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428659;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_48_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428861;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_48_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428874;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_49_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428693;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_49_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428699;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_49_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428705;
  wire [30:0] out_ui_plus_expr_FU_32_0_32_50_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428886;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_51_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428584;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_52_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428565;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_52_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428577;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_53_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428882;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_53_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428892;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_54_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428854;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_54_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428869;
  wire [31:0] out_ui_rshift_expr_FU_64_64_64_55_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428610;
  wire [31:0] out_ui_rshift_expr_FU_64_64_64_55_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428644;
  wire [31:0] out_ui_rshift_expr_FU_64_64_64_55_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428665;
  wire [31:0] out_ui_rshift_expr_FU_64_64_64_55_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428682;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_56_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428590;
  wire [63:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire [31:0] out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1;
  wire s_done_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566_P0;
  wire s_done_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840_P0;
  
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0),
    .in1(out_reg_8_reg_8),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_52_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428565));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_23_reg_0_0_0_0 (.out1(out_MUX_23_reg_0_0_0_0),
    .sel(selector_MUX_23_reg_0_0_0_0),
    .in1(out_reg_6_reg_6),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_24_reg_1_0_0_0 (.out1(out_MUX_24_reg_1_0_0_0),
    .sel(selector_MUX_24_reg_1_0_0_0),
    .in1(out_ui_plus_expr_FU_64_64_64_51_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428584),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_25_reg_10_0_0_0 (.out1(out_MUX_25_reg_10_0_0_0),
    .sel(selector_MUX_25_reg_10_0_0_0),
    .in1(out_ui_lshift_expr_FU_32_0_32_46_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428889),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_28_reg_2_0_0_0 (.out1(out_MUX_28_reg_2_0_0_0),
    .sel(selector_MUX_28_reg_2_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_49_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428693),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_29_reg_3_0_0_0 (.out1(out_MUX_29_reg_3_0_0_0),
    .sel(selector_MUX_29_reg_3_0_0_0),
    .in1(out_reg_7_reg_7),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_35_reg_9_0_0_0 (.out1(out_MUX_35_reg_9_0_0_0),
    .sel(selector_MUX_35_reg_9_0_0_0),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_56_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428590),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
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
  constant_value #(.BITSIZE_out1(4),
    .value(4'b1000)) const_2 (.out1(out_const_2));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b100000)) const_3 (.out1(out_const_3));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1000000)) const_4 (.out1(out_const_4));
  constant_value #(.BITSIZE_out1(2),
    .value(2'b11)) const_5 (.out1(out_const_5));
  constant_value #(.BITSIZE_out1(3),
    .value(3'b110)) const_6 (.out1(out_const_6));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1100000)) const_7 (.out1(out_const_7));
  constant_value #(.BITSIZE_out1(3),
    .value(3'b111)) const_8 (.out1(out_const_8));
  constant_value #(.BITSIZE_out1(32),
    .value(32'b11111111111111111111111111111111)) const_9 (.out1(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(64)) conv_out_const_0_1_64 (.out1(out_conv_out_const_0_1_64),
    .in1(out_const_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428565 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_52_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428565),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_44_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428758));
  A_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566 (.done_port({s_done_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566_P0}),
    .out1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566),
    ._A_TREADY(_A_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566}),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428577 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_52_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428577),
    .in1(in_port_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_45_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428783));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428584 (.out1(out_ui_plus_expr_FU_64_64_64_51_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428584),
    .in1(out_reg_9_reg_9),
    .in2(out_reg_1_reg_1));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428590 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_56_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428590),
    .in1(out_ui_bit_ior_concat_expr_FU_35_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428598),
    .in2(out_ui_bit_ior_concat_expr_FU_35_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428655),
    .in3(out_reg_9_reg_9));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428598 (.out1(out_ui_bit_ior_concat_expr_FU_35_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428598),
    .in1(out_ui_lshift_expr_FU_64_0_64_48_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428861),
    .in2(out_ui_bit_and_expr_FU_32_0_32_34_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428864),
    .in3(out_const_3));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428602 (.out1(out_ui_bit_and_expr_FU_32_0_32_33_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428602),
    .in1(out_UUdata_converter_FU_28_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428606),
    .in2(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428606 (.out1(out_UUdata_converter_FU_28_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428606),
    .in1(out_ui_rshift_expr_FU_64_64_64_55_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428610));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428610 (.out1(out_ui_rshift_expr_FU_64_64_64_55_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428610),
    .in1(out_reg_5_reg_5),
    .in2(out_UUdata_converter_FU_26_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428618));
  UUdata_converter_FU #(.BITSIZE_in1(10),
    .BITSIZE_out1(10)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428618 (.out1(out_UUdata_converter_FU_26_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428618),
    .in1(out_ui_bit_ior_expr_FU_16_0_16_36_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428623));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(10),
    .BITSIZE_in2(7),
    .BITSIZE_out1(10)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428623 (.out1(out_ui_bit_ior_expr_FU_16_0_16_36_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428623),
    .in1(out_ui_lshift_expr_FU_32_0_32_43_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428627),
    .in2(out_const_4));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(3),
    .BITSIZE_out1(10),
    .PRECISION(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428627 (.out1(out_ui_lshift_expr_FU_32_0_32_43_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428627),
    .in1(out_reg_10_reg_10),
    .in2(out_const_6));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428637 (.out1(out_ui_lshift_expr_FU_64_0_64_47_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428637),
    .in1(out_UUdata_converter_FU_25_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428641),
    .in2(out_const_3));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428641 (.out1(out_UUdata_converter_FU_25_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428641),
    .in1(out_ui_rshift_expr_FU_64_64_64_55_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428644));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428644 (.out1(out_ui_rshift_expr_FU_64_64_64_55_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428644),
    .in1(out_reg_5_reg_5),
    .in2(out_UUdata_converter_FU_23_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428648));
  UUdata_converter_FU #(.BITSIZE_in1(10),
    .BITSIZE_out1(10)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428648 (.out1(out_UUdata_converter_FU_23_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428648),
    .in1(out_ui_bit_ior_expr_FU_16_0_16_37_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428652));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(10),
    .BITSIZE_in2(6),
    .BITSIZE_out1(10)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428652 (.out1(out_ui_bit_ior_expr_FU_16_0_16_37_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428652),
    .in1(out_ui_lshift_expr_FU_32_0_32_43_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428627),
    .in2(out_const_3));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428655 (.out1(out_ui_bit_ior_concat_expr_FU_35_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428655),
    .in1(out_ui_lshift_expr_FU_64_0_64_48_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428874),
    .in2(out_ui_bit_and_expr_FU_32_0_32_34_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428877),
    .in3(out_const_3));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428659 (.out1(out_ui_lshift_expr_FU_64_0_64_47_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428659),
    .in1(out_UUdata_converter_FU_29_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428662),
    .in2(out_const_3));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428662 (.out1(out_UUdata_converter_FU_29_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428662),
    .in1(out_ui_rshift_expr_FU_64_64_64_55_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428665));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428665 (.out1(out_ui_rshift_expr_FU_64_64_64_55_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428665),
    .in1(out_reg_5_reg_5),
    .in2(out_UUdata_converter_FU_27_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428669));
  UUdata_converter_FU #(.BITSIZE_in1(10),
    .BITSIZE_out1(10)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428669 (.out1(out_UUdata_converter_FU_27_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428669),
    .in1(out_ui_bit_ior_expr_FU_16_0_16_38_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428673));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(10),
    .BITSIZE_in2(7),
    .BITSIZE_out1(10)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428673 (.out1(out_ui_bit_ior_expr_FU_16_0_16_38_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428673),
    .in1(out_ui_lshift_expr_FU_32_0_32_43_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428627),
    .in2(out_const_7));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428676 (.out1(out_ui_bit_and_expr_FU_32_0_32_33_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428676),
    .in1(out_UUdata_converter_FU_24_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428679),
    .in2(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428679 (.out1(out_UUdata_converter_FU_24_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428679),
    .in1(out_ui_rshift_expr_FU_64_64_64_55_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428682));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428682 (.out1(out_ui_rshift_expr_FU_64_64_64_55_i3_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428682),
    .in1(out_reg_5_reg_5),
    .in2(out_UUdata_converter_FU_22_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428685));
  UUdata_converter_FU #(.BITSIZE_in1(10),
    .BITSIZE_out1(10)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428685 (.out1(out_UUdata_converter_FU_22_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428685),
    .in1(out_ui_lshift_expr_FU_32_0_32_43_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428627));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428693 (.out1(out_ui_plus_expr_FU_32_0_32_49_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428693),
    .in1(out_reg_2_reg_2),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428699 (.out1(out_ui_plus_expr_FU_32_0_32_49_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428699),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428705 (.out1(out_ui_plus_expr_FU_32_0_32_49_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428705),
    .in1(out_reg_3_reg_3),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428714 (.out1(out_UUdata_converter_FU_9_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428714),
    .in1(out_ui_eq_expr_FU_32_0_32_40_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428769));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715 (.out1(out_read_cond_FU_10_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715),
    .in1(out_UUdata_converter_FU_9_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428714));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723 (.out1(out_read_cond_FU_17_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723),
    .in1(out_reg_12_reg_12));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428725 (.out1(out_UUdata_converter_FU_18_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428725),
    .in1(out_ui_eq_expr_FU_32_32_32_42_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428775));
  ui_cond_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_in3(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428728 (.out1(out_ui_cond_expr_FU_1_1_1_1_39_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428728),
    .in1(out_truth_and_expr_FU_1_0_1_32_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428781),
    .in2(out_const_1),
    .in3(out_UUdata_converter_FU_18_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428725));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729 (.out1(out_read_cond_FU_19_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729),
    .in1(out_ui_cond_expr_FU_1_1_1_1_39_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428728));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428739 (.out1(out_UUdata_converter_FU_30_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428739),
    .in1(out_ui_eq_expr_FU_32_0_32_41_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428790));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740 (.out1(out_read_cond_FU_31_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740),
    .in1(out_UUdata_converter_FU_30_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428739));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(3),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428758 (.out1(out_ui_lshift_expr_FU_32_0_32_44_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428758),
    .in1(out_reg_2_reg_2),
    .in2(out_const_8));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428769 (.out1(out_ui_eq_expr_FU_32_0_32_40_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428769),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428772 (.out1(out_ui_eq_expr_FU_32_32_32_42_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428772),
    .in1(out_reg_7_reg_7),
    .in2(in_port_len));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428775 (.out1(out_ui_eq_expr_FU_32_32_32_42_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428775),
    .in1(out_reg_2_reg_2),
    .in2(in_port_loop_count));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428781 (.out1(out_truth_and_expr_FU_1_0_1_32_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428781),
    .in1(out_truth_and_expr_FU_1_0_1_32_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428849),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428783 (.out1(out_ui_lshift_expr_FU_32_0_32_45_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428783),
    .in1(out_reg_0_reg_0),
    .in2(out_const_5));
  ui_eq_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(4),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428790 (.out1(out_ui_eq_expr_FU_32_0_32_41_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428790),
    .in1(out_ui_rshift_expr_FU_32_0_32_53_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428892),
    .in2(out_const_2));
  out_bambu_artificial_ParmMgr_Write_axis_modgen #(.BITSIZE_in1(7),
    .BITSIZE_in2(64),
    .BITSIZE_in3(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840 (.done_port({s_done_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840_P0}),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840}),
    .in1(out_const_4),
    .in2(out_reg_11_reg_11),
    .in3(out_reg_4_reg_4),
    ._out_TREADY(_out_TREADY));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428849 (.out1(out_truth_and_expr_FU_1_0_1_32_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428849),
    .in1(out_ui_eq_expr_FU_32_32_32_42_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428772),
    .in2(out_const_1));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428854 (.out1(out_ui_rshift_expr_FU_64_0_64_54_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428854),
    .in1(out_ui_lshift_expr_FU_64_0_64_47_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428637),
    .in2(out_const_3));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428861 (.out1(out_ui_lshift_expr_FU_64_0_64_48_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428861),
    .in1(out_ui_rshift_expr_FU_64_0_64_54_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428854),
    .in2(out_const_3));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428864 (.out1(out_ui_bit_and_expr_FU_32_0_32_34_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428864),
    .in1(out_ui_bit_and_expr_FU_32_0_32_33_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428602),
    .in2(out_const_9));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428869 (.out1(out_ui_rshift_expr_FU_64_0_64_54_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428869),
    .in1(out_ui_lshift_expr_FU_64_0_64_47_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428659),
    .in2(out_const_3));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428874 (.out1(out_ui_lshift_expr_FU_64_0_64_48_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428874),
    .in1(out_ui_rshift_expr_FU_64_0_64_54_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428869),
    .in2(out_const_3));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428877 (.out1(out_ui_bit_and_expr_FU_32_0_32_34_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428877),
    .in1(out_ui_bit_and_expr_FU_32_0_32_33_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428676),
    .in2(out_const_9));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428882 (.out1(out_ui_rshift_expr_FU_32_0_32_53_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428882),
    .in1(out_reg_10_reg_10),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428886 (.out1(out_ui_plus_expr_FU_32_0_32_50_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428886),
    .in1(out_ui_rshift_expr_FU_32_0_32_53_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428882),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428889 (.out1(out_ui_lshift_expr_FU_32_0_32_46_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428889),
    .in1(out_ui_plus_expr_FU_32_0_32_50_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428886),
    .in2(out_const_1));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428892 (.out1(out_ui_rshift_expr_FU_32_0_32_53_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428892),
    .in1(out_ui_lshift_expr_FU_32_0_32_46_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428889),
    .in2(out_const_1));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_23_reg_0_0_0_0),
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
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_51_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428584),
    .wenable(wrenable_reg_11));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_12 (.out1(out_reg_12_reg_12),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_18_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428725),
    .wenable(wrenable_reg_12));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_28_reg_2_0_0_0),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_29_reg_3_0_0_0),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_52_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428577),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(1024),
    .BITSIZE_out1(1024)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_49_i1_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428699),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_49_i2_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428705),
    .wenable(wrenable_reg_7));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_52_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428565),
    .wenable(wrenable_reg_8));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_35_reg_9_0_0_0),
    .wenable(wrenable_reg_9));
  // io-signal post fix
  assign OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715 = out_read_cond_FU_10_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715;
  assign OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723 = out_read_cond_FU_17_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723;
  assign OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729 = out_read_cond_FU_19_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729;
  assign OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740 = out_read_cond_FU_31_i0_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740;
  assign OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566 = s_done_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566_P0;
  assign OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840 = s_done_fu__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840_P0;

endmodule

// FSM based controller description for _Z4vsumPK6ac_intILi1024ELb0EEPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z4vsumPK6ac_intILi1024ELb0EEPxjj(done_port,
  selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566,
  selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0,
  selector_MUX_23_reg_0_0_0_0,
  selector_MUX_24_reg_1_0_0_0,
  selector_MUX_25_reg_10_0_0_0,
  selector_MUX_28_reg_2_0_0_0,
  selector_MUX_29_reg_3_0_0_0,
  selector_MUX_35_reg_9_0_0_0,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_10,
  wrenable_reg_11,
  wrenable_reg_12,
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715,
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723,
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729,
  OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740,
  OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566,
  OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715;
  input OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723;
  input OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729;
  input OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740;
  input OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  input OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  output selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0;
  output selector_MUX_23_reg_0_0_0_0;
  output selector_MUX_24_reg_1_0_0_0;
  output selector_MUX_25_reg_10_0_0_0;
  output selector_MUX_28_reg_2_0_0_0;
  output selector_MUX_29_reg_3_0_0_0;
  output selector_MUX_35_reg_9_0_0_0;
  output wrenable_reg_0;
  output wrenable_reg_1;
  output wrenable_reg_10;
  output wrenable_reg_11;
  output wrenable_reg_12;
  output wrenable_reg_2;
  output wrenable_reg_3;
  output wrenable_reg_4;
  output wrenable_reg_5;
  output wrenable_reg_6;
  output wrenable_reg_7;
  output wrenable_reg_8;
  output wrenable_reg_9;
  parameter [3:0] S_2 = 4'd2,
    S_9 = 4'd9,
    S_0 = 4'd0,
    S_1 = 4'd1,
    S_7 = 4'd7,
    S_4 = 4'd4,
    S_5 = 4'd5,
    S_6 = 4'd6,
    S_3 = 4'd3,
    S_8 = 4'd8;
  reg [3:0] _present_state=S_2, _next_state;
  reg done_port;
  reg selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  reg selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0;
  reg selector_MUX_23_reg_0_0_0_0;
  reg selector_MUX_24_reg_1_0_0_0;
  reg selector_MUX_25_reg_10_0_0_0;
  reg selector_MUX_28_reg_2_0_0_0;
  reg selector_MUX_29_reg_3_0_0_0;
  reg selector_MUX_35_reg_9_0_0_0;
  reg wrenable_reg_0;
  reg wrenable_reg_1;
  reg wrenable_reg_10;
  reg wrenable_reg_11;
  reg wrenable_reg_12;
  reg wrenable_reg_2;
  reg wrenable_reg_3;
  reg wrenable_reg_4;
  reg wrenable_reg_5;
  reg wrenable_reg_6;
  reg wrenable_reg_7;
  reg wrenable_reg_8;
  reg wrenable_reg_9;
  
  always @(posedge clock)
    if (reset == 1'b0) _present_state <= S_2;
    else _present_state <= _next_state;
  
  always @(*)
  begin
    done_port = 1'b0;
    selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566 = 1'b0;
    selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0 = 1'b0;
    selector_MUX_23_reg_0_0_0_0 = 1'b0;
    selector_MUX_24_reg_1_0_0_0 = 1'b0;
    selector_MUX_25_reg_10_0_0_0 = 1'b0;
    selector_MUX_28_reg_2_0_0_0 = 1'b0;
    selector_MUX_29_reg_3_0_0_0 = 1'b0;
    selector_MUX_35_reg_9_0_0_0 = 1'b0;
    wrenable_reg_0 = 1'b0;
    wrenable_reg_1 = 1'b0;
    wrenable_reg_10 = 1'b0;
    wrenable_reg_11 = 1'b0;
    wrenable_reg_12 = 1'b0;
    wrenable_reg_2 = 1'b0;
    wrenable_reg_3 = 1'b0;
    wrenable_reg_4 = 1'b0;
    wrenable_reg_5 = 1'b0;
    wrenable_reg_6 = 1'b0;
    wrenable_reg_7 = 1'b0;
    wrenable_reg_8 = 1'b0;
    wrenable_reg_9 = 1'b0;
    case (_present_state)
      S_2 :
        if(start_port == 1'b1)
        begin
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715 == 1'b0)
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
          _next_state = S_2;
        end
      S_9 :
        begin
          _next_state = S_2;
        end
      S_0 :
        begin
          selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566 = 1'b1;
          selector_MUX_28_reg_2_0_0_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_4 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
          wrenable_reg_6 = 1'b1;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = 1'b1;
          wrenable_reg_9 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566 == 1'b0)
            begin
              _next_state = S_1;
              wrenable_reg_10 = 1'b0;
              wrenable_reg_9 = 1'b0;
            end
          else
            begin
              _next_state = S_7;
            end
        end
      S_1 :
        begin
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
          wrenable_reg_9 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566 == 1'b0)
            begin
              _next_state = S_1;
              wrenable_reg_10 = 1'b0;
              wrenable_reg_9 = 1'b0;
            end
          else
            begin
              _next_state = S_7;
            end
        end
      S_7 :
        begin
          selector_MUX_25_reg_10_0_0_0 = 1'b1;
          selector_MUX_35_reg_9_0_0_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_9 = 1'b1;
          if (OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740 == 1'b1)
            begin
              _next_state = S_4;
              selector_MUX_25_reg_10_0_0_0 = 1'b0;
              wrenable_reg_10 = 1'b0;
            end
          else
            begin
              _next_state = S_7;
            end
        end
      S_4 :
        begin
          selector_MUX_24_reg_1_0_0_0 = 1'b1;
          selector_MUX_29_reg_3_0_0_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729 == 1'b1)
            begin
              _next_state = S_5;
              selector_MUX_24_reg_1_0_0_0 = 1'b0;
              selector_MUX_29_reg_3_0_0_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
          else
            begin
              _next_state = S_3;
            end
        end
      S_5 :
        begin
          selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840 = 1'b1;
          selector_MUX_23_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840 == 1'b0)
            begin
              _next_state = S_6;
              selector_MUX_23_reg_0_0_0_0 = 1'b0;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
          else
            begin
              _next_state = S_3;
            end
        end
      S_6 :
        begin
          selector_MUX_23_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840 == 1'b0)
            begin
              _next_state = S_6;
              selector_MUX_23_reg_0_0_0_0 = 1'b0;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
          else
            begin
              _next_state = S_3;
            end
        end
      S_3 :
        begin
          if (OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723 == 1'b0)
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
          _next_state = S_2;
        end
      default :
        begin
          _next_state = S_2;
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
  wire OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715;
  wire OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723;
  wire OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729;
  wire OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740;
  wire OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  wire OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566;
  wire selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0;
  wire selector_MUX_23_reg_0_0_0_0;
  wire selector_MUX_24_reg_1_0_0_0;
  wire selector_MUX_25_reg_10_0_0_0;
  wire selector_MUX_28_reg_2_0_0_0;
  wire selector_MUX_29_reg_3_0_0_0;
  wire selector_MUX_35_reg_9_0_0_0;
  wire wrenable_reg_0;
  wire wrenable_reg_1;
  wire wrenable_reg_10;
  wire wrenable_reg_11;
  wire wrenable_reg_12;
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
    .selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840(selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0),
    .selector_MUX_23_reg_0_0_0_0(selector_MUX_23_reg_0_0_0_0),
    .selector_MUX_24_reg_1_0_0_0(selector_MUX_24_reg_1_0_0_0),
    .selector_MUX_25_reg_10_0_0_0(selector_MUX_25_reg_10_0_0_0),
    .selector_MUX_28_reg_2_0_0_0(selector_MUX_28_reg_2_0_0_0),
    .selector_MUX_29_reg_3_0_0_0(selector_MUX_29_reg_3_0_0_0),
    .selector_MUX_35_reg_9_0_0_0(selector_MUX_35_reg_9_0_0_0),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_10(wrenable_reg_10),
    .wrenable_reg_11(wrenable_reg_11),
    .wrenable_reg_12(wrenable_reg_12),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740),
    .OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566(OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566),
    .OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840(OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z4vsumPK6ac_intILi1024ELb0EEPxjj Datapath_i (._A_TREADY(_A_TREADY),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428715),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428723),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428729),
    .OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740(OUT_CONDITION__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428740),
    .OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566(OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428566),
    .OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840(OUT_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840),
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
    .selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840(selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi1024ELb0EEPxjj_428532_428840),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_57_i0_0_0_0),
    .selector_MUX_23_reg_0_0_0_0(selector_MUX_23_reg_0_0_0_0),
    .selector_MUX_24_reg_1_0_0_0(selector_MUX_24_reg_1_0_0_0),
    .selector_MUX_25_reg_10_0_0_0(selector_MUX_25_reg_10_0_0_0),
    .selector_MUX_28_reg_2_0_0_0(selector_MUX_28_reg_2_0_0_0),
    .selector_MUX_29_reg_3_0_0_0(selector_MUX_29_reg_3_0_0_0),
    .selector_MUX_35_reg_9_0_0_0(selector_MUX_35_reg_9_0_0_0),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_10(wrenable_reg_10),
    .wrenable_reg_11(wrenable_reg_11),
    .wrenable_reg_12(wrenable_reg_12),
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


