// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-03T13:38:05
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=dot --top-rtldesign-name=dot --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --generate-interface=INFER --simulate --simulator=VERILATOR --generate-tb=/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/dot/src/tb_dot.cpp --tb-extra-gcc-options=-DDUT=dot -DCFG_LOOP_COUNT=16 -DCFG_LEN=16 --tb-param-size=A:4096,B:4096,out:8 -DDATA_T=int64_t -DSIZE_N=512 -DBAMBU_LANES=32 --std=c++14 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include/bambu -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/dot/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/dot/vectors/n512 /users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/dot/bambu_unopt_n512_w32_proj/dot.cpp 
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
    BITSIZE_out1=2048;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [2047:0] _A_TDATA;
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
    BITSIZE_out1=2048;
  // IN
  input clock;
  input reset;
  input [0:0] start_port;
  input [BITSIZE_in1-1:0] in1;
  input [2047:0] _B_TDATA;
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

// Datapath RTL description for _Z3dotPK6ac_intILi2048ELb0EES2_Pxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj(clock,
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
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0,
  selector_MUX_22_reg_0_0_0_0,
  selector_MUX_23_reg_1_0_0_0,
  selector_MUX_25_reg_11_0_0_0,
  selector_MUX_26_reg_12_0_0_0,
  selector_MUX_29_reg_2_0_0_0,
  selector_MUX_30_reg_3_0_0_0,
  muenable_mu_S_0,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_10,
  wrenable_reg_11,
  wrenable_reg_12,
  wrenable_reg_13,
  wrenable_reg_14,
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708,
  OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716,
  OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722,
  OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844,
  OUT_mu_S_0_MULTI_UNBOUNDED_0);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_A;
  input [31:0] in_port_B;
  input [31:0] in_port_out;
  input [31:0] in_port_loop_count;
  input [31:0] in_port_len;
  input [2047:0] _A_TDATA;
  input _A_TVALID;
  input [2047:0] _B_TDATA;
  input _B_TVALID;
  input _out_TREADY;
  input selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569;
  input selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571;
  input selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844;
  input selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0;
  input selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0;
  input selector_MUX_22_reg_0_0_0_0;
  input selector_MUX_23_reg_1_0_0_0;
  input selector_MUX_25_reg_11_0_0_0;
  input selector_MUX_26_reg_12_0_0_0;
  input selector_MUX_29_reg_2_0_0_0;
  input selector_MUX_30_reg_3_0_0_0;
  input muenable_mu_S_0;
  input wrenable_reg_0;
  input wrenable_reg_1;
  input wrenable_reg_10;
  input wrenable_reg_11;
  input wrenable_reg_12;
  input wrenable_reg_13;
  input wrenable_reg_14;
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
  output OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708;
  output OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716;
  output OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722;
  output OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733;
  output OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569;
  output OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571;
  output OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844;
  output OUT_mu_S_0_MULTI_UNBOUNDED_0;
  // Component and signal declarations
  wire [2047:0] out_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569;
  wire [2047:0] out_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571;
  wire [31:0] out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0;
  wire [31:0] out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0;
  wire [31:0] out_MUX_22_reg_0_0_0_0;
  wire [63:0] out_MUX_23_reg_1_0_0_0;
  wire [63:0] out_MUX_25_reg_11_0_0_0;
  wire [31:0] out_MUX_26_reg_12_0_0_0;
  wire [31:0] out_MUX_29_reg_2_0_0_0;
  wire [31:0] out_MUX_30_reg_3_0_0_0;
  wire out_UUdata_converter_FU_18_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428718;
  wire [10:0] out_UUdata_converter_FU_22_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428653;
  wire [10:0] out_UUdata_converter_FU_23_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428624;
  wire [31:0] out_UUdata_converter_FU_24_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428672;
  wire [31:0] out_UUdata_converter_FU_25_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428663;
  wire [31:0] out_UUdata_converter_FU_26_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428647;
  wire [31:0] out_UUdata_converter_FU_27_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428612;
  wire out_UUdata_converter_FU_28_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428732;
  wire out_UUdata_converter_FU_9_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428707;
  wire out_const_0;
  wire out_const_1;
  wire [3:0] out_const_2;
  wire [5:0] out_const_3;
  wire [6:0] out_const_4;
  wire [1:0] out_const_5;
  wire [2:0] out_const_6;
  wire [31:0] out_const_7;
  wire [31:0] out_conv_out_const_0_1_32;
  wire [63:0] out_conv_out_const_0_1_64;
  wire out_read_cond_FU_10_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708;
  wire out_read_cond_FU_17_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716;
  wire out_read_cond_FU_19_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722;
  wire out_read_cond_FU_29_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733;
  wire [31:0] out_reg_0_reg_0;
  wire [31:0] out_reg_10_reg_10;
  wire [63:0] out_reg_11_reg_11;
  wire [31:0] out_reg_12_reg_12;
  wire [63:0] out_reg_13_reg_13;
  wire out_reg_14_reg_14;
  wire [63:0] out_reg_1_reg_1;
  wire [31:0] out_reg_2_reg_2;
  wire [31:0] out_reg_3_reg_3;
  wire [31:0] out_reg_4_reg_4;
  wire [2047:0] out_reg_5_reg_5;
  wire [2047:0] out_reg_6_reg_6;
  wire [31:0] out_reg_7_reg_7;
  wire [31:0] out_reg_8_reg_8;
  wire [31:0] out_reg_9_reg_9;
  wire out_truth_and_expr_FU_1_0_1_30_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428777;
  wire out_truth_and_expr_FU_1_0_1_30_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428853;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_31_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428643;
  wire [31:0] out_ui_bit_and_expr_FU_32_0_32_31_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428669;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_32_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428604;
  wire [63:0] out_ui_bit_ior_expr_FU_0_64_64_33_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428656;
  wire [10:0] out_ui_bit_ior_expr_FU_16_0_16_34_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428629;
  wire [0:0] out_ui_cond_expr_FU_1_1_1_1_35_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428721;
  wire out_ui_eq_expr_FU_32_0_32_36_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428765;
  wire out_ui_eq_expr_FU_32_0_32_37_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428786;
  wire out_ui_eq_expr_FU_32_32_32_38_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428768;
  wire out_ui_eq_expr_FU_32_32_32_38_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428771;
  wire [10:0] out_ui_lshift_expr_FU_32_0_32_39_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428633;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_40_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428750;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_41_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428779;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_42_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428608;
  wire [63:0] out_ui_lshift_expr_FU_64_0_64_42_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428660;
  wire [63:0] out_ui_mult_expr_FU_64_64_64_0_43_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428600;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_44_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428640;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_44_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428681;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_44_i2_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428686;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_44_i3_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428692;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_45_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428589;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_45_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428595;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_46_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428568;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_46_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428570;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_46_i2_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428582;
  wire [31:0] out_ui_rshift_expr_FU_64_64_64_47_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428616;
  wire [31:0] out_ui_rshift_expr_FU_64_64_64_47_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428650;
  wire [31:0] out_ui_rshift_expr_FU_64_64_64_47_i2_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428666;
  wire [31:0] out_ui_rshift_expr_FU_64_64_64_47_i3_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428675;
  wire [63:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire [31:0] out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1;
  wire s_done_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569_P0;
  wire s_done_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571_P0;
  wire s_done_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844_P0;
  
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0 (.out1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0),
    .sel(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0),
    .in1(out_reg_9_reg_9),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_46_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428568));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0 (.out1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0),
    .sel(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0),
    .in1(out_reg_10_reg_10),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_46_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428570));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_22_reg_0_0_0_0 (.out1(out_MUX_22_reg_0_0_0_0),
    .sel(selector_MUX_22_reg_0_0_0_0),
    .in1(out_reg_7_reg_7),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_23_reg_1_0_0_0 (.out1(out_MUX_23_reg_1_0_0_0),
    .sel(selector_MUX_23_reg_1_0_0_0),
    .in1(out_ui_plus_expr_FU_64_64_64_45_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428589),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_25_reg_11_0_0_0 (.out1(out_MUX_25_reg_11_0_0_0),
    .sel(selector_MUX_25_reg_11_0_0_0),
    .in1(out_ui_plus_expr_FU_64_64_64_45_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428595),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_26_reg_12_0_0_0 (.out1(out_MUX_26_reg_12_0_0_0),
    .sel(selector_MUX_26_reg_12_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_44_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428640),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_29_reg_2_0_0_0 (.out1(out_MUX_29_reg_2_0_0_0),
    .sel(selector_MUX_29_reg_2_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_44_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428681),
    .in2(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_30_reg_3_0_0_0 (.out1(out_MUX_30_reg_3_0_0_0),
    .sel(selector_MUX_30_reg_3_0_0_0),
    .in1(out_reg_8_reg_8),
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
  constant_value #(.BITSIZE_out1(32),
    .value(32'b11111111111111111111111111111111)) const_7 (.out1(out_const_7));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(64)) conv_out_const_0_1_64 (.out1(out_conv_out_const_0_1_64),
    .in1(out_const_0));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428568 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_46_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428568),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_40_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428750));
  A_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(2048)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569 (.done_port({s_done_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569_P0}),
    .out1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569),
    ._A_TREADY(_A_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569}),
    .in1(out_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0),
    ._A_TDATA(_A_TDATA),
    ._A_TVALID(_A_TVALID));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428570 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_46_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428570),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_40_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428750));
  B_bambu_artificial_ParmMgr_Read_axis_modgen #(.BITSIZE_in1(32),
    .BITSIZE_out1(2048)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571 (.done_port({s_done_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571_P0}),
    .out1(out_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571),
    ._B_TREADY(_B_TREADY),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571}),
    .in1(out_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0),
    ._B_TDATA(_B_TDATA),
    ._B_TVALID(_B_TVALID));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428582 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_46_i2_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428582),
    .in1(in_port_out),
    .in2(out_ui_lshift_expr_FU_32_0_32_41_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428779));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428589 (.out1(out_ui_plus_expr_FU_64_64_64_45_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428589),
    .in1(out_reg_11_reg_11),
    .in2(out_reg_1_reg_1));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428595 (.out1(out_ui_plus_expr_FU_64_64_64_45_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428595),
    .in1(out_reg_11_reg_11),
    .in2(out_ui_mult_expr_FU_64_64_64_0_43_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428600));
  ui_mult_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64),
    .PIPE_PARAMETER(0)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428600 (.out1(out_ui_mult_expr_FU_64_64_64_0_43_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428600),
    .clock(clock),
    .in1(out_ui_bit_ior_expr_FU_0_64_64_32_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428604),
    .in2(out_ui_bit_ior_expr_FU_0_64_64_33_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428656));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428604 (.out1(out_ui_bit_ior_expr_FU_0_64_64_32_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428604),
    .in1(out_ui_lshift_expr_FU_64_0_64_42_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428608),
    .in2(out_ui_bit_and_expr_FU_32_0_32_31_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428643));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428608 (.out1(out_ui_lshift_expr_FU_64_0_64_42_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428608),
    .in1(out_UUdata_converter_FU_27_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428612),
    .in2(out_const_3));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428612 (.out1(out_UUdata_converter_FU_27_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428612),
    .in1(out_ui_rshift_expr_FU_64_64_64_47_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428616));
  ui_rshift_expr_FU #(.BITSIZE_in1(2048),
    .BITSIZE_in2(11),
    .BITSIZE_out1(32),
    .PRECISION(2048)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428616 (.out1(out_ui_rshift_expr_FU_64_64_64_47_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428616),
    .in1(out_reg_5_reg_5),
    .in2(out_UUdata_converter_FU_23_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428624));
  UUdata_converter_FU #(.BITSIZE_in1(11),
    .BITSIZE_out1(11)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428624 (.out1(out_UUdata_converter_FU_23_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428624),
    .in1(out_ui_bit_ior_expr_FU_16_0_16_34_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428629));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(11),
    .BITSIZE_in2(6),
    .BITSIZE_out1(11)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428629 (.out1(out_ui_bit_ior_expr_FU_16_0_16_34_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428629),
    .in1(out_ui_lshift_expr_FU_32_0_32_39_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428633),
    .in2(out_const_3));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(3),
    .BITSIZE_out1(11),
    .PRECISION(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428633 (.out1(out_ui_lshift_expr_FU_32_0_32_39_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428633),
    .in1(out_reg_12_reg_12),
    .in2(out_const_6));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428640 (.out1(out_ui_plus_expr_FU_32_0_32_44_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428640),
    .in1(out_reg_12_reg_12),
    .in2(out_const_1));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428643 (.out1(out_ui_bit_and_expr_FU_32_0_32_31_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428643),
    .in1(out_UUdata_converter_FU_26_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428647),
    .in2(out_const_7));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428647 (.out1(out_UUdata_converter_FU_26_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428647),
    .in1(out_ui_rshift_expr_FU_64_64_64_47_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428650));
  ui_rshift_expr_FU #(.BITSIZE_in1(2048),
    .BITSIZE_in2(11),
    .BITSIZE_out1(32),
    .PRECISION(2048)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428650 (.out1(out_ui_rshift_expr_FU_64_64_64_47_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428650),
    .in1(out_reg_5_reg_5),
    .in2(out_UUdata_converter_FU_22_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428653));
  UUdata_converter_FU #(.BITSIZE_in1(11),
    .BITSIZE_out1(11)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428653 (.out1(out_UUdata_converter_FU_22_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428653),
    .in1(out_ui_lshift_expr_FU_32_0_32_39_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428633));
  ui_bit_ior_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(32),
    .BITSIZE_out1(64)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428656 (.out1(out_ui_bit_ior_expr_FU_0_64_64_33_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428656),
    .in1(out_ui_lshift_expr_FU_64_0_64_42_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428660),
    .in2(out_ui_bit_and_expr_FU_32_0_32_31_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428669));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(64),
    .PRECISION(64)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428660 (.out1(out_ui_lshift_expr_FU_64_0_64_42_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428660),
    .in1(out_UUdata_converter_FU_25_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428663),
    .in2(out_const_3));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428663 (.out1(out_UUdata_converter_FU_25_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428663),
    .in1(out_ui_rshift_expr_FU_64_64_64_47_i2_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428666));
  ui_rshift_expr_FU #(.BITSIZE_in1(2048),
    .BITSIZE_in2(11),
    .BITSIZE_out1(32),
    .PRECISION(2048)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428666 (.out1(out_ui_rshift_expr_FU_64_64_64_47_i2_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428666),
    .in1(out_reg_6_reg_6),
    .in2(out_UUdata_converter_FU_23_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428624));
  ui_bit_and_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428669 (.out1(out_ui_bit_and_expr_FU_32_0_32_31_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428669),
    .in1(out_UUdata_converter_FU_24_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428672),
    .in2(out_const_7));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428672 (.out1(out_UUdata_converter_FU_24_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428672),
    .in1(out_ui_rshift_expr_FU_64_64_64_47_i3_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428675));
  ui_rshift_expr_FU #(.BITSIZE_in1(2048),
    .BITSIZE_in2(11),
    .BITSIZE_out1(32),
    .PRECISION(2048)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428675 (.out1(out_ui_rshift_expr_FU_64_64_64_47_i3_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428675),
    .in1(out_reg_6_reg_6),
    .in2(out_UUdata_converter_FU_22_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428653));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428681 (.out1(out_ui_plus_expr_FU_32_0_32_44_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428681),
    .in1(out_reg_2_reg_2),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428686 (.out1(out_ui_plus_expr_FU_32_0_32_44_i2_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428686),
    .in1(out_reg_0_reg_0),
    .in2(out_const_1));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428692 (.out1(out_ui_plus_expr_FU_32_0_32_44_i3_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428692),
    .in1(out_reg_3_reg_3),
    .in2(out_const_1));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428707 (.out1(out_UUdata_converter_FU_9_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428707),
    .in1(out_ui_eq_expr_FU_32_0_32_36_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428765));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708 (.out1(out_read_cond_FU_10_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708),
    .in1(out_UUdata_converter_FU_9_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428707));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716 (.out1(out_read_cond_FU_17_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716),
    .in1(out_reg_14_reg_14));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428718 (.out1(out_UUdata_converter_FU_18_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428718),
    .in1(out_ui_eq_expr_FU_32_32_32_38_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428771));
  ui_cond_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_in3(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428721 (.out1(out_ui_cond_expr_FU_1_1_1_1_35_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428721),
    .in1(out_truth_and_expr_FU_1_0_1_30_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428777),
    .in2(out_const_1),
    .in3(out_UUdata_converter_FU_18_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428718));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722 (.out1(out_read_cond_FU_19_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722),
    .in1(out_ui_cond_expr_FU_1_1_1_1_35_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428721));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428732 (.out1(out_UUdata_converter_FU_28_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428732),
    .in1(out_ui_eq_expr_FU_32_0_32_37_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428786));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733 (.out1(out_read_cond_FU_29_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733),
    .in1(out_UUdata_converter_FU_28_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428732));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(4),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428750 (.out1(out_ui_lshift_expr_FU_32_0_32_40_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428750),
    .in1(out_reg_2_reg_2),
    .in2(out_const_2));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428765 (.out1(out_ui_eq_expr_FU_32_0_32_36_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428765),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428768 (.out1(out_ui_eq_expr_FU_32_32_32_38_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428768),
    .in1(out_reg_8_reg_8),
    .in2(in_port_len));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428771 (.out1(out_ui_eq_expr_FU_32_32_32_38_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428771),
    .in1(out_reg_2_reg_2),
    .in2(in_port_loop_count));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428777 (.out1(out_truth_and_expr_FU_1_0_1_30_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428777),
    .in1(out_truth_and_expr_FU_1_0_1_30_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428853),
    .in2(out_const_1));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(2),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428779 (.out1(out_ui_lshift_expr_FU_32_0_32_41_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428779),
    .in1(out_reg_0_reg_0),
    .in2(out_const_5));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428786 (.out1(out_ui_eq_expr_FU_32_0_32_37_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428786),
    .in1(out_ui_plus_expr_FU_32_0_32_44_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428640),
    .in2(out_const_3));
  out_bambu_artificial_ParmMgr_Write_axis_modgen #(.BITSIZE_in1(7),
    .BITSIZE_in2(64),
    .BITSIZE_in3(32)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844 (.done_port({s_done_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844_P0}),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .clock(clock),
    .reset(reset),
    .start_port({selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844}),
    .in1(out_const_4),
    .in2(out_reg_13_reg_13),
    .in3(out_reg_4_reg_4),
    ._out_TREADY(_out_TREADY));
  truth_and_expr_FU #(.BITSIZE_in1(1),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428853 (.out1(out_truth_and_expr_FU_1_0_1_30_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428853),
    .in1(out_ui_eq_expr_FU_32_32_32_38_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428768),
    .in2(out_const_1));
  SIMPLEJOIN_FU #(.BITSIZE_ops(1),
    .PORTSIZE_ops(2)) mu_S_0 (.sop(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .enable(muenable_mu_S_0),
    .ops({s_done_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571_P0,
      s_done_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569_P0}));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_22_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_23_reg_1_0_0_0),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_10 (.out1(out_reg_10_reg_10),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_46_i1_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428570),
    .wenable(wrenable_reg_10));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_25_reg_11_0_0_0),
    .wenable(wrenable_reg_11));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_12 (.out1(out_reg_12_reg_12),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_26_reg_12_0_0_0),
    .wenable(wrenable_reg_12));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_13 (.out1(out_reg_13_reg_13),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_45_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428589),
    .wenable(wrenable_reg_13));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_14 (.out1(out_reg_14_reg_14),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_18_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428718),
    .wenable(wrenable_reg_14));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_29_reg_2_0_0_0),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_30_reg_3_0_0_0),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_46_i2_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428582),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(2048),
    .BITSIZE_out1(2048)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(2048),
    .BITSIZE_out1(2048)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_44_i2_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428686),
    .wenable(wrenable_reg_7));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_32_0_32_44_i3_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428692),
    .wenable(wrenable_reg_8));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_46_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428568),
    .wenable(wrenable_reg_9));
  // io-signal post fix
  assign OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708 = out_read_cond_FU_10_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708;
  assign OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716 = out_read_cond_FU_17_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716;
  assign OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722 = out_read_cond_FU_19_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722;
  assign OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733 = out_read_cond_FU_29_i0_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733;
  assign OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569 = s_done_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569_P0;
  assign OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571 = s_done_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571_P0;
  assign OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844 = s_done_fu__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844_P0;

endmodule

// FSM based controller description for _Z3dotPK6ac_intILi2048ELb0EES2_Pxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj(done_port,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571,
  selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844,
  selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0,
  selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0,
  selector_MUX_22_reg_0_0_0_0,
  selector_MUX_23_reg_1_0_0_0,
  selector_MUX_25_reg_11_0_0_0,
  selector_MUX_26_reg_12_0_0_0,
  selector_MUX_29_reg_2_0_0_0,
  selector_MUX_30_reg_3_0_0_0,
  muenable_mu_S_0,
  wrenable_reg_0,
  wrenable_reg_1,
  wrenable_reg_10,
  wrenable_reg_11,
  wrenable_reg_12,
  wrenable_reg_13,
  wrenable_reg_14,
  wrenable_reg_2,
  wrenable_reg_3,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708,
  OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716,
  OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722,
  OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571,
  OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844,
  OUT_mu_S_0_MULTI_UNBOUNDED_0,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708;
  input OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716;
  input OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722;
  input OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733;
  input OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569;
  input OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571;
  input OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844;
  input OUT_mu_S_0_MULTI_UNBOUNDED_0;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569;
  output selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571;
  output selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844;
  output selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0;
  output selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0;
  output selector_MUX_22_reg_0_0_0_0;
  output selector_MUX_23_reg_1_0_0_0;
  output selector_MUX_25_reg_11_0_0_0;
  output selector_MUX_26_reg_12_0_0_0;
  output selector_MUX_29_reg_2_0_0_0;
  output selector_MUX_30_reg_3_0_0_0;
  output muenable_mu_S_0;
  output wrenable_reg_0;
  output wrenable_reg_1;
  output wrenable_reg_10;
  output wrenable_reg_11;
  output wrenable_reg_12;
  output wrenable_reg_13;
  output wrenable_reg_14;
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
  reg selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569;
  reg selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571;
  reg selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844;
  reg selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0;
  reg selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0;
  reg selector_MUX_22_reg_0_0_0_0;
  reg selector_MUX_23_reg_1_0_0_0;
  reg selector_MUX_25_reg_11_0_0_0;
  reg selector_MUX_26_reg_12_0_0_0;
  reg selector_MUX_29_reg_2_0_0_0;
  reg selector_MUX_30_reg_3_0_0_0;
  reg muenable_mu_S_0;
  reg wrenable_reg_0;
  reg wrenable_reg_1;
  reg wrenable_reg_10;
  reg wrenable_reg_11;
  reg wrenable_reg_12;
  reg wrenable_reg_13;
  reg wrenable_reg_14;
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
    selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569 = 1'b0;
    selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571 = 1'b0;
    selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844 = 1'b0;
    selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0 = 1'b0;
    selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0 = 1'b0;
    selector_MUX_22_reg_0_0_0_0 = 1'b0;
    selector_MUX_23_reg_1_0_0_0 = 1'b0;
    selector_MUX_25_reg_11_0_0_0 = 1'b0;
    selector_MUX_26_reg_12_0_0_0 = 1'b0;
    selector_MUX_29_reg_2_0_0_0 = 1'b0;
    selector_MUX_30_reg_3_0_0_0 = 1'b0;
    muenable_mu_S_0 = 1'b0;
    wrenable_reg_0 = 1'b0;
    wrenable_reg_1 = 1'b0;
    wrenable_reg_10 = 1'b0;
    wrenable_reg_11 = 1'b0;
    wrenable_reg_12 = 1'b0;
    wrenable_reg_13 = 1'b0;
    wrenable_reg_14 = 1'b0;
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
          if (OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708 == 1'b0)
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
          selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569 = 1'b1;
          selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571 = 1'b1;
          selector_MUX_29_reg_2_0_0_0 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_4 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571;
          wrenable_reg_6 = OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = 1'b1;
          wrenable_reg_9 = 1'b1;
          if (OUT_mu_S_0_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_1;
              muenable_mu_S_0 = 1'b1;
              wrenable_reg_11 = 1'b0;
              wrenable_reg_12 = 1'b0;
            end
          else
            begin
              _next_state = S_7;
              muenable_mu_S_0 = 1'b1;
            end
        end
      S_1 :
        begin
          selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0 = 1'b1;
          selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0 = 1'b1;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_5 = OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571;
          wrenable_reg_6 = OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569;
          if (OUT_mu_S_0_MULTI_UNBOUNDED_0 == 1'b0)
            begin
              _next_state = S_1;
              wrenable_reg_11 = 1'b0;
              wrenable_reg_12 = 1'b0;
            end
          else
            begin
              _next_state = S_7;
            end
        end
      S_7 :
        begin
          selector_MUX_25_reg_11_0_0_0 = 1'b1;
          selector_MUX_26_reg_12_0_0_0 = 1'b1;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_12 = 1'b1;
          if (OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733 == 1'b1)
            begin
              _next_state = S_4;
              selector_MUX_26_reg_12_0_0_0 = 1'b0;
              wrenable_reg_12 = 1'b0;
            end
          else
            begin
              _next_state = S_7;
            end
        end
      S_4 :
        begin
          selector_MUX_23_reg_1_0_0_0 = 1'b1;
          selector_MUX_30_reg_3_0_0_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_13 = 1'b1;
          wrenable_reg_14 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722 == 1'b1)
            begin
              _next_state = S_5;
              selector_MUX_23_reg_1_0_0_0 = 1'b0;
              selector_MUX_30_reg_3_0_0_0 = 1'b0;
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
          selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844 = 1'b1;
          selector_MUX_22_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844 == 1'b0)
            begin
              _next_state = S_6;
              selector_MUX_22_reg_0_0_0_0 = 1'b0;
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
          selector_MUX_22_reg_0_0_0_0 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_3 = 1'b1;
          if (OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844 == 1'b0)
            begin
              _next_state = S_6;
              selector_MUX_22_reg_0_0_0_0 = 1'b0;
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
          if (OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716 == 1'b0)
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

// Top component for _Z3dotPK6ac_intILi2048ELb0EES2_Pxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z3dotPK6ac_intILi2048ELb0EES2_Pxjj(clock,
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
  input [2047:0] _A_TDATA;
  input _A_TVALID;
  input [2047:0] _B_TDATA;
  input _B_TVALID;
  input _out_TREADY;
  // OUT
  output done_port;
  output _A_TREADY;
  output _B_TREADY;
  output [63:0] _out_TDATA;
  output _out_TVALID;
  // Component and signal declarations
  wire OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708;
  wire OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716;
  wire OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722;
  wire OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733;
  wire OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569;
  wire OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571;
  wire OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844;
  wire OUT_mu_S_0_MULTI_UNBOUNDED_0;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire muenable_mu_S_0;
  wire selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569;
  wire selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571;
  wire selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844;
  wire selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0;
  wire selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0;
  wire selector_MUX_22_reg_0_0_0_0;
  wire selector_MUX_23_reg_1_0_0_0;
  wire selector_MUX_25_reg_11_0_0_0;
  wire selector_MUX_26_reg_12_0_0_0;
  wire selector_MUX_29_reg_2_0_0_0;
  wire selector_MUX_30_reg_3_0_0_0;
  wire wrenable_reg_0;
  wire wrenable_reg_1;
  wire wrenable_reg_10;
  wire wrenable_reg_11;
  wire wrenable_reg_12;
  wire wrenable_reg_13;
  wire wrenable_reg_14;
  wire wrenable_reg_2;
  wire wrenable_reg_3;
  wire wrenable_reg_4;
  wire wrenable_reg_5;
  wire wrenable_reg_6;
  wire wrenable_reg_7;
  wire wrenable_reg_8;
  wire wrenable_reg_9;
  
  controller__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj Controller_i (.done_port(done_delayed_REG_signal_in),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0),
    .selector_MUX_22_reg_0_0_0_0(selector_MUX_22_reg_0_0_0_0),
    .selector_MUX_23_reg_1_0_0_0(selector_MUX_23_reg_1_0_0_0),
    .selector_MUX_25_reg_11_0_0_0(selector_MUX_25_reg_11_0_0_0),
    .selector_MUX_26_reg_12_0_0_0(selector_MUX_26_reg_12_0_0_0),
    .selector_MUX_29_reg_2_0_0_0(selector_MUX_29_reg_2_0_0_0),
    .selector_MUX_30_reg_3_0_0_0(selector_MUX_30_reg_3_0_0_0),
    .muenable_mu_S_0(muenable_mu_S_0),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_10(wrenable_reg_10),
    .wrenable_reg_11(wrenable_reg_11),
    .wrenable_reg_12(wrenable_reg_12),
    .wrenable_reg_13(wrenable_reg_13),
    .wrenable_reg_14(wrenable_reg_14),
    .wrenable_reg_2(wrenable_reg_2),
    .wrenable_reg_3(wrenable_reg_3),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9),
    .OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708(OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708),
    .OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716(OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716),
    .OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722(OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722),
    .OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733(OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569(OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571(OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844(OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844),
    .OUT_mu_S_0_MULTI_UNBOUNDED_0(OUT_mu_S_0_MULTI_UNBOUNDED_0),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj Datapath_i (._A_TREADY(_A_TREADY),
    ._B_TREADY(_B_TREADY),
    ._out_TDATA(_out_TDATA),
    ._out_TVALID(_out_TVALID),
    .OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708(OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428708),
    .OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716(OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428716),
    .OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722(OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428722),
    .OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733(OUT_CONDITION__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428733),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569(OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571(OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571),
    .OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844(OUT_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844),
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
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428569),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428571),
    .selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844(selector_IN_UNBOUNDED__Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_428532_428844),
    .selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0(selector_MUX_0_A_bambu_artificial_ParmMgr_Read_axis_modgen_48_i0_0_0_0),
    .selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0(selector_MUX_1_B_bambu_artificial_ParmMgr_Read_axis_modgen_49_i0_0_0_0),
    .selector_MUX_22_reg_0_0_0_0(selector_MUX_22_reg_0_0_0_0),
    .selector_MUX_23_reg_1_0_0_0(selector_MUX_23_reg_1_0_0_0),
    .selector_MUX_25_reg_11_0_0_0(selector_MUX_25_reg_11_0_0_0),
    .selector_MUX_26_reg_12_0_0_0(selector_MUX_26_reg_12_0_0_0),
    .selector_MUX_29_reg_2_0_0_0(selector_MUX_29_reg_2_0_0_0),
    .selector_MUX_30_reg_3_0_0_0(selector_MUX_30_reg_3_0_0_0),
    .muenable_mu_S_0(muenable_mu_S_0),
    .wrenable_reg_0(wrenable_reg_0),
    .wrenable_reg_1(wrenable_reg_1),
    .wrenable_reg_10(wrenable_reg_10),
    .wrenable_reg_11(wrenable_reg_11),
    .wrenable_reg_12(wrenable_reg_12),
    .wrenable_reg_13(wrenable_reg_13),
    .wrenable_reg_14(wrenable_reg_14),
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

// Minimal interface for function: _Z3dotPK6ac_intILi2048ELb0EES2_Pxjj
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z3dotPK6ac_intILi2048ELb0EES2_Pxjj(clock,
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
  input [2047:0] A_TDATA;
  input [2047:0] B_TDATA;
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
  
  __Z3dotPK6ac_intILi2048ELb0EES2_Pxjj __Z3dotPK6ac_intILi2048ELb0EES2_Pxjj_i0 (.done_port(done_port),
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


