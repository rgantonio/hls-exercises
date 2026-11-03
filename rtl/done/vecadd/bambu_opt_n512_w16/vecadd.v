// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-03T13:00:04
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=vecadd --top-rtldesign-name=vecadd --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER --simulate --simulator=VERILATOR --generate-tb=/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/src/tb_vecadd.cpp --tb-extra-gcc-options=-DDUT=vecadd -DCFG_LOOP_COUNT=32 --tb-param-size=A:4096,B:4096,C:4096 -DDATA_T=int64_t -DSIZE_N=512 -DBAMBU_LANES=16 --std=c++14 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include/bambu -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/vectors/n512 /users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/bambu_opt_n512_w16_proj/vecadd.cpp 
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
module ui_bit_xor_expr_FU(in1,
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
  assign out1 = in1 ^ in2;
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

// Interface module for function: B_bambu_artificial_ParmMgr_Read_axis
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module B_bambu_artificial_ParmMgr_Read_axis_modgen(clock,
  reset,
  start_port,
  in1,
  _B_TDATA,
  _B_TVALID,
  done_port,
  out1,
  _B_TREADY);
  parameter BITSIZE_in1=32,
    BITSIZE_out1=1024;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [1023:0] _B_TDATA;
  input _B_TVALID;
  // OUT
  output [0:0] done_port;
  output [BITSIZE_out1-1:0] out1;
  output _B_TREADY;
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
    started_0 = (started || start_port) & ~_B_TVALID;
    done_0 = (started | start_port) & _B_TVALID;
  end
  
  assign out1 = {_B_TVALID, _B_TDATA};
  assign done_port = done_0;
  assign _B_TREADY = done_0;

endmodule

// Interface module for function: C_bambu_artificial_ParmMgr_Write_axis
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module C_bambu_artificial_ParmMgr_Write_axis_modgen(clock,
  reset,
  start_port,
  in1,
  in2,
  in3,
  _C_TREADY,
  done_port,
  out1,
  _C_TDATA,
  _C_TVALID);
  parameter BITSIZE_in1=11,
    BITSIZE_in2=1024,
    BITSIZE_in3=32;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  input [BITSIZE_in3-1:0] in3;
  input _C_TREADY;
  // OUT
  output [0:0] done_port;
  output out1;
  output [1023:0] _C_TDATA;
  output _C_TVALID;
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
    started_0 = (started | start_port) & ~_C_TREADY;
  end
  
  assign done_port = (started | start_port) & _C_TREADY;
  assign _C_TVALID = started | start_port;
  assign out1 = _C_TREADY;
  assign _C_TDATA = in2;

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

// Datapath RTL description for _Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j(clock,
  reset,
  in_port_A,
  in_port_B,
  in_port_C,
  in_port_loop_count,
  _A_TDATA,
  _A_TVALID,
  _A_TREADY,
  _B_TDATA,
  _B_TVALID,
  _B_TREADY,
  _C_TREADY,
  _C_TDATA,
  _C_TVALID,
  selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564,
  selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566,
  selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0,
  selector_MUX_107_reg_0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0,
  muenable_mu_S_0,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903,
  OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704,
  OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564,
  OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566,
  OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800,
  OUT_mu_S_0_MULTI_UNBOUNDED_0);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_A;
  input [31:0] in_port_B;
  input [31:0] in_port_C;
  input [31:0] in_port_loop_count;
  input [1023:0] _A_TDATA;
  input _A_TVALID;
  input [1023:0] _B_TDATA;
  input _B_TVALID;
  input _C_TREADY;
  input selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564;
  input selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566;
  input selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0;
  input selector_MUX_107_reg_0_0_0_0;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0;
  input muenable_mu_S_0;
  input wrenable_reg_0;
  input wrenable_reg_1;
  input wrenable_reg_2;
  input wrenable_reg_3;
  input wrenable_reg_4;
  input wrenable_reg_5;
  input wrenable_reg_6;
  input wrenable_reg_7;
  // OUT
  output _A_TREADY;
  output _B_TREADY;
  output [1023:0] _C_TDATA;
  output _C_TVALID;
  output OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903;
  output OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704;
  output OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564;
  output OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566;
  output OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800;
  output OUT_mu_S_0_MULTI_UNBOUNDED_0;
  // Component and signal declarations
  wire [1023:0] out_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564;
  wire [1023:0] out_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0;
  wire [31:0] out_MUX_107_reg_0_0_0_0;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0;
  wire [1023:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0;
  wire out_UUdata_converter_FU_102_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429703;
  wire [31:0] out_UUdata_converter_FU_10_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428590;
  wire [31:0] out_UUdata_converter_FU_11_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428591;
  wire [31:0] out_UUdata_converter_FU_12_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428596;
  wire [31:0] out_UUdata_converter_FU_13_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428600;
  wire [31:0] out_UUdata_converter_FU_14_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428602;
  wire [63:0] out_UUdata_converter_FU_15_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428606;
  wire [31:0] out_UUdata_converter_FU_16_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428611;
  wire [31:0] out_UUdata_converter_FU_17_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428612;
  wire [31:0] out_UUdata_converter_FU_18_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428617;
  wire [31:0] out_UUdata_converter_FU_19_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428621;
  wire [31:0] out_UUdata_converter_FU_20_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428623;
  wire [63:0] out_UUdata_converter_FU_21_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428627;
  wire [31:0] out_UUdata_converter_FU_22_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428632;
  wire [31:0] out_UUdata_converter_FU_23_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428633;
  wire [31:0] out_UUdata_converter_FU_24_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428638;
  wire [31:0] out_UUdata_converter_FU_25_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428642;
  wire [31:0] out_UUdata_converter_FU_26_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428644;
  wire [63:0] out_UUdata_converter_FU_27_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428648;
  wire [31:0] out_UUdata_converter_FU_28_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428653;
  wire [31:0] out_UUdata_converter_FU_29_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428654;
  wire [31:0] out_UUdata_converter_FU_30_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428659;
  wire [31:0] out_UUdata_converter_FU_31_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428663;
  wire [31:0] out_UUdata_converter_FU_32_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428665;
  wire [63:0] out_UUdata_converter_FU_33_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428669;
  wire [31:0] out_UUdata_converter_FU_34_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428674;
  wire [31:0] out_UUdata_converter_FU_35_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428675;
  wire [31:0] out_UUdata_converter_FU_36_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428680;
  wire [31:0] out_UUdata_converter_FU_37_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428684;
  wire [31:0] out_UUdata_converter_FU_38_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428686;
  wire [63:0] out_UUdata_converter_FU_39_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428690;
  wire [63:0] out_UUdata_converter_FU_3_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428567;
  wire [31:0] out_UUdata_converter_FU_40_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428695;
  wire [31:0] out_UUdata_converter_FU_41_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428696;
  wire [31:0] out_UUdata_converter_FU_42_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428701;
  wire [31:0] out_UUdata_converter_FU_43_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428705;
  wire [31:0] out_UUdata_converter_FU_44_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428707;
  wire [63:0] out_UUdata_converter_FU_45_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428711;
  wire [31:0] out_UUdata_converter_FU_46_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428716;
  wire [31:0] out_UUdata_converter_FU_47_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428717;
  wire [31:0] out_UUdata_converter_FU_48_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428722;
  wire [31:0] out_UUdata_converter_FU_49_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428726;
  wire [31:0] out_UUdata_converter_FU_4_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428571;
  wire [31:0] out_UUdata_converter_FU_50_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428728;
  wire [63:0] out_UUdata_converter_FU_51_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428732;
  wire [31:0] out_UUdata_converter_FU_52_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428737;
  wire [31:0] out_UUdata_converter_FU_53_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428738;
  wire [31:0] out_UUdata_converter_FU_54_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428743;
  wire [31:0] out_UUdata_converter_FU_55_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428747;
  wire [31:0] out_UUdata_converter_FU_56_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428749;
  wire [63:0] out_UUdata_converter_FU_57_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428753;
  wire [31:0] out_UUdata_converter_FU_58_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428758;
  wire [31:0] out_UUdata_converter_FU_59_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428759;
  wire [31:0] out_UUdata_converter_FU_5_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428572;
  wire [31:0] out_UUdata_converter_FU_60_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428764;
  wire [31:0] out_UUdata_converter_FU_61_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428768;
  wire [31:0] out_UUdata_converter_FU_62_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428770;
  wire [63:0] out_UUdata_converter_FU_63_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428774;
  wire [31:0] out_UUdata_converter_FU_64_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428779;
  wire [31:0] out_UUdata_converter_FU_65_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428780;
  wire [31:0] out_UUdata_converter_FU_66_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428785;
  wire [31:0] out_UUdata_converter_FU_67_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428789;
  wire [31:0] out_UUdata_converter_FU_68_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428791;
  wire [63:0] out_UUdata_converter_FU_69_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428795;
  wire [31:0] out_UUdata_converter_FU_6_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428577;
  wire [31:0] out_UUdata_converter_FU_70_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428800;
  wire [31:0] out_UUdata_converter_FU_71_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428801;
  wire [31:0] out_UUdata_converter_FU_72_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428806;
  wire [31:0] out_UUdata_converter_FU_73_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428810;
  wire [31:0] out_UUdata_converter_FU_74_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428812;
  wire [63:0] out_UUdata_converter_FU_75_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428816;
  wire [31:0] out_UUdata_converter_FU_76_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428821;
  wire [31:0] out_UUdata_converter_FU_77_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428822;
  wire [31:0] out_UUdata_converter_FU_78_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428827;
  wire [31:0] out_UUdata_converter_FU_79_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428831;
  wire [31:0] out_UUdata_converter_FU_7_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428579;
  wire [31:0] out_UUdata_converter_FU_80_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428833;
  wire [63:0] out_UUdata_converter_FU_81_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428837;
  wire [31:0] out_UUdata_converter_FU_82_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428842;
  wire [31:0] out_UUdata_converter_FU_83_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428843;
  wire [31:0] out_UUdata_converter_FU_84_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428848;
  wire [31:0] out_UUdata_converter_FU_85_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428852;
  wire [31:0] out_UUdata_converter_FU_86_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428854;
  wire [63:0] out_UUdata_converter_FU_87_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428858;
  wire [31:0] out_UUdata_converter_FU_88_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428863;
  wire [31:0] out_UUdata_converter_FU_89_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428864;
  wire [31:0] out_UUdata_converter_FU_8_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428581;
  wire [31:0] out_UUdata_converter_FU_90_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428869;
  wire [31:0] out_UUdata_converter_FU_91_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428873;
  wire [31:0] out_UUdata_converter_FU_92_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428875;
  wire [63:0] out_UUdata_converter_FU_93_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428879;
  wire [31:0] out_UUdata_converter_FU_94_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428884;
  wire [31:0] out_UUdata_converter_FU_95_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428885;
  wire [31:0] out_UUdata_converter_FU_96_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428890;
  wire [31:0] out_UUdata_converter_FU_97_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428894;
  wire [31:0] out_UUdata_converter_FU_98_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428896;
  wire out_UUdata_converter_FU_99_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428902;
  wire [63:0] out_UUdata_converter_FU_9_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428585;
  wire out_const_0;
  wire out_const_1;
  wire [9:0] out_const_10;
  wire [9:0] out_const_11;
  wire [7:0] out_const_12;
  wire [8:0] out_const_13;
  wire [9:0] out_const_14;
  wire [9:0] out_const_15;
  wire [8:0] out_const_16;
  wire [9:0] out_const_17;
  wire [9:0] out_const_18;
  wire [6:0] out_const_19;
  wire [5:0] out_const_2;
  wire [7:0] out_const_20;
  wire [8:0] out_const_21;
  wire [9:0] out_const_22;
  wire [9:0] out_const_23;
  wire [8:0] out_const_24;
  wire [9:0] out_const_25;
  wire [9:0] out_const_26;
  wire [2:0] out_const_27;
  wire [7:0] out_const_28;
  wire [8:0] out_const_29;
  wire [6:0] out_const_3;
  wire [9:0] out_const_30;
  wire [9:0] out_const_31;
  wire [8:0] out_const_32;
  wire [9:0] out_const_33;
  wire [9:0] out_const_34;
  wire [31:0] out_const_35;
  wire [7:0] out_const_4;
  wire [8:0] out_const_5;
  wire [9:0] out_const_6;
  wire [10:0] out_const_7;
  wire [9:0] out_const_8;
  wire [8:0] out_const_9;
  wire [31:0] out_conv_out_const_0_1_32;
  wire out_read_cond_FU_100_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903;
  wire out_read_cond_FU_103_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704;
  wire [31:0] out_reg_0_reg_0;
  wire [31:0] out_reg_1_reg_1;
  wire [1023:0] out_reg_2_reg_2;
  wire [31:0] out_reg_3_reg_3;
  wire [1023:0] out_reg_4_reg_4;
  wire [31:0] out_reg_5_reg_5;
  wire out_reg_6_reg_6;
  wire [1023:0] out_reg_7_reg_7;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428568;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428634;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428637;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428649;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428655;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428658;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428670;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i16_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428676;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i17_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428679;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i18_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428691;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i19_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428697;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428573;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i20_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428700;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i21_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428712;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i22_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428718;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i23_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428721;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i24_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428733;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i25_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428739;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i26_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428742;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i27_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428754;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i28_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428760;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i29_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428763;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428576;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i30_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428775;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i31_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428781;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i32_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428784;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i33_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428796;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i34_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428802;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i35_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428805;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i36_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428817;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i37_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428823;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i38_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428826;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i39_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428838;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428586;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i40_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428844;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i41_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428847;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i42_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428859;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i43_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428865;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i44_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428868;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i45_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428880;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i46_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428886;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i47_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428889;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428592;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428595;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428607;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428613;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428616;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_104_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428628;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428569;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428776;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428797;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428818;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428839;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428860;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428881;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428587;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428608;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428629;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428650;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428671;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428692;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428713;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428734;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_105_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428755;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_106_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428574;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_107_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428583;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_108_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428593;
  wire [95:0] out_ui_bit_ior_expr_FU_0_64_64_109_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428598;
  wire [127:0] out_ui_bit_ior_expr_FU_0_64_64_110_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428604;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_111_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428614;
  wire [159:0] out_ui_bit_ior_expr_FU_0_64_64_112_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428619;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_113_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428635;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_114_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428656;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_115_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428677;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_116_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428698;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_117_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428719;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_118_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428740;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_119_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428761;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_120_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428782;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_121_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428803;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_122_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428824;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_123_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428845;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_124_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428866;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_125_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428887;
  wire [191:0] out_ui_bit_xor_expr_FU_64_64_64_126_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428625;
  wire [511:0] out_ui_bit_xor_expr_FU_64_64_64_126_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428730;
  wire [543:0] out_ui_bit_xor_expr_FU_64_64_64_126_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428745;
  wire [575:0] out_ui_bit_xor_expr_FU_64_64_64_126_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428751;
  wire [607:0] out_ui_bit_xor_expr_FU_64_64_64_126_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428766;
  wire [639:0] out_ui_bit_xor_expr_FU_64_64_64_126_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428772;
  wire [671:0] out_ui_bit_xor_expr_FU_64_64_64_126_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428787;
  wire [703:0] out_ui_bit_xor_expr_FU_64_64_64_126_i16_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428793;
  wire [735:0] out_ui_bit_xor_expr_FU_64_64_64_126_i17_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428808;
  wire [767:0] out_ui_bit_xor_expr_FU_64_64_64_126_i18_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428814;
  wire [799:0] out_ui_bit_xor_expr_FU_64_64_64_126_i19_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428829;
  wire [223:0] out_ui_bit_xor_expr_FU_64_64_64_126_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428640;
  wire [831:0] out_ui_bit_xor_expr_FU_64_64_64_126_i20_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428835;
  wire [863:0] out_ui_bit_xor_expr_FU_64_64_64_126_i21_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428850;
  wire [895:0] out_ui_bit_xor_expr_FU_64_64_64_126_i22_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428856;
  wire [927:0] out_ui_bit_xor_expr_FU_64_64_64_126_i23_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428871;
  wire [959:0] out_ui_bit_xor_expr_FU_64_64_64_126_i24_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428877;
  wire [991:0] out_ui_bit_xor_expr_FU_64_64_64_126_i25_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428892;
  wire [1023:0] out_ui_bit_xor_expr_FU_64_64_64_126_i26_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428898;
  wire [255:0] out_ui_bit_xor_expr_FU_64_64_64_126_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428646;
  wire [287:0] out_ui_bit_xor_expr_FU_64_64_64_126_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428661;
  wire [319:0] out_ui_bit_xor_expr_FU_64_64_64_126_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428667;
  wire [351:0] out_ui_bit_xor_expr_FU_64_64_64_126_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428682;
  wire [383:0] out_ui_bit_xor_expr_FU_64_64_64_126_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428688;
  wire [415:0] out_ui_bit_xor_expr_FU_64_64_64_126_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428703;
  wire [447:0] out_ui_bit_xor_expr_FU_64_64_64_126_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428709;
  wire [479:0] out_ui_bit_xor_expr_FU_64_64_64_126_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428724;
  wire out_ui_eq_expr_FU_32_0_32_127_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429746;
  wire out_ui_eq_expr_FU_32_32_32_128_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429739;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_129_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429724;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_130_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428582;
  wire [95:0] out_ui_lshift_expr_FU_64_0_64_131_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428597;
  wire [127:0] out_ui_lshift_expr_FU_64_0_64_132_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428603;
  wire [159:0] out_ui_lshift_expr_FU_64_0_64_133_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428618;
  wire [191:0] out_ui_lshift_expr_FU_64_0_64_134_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428624;
  wire [223:0] out_ui_lshift_expr_FU_64_0_64_135_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428639;
  wire [255:0] out_ui_lshift_expr_FU_64_0_64_136_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428645;
  wire [287:0] out_ui_lshift_expr_FU_64_0_64_137_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428660;
  wire [319:0] out_ui_lshift_expr_FU_64_0_64_138_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428666;
  wire [351:0] out_ui_lshift_expr_FU_64_0_64_139_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428681;
  wire [383:0] out_ui_lshift_expr_FU_64_0_64_140_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428687;
  wire [415:0] out_ui_lshift_expr_FU_64_0_64_141_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428702;
  wire [447:0] out_ui_lshift_expr_FU_64_0_64_142_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428708;
  wire [479:0] out_ui_lshift_expr_FU_64_0_64_143_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428723;
  wire [511:0] out_ui_lshift_expr_FU_64_0_64_144_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428729;
  wire [543:0] out_ui_lshift_expr_FU_64_0_64_145_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428744;
  wire [575:0] out_ui_lshift_expr_FU_64_0_64_146_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428750;
  wire [607:0] out_ui_lshift_expr_FU_64_0_64_147_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428765;
  wire [639:0] out_ui_lshift_expr_FU_64_0_64_148_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428771;
  wire [671:0] out_ui_lshift_expr_FU_64_0_64_149_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428786;
  wire [703:0] out_ui_lshift_expr_FU_64_0_64_150_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428792;
  wire [735:0] out_ui_lshift_expr_FU_64_0_64_151_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428807;
  wire [767:0] out_ui_lshift_expr_FU_64_0_64_152_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428813;
  wire [799:0] out_ui_lshift_expr_FU_64_0_64_153_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428828;
  wire [831:0] out_ui_lshift_expr_FU_64_0_64_154_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428834;
  wire [863:0] out_ui_lshift_expr_FU_64_0_64_155_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428849;
  wire [895:0] out_ui_lshift_expr_FU_64_0_64_156_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428855;
  wire [927:0] out_ui_lshift_expr_FU_64_0_64_157_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428870;
  wire [959:0] out_ui_lshift_expr_FU_64_0_64_158_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428876;
  wire [991:0] out_ui_lshift_expr_FU_64_0_64_159_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428891;
  wire [1023:0] out_ui_lshift_expr_FU_64_0_64_160_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428897;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429810;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429880;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429887;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429894;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429901;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429908;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429915;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429817;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429824;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429831;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429838;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429845;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429852;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429859;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429866;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_161_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429873;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_162_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428901;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428580;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428790;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428811;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428832;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428853;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428874;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428895;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428601;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428622;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428643;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428664;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428685;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428706;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428727;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428748;
  wire [31:0] out_ui_plus_expr_FU_32_32_32_163_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428769;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428575;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428783;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428804;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428825;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428846;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428867;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428888;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428594;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428615;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428636;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428657;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428678;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428699;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428720;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428741;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_164_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428762;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_165_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428563;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_165_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428565;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_165_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428899;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_166_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428570;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428578;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428788;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428809;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428830;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428851;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428872;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428893;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428599;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428620;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428641;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428662;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428683;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428704;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428725;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428746;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_167_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428767;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_168_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428584;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_168_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428588;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_169_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428589;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_170_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428605;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_170_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428609;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_171_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428610;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_172_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428626;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_172_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428630;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_173_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428631;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_174_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428647;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_174_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428651;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_175_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428652;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_176_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428668;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_176_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428672;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_177_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428673;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_178_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428689;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_178_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428693;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_179_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428694;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_180_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428710;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_180_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428714;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_181_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428715;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_182_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428731;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_182_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428735;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_183_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428736;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_184_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428752;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_184_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428756;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_185_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428757;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_186_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428773;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_186_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428777;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_187_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428778;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_188_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428794;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_188_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428798;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_189_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428799;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_190_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428815;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_190_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428819;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_191_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428820;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_192_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428836;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_192_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428840;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_193_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428841;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_194_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428857;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_194_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428861;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_195_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428862;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_196_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428878;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_196_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428882;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_197_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428883;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429804;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429876;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429883;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429890;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429897;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429904;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429911;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429813;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429820;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429827;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429834;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429841;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429848;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429855;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429862;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_198_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429869;
  wire [31:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire s_done_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564_P0;
  wire s_done_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566_P0;
  wire s_done_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800_P0;
  
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0),
    .in1(out_reg_1_reg_1),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_165_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428563));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_107_reg_0_0_0_0 (.out1(out_MUX_107_reg_0_0_0_0),
    .sel(selector_MUX_107_reg_0_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_162_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428901),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0),
    .in1(out_reg_3_reg_3),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_165_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428565));
  MUX_GATE #(.BITSIZE_in1(1024),
    .BITSIZE_in2(1024),
    .BITSIZE_out1(1024)) MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0),
    .in1(out_reg_7_reg_7),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i26_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428898));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) UUdata_converter_FU_uu_conv_0 (.out1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in1(out_conv_out_const_0_1_32));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b0)) const_0 (.out1(out_const_0));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b1)) const_1 (.out1(out_const_1));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1001000000)) const_10 (.out1(out_const_10));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1001100000)) const_11 (.out1(out_const_11));
  constant_value #(.BITSIZE_out1(8),
    .value(8'b10100000)) const_12 (.out1(out_const_12));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b101000000)) const_13 (.out1(out_const_13));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1010000000)) const_14 (.out1(out_const_14));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1010100000)) const_15 (.out1(out_const_15));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b101100000)) const_16 (.out1(out_const_16));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1011000000)) const_17 (.out1(out_const_17));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1011100000)) const_18 (.out1(out_const_18));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1100000)) const_19 (.out1(out_const_19));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b100000)) const_2 (.out1(out_const_2));
  constant_value #(.BITSIZE_out1(8),
    .value(8'b11000000)) const_20 (.out1(out_const_20));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b110000000)) const_21 (.out1(out_const_21));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1100000000)) const_22 (.out1(out_const_22));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1100100000)) const_23 (.out1(out_const_23));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b110100000)) const_24 (.out1(out_const_24));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1101000000)) const_25 (.out1(out_const_25));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1101100000)) const_26 (.out1(out_const_26));
  constant_value #(.BITSIZE_out1(3),
    .value(3'b111)) const_27 (.out1(out_const_27));
  constant_value #(.BITSIZE_out1(8),
    .value(8'b11100000)) const_28 (.out1(out_const_28));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b111000000)) const_29 (.out1(out_const_29));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1000000)) const_3 (.out1(out_const_3));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1110000000)) const_30 (.out1(out_const_30));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1110100000)) const_31 (.out1(out_const_31));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b111100000)) const_32 (.out1(out_const_32));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1111000000)) const_33 (.out1(out_const_33));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1111100000)) const_34 (.out1(out_const_34));
  constant_value #(.BITSIZE_out1(32),
    .value(32'b11111111111111111111111111111111)) const_35 (.out1(out_const_35));
  constant_value #(.BITSIZE_out1(8),
    .value(8'b10000000)) const_4 (.out1(out_const_4));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b100000000)) const_5 (.out1(out_const_5));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1000000000)) const_6 (.out1(out_const_6));
  constant_value #(.BITSIZE_out1(11),
    .value(11'b10000000000)) const_7 (.out1(out_const_7));
  constant_value #(.BITSIZE_out1(10),
    .value(10'b1000100000)) const_8 (.out1(out_const_8));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b100100000)) const_9 (.out1(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428563 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_165_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428563),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_129_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429724));
  A_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564 (.done_port({s_done_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564_P0}),
    .out1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564),
    ._A_TREADY(_A_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564}),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428565 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_165_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428565),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_129_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429724));
  B_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566 (.done_port({s_done_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566_P0}),
    .out1(out_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566),
    ._B_TREADY(_B_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566}),
    .in1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0),
    ._B_TDATA(_B_TDATA),
    ._B_TVALID(_B_TVALID));
  UUdata_converter_FU #(.BITSIZE_in1(1024),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428567 (.out1(out_UUdata_converter_FU_3_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428567),
    .in1(out_reg_2_reg_2));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428568 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428568),
    .in1(out_UUdata_converter_FU_3_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428567),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428569 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428569),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429804),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428570 (.out1(out_ui_rshift_expr_FU_64_0_64_166_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428570),
    .in1(out_reg_4_reg_4),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428571 (.out1(out_UUdata_converter_FU_4_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428571),
    .in1(out_ui_rshift_expr_FU_64_0_64_166_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428570));
  UUdata_converter_FU #(.BITSIZE_in1(1024),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428572 (.out1(out_UUdata_converter_FU_5_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428572),
    .in1(out_reg_4_reg_4));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428573 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428573),
    .in1(out_UUdata_converter_FU_5_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428572),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428574 (.out1(out_ui_bit_ior_expr_FU_0_64_64_106_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428574),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429810),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428568));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428575 (.out1(out_ui_plus_expr_FU_64_64_64_164_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428575),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_106_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428574),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428573));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428576 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428576),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428575),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428577 (.out1(out_UUdata_converter_FU_6_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428577),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428576));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428578 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428578),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428575),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428579 (.out1(out_UUdata_converter_FU_7_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428579),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428578));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428580 (.out1(out_ui_plus_expr_FU_32_32_32_163_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428580),
    .in1(out_UUdata_converter_FU_4_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428571),
    .in2(out_UUdata_converter_FU_7_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428579));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428581 (.out1(out_UUdata_converter_FU_8_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428581),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428580));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428582 (.out1(out_ui_lshift_expr_FU_64_0_64_130_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428582),
    .in1(out_UUdata_converter_FU_8_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428581),
    .in2(out_const_2));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428583 (.out1(out_ui_bit_ior_expr_FU_0_64_64_107_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428583),
    .in1(out_ui_lshift_expr_FU_64_0_64_130_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428582),
    .in2(out_UUdata_converter_FU_6_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428577));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(7),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428584 (.out1(out_ui_rshift_expr_FU_64_0_64_168_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428584),
    .in1(out_reg_2_reg_2),
    .in2(out_const_3));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428585 (.out1(out_UUdata_converter_FU_9_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428585),
    .in1(out_ui_rshift_expr_FU_64_0_64_168_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428584));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428586 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428586),
    .in1(out_UUdata_converter_FU_9_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428585),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428587 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428587),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429813),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(7),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428588 (.out1(out_ui_rshift_expr_FU_64_0_64_168_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428588),
    .in1(out_reg_4_reg_4),
    .in2(out_const_3));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(7),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428589 (.out1(out_ui_rshift_expr_FU_64_0_64_169_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428589),
    .in1(out_reg_4_reg_4),
    .in2(out_const_19));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428590 (.out1(out_UUdata_converter_FU_10_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428590),
    .in1(out_ui_rshift_expr_FU_64_0_64_169_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428589));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428591 (.out1(out_UUdata_converter_FU_11_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428591),
    .in1(out_ui_rshift_expr_FU_64_0_64_168_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428588));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428592 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428592),
    .in1(out_UUdata_converter_FU_11_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428591),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428593 (.out1(out_ui_bit_ior_expr_FU_0_64_64_108_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428593),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429817),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428586));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428594 (.out1(out_ui_plus_expr_FU_64_64_64_164_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428594),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_108_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428593),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428592));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428595 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428595),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428594),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428596 (.out1(out_UUdata_converter_FU_12_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428596),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428595));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(7),
    .BITSIZE_out1(96),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428597 (.out1(out_ui_lshift_expr_FU_64_0_64_131_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428597),
    .in1(out_UUdata_converter_FU_12_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428596),
    .in2(out_const_3));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(96),
    .BITSIZE_in2(64),
    .BITSIZE_out1(96)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428598 (.out1(out_ui_bit_ior_expr_FU_0_64_64_109_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428598),
    .in1(out_ui_lshift_expr_FU_64_0_64_131_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428597),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_107_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428583));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428599 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428599),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428594),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428600 (.out1(out_UUdata_converter_FU_13_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428600),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428599));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428601 (.out1(out_ui_plus_expr_FU_32_32_32_163_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428601),
    .in1(out_UUdata_converter_FU_10_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428590),
    .in2(out_UUdata_converter_FU_13_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428600));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428602 (.out1(out_UUdata_converter_FU_14_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428602),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428601));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(7),
    .BITSIZE_out1(128),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428603 (.out1(out_ui_lshift_expr_FU_64_0_64_132_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428603),
    .in1(out_UUdata_converter_FU_14_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428602),
    .in2(out_const_19));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(128),
    .BITSIZE_in2(96),
    .BITSIZE_out1(128)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428604 (.out1(out_ui_bit_ior_expr_FU_0_64_64_110_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428604),
    .in1(out_ui_lshift_expr_FU_64_0_64_132_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428603),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_109_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428598));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(8),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428605 (.out1(out_ui_rshift_expr_FU_64_0_64_170_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428605),
    .in1(out_reg_2_reg_2),
    .in2(out_const_4));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428606 (.out1(out_UUdata_converter_FU_15_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428606),
    .in1(out_ui_rshift_expr_FU_64_0_64_170_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428605));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428607 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428607),
    .in1(out_UUdata_converter_FU_15_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428606),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428608 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428608),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429820),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(8),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428609 (.out1(out_ui_rshift_expr_FU_64_0_64_170_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428609),
    .in1(out_reg_4_reg_4),
    .in2(out_const_4));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(8),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428610 (.out1(out_ui_rshift_expr_FU_64_0_64_171_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428610),
    .in1(out_reg_4_reg_4),
    .in2(out_const_12));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428611 (.out1(out_UUdata_converter_FU_16_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428611),
    .in1(out_ui_rshift_expr_FU_64_0_64_171_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428610));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428612 (.out1(out_UUdata_converter_FU_17_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428612),
    .in1(out_ui_rshift_expr_FU_64_0_64_170_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428609));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428613 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428613),
    .in1(out_UUdata_converter_FU_17_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428612),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428614 (.out1(out_ui_bit_ior_expr_FU_0_64_64_111_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428614),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429824),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428607));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428615 (.out1(out_ui_plus_expr_FU_64_64_64_164_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428615),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_111_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428614),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428613));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428616 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428616),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428615),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428617 (.out1(out_UUdata_converter_FU_18_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428617),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428616));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(8),
    .BITSIZE_out1(160),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428618 (.out1(out_ui_lshift_expr_FU_64_0_64_133_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428618),
    .in1(out_UUdata_converter_FU_18_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428617),
    .in2(out_const_4));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(160),
    .BITSIZE_in2(128),
    .BITSIZE_out1(160)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428619 (.out1(out_ui_bit_ior_expr_FU_0_64_64_112_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428619),
    .in1(out_ui_lshift_expr_FU_64_0_64_133_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428618),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_110_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428604));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428620 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428620),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428615),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428621 (.out1(out_UUdata_converter_FU_19_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428621),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428620));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428622 (.out1(out_ui_plus_expr_FU_32_32_32_163_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428622),
    .in1(out_UUdata_converter_FU_16_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428611),
    .in2(out_UUdata_converter_FU_19_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428621));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428623 (.out1(out_UUdata_converter_FU_20_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428623),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428622));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(8),
    .BITSIZE_out1(192),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428624 (.out1(out_ui_lshift_expr_FU_64_0_64_134_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428624),
    .in1(out_UUdata_converter_FU_20_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428623),
    .in2(out_const_12));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(192),
    .BITSIZE_in2(160),
    .BITSIZE_out1(192)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428625 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428625),
    .in1(out_ui_lshift_expr_FU_64_0_64_134_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428624),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_112_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428619));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(8),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428626 (.out1(out_ui_rshift_expr_FU_64_0_64_172_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428626),
    .in1(out_reg_2_reg_2),
    .in2(out_const_20));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428627 (.out1(out_UUdata_converter_FU_21_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428627),
    .in1(out_ui_rshift_expr_FU_64_0_64_172_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428626));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428628 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428628),
    .in1(out_UUdata_converter_FU_21_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428627),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428629 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428629),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429827),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(8),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428630 (.out1(out_ui_rshift_expr_FU_64_0_64_172_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428630),
    .in1(out_reg_4_reg_4),
    .in2(out_const_20));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(8),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428631 (.out1(out_ui_rshift_expr_FU_64_0_64_173_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428631),
    .in1(out_reg_4_reg_4),
    .in2(out_const_28));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428632 (.out1(out_UUdata_converter_FU_22_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428632),
    .in1(out_ui_rshift_expr_FU_64_0_64_173_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428631));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428633 (.out1(out_UUdata_converter_FU_23_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428633),
    .in1(out_ui_rshift_expr_FU_64_0_64_172_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428630));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428634 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428634),
    .in1(out_UUdata_converter_FU_23_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428633),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428635 (.out1(out_ui_bit_ior_expr_FU_0_64_64_113_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428635),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429831),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428628));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428636 (.out1(out_ui_plus_expr_FU_64_64_64_164_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428636),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_113_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428635),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428634));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428637 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428637),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428636),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428638 (.out1(out_UUdata_converter_FU_24_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428638),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428637));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(8),
    .BITSIZE_out1(224),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428639 (.out1(out_ui_lshift_expr_FU_64_0_64_135_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428639),
    .in1(out_UUdata_converter_FU_24_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428638),
    .in2(out_const_20));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(224),
    .BITSIZE_in2(192),
    .BITSIZE_out1(224)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428640 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428640),
    .in1(out_ui_lshift_expr_FU_64_0_64_135_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428639),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428625));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428641 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428641),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428636),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428642 (.out1(out_UUdata_converter_FU_25_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428642),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428641));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428643 (.out1(out_ui_plus_expr_FU_32_32_32_163_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428643),
    .in1(out_UUdata_converter_FU_22_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428632),
    .in2(out_UUdata_converter_FU_25_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428642));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428644 (.out1(out_UUdata_converter_FU_26_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428644),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428643));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(8),
    .BITSIZE_out1(256),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428645 (.out1(out_ui_lshift_expr_FU_64_0_64_136_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428645),
    .in1(out_UUdata_converter_FU_26_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428644),
    .in2(out_const_28));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(256),
    .BITSIZE_in2(224),
    .BITSIZE_out1(256)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428646 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428646),
    .in1(out_ui_lshift_expr_FU_64_0_64_136_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428645),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428640));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428647 (.out1(out_ui_rshift_expr_FU_64_0_64_174_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428647),
    .in1(out_reg_2_reg_2),
    .in2(out_const_5));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428648 (.out1(out_UUdata_converter_FU_27_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428648),
    .in1(out_ui_rshift_expr_FU_64_0_64_174_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428647));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428649 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428649),
    .in1(out_UUdata_converter_FU_27_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428648),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428650 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428650),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429834),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428651 (.out1(out_ui_rshift_expr_FU_64_0_64_174_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428651),
    .in1(out_reg_4_reg_4),
    .in2(out_const_5));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428652 (.out1(out_ui_rshift_expr_FU_64_0_64_175_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428652),
    .in1(out_reg_4_reg_4),
    .in2(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428653 (.out1(out_UUdata_converter_FU_28_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428653),
    .in1(out_ui_rshift_expr_FU_64_0_64_175_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428652));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428654 (.out1(out_UUdata_converter_FU_29_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428654),
    .in1(out_ui_rshift_expr_FU_64_0_64_174_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428651));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428655 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428655),
    .in1(out_UUdata_converter_FU_29_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428654),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428656 (.out1(out_ui_bit_ior_expr_FU_0_64_64_114_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428656),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429838),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428649));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428657 (.out1(out_ui_plus_expr_FU_64_64_64_164_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428657),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_114_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428656),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428655));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428658 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428658),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428657),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428659 (.out1(out_UUdata_converter_FU_30_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428659),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428658));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(9),
    .BITSIZE_out1(288),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428660 (.out1(out_ui_lshift_expr_FU_64_0_64_137_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428660),
    .in1(out_UUdata_converter_FU_30_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428659),
    .in2(out_const_5));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(288),
    .BITSIZE_in2(256),
    .BITSIZE_out1(288)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428661 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428661),
    .in1(out_ui_lshift_expr_FU_64_0_64_137_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428660),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428646));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428662 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428662),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428657),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428663 (.out1(out_UUdata_converter_FU_31_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428663),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428662));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428664 (.out1(out_ui_plus_expr_FU_32_32_32_163_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428664),
    .in1(out_UUdata_converter_FU_28_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428653),
    .in2(out_UUdata_converter_FU_31_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428663));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428665 (.out1(out_UUdata_converter_FU_32_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428665),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428664));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(9),
    .BITSIZE_out1(320),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428666 (.out1(out_ui_lshift_expr_FU_64_0_64_138_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428666),
    .in1(out_UUdata_converter_FU_32_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428665),
    .in2(out_const_9));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(320),
    .BITSIZE_in2(288),
    .BITSIZE_out1(320)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428667 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428667),
    .in1(out_ui_lshift_expr_FU_64_0_64_138_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428666),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428661));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428668 (.out1(out_ui_rshift_expr_FU_64_0_64_176_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428668),
    .in1(out_reg_2_reg_2),
    .in2(out_const_13));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428669 (.out1(out_UUdata_converter_FU_33_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428669),
    .in1(out_ui_rshift_expr_FU_64_0_64_176_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428668));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428670 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428670),
    .in1(out_UUdata_converter_FU_33_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428669),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428671 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428671),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429841),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428672 (.out1(out_ui_rshift_expr_FU_64_0_64_176_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428672),
    .in1(out_reg_4_reg_4),
    .in2(out_const_13));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428673 (.out1(out_ui_rshift_expr_FU_64_0_64_177_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428673),
    .in1(out_reg_4_reg_4),
    .in2(out_const_16));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428674 (.out1(out_UUdata_converter_FU_34_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428674),
    .in1(out_ui_rshift_expr_FU_64_0_64_177_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428673));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428675 (.out1(out_UUdata_converter_FU_35_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428675),
    .in1(out_ui_rshift_expr_FU_64_0_64_176_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428672));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428676 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i16_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428676),
    .in1(out_UUdata_converter_FU_35_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428675),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428677 (.out1(out_ui_bit_ior_expr_FU_0_64_64_115_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428677),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429845),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428670));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428678 (.out1(out_ui_plus_expr_FU_64_64_64_164_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428678),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_115_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428677),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i16_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428676));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428679 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i17_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428679),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428678),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428680 (.out1(out_UUdata_converter_FU_36_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428680),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i17_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428679));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(9),
    .BITSIZE_out1(352),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428681 (.out1(out_ui_lshift_expr_FU_64_0_64_139_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428681),
    .in1(out_UUdata_converter_FU_36_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428680),
    .in2(out_const_13));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(352),
    .BITSIZE_in2(320),
    .BITSIZE_out1(352)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428682 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428682),
    .in1(out_ui_lshift_expr_FU_64_0_64_139_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428681),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428667));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428683 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428683),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428678),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428684 (.out1(out_UUdata_converter_FU_37_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428684),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428683));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428685 (.out1(out_ui_plus_expr_FU_32_32_32_163_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428685),
    .in1(out_UUdata_converter_FU_34_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428674),
    .in2(out_UUdata_converter_FU_37_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428684));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428686 (.out1(out_UUdata_converter_FU_38_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428686),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428685));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(9),
    .BITSIZE_out1(384),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428687 (.out1(out_ui_lshift_expr_FU_64_0_64_140_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428687),
    .in1(out_UUdata_converter_FU_38_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428686),
    .in2(out_const_16));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(384),
    .BITSIZE_in2(352),
    .BITSIZE_out1(384)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428688 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428688),
    .in1(out_ui_lshift_expr_FU_64_0_64_140_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428687),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428682));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428689 (.out1(out_ui_rshift_expr_FU_64_0_64_178_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428689),
    .in1(out_reg_2_reg_2),
    .in2(out_const_21));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428690 (.out1(out_UUdata_converter_FU_39_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428690),
    .in1(out_ui_rshift_expr_FU_64_0_64_178_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428689));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428691 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i18_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428691),
    .in1(out_UUdata_converter_FU_39_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428690),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428692 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428692),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429848),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428693 (.out1(out_ui_rshift_expr_FU_64_0_64_178_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428693),
    .in1(out_reg_4_reg_4),
    .in2(out_const_21));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428694 (.out1(out_ui_rshift_expr_FU_64_0_64_179_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428694),
    .in1(out_reg_4_reg_4),
    .in2(out_const_24));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428695 (.out1(out_UUdata_converter_FU_40_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428695),
    .in1(out_ui_rshift_expr_FU_64_0_64_179_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428694));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428696 (.out1(out_UUdata_converter_FU_41_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428696),
    .in1(out_ui_rshift_expr_FU_64_0_64_178_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428693));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428697 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i19_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428697),
    .in1(out_UUdata_converter_FU_41_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428696),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428698 (.out1(out_ui_bit_ior_expr_FU_0_64_64_116_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428698),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429852),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i18_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428691));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428699 (.out1(out_ui_plus_expr_FU_64_64_64_164_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428699),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_116_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428698),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i19_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428697));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428700 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i20_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428700),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428699),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428701 (.out1(out_UUdata_converter_FU_42_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428701),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i20_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428700));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(9),
    .BITSIZE_out1(416),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428702 (.out1(out_ui_lshift_expr_FU_64_0_64_141_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428702),
    .in1(out_UUdata_converter_FU_42_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428701),
    .in2(out_const_21));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(416),
    .BITSIZE_in2(384),
    .BITSIZE_out1(416)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428703 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428703),
    .in1(out_ui_lshift_expr_FU_64_0_64_141_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428702),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428688));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428704 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428704),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428699),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428705 (.out1(out_UUdata_converter_FU_43_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428705),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428704));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428706 (.out1(out_ui_plus_expr_FU_32_32_32_163_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428706),
    .in1(out_UUdata_converter_FU_40_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428695),
    .in2(out_UUdata_converter_FU_43_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428705));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428707 (.out1(out_UUdata_converter_FU_44_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428707),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428706));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(9),
    .BITSIZE_out1(448),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428708 (.out1(out_ui_lshift_expr_FU_64_0_64_142_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428708),
    .in1(out_UUdata_converter_FU_44_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428707),
    .in2(out_const_24));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(448),
    .BITSIZE_in2(416),
    .BITSIZE_out1(448)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428709 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428709),
    .in1(out_ui_lshift_expr_FU_64_0_64_142_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428708),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428703));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428710 (.out1(out_ui_rshift_expr_FU_64_0_64_180_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428710),
    .in1(out_reg_2_reg_2),
    .in2(out_const_29));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428711 (.out1(out_UUdata_converter_FU_45_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428711),
    .in1(out_ui_rshift_expr_FU_64_0_64_180_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428710));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428712 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i21_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428712),
    .in1(out_UUdata_converter_FU_45_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428711),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428713 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428713),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429855),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428714 (.out1(out_ui_rshift_expr_FU_64_0_64_180_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428714),
    .in1(out_reg_4_reg_4),
    .in2(out_const_29));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428715 (.out1(out_ui_rshift_expr_FU_64_0_64_181_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428715),
    .in1(out_reg_4_reg_4),
    .in2(out_const_32));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428716 (.out1(out_UUdata_converter_FU_46_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428716),
    .in1(out_ui_rshift_expr_FU_64_0_64_181_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428715));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428717 (.out1(out_UUdata_converter_FU_47_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428717),
    .in1(out_ui_rshift_expr_FU_64_0_64_180_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428714));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428718 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i22_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428718),
    .in1(out_UUdata_converter_FU_47_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428717),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428719 (.out1(out_ui_bit_ior_expr_FU_0_64_64_117_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428719),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429859),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i21_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428712));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428720 (.out1(out_ui_plus_expr_FU_64_64_64_164_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428720),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_117_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428719),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i22_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428718));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428721 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i23_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428721),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428720),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428722 (.out1(out_UUdata_converter_FU_48_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428722),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i23_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428721));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(9),
    .BITSIZE_out1(480),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428723 (.out1(out_ui_lshift_expr_FU_64_0_64_143_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428723),
    .in1(out_UUdata_converter_FU_48_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428722),
    .in2(out_const_29));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(480),
    .BITSIZE_in2(448),
    .BITSIZE_out1(480)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428724 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428724),
    .in1(out_ui_lshift_expr_FU_64_0_64_143_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428723),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428709));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428725 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428725),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428720),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428726 (.out1(out_UUdata_converter_FU_49_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428726),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428725));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428727 (.out1(out_ui_plus_expr_FU_32_32_32_163_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428727),
    .in1(out_UUdata_converter_FU_46_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428716),
    .in2(out_UUdata_converter_FU_49_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428726));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428728 (.out1(out_UUdata_converter_FU_50_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428728),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428727));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(9),
    .BITSIZE_out1(512),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428729 (.out1(out_ui_lshift_expr_FU_64_0_64_144_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428729),
    .in1(out_UUdata_converter_FU_50_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428728),
    .in2(out_const_32));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(480),
    .BITSIZE_out1(512)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428730 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428730),
    .in1(out_ui_lshift_expr_FU_64_0_64_144_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428729),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428724));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428731 (.out1(out_ui_rshift_expr_FU_64_0_64_182_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428731),
    .in1(out_reg_2_reg_2),
    .in2(out_const_6));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428732 (.out1(out_UUdata_converter_FU_51_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428732),
    .in1(out_ui_rshift_expr_FU_64_0_64_182_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428731));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428733 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i24_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428733),
    .in1(out_UUdata_converter_FU_51_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428732),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428734 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428734),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429862),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428735 (.out1(out_ui_rshift_expr_FU_64_0_64_182_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428735),
    .in1(out_reg_4_reg_4),
    .in2(out_const_6));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428736 (.out1(out_ui_rshift_expr_FU_64_0_64_183_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428736),
    .in1(out_reg_4_reg_4),
    .in2(out_const_8));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428737 (.out1(out_UUdata_converter_FU_52_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428737),
    .in1(out_ui_rshift_expr_FU_64_0_64_183_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428736));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428738 (.out1(out_UUdata_converter_FU_53_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428738),
    .in1(out_ui_rshift_expr_FU_64_0_64_182_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428735));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428739 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i25_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428739),
    .in1(out_UUdata_converter_FU_53_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428738),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428740 (.out1(out_ui_bit_ior_expr_FU_0_64_64_118_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428740),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429866),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i24_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428733));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428741 (.out1(out_ui_plus_expr_FU_64_64_64_164_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428741),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_118_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428740),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i25_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428739));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428742 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i26_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428742),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428741),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428743 (.out1(out_UUdata_converter_FU_54_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428743),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i26_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428742));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(544),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428744 (.out1(out_ui_lshift_expr_FU_64_0_64_145_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428744),
    .in1(out_UUdata_converter_FU_54_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428743),
    .in2(out_const_6));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(544),
    .BITSIZE_in2(512),
    .BITSIZE_out1(544)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428745 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428745),
    .in1(out_ui_lshift_expr_FU_64_0_64_145_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428744),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428730));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428746 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428746),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428741),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428747 (.out1(out_UUdata_converter_FU_55_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428747),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428746));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428748 (.out1(out_ui_plus_expr_FU_32_32_32_163_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428748),
    .in1(out_UUdata_converter_FU_52_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428737),
    .in2(out_UUdata_converter_FU_55_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428747));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428749 (.out1(out_UUdata_converter_FU_56_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428749),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428748));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(576),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428750 (.out1(out_ui_lshift_expr_FU_64_0_64_146_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428750),
    .in1(out_UUdata_converter_FU_56_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428749),
    .in2(out_const_8));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(576),
    .BITSIZE_in2(544),
    .BITSIZE_out1(576)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428751 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428751),
    .in1(out_ui_lshift_expr_FU_64_0_64_146_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428750),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428745));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428752 (.out1(out_ui_rshift_expr_FU_64_0_64_184_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428752),
    .in1(out_reg_2_reg_2),
    .in2(out_const_10));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428753 (.out1(out_UUdata_converter_FU_57_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428753),
    .in1(out_ui_rshift_expr_FU_64_0_64_184_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428752));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428754 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i27_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428754),
    .in1(out_UUdata_converter_FU_57_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428753),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428755 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428755),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429869),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428756 (.out1(out_ui_rshift_expr_FU_64_0_64_184_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428756),
    .in1(out_reg_4_reg_4),
    .in2(out_const_10));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428757 (.out1(out_ui_rshift_expr_FU_64_0_64_185_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428757),
    .in1(out_reg_4_reg_4),
    .in2(out_const_11));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428758 (.out1(out_UUdata_converter_FU_58_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428758),
    .in1(out_ui_rshift_expr_FU_64_0_64_185_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428757));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428759 (.out1(out_UUdata_converter_FU_59_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428759),
    .in1(out_ui_rshift_expr_FU_64_0_64_184_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428756));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428760 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i28_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428760),
    .in1(out_UUdata_converter_FU_59_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428759),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428761 (.out1(out_ui_bit_ior_expr_FU_0_64_64_119_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428761),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429873),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i27_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428754));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428762 (.out1(out_ui_plus_expr_FU_64_64_64_164_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428762),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_119_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428761),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i28_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428760));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428763 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i29_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428763),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428762),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428764 (.out1(out_UUdata_converter_FU_60_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428764),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i29_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428763));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(608),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428765 (.out1(out_ui_lshift_expr_FU_64_0_64_147_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428765),
    .in1(out_UUdata_converter_FU_60_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428764),
    .in2(out_const_10));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(608),
    .BITSIZE_in2(576),
    .BITSIZE_out1(608)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428766 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428766),
    .in1(out_ui_lshift_expr_FU_64_0_64_147_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428765),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428751));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428767 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428767),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428762),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428768 (.out1(out_UUdata_converter_FU_61_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428768),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428767));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428769 (.out1(out_ui_plus_expr_FU_32_32_32_163_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428769),
    .in1(out_UUdata_converter_FU_58_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428758),
    .in2(out_UUdata_converter_FU_61_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428768));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428770 (.out1(out_UUdata_converter_FU_62_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428770),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428769));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(640),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428771 (.out1(out_ui_lshift_expr_FU_64_0_64_148_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428771),
    .in1(out_UUdata_converter_FU_62_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428770),
    .in2(out_const_11));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(640),
    .BITSIZE_in2(608),
    .BITSIZE_out1(640)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428772 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428772),
    .in1(out_ui_lshift_expr_FU_64_0_64_148_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428771),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428766));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428773 (.out1(out_ui_rshift_expr_FU_64_0_64_186_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428773),
    .in1(out_reg_2_reg_2),
    .in2(out_const_14));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428774 (.out1(out_UUdata_converter_FU_63_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428774),
    .in1(out_ui_rshift_expr_FU_64_0_64_186_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428773));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428775 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i30_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428775),
    .in1(out_UUdata_converter_FU_63_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428774),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428776 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428776),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429876),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428777 (.out1(out_ui_rshift_expr_FU_64_0_64_186_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428777),
    .in1(out_reg_4_reg_4),
    .in2(out_const_14));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428778 (.out1(out_ui_rshift_expr_FU_64_0_64_187_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428778),
    .in1(out_reg_4_reg_4),
    .in2(out_const_15));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428779 (.out1(out_UUdata_converter_FU_64_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428779),
    .in1(out_ui_rshift_expr_FU_64_0_64_187_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428778));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428780 (.out1(out_UUdata_converter_FU_65_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428780),
    .in1(out_ui_rshift_expr_FU_64_0_64_186_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428777));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428781 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i31_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428781),
    .in1(out_UUdata_converter_FU_65_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428780),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428782 (.out1(out_ui_bit_ior_expr_FU_0_64_64_120_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428782),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429880),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i30_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428775));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428783 (.out1(out_ui_plus_expr_FU_64_64_64_164_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428783),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_120_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428782),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i31_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428781));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428784 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i32_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428784),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428783),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428785 (.out1(out_UUdata_converter_FU_66_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428785),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i32_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428784));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(672),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428786 (.out1(out_ui_lshift_expr_FU_64_0_64_149_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428786),
    .in1(out_UUdata_converter_FU_66_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428785),
    .in2(out_const_14));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(672),
    .BITSIZE_in2(640),
    .BITSIZE_out1(672)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428787 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428787),
    .in1(out_ui_lshift_expr_FU_64_0_64_149_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428786),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428772));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428788 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428788),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428783),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428789 (.out1(out_UUdata_converter_FU_67_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428789),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428788));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428790 (.out1(out_ui_plus_expr_FU_32_32_32_163_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428790),
    .in1(out_UUdata_converter_FU_64_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428779),
    .in2(out_UUdata_converter_FU_67_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428789));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428791 (.out1(out_UUdata_converter_FU_68_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428791),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428790));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(704),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428792 (.out1(out_ui_lshift_expr_FU_64_0_64_150_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428792),
    .in1(out_UUdata_converter_FU_68_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428791),
    .in2(out_const_15));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(704),
    .BITSIZE_in2(672),
    .BITSIZE_out1(704)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428793 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i16_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428793),
    .in1(out_ui_lshift_expr_FU_64_0_64_150_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428792),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428787));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428794 (.out1(out_ui_rshift_expr_FU_64_0_64_188_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428794),
    .in1(out_reg_2_reg_2),
    .in2(out_const_17));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428795 (.out1(out_UUdata_converter_FU_69_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428795),
    .in1(out_ui_rshift_expr_FU_64_0_64_188_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428794));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428796 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i33_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428796),
    .in1(out_UUdata_converter_FU_69_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428795),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428797 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428797),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429883),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428798 (.out1(out_ui_rshift_expr_FU_64_0_64_188_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428798),
    .in1(out_reg_4_reg_4),
    .in2(out_const_17));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428799 (.out1(out_ui_rshift_expr_FU_64_0_64_189_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428799),
    .in1(out_reg_4_reg_4),
    .in2(out_const_18));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428800 (.out1(out_UUdata_converter_FU_70_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428800),
    .in1(out_ui_rshift_expr_FU_64_0_64_189_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428799));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428801 (.out1(out_UUdata_converter_FU_71_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428801),
    .in1(out_ui_rshift_expr_FU_64_0_64_188_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428798));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428802 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i34_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428802),
    .in1(out_UUdata_converter_FU_71_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428801),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428803 (.out1(out_ui_bit_ior_expr_FU_0_64_64_121_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428803),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429887),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i33_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428796));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428804 (.out1(out_ui_plus_expr_FU_64_64_64_164_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428804),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_121_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428803),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i34_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428802));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428805 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i35_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428805),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428804),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428806 (.out1(out_UUdata_converter_FU_72_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428806),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i35_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428805));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(736),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428807 (.out1(out_ui_lshift_expr_FU_64_0_64_151_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428807),
    .in1(out_UUdata_converter_FU_72_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428806),
    .in2(out_const_17));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(736),
    .BITSIZE_in2(704),
    .BITSIZE_out1(736)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428808 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i17_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428808),
    .in1(out_ui_lshift_expr_FU_64_0_64_151_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428807),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i16_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428793));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428809 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428809),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428804),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428810 (.out1(out_UUdata_converter_FU_73_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428810),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428809));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428811 (.out1(out_ui_plus_expr_FU_32_32_32_163_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428811),
    .in1(out_UUdata_converter_FU_70_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428800),
    .in2(out_UUdata_converter_FU_73_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428810));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428812 (.out1(out_UUdata_converter_FU_74_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428812),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428811));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(768),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428813 (.out1(out_ui_lshift_expr_FU_64_0_64_152_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428813),
    .in1(out_UUdata_converter_FU_74_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428812),
    .in2(out_const_18));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(768),
    .BITSIZE_in2(736),
    .BITSIZE_out1(768)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428814 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i18_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428814),
    .in1(out_ui_lshift_expr_FU_64_0_64_152_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428813),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i17_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428808));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428815 (.out1(out_ui_rshift_expr_FU_64_0_64_190_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428815),
    .in1(out_reg_2_reg_2),
    .in2(out_const_22));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428816 (.out1(out_UUdata_converter_FU_75_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428816),
    .in1(out_ui_rshift_expr_FU_64_0_64_190_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428815));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428817 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i36_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428817),
    .in1(out_UUdata_converter_FU_75_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428816),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428818 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428818),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429890),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428819 (.out1(out_ui_rshift_expr_FU_64_0_64_190_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428819),
    .in1(out_reg_4_reg_4),
    .in2(out_const_22));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428820 (.out1(out_ui_rshift_expr_FU_64_0_64_191_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428820),
    .in1(out_reg_4_reg_4),
    .in2(out_const_23));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428821 (.out1(out_UUdata_converter_FU_76_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428821),
    .in1(out_ui_rshift_expr_FU_64_0_64_191_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428820));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428822 (.out1(out_UUdata_converter_FU_77_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428822),
    .in1(out_ui_rshift_expr_FU_64_0_64_190_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428819));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428823 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i37_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428823),
    .in1(out_UUdata_converter_FU_77_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428822),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428824 (.out1(out_ui_bit_ior_expr_FU_0_64_64_122_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428824),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429894),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i36_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428817));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428825 (.out1(out_ui_plus_expr_FU_64_64_64_164_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428825),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_122_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428824),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i37_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428823));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428826 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i38_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428826),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428825),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428827 (.out1(out_UUdata_converter_FU_78_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428827),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i38_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428826));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(800),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428828 (.out1(out_ui_lshift_expr_FU_64_0_64_153_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428828),
    .in1(out_UUdata_converter_FU_78_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428827),
    .in2(out_const_22));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(800),
    .BITSIZE_in2(768),
    .BITSIZE_out1(800)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428829 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i19_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428829),
    .in1(out_ui_lshift_expr_FU_64_0_64_153_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428828),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i18_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428814));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428830 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428830),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428825),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428831 (.out1(out_UUdata_converter_FU_79_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428831),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428830));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428832 (.out1(out_ui_plus_expr_FU_32_32_32_163_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428832),
    .in1(out_UUdata_converter_FU_76_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428821),
    .in2(out_UUdata_converter_FU_79_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428831));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428833 (.out1(out_UUdata_converter_FU_80_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428833),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428832));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(832),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428834 (.out1(out_ui_lshift_expr_FU_64_0_64_154_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428834),
    .in1(out_UUdata_converter_FU_80_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428833),
    .in2(out_const_23));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(832),
    .BITSIZE_in2(800),
    .BITSIZE_out1(832)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428835 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i20_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428835),
    .in1(out_ui_lshift_expr_FU_64_0_64_154_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428834),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i19_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428829));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428836 (.out1(out_ui_rshift_expr_FU_64_0_64_192_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428836),
    .in1(out_reg_2_reg_2),
    .in2(out_const_25));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428837 (.out1(out_UUdata_converter_FU_81_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428837),
    .in1(out_ui_rshift_expr_FU_64_0_64_192_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428836));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428838 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i39_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428838),
    .in1(out_UUdata_converter_FU_81_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428837),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428839 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428839),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429897),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428840 (.out1(out_ui_rshift_expr_FU_64_0_64_192_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428840),
    .in1(out_reg_4_reg_4),
    .in2(out_const_25));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428841 (.out1(out_ui_rshift_expr_FU_64_0_64_193_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428841),
    .in1(out_reg_4_reg_4),
    .in2(out_const_26));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428842 (.out1(out_UUdata_converter_FU_82_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428842),
    .in1(out_ui_rshift_expr_FU_64_0_64_193_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428841));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428843 (.out1(out_UUdata_converter_FU_83_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428843),
    .in1(out_ui_rshift_expr_FU_64_0_64_192_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428840));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428844 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i40_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428844),
    .in1(out_UUdata_converter_FU_83_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428843),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428845 (.out1(out_ui_bit_ior_expr_FU_0_64_64_123_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428845),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429901),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i39_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428838));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428846 (.out1(out_ui_plus_expr_FU_64_64_64_164_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428846),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_123_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428845),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i40_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428844));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428847 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i41_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428847),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428846),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428848 (.out1(out_UUdata_converter_FU_84_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428848),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i41_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428847));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(864),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428849 (.out1(out_ui_lshift_expr_FU_64_0_64_155_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428849),
    .in1(out_UUdata_converter_FU_84_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428848),
    .in2(out_const_25));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(864),
    .BITSIZE_in2(832),
    .BITSIZE_out1(864)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428850 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i21_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428850),
    .in1(out_ui_lshift_expr_FU_64_0_64_155_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428849),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i20_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428835));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428851 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428851),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428846),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428852 (.out1(out_UUdata_converter_FU_85_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428852),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428851));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428853 (.out1(out_ui_plus_expr_FU_32_32_32_163_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428853),
    .in1(out_UUdata_converter_FU_82_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428842),
    .in2(out_UUdata_converter_FU_85_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428852));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428854 (.out1(out_UUdata_converter_FU_86_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428854),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428853));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(896),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428855 (.out1(out_ui_lshift_expr_FU_64_0_64_156_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428855),
    .in1(out_UUdata_converter_FU_86_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428854),
    .in2(out_const_26));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(896),
    .BITSIZE_in2(864),
    .BITSIZE_out1(896)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428856 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i22_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428856),
    .in1(out_ui_lshift_expr_FU_64_0_64_156_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428855),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i21_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428850));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428857 (.out1(out_ui_rshift_expr_FU_64_0_64_194_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428857),
    .in1(out_reg_2_reg_2),
    .in2(out_const_30));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428858 (.out1(out_UUdata_converter_FU_87_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428858),
    .in1(out_ui_rshift_expr_FU_64_0_64_194_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428857));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428859 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i42_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428859),
    .in1(out_UUdata_converter_FU_87_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428858),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428860 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428860),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429904),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428861 (.out1(out_ui_rshift_expr_FU_64_0_64_194_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428861),
    .in1(out_reg_4_reg_4),
    .in2(out_const_30));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428862 (.out1(out_ui_rshift_expr_FU_64_0_64_195_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428862),
    .in1(out_reg_4_reg_4),
    .in2(out_const_31));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428863 (.out1(out_UUdata_converter_FU_88_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428863),
    .in1(out_ui_rshift_expr_FU_64_0_64_195_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428862));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428864 (.out1(out_UUdata_converter_FU_89_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428864),
    .in1(out_ui_rshift_expr_FU_64_0_64_194_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428861));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428865 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i43_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428865),
    .in1(out_UUdata_converter_FU_89_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428864),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428866 (.out1(out_ui_bit_ior_expr_FU_0_64_64_124_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428866),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429908),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i42_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428859));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428867 (.out1(out_ui_plus_expr_FU_64_64_64_164_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428867),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_124_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428866),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i43_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428865));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428868 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i44_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428868),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428867),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428869 (.out1(out_UUdata_converter_FU_90_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428869),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i44_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428868));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(928),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428870 (.out1(out_ui_lshift_expr_FU_64_0_64_157_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428870),
    .in1(out_UUdata_converter_FU_90_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428869),
    .in2(out_const_30));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(928),
    .BITSIZE_in2(896),
    .BITSIZE_out1(928)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428871 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i23_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428871),
    .in1(out_ui_lshift_expr_FU_64_0_64_157_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428870),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i22_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428856));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428872 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428872),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428867),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428873 (.out1(out_UUdata_converter_FU_91_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428873),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428872));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428874 (.out1(out_ui_plus_expr_FU_32_32_32_163_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428874),
    .in1(out_UUdata_converter_FU_88_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428863),
    .in2(out_UUdata_converter_FU_91_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428873));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428875 (.out1(out_UUdata_converter_FU_92_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428875),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428874));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(960),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428876 (.out1(out_ui_lshift_expr_FU_64_0_64_158_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428876),
    .in1(out_UUdata_converter_FU_92_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428875),
    .in2(out_const_31));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(960),
    .BITSIZE_in2(928),
    .BITSIZE_out1(960)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428877 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i24_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428877),
    .in1(out_ui_lshift_expr_FU_64_0_64_158_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428876),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i23_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428871));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428878 (.out1(out_ui_rshift_expr_FU_64_0_64_196_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428878),
    .in1(out_reg_2_reg_2),
    .in2(out_const_33));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428879 (.out1(out_UUdata_converter_FU_93_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428879),
    .in1(out_ui_rshift_expr_FU_64_0_64_196_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428878));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428880 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i45_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428880),
    .in1(out_UUdata_converter_FU_93_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428879),
    .in2(out_const_35));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428881 (.out1(out_ui_bit_and_expr_FU_32_0_32_105_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428881),
    .in1(out_ui_rshift_expr_FU_64_0_64_198_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429911),
    .in2(out_const_35));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428882 (.out1(out_ui_rshift_expr_FU_64_0_64_196_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428882),
    .in1(out_reg_4_reg_4),
    .in2(out_const_33));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(32),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428883 (.out1(out_ui_rshift_expr_FU_64_0_64_197_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428883),
    .in1(out_reg_4_reg_4),
    .in2(out_const_34));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428884 (.out1(out_UUdata_converter_FU_94_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428884),
    .in1(out_ui_rshift_expr_FU_64_0_64_197_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428883));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428885 (.out1(out_UUdata_converter_FU_95_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428885),
    .in1(out_ui_rshift_expr_FU_64_0_64_196_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428882));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428886 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i46_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428886),
    .in1(out_UUdata_converter_FU_95_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428885),
    .in2(out_const_35));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428887 (.out1(out_ui_bit_ior_expr_FU_0_64_64_125_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428887),
    .in1(out_ui_lshift_expr_FU_64_0_64_161_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429915),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i45_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428880));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428888 (.out1(out_ui_plus_expr_FU_64_64_64_164_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428888),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_125_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428887),
    .in2(out_ui_bit_and_expr_FU_32_0_32_104_i46_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428886));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428889 (.out1(out_ui_bit_and_expr_FU_32_0_32_104_i47_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428889),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428888),
    .in2(out_const_35));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428890 (.out1(out_UUdata_converter_FU_96_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428890),
    .in1(out_ui_bit_and_expr_FU_32_0_32_104_i47_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428889));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(992),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428891 (.out1(out_ui_lshift_expr_FU_64_0_64_159_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428891),
    .in1(out_UUdata_converter_FU_96_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428890),
    .in2(out_const_33));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(992),
    .BITSIZE_in2(960),
    .BITSIZE_out1(992)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428892 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i25_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428892),
    .in1(out_ui_lshift_expr_FU_64_0_64_159_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428891),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i24_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428877));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428893 (.out1(out_ui_rshift_expr_FU_64_0_64_167_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428893),
    .in1(out_ui_plus_expr_FU_64_64_64_164_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428888),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428894 (.out1(out_UUdata_converter_FU_97_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428894),
    .in1(out_ui_rshift_expr_FU_64_0_64_167_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428893));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428895 (.out1(out_ui_plus_expr_FU_32_32_32_163_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428895),
    .in1(out_UUdata_converter_FU_94_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428884),
    .in2(out_UUdata_converter_FU_97_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428894));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428896 (.out1(out_UUdata_converter_FU_98_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428896),
    .in1(out_ui_plus_expr_FU_32_32_32_163_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428895));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(10),
    .BITSIZE_out1(1024),
    .PRECISION(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428897 (.out1(out_ui_lshift_expr_FU_64_0_64_160_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428897),
    .in1(out_UUdata_converter_FU_98_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428896),
    .in2(out_const_34));
  ui_bit_xor_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(992),
    .BITSIZE_out1(1024)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428898 (.out1(out_ui_bit_xor_expr_FU_64_64_64_126_i26_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428898),
    .in1(out_ui_lshift_expr_FU_64_0_64_160_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428897),
    .in2(out_ui_bit_xor_expr_FU_64_64_64_126_i25_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428892));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428899 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_165_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428899),
    .in1(in_port_C),
    .in2(out_ui_lshift_expr_FU_32_0_32_129_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429724));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428901 (.out1(out_ui_plus_expr_FU_32_0_32_162_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428901),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428902 (.out1(out_UUdata_converter_FU_99_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428902),
    .in1(out_ui_eq_expr_FU_32_32_32_128_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429739));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903 (.out1(out_read_cond_FU_100_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903),
    .in1(out_reg_6_reg_6));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429703 (.out1(out_UUdata_converter_FU_102_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429703),
    .in1(out_ui_eq_expr_FU_32_0_32_127_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429746));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704 (.out1(out_read_cond_FU_103_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704),
    .in1(out_UUdata_converter_FU_102_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429703));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(3),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429724 (.out1(out_ui_lshift_expr_FU_32_0_32_129_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429724),
    .in1(out_reg_0_reg_0),
    .in2(out_const_27));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429739 (.out1(out_ui_eq_expr_FU_32_32_32_128_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429739),
    .in1(out_ui_plus_expr_FU_32_0_32_162_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428901),
    .in2(in_port_loop_count));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429746 (.out1(out_ui_eq_expr_FU_32_0_32_127_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429746),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  C_bambu_artificial_ParmMgr_Write_axis_modgen #(.BITSIZE_in1(11),
    .BITSIZE_in2(1024),
    .BITSIZE_in3(32)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800 (.done_port({s_done_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800_P0}),
    ._C_TDATA(_C_TDATA),
    ._C_TVALID(_C_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800}),
    .in1(out_const_7),
    .in2(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0),
    .in3(out_reg_5_reg_5),
    ._C_TREADY(_C_TREADY));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429804 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429804),
    .in1(out_UUdata_converter_FU_3_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428567),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429810 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429810),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428569),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429813 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429813),
    .in1(out_UUdata_converter_FU_9_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428585),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429817 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429817),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428587),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429820 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429820),
    .in1(out_UUdata_converter_FU_15_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428606),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429824 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429824),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428608),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429827 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429827),
    .in1(out_UUdata_converter_FU_21_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428627),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429831 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429831),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i3_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428629),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429834 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429834),
    .in1(out_UUdata_converter_FU_27_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428648),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429838 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429838),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i4_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428650),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429841 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429841),
    .in1(out_UUdata_converter_FU_33_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428669),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429845 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429845),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i5_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428671),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429848 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429848),
    .in1(out_UUdata_converter_FU_39_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428690),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429852 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429852),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i6_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428692),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429855 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429855),
    .in1(out_UUdata_converter_FU_45_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428711),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429859 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429859),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i7_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428713),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429862 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429862),
    .in1(out_UUdata_converter_FU_51_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428732),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429866 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429866),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i8_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428734),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429869 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429869),
    .in1(out_UUdata_converter_FU_57_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428753),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429873 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429873),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i9_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428755),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429876 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429876),
    .in1(out_UUdata_converter_FU_63_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428774),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429880 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429880),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i10_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428776),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429883 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429883),
    .in1(out_UUdata_converter_FU_69_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428795),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429887 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429887),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i11_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428797),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429890 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429890),
    .in1(out_UUdata_converter_FU_75_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428816),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429894 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429894),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i12_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428818),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429897 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429897),
    .in1(out_UUdata_converter_FU_81_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428837),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429901 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429901),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i13_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428839),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429904 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429904),
    .in1(out_UUdata_converter_FU_87_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428858),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429908 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429908),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i14_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428860),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429911 (.out1(out_ui_rshift_expr_FU_64_0_64_198_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429911),
    .in1(out_UUdata_converter_FU_93_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428879),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429915 (.out1(out_ui_lshift_expr_FU_64_0_64_161_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429915),
    .in1(out_ui_bit_and_expr_FU_32_0_32_105_i15_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428881),
    .in2(out_const_2));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_0 (.sop(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_0),
    .ops({s_done_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564_P0,
      s_done_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566_P0}));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_107_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_165_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428563),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(1024),
    .BITSIZE_out1(1024)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_165_i1_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428565),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(1024),
    .BITSIZE_out1(1024)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_165_i2_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428899),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_99_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428902),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(1024),
    .BITSIZE_out1(1024)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_bit_xor_expr_FU_64_64_64_126_i26_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428898),
    .wenable(wrenable_reg_7));
  // io-signal post fix
  assign OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903 = out_read_cond_FU_100_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903;
  assign OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704 = out_read_cond_FU_103_i0_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704;
  assign OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564 = s_done_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566 = s_done_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566_P0;
  assign OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800 = s_done_fu__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800_P0;

endmodule

// FSM based controller description for _Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j(done_port,
  selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564,
  selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566,
  selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0,
  selector_MUX_107_reg_0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0,
  muenable_mu_S_0,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903,
  OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704,
  OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564,
  OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566,
  OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800,
  OUT_mu_S_0_MULTI_UNBOUNDED_0,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903;
  input OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704;
  input OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564;
  input OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566;
  input OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800;
  input OUT_mu_S_0_MULTI_UNBOUNDED_0;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564;
  output selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566;
  output selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0;
  output selector_MUX_107_reg_0_0_0_0;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0;
  output muenable_mu_S_0;
  output wrenable_reg_0;
  output wrenable_reg_1;
  output wrenable_reg_2;
  output wrenable_reg_3;
  output wrenable_reg_4;
  output wrenable_reg_5;
  output wrenable_reg_6;
  output wrenable_reg_7;
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
  reg selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564;
  reg selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566;
  reg selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0;
  reg selector_MUX_107_reg_0_0_0_0;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0;
  reg muenable_mu_S_0;
  reg wrenable_reg_0;
  reg wrenable_reg_1;
  reg wrenable_reg_2;
  reg wrenable_reg_3;
  reg wrenable_reg_4;
  reg wrenable_reg_5;
  reg wrenable_reg_6;
  reg wrenable_reg_7;
  
  always @(posedge clock)
    if (reset == 1'b0) _present_state <= S_5;
    else _present_state <= _next_state;
  
  always @(*)
  begin
    done_port = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0 = 1'b0;
    selector_MUX_107_reg_0_0_0_0 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0 = 1'b0;
    muenable_mu_S_0 = 1'b0;
    wrenable_reg_0 = 1'b0;
    wrenable_reg_1 = 1'b0;
    wrenable_reg_2 = 1'b0;
    wrenable_reg_3 = 1'b0;
    wrenable_reg_4 = 1'b0;
    wrenable_reg_5 = 1'b0;
    wrenable_reg_6 = 1'b0;
    wrenable_reg_7 = 1'b0;
    case (_present_state)
      S_5 :
        if(start_port == 1'b1)
        begin
          wrenable_reg_0 = 1'b1;
          if (OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704 == 1'b0)
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
          selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566 = 1'b1;
          selector_MUX_107_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564;
          wrenable_reg_3 = 1'b1;
          wrenable_reg_4 = OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566;
          wrenable_reg_5 = 1'b1;
          wrenable_reg_6 = 1'b1;
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0 = 1'b1;
          wrenable_reg_2 = OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564;
          wrenable_reg_4 = OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566;
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
          selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800 = 1'b1;
          wrenable_reg_7 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800 == 1'b0)
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
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800 == 1'b0)
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
          if (OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903 == 1'b0)
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

// Top component for _Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j(clock,
  reset,
  start_port,
  done_port,
  A,
  B,
  C,
  loop_count,
  _A_TDATA,
  _A_TVALID,
  _B_TDATA,
  _B_TVALID,
  _C_TREADY,
  _A_TREADY,
  _B_TREADY,
  _C_TDATA,
  _C_TVALID);
  // IN
  input clock;
  input reset;
  input start_port;
  input [31:0] A;
  input [31:0] B;
  input [31:0] C;
  input [31:0] loop_count;
  input [1023:0] _A_TDATA;
  input _A_TVALID;
  input [1023:0] _B_TDATA;
  input _B_TVALID;
  input _C_TREADY;
  // OUT
  output done_port;
  output _A_TREADY;
  output _B_TREADY;
  output [1023:0] _C_TDATA;
  output _C_TVALID;
  // Component and signal declarations
  wire OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903;
  wire OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704;
  wire OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564;
  wire OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566;
  wire OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800;
  wire OUT_mu_S_0_MULTI_UNBOUNDED_0;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire muenable_mu_S_0;
  wire selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564;
  wire selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566;
  wire selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0;
  wire selector_MUX_107_reg_0_0_0_0;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0;
  wire wrenable_reg_0;
  wire wrenable_reg_1;
  wire wrenable_reg_2;
  wire wrenable_reg_3;
  wire wrenable_reg_4;
  wire wrenable_reg_5;
  wire wrenable_reg_6;
  wire wrenable_reg_7;
  
  controller__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564(selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564),
    .selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566(selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566),
    .selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800(selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0),
    .selector_MUX_107_reg_0_0_0_0(selector_MUX_107_reg_0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0),
    .muenable_mu_S_0(muenable_mu_S_0),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903(OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903),
    .OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704(OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704),
    .OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564(OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564),
    .OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566(OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566),
    .OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800(OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800),
    .OUT_mu_S_0_MULTI_UNBOUNDED_0(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j Datapath_i (._A_TREADY(_A_TREADY),
    ._B_TREADY(_B_TREADY),
    ._C_TDATA(_C_TDATA),
    ._C_TVALID(_C_TVALID),
    .OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903(OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428903),
    .OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704(OUT_CONDITION__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429704),
    .OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564(OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564),
    .OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566(OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566),
    .OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800(OUT_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800),
    .OUT_mu_S_0_MULTI_UNBOUNDED_0(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .in_port_A(A),
    .in_port_B(B),
    .in_port_C(C),
    .in_port_loop_count(loop_count),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID),
    ._B_TDATA(_B_TDATA),
    ._B_TVALID(_B_TVALID),
    ._C_TREADY(_C_TREADY),
    .selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564(selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428564),
    .selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566(selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_428566),
    .selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800(selector_IN_UNBOUNDED__Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_428532_429800),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_199_i0_0_0_0),
    .selector_MUX_107_reg_0_0_0_0(selector_MUX_107_reg_0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_200_i0_0_0_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_201_i0_1_0_0),
    .muenable_mu_S_0(muenable_mu_S_0),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7));
  flipflop_AR #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) done_delayed_REG (.out1(done_delayed_REG_signal_out),
    .clock(clock),
    .reset(reset),
    .in1(done_delayed_REG_signal_in));
  // io-signal post fix
  assign done_port = done_delayed_REG_signal_out;

endmodule

// Minimal interface for function: _Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j(clock,
  reset,
  start_port,
  A_TDATA,
  B_TDATA,
  loop_count,
  A_TVALID,
  B_TVALID,
  C_TREADY,
  done_port,
  A_TREADY,
  B_TREADY,
  C_TDATA,
  C_TVALID);
  // IN
  input clock;
  input reset;
  input start_port;
  input [1023:0] A_TDATA;
  input [1023:0] B_TDATA;
  input [31:0] loop_count;
  input A_TVALID;
  input B_TVALID;
  input C_TREADY;
  // OUT
  output done_port;
  output A_TREADY;
  output B_TREADY;
  output [1023:0] C_TDATA;
  output C_TVALID;
  // Component and signal declarations
  
  __Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j __Z6vecaddPK6ac_intILi1024ELb0EES2_PS0_j_i0 (.done_port(done_port),
    ._A_TREADY(A_TREADY),
    ._B_TREADY(B_TREADY),
    ._C_TDATA(C_TDATA),
    ._C_TVALID(C_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port(start_port),
    .A(32'b00000000000000000000000000000000),
    .B(32'b00000000000000000000000000000000),
    .C(32'b00000000000000000000000000000000),
    .loop_count(loop_count),
    ._A_TDATA(A_TDATA),
    ._A_TVALID(A_TVALID),
    ._B_TDATA(B_TDATA),
    ._B_TVALID(B_TVALID),
    ._C_TREADY(C_TREADY));

endmodule


