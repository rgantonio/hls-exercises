// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-05T07:06:18
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=axpy --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER -DDATA_T=int64_t -DSIZE_N=512 -DBAMBU_LANES=1 --std=c++14 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include/bambu -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_untiered/axpy/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_untiered/axpy/vectors/n512 axpy.cpp 
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

// Interface module for function: x_bambu_artificial_ParmMgr_Read_axis
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module x_bambu_artificial_ParmMgr_Read_axis_modgen(clock,
  reset,
  start_port,
  in1,
  _x_TDATA,
  _x_TVALID,
  done_port,
  out1,
  _x_TREADY);
  parameter BITSIZE_in1=32,
    BITSIZE_out1=64;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [63:0] _x_TDATA;
  input _x_TVALID;
  // OUT
  output [0:0] done_port;
  output [BITSIZE_out1-1:0] out1;
  output _x_TREADY;
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
    started_0 = (started || start_port) & ~_x_TVALID;
    done_0 = (started | start_port) & _x_TVALID;
  end
  
  assign out1 = {_x_TVALID, _x_TDATA};
  assign done_port = done_0;
  assign _x_TREADY = done_0;

endmodule

// Interface module for function: y_bambu_artificial_ParmMgr_Read_axis
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module y_bambu_artificial_ParmMgr_Read_axis_modgen(clock,
  reset,
  start_port,
  in1,
  _y_TDATA,
  _y_TVALID,
  done_port,
  out1,
  _y_TREADY);
  parameter BITSIZE_in1=32,
    BITSIZE_out1=64;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [63:0] _y_TDATA;
  input _y_TVALID;
  // OUT
  output [0:0] done_port;
  output [BITSIZE_out1-1:0] out1;
  output _y_TREADY;
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
    started_0 = (started || start_port) & ~_y_TVALID;
    done_0 = (started | start_port) & _y_TVALID;
  end
  
  assign out1 = {_y_TVALID, _y_TDATA};
  assign done_port = done_0;
  assign _y_TREADY = done_0;

endmodule

// Interface module for function: y_out_bambu_artificial_ParmMgr_Write_axis
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module y_out_bambu_artificial_ParmMgr_Write_axis_modgen(clock,
  reset,
  start_port,
  in1,
  in2,
  in3,
  _y_out_TREADY,
  done_port,
  out1,
  _y_out_TDATA,
  _y_out_TVALID);
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
  input _y_out_TREADY;
  // OUT
  output [0:0] done_port;
  output out1;
  output [63:0] _y_out_TDATA;
  output _y_out_TVALID;
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
    started_0 = (started | start_port) & ~_y_out_TREADY;
  end
  
  assign done_port = (started | start_port) & _y_out_TREADY;
  assign _y_out_TVALID = started | start_port;
  assign out1 = _y_out_TREADY;
  assign _y_out_TDATA = in2;

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

// Datapath RTL description for _Z4axpyPKxS0_Pxxj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z4axpyPKxS0_Pxxj(clock,
  reset,
  in_port_x,
  in_port_y,
  in_port_y_out,
  in_port_alpha,
  in_port_loop_count,
  _x_TDATA,
  _x_TVALID,
  _x_TREADY,
  _y_TDATA,
  _y_TVALID,
  _y_TREADY,
  _y_out_TREADY,
  _y_out_TDATA,
  _y_out_TVALID,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845,
  selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0,
  selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1,
  selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2,
  selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0,
  selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0,
  selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1,
  selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2,
  selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0,
  selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1,
  selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0,
  selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1,
  selector_MUX_10_reg_0_0_0_0,
  selector_MUX_17_reg_15_0_0_0,
  selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0,
  selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1,
  selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2,
  selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0,
  muenable_mu_S_0,
  muenable_mu_S_5,
  muenable_mu_S_7,
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
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428876,
  OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428889,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845,
  OUT_mu_S_0_MULTI_UNBOUNDED_0,
  OUT_mu_S_5_MULTI_UNBOUNDED_0,
  OUT_mu_S_7_MULTI_UNBOUNDED_0);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_x;
  input [31:0] in_port_y;
  input [31:0] in_port_y_out;
  input [63:0] in_port_alpha;
  input [31:0] in_port_loop_count;
  input [63:0] _x_TDATA;
  input _x_TVALID;
  input [63:0] _y_TDATA;
  input _y_TVALID;
  input _y_out_TREADY;
  input selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567;
  input selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569;
  input selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604;
  input selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616;
  input selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637;
  input selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646;
  input selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835;
  input selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840;
  input selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845;
  input selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0;
  input selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1;
  input selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2;
  input selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0;
  input selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0;
  input selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1;
  input selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2;
  input selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0;
  input selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1;
  input selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0;
  input selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1;
  input selector_MUX_10_reg_0_0_0_0;
  input selector_MUX_17_reg_15_0_0_0;
  input selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0;
  input selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1;
  input selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2;
  input selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0;
  input muenable_mu_S_0;
  input muenable_mu_S_5;
  input muenable_mu_S_7;
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
  input wrenable_reg_3;
  input wrenable_reg_4;
  input wrenable_reg_5;
  input wrenable_reg_6;
  input wrenable_reg_7;
  input wrenable_reg_8;
  input wrenable_reg_9;
  // OUT
  output _x_TREADY;
  output _y_TREADY;
  output [63:0] _y_out_TDATA;
  output _y_out_TVALID;
  output [1:0] OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428876;
  output [1:0] OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428889;
  output OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567;
  output OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569;
  output OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604;
  output OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616;
  output OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637;
  output OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646;
  output OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835;
  output OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840;
  output OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845;
  output OUT_mu_S_0_MULTI_UNBOUNDED_0;
  output OUT_mu_S_5_MULTI_UNBOUNDED_0;
  output OUT_mu_S_7_MULTI_UNBOUNDED_0;
  // Component and signal declarations
  wire [31:0] out_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0;
  wire [31:0] out_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1;
  wire [31:0] out_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2;
  wire [31:0] out_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0;
  wire [63:0] out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0;
  wire [63:0] out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1;
  wire [63:0] out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2;
  wire [63:0] out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0;
  wire [63:0] out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1;
  wire [31:0] out_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0;
  wire [31:0] out_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1;
  wire [31:0] out_MUX_10_reg_0_0_0_0;
  wire [28:0] out_MUX_17_reg_15_0_0_0;
  wire [31:0] out_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0;
  wire [31:0] out_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1;
  wire [31:0] out_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2;
  wire [31:0] out_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0;
  wire out_UUdata_converter_FU_11_i0_fu__Z4axpyPKxS0_Pxxj_428532_428690;
  wire out_UUdata_converter_FU_13_i0_fu__Z4axpyPKxS0_Pxxj_428532_428698;
  wire out_UUdata_converter_FU_14_i0_fu__Z4axpyPKxS0_Pxxj_428532_428675;
  wire out_UUdata_converter_FU_15_i0_fu__Z4axpyPKxS0_Pxxj_428532_428686;
  wire out_const_0;
  wire out_const_1;
  wire [6:0] out_const_2;
  wire [1:0] out_const_3;
  wire [30:0] out_const_4;
  wire [28:0] out_conv_out_const_0_1_29;
  wire [31:0] out_conv_out_const_0_1_32;
  wire [28:0] out_conv_out_reg_0_reg_0_32_29;
  wire [1:0] out_multi_read_cond_FU_12_i0_fu__Z4axpyPKxS0_Pxxj_428532_428889;
  wire [1:0] out_multi_read_cond_FU_16_i0_fu__Z4axpyPKxS0_Pxxj_428532_428876;
  wire [31:0] out_reg_0_reg_0;
  wire [31:0] out_reg_10_reg_10;
  wire out_reg_11_reg_11;
  wire out_reg_12_reg_12;
  wire [63:0] out_reg_13_reg_13;
  wire [63:0] out_reg_14_reg_14;
  wire [28:0] out_reg_15_reg_15;
  wire [31:0] out_reg_16_reg_16;
  wire [31:0] out_reg_17_reg_17;
  wire [31:0] out_reg_18_reg_18;
  wire [63:0] out_reg_19_reg_19;
  wire out_reg_1_reg_1;
  wire [30:0] out_reg_2_reg_2;
  wire [31:0] out_reg_3_reg_3;
  wire [63:0] out_reg_4_reg_4;
  wire [31:0] out_reg_5_reg_5;
  wire [63:0] out_reg_6_reg_6;
  wire [31:0] out_reg_7_reg_7;
  wire [31:0] out_reg_8_reg_8;
  wire [31:0] out_reg_9_reg_9;
  wire out_truth_and_expr_FU_1_1_1_17_i0_fu__Z4axpyPKxS0_Pxxj_428532_428882;
  wire out_truth_and_expr_FU_1_1_1_17_i1_fu__Z4axpyPKxS0_Pxxj_428532_428895;
  wire out_truth_not_expr_FU_1_1_18_i0_fu__Z4axpyPKxS0_Pxxj_428532_428879;
  wire out_truth_not_expr_FU_1_1_18_i1_fu__Z4axpyPKxS0_Pxxj_428532_428892;
  wire [0:0] out_ui_bit_and_expr_FU_1_0_1_19_i0_fu__Z4axpyPKxS0_Pxxj_428532_428674;
  wire [30:0] out_ui_bit_and_expr_FU_32_0_32_20_i0_fu__Z4axpyPKxS0_Pxxj_428532_428695;
  wire [28:0] out_ui_bit_ior_expr_FU_32_0_32_21_i0_fu__Z4axpyPKxS0_Pxxj_428532_428630;
  wire out_ui_eq_expr_FU_1_0_1_22_i0_fu__Z4axpyPKxS0_Pxxj_428532_428741;
  wire out_ui_eq_expr_FU_32_0_32_23_i0_fu__Z4axpyPKxS0_Pxxj_428532_428738;
  wire out_ui_eq_expr_FU_32_0_32_24_i0_fu__Z4axpyPKxS0_Pxxj_428532_428771;
  wire out_ui_eq_expr_FU_32_32_32_25_i0_fu__Z4axpyPKxS0_Pxxj_428532_428762;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_26_i0_fu__Z4axpyPKxS0_Pxxj_428532_428719;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_26_i1_fu__Z4axpyPKxS0_Pxxj_428532_428744;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_26_i2_fu__Z4axpyPKxS0_Pxxj_428532_428753;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_27_i0_fu__Z4axpyPKxS0_Pxxj_428532_428856;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_27_i1_fu__Z4axpyPKxS0_Pxxj_428532_428869;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_28_i0_ui_mult_expr_FU_64_64_64_0_28_i0;
  wire [30:0] out_ui_plus_expr_FU_32_0_32_29_i0_fu__Z4axpyPKxS0_Pxxj_428532_428853;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_30_i0_fu__Z4axpyPKxS0_Pxxj_428532_428571;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_30_i1_fu__Z4axpyPKxS0_Pxxj_428532_428600;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_30_i2_fu__Z4axpyPKxS0_Pxxj_428532_428633;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_31_i0_fu__Z4axpyPKxS0_Pxxj_428532_428566;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_31_i1_fu__Z4axpyPKxS0_Pxxj_428532_428568;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_31_i2_fu__Z4axpyPKxS0_Pxxj_428532_428572;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_31_i3_fu__Z4axpyPKxS0_Pxxj_428532_428588;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_31_i4_fu__Z4axpyPKxS0_Pxxj_428532_428607;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_31_i5_fu__Z4axpyPKxS0_Pxxj_428532_428619;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_31_i6_fu__Z4axpyPKxS0_Pxxj_428532_428626;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_31_i7_fu__Z4axpyPKxS0_Pxxj_428532_428640;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_31_i8_fu__Z4axpyPKxS0_Pxxj_428532_428649;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_32_i0_fu__Z4axpyPKxS0_Pxxj_428532_428849;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_32_i1_fu__Z4axpyPKxS0_Pxxj_428532_428859;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_32_i2_fu__Z4axpyPKxS0_Pxxj_428532_428862;
  wire [30:0] out_ui_rshift_expr_FU_32_0_32_32_i3_fu__Z4axpyPKxS0_Pxxj_428532_428865;
  wire [28:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire [28:0] out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1;
  wire [31:0] out_uu_conv_conn_obj_2_UUdata_converter_FU_uu_conv_2;
  wire [63:0] out_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0;
  wire [63:0] out_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0;
  wire s_done_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_P0;
  wire s_done_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_P0;
  wire s_done_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_P0;
  wire s_start_port0;
  wire s_start_port1;
  wire s_start_port2;
  
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0 (.out1(out_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0),
    .sel(selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0),
    .in1(out_reg_9_reg_9),
    .in2(out_reg_5_reg_5));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1 (.out1(out_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1),
    .sel(selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1),
    .in1(out_reg_17_reg_17),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_31_i1_fu__Z4axpyPKxS0_Pxxj_428532_428568));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2 (.out1(out_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2),
    .sel(selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_31_i4_fu__Z4axpyPKxS0_Pxxj_428532_428607),
    .in2(out_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0 (.out1(out_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0),
    .sel(selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0),
    .in1(out_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1),
    .in2(out_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0 (.out1(out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0),
    .sel(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0),
    .in1(out_reg_19_reg_19),
    .in2(out_reg_14_reg_14));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1 (.out1(out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1),
    .sel(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1),
    .in1(out_reg_13_reg_13),
    .in2(out_ui_plus_expr_FU_64_64_64_30_i0_fu__Z4axpyPKxS0_Pxxj_428532_428571));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2 (.out1(out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2),
    .sel(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2),
    .in1(out_ui_plus_expr_FU_64_64_64_30_i1_fu__Z4axpyPKxS0_Pxxj_428532_428600),
    .in2(out_ui_plus_expr_FU_64_64_64_30_i2_fu__Z4axpyPKxS0_Pxxj_428532_428633));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0 (.out1(out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0),
    .sel(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0),
    .in1(out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0),
    .in2(out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1 (.out1(out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1),
    .sel(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1),
    .in1(out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2),
    .in2(out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0 (.out1(out_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0),
    .sel(selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0),
    .in1(out_reg_8_reg_8),
    .in2(out_reg_3_reg_3));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1 (.out1(out_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1),
    .sel(selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1),
    .in1(out_reg_18_reg_18),
    .in2(out_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_10_reg_0_0_0_0 (.out1(out_MUX_10_reg_0_0_0_0),
    .sel(selector_MUX_10_reg_0_0_0_0),
    .in1(out_ui_lshift_expr_FU_32_0_32_27_i0_fu__Z4axpyPKxS0_Pxxj_428532_428856),
    .in2(out_uu_conv_conn_obj_2_UUdata_converter_FU_uu_conv_2));
  MUX_GATE #(.BITSIZE_in1(29),
    .BITSIZE_in2(29),
    .BITSIZE_out1(29)) MUX_17_reg_15_0_0_0 (.out1(out_MUX_17_reg_15_0_0_0),
    .sel(selector_MUX_17_reg_15_0_0_0),
    .in1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0 (.out1(out_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0),
    .sel(selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0),
    .in1(out_reg_7_reg_7),
    .in2(out_reg_16_reg_16));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1 (.out1(out_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1),
    .sel(selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1),
    .in1(out_reg_10_reg_10),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_31_i0_fu__Z4axpyPKxS0_Pxxj_428532_428566));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2 (.out1(out_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2),
    .sel(selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_31_i5_fu__Z4axpyPKxS0_Pxxj_428532_428619),
    .in2(out_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0 (.out1(out_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0),
    .sel(selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0),
    .in1(out_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1),
    .in2(out_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2));
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
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(29)) conv_out_const_0_1_29 (.out1(out_conv_out_const_0_1_29),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(29)) conv_out_reg_0_reg_0_32_29 (.out1(out_conv_out_reg_0_reg_0_32_29),
    .in1(out_reg_0_reg_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4axpyPKxS0_Pxxj_428532_428566 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_31_i0_fu__Z4axpyPKxS0_Pxxj_428532_428566),
    .in1(in_port_x),
    .in2(out_ui_lshift_expr_FU_32_0_32_26_i0_fu__Z4axpyPKxS0_Pxxj_428532_428719));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4axpyPKxS0_Pxxj_428532_428568 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_31_i1_fu__Z4axpyPKxS0_Pxxj_428532_428568),
    .in1(in_port_y),
    .in2(out_ui_lshift_expr_FU_32_0_32_26_i0_fu__Z4axpyPKxS0_Pxxj_428532_428719));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z4axpyPKxS0_Pxxj_428532_428571 (.out1(out_ui_plus_expr_FU_64_64_64_30_i0_fu__Z4axpyPKxS0_Pxxj_428532_428571),
    .in1(out_reg_4_reg_4),
    .in2(out_ui_mult_expr_FU_64_64_64_0_28_i0_ui_mult_expr_FU_64_64_64_0_28_i0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4axpyPKxS0_Pxxj_428532_428572 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_31_i2_fu__Z4axpyPKxS0_Pxxj_428532_428572),
    .in1(in_port_y_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_26_i0_fu__Z4axpyPKxS0_Pxxj_428532_428719));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4axpyPKxS0_Pxxj_428532_428588 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_31_i3_fu__Z4axpyPKxS0_Pxxj_428532_428588),
    .in1(in_port_y_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_26_i1_fu__Z4axpyPKxS0_Pxxj_428532_428744));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z4axpyPKxS0_Pxxj_428532_428600 (.out1(out_ui_plus_expr_FU_64_64_64_30_i1_fu__Z4axpyPKxS0_Pxxj_428532_428600),
    .in1(out_reg_4_reg_4),
    .in2(out_ui_mult_expr_FU_64_64_64_0_28_i0_ui_mult_expr_FU_64_64_64_0_28_i0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4axpyPKxS0_Pxxj_428532_428607 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_31_i4_fu__Z4axpyPKxS0_Pxxj_428532_428607),
    .in1(in_port_y),
    .in2(out_ui_lshift_expr_FU_32_0_32_26_i1_fu__Z4axpyPKxS0_Pxxj_428532_428744));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4axpyPKxS0_Pxxj_428532_428619 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_31_i5_fu__Z4axpyPKxS0_Pxxj_428532_428619),
    .in1(in_port_x),
    .in2(out_ui_lshift_expr_FU_32_0_32_26_i1_fu__Z4axpyPKxS0_Pxxj_428532_428744));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4axpyPKxS0_Pxxj_428532_428626 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_31_i6_fu__Z4axpyPKxS0_Pxxj_428532_428626),
    .in1(in_port_y_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_26_i2_fu__Z4axpyPKxS0_Pxxj_428532_428753));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(29)) fu__Z4axpyPKxS0_Pxxj_428532_428630 (.out1(out_ui_bit_ior_expr_FU_32_0_32_21_i0_fu__Z4axpyPKxS0_Pxxj_428532_428630),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z4axpyPKxS0_Pxxj_428532_428633 (.out1(out_ui_plus_expr_FU_64_64_64_30_i2_fu__Z4axpyPKxS0_Pxxj_428532_428633),
    .in1(out_reg_4_reg_4),
    .in2(out_ui_mult_expr_FU_64_64_64_0_28_i0_ui_mult_expr_FU_64_64_64_0_28_i0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4axpyPKxS0_Pxxj_428532_428640 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_31_i7_fu__Z4axpyPKxS0_Pxxj_428532_428640),
    .in1(in_port_y),
    .in2(out_ui_lshift_expr_FU_32_0_32_26_i2_fu__Z4axpyPKxS0_Pxxj_428532_428753));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z4axpyPKxS0_Pxxj_428532_428649 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_31_i8_fu__Z4axpyPKxS0_Pxxj_428532_428649),
    .in1(in_port_x),
    .in2(out_ui_lshift_expr_FU_32_0_32_26_i2_fu__Z4axpyPKxS0_Pxxj_428532_428753));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428674 (.out1(out_ui_bit_and_expr_FU_1_0_1_19_i0_fu__Z4axpyPKxS0_Pxxj_428532_428674),
    .in1(in_port_loop_count),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428675 (.out1(out_UUdata_converter_FU_14_i0_fu__Z4axpyPKxS0_Pxxj_428532_428675),
    .in1(out_ui_eq_expr_FU_32_0_32_23_i0_fu__Z4axpyPKxS0_Pxxj_428532_428738));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428686 (.out1(out_UUdata_converter_FU_15_i0_fu__Z4axpyPKxS0_Pxxj_428532_428686),
    .in1(out_ui_eq_expr_FU_1_0_1_22_i0_fu__Z4axpyPKxS0_Pxxj_428532_428741));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428690 (.out1(out_UUdata_converter_FU_11_i0_fu__Z4axpyPKxS0_Pxxj_428532_428690),
    .in1(out_ui_eq_expr_FU_32_32_32_25_i0_fu__Z4axpyPKxS0_Pxxj_428532_428762));
  ui_bit_and_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(31),
    .BITSIZE_out1(31)) fu__Z4axpyPKxS0_Pxxj_428532_428695 (.out1(out_ui_bit_and_expr_FU_32_0_32_20_i0_fu__Z4axpyPKxS0_Pxxj_428532_428695),
    .in1(out_ui_rshift_expr_FU_32_0_32_32_i3_fu__Z4axpyPKxS0_Pxxj_428532_428865),
    .in2(out_const_4));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428698 (.out1(out_UUdata_converter_FU_13_i0_fu__Z4axpyPKxS0_Pxxj_428532_428698),
    .in1(out_ui_eq_expr_FU_32_0_32_24_i0_fu__Z4axpyPKxS0_Pxxj_428532_428771));
  ui_lshift_expr_FU #(.BITSIZE_in1(29),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4axpyPKxS0_Pxxj_428532_428719 (.out1(out_ui_lshift_expr_FU_32_0_32_26_i0_fu__Z4axpyPKxS0_Pxxj_428532_428719),
    .in1(out_reg_15_reg_15),
    .in2(out_const_3));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428738 (.out1(out_ui_eq_expr_FU_32_0_32_23_i0_fu__Z4axpyPKxS0_Pxxj_428532_428738),
    .in1(in_port_loop_count),
    .in2(out_const_1));
  ui_eq_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428741 (.out1(out_ui_eq_expr_FU_1_0_1_22_i0_fu__Z4axpyPKxS0_Pxxj_428532_428741),
    .in1(out_ui_bit_and_expr_FU_1_0_1_19_i0_fu__Z4axpyPKxS0_Pxxj_428532_428674),
    .in2(out_const_0));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4axpyPKxS0_Pxxj_428532_428744 (.out1(out_ui_lshift_expr_FU_32_0_32_26_i1_fu__Z4axpyPKxS0_Pxxj_428532_428744),
    .in1(out_reg_0_reg_0),
    .in2(out_const_3));
  ui_lshift_expr_FU #(.BITSIZE_in1(29),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4axpyPKxS0_Pxxj_428532_428753 (.out1(out_ui_lshift_expr_FU_32_0_32_26_i2_fu__Z4axpyPKxS0_Pxxj_428532_428753),
    .in1(out_ui_bit_ior_expr_FU_32_0_32_21_i0_fu__Z4axpyPKxS0_Pxxj_428532_428630),
    .in2(out_const_3));
  ui_eq_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(31),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428762 (.out1(out_ui_eq_expr_FU_32_32_32_25_i0_fu__Z4axpyPKxS0_Pxxj_428532_428762),
    .in1(out_ui_rshift_expr_FU_32_0_32_32_i1_fu__Z4axpyPKxS0_Pxxj_428532_428859),
    .in2(out_reg_2_reg_2));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428771 (.out1(out_ui_eq_expr_FU_32_0_32_24_i0_fu__Z4axpyPKxS0_Pxxj_428532_428771),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4axpyPKxS0_Pxxj_428532_428849 (.out1(out_ui_rshift_expr_FU_32_0_32_32_i0_fu__Z4axpyPKxS0_Pxxj_428532_428849),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31)) fu__Z4axpyPKxS0_Pxxj_428532_428853 (.out1(out_ui_plus_expr_FU_32_0_32_29_i0_fu__Z4axpyPKxS0_Pxxj_428532_428853),
    .in1(out_ui_rshift_expr_FU_32_0_32_32_i0_fu__Z4axpyPKxS0_Pxxj_428532_428849),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4axpyPKxS0_Pxxj_428532_428856 (.out1(out_ui_lshift_expr_FU_32_0_32_27_i0_fu__Z4axpyPKxS0_Pxxj_428532_428856),
    .in1(out_ui_plus_expr_FU_32_0_32_29_i0_fu__Z4axpyPKxS0_Pxxj_428532_428853),
    .in2(out_const_1));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4axpyPKxS0_Pxxj_428532_428859 (.out1(out_ui_rshift_expr_FU_32_0_32_32_i1_fu__Z4axpyPKxS0_Pxxj_428532_428859),
    .in1(out_ui_lshift_expr_FU_32_0_32_27_i0_fu__Z4axpyPKxS0_Pxxj_428532_428856),
    .in2(out_const_1));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4axpyPKxS0_Pxxj_428532_428862 (.out1(out_ui_rshift_expr_FU_32_0_32_32_i2_fu__Z4axpyPKxS0_Pxxj_428532_428862),
    .in1(out_ui_lshift_expr_FU_32_0_32_27_i1_fu__Z4axpyPKxS0_Pxxj_428532_428869),
    .in2(out_const_1));
  ui_rshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(31),
    .PRECISION(32)) fu__Z4axpyPKxS0_Pxxj_428532_428865 (.out1(out_ui_rshift_expr_FU_32_0_32_32_i3_fu__Z4axpyPKxS0_Pxxj_428532_428865),
    .in1(in_port_loop_count),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(31),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z4axpyPKxS0_Pxxj_428532_428869 (.out1(out_ui_lshift_expr_FU_32_0_32_27_i1_fu__Z4axpyPKxS0_Pxxj_428532_428869),
    .in1(out_ui_bit_and_expr_FU_32_0_32_20_i0_fu__Z4axpyPKxS0_Pxxj_428532_428695),
    .in2(out_const_1));
  multi_read_cond_FU #(.BITSIZE_in1(1),
    .PORTSIZE_in1(2),
    .BITSIZE_out1(2)) fu__Z4axpyPKxS0_Pxxj_428532_428876 (.out1(out_multi_read_cond_FU_16_i0_fu__Z4axpyPKxS0_Pxxj_428532_428876),
    .in1({out_truth_and_expr_FU_1_1_1_17_i0_fu__Z4axpyPKxS0_Pxxj_428532_428882,
      out_UUdata_converter_FU_13_i0_fu__Z4axpyPKxS0_Pxxj_428532_428698}));
  truth_not_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428879 (.out1(out_truth_not_expr_FU_1_1_18_i0_fu__Z4axpyPKxS0_Pxxj_428532_428879),
    .in1(out_UUdata_converter_FU_13_i0_fu__Z4axpyPKxS0_Pxxj_428532_428698));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428882 (.out1(out_truth_and_expr_FU_1_1_1_17_i0_fu__Z4axpyPKxS0_Pxxj_428532_428882),
    .in1(out_UUdata_converter_FU_14_i0_fu__Z4axpyPKxS0_Pxxj_428532_428675),
    .in2(out_truth_not_expr_FU_1_1_18_i0_fu__Z4axpyPKxS0_Pxxj_428532_428879));
  multi_read_cond_FU #(.BITSIZE_in1(1),
    .PORTSIZE_in1(2),
    .BITSIZE_out1(2)) fu__Z4axpyPKxS0_Pxxj_428532_428889 (.out1(out_multi_read_cond_FU_12_i0_fu__Z4axpyPKxS0_Pxxj_428532_428889),
    .in1({out_reg_12_reg_12,
      out_reg_11_reg_11}));
  truth_not_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428892 (.out1(out_truth_not_expr_FU_1_1_18_i1_fu__Z4axpyPKxS0_Pxxj_428532_428892),
    .in1(out_UUdata_converter_FU_11_i0_fu__Z4axpyPKxS0_Pxxj_428532_428690));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z4axpyPKxS0_Pxxj_428532_428895 (.out1(out_truth_and_expr_FU_1_1_1_17_i1_fu__Z4axpyPKxS0_Pxxj_428532_428895),
    .in1(out_UUdata_converter_FU_11_i0_fu__Z4axpyPKxS0_Pxxj_428532_428690),
    .in2(out_reg_1_reg_1));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_0 (.sop(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_0),
    .ops({s_done_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_P0,
      s_done_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_5 (.sop(OUT_mu_S_5_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_5),
    .ops({s_done_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_P0,
      s_done_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_P0}));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(3)) mu_S_7 (.sop(OUT_mu_S_7_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_7),
    .ops({s_done_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_P0,
      s_done_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_P0,
      s_done_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_P0}));
  or or_or_start_port0( s_start_port0, selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567, selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616, selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646);
  or or_or_start_port1( s_start_port1, selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569, selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604, selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637);
  or or_or_start_port2( s_start_port2, selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835, selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840, selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845);
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_10_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_15_i0_fu__Z4axpyPKxS0_Pxxj_428532_428686),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_10 (.out1(out_reg_10_reg_10),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_31_i8_fu__Z4axpyPKxS0_Pxxj_428532_428649),
    .wenable(wrenable_reg_10));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_truth_not_expr_FU_1_1_18_i1_fu__Z4axpyPKxS0_Pxxj_428532_428892),
    .wenable(wrenable_reg_11));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_12 (.out1(out_reg_12_reg_12),
    .clock(clock),
    .reset(reset),
    .in1(out_truth_and_expr_FU_1_1_1_17_i1_fu__Z4axpyPKxS0_Pxxj_428532_428895),
    .wenable(wrenable_reg_12));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_13 (.out1(out_reg_13_reg_13),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_30_i1_fu__Z4axpyPKxS0_Pxxj_428532_428600),
    .wenable(wrenable_reg_13));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_14 (.out1(out_reg_14_reg_14),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_30_i2_fu__Z4axpyPKxS0_Pxxj_428532_428633),
    .wenable(wrenable_reg_14));
  register_SE #(.BITSIZE_in1(29),
    .BITSIZE_out1(29)) reg_15 (.out1(out_reg_15_reg_15),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_17_reg_15_0_0_0),
    .wenable(wrenable_reg_15));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_16 (.out1(out_reg_16_reg_16),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_31_i0_fu__Z4axpyPKxS0_Pxxj_428532_428566),
    .wenable(wrenable_reg_16));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_17 (.out1(out_reg_17_reg_17),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_31_i1_fu__Z4axpyPKxS0_Pxxj_428532_428568),
    .wenable(wrenable_reg_17));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_18 (.out1(out_reg_18_reg_18),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_31_i2_fu__Z4axpyPKxS0_Pxxj_428532_428572),
    .wenable(wrenable_reg_18));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_19 (.out1(out_reg_19_reg_19),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_30_i0_fu__Z4axpyPKxS0_Pxxj_428532_428571),
    .wenable(wrenable_reg_19));
  register_SE #(.BITSIZE_in1(31),
    .BITSIZE_out1(31)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_rshift_expr_FU_32_0_32_32_i2_fu__Z4axpyPKxS0_Pxxj_428532_428862),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_31_i3_fu__Z4axpyPKxS0_Pxxj_428532_428588),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_31_i4_fu__Z4axpyPKxS0_Pxxj_428532_428607),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_31_i5_fu__Z4axpyPKxS0_Pxxj_428532_428619),
    .wenable(wrenable_reg_7));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_31_i6_fu__Z4axpyPKxS0_Pxxj_428532_428626),
    .wenable(wrenable_reg_8));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_31_i7_fu__Z4axpyPKxS0_Pxxj_428532_428640),
    .wenable(wrenable_reg_9));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) ui_mult_expr_FU_64_64_64_0_28_i0 (.out1(out_ui_mult_expr_FU_64_64_64_0_28_i0_ui_mult_expr_FU_64_64_64_0_28_i0),
    .clock(clock),
    .in1(out_reg_6_reg_6),
    .in2(in_port_alpha));
  x_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(64)) x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0 (.done_port({s_done_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_P0}),
    .out1(out_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0),
    ._x_TREADY(_x_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port0}),
    .in1(out_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0),
    ._x_TDATA(_x_TDATA),
    ._x_TVALID(_x_TVALID));
  y_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(64)) y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0 (.done_port({s_done_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_P0}),
    .out1(out_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0),
    ._y_TREADY(_y_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port1}),
    .in1(out_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0),
    ._y_TDATA(_y_TDATA),
    ._y_TVALID(_y_TVALID));
  y_out_bambu_artificial_ParmMgr_Write_axis_modgen #(.BITSIZE_in1(7),
    .BITSIZE_in2(64),
    .BITSIZE_in3(32)) y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0 (.done_port({s_done_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_P0}),
    ._y_out_TDATA(_y_out_TDATA),
    ._y_out_TVALID(_y_out_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port({s_start_port2}),
    .in1(out_const_2),
    .in2(out_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1),
    .in3(out_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1),
    ._y_out_TREADY(_y_out_TREADY));
  // io-signal post fix
  assign OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428876 = out_multi_read_cond_FU_16_i0_fu__Z4axpyPKxS0_Pxxj_428532_428876;
  assign OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428889 = out_multi_read_cond_FU_12_i0_fu__Z4axpyPKxS0_Pxxj_428532_428889;
  assign OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567 = s_done_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_P0;
  assign OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569 = s_done_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_P0;
  assign OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604 = s_done_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_P0;
  assign OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616 = s_done_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_P0;
  assign OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637 = s_done_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_P0;
  assign OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646 = s_done_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_P0;
  assign OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835 = s_done_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_P0;
  assign OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840 = s_done_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_P0;
  assign OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845 = s_done_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_P0;

endmodule

// FSM based controller description for _Z4axpyPKxS0_Pxxj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z4axpyPKxS0_Pxxj(done_port,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840,
  selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845,
  selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0,
  selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1,
  selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2,
  selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0,
  selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0,
  selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1,
  selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2,
  selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0,
  selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1,
  selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0,
  selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1,
  selector_MUX_10_reg_0_0_0_0,
  selector_MUX_17_reg_15_0_0_0,
  selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0,
  selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1,
  selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2,
  selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0,
  muenable_mu_S_0,
  muenable_mu_S_5,
  muenable_mu_S_7,
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
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428876,
  OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428889,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840,
  OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845,
  OUT_mu_S_0_MULTI_UNBOUNDED_0,
  OUT_mu_S_5_MULTI_UNBOUNDED_0,
  OUT_mu_S_7_MULTI_UNBOUNDED_0,
  clock,
  reset,
  start_port);
  // IN
  input [1:0] OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428876;
  input [1:0] OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428889;
  input OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567;
  input OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569;
  input OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604;
  input OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616;
  input OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637;
  input OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646;
  input OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835;
  input OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840;
  input OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845;
  input OUT_mu_S_0_MULTI_UNBOUNDED_0;
  input OUT_mu_S_5_MULTI_UNBOUNDED_0;
  input OUT_mu_S_7_MULTI_UNBOUNDED_0;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567;
  output selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569;
  output selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604;
  output selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616;
  output selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637;
  output selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646;
  output selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835;
  output selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840;
  output selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845;
  output selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0;
  output selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1;
  output selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2;
  output selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0;
  output selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0;
  output selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1;
  output selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2;
  output selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0;
  output selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1;
  output selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0;
  output selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1;
  output selector_MUX_10_reg_0_0_0_0;
  output selector_MUX_17_reg_15_0_0_0;
  output selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0;
  output selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1;
  output selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2;
  output selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0;
  output muenable_mu_S_0;
  output muenable_mu_S_5;
  output muenable_mu_S_7;
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
  reg selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567;
  reg selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569;
  reg selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604;
  reg selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616;
  reg selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637;
  reg selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646;
  reg selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835;
  reg selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840;
  reg selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845;
  reg selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0;
  reg selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1;
  reg selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2;
  reg selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0;
  reg selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0;
  reg selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1;
  reg selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2;
  reg selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0;
  reg selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1;
  reg selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0;
  reg selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1;
  reg selector_MUX_10_reg_0_0_0_0;
  reg selector_MUX_17_reg_15_0_0_0;
  reg selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0;
  reg selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1;
  reg selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2;
  reg selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0;
  reg muenable_mu_S_0;
  reg muenable_mu_S_5;
  reg muenable_mu_S_7;
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
    selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567 = 1'b0;
    selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569 = 1'b0;
    selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604 = 1'b0;
    selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616 = 1'b0;
    selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637 = 1'b0;
    selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646 = 1'b0;
    selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835 = 1'b0;
    selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840 = 1'b0;
    selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845 = 1'b0;
    selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0 = 1'b0;
    selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1 = 1'b0;
    selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2 = 1'b0;
    selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0 = 1'b0;
    selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0 = 1'b0;
    selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1 = 1'b0;
    selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2 = 1'b0;
    selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0 = 1'b0;
    selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1 = 1'b0;
    selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0 = 1'b0;
    selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1 = 1'b0;
    selector_MUX_10_reg_0_0_0_0 = 1'b0;
    selector_MUX_17_reg_15_0_0_0 = 1'b0;
    selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0 = 1'b0;
    selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1 = 1'b0;
    selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2 = 1'b0;
    selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0 = 1'b0;
    muenable_mu_S_0 = 1'b0;
    muenable_mu_S_5 = 1'b0;
    muenable_mu_S_7 = 1'b0;
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
          wrenable_reg_15 = 1'b1;
          wrenable_reg_2 = 1'b1;
          casez (OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428876)
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
                wrenable_reg_15 = 1'b0;
                wrenable_reg_2 = 1'b0;
              end
            default:
              begin
                _next_state = S_5;
                wrenable_reg_15 = 1'b0;
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
          selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604 = 1'b1;
          selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616 = 1'b1;
          selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2 = 1'b1;
          selector_MUX_10_reg_0_0_0_0 = 1'b1;
          selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_3 = 1'b1;
          wrenable_reg_4 = OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604;
          wrenable_reg_5 = 1'b1;
          wrenable_reg_6 = OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = 1'b1;
          wrenable_reg_9 = 1'b1;
          if (OUT_mu_S_5_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_6;
              muenable_mu_S_5 = 1'b1;
            end
          else
            begin
              _next_state = S_7;
              muenable_mu_S_5 = 1'b1;
            end
        end
      S_6 :
        begin
          selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0 = 1'b1;
          wrenable_reg_4 = OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604;
          wrenable_reg_6 = OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616;
          if (OUT_mu_S_5_MULTI_UNBOUNDED_0 == 1'b0)
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
          selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637 = 1'b1;
          selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646 = 1'b1;
          selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840 = 1'b1;
          selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0 = 1'b1;
          selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2 = 1'b1;
          selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1 = 1'b1;
          selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1 = 1'b1;
          selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0 = 1'b1;
          wrenable_reg_13 = 1'b1;
          wrenable_reg_4 = OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637;
          wrenable_reg_6 = OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646;
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
          selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0 = 1'b1;
          selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1 = 1'b1;
          selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1 = 1'b1;
          selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0 = 1'b1;
          wrenable_reg_4 = OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637;
          wrenable_reg_6 = OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646;
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
          selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845 = 1'b1;
          selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1 = 1'b1;
          selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0 = 1'b1;
          wrenable_reg_14 = 1'b1;
          if (OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845 == 1'b0)
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
          selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0 = 1'b1;
          selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0 = 1'b1;
          if (OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845 == 1'b0)
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
          selector_MUX_17_reg_15_0_0_0 = 1'b1;
          wrenable_reg_15 = 1'b1;
          casez (OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428889)
            2'b01 :
              begin
                _next_state = S_5;
                selector_MUX_17_reg_15_0_0_0 = 1'b0;
                wrenable_reg_15 = 1'b0;
              end
            2'b10 :
              begin
                _next_state = S_14;
                done_port = 1'b1;
                selector_MUX_17_reg_15_0_0_0 = 1'b0;
                wrenable_reg_15 = 1'b0;
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
          selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567 = 1'b1;
          selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569 = 1'b1;
          selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0 = 1'b1;
          selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0 = 1'b1;
          wrenable_reg_16 = 1'b1;
          wrenable_reg_17 = 1'b1;
          wrenable_reg_18 = 1'b1;
          wrenable_reg_4 = OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569;
          wrenable_reg_6 = OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567;
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
          selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1 = 1'b1;
          selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0 = 1'b1;
          wrenable_reg_4 = OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569;
          wrenable_reg_6 = OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567;
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
          selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835 = 1'b1;
          selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1 = 1'b1;
          wrenable_reg_19 = 1'b1;
          if (OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835 == 1'b0)
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
          selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0 = 1'b1;
          selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0 = 1'b1;
          selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1 = 1'b1;
          if (OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835 == 1'b0)
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

// Top component for _Z4axpyPKxS0_Pxxj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z4axpyPKxS0_Pxxj(clock,
  reset,
  start_port,
  done_port,
  x,
  y,
  y_out,
  alpha,
  loop_count,
  _x_TDATA,
  _x_TVALID,
  _y_TDATA,
  _y_TVALID,
  _y_out_TREADY,
  _x_TREADY,
  _y_TREADY,
  _y_out_TDATA,
  _y_out_TVALID);
  // IN
  input clock;
  input reset;
  input start_port;
  input [31:0] x;
  input [31:0] y;
  input [31:0] y_out;
  input [63:0] alpha;
  input [31:0] loop_count;
  input [63:0] _x_TDATA;
  input _x_TVALID;
  input [63:0] _y_TDATA;
  input _y_TVALID;
  input _y_out_TREADY;
  // OUT
  output done_port;
  output _x_TREADY;
  output _y_TREADY;
  output [63:0] _y_out_TDATA;
  output _y_out_TVALID;
  // Component and signal declarations
  wire [1:0] OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428876;
  wire [1:0] OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428889;
  wire OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567;
  wire OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569;
  wire OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604;
  wire OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616;
  wire OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637;
  wire OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646;
  wire OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835;
  wire OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840;
  wire OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845;
  wire OUT_mu_S_0_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_5_MULTI_UNBOUNDED_0;
  wire OUT_mu_S_7_MULTI_UNBOUNDED_0;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire muenable_mu_S_0;
  wire muenable_mu_S_5;
  wire muenable_mu_S_7;
  wire selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567;
  wire selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569;
  wire selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604;
  wire selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616;
  wire selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637;
  wire selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646;
  wire selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835;
  wire selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840;
  wire selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845;
  wire selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0;
  wire selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1;
  wire selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2;
  wire selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0;
  wire selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0;
  wire selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1;
  wire selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2;
  wire selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0;
  wire selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1;
  wire selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0;
  wire selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1;
  wire selector_MUX_10_reg_0_0_0_0;
  wire selector_MUX_17_reg_15_0_0_0;
  wire selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0;
  wire selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1;
  wire selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2;
  wire selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0;
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
  wire wrenable_reg_3;
  wire wrenable_reg_4;
  wire wrenable_reg_5;
  wire wrenable_reg_6;
  wire wrenable_reg_7;
  wire wrenable_reg_8;
  wire wrenable_reg_9;
  
  controller__Z4axpyPKxS0_Pxxj Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845),
    .selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0(selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0),
    .selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1(selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1),
    .selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2(selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2),
    .selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0(selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0),
    .selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0),
    .selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1),
    .selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2),
    .selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0),
    .selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1),
    .selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0(selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0),
    .selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1(selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1),
    .selector_MUX_10_reg_0_0_0_0(selector_MUX_10_reg_0_0_0_0),
    .selector_MUX_17_reg_15_0_0_0(selector_MUX_17_reg_15_0_0_0),
    .selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0(selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0),
    .selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1(selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1),
    .selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2(selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2),
    .selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0(selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0),
    .muenable_mu_S_0(muenable_mu_S_0),
    .muenable_mu_S_5(muenable_mu_S_5),
    .muenable_mu_S_7(muenable_mu_S_7),
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
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9),
    .OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428876(OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428876),
    .OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428889(OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428889),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845),
    .OUT_mu_S_0_MULTI_UNBOUNDED_0(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .OUT_mu_S_5_MULTI_UNBOUNDED_0(OUT_mu_S_5_MULTI_UNBOUNDED_0),
    .OUT_mu_S_7_MULTI_UNBOUNDED_0(OUT_mu_S_7_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z4axpyPKxS0_Pxxj Datapath_i (._x_TREADY(_x_TREADY),
    ._y_TREADY(_y_TREADY),
    ._y_out_TDATA(_y_out_TDATA),
    ._y_out_TVALID(_y_out_TVALID),
    .OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428876(OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428876),
    .OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428889(OUT_MULTIIF__Z4axpyPKxS0_Pxxj_428532_428889),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840),
    .OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845(OUT_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845),
    .OUT_mu_S_0_MULTI_UNBOUNDED_0(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .OUT_mu_S_5_MULTI_UNBOUNDED_0(OUT_mu_S_5_MULTI_UNBOUNDED_0),
    .OUT_mu_S_7_MULTI_UNBOUNDED_0(OUT_mu_S_7_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .in_port_x(x),
    .in_port_y(y),
    .in_port_y_out(y_out),
    .in_port_alpha(alpha),
    .in_port_loop_count(loop_count),
    ._x_TDATA(_x_TDATA),
    ._x_TVALID(_x_TVALID),
    ._y_TDATA(_y_TDATA),
    ._y_TVALID(_y_TVALID),
    ._y_out_TREADY(_y_out_TREADY),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428567),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428569),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428604),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428616),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428637),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428646),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428835),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428840),
    .selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845(selector_IN_UNBOUNDED__Z4axpyPKxS0_Pxxj_428532_428845),
    .selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0(selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_0),
    .selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1(selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_1),
    .selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2(selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_0_2),
    .selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0(selector_MUX_100_y_bambu_artificial_ParmMgr_Read_axis_modgen_34_i0_0_1_0),
    .selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_0),
    .selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_1),
    .selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_0_2),
    .selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_0),
    .selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1(selector_MUX_102_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_1_1_1),
    .selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0(selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_0),
    .selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1(selector_MUX_103_y_out_bambu_artificial_ParmMgr_Write_axis_modgen_35_i0_2_0_1),
    .selector_MUX_10_reg_0_0_0_0(selector_MUX_10_reg_0_0_0_0),
    .selector_MUX_17_reg_15_0_0_0(selector_MUX_17_reg_15_0_0_0),
    .selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0(selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_0),
    .selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1(selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_1),
    .selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2(selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_0_2),
    .selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0(selector_MUX_99_x_bambu_artificial_ParmMgr_Read_axis_modgen_33_i0_0_1_0),
    .muenable_mu_S_0(muenable_mu_S_0),
    .muenable_mu_S_5(muenable_mu_S_5),
    .muenable_mu_S_7(muenable_mu_S_7),
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

// Minimal interface for function: _Z4axpyPKxS0_Pxxj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z4axpyPKxS0_Pxxj(clock,
  reset,
  start_port,
  x_TDATA,
  y_TDATA,
  alpha,
  loop_count,
  x_TVALID,
  y_TVALID,
  y_out_TREADY,
  done_port,
  x_TREADY,
  y_TREADY,
  y_out_TDATA,
  y_out_TVALID);
  // IN
  input clock;
  input reset;
  input start_port;
  input [63:0] x_TDATA;
  input [63:0] y_TDATA;
  input [63:0] alpha;
  input [31:0] loop_count;
  input x_TVALID;
  input y_TVALID;
  input y_out_TREADY;
  // OUT
  output done_port;
  output x_TREADY;
  output y_TREADY;
  output [63:0] y_out_TDATA;
  output y_out_TVALID;
  // Component and signal declarations
  
  __Z4axpyPKxS0_Pxxj __Z4axpyPKxS0_Pxxj_i0 (.done_port(done_port),
    ._x_TREADY(x_TREADY),
    ._y_TREADY(y_TREADY),
    ._y_out_TDATA(y_out_TDATA),
    ._y_out_TVALID(y_out_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port(start_port),
    .x(32'b00000000000000000000000000000000),
    .y(32'b00000000000000000000000000000000),
    .y_out(32'b00000000000000000000000000000000),
    .alpha(alpha),
    .loop_count(loop_count),
    ._x_TDATA(x_TDATA),
    ._x_TVALID(x_TVALID),
    ._y_TDATA(y_TDATA),
    ._y_TVALID(y_TVALID),
    ._y_out_TREADY(y_out_TREADY));

endmodule


