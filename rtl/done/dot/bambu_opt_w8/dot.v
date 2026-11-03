// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-03T13:38:06
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=dot --top-rtldesign-name=dot --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER --simulate --simulator=VERILATOR --generate-tb=/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/dot/src/tb_dot.cpp --tb-extra-gcc-options=-DDUT=dot -DCFG_LOOP_COUNT=8 -DCFG_LEN=8 --tb-param-size=A:512,B:512,out:8 -DDATA_T=int64_t -DSIZE_N=64 -DBAMBU_LANES=8 --std=c++14 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include/bambu -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/dot/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/dot/vectors/n64 /users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/dot/bambu_opt_n64_w8_proj/dot.cpp 
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
    BITSIZE_out1=512;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [511:0] _A_TDATA;
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
    BITSIZE_out1=512;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [511:0] _B_TDATA;
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

// Datapath RTL description for _Z3dotPK6ac_intILi512ELb0EES2_Pxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z3dotPK6ac_intILi512ELb0EES2_Pxjj(clock,
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
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0,
  selector_MUX_29_reg_0_0_0_0,
  selector_MUX_30_reg_1_0_0_0,
  selector_MUX_37_reg_2_0_0_0,
  selector_MUX_38_reg_3_0_0_0,
  muenable_mu_S_0,
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
  OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671,
  OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942,
  OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051,
  OUT_mu_S_0_MULTI_UNBOUNDED_0);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_A;
  input [31:0] in_port_B;
  input [31:0] in_port_out;
  input [31:0] in_port_loop_count;
  input [31:0] in_port_len;
  input [511:0] _A_TDATA;
  input _A_TVALID;
  input [511:0] _B_TDATA;
  input _B_TVALID;
  input _out_TREADY;
  input selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569;
  input selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571;
  input selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0;
  input selector_MUX_29_reg_0_0_0_0;
  input selector_MUX_30_reg_1_0_0_0;
  input selector_MUX_37_reg_2_0_0_0;
  input selector_MUX_38_reg_3_0_0_0;
  input muenable_mu_S_0;
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
  output _B_TREADY;
  output [63:0] _out_TDATA;
  output _out_TVALID;
  output OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671;
  output OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942;
  output OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945;
  output OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569;
  output OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571;
  output OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051;
  output OUT_mu_S_0_MULTI_UNBOUNDED_0;
  // Component and signal declarations
  wire [511:0] out_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569;
  wire [511:0] out_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0;
  wire [31:0] out_MUX_29_reg_0_0_0_0;
  wire [63:0] out_MUX_30_reg_1_0_0_0;
  wire [31:0] out_MUX_37_reg_2_0_0_0;
  wire [31:0] out_MUX_38_reg_3_0_0_0;
  wire [63:0] out_UUdata_converter_FU_10_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428581;
  wire [63:0] out_UUdata_converter_FU_11_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428586;
  wire [63:0] out_UUdata_converter_FU_12_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428591;
  wire [63:0] out_UUdata_converter_FU_13_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428596;
  wire [63:0] out_UUdata_converter_FU_14_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428601;
  wire [63:0] out_UUdata_converter_FU_15_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428606;
  wire [63:0] out_UUdata_converter_FU_16_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428611;
  wire [63:0] out_UUdata_converter_FU_17_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428616;
  wire [63:0] out_UUdata_converter_FU_18_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428621;
  wire [63:0] out_UUdata_converter_FU_19_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428626;
  wire [63:0] out_UUdata_converter_FU_20_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428631;
  wire [63:0] out_UUdata_converter_FU_21_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428636;
  wire [63:0] out_UUdata_converter_FU_22_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428641;
  wire [63:0] out_UUdata_converter_FU_23_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428646;
  wire out_UUdata_converter_FU_24_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428669;
  wire out_UUdata_converter_FU_27_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428941;
  wire [63:0] out_UUdata_converter_FU_8_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428572;
  wire [63:0] out_UUdata_converter_FU_9_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428576;
  wire out_const_0;
  wire out_const_1;
  wire [8:0] out_const_10;
  wire [8:0] out_const_11;
  wire [31:0] out_const_12;
  wire [5:0] out_const_2;
  wire [6:0] out_const_3;
  wire [7:0] out_const_4;
  wire [8:0] out_const_5;
  wire [8:0] out_const_6;
  wire [1:0] out_const_7;
  wire [2:0] out_const_8;
  wire [7:0] out_const_9;
  wire [31:0] out_conv_out_const_0_1_32;
  wire [63:0] out_conv_out_const_0_1_64;
  wire out_read_cond_FU_25_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671;
  wire out_read_cond_FU_28_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942;
  wire out_read_cond_FU_34_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945;
  wire [31:0] out_reg_0_reg_0;
  wire [511:0] out_reg_10_reg_10;
  wire out_reg_11_reg_11;
  wire out_reg_12_reg_12;
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
  wire [511:0] out_reg_8_reg_8;
  wire [31:0] out_reg_9_reg_9;
  wire out_truth_and_expr_FU_1_0_1_35_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428984;
  wire out_truth_and_expr_FU_1_0_1_35_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429175;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428573;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i10_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428622;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i11_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428627;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i12_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428632;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i13_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428637;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i14_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428642;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i15_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428647;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428577;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428582;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428587;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428592;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428597;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428602;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428607;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i8_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428612;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_36_i9_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428617;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428574;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i10_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428623;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i11_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428628;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i12_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428633;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i13_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428638;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i14_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428643;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i15_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428648;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428578;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428583;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428588;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428593;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428598;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428603;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428608;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i8_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428613;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_37_i9_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428618;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_38_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428575;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_39_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428579;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_40_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428584;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_41_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428589;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_42_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428594;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_43_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428599;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_44_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428604;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_45_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428609;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_46_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428614;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_47_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428619;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_48_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428624;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_49_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428629;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_50_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428634;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_51_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428639;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_52_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428644;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_53_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428649;
  wire [0:0] out_ui_cond_expr_FU_1_1_1_1_54_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428670;
  wire out_ui_eq_expr_FU_32_0_32_55_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428989;
  wire out_ui_eq_expr_FU_32_32_32_56_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428975;
  wire out_ui_eq_expr_FU_32_32_32_56_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428978;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_57_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428963;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_58_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428992;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429061;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i10_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429131;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i11_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429138;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i12_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429145;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i13_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429152;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i14_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429159;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i15_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429166;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429068;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429075;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429082;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429089;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429096;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429103;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429110;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i8_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429117;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_59_i9_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429124;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_60_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428650;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_60_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428651;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_60_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428652;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_60_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428653;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_60_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428654;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_60_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428655;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_60_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428659;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_60_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428660;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_61_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428666;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_61_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428668;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_61_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428698;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_62_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428657;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_62_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428664;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_63_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428568;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_63_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428570;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_63_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428682;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_64_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428580;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_64_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428585;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_65_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428590;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_65_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428595;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_66_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428600;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_66_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428605;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_67_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428610;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_67_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428615;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_68_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428620;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_68_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428625;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_69_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428630;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_69_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428635;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_70_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428640;
  wire [63:0] out_ui_rshift_expr_FU_64_0_64_70_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428645;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429055;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i10_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429127;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i11_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429134;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i12_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429141;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i13_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429148;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i14_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429155;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i15_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429162;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429064;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429071;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429078;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429085;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429092;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429099;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429106;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i8_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429113;
  wire [31:0] out_ui_rshift_expr_FU_64_0_64_71_i9_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429120;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_72_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428661;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_72_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428662;
  wire [63:0] out_ui_ternary_plus_expr_FU_64_64_64_64_72_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428665;
  wire [63:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire [31:0] out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1;
  wire s_done_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569_P0;
  wire s_done_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571_P0;
  wire s_done_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051_P0;
  
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0),
    .in1(out_reg_7_reg_7),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_63_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428568));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0),
    .in1(out_reg_9_reg_9),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_63_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428570));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_29_reg_0_0_0_0 (.out1(out_MUX_29_reg_0_0_0_0),
    .sel(selector_MUX_29_reg_0_0_0_0),
    .in1(out_reg_5_reg_5),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_30_reg_1_0_0_0 (.out1(out_MUX_30_reg_1_0_0_0),
    .sel(selector_MUX_30_reg_1_0_0_0),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_72_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428665),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_37_reg_2_0_0_0 (.out1(out_MUX_37_reg_2_0_0_0),
    .sel(selector_MUX_37_reg_2_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_61_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428668),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_38_reg_3_0_0_0 (.out1(out_MUX_38_reg_3_0_0_0),
    .sel(selector_MUX_38_reg_3_0_0_0),
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
  constant_value #(.BITSIZE_out1(9),
    .value(9'b110000000)) const_10 (.out1(out_const_10));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b111000000)) const_11 (.out1(out_const_11));
  constant_value #(.BITSIZE_out1(32),
    .value(32'b11111111111111111111111111111111)) const_12 (.out1(out_const_12));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b100000)) const_2 (.out1(out_const_2));
  constant_value #(.BITSIZE_out1(7),
    .value(7'b1000000)) const_3 (.out1(out_const_3));
  constant_value #(.BITSIZE_out1(8),
    .value(8'b10000000)) const_4 (.out1(out_const_4));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b100000000)) const_5 (.out1(out_const_5));
  constant_value #(.BITSIZE_out1(9),
    .value(9'b101000000)) const_6 (.out1(out_const_6));
  constant_value #(.BITSIZE_out1(2),
    .value(2'b11)) const_7 (.out1(out_const_7));
  constant_value #(.BITSIZE_out1(3),
    .value(3'b110)) const_8 (.out1(out_const_8));
  constant_value #(.BITSIZE_out1(8),
    .value(8'b11000000)) const_9 (.out1(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(64)) conv_out_const_0_1_64 (.out1(out_conv_out_const_0_1_64),
    .in1(out_const_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428568 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_63_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428568),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_57_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428963));
  A_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569 (.done_port({s_done_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569_P0}),
    .out1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569),
    ._A_TREADY(_A_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569}),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428570 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_63_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428570),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_57_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428963));
  B_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571 (.done_port({s_done_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571_P0}),
    .out1(out_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571),
    ._B_TREADY(_B_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571}),
    .in1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0),
    ._B_TDATA(_B_TDATA),
    ._B_TVALID(_B_TVALID));
  UUdata_converter_FU #(.BITSIZE_in1(512),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428572 (.out1(out_UUdata_converter_FU_8_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428572),
    .in1(out_reg_8_reg_8));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428573 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428573),
    .in1(out_UUdata_converter_FU_8_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428572),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428574 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428574),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429055),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428575 (.out1(out_ui_bit_ior_expr_FU_0_64_64_38_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428575),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429061),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428573));
  UUdata_converter_FU #(.BITSIZE_in1(512),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428576 (.out1(out_UUdata_converter_FU_9_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428576),
    .in1(out_reg_10_reg_10));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428577 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428577),
    .in1(out_UUdata_converter_FU_9_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428576),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428578 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428578),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429064),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428579 (.out1(out_ui_bit_ior_expr_FU_0_64_64_39_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428579),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429068),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428577));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(7),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428580 (.out1(out_ui_rshift_expr_FU_64_0_64_64_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428580),
    .in1(out_reg_8_reg_8),
    .in2(out_const_3));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428581 (.out1(out_UUdata_converter_FU_10_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428581),
    .in1(out_ui_rshift_expr_FU_64_0_64_64_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428580));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428582 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428582),
    .in1(out_UUdata_converter_FU_10_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428581),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428583 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428583),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429071),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428584 (.out1(out_ui_bit_ior_expr_FU_0_64_64_40_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428584),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429075),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428582));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(7),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428585 (.out1(out_ui_rshift_expr_FU_64_0_64_64_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428585),
    .in1(out_reg_10_reg_10),
    .in2(out_const_3));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428586 (.out1(out_UUdata_converter_FU_11_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428586),
    .in1(out_ui_rshift_expr_FU_64_0_64_64_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428585));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428587 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428587),
    .in1(out_UUdata_converter_FU_11_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428586),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428588 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428588),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429078),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428589 (.out1(out_ui_bit_ior_expr_FU_0_64_64_41_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428589),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429082),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428587));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(8),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428590 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428590),
    .in1(out_reg_8_reg_8),
    .in2(out_const_4));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428591 (.out1(out_UUdata_converter_FU_12_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428591),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428590));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428592 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428592),
    .in1(out_UUdata_converter_FU_12_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428591),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428593 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428593),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429085),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428594 (.out1(out_ui_bit_ior_expr_FU_0_64_64_42_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428594),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429089),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428592));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(8),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428595 (.out1(out_ui_rshift_expr_FU_64_0_64_65_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428595),
    .in1(out_reg_10_reg_10),
    .in2(out_const_4));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428596 (.out1(out_UUdata_converter_FU_13_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428596),
    .in1(out_ui_rshift_expr_FU_64_0_64_65_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428595));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428597 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428597),
    .in1(out_UUdata_converter_FU_13_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428596),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428598 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428598),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429092),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428599 (.out1(out_ui_bit_ior_expr_FU_0_64_64_43_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428599),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429096),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428597));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(8),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428600 (.out1(out_ui_rshift_expr_FU_64_0_64_66_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428600),
    .in1(out_reg_8_reg_8),
    .in2(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428601 (.out1(out_UUdata_converter_FU_14_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428601),
    .in1(out_ui_rshift_expr_FU_64_0_64_66_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428600));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428602 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428602),
    .in1(out_UUdata_converter_FU_14_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428601),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428603 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428603),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429099),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428604 (.out1(out_ui_bit_ior_expr_FU_0_64_64_44_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428604),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429103),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428602));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(8),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428605 (.out1(out_ui_rshift_expr_FU_64_0_64_66_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428605),
    .in1(out_reg_10_reg_10),
    .in2(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428606 (.out1(out_UUdata_converter_FU_15_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428606),
    .in1(out_ui_rshift_expr_FU_64_0_64_66_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428605));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428607 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428607),
    .in1(out_UUdata_converter_FU_15_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428606),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428608 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428608),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429106),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428609 (.out1(out_ui_bit_ior_expr_FU_0_64_64_45_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428609),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429110),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428607));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428610 (.out1(out_ui_rshift_expr_FU_64_0_64_67_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428610),
    .in1(out_reg_8_reg_8),
    .in2(out_const_5));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428611 (.out1(out_UUdata_converter_FU_16_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428611),
    .in1(out_ui_rshift_expr_FU_64_0_64_67_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428610));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428612 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i8_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428612),
    .in1(out_UUdata_converter_FU_16_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428611),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428613 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i8_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428613),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i8_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429113),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428614 (.out1(out_ui_bit_ior_expr_FU_0_64_64_46_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428614),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i8_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429117),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i8_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428612));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428615 (.out1(out_ui_rshift_expr_FU_64_0_64_67_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428615),
    .in1(out_reg_10_reg_10),
    .in2(out_const_5));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428616 (.out1(out_UUdata_converter_FU_17_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428616),
    .in1(out_ui_rshift_expr_FU_64_0_64_67_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428615));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428617 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i9_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428617),
    .in1(out_UUdata_converter_FU_17_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428616),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428618 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i9_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428618),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i9_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429120),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428619 (.out1(out_ui_bit_ior_expr_FU_0_64_64_47_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428619),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i9_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429124),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i9_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428617));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428620 (.out1(out_ui_rshift_expr_FU_64_0_64_68_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428620),
    .in1(out_reg_8_reg_8),
    .in2(out_const_6));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428621 (.out1(out_UUdata_converter_FU_18_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428621),
    .in1(out_ui_rshift_expr_FU_64_0_64_68_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428620));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428622 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i10_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428622),
    .in1(out_UUdata_converter_FU_18_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428621),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428623 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i10_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428623),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i10_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429127),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428624 (.out1(out_ui_bit_ior_expr_FU_0_64_64_48_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428624),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i10_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429131),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i10_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428622));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428625 (.out1(out_ui_rshift_expr_FU_64_0_64_68_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428625),
    .in1(out_reg_10_reg_10),
    .in2(out_const_6));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428626 (.out1(out_UUdata_converter_FU_19_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428626),
    .in1(out_ui_rshift_expr_FU_64_0_64_68_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428625));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428627 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i11_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428627),
    .in1(out_UUdata_converter_FU_19_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428626),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428628 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i11_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428628),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i11_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429134),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428629 (.out1(out_ui_bit_ior_expr_FU_0_64_64_49_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428629),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i11_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429138),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i11_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428627));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428630 (.out1(out_ui_rshift_expr_FU_64_0_64_69_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428630),
    .in1(out_reg_8_reg_8),
    .in2(out_const_10));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428631 (.out1(out_UUdata_converter_FU_20_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428631),
    .in1(out_ui_rshift_expr_FU_64_0_64_69_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428630));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428632 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i12_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428632),
    .in1(out_UUdata_converter_FU_20_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428631),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428633 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i12_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428633),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i12_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429141),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428634 (.out1(out_ui_bit_ior_expr_FU_0_64_64_50_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428634),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i12_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429145),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i12_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428632));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428635 (.out1(out_ui_rshift_expr_FU_64_0_64_69_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428635),
    .in1(out_reg_10_reg_10),
    .in2(out_const_10));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428636 (.out1(out_UUdata_converter_FU_21_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428636),
    .in1(out_ui_rshift_expr_FU_64_0_64_69_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428635));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428637 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i13_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428637),
    .in1(out_UUdata_converter_FU_21_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428636),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428638 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i13_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428638),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i13_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429148),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428639 (.out1(out_ui_bit_ior_expr_FU_0_64_64_51_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428639),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i13_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429152),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i13_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428637));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428640 (.out1(out_ui_rshift_expr_FU_64_0_64_70_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428640),
    .in1(out_reg_8_reg_8),
    .in2(out_const_11));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428641 (.out1(out_UUdata_converter_FU_22_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428641),
    .in1(out_ui_rshift_expr_FU_64_0_64_70_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428640));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428642 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i14_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428642),
    .in1(out_UUdata_converter_FU_22_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428641),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428643 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i14_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428643),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i14_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429155),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428644 (.out1(out_ui_bit_ior_expr_FU_0_64_64_52_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428644),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i14_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429159),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i14_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428642));
  ui_rshift_expr_FU #(.BITSIZE_in1(512),
    .BITSIZE_in2(9),
    .BITSIZE_out1(64),
    .PRECISION(512)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428645 (.out1(out_ui_rshift_expr_FU_64_0_64_70_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428645),
    .in1(out_reg_10_reg_10),
    .in2(out_const_11));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428646 (.out1(out_UUdata_converter_FU_23_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428646),
    .in1(out_ui_rshift_expr_FU_64_0_64_70_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428645));
  ui_bit_and_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428647 (.out1(out_ui_bit_and_expr_FU_32_0_32_36_i15_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428647),
    .in1(out_UUdata_converter_FU_23_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428646),
    .in2(out_const_12));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428648 (.out1(out_ui_bit_and_expr_FU_32_0_32_37_i15_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428648),
    .in1(out_ui_rshift_expr_FU_64_0_64_71_i15_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429162),
    .in2(out_const_12));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428649 (.out1(out_ui_bit_ior_expr_FU_0_64_64_53_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428649),
    .in1(out_ui_lshift_expr_FU_64_0_64_59_i15_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429166),
    .in2(out_ui_bit_and_expr_FU_32_0_32_36_i15_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428647));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428650 (.out1(out_ui_mult_expr_FU_64_64_64_0_60_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428650),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_39_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428579),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_38_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428575));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428651 (.out1(out_ui_mult_expr_FU_64_64_64_0_60_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428651),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_49_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428629),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_48_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428624));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428652 (.out1(out_ui_mult_expr_FU_64_64_64_0_60_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428652),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_45_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428609),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_44_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428604));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428653 (.out1(out_ui_mult_expr_FU_64_64_64_0_60_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428653),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_47_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428619),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_46_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428614));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428654 (.out1(out_ui_mult_expr_FU_64_64_64_0_60_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428654),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_51_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428639),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_50_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428634));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428655 (.out1(out_ui_mult_expr_FU_64_64_64_0_60_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428655),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_41_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428589),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_40_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428584));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428657 (.out1(out_ui_plus_expr_FU_64_64_64_62_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428657),
    .in1(out_ui_mult_expr_FU_64_64_64_0_60_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428652),
    .in2(out_ui_mult_expr_FU_64_64_64_0_60_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428653));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428659 (.out1(out_ui_mult_expr_FU_64_64_64_0_60_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428659),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_43_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428599),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_42_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428594));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428660 (.out1(out_ui_mult_expr_FU_64_64_64_0_60_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428660),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_53_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428649),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_52_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428644));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428661 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_72_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428661),
    .in1(out_ui_mult_expr_FU_64_64_64_0_60_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428650),
    .in2(out_ui_mult_expr_FU_64_64_64_0_60_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428651),
    .in3(out_ui_plus_expr_FU_64_64_64_62_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428657));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428662 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_72_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428662),
    .in1(out_ui_mult_expr_FU_64_64_64_0_60_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428654),
    .in2(out_ui_mult_expr_FU_64_64_64_0_60_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428655),
    .in3(out_ui_mult_expr_FU_64_64_64_0_60_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428659));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428664 (.out1(out_ui_plus_expr_FU_64_64_64_62_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428664),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_72_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428661),
    .in2(out_ui_ternary_plus_expr_FU_64_64_64_64_72_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428662));
  ui_ternary_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_in3(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428665 (.out1(out_ui_ternary_plus_expr_FU_64_64_64_64_72_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428665),
    .in1(out_reg_1_reg_1),
    .in2(out_reg_13_reg_13),
    .in3(out_reg_14_reg_14));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428666 (.out1(out_ui_plus_expr_FU_32_0_32_61_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428666),
    .in1(out_reg_3_reg_3),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428668 (.out1(out_ui_plus_expr_FU_32_0_32_61_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428668),
    .in1(out_reg_2_reg_2),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428669 (.out1(out_UUdata_converter_FU_24_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428669),
    .in1(out_ui_eq_expr_FU_32_32_32_56_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428978));
  ui_cond_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_in3(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428670 (.out1(out_ui_cond_expr_FU_1_1_1_1_54_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428670),
    .in1(out_truth_and_expr_FU_1_0_1_35_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428984),
    .in2(out_const_1),
    .in3(out_UUdata_converter_FU_24_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428669));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671 (.out1(out_read_cond_FU_25_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671),
    .in1(out_reg_12_reg_12));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428682 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_63_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428682),
    .in1(in_port_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_58_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428992));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428698 (.out1(out_ui_plus_expr_FU_32_0_32_61_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428698),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428941 (.out1(out_UUdata_converter_FU_27_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428941),
    .in1(out_ui_eq_expr_FU_32_0_32_55_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428989));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942 (.out1(out_read_cond_FU_28_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942),
    .in1(out_UUdata_converter_FU_27_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428941));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945 (.out1(out_read_cond_FU_34_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945),
    .in1(out_reg_11_reg_11));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(3),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428963 (.out1(out_ui_lshift_expr_FU_32_0_32_57_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428963),
    .in1(out_reg_2_reg_2),
    .in2(out_const_8));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428975 (.out1(out_ui_eq_expr_FU_32_32_32_56_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428975),
    .in1(out_ui_plus_expr_FU_32_0_32_61_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428666),
    .in2(in_port_len));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428978 (.out1(out_ui_eq_expr_FU_32_32_32_56_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428978),
    .in1(out_ui_plus_expr_FU_32_0_32_61_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428668),
    .in2(in_port_loop_count));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428984 (.out1(out_truth_and_expr_FU_1_0_1_35_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428984),
    .in1(out_truth_and_expr_FU_1_0_1_35_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429175),
    .in2(out_const_1));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428989 (.out1(out_ui_eq_expr_FU_32_0_32_55_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428989),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428992 (.out1(out_ui_lshift_expr_FU_32_0_32_58_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428992),
    .in1(out_reg_0_reg_0),
    .in2(out_const_7));
  out_bambu_artificial_ParmMgr_Write_axis_modgen #(.BITSIZE_in1(7),
    .BITSIZE_in2(64),
    .BITSIZE_in3(32)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051 (.done_port({s_done_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051_P0}),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051}),
    .in1(out_const_3),
    .in2(out_reg_15_reg_15),
    .in3(out_reg_4_reg_4),
    ._out_TREADY(_out_TREADY));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429055 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429055),
    .in1(out_UUdata_converter_FU_8_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428572),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429061 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429061),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428574),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429064 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429064),
    .in1(out_UUdata_converter_FU_9_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428576),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429068 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429068),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428578),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429071 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429071),
    .in1(out_UUdata_converter_FU_10_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428581),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429075 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429075),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428583),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429078 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429078),
    .in1(out_UUdata_converter_FU_11_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428586),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429082 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429082),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i3_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428588),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429085 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429085),
    .in1(out_UUdata_converter_FU_12_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428591),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429089 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429089),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i4_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428593),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429092 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429092),
    .in1(out_UUdata_converter_FU_13_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428596),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429096 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429096),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i5_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428598),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429099 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429099),
    .in1(out_UUdata_converter_FU_14_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428601),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429103 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429103),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i6_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428603),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429106 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429106),
    .in1(out_UUdata_converter_FU_15_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428606),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429110 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429110),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428608),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429113 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i8_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429113),
    .in1(out_UUdata_converter_FU_16_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428611),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429117 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i8_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429117),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i8_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428613),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429120 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i9_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429120),
    .in1(out_UUdata_converter_FU_17_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428616),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429124 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i9_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429124),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i9_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428618),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429127 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i10_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429127),
    .in1(out_UUdata_converter_FU_18_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428621),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429131 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i10_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429131),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i10_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428623),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429134 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i11_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429134),
    .in1(out_UUdata_converter_FU_19_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428626),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429138 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i11_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429138),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i11_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428628),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429141 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i12_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429141),
    .in1(out_UUdata_converter_FU_20_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428631),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429145 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i12_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429145),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i12_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428633),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429148 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i13_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429148),
    .in1(out_UUdata_converter_FU_21_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428636),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429152 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i13_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429152),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i13_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428638),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429155 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i14_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429155),
    .in1(out_UUdata_converter_FU_22_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428641),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429159 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i14_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429159),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i14_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428643),
    .in2(out_const_2));
  ui_rshift_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429162 (.out1(out_ui_rshift_expr_FU_64_0_64_71_i15_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429162),
    .in1(out_UUdata_converter_FU_23_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428646),
    .in2(out_const_2));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429166 (.out1(out_ui_lshift_expr_FU_64_0_64_59_i15_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429166),
    .in1(out_ui_bit_and_expr_FU_32_0_32_37_i15_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428648),
    .in2(out_const_2));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429175 (.out1(out_truth_and_expr_FU_1_0_1_35_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429175),
    .in1(out_ui_eq_expr_FU_32_32_32_56_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428975),
    .in2(out_const_1));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_0 (.sop(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_0),
    .ops({s_done_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569_P0,
      s_done_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571_P0}));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_29_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_30_reg_1_0_0_0),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(512),
    .BITSIZE_out1(512)) reg_10 (.out1(out_reg_10_reg_10),
    .clock(clock),
    .reset(reset),
    .in1(out_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571),
    .wenable(wrenable_reg_10));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_24_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428669),
    .wenable(wrenable_reg_11));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_12 (.out1(out_reg_12_reg_12),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_cond_expr_FU_1_1_1_1_54_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428670),
    .wenable(wrenable_reg_12));
  register_STD #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_13 (.out1(out_reg_13_reg_13),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_mult_expr_FU_64_64_64_0_60_i7_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428660),
    .wenable(wrenable_reg_13));
  register_STD #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_14 (.out1(out_reg_14_reg_14),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_62_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428664),
    .wenable(wrenable_reg_14));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_15 (.out1(out_reg_15_reg_15),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_ternary_plus_expr_FU_64_64_64_64_72_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428665),
    .wenable(wrenable_reg_15));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_37_reg_2_0_0_0),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_38_reg_3_0_0_0),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_63_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428682),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_61_i2_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428698),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_61_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428666),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_63_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428568),
    .wenable(wrenable_reg_7));
  register_SE #(.BITSIZE_in1(512),
    .BITSIZE_out1(512)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569),
    .wenable(wrenable_reg_8));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_63_i1_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428570),
    .wenable(wrenable_reg_9));
  // io-signal post fix
  assign OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671 = out_read_cond_FU_25_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671;
  assign OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942 = out_read_cond_FU_28_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942;
  assign OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945 = out_read_cond_FU_34_i0_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945;
  assign OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569 = s_done_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569_P0;
  assign OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571 = s_done_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571_P0;
  assign OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051 = s_done_fu__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051_P0;

endmodule

// FSM based controller description for _Z3dotPK6ac_intILi512ELb0EES2_Pxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z3dotPK6ac_intILi512ELb0EES2_Pxjj(done_port,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0,
  selector_MUX_29_reg_0_0_0_0,
  selector_MUX_30_reg_1_0_0_0,
  selector_MUX_37_reg_2_0_0_0,
  selector_MUX_38_reg_3_0_0_0,
  muenable_mu_S_0,
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
  OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671,
  OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942,
  OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051,
  OUT_mu_S_0_MULTI_UNBOUNDED_0,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671;
  input OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942;
  input OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945;
  input OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569;
  input OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571;
  input OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051;
  input OUT_mu_S_0_MULTI_UNBOUNDED_0;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569;
  output selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571;
  output selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0;
  output selector_MUX_29_reg_0_0_0_0;
  output selector_MUX_30_reg_1_0_0_0;
  output selector_MUX_37_reg_2_0_0_0;
  output selector_MUX_38_reg_3_0_0_0;
  output muenable_mu_S_0;
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
  reg selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569;
  reg selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571;
  reg selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0;
  reg selector_MUX_29_reg_0_0_0_0;
  reg selector_MUX_30_reg_1_0_0_0;
  reg selector_MUX_37_reg_2_0_0_0;
  reg selector_MUX_38_reg_3_0_0_0;
  reg muenable_mu_S_0;
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
    selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569 = 1'b0;
    selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571 = 1'b0;
    selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0 = 1'b0;
    selector_MUX_29_reg_0_0_0_0 = 1'b0;
    selector_MUX_30_reg_1_0_0_0 = 1'b0;
    selector_MUX_37_reg_2_0_0_0 = 1'b0;
    selector_MUX_38_reg_3_0_0_0 = 1'b0;
    muenable_mu_S_0 = 1'b0;
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
          if (OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942 == 1'b0)
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
          selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569 = 1'b1;
          selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571 = 1'b1;
          selector_MUX_37_reg_2_0_0_0 = 1'b1;
          wrenable_reg_10 = OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_4 = 1'b1;
          wrenable_reg_5 = 1'b1;
          wrenable_reg_6 = 1'b1;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569;
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
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0 = 1'b1;
          wrenable_reg_10 = OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571;
          wrenable_reg_8 = OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569;
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
          _next_state = S_3;
        end
      S_3 :
        begin
          selector_MUX_30_reg_1_0_0_0 = 1'b1;
          selector_MUX_38_reg_3_0_0_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_15 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671 == 1'b1)
            begin
              _next_state = S_6;
              selector_MUX_30_reg_1_0_0_0 = 1'b0;
              selector_MUX_38_reg_3_0_0_0 = 1'b0;
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
          selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051 = 1'b1;
          selector_MUX_29_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051 == 1'b0)
            begin
              _next_state = S_7;
              selector_MUX_29_reg_0_0_0_0 = 1'b0;
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
          selector_MUX_29_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051 == 1'b0)
            begin
              _next_state = S_7;
              selector_MUX_29_reg_0_0_0_0 = 1'b0;
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
          if (OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945 == 1'b0)
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

// Top component for _Z3dotPK6ac_intILi512ELb0EES2_Pxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z3dotPK6ac_intILi512ELb0EES2_Pxjj(clock,
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
  input [511:0] _A_TDATA;
  input _A_TVALID;
  input [511:0] _B_TDATA;
  input _B_TVALID;
  input _out_TREADY;
  // OUT
  output done_port;
  output _A_TREADY;
  output _B_TREADY;
  output [63:0] _out_TDATA;
  output _out_TVALID;
  // Component and signal declarations
  wire OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671;
  wire OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942;
  wire OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945;
  wire OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569;
  wire OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571;
  wire OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051;
  wire OUT_mu_S_0_MULTI_UNBOUNDED_0;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire muenable_mu_S_0;
  wire selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569;
  wire selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571;
  wire selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0;
  wire selector_MUX_29_reg_0_0_0_0;
  wire selector_MUX_30_reg_1_0_0_0;
  wire selector_MUX_37_reg_2_0_0_0;
  wire selector_MUX_38_reg_3_0_0_0;
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
  
  controller__Z3dotPK6ac_intILi512ELb0EES2_Pxjj Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0),
    .selector_MUX_29_reg_0_0_0_0(selector_MUX_29_reg_0_0_0_0),
    .selector_MUX_30_reg_1_0_0_0(selector_MUX_30_reg_1_0_0_0),
    .selector_MUX_37_reg_2_0_0_0(selector_MUX_37_reg_2_0_0_0),
    .selector_MUX_38_reg_3_0_0_0(selector_MUX_38_reg_3_0_0_0),
    .muenable_mu_S_0(muenable_mu_S_0),
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
    .OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671(OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671),
    .OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942(OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942),
    .OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945(OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569(OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571(OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051(OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051),
    .OUT_mu_S_0_MULTI_UNBOUNDED_0(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z3dotPK6ac_intILi512ELb0EES2_Pxjj Datapath_i (._A_TREADY(_A_TREADY),
    ._B_TREADY(_B_TREADY),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671(OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428671),
    .OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942(OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428942),
    .OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945(OUT_CONDITION__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428945),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569(OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571(OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051(OUT_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051),
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
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428569),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_428571),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi512ELb0EES2_Pxjj_428532_429051),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_73_i0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_74_i0_0_0_0),
    .selector_MUX_29_reg_0_0_0_0(selector_MUX_29_reg_0_0_0_0),
    .selector_MUX_30_reg_1_0_0_0(selector_MUX_30_reg_1_0_0_0),
    .selector_MUX_37_reg_2_0_0_0(selector_MUX_37_reg_2_0_0_0),
    .selector_MUX_38_reg_3_0_0_0(selector_MUX_38_reg_3_0_0_0),
    .muenable_mu_S_0(muenable_mu_S_0),
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

// Minimal interface for function: _Z3dotPK6ac_intILi512ELb0EES2_Pxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z3dotPK6ac_intILi512ELb0EES2_Pxjj(clock,
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
  input [511:0] A_TDATA;
  input [511:0] B_TDATA;
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
  
  __Z3dotPK6ac_intILi512ELb0EES2_Pxjj __Z3dotPK6ac_intILi512ELb0EES2_Pxjj_i0 (.done_port(done_port),
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


