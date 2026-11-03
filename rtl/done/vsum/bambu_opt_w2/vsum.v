// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-03T13:32:06
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=vsum --top-rtldesign-name=vsum --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER --simulate --simulator=VERILATOR --generate-tb=/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/src/tb_vsum.cpp --tb-extra-gcc-options=-DDUT=vsum -DCFG_LOOP_COUNT=32 -DCFG_LEN=32 --tb-param-size=A:512,out:8 -DDATA_T=int64_t -DSIZE_N=64 -DBAMBU_LANES=2 --std=c++14 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include/bambu -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/vectors/n64 /users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vsum/bambu_opt_n64_w2_proj/vsum.cpp 
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

// Datapath RTL description for _Z4vsumPK6ac_intILi128ELb0EEPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z4vsumPK6ac_intILi128ELb0EEPxjj(clock,
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
  selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566,
  selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0,
  selector_MUX_14_reg_0_0_0_0,
  selector_MUX_15_reg_1_0_0_0,
  selector_MUX_18_reg_2_0_0_0,
  selector_MUX_19_reg_3_0_0_0,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_10,
  wrenable_reg_11,
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583,
  OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669,
  OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672,
  OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566,
  OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_A;
  input [31:0] in_port_out;
  input [31:0] in_port_loop_count;
  input [31:0] in_port_len;
  input [127:0] _A_TDATA;
  input _A_TVALID;
  input _out_TREADY;
  input selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566;
  input selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0;
  input selector_MUX_14_reg_0_0_0_0;
  input selector_MUX_15_reg_1_0_0_0;
  input selector_MUX_18_reg_2_0_0_0;
  input selector_MUX_19_reg_3_0_0_0;
  input wrenable_reg_0;
  input wrenable_reg_1;
  input wrenable_reg_10;
  input wrenable_reg_11;
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
  output OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583;
  output OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669;
  output OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672;
  output OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566;
  output OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766;
  // Component and signal declarations
  wire [127:0] out_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0;
  wire [31:0] out_MUX_14_reg_0_0_0_0;
  wire [63:0] out_MUX_15_reg_1_0_0_0;
  wire [31:0] out_MUX_18_reg_2_0_0_0;
  wire [31:0] out_MUX_19_reg_3_0_0_0;
  wire out_UUdata_converter_FU_10_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428581;
  wire out_UUdata_converter_FU_13_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428668;
  wire [63:0] out_UUdata_converter_FU_8_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428567;
  wire [63:0] out_UUdata_converter_FU_9_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428572;
  wire out_const_0;
  wire out_const_1;
  wire [2:0] out_const_2;
  wire [5:0] out_const_3;
  wire [6:0] out_const_4;
  wire [1:0] out_const_5;
  wire [31:0] out_const_6;
  wire [31:0] out_conv_out_const_0_1_32;
  wire [63:0] out_conv_out_const_0_1_64;
  wire out_read_cond_FU_11_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583;
  wire out_read_cond_FU_14_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669;
  wire out_read_cond_FU_20_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672;
  wire [31:0] out_reg_0_reg_0;
  wire out_reg_10_reg_10;
  wire [63:0] out_reg_11_reg_11;
  wire [63:0] out_reg_1_reg_1;
  wire [31:0] out_reg_2_reg_2;
  wire [31:0] out_reg_3_reg_3;
  wire [31:0] out_reg_4_reg_4;
  wire [31:0] out_reg_5_reg_5;
  wire [31:0] out_reg_6_reg_6;
  wire [31:0] out_reg_7_reg_7;
  wire [127:0] out_reg_8_reg_8;
  wire out_reg_9_reg_9;
  wire out_truth_and_expr_FU_1_0_1_21_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428708;
  wire out_truth_and_expr_FU_1_0_1_21_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428808;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_22_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428568;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_22_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428573;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_22_i2_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428797;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_23_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428569;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_23_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428574;
  wire [63:0] out_ui_bit_ior_concat_expr_FU_24_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428576;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_25_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428570;
  wire [0:0] out_ui_cond_expr_FU_1_1_1_1_26_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428582;
  wire out_ui_eq_expr_FU_32_0_32_27_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428712;
  wire out_ui_eq_expr_FU_32_32_32_28_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428699;
  wire out_ui_eq_expr_FU_32_32_32_28_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428702;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_29_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428690;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_30_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428715;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_31_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428776;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_31_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428783;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_31_i2_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428794;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_32_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428578;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_32_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428580;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_32_i2_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428610;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_33_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428791;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_34_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428565;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_34_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428594;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_35_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428571;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_36_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428770;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_36_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428779;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_36_i2_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428786;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_36_i3_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428789;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_37_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428577;
  wire [63:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire [31:0] out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1;
  wire s_done_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566_P0;
  wire s_done_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766_P0;
  
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0),
    .in1(out_reg_7_reg_7),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_34_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428565));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_14_reg_0_0_0_0 (.out1(out_MUX_14_reg_0_0_0_0),
    .sel(selector_MUX_14_reg_0_0_0_0),
    .in1(out_reg_5_reg_5),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_15_reg_1_0_0_0 (.out1(out_MUX_15_reg_1_0_0_0),
    .sel(selector_MUX_15_reg_1_0_0_0),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_37_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428577),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_18_reg_2_0_0_0 (.out1(out_MUX_18_reg_2_0_0_0),
    .sel(selector_MUX_18_reg_2_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_32_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428580),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_19_reg_3_0_0_0 (.out1(out_MUX_19_reg_3_0_0_0),
    .sel(selector_MUX_19_reg_3_0_0_0),
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
  constant_value #(.BITSIZE_out1(3),
    .value(3'b100)) const_2 (.out1(out_const_2));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b100000)) const_3 (.out1(out_const_3));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1000000)) const_4 (.out1(out_const_4));
  constant_value #(.BITSIZE_out1(2),
    .value(2'b11)) const_5 (.out1(out_const_5));
  constant_value #(.BITSIZE_out1(32),
    .value(32'b11111111111111111111111111111111)) const_6 (.out1(out_const_6));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(64)) conv_out_const_0_1_64 (.out1(out_conv_out_const_0_1_64),
    .in1(out_const_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428565 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_34_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428565),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_29_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428690));
  A_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(128)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566 (.done_port({s_done_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566_P0}),
    .out1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566),
    ._A_TREADY(_A_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566}),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID));
  UUdata_converter_FU #(.BITSIZE_in1(128),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428567 (.out1(out_UUdata_converter_FU_8_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428567),
    .in1(out_reg_8_reg_8));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428568 (.out1(out_ui_bit_and_expr_FU_32_0_32_22_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428568),
    .in1(out_ui_rshift_expr_FU_64_0_64_36_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428770),
    .in2(out_const_6));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428569 (.out1(out_ui_bit_and_expr_FU_32_0_32_23_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428569),
    .in1(out_UUdata_converter_FU_8_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428567),
    .in2(out_const_6));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428570 (.out1(out_ui_bit_ior_expr_FU_0_64_64_25_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428570),
    .in1(out_ui_bit_and_expr_FU_32_0_32_23_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428569),
    .in2(out_ui_lshift_expr_FU_64_0_64_31_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428776));
  ui_rshift_expr_FU #(.BITSIZE_in1(128),
    .BITSIZE_in2(7),
    .BITSIZE_out1(64),
    .PRECISION(128)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428571 (.out1(out_ui_rshift_expr_FU_64_0_64_35_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428571),
    .in1(out_reg_8_reg_8),
    .in2(out_const_4));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428572 (.out1(out_UUdata_converter_FU_9_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428572),
    .in1(out_ui_rshift_expr_FU_64_0_64_35_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428571));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428573 (.out1(out_ui_bit_and_expr_FU_32_0_32_22_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428573),
    .in1(out_ui_rshift_expr_FU_64_0_64_36_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428779),
    .in2(out_const_6));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428574 (.out1(out_ui_bit_and_expr_FU_32_0_32_23_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428574),
    .in1(out_UUdata_converter_FU_9_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428572),
    .in2(out_const_6));
  ui_bit_ior_concat_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(6),
    .BITSIZE_out1(64),
    .OFFSET_PARAMETER(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428576 (.out1(out_ui_bit_ior_concat_expr_FU_24_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428576),
    .in1(out_ui_lshift_expr_FU_64_0_64_31_i2_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428794),
    .in2(out_ui_bit_and_expr_FU_32_0_32_22_i2_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428797),
    .in3(out_const_3));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428577 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_37_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428577),
    .in1(out_reg_1_reg_1),
    .in2(out_ui_bit_and_expr_FU_32_0_32_23_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428574),
    .in3(out_ui_bit_ior_concat_expr_FU_24_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428576));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428578 (.out1(out_ui_plus_expr_FU_32_0_32_32_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428578),
    .in1(out_reg_3_reg_3),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428580 (.out1(out_ui_plus_expr_FU_32_0_32_32_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428580),
    .in1(out_reg_2_reg_2),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428581 (.out1(out_UUdata_converter_FU_10_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428581),
    .in1(out_ui_eq_expr_FU_32_32_32_28_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428702));
  ui_cond_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_in3(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428582 (.out1(out_ui_cond_expr_FU_1_1_1_1_26_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428582),
    .in1(out_truth_and_expr_FU_1_0_1_21_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428708),
    .in2(out_const_1),
    .in3(out_UUdata_converter_FU_10_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428581));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583 (.out1(out_read_cond_FU_11_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583),
    .in1(out_reg_10_reg_10));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428594 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_34_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428594),
    .in1(in_port_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_30_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428715));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428610 (.out1(out_ui_plus_expr_FU_32_0_32_32_i2_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428610),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428668 (.out1(out_UUdata_converter_FU_13_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428668),
    .in1(out_ui_eq_expr_FU_32_0_32_27_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428712));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669 (.out1(out_read_cond_FU_14_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669),
    .in1(out_UUdata_converter_FU_13_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428668));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672 (.out1(out_read_cond_FU_20_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672),
    .in1(out_reg_9_reg_9));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(3),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428690 (.out1(out_ui_lshift_expr_FU_32_0_32_29_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428690),
    .in1(out_reg_2_reg_2),
    .in2(out_const_2));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428699 (.out1(out_ui_eq_expr_FU_32_32_32_28_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428699),
    .in1(out_ui_plus_expr_FU_32_0_32_32_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428578),
    .in2(in_port_len));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428702 (.out1(out_ui_eq_expr_FU_32_32_32_28_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428702),
    .in1(out_ui_plus_expr_FU_32_0_32_32_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428580),
    .in2(in_port_loop_count));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428708 (.out1(out_truth_and_expr_FU_1_0_1_21_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428708),
    .in1(out_truth_and_expr_FU_1_0_1_21_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428808),
    .in2(out_const_1));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428712 (.out1(out_ui_eq_expr_FU_32_0_32_27_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428712),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428715 (.out1(out_ui_lshift_expr_FU_32_0_32_30_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428715),
    .in1(out_reg_0_reg_0),
    .in2(out_const_5));
  out_bambu_artificial_ParmMgr_Write_axis_modgen #(.BITSIZE_in1(7),
    .BITSIZE_in2(64),
    .BITSIZE_in3(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766 (.done_port({s_done_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766_P0}),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766}),
    .in1(out_const_4),
    .in2(out_reg_11_reg_11),
    .in3(out_reg_4_reg_4),
    ._out_TREADY(_out_TREADY));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428770 (.out1(out_ui_rshift_expr_FU_64_0_64_36_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428770),
    .in1(out_UUdata_converter_FU_8_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428567),
    .in2(out_const_3));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428776 (.out1(out_ui_lshift_expr_FU_64_0_64_31_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428776),
    .in1(out_ui_bit_and_expr_FU_32_0_32_22_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428568),
    .in2(out_const_3));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428779 (.out1(out_ui_rshift_expr_FU_64_0_64_36_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428779),
    .in1(out_UUdata_converter_FU_9_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428572),
    .in2(out_const_3));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428783 (.out1(out_ui_lshift_expr_FU_64_0_64_31_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428783),
    .in1(out_ui_bit_and_expr_FU_32_0_32_22_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428573),
    .in2(out_const_3));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428786 (.out1(out_ui_rshift_expr_FU_64_0_64_36_i2_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428786),
    .in1(out_ui_lshift_expr_FU_64_0_64_31_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428783),
    .in2(out_const_3));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428789 (.out1(out_ui_rshift_expr_FU_64_0_64_36_i3_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428789),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_25_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428570),
    .in2(out_const_3));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428791 (.out1(out_ui_plus_expr_FU_32_32_32_33_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428791),
    .in1(out_ui_rshift_expr_FU_64_0_64_36_i2_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428786),
    .in2(out_ui_rshift_expr_FU_64_0_64_36_i3_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428789));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428794 (.out1(out_ui_lshift_expr_FU_64_0_64_31_i2_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428794),
    .in1(out_ui_plus_expr_FU_32_32_32_33_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428791),
    .in2(out_const_3));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428797 (.out1(out_ui_bit_and_expr_FU_32_0_32_22_i2_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428797),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_25_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428570),
    .in2(out_const_6));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428808 (.out1(out_truth_and_expr_FU_1_0_1_21_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428808),
    .in1(out_ui_eq_expr_FU_32_32_32_28_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428699),
    .in2(out_const_1));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_14_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_15_reg_1_0_0_0),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_10 (.out1(out_reg_10_reg_10),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_cond_expr_FU_1_1_1_1_26_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428582),
    .wenable(wrenable_reg_10));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_37_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428577),
    .wenable(wrenable_reg_11));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_18_reg_2_0_0_0),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_19_reg_3_0_0_0),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_34_i1_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428594),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_32_i2_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428610),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_32_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428578),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_34_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428565),
    .wenable(wrenable_reg_7));
  register_SE #(.BITSIZE_in1(128),
    .BITSIZE_out1(128)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566),
    .wenable(wrenable_reg_8));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_10_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428581),
    .wenable(wrenable_reg_9));
  // io-signal post fix
  assign OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583 = out_read_cond_FU_11_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583;
  assign OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669 = out_read_cond_FU_14_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669;
  assign OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672 = out_read_cond_FU_20_i0_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672;
  assign OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566 = s_done_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566_P0;
  assign OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766 = s_done_fu__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766_P0;

endmodule

// FSM based controller description for _Z4vsumPK6ac_intILi128ELb0EEPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z4vsumPK6ac_intILi128ELb0EEPxjj(done_port,
  selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566,
  selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0,
  selector_MUX_14_reg_0_0_0_0,
  selector_MUX_15_reg_1_0_0_0,
  selector_MUX_18_reg_2_0_0_0,
  selector_MUX_19_reg_3_0_0_0,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_10,
  wrenable_reg_11,
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583,
  OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669,
  OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672,
  OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566,
  OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583;
  input OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669;
  input OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672;
  input OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566;
  input OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566;
  output selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0;
  output selector_MUX_14_reg_0_0_0_0;
  output selector_MUX_15_reg_1_0_0_0;
  output selector_MUX_18_reg_2_0_0_0;
  output selector_MUX_19_reg_3_0_0_0;
  output wrenable_reg_0;
  output wrenable_reg_1;
  output wrenable_reg_10;
  output wrenable_reg_11;
  output wrenable_reg_2;
  output wrenable_reg_3;
  output wrenable_reg_4;
  output wrenable_reg_5;
  output wrenable_reg_6;
  output wrenable_reg_7;
  output wrenable_reg_8;
  output wrenable_reg_9;
  parameter [3:0] S_3 = 4'd3,
    S_8 = 4'd8,
    S_0 = 4'd0,
    S_1 = 4'd1,
    S_2 = 4'd2,
    S_5 = 4'd5,
    S_6 = 4'd6,
    S_4 = 4'd4,
    S_7 = 4'd7;
  reg [3:0] _present_state=S_3, _next_state;
  reg done_port;
  reg selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566;
  reg selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0;
  reg selector_MUX_14_reg_0_0_0_0;
  reg selector_MUX_15_reg_1_0_0_0;
  reg selector_MUX_18_reg_2_0_0_0;
  reg selector_MUX_19_reg_3_0_0_0;
  reg wrenable_reg_0;
  reg wrenable_reg_1;
  reg wrenable_reg_10;
  reg wrenable_reg_11;
  reg wrenable_reg_2;
  reg wrenable_reg_3;
  reg wrenable_reg_4;
  reg wrenable_reg_5;
  reg wrenable_reg_6;
  reg wrenable_reg_7;
  reg wrenable_reg_8;
  reg wrenable_reg_9;
  
  always @(posedge clock)
    if (reset == 1'b0) _present_state <= S_3;
    else _present_state <= _next_state;
  
  always @(*)
  begin
    done_port = 1'b0;
    selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566 = 1'b0;
    selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0 = 1'b0;
    selector_MUX_14_reg_0_0_0_0 = 1'b0;
    selector_MUX_15_reg_1_0_0_0 = 1'b0;
    selector_MUX_18_reg_2_0_0_0 = 1'b0;
    selector_MUX_19_reg_3_0_0_0 = 1'b0;
    wrenable_reg_0 = 1'b0;
    wrenable_reg_1 = 1'b0;
    wrenable_reg_10 = 1'b0;
    wrenable_reg_11 = 1'b0;
    wrenable_reg_2 = 1'b0;
    wrenable_reg_3 = 1'b0;
    wrenable_reg_4 = 1'b0;
    wrenable_reg_5 = 1'b0;
    wrenable_reg_6 = 1'b0;
    wrenable_reg_7 = 1'b0;
    wrenable_reg_8 = 1'b0;
    wrenable_reg_9 = 1'b0;
    case (_present_state)
      S_3 :
        if(start_port == 1'b1)
        begin
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669 == 1'b0)
            begin
              _next_state = S_0;
            end
          else
            begin
              _next_state = S_8;
              done_port = 1'b1;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_2 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
        end
        else
        begin
          _next_state = S_3;
        end
      S_8 :
        begin
          _next_state = S_3;
        end
      S_0 :
        begin
          selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566 = 1'b1;
          selector_MUX_18_reg_2_0_0_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_4 = 1'b1;
          wrenable_reg_5 = 1'b1;
          wrenable_reg_6 = 1'b1;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566;
          wrenable_reg_9 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566 == 1'b0)
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0 = 1'b1;
          wrenable_reg_8 = OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566;
          if (OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566 == 1'b0)
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
          selector_MUX_15_reg_1_0_0_0 = 1'b1;
          selector_MUX_19_reg_3_0_0_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583 == 1'b1)
            begin
              _next_state = S_5;
              selector_MUX_15_reg_1_0_0_0 = 1'b0;
              selector_MUX_19_reg_3_0_0_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
          else
            begin
              _next_state = S_4;
            end
        end
      S_5 :
        begin
          selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766 = 1'b1;
          selector_MUX_14_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766 == 1'b0)
            begin
              _next_state = S_6;
              selector_MUX_14_reg_0_0_0_0 = 1'b0;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
          else
            begin
              _next_state = S_4;
            end
        end
      S_6 :
        begin
          selector_MUX_14_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766 == 1'b0)
            begin
              _next_state = S_6;
              selector_MUX_14_reg_0_0_0_0 = 1'b0;
              wrenable_reg_0 = 1'b0;
              wrenable_reg_1 = 1'b0;
              wrenable_reg_3 = 1'b0;
            end
          else
            begin
              _next_state = S_4;
            end
        end
      S_4 :
        begin
          if (OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672 == 1'b0)
            begin
              _next_state = S_0;
            end
          else
            begin
              _next_state = S_7;
              done_port = 1'b1;
            end
        end
      S_7 :
        begin
          _next_state = S_3;
        end
      default :
        begin
          _next_state = S_3;
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

// Top component for _Z4vsumPK6ac_intILi128ELb0EEPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z4vsumPK6ac_intILi128ELb0EEPxjj(clock,
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
  input [127:0] _A_TDATA;
  input _A_TVALID;
  input _out_TREADY;
  // OUT
  output done_port;
  output _A_TREADY;
  output [63:0] _out_TDATA;
  output _out_TVALID;
  // Component and signal declarations
  wire OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583;
  wire OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669;
  wire OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672;
  wire OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566;
  wire OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566;
  wire selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0;
  wire selector_MUX_14_reg_0_0_0_0;
  wire selector_MUX_15_reg_1_0_0_0;
  wire selector_MUX_18_reg_2_0_0_0;
  wire selector_MUX_19_reg_3_0_0_0;
  wire wrenable_reg_0;
  wire wrenable_reg_1;
  wire wrenable_reg_10;
  wire wrenable_reg_11;
  wire wrenable_reg_2;
  wire wrenable_reg_3;
  wire wrenable_reg_4;
  wire wrenable_reg_5;
  wire wrenable_reg_6;
  wire wrenable_reg_7;
  wire wrenable_reg_8;
  wire wrenable_reg_9;
  
  controller__Z4vsumPK6ac_intILi128ELb0EEPxjj Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566(selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566),
    .selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766(selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0),
    .selector_MUX_14_reg_0_0_0_0(selector_MUX_14_reg_0_0_0_0),
    .selector_MUX_15_reg_1_0_0_0(selector_MUX_15_reg_1_0_0_0),
    .selector_MUX_18_reg_2_0_0_0(selector_MUX_18_reg_2_0_0_0),
    .selector_MUX_19_reg_3_0_0_0(selector_MUX_19_reg_3_0_0_0),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_10(wrenable_reg_10),
    .wrenable_reg_11(wrenable_reg_11),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9),
    .OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583(OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583),
    .OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669(OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669),
    .OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672(OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672),
    .OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566(OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566),
    .OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766(OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z4vsumPK6ac_intILi128ELb0EEPxjj Datapath_i (._A_TREADY(_A_TREADY),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583(OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428583),
    .OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669(OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428669),
    .OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672(OUT_CONDITION__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428672),
    .OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566(OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566),
    .OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766(OUT_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766),
    .clock(clock),
    .reset(reset),
    .in_port_A(A),
    .in_port_out(out),
    .in_port_loop_count(loop_count),
    .in_port_len(len),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID),
    ._out_TREADY(_out_TREADY),
    .selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566(selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428566),
    .selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766(selector_IN_UNBOUNDED__Z4vsumPK6ac_intILi128ELb0EEPxjj_428532_428766),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_38_i0_0_0_0),
    .selector_MUX_14_reg_0_0_0_0(selector_MUX_14_reg_0_0_0_0),
    .selector_MUX_15_reg_1_0_0_0(selector_MUX_15_reg_1_0_0_0),
    .selector_MUX_18_reg_2_0_0_0(selector_MUX_18_reg_2_0_0_0),
    .selector_MUX_19_reg_3_0_0_0(selector_MUX_19_reg_3_0_0_0),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_10(wrenable_reg_10),
    .wrenable_reg_11(wrenable_reg_11),
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

// Minimal interface for function: _Z4vsumPK6ac_intILi128ELb0EEPxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z4vsumPK6ac_intILi128ELb0EEPxjj(clock,
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
  input [127:0] A_TDATA;
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
  
  __Z4vsumPK6ac_intILi128ELb0EEPxjj __Z4vsumPK6ac_intILi128ELb0EEPxjj_i0 (.done_port(done_port),
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


