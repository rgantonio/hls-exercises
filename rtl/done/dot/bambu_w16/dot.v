// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-04T22:52:36
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=dot --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER -DDATA_T=int64_t -DSIZE_N=512 -DBAMBU_LANES=16 --std=c++14 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include/bambu -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/dot/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/dot/vectors/n512 dot.cpp 
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
module ui_mult_expr_FU(clock,
  in1,
  in2,
  out1);
  parameter BITSIZE_in1=1,
    BITSIZE_in2=1,
    BITSIZE_out1=1,
    PIPE_PARAMETER=0;
  // IN
  input clock;
  input [BITSIZE_in1-1:0] in1;
  input [BITSIZE_in2-1:0] in2;
  // OUT
  output [BITSIZE_out1-1:0] out1;
  
  generate
    if(PIPE_PARAMETER==1)
    begin
      reg [BITSIZE_out1-1:0] out1_reg;
      assign out1 = out1_reg;
      always @(posedge clock)
      begin
        out1_reg <= in1 * in2;
      end
    end
    else if(PIPE_PARAMETER>1)
    begin
      reg [BITSIZE_in1-1:0] in1_in;
      reg [BITSIZE_in2-1:0] in2_in;
      wire [BITSIZE_out1-1:0] mult_res;
      reg [BITSIZE_out1-1:0] mul [PIPE_PARAMETER-2:0];
      integer i;
      assign mult_res = in1_in * in2_in;
      always @(posedge clock)
      begin
        in1_in <= in1;
        in2_in <= in2;
        mul[PIPE_PARAMETER-2] <= mult_res;
        for (i=0; i<PIPE_PARAMETER-2; i=i+1)
          mul[i] <= mul[i+1];
      end
      assign out1 = mul[0];
    end
    else
    begin
      assign out1 = in1 * in2;
    end
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

// Datapath RTL description for _Z3dotPK6ac_intILi1024ELb0EES2_Pxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj(clock,
  reset,
  in_port_A,
  in_port_B,
  in_port_out,
  in_port_loop_count,
  in_port_len,
  _A_TDATA,
  _A_TVALID,
  _A_TREADY,
  _B_TDATA,
  _B_TVALID,
  _B_TREADY,
  _out_TREADY,
  _out_TDATA,
  _out_TVALID,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0,
  selector_MUX_45_reg_0_0_0_0,
  selector_MUX_46_reg_1_0_0_0,
  selector_MUX_55_reg_2_0_0_0,
  selector_MUX_56_reg_3_0_0_0,
  muenable_mu_S_0,
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
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767,
  OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246,
  OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355,
  OUT_mu_S_0_MULTI_UNBOUNDED_0);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_A;
  input [31:0] in_port_B;
  input [31:0] in_port_out;
  input [31:0] in_port_loop_count;
  input [31:0] in_port_len;
  input [1023:0] _A_TDATA;
  input _A_TVALID;
  input [1023:0] _B_TDATA;
  input _B_TVALID;
  input _out_TREADY;
  input selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569;
  input selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571;
  input selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0;
  input selector_MUX_45_reg_0_0_0_0;
  input selector_MUX_46_reg_1_0_0_0;
  input selector_MUX_55_reg_2_0_0_0;
  input selector_MUX_56_reg_3_0_0_0;
  input muenable_mu_S_0;
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
  output _B_TREADY;
  output [63:0] _out_TDATA;
  output _out_TVALID;
  output OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767;
  output OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246;
  output OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249;
  output OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569;
  output OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571;
  output OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355;
  output OUT_mu_S_0_MULTI_UNBOUNDED_0;
  // Component and signal declarations
  wire [1023:0] out_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569;
  wire [1023:0] out_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0;
  wire [31:0] out_MUX_45_reg_0_0_0_0;
  wire [63:0] out_MUX_46_reg_1_0_0_0;
  wire [31:0] out_MUX_55_reg_2_0_0_0;
  wire [31:0] out_MUX_56_reg_3_0_0_0;
  wire [63:0] out_UUdata_converter_FU_10_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428581;
  wire [63:0] out_UUdata_converter_FU_11_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428586;
  wire [63:0] out_UUdata_converter_FU_12_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428591;
  wire [63:0] out_UUdata_converter_FU_13_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428596;
  wire [63:0] out_UUdata_converter_FU_14_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428601;
  wire [63:0] out_UUdata_converter_FU_15_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428606;
  wire [63:0] out_UUdata_converter_FU_16_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428611;
  wire [63:0] out_UUdata_converter_FU_17_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428616;
  wire [63:0] out_UUdata_converter_FU_18_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428621;
  wire [63:0] out_UUdata_converter_FU_19_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428626;
  wire [63:0] out_UUdata_converter_FU_20_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428631;
  wire [63:0] out_UUdata_converter_FU_21_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428636;
  wire [63:0] out_UUdata_converter_FU_22_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428641;
  wire [63:0] out_UUdata_converter_FU_23_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428646;
  wire [63:0] out_UUdata_converter_FU_24_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428651;
  wire [63:0] out_UUdata_converter_FU_25_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428656;
  wire [63:0] out_UUdata_converter_FU_26_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428661;
  wire [63:0] out_UUdata_converter_FU_27_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428666;
  wire [63:0] out_UUdata_converter_FU_28_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428671;
  wire [63:0] out_UUdata_converter_FU_29_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428676;
  wire [63:0] out_UUdata_converter_FU_30_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428681;
  wire [63:0] out_UUdata_converter_FU_31_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428686;
  wire [63:0] out_UUdata_converter_FU_32_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428691;
  wire [63:0] out_UUdata_converter_FU_33_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428696;
  wire [63:0] out_UUdata_converter_FU_34_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428701;
  wire [63:0] out_UUdata_converter_FU_35_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428706;
  wire [63:0] out_UUdata_converter_FU_36_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428711;
  wire [63:0] out_UUdata_converter_FU_37_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428716;
  wire [63:0] out_UUdata_converter_FU_38_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428721;
  wire [63:0] out_UUdata_converter_FU_39_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428726;
  wire out_UUdata_converter_FU_40_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428765;
  wire out_UUdata_converter_FU_43_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429245;
  wire [63:0] out_UUdata_converter_FU_8_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428572;
  wire [63:0] out_UUdata_converter_FU_9_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428576;
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
  wire out_read_cond_FU_41_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767;
  wire out_read_cond_FU_44_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246;
  wire out_read_cond_FU_50_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249;
  wire [31:0] out_reg_0_reg_0;
  wire [1023:0] out_reg_10_reg_10;
  wire out_reg_11_reg_11;
  wire out_reg_12_reg_12;
  wire [63:0] out_reg_13_reg_13;
  wire [63:0] out_reg_14_reg_14;
  wire [63:0] out_reg_15_reg_15;
  wire [63:0] out_reg_16_reg_16;
  wire [63:0] out_reg_17_reg_17;
  wire [63:0] out_reg_1_reg_1;
  wire [31:0] out_reg_2_reg_2;
  wire [31:0] out_reg_3_reg_3;
  wire [31:0] out_reg_4_reg_4;
  wire [31:0] out_reg_5_reg_5;
  wire [31:0] out_reg_6_reg_6;
  wire [31:0] out_reg_7_reg_7;
  wire [1023:0] out_reg_8_reg_8;
  wire [31:0] out_reg_9_reg_9;
  wire out_truth_and_expr_FU_1_0_1_51_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429288;
  wire out_truth_and_expr_FU_1_0_1_51_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429591;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428573;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428622;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428627;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428632;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428637;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428642;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428647;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i16_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428652;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i17_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428657;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i18_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428662;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i19_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428667;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428577;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i20_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428672;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i21_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428677;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i22_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428682;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i23_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428687;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i24_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428692;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i25_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428697;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i26_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428702;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i27_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428707;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i28_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428712;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i29_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428717;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428582;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i30_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428722;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i31_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428727;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428587;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428592;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428597;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428602;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428607;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428612;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_52_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428617;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428574;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428623;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428628;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428633;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428638;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428643;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428648;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i16_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428653;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i17_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428658;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i18_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428663;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i19_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428668;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428578;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i20_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428673;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i21_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428678;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i22_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428683;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i23_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428688;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i24_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428693;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i25_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428698;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i26_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428703;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i27_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428708;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i28_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428713;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i29_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428718;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428583;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i30_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428723;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i31_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428728;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428588;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428593;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428598;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428603;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428608;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428613;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_53_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428618;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_54_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428575;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_55_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428579;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_56_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428584;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_57_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428589;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_58_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428594;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_59_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428599;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_60_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428604;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_61_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428609;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_62_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428614;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_63_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428619;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_64_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428624;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_65_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428629;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_66_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428634;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_67_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428639;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_68_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428644;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_69_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428649;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_70_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428654;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_71_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428659;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_72_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428664;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_73_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428669;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_74_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428674;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_75_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428679;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_76_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428684;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_77_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428689;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_78_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428694;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_79_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428699;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_80_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428704;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_81_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428709;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_82_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428714;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_83_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428719;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_84_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428724;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_85_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428729;
  wire [0:0] out_ui_cond_expr_FU_1_1_1_1_86_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428766;
  wire out_ui_eq_expr_FU_32_0_32_87_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429293;
  wire out_ui_eq_expr_FU_32_32_32_88_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429279;
  wire out_ui_eq_expr_FU_32_32_32_88_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429282;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_89_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429267;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_90_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429296;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429365;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429435;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429442;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429449;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429456;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429463;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429470;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i16_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429477;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i17_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429484;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i18_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429491;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i19_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429498;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429372;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i20_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429505;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i21_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429512;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i22_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429519;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i23_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429526;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i24_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429533;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i25_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429540;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i26_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429547;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i27_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429554;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i28_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429561;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i29_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429568;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429379;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i30_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429575;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i31_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429582;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429386;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429393;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429400;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429407;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429414;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429421;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_91_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429428;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428730;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428740;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428741;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428742;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428743;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428751;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428756;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428731;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428732;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428733;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428734;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428735;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428736;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428737;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428738;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_92_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428739;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_93_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428762;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_93_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428764;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_93_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428794;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_94_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428745;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_94_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428747;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_94_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428749;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_94_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428758;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_95_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428568;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_95_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428570;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_95_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428778;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_100_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428620;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_100_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428625;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_101_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428630;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_101_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428635;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_102_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428640;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_102_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428645;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_103_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428650;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_103_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428655;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_104_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428660;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_104_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428665;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_105_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428670;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_105_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428675;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_106_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428680;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_106_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428685;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_107_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428690;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_107_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428695;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_108_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428700;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_108_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428705;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_109_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428710;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_109_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428715;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_110_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428720;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_110_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428725;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429359;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429431;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429438;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429445;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429452;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429459;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429466;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i16_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429473;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i17_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429480;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i18_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429487;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i19_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429494;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429368;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i20_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429501;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i21_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429508;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i22_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429515;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i23_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429522;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i24_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429529;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i25_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429536;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i26_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429543;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i27_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429550;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i28_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429557;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i29_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429564;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429375;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i30_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429571;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i31_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429578;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429382;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429389;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429396;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429403;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429410;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429417;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_111_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429424;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_96_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428580;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_96_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428585;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_97_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428590;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_97_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428595;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_98_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428600;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_98_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428605;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_99_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428610;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_99_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428615;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_112_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428752;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_112_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428753;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_112_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428754;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_112_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428755;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_112_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428760;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_112_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428761;
  wire [63:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire [31:0] out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1;
  wire s_done_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569_P0;
  wire s_done_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571_P0;
  wire s_done_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355_P0;
  
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0),
    .in1(out_reg_7_reg_7),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_95_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428568));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0),
    .in1(out_reg_9_reg_9),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_95_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428570));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_45_reg_0_0_0_0 (.out1(out_MUX_45_reg_0_0_0_0),
    .sel(selector_MUX_45_reg_0_0_0_0),
    .in1(out_reg_5_reg_5),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_46_reg_1_0_0_0 (.out1(out_MUX_46_reg_1_0_0_0),
    .sel(selector_MUX_46_reg_1_0_0_0),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428761),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_55_reg_2_0_0_0 (.out1(out_MUX_55_reg_2_0_0_0),
    .sel(selector_MUX_55_reg_2_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_93_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428764),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_56_reg_3_0_0_0 (.out1(out_MUX_56_reg_3_0_0_0),
    .sel(selector_MUX_56_reg_3_0_0_0),
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
    .LSB_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428568 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_95_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428568),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_89_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429267));
  A_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569 (.done_port({s_done_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569_P0}),
    .out1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569),
    ._A_TREADY(_A_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569}),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428570 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_95_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428570),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_89_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429267));
  B_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571 (.done_port({s_done_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571_P0}),
    .out1(out_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571),
    ._B_TREADY(_B_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571}),
    .in1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0),
    ._B_TDATA(_B_TDATA),
    ._B_TVALID(_B_TVALID));
  UUdata_converter_FU #(.BITSIZE_in1(1024),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428572 (.out1(out_UUdata_converter_FU_8_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428572),
    .in1(out_reg_8_reg_8));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428573 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428573),
    .in1(out_UUdata_converter_FU_8_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428572),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428574 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428574),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429359),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428575 (.out1(out_ui_bit_ior_expr_FU_0_64_64_54_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428575),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429365),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428573));
  UUdata_converter_FU #(.BITSIZE_in1(1024),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428576 (.out1(out_UUdata_converter_FU_9_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428576),
    .in1(out_reg_10_reg_10));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428577 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428577),
    .in1(out_UUdata_converter_FU_9_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428576),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428578 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428578),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429368),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428579 (.out1(out_ui_bit_ior_expr_FU_0_64_64_55_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428579),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429372),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428577));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(7),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428580 (.out1(out_ui_rshift_expr_FU_64_0_64_96_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428580),
    .in1(out_reg_8_reg_8),
    .in2(out_const_3));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428581 (.out1(out_UUdata_converter_FU_10_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428581),
    .in1(out_ui_rshift_expr_FU_64_0_64_96_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428580));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428582 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428582),
    .in1(out_UUdata_converter_FU_10_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428581),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428583 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428583),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429375),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428584 (.out1(out_ui_bit_ior_expr_FU_0_64_64_56_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428584),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429379),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428582));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(7),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428585 (.out1(out_ui_rshift_expr_FU_64_0_64_96_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428585),
    .in1(out_reg_10_reg_10),
    .in2(out_const_3));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428586 (.out1(out_UUdata_converter_FU_11_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428586),
    .in1(out_ui_rshift_expr_FU_64_0_64_96_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428585));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428587 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428587),
    .in1(out_UUdata_converter_FU_11_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428586),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428588 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428588),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429382),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428589 (.out1(out_ui_bit_ior_expr_FU_0_64_64_57_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428589),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429386),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428587));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(8),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428590 (.out1(out_ui_rshift_expr_FU_64_0_64_97_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428590),
    .in1(out_reg_8_reg_8),
    .in2(out_const_4));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428591 (.out1(out_UUdata_converter_FU_12_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428591),
    .in1(out_ui_rshift_expr_FU_64_0_64_97_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428590));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428592 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428592),
    .in1(out_UUdata_converter_FU_12_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428591),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428593 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428593),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429389),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428594 (.out1(out_ui_bit_ior_expr_FU_0_64_64_58_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428594),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429393),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428592));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(8),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428595 (.out1(out_ui_rshift_expr_FU_64_0_64_97_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428595),
    .in1(out_reg_10_reg_10),
    .in2(out_const_4));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428596 (.out1(out_UUdata_converter_FU_13_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428596),
    .in1(out_ui_rshift_expr_FU_64_0_64_97_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428595));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428597 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428597),
    .in1(out_UUdata_converter_FU_13_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428596),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428598 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428598),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429396),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428599 (.out1(out_ui_bit_ior_expr_FU_0_64_64_59_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428599),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429400),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428597));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(8),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428600 (.out1(out_ui_rshift_expr_FU_64_0_64_98_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428600),
    .in1(out_reg_8_reg_8),
    .in2(out_const_12));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428601 (.out1(out_UUdata_converter_FU_14_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428601),
    .in1(out_ui_rshift_expr_FU_64_0_64_98_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428600));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428602 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428602),
    .in1(out_UUdata_converter_FU_14_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428601),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428603 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428603),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429403),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428604 (.out1(out_ui_bit_ior_expr_FU_0_64_64_60_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428604),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429407),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428602));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(8),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428605 (.out1(out_ui_rshift_expr_FU_64_0_64_98_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428605),
    .in1(out_reg_10_reg_10),
    .in2(out_const_12));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428606 (.out1(out_UUdata_converter_FU_15_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428606),
    .in1(out_ui_rshift_expr_FU_64_0_64_98_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428605));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428607 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428607),
    .in1(out_UUdata_converter_FU_15_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428606),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428608 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428608),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429410),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428609 (.out1(out_ui_bit_ior_expr_FU_0_64_64_61_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428609),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429414),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428607));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428610 (.out1(out_ui_rshift_expr_FU_64_0_64_99_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428610),
    .in1(out_reg_8_reg_8),
    .in2(out_const_5));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428611 (.out1(out_UUdata_converter_FU_16_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428611),
    .in1(out_ui_rshift_expr_FU_64_0_64_99_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428610));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428612 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428612),
    .in1(out_UUdata_converter_FU_16_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428611),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428613 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428613),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429417),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428614 (.out1(out_ui_bit_ior_expr_FU_0_64_64_62_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428614),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429421),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428612));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428615 (.out1(out_ui_rshift_expr_FU_64_0_64_99_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428615),
    .in1(out_reg_10_reg_10),
    .in2(out_const_5));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428616 (.out1(out_UUdata_converter_FU_17_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428616),
    .in1(out_ui_rshift_expr_FU_64_0_64_99_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428615));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428617 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428617),
    .in1(out_UUdata_converter_FU_17_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428616),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428618 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428618),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429424),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428619 (.out1(out_ui_bit_ior_expr_FU_0_64_64_63_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428619),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429428),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428617));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428620 (.out1(out_ui_rshift_expr_FU_64_0_64_100_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428620),
    .in1(out_reg_8_reg_8),
    .in2(out_const_8));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428621 (.out1(out_UUdata_converter_FU_18_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428621),
    .in1(out_ui_rshift_expr_FU_64_0_64_100_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428620));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428622 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428622),
    .in1(out_UUdata_converter_FU_18_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428621),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428623 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428623),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429431),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428624 (.out1(out_ui_bit_ior_expr_FU_0_64_64_64_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428624),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429435),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428622));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428625 (.out1(out_ui_rshift_expr_FU_64_0_64_100_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428625),
    .in1(out_reg_10_reg_10),
    .in2(out_const_8));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428626 (.out1(out_UUdata_converter_FU_19_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428626),
    .in1(out_ui_rshift_expr_FU_64_0_64_100_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428625));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428627 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428627),
    .in1(out_UUdata_converter_FU_19_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428626),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428628 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428628),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429438),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428629 (.out1(out_ui_bit_ior_expr_FU_0_64_64_65_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428629),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429442),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428627));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428630 (.out1(out_ui_rshift_expr_FU_64_0_64_101_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428630),
    .in1(out_reg_8_reg_8),
    .in2(out_const_13));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428631 (.out1(out_UUdata_converter_FU_20_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428631),
    .in1(out_ui_rshift_expr_FU_64_0_64_101_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428630));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428632 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428632),
    .in1(out_UUdata_converter_FU_20_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428631),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428633 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428633),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429445),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428634 (.out1(out_ui_bit_ior_expr_FU_0_64_64_66_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428634),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429449),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428632));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428635 (.out1(out_ui_rshift_expr_FU_64_0_64_101_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428635),
    .in1(out_reg_10_reg_10),
    .in2(out_const_13));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428636 (.out1(out_UUdata_converter_FU_21_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428636),
    .in1(out_ui_rshift_expr_FU_64_0_64_101_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428635));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428637 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428637),
    .in1(out_UUdata_converter_FU_21_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428636),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428638 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428638),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429452),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428639 (.out1(out_ui_bit_ior_expr_FU_0_64_64_67_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428639),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429456),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428637));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428640 (.out1(out_ui_rshift_expr_FU_64_0_64_102_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428640),
    .in1(out_reg_8_reg_8),
    .in2(out_const_17));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428641 (.out1(out_UUdata_converter_FU_22_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428641),
    .in1(out_ui_rshift_expr_FU_64_0_64_102_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428640));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428642 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428642),
    .in1(out_UUdata_converter_FU_22_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428641),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428643 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428643),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429459),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428644 (.out1(out_ui_bit_ior_expr_FU_0_64_64_68_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428644),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429463),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428642));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428645 (.out1(out_ui_rshift_expr_FU_64_0_64_102_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428645),
    .in1(out_reg_10_reg_10),
    .in2(out_const_17));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428646 (.out1(out_UUdata_converter_FU_23_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428646),
    .in1(out_ui_rshift_expr_FU_64_0_64_102_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428645));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428647 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428647),
    .in1(out_UUdata_converter_FU_23_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428646),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428648 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428648),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429466),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428649 (.out1(out_ui_bit_ior_expr_FU_0_64_64_69_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428649),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429470),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428647));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428650 (.out1(out_ui_rshift_expr_FU_64_0_64_103_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428650),
    .in1(out_reg_8_reg_8),
    .in2(out_const_6));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428651 (.out1(out_UUdata_converter_FU_24_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428651),
    .in1(out_ui_rshift_expr_FU_64_0_64_103_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428650));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428652 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i16_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428652),
    .in1(out_UUdata_converter_FU_24_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428651),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428653 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i16_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428653),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i16_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429473),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428654 (.out1(out_ui_bit_ior_expr_FU_0_64_64_70_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428654),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i16_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429477),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i16_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428652));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428655 (.out1(out_ui_rshift_expr_FU_64_0_64_103_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428655),
    .in1(out_reg_10_reg_10),
    .in2(out_const_6));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428656 (.out1(out_UUdata_converter_FU_25_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428656),
    .in1(out_ui_rshift_expr_FU_64_0_64_103_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428655));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428657 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i17_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428657),
    .in1(out_UUdata_converter_FU_25_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428656),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428658 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i17_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428658),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i17_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429480),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428659 (.out1(out_ui_bit_ior_expr_FU_0_64_64_71_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428659),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i17_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429484),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i17_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428657));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428660 (.out1(out_ui_rshift_expr_FU_64_0_64_104_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428660),
    .in1(out_reg_8_reg_8),
    .in2(out_const_7));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428661 (.out1(out_UUdata_converter_FU_26_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428661),
    .in1(out_ui_rshift_expr_FU_64_0_64_104_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428660));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428662 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i18_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428662),
    .in1(out_UUdata_converter_FU_26_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428661),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428663 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i18_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428663),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i18_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429487),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428664 (.out1(out_ui_bit_ior_expr_FU_0_64_64_72_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428664),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i18_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429491),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i18_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428662));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428665 (.out1(out_ui_rshift_expr_FU_64_0_64_104_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428665),
    .in1(out_reg_10_reg_10),
    .in2(out_const_7));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428666 (.out1(out_UUdata_converter_FU_27_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428666),
    .in1(out_ui_rshift_expr_FU_64_0_64_104_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428665));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428667 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i19_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428667),
    .in1(out_UUdata_converter_FU_27_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428666),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428668 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i19_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428668),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i19_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429494),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428669 (.out1(out_ui_bit_ior_expr_FU_0_64_64_73_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428669),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i19_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429498),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i19_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428667));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428670 (.out1(out_ui_rshift_expr_FU_64_0_64_105_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428670),
    .in1(out_reg_8_reg_8),
    .in2(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428671 (.out1(out_UUdata_converter_FU_28_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428671),
    .in1(out_ui_rshift_expr_FU_64_0_64_105_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428670));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428672 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i20_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428672),
    .in1(out_UUdata_converter_FU_28_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428671),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428673 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i20_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428673),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i20_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429501),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428674 (.out1(out_ui_bit_ior_expr_FU_0_64_64_74_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428674),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i20_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429505),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i20_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428672));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428675 (.out1(out_ui_rshift_expr_FU_64_0_64_105_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428675),
    .in1(out_reg_10_reg_10),
    .in2(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428676 (.out1(out_UUdata_converter_FU_29_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428676),
    .in1(out_ui_rshift_expr_FU_64_0_64_105_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428675));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428677 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i21_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428677),
    .in1(out_UUdata_converter_FU_29_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428676),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428678 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i21_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428678),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i21_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429508),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428679 (.out1(out_ui_bit_ior_expr_FU_0_64_64_75_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428679),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i21_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429512),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i21_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428677));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428680 (.out1(out_ui_rshift_expr_FU_64_0_64_106_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428680),
    .in1(out_reg_8_reg_8),
    .in2(out_const_10));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428681 (.out1(out_UUdata_converter_FU_30_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428681),
    .in1(out_ui_rshift_expr_FU_64_0_64_106_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428680));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428682 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i22_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428682),
    .in1(out_UUdata_converter_FU_30_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428681),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428683 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i22_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428683),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i22_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429515),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428684 (.out1(out_ui_bit_ior_expr_FU_0_64_64_76_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428684),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i22_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429519),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i22_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428682));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428685 (.out1(out_ui_rshift_expr_FU_64_0_64_106_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428685),
    .in1(out_reg_10_reg_10),
    .in2(out_const_10));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428686 (.out1(out_UUdata_converter_FU_31_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428686),
    .in1(out_ui_rshift_expr_FU_64_0_64_106_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428685));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428687 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i23_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428687),
    .in1(out_UUdata_converter_FU_31_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428686),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428688 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i23_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428688),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i23_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429522),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428689 (.out1(out_ui_bit_ior_expr_FU_0_64_64_77_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428689),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i23_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429526),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i23_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428687));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428690 (.out1(out_ui_rshift_expr_FU_64_0_64_107_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428690),
    .in1(out_reg_8_reg_8),
    .in2(out_const_14));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428691 (.out1(out_UUdata_converter_FU_32_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428691),
    .in1(out_ui_rshift_expr_FU_64_0_64_107_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428690));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428692 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i24_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428692),
    .in1(out_UUdata_converter_FU_32_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428691),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428693 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i24_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428693),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i24_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429529),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428694 (.out1(out_ui_bit_ior_expr_FU_0_64_64_78_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428694),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i24_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429533),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i24_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428692));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428695 (.out1(out_ui_rshift_expr_FU_64_0_64_107_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428695),
    .in1(out_reg_10_reg_10),
    .in2(out_const_14));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428696 (.out1(out_UUdata_converter_FU_33_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428696),
    .in1(out_ui_rshift_expr_FU_64_0_64_107_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428695));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428697 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i25_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428697),
    .in1(out_UUdata_converter_FU_33_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428696),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428698 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i25_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428698),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i25_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429536),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428699 (.out1(out_ui_bit_ior_expr_FU_0_64_64_79_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428699),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i25_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429540),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i25_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428697));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428700 (.out1(out_ui_rshift_expr_FU_64_0_64_108_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428700),
    .in1(out_reg_8_reg_8),
    .in2(out_const_15));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428701 (.out1(out_UUdata_converter_FU_34_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428701),
    .in1(out_ui_rshift_expr_FU_64_0_64_108_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428700));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428702 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i26_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428702),
    .in1(out_UUdata_converter_FU_34_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428701),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428703 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i26_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428703),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i26_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429543),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428704 (.out1(out_ui_bit_ior_expr_FU_0_64_64_80_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428704),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i26_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429547),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i26_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428702));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428705 (.out1(out_ui_rshift_expr_FU_64_0_64_108_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428705),
    .in1(out_reg_10_reg_10),
    .in2(out_const_15));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428706 (.out1(out_UUdata_converter_FU_35_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428706),
    .in1(out_ui_rshift_expr_FU_64_0_64_108_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428705));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428707 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i27_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428707),
    .in1(out_UUdata_converter_FU_35_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428706),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428708 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i27_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428708),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i27_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429550),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428709 (.out1(out_ui_bit_ior_expr_FU_0_64_64_81_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428709),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i27_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429554),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i27_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428707));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428710 (.out1(out_ui_rshift_expr_FU_64_0_64_109_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428710),
    .in1(out_reg_8_reg_8),
    .in2(out_const_18));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428711 (.out1(out_UUdata_converter_FU_36_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428711),
    .in1(out_ui_rshift_expr_FU_64_0_64_109_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428710));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428712 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i28_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428712),
    .in1(out_UUdata_converter_FU_36_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428711),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428713 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i28_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428713),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i28_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429557),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428714 (.out1(out_ui_bit_ior_expr_FU_0_64_64_82_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428714),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i28_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429561),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i28_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428712));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428715 (.out1(out_ui_rshift_expr_FU_64_0_64_109_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428715),
    .in1(out_reg_10_reg_10),
    .in2(out_const_18));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428716 (.out1(out_UUdata_converter_FU_37_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428716),
    .in1(out_ui_rshift_expr_FU_64_0_64_109_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428715));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428717 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i29_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428717),
    .in1(out_UUdata_converter_FU_37_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428716),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428718 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i29_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428718),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i29_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429564),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428719 (.out1(out_ui_bit_ior_expr_FU_0_64_64_83_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428719),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i29_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429568),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i29_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428717));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428720 (.out1(out_ui_rshift_expr_FU_64_0_64_110_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428720),
    .in1(out_reg_8_reg_8),
    .in2(out_const_19));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428721 (.out1(out_UUdata_converter_FU_38_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428721),
    .in1(out_ui_rshift_expr_FU_64_0_64_110_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428720));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428722 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i30_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428722),
    .in1(out_UUdata_converter_FU_38_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428721),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428723 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i30_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428723),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i30_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429571),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428724 (.out1(out_ui_bit_ior_expr_FU_0_64_64_84_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428724),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i30_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429575),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i30_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428722));
  ui_rshift_expr_FU #(.BITSIZE_in1(1024),
    .BITSIZE_in2(10),
    .BITSIZE_out1(64),
    .PRECISION(1024)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428725 (.out1(out_ui_rshift_expr_FU_64_0_64_110_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428725),
    .in1(out_reg_10_reg_10),
    .in2(out_const_19));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428726 (.out1(out_UUdata_converter_FU_39_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428726),
    .in1(out_ui_rshift_expr_FU_64_0_64_110_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428725));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428727 (.out1(out_ui_bit_and_expr_FU_32_0_32_52_i31_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428727),
    .in1(out_UUdata_converter_FU_39_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428726),
    .in2(out_const_20));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428728 (.out1(out_ui_bit_and_expr_FU_32_0_32_53_i31_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428728),
    .in1(out_ui_rshift_expr_FU_64_0_64_111_i31_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429578),
    .in2(out_const_20));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428729 (.out1(out_ui_bit_ior_expr_FU_0_64_64_85_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428729),
    .in1(out_ui_lshift_expr_FU_64_0_64_91_i31_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429582),
    .in2(out_ui_bit_and_expr_FU_32_0_32_52_i31_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428727));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428730 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428730),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_73_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428669),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_72_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428664));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428731 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428731),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_83_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428719),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_82_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428714));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428732 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428732),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_57_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428589),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_56_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428584));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428733 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428733),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_67_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428639),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_66_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428634));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428734 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428734),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_81_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428709),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_80_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428704));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428735 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428735),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_63_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428619),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_62_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428614));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428736 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428736),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_61_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428609),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_60_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428604));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428737 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428737),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_79_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428699),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_78_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428694));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428738 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428738),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_65_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428629),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_64_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428624));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428739 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428739),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_55_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428579),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_54_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428575));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428740 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428740),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_59_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428599),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_58_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428594));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428741 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428741),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_71_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428659),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_70_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428654));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428742 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428742),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_77_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428689),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_76_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428684));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428743 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428743),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_69_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428649),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_68_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428644));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428745 (.out1(out_ui_plus_expr_FU_64_64_64_94_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428745),
    .in1(out_ui_mult_expr_FU_64_64_64_0_92_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428732),
    .in2(out_ui_mult_expr_FU_64_64_64_0_92_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428733));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428747 (.out1(out_ui_plus_expr_FU_64_64_64_94_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428747),
    .in1(out_ui_mult_expr_FU_64_64_64_0_92_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428736),
    .in2(out_ui_mult_expr_FU_64_64_64_0_92_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428737));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428749 (.out1(out_ui_plus_expr_FU_64_64_64_94_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428749),
    .in1(out_ui_mult_expr_FU_64_64_64_0_92_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428740),
    .in2(out_ui_mult_expr_FU_64_64_64_0_92_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428741));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428751 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428751),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_85_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428729),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_84_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428724));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428752 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428752),
    .in1(out_ui_mult_expr_FU_64_64_64_0_92_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428730),
    .in2(out_ui_mult_expr_FU_64_64_64_0_92_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428731),
    .in3(out_ui_plus_expr_FU_64_64_64_94_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428745));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428753 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428753),
    .in1(out_ui_mult_expr_FU_64_64_64_0_92_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428734),
    .in2(out_ui_mult_expr_FU_64_64_64_0_92_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428735),
    .in3(out_ui_plus_expr_FU_64_64_64_94_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428747));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428754 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428754),
    .in1(out_ui_mult_expr_FU_64_64_64_0_92_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428738),
    .in2(out_ui_mult_expr_FU_64_64_64_0_92_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428739),
    .in3(out_ui_plus_expr_FU_64_64_64_94_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428749));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428755 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428755),
    .in1(out_ui_mult_expr_FU_64_64_64_0_92_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428742),
    .in2(out_ui_mult_expr_FU_64_64_64_0_92_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428743),
    .in3(out_ui_mult_expr_FU_64_64_64_0_92_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428751));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428756 (.out1(out_ui_mult_expr_FU_64_64_64_0_92_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428756),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_75_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428679),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_74_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428674));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428758 (.out1(out_ui_plus_expr_FU_64_64_64_94_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428758),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428754),
    .in2(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428755));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428760 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428760),
    .in1(out_reg_13_reg_13),
    .in2(out_reg_14_reg_14),
    .in3(out_reg_16_reg_16));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428761 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428761),
    .in1(out_reg_1_reg_1),
    .in2(out_reg_15_reg_15),
    .in3(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428760));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428762 (.out1(out_ui_plus_expr_FU_32_0_32_93_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428762),
    .in1(out_reg_3_reg_3),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428764 (.out1(out_ui_plus_expr_FU_32_0_32_93_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428764),
    .in1(out_reg_2_reg_2),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428765 (.out1(out_UUdata_converter_FU_40_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428765),
    .in1(out_ui_eq_expr_FU_32_32_32_88_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429282));
  ui_cond_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_in3(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428766 (.out1(out_ui_cond_expr_FU_1_1_1_1_86_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428766),
    .in1(out_truth_and_expr_FU_1_0_1_51_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429288),
    .in2(out_const_1),
    .in3(out_UUdata_converter_FU_40_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428765));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767 (.out1(out_read_cond_FU_41_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767),
    .in1(out_reg_12_reg_12));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428778 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_95_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428778),
    .in1(in_port_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_90_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429296));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428794 (.out1(out_ui_plus_expr_FU_32_0_32_93_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428794),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429245 (.out1(out_UUdata_converter_FU_43_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429245),
    .in1(out_ui_eq_expr_FU_32_0_32_87_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429293));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246 (.out1(out_read_cond_FU_44_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246),
    .in1(out_UUdata_converter_FU_43_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429245));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249 (.out1(out_read_cond_FU_50_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249),
    .in1(out_reg_11_reg_11));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(3),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429267 (.out1(out_ui_lshift_expr_FU_32_0_32_89_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429267),
    .in1(out_reg_2_reg_2),
    .in2(out_const_16));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429279 (.out1(out_ui_eq_expr_FU_32_32_32_88_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429279),
    .in1(out_ui_plus_expr_FU_32_0_32_93_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428762),
    .in2(in_port_len));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429282 (.out1(out_ui_eq_expr_FU_32_32_32_88_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429282),
    .in1(out_ui_plus_expr_FU_32_0_32_93_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428764),
    .in2(in_port_loop_count));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429288 (.out1(out_truth_and_expr_FU_1_0_1_51_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429288),
    .in1(out_truth_and_expr_FU_1_0_1_51_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429591),
    .in2(out_const_1));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429293 (.out1(out_ui_eq_expr_FU_32_0_32_87_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429293),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429296 (.out1(out_ui_lshift_expr_FU_32_0_32_90_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429296),
    .in1(out_reg_0_reg_0),
    .in2(out_const_11));
  out_bambu_artificial_ParmMgr_Write_axis_modgen #(.BITSIZE_in1(7),
    .BITSIZE_in2(64),
    .BITSIZE_in3(32)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355 (.done_port({s_done_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355_P0}),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355}),
    .in1(out_const_3),
    .in2(out_reg_17_reg_17),
    .in3(out_reg_4_reg_4),
    ._out_TREADY(_out_TREADY));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429359 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429359),
    .in1(out_UUdata_converter_FU_8_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428572),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429365 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429365),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428574),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429368 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429368),
    .in1(out_UUdata_converter_FU_9_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428576),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429372 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429372),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428578),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429375 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429375),
    .in1(out_UUdata_converter_FU_10_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428581),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429379 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429379),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428583),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429382 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429382),
    .in1(out_UUdata_converter_FU_11_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428586),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429386 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429386),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428588),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429389 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429389),
    .in1(out_UUdata_converter_FU_12_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428591),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429393 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429393),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i4_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428593),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429396 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429396),
    .in1(out_UUdata_converter_FU_13_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428596),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429400 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429400),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428598),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429403 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429403),
    .in1(out_UUdata_converter_FU_14_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428601),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429407 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429407),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i6_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428603),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429410 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429410),
    .in1(out_UUdata_converter_FU_15_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428606),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429414 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429414),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i7_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428608),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429417 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429417),
    .in1(out_UUdata_converter_FU_16_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428611),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429421 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429421),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i8_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428613),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429424 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429424),
    .in1(out_UUdata_converter_FU_17_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428616),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429428 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429428),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i9_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428618),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429431 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429431),
    .in1(out_UUdata_converter_FU_18_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428621),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429435 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429435),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i10_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428623),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429438 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429438),
    .in1(out_UUdata_converter_FU_19_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428626),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429442 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429442),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i11_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428628),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429445 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429445),
    .in1(out_UUdata_converter_FU_20_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428631),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429449 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429449),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i12_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428633),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429452 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429452),
    .in1(out_UUdata_converter_FU_21_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428636),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429456 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429456),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i13_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428638),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429459 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429459),
    .in1(out_UUdata_converter_FU_22_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428641),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429463 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429463),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i14_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428643),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429466 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429466),
    .in1(out_UUdata_converter_FU_23_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428646),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429470 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429470),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428648),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429473 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i16_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429473),
    .in1(out_UUdata_converter_FU_24_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428651),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429477 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i16_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429477),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i16_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428653),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429480 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i17_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429480),
    .in1(out_UUdata_converter_FU_25_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428656),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429484 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i17_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429484),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i17_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428658),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429487 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i18_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429487),
    .in1(out_UUdata_converter_FU_26_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428661),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429491 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i18_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429491),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i18_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428663),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429494 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i19_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429494),
    .in1(out_UUdata_converter_FU_27_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428666),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429498 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i19_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429498),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i19_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428668),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429501 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i20_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429501),
    .in1(out_UUdata_converter_FU_28_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428671),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429505 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i20_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429505),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i20_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428673),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429508 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i21_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429508),
    .in1(out_UUdata_converter_FU_29_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428676),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429512 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i21_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429512),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i21_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428678),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429515 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i22_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429515),
    .in1(out_UUdata_converter_FU_30_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428681),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429519 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i22_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429519),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i22_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428683),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429522 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i23_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429522),
    .in1(out_UUdata_converter_FU_31_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428686),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429526 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i23_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429526),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i23_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428688),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429529 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i24_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429529),
    .in1(out_UUdata_converter_FU_32_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428691),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429533 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i24_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429533),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i24_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428693),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429536 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i25_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429536),
    .in1(out_UUdata_converter_FU_33_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428696),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429540 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i25_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429540),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i25_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428698),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429543 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i26_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429543),
    .in1(out_UUdata_converter_FU_34_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428701),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429547 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i26_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429547),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i26_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428703),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429550 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i27_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429550),
    .in1(out_UUdata_converter_FU_35_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428706),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429554 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i27_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429554),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i27_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428708),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429557 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i28_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429557),
    .in1(out_UUdata_converter_FU_36_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428711),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429561 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i28_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429561),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i28_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428713),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429564 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i29_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429564),
    .in1(out_UUdata_converter_FU_37_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428716),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429568 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i29_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429568),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i29_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428718),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429571 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i30_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429571),
    .in1(out_UUdata_converter_FU_38_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428721),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429575 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i30_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429575),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i30_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428723),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429578 (.out1(out_ui_rshift_expr_FU_64_0_64_111_i31_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429578),
    .in1(out_UUdata_converter_FU_39_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428726),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429582 (.out1(out_ui_lshift_expr_FU_64_0_64_91_i31_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429582),
    .in1(out_ui_bit_and_expr_FU_32_0_32_53_i31_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428728),
    .in2(out_const_2));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429591 (.out1(out_truth_and_expr_FU_1_0_1_51_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429591),
    .in1(out_ui_eq_expr_FU_32_32_32_88_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429279),
    .in2(out_const_1));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_0 (.sop(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_0),
    .ops({s_done_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571_P0,
      s_done_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569_P0}));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_45_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_46_reg_1_0_0_0),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(1024),
    .BITSIZE_out1(1024)) reg_10 (.out1(out_reg_10_reg_10),
    .clock(clock),
    .reset(reset),
    .in1(out_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571),
    .wenable(wrenable_reg_10));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_40_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428765),
    .wenable(wrenable_reg_11));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_12 (.out1(out_reg_12_reg_12),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_cond_expr_FU_1_1_1_1_86_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428766),
    .wenable(wrenable_reg_12));
  register_STD #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_13 (.out1(out_reg_13_reg_13),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428752),
    .wenable(wrenable_reg_13));
  register_STD #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_14 (.out1(out_reg_14_reg_14),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428753),
    .wenable(wrenable_reg_14));
  register_STD #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_15 (.out1(out_reg_15_reg_15),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_mult_expr_FU_64_64_64_0_92_i15_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428756),
    .wenable(wrenable_reg_15));
  register_STD #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_16 (.out1(out_reg_16_reg_16),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_94_i3_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428758),
    .wenable(wrenable_reg_16));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_17 (.out1(out_reg_17_reg_17),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_112_i5_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428761),
    .wenable(wrenable_reg_17));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_55_reg_2_0_0_0),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_56_reg_3_0_0_0),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_95_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428778),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_93_i2_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428794),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_93_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428762),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_95_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428568),
    .wenable(wrenable_reg_7));
  register_SE #(.BITSIZE_in1(1024),
    .BITSIZE_out1(1024)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569),
    .wenable(wrenable_reg_8));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_95_i1_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428570),
    .wenable(wrenable_reg_9));
  // io-signal post fix
  assign OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767 = out_read_cond_FU_41_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767;
  assign OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246 = out_read_cond_FU_44_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246;
  assign OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249 = out_read_cond_FU_50_i0_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249;
  assign OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569 = s_done_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569_P0;
  assign OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571 = s_done_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571_P0;
  assign OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355 = s_done_fu__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355_P0;

endmodule

// FSM based controller description for _Z3dotPK6ac_intILi1024ELb0EES2_Pxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj(done_port,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0,
  selector_MUX_45_reg_0_0_0_0,
  selector_MUX_46_reg_1_0_0_0,
  selector_MUX_55_reg_2_0_0_0,
  selector_MUX_56_reg_3_0_0_0,
  muenable_mu_S_0,
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
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767,
  OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246,
  OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355,
  OUT_mu_S_0_MULTI_UNBOUNDED_0,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767;
  input OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246;
  input OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249;
  input OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569;
  input OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571;
  input OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355;
  input OUT_mu_S_0_MULTI_UNBOUNDED_0;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569;
  output selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571;
  output selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0;
  output selector_MUX_45_reg_0_0_0_0;
  output selector_MUX_46_reg_1_0_0_0;
  output selector_MUX_55_reg_2_0_0_0;
  output selector_MUX_56_reg_3_0_0_0;
  output muenable_mu_S_0;
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
  reg selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569;
  reg selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571;
  reg selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0;
  reg selector_MUX_45_reg_0_0_0_0;
  reg selector_MUX_46_reg_1_0_0_0;
  reg selector_MUX_55_reg_2_0_0_0;
  reg selector_MUX_56_reg_3_0_0_0;
  reg muenable_mu_S_0;
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
    selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569 = 1'b0;
    selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571 = 1'b0;
    selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0 = 1'b0;
    selector_MUX_45_reg_0_0_0_0 = 1'b0;
    selector_MUX_46_reg_1_0_0_0 = 1'b0;
    selector_MUX_55_reg_2_0_0_0 = 1'b0;
    selector_MUX_56_reg_3_0_0_0 = 1'b0;
    muenable_mu_S_0 = 1'b0;
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
          if (OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246 == 1'b0)
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
          selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569 = 1'b1;
          selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571 = 1'b1;
          selector_MUX_55_reg_2_0_0_0 = 1'b1;
          wrenable_reg_10 = OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_4 = 1'b1;
          wrenable_reg_5 = 1'b1;
          wrenable_reg_6 = 1'b1;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569;
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0 = 1'b1;
          wrenable_reg_10 = OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571;
          wrenable_reg_8 = OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569;
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
          wrenable_reg_13 = 1'b1;
          wrenable_reg_14 = 1'b1;
          wrenable_reg_15 = 1'b1;
          wrenable_reg_16 = 1'b1;
          _next_state = S_3;
        end
      S_3 :
        begin
          selector_MUX_46_reg_1_0_0_0 = 1'b1;
          selector_MUX_56_reg_3_0_0_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_17 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767 == 1'b1)
            begin
              _next_state = S_6;
              selector_MUX_46_reg_1_0_0_0 = 1'b0;
              selector_MUX_56_reg_3_0_0_0 = 1'b0;
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
          selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355 = 1'b1;
          selector_MUX_45_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355 == 1'b0)
            begin
              _next_state = S_7;
              selector_MUX_45_reg_0_0_0_0 = 1'b0;
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
          selector_MUX_45_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355 == 1'b0)
            begin
              _next_state = S_7;
              selector_MUX_45_reg_0_0_0_0 = 1'b0;
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
          if (OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249 == 1'b0)
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

// Top component for _Z3dotPK6ac_intILi1024ELb0EES2_Pxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z3dotPK6ac_intILi1024ELb0EES2_Pxjj(clock,
  reset,
  start_port,
  done_port,
  A,
  B,
  out,
  loop_count,
  len,
  _A_TDATA,
  _A_TVALID,
  _B_TDATA,
  _B_TVALID,
  _out_TREADY,
  _A_TREADY,
  _B_TREADY,
  _out_TDATA,
  _out_TVALID);
  // IN
  input clock;
  input reset;
  input start_port;
  input [31:0] A;
  input [31:0] B;
  input [31:0] out;
  input [31:0] loop_count;
  input [31:0] len;
  input [1023:0] _A_TDATA;
  input _A_TVALID;
  input [1023:0] _B_TDATA;
  input _B_TVALID;
  input _out_TREADY;
  // OUT
  output done_port;
  output _A_TREADY;
  output _B_TREADY;
  output [63:0] _out_TDATA;
  output _out_TVALID;
  // Component and signal declarations
  wire OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767;
  wire OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246;
  wire OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249;
  wire OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569;
  wire OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571;
  wire OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355;
  wire OUT_mu_S_0_MULTI_UNBOUNDED_0;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire muenable_mu_S_0;
  wire selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569;
  wire selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571;
  wire selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0;
  wire selector_MUX_45_reg_0_0_0_0;
  wire selector_MUX_46_reg_1_0_0_0;
  wire selector_MUX_55_reg_2_0_0_0;
  wire selector_MUX_56_reg_3_0_0_0;
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
  wire wrenable_reg_2;
  wire wrenable_reg_3;
  wire wrenable_reg_4;
  wire wrenable_reg_5;
  wire wrenable_reg_6;
  wire wrenable_reg_7;
  wire wrenable_reg_8;
  wire wrenable_reg_9;
  
  controller__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0),
    .selector_MUX_45_reg_0_0_0_0(selector_MUX_45_reg_0_0_0_0),
    .selector_MUX_46_reg_1_0_0_0(selector_MUX_46_reg_1_0_0_0),
    .selector_MUX_55_reg_2_0_0_0(selector_MUX_55_reg_2_0_0_0),
    .selector_MUX_56_reg_3_0_0_0(selector_MUX_56_reg_3_0_0_0),
    .muenable_mu_S_0(muenable_mu_S_0),
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
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9),
    .OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767(OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767),
    .OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246(OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246),
    .OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249(OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569(OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571(OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355(OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355),
    .OUT_mu_S_0_MULTI_UNBOUNDED_0(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj Datapath_i (._A_TREADY(_A_TREADY),
    ._B_TREADY(_B_TREADY),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767(OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428767),
    .OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246(OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429246),
    .OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249(OUT_CONDITION__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429249),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569(OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571(OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355(OUT_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355),
    .OUT_mu_S_0_MULTI_UNBOUNDED_0(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .in_port_A(A),
    .in_port_B(B),
    .in_port_out(out),
    .in_port_loop_count(loop_count),
    .in_port_len(len),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID),
    ._B_TDATA(_B_TDATA),
    ._B_TVALID(_B_TVALID),
    ._out_TREADY(_out_TREADY),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428569),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_428571),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_428532_429355),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_113_i0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_114_i0_0_0_0),
    .selector_MUX_45_reg_0_0_0_0(selector_MUX_45_reg_0_0_0_0),
    .selector_MUX_46_reg_1_0_0_0(selector_MUX_46_reg_1_0_0_0),
    .selector_MUX_55_reg_2_0_0_0(selector_MUX_55_reg_2_0_0_0),
    .selector_MUX_56_reg_3_0_0_0(selector_MUX_56_reg_3_0_0_0),
    .muenable_mu_S_0(muenable_mu_S_0),
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

// Minimal interface for function: _Z3dotPK6ac_intILi1024ELb0EES2_Pxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z3dotPK6ac_intILi1024ELb0EES2_Pxjj(clock,
  reset,
  start_port,
  A_TDATA,
  B_TDATA,
  loop_count,
  len,
  A_TVALID,
  B_TVALID,
  out_TREADY,
  done_port,
  A_TREADY,
  B_TREADY,
  out_TDATA,
  out_TVALID);
  // IN
  input clock;
  input reset;
  input start_port;
  input [1023:0] A_TDATA;
  input [1023:0] B_TDATA;
  input [31:0] loop_count;
  input [31:0] len;
  input A_TVALID;
  input B_TVALID;
  input out_TREADY;
  // OUT
  output done_port;
  output A_TREADY;
  output B_TREADY;
  output [63:0] out_TDATA;
  output out_TVALID;
  // Component and signal declarations
  
  __Z3dotPK6ac_intILi1024ELb0EES2_Pxjj __Z3dotPK6ac_intILi1024ELb0EES2_Pxjj_i0 (.done_port(done_port),
    ._A_TREADY(A_TREADY),
    ._B_TREADY(B_TREADY),
    ._out_TDATA(out_TDATA),
    ._out_TVALID(out_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port(start_port),
    .A(32'b00000000000000000000000000000000),
    .B(32'b00000000000000000000000000000000),
    .out(32'b00000000000000000000000000000000),
    .loop_count(loop_count),
    .len(len),
    ._A_TDATA(A_TDATA),
    ._A_TVALID(A_TVALID),
    ._B_TDATA(B_TDATA),
    ._B_TVALID(B_TVALID),
    ._out_TREADY(out_TREADY));

endmodule


