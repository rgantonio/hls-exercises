// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-03T13:00:03
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=vecadd --top-rtldesign-name=vecadd --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER --simulate --simulator=VERILATOR --generate-tb=/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/src/tb_vecadd.cpp --tb-extra-gcc-options=-DDUT=vecadd -DCFG_LOOP_COUNT=512 --tb-param-size=A:4096,B:4096,C:4096 -DDATA_T=int64_t -DSIZE_N=512 -DBAMBU_LANES=1 --std=c++14 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include/bambu -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/vectors/n512 /users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/bambu_unopt_n512_w1_proj/vecadd.cpp 
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
module ui_lt_expr_FU(in1,
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
  assign out1 = in1 < in2;
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
    BITSIZE_out1=64;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [63:0] _B_TDATA;
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
  input _C_TREADY;
  // OUT
  output [0:0] done_port;
  output out1;
  output [63:0] _C_TDATA;
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

// Datapath RTL description for _Z6vecaddPKxS0_Pxj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z6vecaddPKxS0_Pxj(clock,
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
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1,
  selector_MUX_19_reg_0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1,
  selector_MUX_35_reg_23_0_0_0,
  selector_MUX_35_reg_23_0_0_1,
  selector_MUX_36_reg_24_0_0_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0,
  muenable_mu_S_0,
  muenable_mu_S_10,
  muenable_mu_S_12,
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
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428574,
  OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428739,
  OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428747,
  OUT_MULTIIF__Z6vecaddPKxS0_Pxj_428532_428981,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949,
  OUT_mu_S_0_MULTI_UNBOUNDED_0,
  OUT_mu_S_10_MULTI_UNBOUNDED_0,
  OUT_mu_S_12_MULTI_UNBOUNDED_0,
  OUT_mu_S_6_MULTI_UNBOUNDED_0,
  OUT_mu_S_8_MULTI_UNBOUNDED_0);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_A;
  input [31:0] in_port_B;
  input [31:0] in_port_C;
  input [31:0] in_port_loop_count;
  input [63:0] _A_TDATA;
  input _A_TVALID;
  input [63:0] _B_TDATA;
  input _B_TVALID;
  input _C_TREADY;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944;
  input selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1;
  input selector_MUX_19_reg_0_0_0_0;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1;
  input selector_MUX_35_reg_23_0_0_0;
  input selector_MUX_35_reg_23_0_0_1;
  input selector_MUX_36_reg_24_0_0_0;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2;
  input selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0;
  input selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0;
  input selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1;
  input selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2;
  input selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0;
  input muenable_mu_S_0;
  input muenable_mu_S_10;
  input muenable_mu_S_12;
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
  input wrenable_reg_4;
  input wrenable_reg_5;
  input wrenable_reg_6;
  input wrenable_reg_7;
  input wrenable_reg_8;
  input wrenable_reg_9;
  // OUT
  output _A_TREADY;
  output _B_TREADY;
  output [63:0] _C_TDATA;
  output _C_TVALID;
  output OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428574;
  output OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428739;
  output OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428747;
  output [1:0] OUT_MULTIIF__Z6vecaddPKxS0_Pxj_428532_428981;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944;
  output OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949;
  output OUT_mu_S_0_MULTI_UNBOUNDED_0;
  output OUT_mu_S_10_MULTI_UNBOUNDED_0;
  output OUT_mu_S_12_MULTI_UNBOUNDED_0;
  output OUT_mu_S_6_MULTI_UNBOUNDED_0;
  output OUT_mu_S_8_MULTI_UNBOUNDED_0;
  // Component and signal declarations
  wire [63:0] out_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0;
  wire [63:0] out_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1;
  wire [31:0] out_MUX_19_reg_0_0_0_0;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1;
  wire [31:0] out_MUX_35_reg_23_0_0_0;
  wire [31:0] out_MUX_35_reg_23_0_0_1;
  wire [31:0] out_MUX_36_reg_24_0_0_0;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2;
  wire [63:0] out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0;
  wire [31:0] out_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0;
  wire [31:0] out_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1;
  wire [31:0] out_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2;
  wire [31:0] out_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0;
  wire out_UUdata_converter_FU_22_i0_fu__Z6vecaddPKxS0_Pxj_428532_428746;
  wire out_UUdata_converter_FU_24_i0_fu__Z6vecaddPKxS0_Pxj_428532_428754;
  wire out_UUdata_converter_FU_25_i0_fu__Z6vecaddPKxS0_Pxj_428532_428742;
  wire out_UUdata_converter_FU_26_i0_fu__Z6vecaddPKxS0_Pxj_428532_428738;
  wire out_UUdata_converter_FU_4_i0_fu__Z6vecaddPKxS0_Pxj_428532_428573;
  wire out_const_0;
  wire out_const_1;
  wire [1:0] out_const_2;
  wire [2:0] out_const_3;
  wire [6:0] out_const_4;
  wire [1:0] out_const_5;
  wire [29:0] out_const_6;
  wire [31:0] out_conv_out_const_0_1_32;
  wire [1:0] out_multi_read_cond_FU_27_i0_fu__Z6vecaddPKxS0_Pxj_428532_428981;
  wire out_read_cond_FU_12_i0_fu__Z6vecaddPKxS0_Pxj_428532_428739;
  wire out_read_cond_FU_23_i0_fu__Z6vecaddPKxS0_Pxj_428532_428747;
  wire out_read_cond_FU_5_i0_fu__Z6vecaddPKxS0_Pxj_428532_428574;
  wire [31:0] out_reg_0_reg_0;
  wire [31:0] out_reg_10_reg_10;
  wire [31:0] out_reg_11_reg_11;
  wire [31:0] out_reg_12_reg_12;
  wire [31:0] out_reg_13_reg_13;
  wire [31:0] out_reg_14_reg_14;
  wire [31:0] out_reg_15_reg_15;
  wire [31:0] out_reg_16_reg_16;
  wire [31:0] out_reg_17_reg_17;
  wire out_reg_18_reg_18;
  wire [63:0] out_reg_19_reg_19;
  wire [1:0] out_reg_1_reg_1;
  wire [63:0] out_reg_20_reg_20;
  wire [63:0] out_reg_21_reg_21;
  wire [63:0] out_reg_22_reg_22;
  wire [31:0] out_reg_23_reg_23;
  wire [31:0] out_reg_24_reg_24;
  wire [31:0] out_reg_25_reg_25;
  wire [31:0] out_reg_26_reg_26;
  wire [31:0] out_reg_27_reg_27;
  wire [31:0] out_reg_28_reg_28;
  wire out_reg_29_reg_29;
  wire out_reg_2_reg_2;
  wire [63:0] out_reg_30_reg_30;
  wire [29:0] out_reg_3_reg_3;
  wire [31:0] out_reg_4_reg_4;
  wire [63:0] out_reg_5_reg_5;
  wire [63:0] out_reg_6_reg_6;
  wire [31:0] out_reg_7_reg_7;
  wire [31:0] out_reg_8_reg_8;
  wire [31:0] out_reg_9_reg_9;
  wire out_truth_and_expr_FU_1_1_1_28_i0_fu__Z6vecaddPKxS0_Pxj_428532_428987;
  wire out_truth_not_expr_FU_1_1_29_i0_fu__Z6vecaddPKxS0_Pxj_428532_428984;
  wire [29:0] out_ui_bit_and_expr_FU_32_0_32_30_i0_fu__Z6vecaddPKxS0_Pxj_428532_428751;
  wire [1:0] out_ui_bit_and_expr_FU_8_0_8_31_i0_fu__Z6vecaddPKxS0_Pxj_428532_428734;
  wire [28:0] out_ui_bit_ior_expr_FU_32_0_32_32_i0_fu__Z6vecaddPKxS0_Pxj_428532_428637;
  wire [28:0] out_ui_bit_ior_expr_FU_32_0_32_33_i0_fu__Z6vecaddPKxS0_Pxj_428532_428661;
  wire [28:0] out_ui_bit_ior_expr_FU_32_0_32_34_i0_fu__Z6vecaddPKxS0_Pxj_428532_428685;
  wire out_ui_eq_expr_FU_32_0_32_35_i0_fu__Z6vecaddPKxS0_Pxj_428532_428854;
  wire out_ui_eq_expr_FU_32_32_32_36_i0_fu__Z6vecaddPKxS0_Pxj_428532_428790;
  wire out_ui_eq_expr_FU_32_32_32_36_i1_fu__Z6vecaddPKxS0_Pxj_428532_428839;
  wire out_ui_eq_expr_FU_8_0_8_37_i0_fu__Z6vecaddPKxS0_Pxj_428532_428797;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_38_i0_fu__Z6vecaddPKxS0_Pxj_428532_428775;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_38_i1_fu__Z6vecaddPKxS0_Pxj_428532_428803;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_38_i2_fu__Z6vecaddPKxS0_Pxj_428532_428812;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_38_i3_fu__Z6vecaddPKxS0_Pxj_428532_428821;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_38_i4_fu__Z6vecaddPKxS0_Pxj_428532_428830;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_39_i0_fu__Z6vecaddPKxS0_Pxj_428532_428961;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_39_i1_fu__Z6vecaddPKxS0_Pxj_428532_428974;
  wire out_ui_lt_expr_FU_32_0_32_40_i0_fu__Z6vecaddPKxS0_Pxj_428532_428800;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_41_i0_fu__Z6vecaddPKxS0_Pxj_428532_428571;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_41_i1_fu__Z6vecaddPKxS0_Pxj_428532_428572;
  wire [29:0] out_ui_plus_expr_FU_32_0_32_42_i0_fu__Z6vecaddPKxS0_Pxj_428532_428958;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_43_i0_fu__Z6vecaddPKxS0_Pxj_428532_428568;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_43_i1_fu__Z6vecaddPKxS0_Pxj_428532_428612;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_43_i2_fu__Z6vecaddPKxS0_Pxj_428532_428640;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_43_i3_fu__Z6vecaddPKxS0_Pxj_428532_428664;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_43_i4_fu__Z6vecaddPKxS0_Pxj_428532_428688;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i0_fu__Z6vecaddPKxS0_Pxj_428532_428564;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i10_fu__Z6vecaddPKxS0_Pxj_428532_428671;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i11_fu__Z6vecaddPKxS0_Pxj_428532_428677;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i12_fu__Z6vecaddPKxS0_Pxj_428532_428681;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i13_fu__Z6vecaddPKxS0_Pxj_428532_428695;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i14_fu__Z6vecaddPKxS0_Pxj_428532_428701;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i1_fu__Z6vecaddPKxS0_Pxj_428532_428566;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i2_fu__Z6vecaddPKxS0_Pxj_428532_428569;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i3_fu__Z6vecaddPKxS0_Pxj_428532_428600;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i4_fu__Z6vecaddPKxS0_Pxj_428532_428619;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i5_fu__Z6vecaddPKxS0_Pxj_428532_428627;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i6_fu__Z6vecaddPKxS0_Pxj_428532_428633;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i7_fu__Z6vecaddPKxS0_Pxj_428532_428647;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i8_fu__Z6vecaddPKxS0_Pxj_428532_428653;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_44_i9_fu__Z6vecaddPKxS0_Pxj_428532_428657;
  wire [29:0] out_ui_rshift_expr_FU_32_0_32_45_i0_fu__Z6vecaddPKxS0_Pxj_428532_428953;
  wire [29:0] out_ui_rshift_expr_FU_32_0_32_45_i1_fu__Z6vecaddPKxS0_Pxj_428532_428964;
  wire [29:0] out_ui_rshift_expr_FU_32_0_32_45_i2_fu__Z6vecaddPKxS0_Pxj_428532_428967;
  wire [29:0] out_ui_rshift_expr_FU_32_0_32_45_i3_fu__Z6vecaddPKxS0_Pxj_428532_428970;
  wire [31:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_P0;
  wire s_done_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_P0;
  wire s_done_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_P0;
  wire s_start_port0;
  wire s_start_port1;
  wire s_start_port2;
  
  A_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(64)) A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0 (.done_port({s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_P0}),
    .out1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0),
    ._A_TREADY(_A_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port0}),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID));
  B_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(64)) B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0 (.done_port({s_done_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_P0}),
    .out1(out_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0),
    ._B_TREADY(_B_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port1}),
    .in1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1),
    ._B_TDATA(_B_TDATA),
    ._B_TVALID(_B_TVALID));
  C_bambu_artificial_ParmMgr_Write_axis_modgen #(.BITSIZE_in1(7),
    .BITSIZE_in2(64),
    .BITSIZE_in3(32)) C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0 (.done_port({s_done_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_P0}),
    ._C_TDATA(_C_TDATA),
    ._C_TVALID(_C_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port2}),
    .in1(out_const_4),
    .in2(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0),
    .in3(out_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0),
    ._C_TREADY(_C_TREADY));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0),
    .in1(out_reg_8_reg_8),
    .in2(out_reg_26_reg_26));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1),
    .in1(out_reg_17_reg_17),
    .in2(out_reg_14_reg_14));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2),
    .in1(out_reg_11_reg_11),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_44_i0_fu__Z6vecaddPKxS0_Pxj_428532_428564));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i5_fu__Z6vecaddPKxS0_Pxj_428532_428627),
    .in2(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1),
    .in2(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3),
    .in2(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_19_reg_0_0_0_0 (.out1(out_MUX_19_reg_0_0_0_0),
    .sel(selector_MUX_19_reg_0_0_0_0),
    .in1(out_ui_lshift_expr_FU_32_0_32_39_i0_fu__Z6vecaddPKxS0_Pxj_428532_428961),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0),
    .in1(out_reg_7_reg_7),
    .in2(out_reg_27_reg_27));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1),
    .in1(out_reg_16_reg_16),
    .in2(out_reg_13_reg_13));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2),
    .in1(out_reg_10_reg_10),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_44_i1_fu__Z6vecaddPKxS0_Pxj_428532_428566));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i4_fu__Z6vecaddPKxS0_Pxj_428532_428619),
    .in2(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0),
    .in1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1),
    .in2(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1),
    .in1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3),
    .in2(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_35_reg_23_0_0_0 (.out1(out_MUX_35_reg_23_0_0_0),
    .sel(selector_MUX_35_reg_23_0_0_0),
    .in1(out_reg_25_reg_25),
    .in2(out_reg_0_reg_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_35_reg_23_0_0_1 (.out1(out_MUX_35_reg_23_0_0_1),
    .sel(selector_MUX_35_reg_23_0_0_1),
    .in1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in2(out_MUX_35_reg_23_0_0_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_36_reg_24_0_0_0 (.out1(out_MUX_36_reg_24_0_0_0),
    .sel(selector_MUX_36_reg_24_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_41_i1_fu__Z6vecaddPKxS0_Pxj_428532_428572),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0),
    .in1(out_reg_30_reg_30),
    .in2(out_reg_22_reg_22));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1),
    .in1(out_reg_21_reg_21),
    .in2(out_reg_20_reg_20));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2),
    .in1(out_reg_19_reg_19),
    .in2(out_ui_plus_expr_FU_64_64_64_43_i0_fu__Z6vecaddPKxS0_Pxj_428532_428568));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3),
    .in1(out_ui_plus_expr_FU_64_64_64_43_i1_fu__Z6vecaddPKxS0_Pxj_428532_428612),
    .in2(out_ui_plus_expr_FU_64_64_64_43_i2_fu__Z6vecaddPKxS0_Pxj_428532_428640));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4),
    .in1(out_ui_plus_expr_FU_64_64_64_43_i3_fu__Z6vecaddPKxS0_Pxj_428532_428664),
    .in2(out_ui_plus_expr_FU_64_64_64_43_i4_fu__Z6vecaddPKxS0_Pxj_428532_428688));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0),
    .in1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0),
    .in2(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1),
    .in1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2),
    .in2(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2),
    .in1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4),
    .in2(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0 (.out1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0),
    .sel(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0),
    .in1(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1),
    .in2(out_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0 (.out1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0),
    .sel(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0),
    .in1(out_reg_9_reg_9),
    .in2(out_reg_4_reg_4));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1 (.out1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1),
    .sel(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1),
    .in1(out_reg_28_reg_28),
    .in2(out_reg_15_reg_15));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2 (.out1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2),
    .sel(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2),
    .in1(out_reg_12_reg_12),
    .in2(out_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0 (.out1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0),
    .sel(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0),
    .in1(out_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1),
    .in2(out_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) UUdata_converter_FU_uu_conv_0 (.out1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in1(out_conv_out_const_0_1_32));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b0)) const_0 (.out1(out_const_0));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b1)) const_1 (.out1(out_const_1));
  constant_value #(.BITSIZE_out1(2),
    .value(2'b10)) const_2 (.out1(out_const_2));
  constant_value #(.BITSIZE_out1(3),
    .value(3'b100)) const_3 (.out1(out_const_3));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1000000)) const_4 (.out1(out_const_4));
  constant_value #(.BITSIZE_out1(2),
    .value(2'b11)) const_5 (.out1(out_const_5));
  constant_value #(.BITSIZE_out1(30),
    .value(30'b111111111111111111111111111111)) const_6 (.out1(out_const_6));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428564 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i0_fu__Z6vecaddPKxS0_Pxj_428532_428564),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i0_fu__Z6vecaddPKxS0_Pxj_428532_428775));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428566 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i1_fu__Z6vecaddPKxS0_Pxj_428532_428566),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i0_fu__Z6vecaddPKxS0_Pxj_428532_428775));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPKxS0_Pxj_428532_428568 (.out1(out_ui_plus_expr_FU_64_64_64_43_i0_fu__Z6vecaddPKxS0_Pxj_428532_428568),
    .in1(out_reg_5_reg_5),
    .in2(out_reg_6_reg_6));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428569 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i2_fu__Z6vecaddPKxS0_Pxj_428532_428569),
    .in1(in_port_C),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i0_fu__Z6vecaddPKxS0_Pxj_428532_428775));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z6vecaddPKxS0_Pxj_428532_428571 (.out1(out_ui_plus_expr_FU_32_0_32_41_i0_fu__Z6vecaddPKxS0_Pxj_428532_428571),
    .in1(out_reg_23_reg_23),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z6vecaddPKxS0_Pxj_428532_428572 (.out1(out_ui_plus_expr_FU_32_0_32_41_i1_fu__Z6vecaddPKxS0_Pxj_428532_428572),
    .in1(out_reg_24_reg_24),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428573 (.out1(out_UUdata_converter_FU_4_i0_fu__Z6vecaddPKxS0_Pxj_428532_428573),
    .in1(out_ui_eq_expr_FU_32_32_32_36_i0_fu__Z6vecaddPKxS0_Pxj_428532_428790));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428574 (.out1(out_read_cond_FU_5_i0_fu__Z6vecaddPKxS0_Pxj_428532_428574),
    .in1(out_reg_29_reg_29));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428600 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i3_fu__Z6vecaddPKxS0_Pxj_428532_428600),
    .in1(in_port_C),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i1_fu__Z6vecaddPKxS0_Pxj_428532_428803));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPKxS0_Pxj_428532_428612 (.out1(out_ui_plus_expr_FU_64_64_64_43_i1_fu__Z6vecaddPKxS0_Pxj_428532_428612),
    .in1(out_reg_5_reg_5),
    .in2(out_reg_6_reg_6));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428619 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i4_fu__Z6vecaddPKxS0_Pxj_428532_428619),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i1_fu__Z6vecaddPKxS0_Pxj_428532_428803));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428627 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i5_fu__Z6vecaddPKxS0_Pxj_428532_428627),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i1_fu__Z6vecaddPKxS0_Pxj_428532_428803));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428633 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i6_fu__Z6vecaddPKxS0_Pxj_428532_428633),
    .in1(in_port_C),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i2_fu__Z6vecaddPKxS0_Pxj_428532_428812));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(29)) fu__Z6vecaddPKxS0_Pxj_428532_428637 (.out1(out_ui_bit_ior_expr_FU_32_0_32_32_i0_fu__Z6vecaddPKxS0_Pxj_428532_428637),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPKxS0_Pxj_428532_428640 (.out1(out_ui_plus_expr_FU_64_64_64_43_i2_fu__Z6vecaddPKxS0_Pxj_428532_428640),
    .in1(out_reg_5_reg_5),
    .in2(out_reg_6_reg_6));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428647 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i7_fu__Z6vecaddPKxS0_Pxj_428532_428647),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i2_fu__Z6vecaddPKxS0_Pxj_428532_428812));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428653 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i8_fu__Z6vecaddPKxS0_Pxj_428532_428653),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i2_fu__Z6vecaddPKxS0_Pxj_428532_428812));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428657 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i9_fu__Z6vecaddPKxS0_Pxj_428532_428657),
    .in1(in_port_C),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i3_fu__Z6vecaddPKxS0_Pxj_428532_428821));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(29)) fu__Z6vecaddPKxS0_Pxj_428532_428661 (.out1(out_ui_bit_ior_expr_FU_32_0_32_33_i0_fu__Z6vecaddPKxS0_Pxj_428532_428661),
    .in1(out_reg_0_reg_0),
    .in2(out_const_2));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPKxS0_Pxj_428532_428664 (.out1(out_ui_plus_expr_FU_64_64_64_43_i3_fu__Z6vecaddPKxS0_Pxj_428532_428664),
    .in1(out_reg_5_reg_5),
    .in2(out_reg_6_reg_6));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428671 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i10_fu__Z6vecaddPKxS0_Pxj_428532_428671),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i3_fu__Z6vecaddPKxS0_Pxj_428532_428821));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428677 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i11_fu__Z6vecaddPKxS0_Pxj_428532_428677),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i3_fu__Z6vecaddPKxS0_Pxj_428532_428821));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428681 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i12_fu__Z6vecaddPKxS0_Pxj_428532_428681),
    .in1(in_port_C),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i4_fu__Z6vecaddPKxS0_Pxj_428532_428830));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(29)) fu__Z6vecaddPKxS0_Pxj_428532_428685 (.out1(out_ui_bit_ior_expr_FU_32_0_32_34_i0_fu__Z6vecaddPKxS0_Pxj_428532_428685),
    .in1(out_reg_0_reg_0),
    .in2(out_const_5));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPKxS0_Pxj_428532_428688 (.out1(out_ui_plus_expr_FU_64_64_64_43_i4_fu__Z6vecaddPKxS0_Pxj_428532_428688),
    .in1(out_reg_5_reg_5),
    .in2(out_reg_6_reg_6));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428695 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i13_fu__Z6vecaddPKxS0_Pxj_428532_428695),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i4_fu__Z6vecaddPKxS0_Pxj_428532_428830));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPKxS0_Pxj_428532_428701 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_44_i14_fu__Z6vecaddPKxS0_Pxj_428532_428701),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_38_i4_fu__Z6vecaddPKxS0_Pxj_428532_428830));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(2)) fu__Z6vecaddPKxS0_Pxj_428532_428734 (.out1(out_ui_bit_and_expr_FU_8_0_8_31_i0_fu__Z6vecaddPKxS0_Pxj_428532_428734),
    .in1(in_port_loop_count),
    .in2(out_const_5));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428738 (.out1(out_UUdata_converter_FU_26_i0_fu__Z6vecaddPKxS0_Pxj_428532_428738),
    .in1(out_ui_eq_expr_FU_8_0_8_37_i0_fu__Z6vecaddPKxS0_Pxj_428532_428797));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428739 (.out1(out_read_cond_FU_12_i0_fu__Z6vecaddPKxS0_Pxj_428532_428739),
    .in1(out_reg_2_reg_2));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428742 (.out1(out_UUdata_converter_FU_25_i0_fu__Z6vecaddPKxS0_Pxj_428532_428742),
    .in1(out_ui_lt_expr_FU_32_0_32_40_i0_fu__Z6vecaddPKxS0_Pxj_428532_428800));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428746 (.out1(out_UUdata_converter_FU_22_i0_fu__Z6vecaddPKxS0_Pxj_428532_428746),
    .in1(out_ui_eq_expr_FU_32_32_32_36_i1_fu__Z6vecaddPKxS0_Pxj_428532_428839));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428747 (.out1(out_read_cond_FU_23_i0_fu__Z6vecaddPKxS0_Pxj_428532_428747),
    .in1(out_reg_18_reg_18));
  ui_bit_and_expr_FU #(.BITSIZE_in1(30),
    .BITSIZE_in2(30),
    .BITSIZE_out1(30)) fu__Z6vecaddPKxS0_Pxj_428532_428751 (.out1(out_ui_bit_and_expr_FU_32_0_32_30_i0_fu__Z6vecaddPKxS0_Pxj_428532_428751),
    .in1(out_ui_rshift_expr_FU_32_0_32_45_i3_fu__Z6vecaddPKxS0_Pxj_428532_428970),
    .in2(out_const_6));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428754 (.out1(out_UUdata_converter_FU_24_i0_fu__Z6vecaddPKxS0_Pxj_428532_428754),
    .in1(out_ui_eq_expr_FU_32_0_32_35_i0_fu__Z6vecaddPKxS0_Pxj_428532_428854));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z6vecaddPKxS0_Pxj_428532_428775 (.out1(out_ui_lshift_expr_FU_32_0_32_38_i0_fu__Z6vecaddPKxS0_Pxj_428532_428775),
    .in1(out_reg_23_reg_23),
    .in2(out_const_5));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428790 (.out1(out_ui_eq_expr_FU_32_32_32_36_i0_fu__Z6vecaddPKxS0_Pxj_428532_428790),
    .in1(out_ui_plus_expr_FU_32_0_32_41_i1_fu__Z6vecaddPKxS0_Pxj_428532_428572),
    .in2(out_reg_1_reg_1));
  ui_eq_expr_FU #(.BITSIZE_in1(2),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428797 (.out1(out_ui_eq_expr_FU_8_0_8_37_i0_fu__Z6vecaddPKxS0_Pxj_428532_428797),
    .in1(out_ui_bit_and_expr_FU_8_0_8_31_i0_fu__Z6vecaddPKxS0_Pxj_428532_428734),
    .in2(out_const_0));
  ui_lt_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(3),
    .BITSIZE_out1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428800 (.out1(out_ui_lt_expr_FU_32_0_32_40_i0_fu__Z6vecaddPKxS0_Pxj_428532_428800),
    .in1(in_port_loop_count),
    .in2(out_const_3));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z6vecaddPKxS0_Pxj_428532_428803 (.out1(out_ui_lshift_expr_FU_32_0_32_38_i1_fu__Z6vecaddPKxS0_Pxj_428532_428803),
    .in1(out_reg_0_reg_0),
    .in2(out_const_5));
  ui_lshift_expr_FU #(.BITSIZE_in1(29),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z6vecaddPKxS0_Pxj_428532_428812 (.out1(out_ui_lshift_expr_FU_32_0_32_38_i2_fu__Z6vecaddPKxS0_Pxj_428532_428812),
    .in1(out_ui_bit_ior_expr_FU_32_0_32_32_i0_fu__Z6vecaddPKxS0_Pxj_428532_428637),
    .in2(out_const_5));
  ui_lshift_expr_FU #(.BITSIZE_in1(29),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z6vecaddPKxS0_Pxj_428532_428821 (.out1(out_ui_lshift_expr_FU_32_0_32_38_i3_fu__Z6vecaddPKxS0_Pxj_428532_428821),
    .in1(out_ui_bit_ior_expr_FU_32_0_32_33_i0_fu__Z6vecaddPKxS0_Pxj_428532_428661),
    .in2(out_const_5));
  ui_lshift_expr_FU #(.BITSIZE_in1(29),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z6vecaddPKxS0_Pxj_428532_428830 (.out1(out_ui_lshift_expr_FU_32_0_32_38_i4_fu__Z6vecaddPKxS0_Pxj_428532_428830),
    .in1(out_ui_bit_ior_expr_FU_32_0_32_34_i0_fu__Z6vecaddPKxS0_Pxj_428532_428685),
    .in2(out_const_5));
  ui_eq_expr_FU #(.BITSIZE_in1(30),
    .BITSIZE_in2(30),
    .BITSIZE_out1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428839 (.out1(out_ui_eq_expr_FU_32_32_32_36_i1_fu__Z6vecaddPKxS0_Pxj_428532_428839),
    .in1(out_ui_rshift_expr_FU_32_0_32_45_i1_fu__Z6vecaddPKxS0_Pxj_428532_428964),
    .in2(out_reg_3_reg_3));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428854 (.out1(out_ui_eq_expr_FU_32_0_32_35_i0_fu__Z6vecaddPKxS0_Pxj_428532_428854),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(30),
    .PRECISION(32)) fu__Z6vecaddPKxS0_Pxj_428532_428953 (.out1(out_ui_rshift_expr_FU_32_0_32_45_i0_fu__Z6vecaddPKxS0_Pxj_428532_428953),
    .in1(out_reg_0_reg_0),
    .in2(out_const_2));
  ui_plus_expr_FU #(.BITSIZE_in1(30),
    .BITSIZE_in2(1),
    .BITSIZE_out1(30)) fu__Z6vecaddPKxS0_Pxj_428532_428958 (.out1(out_ui_plus_expr_FU_32_0_32_42_i0_fu__Z6vecaddPKxS0_Pxj_428532_428958),
    .in1(out_ui_rshift_expr_FU_32_0_32_45_i0_fu__Z6vecaddPKxS0_Pxj_428532_428953),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(30),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z6vecaddPKxS0_Pxj_428532_428961 (.out1(out_ui_lshift_expr_FU_32_0_32_39_i0_fu__Z6vecaddPKxS0_Pxj_428532_428961),
    .in1(out_ui_plus_expr_FU_32_0_32_42_i0_fu__Z6vecaddPKxS0_Pxj_428532_428958),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(30),
    .PRECISION(32)) fu__Z6vecaddPKxS0_Pxj_428532_428964 (.out1(out_ui_rshift_expr_FU_32_0_32_45_i1_fu__Z6vecaddPKxS0_Pxj_428532_428964),
    .in1(out_ui_lshift_expr_FU_32_0_32_39_i0_fu__Z6vecaddPKxS0_Pxj_428532_428961),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(30),
    .PRECISION(32)) fu__Z6vecaddPKxS0_Pxj_428532_428967 (.out1(out_ui_rshift_expr_FU_32_0_32_45_i2_fu__Z6vecaddPKxS0_Pxj_428532_428967),
    .in1(out_ui_lshift_expr_FU_32_0_32_39_i1_fu__Z6vecaddPKxS0_Pxj_428532_428974),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(30),
    .PRECISION(32)) fu__Z6vecaddPKxS0_Pxj_428532_428970 (.out1(out_ui_rshift_expr_FU_32_0_32_45_i3_fu__Z6vecaddPKxS0_Pxj_428532_428970),
    .in1(in_port_loop_count),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(30),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z6vecaddPKxS0_Pxj_428532_428974 (.out1(out_ui_lshift_expr_FU_32_0_32_39_i1_fu__Z6vecaddPKxS0_Pxj_428532_428974),
    .in1(out_ui_bit_and_expr_FU_32_0_32_30_i0_fu__Z6vecaddPKxS0_Pxj_428532_428751),
    .in2(out_const_2));
  multi_read_cond_FU #(.BITSIZE_in1(1),
    .PORTSIZE_in1(2),
    .BITSIZE_out1(2)) fu__Z6vecaddPKxS0_Pxj_428532_428981 (.out1(out_multi_read_cond_FU_27_i0_fu__Z6vecaddPKxS0_Pxj_428532_428981),
    .in1({out_truth_and_expr_FU_1_1_1_28_i0_fu__Z6vecaddPKxS0_Pxj_428532_428987,
      out_UUdata_converter_FU_24_i0_fu__Z6vecaddPKxS0_Pxj_428532_428754}));
  truth_not_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428984 (.out1(out_truth_not_expr_FU_1_1_29_i0_fu__Z6vecaddPKxS0_Pxj_428532_428984),
    .in1(out_UUdata_converter_FU_24_i0_fu__Z6vecaddPKxS0_Pxj_428532_428754));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPKxS0_Pxj_428532_428987 (.out1(out_truth_and_expr_FU_1_1_1_28_i0_fu__Z6vecaddPKxS0_Pxj_428532_428987),
    .in1(out_UUdata_converter_FU_25_i0_fu__Z6vecaddPKxS0_Pxj_428532_428742),
    .in2(out_truth_not_expr_FU_1_1_29_i0_fu__Z6vecaddPKxS0_Pxj_428532_428984));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_0 (.sop(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_0),
    .ops({s_done_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_P0,
      s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(3)) mu_S_10 (.sop(OUT_mu_S_10_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_10),
    .ops({s_done_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_P0,
      s_done_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_P0,
      s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(3)) mu_S_12 (.sop(OUT_mu_S_12_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_12),
    .ops({s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_P0,
      s_done_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_P0,
      s_done_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_6 (.sop(OUT_mu_S_6_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_6),
    .ops({s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_P0,
      s_done_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(3)) mu_S_8 (.sop(OUT_mu_S_8_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_8),
    .ops({s_done_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_P0,
      s_done_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_P0,
      s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_P0}));
  or or_or_start_port0( s_start_port0, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698);
  or or_or_start_port1( s_start_port1, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692);
  or or_or_start_port2( s_start_port2, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944, selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949);
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_19_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_SE #(.BITSIZE_in1(2),
    .BITSIZE_out1(2)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_bit_and_expr_FU_8_0_8_31_i0_fu__Z6vecaddPKxS0_Pxj_428532_428734),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_10 (.out1(out_reg_10_reg_10),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i7_fu__Z6vecaddPKxS0_Pxj_428532_428647),
    .wenable(wrenable_reg_10));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i8_fu__Z6vecaddPKxS0_Pxj_428532_428653),
    .wenable(wrenable_reg_11));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_12 (.out1(out_reg_12_reg_12),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i9_fu__Z6vecaddPKxS0_Pxj_428532_428657),
    .wenable(wrenable_reg_12));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_13 (.out1(out_reg_13_reg_13),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i10_fu__Z6vecaddPKxS0_Pxj_428532_428671),
    .wenable(wrenable_reg_13));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_14 (.out1(out_reg_14_reg_14),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i11_fu__Z6vecaddPKxS0_Pxj_428532_428677),
    .wenable(wrenable_reg_14));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_15 (.out1(out_reg_15_reg_15),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i12_fu__Z6vecaddPKxS0_Pxj_428532_428681),
    .wenable(wrenable_reg_15));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_16 (.out1(out_reg_16_reg_16),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i13_fu__Z6vecaddPKxS0_Pxj_428532_428695),
    .wenable(wrenable_reg_16));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_17 (.out1(out_reg_17_reg_17),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i14_fu__Z6vecaddPKxS0_Pxj_428532_428701),
    .wenable(wrenable_reg_17));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_18 (.out1(out_reg_18_reg_18),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_22_i0_fu__Z6vecaddPKxS0_Pxj_428532_428746),
    .wenable(wrenable_reg_18));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_19 (.out1(out_reg_19_reg_19),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_43_i1_fu__Z6vecaddPKxS0_Pxj_428532_428612),
    .wenable(wrenable_reg_19));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_26_i0_fu__Z6vecaddPKxS0_Pxj_428532_428738),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_20 (.out1(out_reg_20_reg_20),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_43_i2_fu__Z6vecaddPKxS0_Pxj_428532_428640),
    .wenable(wrenable_reg_20));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_21 (.out1(out_reg_21_reg_21),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_43_i3_fu__Z6vecaddPKxS0_Pxj_428532_428664),
    .wenable(wrenable_reg_21));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_22 (.out1(out_reg_22_reg_22),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_43_i4_fu__Z6vecaddPKxS0_Pxj_428532_428688),
    .wenable(wrenable_reg_22));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_23 (.out1(out_reg_23_reg_23),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_35_reg_23_0_0_1),
    .wenable(wrenable_reg_23));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_24 (.out1(out_reg_24_reg_24),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_36_reg_24_0_0_0),
    .wenable(wrenable_reg_24));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_25 (.out1(out_reg_25_reg_25),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_41_i0_fu__Z6vecaddPKxS0_Pxj_428532_428571),
    .wenable(wrenable_reg_25));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_26 (.out1(out_reg_26_reg_26),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i0_fu__Z6vecaddPKxS0_Pxj_428532_428564),
    .wenable(wrenable_reg_26));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_27 (.out1(out_reg_27_reg_27),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i1_fu__Z6vecaddPKxS0_Pxj_428532_428566),
    .wenable(wrenable_reg_27));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_28 (.out1(out_reg_28_reg_28),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i2_fu__Z6vecaddPKxS0_Pxj_428532_428569),
    .wenable(wrenable_reg_28));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_29 (.out1(out_reg_29_reg_29),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_4_i0_fu__Z6vecaddPKxS0_Pxj_428532_428573),
    .wenable(wrenable_reg_29));
  register_SE #(.BITSIZE_in1(30),
    .BITSIZE_out1(30)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_rshift_expr_FU_32_0_32_45_i2_fu__Z6vecaddPKxS0_Pxj_428532_428967),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_30 (.out1(out_reg_30_reg_30),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_43_i0_fu__Z6vecaddPKxS0_Pxj_428532_428568),
    .wenable(wrenable_reg_30));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i3_fu__Z6vecaddPKxS0_Pxj_428532_428600),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i4_fu__Z6vecaddPKxS0_Pxj_428532_428619),
    .wenable(wrenable_reg_7));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i5_fu__Z6vecaddPKxS0_Pxj_428532_428627),
    .wenable(wrenable_reg_8));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_44_i6_fu__Z6vecaddPKxS0_Pxj_428532_428633),
    .wenable(wrenable_reg_9));
  // io-signal post fix
  assign OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428574 = out_read_cond_FU_5_i0_fu__Z6vecaddPKxS0_Pxj_428532_428574;
  assign OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428739 = out_read_cond_FU_12_i0_fu__Z6vecaddPKxS0_Pxj_428532_428739;
  assign OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428747 = out_read_cond_FU_23_i0_fu__Z6vecaddPKxS0_Pxj_428532_428747;
  assign OUT_MULTIIF__Z6vecaddPKxS0_Pxj_428532_428981 = out_multi_read_cond_FU_27_i0_fu__Z6vecaddPKxS0_Pxj_428532_428981;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565 = s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567 = s_done_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616 = s_done_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624 = s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644 = s_done_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650 = s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668 = s_done_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674 = s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692 = s_done_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698 = s_done_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929 = s_done_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934 = s_done_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939 = s_done_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944 = s_done_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_P0;
  assign OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949 = s_done_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_P0;

endmodule

// FSM based controller description for _Z6vecaddPKxS0_Pxj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z6vecaddPKxS0_Pxj(done_port,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944,
  selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1,
  selector_MUX_19_reg_0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1,
  selector_MUX_35_reg_23_0_0_0,
  selector_MUX_35_reg_23_0_0_1,
  selector_MUX_36_reg_24_0_0_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2,
  selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2,
  selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0,
  muenable_mu_S_0,
  muenable_mu_S_10,
  muenable_mu_S_12,
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
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428574,
  OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428739,
  OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428747,
  OUT_MULTIIF__Z6vecaddPKxS0_Pxj_428532_428981,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944,
  OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949,
  OUT_mu_S_0_MULTI_UNBOUNDED_0,
  OUT_mu_S_10_MULTI_UNBOUNDED_0,
  OUT_mu_S_12_MULTI_UNBOUNDED_0,
  OUT_mu_S_6_MULTI_UNBOUNDED_0,
  OUT_mu_S_8_MULTI_UNBOUNDED_0,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428574;
  input OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428739;
  input OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428747;
  input [1:0] OUT_MULTIIF__Z6vecaddPKxS0_Pxj_428532_428981;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944;
  input OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949;
  input OUT_mu_S_0_MULTI_UNBOUNDED_0;
  input OUT_mu_S_10_MULTI_UNBOUNDED_0;
  input OUT_mu_S_12_MULTI_UNBOUNDED_0;
  input OUT_mu_S_6_MULTI_UNBOUNDED_0;
  input OUT_mu_S_8_MULTI_UNBOUNDED_0;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944;
  output selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1;
  output selector_MUX_19_reg_0_0_0_0;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1;
  output selector_MUX_35_reg_23_0_0_0;
  output selector_MUX_35_reg_23_0_0_1;
  output selector_MUX_36_reg_24_0_0_0;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2;
  output selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0;
  output selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0;
  output selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1;
  output selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2;
  output selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0;
  output muenable_mu_S_0;
  output muenable_mu_S_10;
  output muenable_mu_S_12;
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
  output wrenable_reg_4;
  output wrenable_reg_5;
  output wrenable_reg_6;
  output wrenable_reg_7;
  output wrenable_reg_8;
  output wrenable_reg_9;
  parameter [4:0] S_17 = 5'd17,
    S_20 = 5'd20,
    S_6 = 5'd6,
    S_7 = 5'd7,
    S_8 = 5'd8,
    S_9 = 5'd9,
    S_10 = 5'd10,
    S_11 = 5'd11,
    S_12 = 5'd12,
    S_13 = 5'd13,
    S_14 = 5'd14,
    S_15 = 5'd15,
    S_16 = 5'd16,
    S_5 = 5'd5,
    S_19 = 5'd19,
    S_0 = 5'd0,
    S_1 = 5'd1,
    S_2 = 5'd2,
    S_3 = 5'd3,
    S_4 = 5'd4,
    S_18 = 5'd18;
  reg [4:0] _present_state=S_17, _next_state;
  reg done_port;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944;
  reg selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1;
  reg selector_MUX_19_reg_0_0_0_0;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1;
  reg selector_MUX_35_reg_23_0_0_0;
  reg selector_MUX_35_reg_23_0_0_1;
  reg selector_MUX_36_reg_24_0_0_0;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2;
  reg selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0;
  reg selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0;
  reg selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1;
  reg selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2;
  reg selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0;
  reg muenable_mu_S_0;
  reg muenable_mu_S_10;
  reg muenable_mu_S_12;
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
  reg wrenable_reg_4;
  reg wrenable_reg_5;
  reg wrenable_reg_6;
  reg wrenable_reg_7;
  reg wrenable_reg_8;
  reg wrenable_reg_9;
  
  always @(posedge clock)
    if (reset == 1'b0) _present_state <= S_17;
    else _present_state <= _next_state;
  
  always @(*)
  begin
    done_port = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944 = 1'b0;
    selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1 = 1'b0;
    selector_MUX_19_reg_0_0_0_0 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1 = 1'b0;
    selector_MUX_35_reg_23_0_0_0 = 1'b0;
    selector_MUX_35_reg_23_0_0_1 = 1'b0;
    selector_MUX_36_reg_24_0_0_0 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2 = 1'b0;
    selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0 = 1'b0;
    selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0 = 1'b0;
    selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1 = 1'b0;
    selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2 = 1'b0;
    selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0 = 1'b0;
    muenable_mu_S_0 = 1'b0;
    muenable_mu_S_10 = 1'b0;
    muenable_mu_S_12 = 1'b0;
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
    wrenable_reg_4 = 1'b0;
    wrenable_reg_5 = 1'b0;
    wrenable_reg_6 = 1'b0;
    wrenable_reg_7 = 1'b0;
    wrenable_reg_8 = 1'b0;
    wrenable_reg_9 = 1'b0;
    case (_present_state)
      S_17 :
        if(start_port == 1'b1)
        begin
          selector_MUX_35_reg_23_0_0_1 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_23 = 1'b1;
          wrenable_reg_3 = 1'b1;
          casez (OUT_MULTIIF__Z6vecaddPKxS0_Pxj_428532_428981)
            2'b10 :
              begin
                _next_state = S_5;
                wrenable_reg_0 = 1'b0;
                wrenable_reg_3 = 1'b0;
              end
            2'b01 :
              begin
                _next_state = S_20;
                done_port = 1'b1;
                selector_MUX_35_reg_23_0_0_1 = 1'b0;
                wrenable_reg_0 = 1'b0;
                wrenable_reg_1 = 1'b0;
                wrenable_reg_2 = 1'b0;
                wrenable_reg_23 = 1'b0;
                wrenable_reg_3 = 1'b0;
              end
            default:
              begin
                _next_state = S_6;
                selector_MUX_35_reg_23_0_0_1 = 1'b0;
                wrenable_reg_23 = 1'b0;
              end
          endcase
        end
        else
        begin
          _next_state = S_17;
        end
      S_20 :
        begin
          _next_state = S_17;
        end
      S_6 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1 = 1'b1;
          selector_MUX_19_reg_0_0_0_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_13 = 1'b1;
          wrenable_reg_14 = 1'b1;
          wrenable_reg_15 = 1'b1;
          wrenable_reg_16 = 1'b1;
          wrenable_reg_17 = 1'b1;
          wrenable_reg_18 = 1'b1;
          wrenable_reg_4 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616;
          wrenable_reg_6 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = 1'b1;
          wrenable_reg_9 = 1'b1;
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616;
          wrenable_reg_6 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624;
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
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0 = 1'b1;
          wrenable_reg_19 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644;
          wrenable_reg_6 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650;
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644;
          wrenable_reg_6 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650;
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
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0 = 1'b1;
          wrenable_reg_20 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668;
          wrenable_reg_6 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674;
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668;
          wrenable_reg_6 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674;
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
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2 = 1'b1;
          wrenable_reg_21 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692;
          wrenable_reg_6 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698;
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1 = 1'b1;
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692;
          wrenable_reg_6 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698;
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
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0 = 1'b1;
          wrenable_reg_22 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949 == 1'b0)
            begin
              _next_state = S_15;
            end
          else
            begin
              _next_state = S_16;
            end
        end
      S_15 :
        begin
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949 == 1'b0)
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
          wrenable_reg_23 = 1'b1;
          if (OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428747 == 1'b1)
            begin
              _next_state = S_5;
            end
          else
            begin
              _next_state = S_6;
              wrenable_reg_23 = 1'b0;
            end
        end
      S_5 :
        begin
          wrenable_reg_24 = 1'b1;
          if (OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428739 == 1'b0)
            begin
              _next_state = S_0;
            end
          else
            begin
              _next_state = S_19;
              done_port = 1'b1;
              wrenable_reg_24 = 1'b0;
            end
        end
      S_19 :
        begin
          _next_state = S_17;
        end
      S_0 :
        begin
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565 = 1'b1;
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567 = 1'b1;
          selector_MUX_36_reg_24_0_0_0 = 1'b1;
          wrenable_reg_24 = 1'b1;
          wrenable_reg_25 = 1'b1;
          wrenable_reg_26 = 1'b1;
          wrenable_reg_27 = 1'b1;
          wrenable_reg_28 = 1'b1;
          wrenable_reg_29 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567;
          wrenable_reg_6 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565;
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567;
          wrenable_reg_6 = OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565;
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
          selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0 = 1'b1;
          wrenable_reg_30 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929 == 1'b0)
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
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0 = 1'b1;
          selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1 = 1'b1;
          selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0 = 1'b1;
          if (OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929 == 1'b0)
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
          selector_MUX_35_reg_23_0_0_0 = 1'b1;
          wrenable_reg_23 = 1'b1;
          if (OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428574 == 1'b0)
            begin
              _next_state = S_0;
            end
          else
            begin
              _next_state = S_18;
              done_port = 1'b1;
              selector_MUX_35_reg_23_0_0_0 = 1'b0;
              wrenable_reg_23 = 1'b0;
            end
        end
      S_18 :
        begin
          _next_state = S_17;
        end
      default :
        begin
          _next_state = S_17;
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

// Top component for _Z6vecaddPKxS0_Pxj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z6vecaddPKxS0_Pxj(clock,
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
  input [63:0] _A_TDATA;
  input _A_TVALID;
  input [63:0] _B_TDATA;
  input _B_TVALID;
  input _C_TREADY;
  // OUT
  output done_port;
  output _A_TREADY;
  output _B_TREADY;
  output [63:0] _C_TDATA;
  output _C_TVALID;
  // Component and signal declarations
  wire OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428574;
  wire OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428739;
  wire OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428747;
  wire [1:0] OUT_MULTIIF__Z6vecaddPKxS0_Pxj_428532_428981;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944;
  wire OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949;
  wire OUT_mu_S_0_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_10_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_12_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_6_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_8_MULTI_UNBOUNDED_0;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire muenable_mu_S_0;
  wire muenable_mu_S_10;
  wire muenable_mu_S_12;
  wire muenable_mu_S_6;
  wire muenable_mu_S_8;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944;
  wire selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1;
  wire selector_MUX_19_reg_0_0_0_0;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1;
  wire selector_MUX_35_reg_23_0_0_0;
  wire selector_MUX_35_reg_23_0_0_1;
  wire selector_MUX_36_reg_24_0_0_0;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2;
  wire selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0;
  wire selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0;
  wire selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1;
  wire selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2;
  wire selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0;
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
  
  controller__Z6vecaddPKxS0_Pxj Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1),
    .selector_MUX_19_reg_0_0_0_0(selector_MUX_19_reg_0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1),
    .selector_MUX_35_reg_23_0_0_0(selector_MUX_35_reg_23_0_0_0),
    .selector_MUX_35_reg_23_0_0_1(selector_MUX_35_reg_23_0_0_1),
    .selector_MUX_36_reg_24_0_0_0(selector_MUX_36_reg_24_0_0_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0),
    .muenable_mu_S_0(muenable_mu_S_0),
    .muenable_mu_S_10(muenable_mu_S_10),
    .muenable_mu_S_12(muenable_mu_S_12),
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
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9),
    .OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428574(OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428574),
    .OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428739(OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428739),
    .OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428747(OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428747),
    .OUT_MULTIIF__Z6vecaddPKxS0_Pxj_428532_428981(OUT_MULTIIF__Z6vecaddPKxS0_Pxj_428532_428981),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949),
    .OUT_mu_S_0_MULTI_UNBOUNDED_0(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .OUT_mu_S_10_MULTI_UNBOUNDED_0(OUT_mu_S_10_MULTI_UNBOUNDED_0),
    .OUT_mu_S_12_MULTI_UNBOUNDED_0(OUT_mu_S_12_MULTI_UNBOUNDED_0),
    .OUT_mu_S_6_MULTI_UNBOUNDED_0(OUT_mu_S_6_MULTI_UNBOUNDED_0),
    .OUT_mu_S_8_MULTI_UNBOUNDED_0(OUT_mu_S_8_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z6vecaddPKxS0_Pxj Datapath_i (._A_TREADY(_A_TREADY),
    ._B_TREADY(_B_TREADY),
    ._C_TDATA(_C_TDATA),
    ._C_TVALID(_C_TVALID),
    .OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428574(OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428574),
    .OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428739(OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428739),
    .OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428747(OUT_CONDITION__Z6vecaddPKxS0_Pxj_428532_428747),
    .OUT_MULTIIF__Z6vecaddPKxS0_Pxj_428532_428981(OUT_MULTIIF__Z6vecaddPKxS0_Pxj_428532_428981),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944),
    .OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949(OUT_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949),
    .OUT_mu_S_0_MULTI_UNBOUNDED_0(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .OUT_mu_S_10_MULTI_UNBOUNDED_0(OUT_mu_S_10_MULTI_UNBOUNDED_0),
    .OUT_mu_S_12_MULTI_UNBOUNDED_0(OUT_mu_S_12_MULTI_UNBOUNDED_0),
    .OUT_mu_S_6_MULTI_UNBOUNDED_0(OUT_mu_S_6_MULTI_UNBOUNDED_0),
    .OUT_mu_S_8_MULTI_UNBOUNDED_0(OUT_mu_S_8_MULTI_UNBOUNDED_0),
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
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428565),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428567),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428616),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428624),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428644),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428650),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428668),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428674),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428692),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428698),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428929),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428934),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428939),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428944),
    .selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949(selector_IN_UNBOUNDED__Z6vecaddPKxS0_Pxj_428532_428949),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_0),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_1),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_2),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_0_3),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_0),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_46_i0_0_1_1),
    .selector_MUX_19_reg_0_0_0_0(selector_MUX_19_reg_0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_1),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_2),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_0_3),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_47_i0_0_1_1),
    .selector_MUX_35_reg_23_0_0_0(selector_MUX_35_reg_23_0_0_0),
    .selector_MUX_35_reg_23_0_0_1(selector_MUX_35_reg_23_0_0_1),
    .selector_MUX_36_reg_24_0_0_0(selector_MUX_36_reg_24_0_0_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_1),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_2),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_3),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_0_4),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_0),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_1),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_1_2),
    .selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0(selector_MUX_3_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_1_2_0),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_0),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_1),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_0_2),
    .selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0(selector_MUX_4_C_bambu_artificial_ParmMgr_Write_axis_modgen_48_i0_2_1_0),
    .muenable_mu_S_0(muenable_mu_S_0),
    .muenable_mu_S_10(muenable_mu_S_10),
    .muenable_mu_S_12(muenable_mu_S_12),
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

// Minimal interface for function: _Z6vecaddPKxS0_Pxj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z6vecaddPKxS0_Pxj(clock,
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
  input [63:0] A_TDATA;
  input [63:0] B_TDATA;
  input [31:0] loop_count;
  input A_TVALID;
  input B_TVALID;
  input C_TREADY;
  // OUT
  output done_port;
  output A_TREADY;
  output B_TREADY;
  output [63:0] C_TDATA;
  output C_TVALID;
  // Component and signal declarations
  
  __Z6vecaddPKxS0_Pxj __Z6vecaddPKxS0_Pxj_i0 (.done_port(done_port),
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


