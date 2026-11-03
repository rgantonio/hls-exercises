// 
// Politecnico di Milano
// Code created using PandA - Version: PandA 2024.10 - Revision c2ba6936ca2ed63137095fea0b630a1c66e20e63-main - Date 2026-11-03T10:50:21
// Bambu executed with: /users/micas/rantonio/no_backup/kul_main/hls-exercises/tools/bambu/squashfs-root/usr/bin/bambu --top-fname=vecadd --device-name=nangate45 --clock-period=10 --compiler=I386_CLANG16 --simulate --simulator=VERILATOR --generate-tb=/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/src/tb_vecadd.cpp --tb-extra-gcc-options=-DDUT=vecadd -DCFG_LOOP_COUNT=8 --tb-param-size=A:512,B:512,C:512 -DDATA_T=int64_t -DSIZE_N=64 -DW=8 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/probe/bambu/include -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/src -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/tier_done/vecadd/vectors/n64 --std=c++14 -DHLSLIB_SYNTHESIS -DAP_INT_MAX_W=4096 -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/include -I/users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/gen/dace_include /users/micas/rantonio/no_backup/kul_main/hls-exercises/bench/probe/bambu/runs/A_w8_def_none/vecadd.cpp 
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
module BMEMORY_CTRLN(clock,
  in1,
  in2,
  in3,
  in4,
  sel_LOAD,
  sel_STORE,
  out1,
  Min_oe_ram,
  Mout_oe_ram,
  Min_we_ram,
  Mout_we_ram,
  Min_addr_ram,
  Mout_addr_ram,
  M_Rdata_ram,
  Min_Wdata_ram,
  Mout_Wdata_ram,
  Min_data_ram_size,
  Mout_data_ram_size,
  M_DataRdy);
  parameter BITSIZE_in1=1, PORTSIZE_in1=2,
    BITSIZE_in2=1, PORTSIZE_in2=2,
    BITSIZE_in3=1, PORTSIZE_in3=2,
    BITSIZE_in4=1, PORTSIZE_in4=2,
    BITSIZE_sel_LOAD=1, PORTSIZE_sel_LOAD=2,
    BITSIZE_sel_STORE=1, PORTSIZE_sel_STORE=2,
    BITSIZE_out1=1, PORTSIZE_out1=2,
    BITSIZE_Min_oe_ram=1, PORTSIZE_Min_oe_ram=2,
    BITSIZE_Min_we_ram=1, PORTSIZE_Min_we_ram=2,
    BITSIZE_Mout_oe_ram=1, PORTSIZE_Mout_oe_ram=2,
    BITSIZE_Mout_we_ram=1, PORTSIZE_Mout_we_ram=2,
    BITSIZE_M_DataRdy=1, PORTSIZE_M_DataRdy=2,
    BITSIZE_Min_addr_ram=1, PORTSIZE_Min_addr_ram=2,
    BITSIZE_Mout_addr_ram=1, PORTSIZE_Mout_addr_ram=2,
    BITSIZE_M_Rdata_ram=8, PORTSIZE_M_Rdata_ram=2,
    BITSIZE_Min_Wdata_ram=8, PORTSIZE_Min_Wdata_ram=2,
    BITSIZE_Mout_Wdata_ram=8, PORTSIZE_Mout_Wdata_ram=2,
    BITSIZE_Min_data_ram_size=1, PORTSIZE_Min_data_ram_size=2,
    BITSIZE_Mout_data_ram_size=1, PORTSIZE_Mout_data_ram_size=2;
  // IN
  input clock;
  input [(PORTSIZE_in1*BITSIZE_in1)+(-1):0] in1;
  input [(PORTSIZE_in2*BITSIZE_in2)+(-1):0] in2;
  input [(PORTSIZE_in3*BITSIZE_in3)+(-1):0] in3;
  input [PORTSIZE_in4-1:0] in4;
  input [PORTSIZE_sel_LOAD-1:0] sel_LOAD;
  input [PORTSIZE_sel_STORE-1:0] sel_STORE;
  input [PORTSIZE_Min_oe_ram-1:0] Min_oe_ram;
  input [PORTSIZE_Min_we_ram-1:0] Min_we_ram;
  input [(PORTSIZE_Min_addr_ram*BITSIZE_Min_addr_ram)+(-1):0] Min_addr_ram;
  input [(PORTSIZE_M_Rdata_ram*BITSIZE_M_Rdata_ram)+(-1):0] M_Rdata_ram;
  input [(PORTSIZE_Min_Wdata_ram*BITSIZE_Min_Wdata_ram)+(-1):0] Min_Wdata_ram;
  input [(PORTSIZE_Min_data_ram_size*BITSIZE_Min_data_ram_size)+(-1):0] Min_data_ram_size;
  input [PORTSIZE_M_DataRdy-1:0] M_DataRdy;
  // OUT
  output [(PORTSIZE_out1*BITSIZE_out1)+(-1):0] out1;
  output [PORTSIZE_Mout_oe_ram-1:0] Mout_oe_ram;
  output [PORTSIZE_Mout_we_ram-1:0] Mout_we_ram;
  output [(PORTSIZE_Mout_addr_ram*BITSIZE_Mout_addr_ram)+(-1):0] Mout_addr_ram;
  output [(PORTSIZE_Mout_Wdata_ram*BITSIZE_Mout_Wdata_ram)+(-1):0] Mout_Wdata_ram;
  output [(PORTSIZE_Mout_data_ram_size*BITSIZE_Mout_data_ram_size)+(-1):0] Mout_data_ram_size;
  
  parameter max_n_writes = PORTSIZE_sel_STORE > PORTSIZE_Mout_we_ram ? PORTSIZE_sel_STORE : PORTSIZE_Mout_we_ram;
  parameter max_n_reads = PORTSIZE_sel_LOAD > PORTSIZE_Mout_oe_ram ? PORTSIZE_sel_STORE : PORTSIZE_Mout_oe_ram;
  parameter max_n_rw = max_n_writes > max_n_reads ? max_n_writes : max_n_reads;
  wire  [(PORTSIZE_in2*BITSIZE_in2)-1:0] tmp_addr;
  wire [PORTSIZE_sel_LOAD-1:0] int_sel_LOAD;
  wire [PORTSIZE_sel_STORE-1:0] int_sel_STORE;
  assign int_sel_LOAD = sel_LOAD & in4;
  assign int_sel_STORE = sel_STORE & in4;
  assign tmp_addr = in2;
  generate
  genvar i;
    for (i=0; i<max_n_rw; i=i+1)
    begin : L0
      assign Mout_addr_ram[(i+1)*BITSIZE_Mout_addr_ram-1:i*BITSIZE_Mout_addr_ram] = ((i < PORTSIZE_sel_LOAD && int_sel_LOAD[i]) || (i < PORTSIZE_sel_STORE && int_sel_STORE[i])) ? (tmp_addr[(i+1)*BITSIZE_in2-1:i*BITSIZE_in2]) : Min_addr_ram[(i+1)*BITSIZE_Min_addr_ram-1:i*BITSIZE_Min_addr_ram];
    end
    endgenerate
  assign Mout_oe_ram = int_sel_LOAD | Min_oe_ram;
  assign Mout_we_ram = int_sel_STORE | Min_we_ram;
  generate
    for (i=0; i<max_n_reads; i=i+1)
    begin : L1
      assign out1[(i+1)*BITSIZE_out1-1:i*BITSIZE_out1] = M_Rdata_ram[i*BITSIZE_M_Rdata_ram+BITSIZE_out1-1:i*BITSIZE_M_Rdata_ram];
  end
  endgenerate
  generate
    for (i=0; i<max_n_rw; i=i+1)
    begin : L2
      assign Mout_Wdata_ram[(i+1)*BITSIZE_Mout_Wdata_ram-1:i*BITSIZE_Mout_Wdata_ram] = int_sel_STORE[i] ? in1[(i+1)*BITSIZE_in1-1:i*BITSIZE_in1] : Min_Wdata_ram[(i+1)*BITSIZE_Min_Wdata_ram-1:i*BITSIZE_Min_Wdata_ram];
  end
  endgenerate
  generate
    for (i=0; i<max_n_rw; i=i+1)
    begin : L3
      assign Mout_data_ram_size[(i+1)*BITSIZE_Mout_data_ram_size-1:i*BITSIZE_Mout_data_ram_size] = ((i < PORTSIZE_sel_LOAD && int_sel_LOAD[i]) || (i < PORTSIZE_sel_STORE && int_sel_STORE[i])) ? (in3[(i+1)*BITSIZE_in3-1:i*BITSIZE_in3]) : Min_data_ram_size[(i+1)*BITSIZE_Min_data_ram_size-1:i*BITSIZE_Min_data_ram_size];
    end
    endgenerate

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

// Datapath RTL description for _Z6vecaddPK7lanes_tIxLi8EES2_PS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module datapath__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j(clock,
  reset,
  in_port_A,
  in_port_B,
  in_port_C,
  in_port_loop_count,
  M_Rdata_ram,
  M_DataRdy,
  Min_oe_ram,
  Min_we_ram,
  Min_addr_ram,
  Min_Wdata_ram,
  Min_data_ram_size,
  Mout_oe_ram,
  Mout_we_ram,
  Mout_addr_ram,
  Mout_Wdata_ram,
  Mout_data_ram_size,
  fuselector_BMEMORY_CTRLN_16_i0_LOAD,
  fuselector_BMEMORY_CTRLN_16_i0_STORE,
  fuselector_BMEMORY_CTRLN_16_i1_LOAD,
  fuselector_BMEMORY_CTRLN_16_i1_STORE,
  selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0,
  selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1,
  selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0,
  selector_MUX_14_reg_0_0_0_0,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1,
  selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0,
  selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1,
  selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1,
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
  wrenable_reg_31,
  wrenable_reg_32,
  wrenable_reg_33,
  wrenable_reg_34,
  wrenable_reg_35,
  wrenable_reg_36,
  wrenable_reg_37,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621,
  OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766);
  // IN
  input clock;
  input reset;
  input [31:0] in_port_A;
  input [31:0] in_port_B;
  input [31:0] in_port_C;
  input [31:0] in_port_loop_count;
  input [127:0] M_Rdata_ram;
  input [1:0] M_DataRdy;
  input [1:0] Min_oe_ram;
  input [1:0] Min_we_ram;
  input [63:0] Min_addr_ram;
  input [127:0] Min_Wdata_ram;
  input [13:0] Min_data_ram_size;
  input fuselector_BMEMORY_CTRLN_16_i0_LOAD;
  input fuselector_BMEMORY_CTRLN_16_i0_STORE;
  input fuselector_BMEMORY_CTRLN_16_i1_LOAD;
  input fuselector_BMEMORY_CTRLN_16_i1_STORE;
  input selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0;
  input selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1;
  input selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0;
  input selector_MUX_14_reg_0_0_0_0;
  input selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0;
  input selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1;
  input selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2;
  input selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3;
  input selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4;
  input selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5;
  input selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0;
  input selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1;
  input selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2;
  input selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0;
  input selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1;
  input selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0;
  input selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1;
  input selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0;
  input selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0;
  input selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1;
  input selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2;
  input selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3;
  input selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4;
  input selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5;
  input selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0;
  input selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1;
  input selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2;
  input selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0;
  input selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1;
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
  input wrenable_reg_31;
  input wrenable_reg_32;
  input wrenable_reg_33;
  input wrenable_reg_34;
  input wrenable_reg_35;
  input wrenable_reg_36;
  input wrenable_reg_37;
  input wrenable_reg_4;
  input wrenable_reg_5;
  input wrenable_reg_6;
  input wrenable_reg_7;
  input wrenable_reg_8;
  input wrenable_reg_9;
  // OUT
  output [1:0] Mout_oe_ram;
  output [1:0] Mout_we_ram;
  output [63:0] Mout_addr_ram;
  output [127:0] Mout_Wdata_ram;
  output [13:0] Mout_data_ram_size;
  output OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621;
  output OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766;
  // Component and signal declarations
  wire [63:0] out_BMEMORY_CTRLN_16_i0_BMEMORY_CTRLN_16_i0;
  wire [63:0] out_BMEMORY_CTRLN_16_i1_BMEMORY_CTRLN_16_i0;
  wire [63:0] out_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0;
  wire [63:0] out_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1;
  wire [63:0] out_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0;
  wire [31:0] out_MUX_14_reg_0_0_0_0;
  wire [31:0] out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0;
  wire [31:0] out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1;
  wire [31:0] out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2;
  wire [31:0] out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3;
  wire [31:0] out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4;
  wire [31:0] out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5;
  wire [31:0] out_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0;
  wire [31:0] out_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1;
  wire [31:0] out_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2;
  wire [31:0] out_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0;
  wire [31:0] out_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1;
  wire [63:0] out_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0;
  wire [63:0] out_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1;
  wire [63:0] out_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0;
  wire [31:0] out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0;
  wire [31:0] out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1;
  wire [31:0] out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2;
  wire [31:0] out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3;
  wire [31:0] out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4;
  wire [31:0] out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5;
  wire [31:0] out_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0;
  wire [31:0] out_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1;
  wire [31:0] out_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2;
  wire [31:0] out_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0;
  wire [31:0] out_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1;
  wire out_UUdata_converter_FU_11_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428620;
  wire out_UUdata_converter_FU_14_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428765;
  wire out_const_0;
  wire [7:0] out_const_1;
  wire [5:0] out_const_10;
  wire out_const_2;
  wire [3:0] out_const_3;
  wire [4:0] out_const_4;
  wire [5:0] out_const_5;
  wire [5:0] out_const_6;
  wire [2:0] out_const_7;
  wire [4:0] out_const_8;
  wire [5:0] out_const_9;
  wire [31:0] out_conv_out_const_0_1_32;
  wire [6:0] out_conv_out_const_1_8_7;
  wire out_read_cond_FU_12_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621;
  wire out_read_cond_FU_15_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766;
  wire [31:0] out_reg_0_reg_0;
  wire [31:0] out_reg_10_reg_10;
  wire [31:0] out_reg_11_reg_11;
  wire [31:0] out_reg_12_reg_12;
  wire [31:0] out_reg_13_reg_13;
  wire [31:0] out_reg_14_reg_14;
  wire [31:0] out_reg_15_reg_15;
  wire [31:0] out_reg_16_reg_16;
  wire [31:0] out_reg_17_reg_17;
  wire [31:0] out_reg_18_reg_18;
  wire [31:0] out_reg_19_reg_19;
  wire [31:0] out_reg_1_reg_1;
  wire [31:0] out_reg_20_reg_20;
  wire [31:0] out_reg_21_reg_21;
  wire [31:0] out_reg_22_reg_22;
  wire out_reg_23_reg_23;
  wire [63:0] out_reg_24_reg_24;
  wire [63:0] out_reg_25_reg_25;
  wire [63:0] out_reg_26_reg_26;
  wire [63:0] out_reg_27_reg_27;
  wire [63:0] out_reg_28_reg_28;
  wire [63:0] out_reg_29_reg_29;
  wire [31:0] out_reg_2_reg_2;
  wire [63:0] out_reg_30_reg_30;
  wire [63:0] out_reg_31_reg_31;
  wire [63:0] out_reg_32_reg_32;
  wire [63:0] out_reg_33_reg_33;
  wire [63:0] out_reg_34_reg_34;
  wire [63:0] out_reg_35_reg_35;
  wire [63:0] out_reg_36_reg_36;
  wire [63:0] out_reg_37_reg_37;
  wire [31:0] out_reg_3_reg_3;
  wire [31:0] out_reg_4_reg_4;
  wire [31:0] out_reg_5_reg_5;
  wire [31:0] out_reg_6_reg_6;
  wire [31:0] out_reg_7_reg_7;
  wire [31:0] out_reg_8_reg_8;
  wire [31:0] out_reg_9_reg_9;
  wire out_ui_eq_expr_FU_32_0_32_17_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428829;
  wire out_ui_eq_expr_FU_32_32_32_18_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428822;
  wire [31:0] out_ui_lshift_expr_FU_32_0_32_19_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428786;
  wire [31:0] out_ui_plus_expr_FU_32_0_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428619;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_21_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428595;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_21_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428596;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_21_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428597;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_21_i3_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428598;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_21_i4_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428599;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_21_i5_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428600;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_21_i6_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428601;
  wire [63:0] out_ui_plus_expr_FU_64_64_64_21_i7_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428602;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_22_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428565;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_22_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428581;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_22_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428605;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_23_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428567;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_23_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428583;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_23_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428607;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_24_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428569;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_24_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428585;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_24_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428609;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_25_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428571;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_25_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428587;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_25_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428611;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_26_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428573;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_26_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428589;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_26_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428613;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_27_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428575;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_27_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428591;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_27_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428615;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_28_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428577;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_28_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428593;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_0_32_28_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428617;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_29_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_29_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579;
  wire [31:0] out_ui_pointer_plus_expr_FU_32_32_32_29_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603;
  wire [31:0] out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0;
  wire [63:0] out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1;
  wire [63:0] out_uu_conv_conn_obj_2_UUdata_converter_FU_uu_conv_2;
  wire [63:0] out_uu_conv_conn_obj_3_UUdata_converter_FU_uu_conv_3;
  wire [63:0] out_uu_conv_conn_obj_4_UUdata_converter_FU_uu_conv_4;
  wire [63:0] out_uu_conv_conn_obj_5_UUdata_converter_FU_uu_conv_5;
  wire [63:0] out_uu_conv_conn_obj_6_UUdata_converter_FU_uu_conv_6;
  wire [63:0] out_uu_conv_conn_obj_7_UUdata_converter_FU_uu_conv_7;
  wire [63:0] out_uu_conv_conn_obj_8_UUdata_converter_FU_uu_conv_8;
  
  BMEMORY_CTRLN #(.BITSIZE_in1(64),
    .PORTSIZE_in1(2),
    .BITSIZE_in2(32),
    .PORTSIZE_in2(2),
    .BITSIZE_in3(7),
    .PORTSIZE_in3(2),
    .BITSIZE_in4(1),
    .PORTSIZE_in4(2),
    .BITSIZE_sel_LOAD(1),
    .PORTSIZE_sel_LOAD(2),
    .BITSIZE_sel_STORE(1),
    .PORTSIZE_sel_STORE(2),
    .BITSIZE_out1(64),
    .PORTSIZE_out1(2),
    .BITSIZE_Min_oe_ram(1),
    .PORTSIZE_Min_oe_ram(2),
    .BITSIZE_Min_we_ram(1),
    .PORTSIZE_Min_we_ram(2),
    .BITSIZE_Mout_oe_ram(1),
    .PORTSIZE_Mout_oe_ram(2),
    .BITSIZE_Mout_we_ram(1),
    .PORTSIZE_Mout_we_ram(2),
    .BITSIZE_M_DataRdy(1),
    .PORTSIZE_M_DataRdy(2),
    .BITSIZE_Min_addr_ram(32),
    .PORTSIZE_Min_addr_ram(2),
    .BITSIZE_Mout_addr_ram(32),
    .PORTSIZE_Mout_addr_ram(2),
    .BITSIZE_M_Rdata_ram(64),
    .PORTSIZE_M_Rdata_ram(2),
    .BITSIZE_Min_Wdata_ram(64),
    .PORTSIZE_Min_Wdata_ram(2),
    .BITSIZE_Mout_Wdata_ram(64),
    .PORTSIZE_Mout_Wdata_ram(2),
    .BITSIZE_Min_data_ram_size(7),
    .PORTSIZE_Min_data_ram_size(2),
    .BITSIZE_Mout_data_ram_size(7),
    .PORTSIZE_Mout_data_ram_size(2)) BMEMORY_CTRLN_16_i0 (.out1({out_BMEMORY_CTRLN_16_i1_BMEMORY_CTRLN_16_i0,
      out_BMEMORY_CTRLN_16_i0_BMEMORY_CTRLN_16_i0}),
    .Mout_oe_ram(Mout_oe_ram),
    .Mout_we_ram(Mout_we_ram),
    .Mout_addr_ram(Mout_addr_ram),
    .Mout_Wdata_ram(Mout_Wdata_ram),
    .Mout_data_ram_size(Mout_data_ram_size),
    .clock(clock),
    .in1({out_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0,
      out_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0}),
    .in2({out_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1,
      out_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1}),
    .in3({out_conv_out_const_1_8_7,
      out_conv_out_const_1_8_7}),
    .in4({out_const_2,
      out_const_2}),
    .sel_LOAD({fuselector_BMEMORY_CTRLN_16_i1_LOAD,
      fuselector_BMEMORY_CTRLN_16_i0_LOAD}),
    .sel_STORE({fuselector_BMEMORY_CTRLN_16_i1_STORE,
      fuselector_BMEMORY_CTRLN_16_i0_STORE}),
    .Min_oe_ram(Min_oe_ram),
    .Min_we_ram(Min_we_ram),
    .Min_addr_ram(Min_addr_ram),
    .M_Rdata_ram(M_Rdata_ram),
    .Min_Wdata_ram(Min_Wdata_ram),
    .Min_data_ram_size(Min_data_ram_size),
    .M_DataRdy(M_DataRdy));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_0_BMEMORY_CTRLN_16_i0_0_0_0 (.out1(out_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0),
    .sel(selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0),
    .in1(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1),
    .in2(out_uu_conv_conn_obj_3_UUdata_converter_FU_uu_conv_3));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_0_BMEMORY_CTRLN_16_i0_0_0_1 (.out1(out_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1),
    .sel(selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1),
    .in1(out_uu_conv_conn_obj_5_UUdata_converter_FU_uu_conv_5),
    .in2(out_uu_conv_conn_obj_7_UUdata_converter_FU_uu_conv_7));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_0_BMEMORY_CTRLN_16_i0_0_1_0 (.out1(out_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0),
    .sel(selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0),
    .in1(out_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0),
    .in2(out_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_14_reg_0_0_0_0 (.out1(out_MUX_14_reg_0_0_0_0),
    .sel(selector_MUX_14_reg_0_0_0_0),
    .in1(out_ui_plus_expr_FU_32_0_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428619),
    .in2(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_BMEMORY_CTRLN_16_i0_1_0_0 (.out1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0),
    .sel(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0),
    .in1(out_reg_9_reg_9),
    .in2(out_reg_7_reg_7));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_BMEMORY_CTRLN_16_i0_1_0_1 (.out1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1),
    .sel(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1),
    .in1(out_reg_5_reg_5),
    .in2(out_reg_3_reg_3));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_BMEMORY_CTRLN_16_i0_1_0_2 (.out1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2),
    .sel(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2),
    .in1(out_reg_21_reg_21),
    .in2(out_reg_19_reg_19));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_BMEMORY_CTRLN_16_i0_1_0_3 (.out1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3),
    .sel(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3),
    .in1(out_reg_17_reg_17),
    .in2(out_reg_15_reg_15));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_BMEMORY_CTRLN_16_i0_1_0_4 (.out1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4),
    .sel(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4),
    .in1(out_reg_13_reg_13),
    .in2(out_reg_11_reg_11));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_BMEMORY_CTRLN_16_i0_1_0_5 (.out1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5),
    .sel(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5),
    .in1(out_reg_1_reg_1),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_29_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_BMEMORY_CTRLN_16_i0_1_1_0 (.out1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0),
    .sel(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0),
    .in1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0),
    .in2(out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_BMEMORY_CTRLN_16_i0_1_1_1 (.out1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1),
    .sel(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1),
    .in1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2),
    .in2(out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_BMEMORY_CTRLN_16_i0_1_1_2 (.out1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2),
    .sel(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2),
    .in1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4),
    .in2(out_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_BMEMORY_CTRLN_16_i0_1_2_0 (.out1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0),
    .sel(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0),
    .in1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0),
    .in2(out_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_1_BMEMORY_CTRLN_16_i0_1_2_1 (.out1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1),
    .sel(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1),
    .in1(out_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2),
    .in2(out_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_4_BMEMORY_CTRLN_16_i1_0_0_0 (.out1(out_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0),
    .sel(selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0),
    .in1(out_uu_conv_conn_obj_2_UUdata_converter_FU_uu_conv_2),
    .in2(out_uu_conv_conn_obj_4_UUdata_converter_FU_uu_conv_4));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_4_BMEMORY_CTRLN_16_i1_0_0_1 (.out1(out_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1),
    .sel(selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1),
    .in1(out_uu_conv_conn_obj_6_UUdata_converter_FU_uu_conv_6),
    .in2(out_uu_conv_conn_obj_8_UUdata_converter_FU_uu_conv_8));
  MUX_GATE #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) MUX_4_BMEMORY_CTRLN_16_i1_0_1_0 (.out1(out_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0),
    .sel(selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0),
    .in1(out_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0),
    .in2(out_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_5_BMEMORY_CTRLN_16_i1_1_0_0 (.out1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0),
    .sel(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0),
    .in1(out_reg_8_reg_8),
    .in2(out_reg_6_reg_6));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_5_BMEMORY_CTRLN_16_i1_1_0_1 (.out1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1),
    .sel(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1),
    .in1(out_reg_4_reg_4),
    .in2(out_reg_22_reg_22));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_5_BMEMORY_CTRLN_16_i1_1_0_2 (.out1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2),
    .sel(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2),
    .in1(out_reg_20_reg_20),
    .in2(out_reg_2_reg_2));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_5_BMEMORY_CTRLN_16_i1_1_0_3 (.out1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3),
    .sel(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3),
    .in1(out_reg_18_reg_18),
    .in2(out_reg_16_reg_16));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_5_BMEMORY_CTRLN_16_i1_1_0_4 (.out1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4),
    .sel(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4),
    .in1(out_reg_14_reg_14),
    .in2(out_reg_12_reg_12));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_5_BMEMORY_CTRLN_16_i1_1_0_5 (.out1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5),
    .sel(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5),
    .in1(out_reg_10_reg_10),
    .in2(out_ui_pointer_plus_expr_FU_32_32_32_29_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_5_BMEMORY_CTRLN_16_i1_1_1_0 (.out1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0),
    .sel(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0),
    .in1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0),
    .in2(out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_5_BMEMORY_CTRLN_16_i1_1_1_1 (.out1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1),
    .sel(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1),
    .in1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2),
    .in2(out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_5_BMEMORY_CTRLN_16_i1_1_1_2 (.out1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2),
    .sel(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2),
    .in1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4),
    .in2(out_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_5_BMEMORY_CTRLN_16_i1_1_2_0 (.out1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0),
    .sel(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0),
    .in1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0),
    .in2(out_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1));
  MUX_GATE #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32)) MUX_5_BMEMORY_CTRLN_16_i1_1_2_1 (.out1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1),
    .sel(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1),
    .in1(out_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2),
    .in2(out_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0));
  UUdata_converter_FU #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) UUdata_converter_FU_uu_conv_0 (.out1(out_uu_conv_conn_obj_0_UUdata_converter_FU_uu_conv_0),
    .in1(out_conv_out_const_0_1_32));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) UUdata_converter_FU_uu_conv_1 (.out1(out_uu_conv_conn_obj_1_UUdata_converter_FU_uu_conv_1),
    .in1(out_reg_24_reg_24));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) UUdata_converter_FU_uu_conv_2 (.out1(out_uu_conv_conn_obj_2_UUdata_converter_FU_uu_conv_2),
    .in1(out_reg_31_reg_31));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) UUdata_converter_FU_uu_conv_3 (.out1(out_uu_conv_conn_obj_3_UUdata_converter_FU_uu_conv_3),
    .in1(out_reg_32_reg_32));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) UUdata_converter_FU_uu_conv_4 (.out1(out_uu_conv_conn_obj_4_UUdata_converter_FU_uu_conv_4),
    .in1(out_reg_33_reg_33));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) UUdata_converter_FU_uu_conv_5 (.out1(out_uu_conv_conn_obj_5_UUdata_converter_FU_uu_conv_5),
    .in1(out_reg_34_reg_34));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) UUdata_converter_FU_uu_conv_6 (.out1(out_uu_conv_conn_obj_6_UUdata_converter_FU_uu_conv_6),
    .in1(out_reg_35_reg_35));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) UUdata_converter_FU_uu_conv_7 (.out1(out_uu_conv_conn_obj_7_UUdata_converter_FU_uu_conv_7),
    .in1(out_reg_36_reg_36));
  UUdata_converter_FU #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) UUdata_converter_FU_uu_conv_8 (.out1(out_uu_conv_conn_obj_8_UUdata_converter_FU_uu_conv_8),
    .in1(out_reg_37_reg_37));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b0)) const_0 (.out1(out_const_0));
  constant_value #(.BITSIZE_out1(8),
    .value(8'b01000000)) const_1 (.out1(out_const_1));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b111000)) const_10 (.out1(out_const_10));
  constant_value #(.BITSIZE_out1(1),
    .value(1'b1)) const_2 (.out1(out_const_2));
  constant_value #(.BITSIZE_out1(4),
    .value(4'b1000)) const_3 (.out1(out_const_3));
  constant_value #(.BITSIZE_out1(5),
    .value(5'b10000)) const_4 (.out1(out_const_4));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b100000)) const_5 (.out1(out_const_5));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b101000)) const_6 (.out1(out_const_6));
  constant_value #(.BITSIZE_out1(3),
    .value(3'b110)) const_7 (.out1(out_const_7));
  constant_value #(.BITSIZE_out1(5),
    .value(5'b11000)) const_8 (.out1(out_const_8));
  constant_value #(.BITSIZE_out1(6),
    .value(6'b110000)) const_9 (.out1(out_const_9));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(32)) conv_out_const_0_1_32 (.out1(out_conv_out_const_0_1_32),
    .in1(out_const_0));
  UUdata_converter_FU #(.BITSIZE_in1(8),
    .BITSIZE_out1(7)) conv_out_const_1_8_7 (.out1(out_conv_out_const_1_8_7),
    .in1(out_const_1));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_29_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in1(in_port_A),
    .in2(out_ui_lshift_expr_FU_32_0_32_19_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428786));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(4),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428565 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_22_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428565),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_3));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(5),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428567 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_23_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428567),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_4));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(5),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428569 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_24_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428569),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_8));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428571 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_25_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428571),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_5));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428573 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_26_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428573),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_6));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428575 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_27_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428575),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_9));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428577 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_28_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428577),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428563),
    .in2(out_const_10));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_29_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in1(in_port_B),
    .in2(out_ui_lshift_expr_FU_32_0_32_19_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428786));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(4),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428581 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_22_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428581),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_3));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(5),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428583 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_23_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428583),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_4));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(5),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428585 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_24_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428585),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_8));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428587 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_25_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428587),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_5));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428589 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_26_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428589),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_6));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428591 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_27_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428591),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_9));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428593 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_28_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428593),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428579),
    .in2(out_const_10));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428595 (.out1(out_ui_plus_expr_FU_64_64_64_21_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428595),
    .in1(out_BMEMORY_CTRLN_16_i1_BMEMORY_CTRLN_16_i0),
    .in2(out_BMEMORY_CTRLN_16_i0_BMEMORY_CTRLN_16_i0));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428596 (.out1(out_ui_plus_expr_FU_64_64_64_21_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428596),
    .in1(out_BMEMORY_CTRLN_16_i1_BMEMORY_CTRLN_16_i0),
    .in2(out_reg_25_reg_25));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428597 (.out1(out_ui_plus_expr_FU_64_64_64_21_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428597),
    .in1(out_BMEMORY_CTRLN_16_i0_BMEMORY_CTRLN_16_i0),
    .in2(out_reg_26_reg_26));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428598 (.out1(out_ui_plus_expr_FU_64_64_64_21_i3_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428598),
    .in1(out_BMEMORY_CTRLN_16_i1_BMEMORY_CTRLN_16_i0),
    .in2(out_reg_27_reg_27));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428599 (.out1(out_ui_plus_expr_FU_64_64_64_21_i4_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428599),
    .in1(out_BMEMORY_CTRLN_16_i0_BMEMORY_CTRLN_16_i0),
    .in2(out_reg_28_reg_28));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428600 (.out1(out_ui_plus_expr_FU_64_64_64_21_i5_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428600),
    .in1(out_BMEMORY_CTRLN_16_i1_BMEMORY_CTRLN_16_i0),
    .in2(out_reg_29_reg_29));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428601 (.out1(out_ui_plus_expr_FU_64_64_64_21_i6_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428601),
    .in1(out_BMEMORY_CTRLN_16_i0_BMEMORY_CTRLN_16_i0),
    .in2(out_reg_30_reg_30));
  ui_plus_expr_FU #(.BITSIZE_in1(64),
    .BITSIZE_in2(64),
    .BITSIZE_out1(64)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428602 (.out1(out_ui_plus_expr_FU_64_64_64_21_i7_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428602),
    .in1(out_BMEMORY_CTRLN_16_i1_BMEMORY_CTRLN_16_i0),
    .in2(out_reg_25_reg_25));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603 (.out1(out_ui_pointer_plus_expr_FU_32_32_32_29_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in1(in_port_C),
    .in2(out_ui_lshift_expr_FU_32_0_32_19_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428786));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(4),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428605 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_22_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428605),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_3));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(5),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428607 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_23_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428607),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_4));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(5),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428609 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_24_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428609),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_8));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428611 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_25_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428611),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_5));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428613 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_26_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428613),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_6));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428615 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_27_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428615),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_9));
  ui_pointer_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(6),
    .BITSIZE_out1(32),
    .LSB_PARAMETER(0)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428617 (.out1(out_ui_pointer_plus_expr_FU_32_0_32_28_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428617),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .in2(out_const_10));
  ui_plus_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(32)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428619 (.out1(out_ui_plus_expr_FU_32_0_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428619),
    .in1(out_reg_0_reg_0),
    .in2(out_const_2));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428620 (.out1(out_UUdata_converter_FU_11_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428620),
    .in1(out_ui_eq_expr_FU_32_32_32_18_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428822));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621 (.out1(out_read_cond_FU_12_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621),
    .in1(out_reg_23_reg_23));
  UUdata_converter_FU #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428765 (.out1(out_UUdata_converter_FU_14_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428765),
    .in1(out_ui_eq_expr_FU_32_0_32_17_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428829));
  read_cond_FU #(.BITSIZE_in1(1)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766 (.out1(out_read_cond_FU_15_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766),
    .in1(out_UUdata_converter_FU_14_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428765));
  ui_lshift_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(3),
    .BITSIZE_out1(32),
    .PRECISION(32)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428786 (.out1(out_ui_lshift_expr_FU_32_0_32_19_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428786),
    .in1(out_reg_0_reg_0),
    .in2(out_const_7));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(32),
    .BITSIZE_out1(1)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428822 (.out1(out_ui_eq_expr_FU_32_32_32_18_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428822),
    .in1(out_ui_plus_expr_FU_32_0_32_20_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428619),
    .in2(in_port_loop_count));
  ui_eq_expr_FU #(.BITSIZE_in1(32),
    .BITSIZE_in2(1),
    .BITSIZE_out1(1)) fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428829 (.out1(out_ui_eq_expr_FU_32_0_32_17_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428829),
    .in1(in_port_loop_count),
    .in2(out_const_0));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_0 (.out1(out_reg_0_reg_0),
    .clock(clock),
    .reset(reset),
    .in1(out_MUX_14_reg_0_0_0_0),
    .wenable(wrenable_reg_0));
  register_STD #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_1 (.out1(out_reg_1_reg_1),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_22_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428565),
    .wenable(wrenable_reg_1));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_10 (.out1(out_reg_10_reg_10),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_24_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428585),
    .wenable(wrenable_reg_10));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_11 (.out1(out_reg_11_reg_11),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_25_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428587),
    .wenable(wrenable_reg_11));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_12 (.out1(out_reg_12_reg_12),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_26_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428589),
    .wenable(wrenable_reg_12));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_13 (.out1(out_reg_13_reg_13),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_27_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428591),
    .wenable(wrenable_reg_13));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_14 (.out1(out_reg_14_reg_14),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_28_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428593),
    .wenable(wrenable_reg_14));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_15 (.out1(out_reg_15_reg_15),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_32_32_29_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428603),
    .wenable(wrenable_reg_15));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_16 (.out1(out_reg_16_reg_16),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_22_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428605),
    .wenable(wrenable_reg_16));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_17 (.out1(out_reg_17_reg_17),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_23_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428607),
    .wenable(wrenable_reg_17));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_18 (.out1(out_reg_18_reg_18),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_24_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428609),
    .wenable(wrenable_reg_18));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_19 (.out1(out_reg_19_reg_19),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_25_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428611),
    .wenable(wrenable_reg_19));
  register_STD #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_2 (.out1(out_reg_2_reg_2),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_23_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428567),
    .wenable(wrenable_reg_2));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_20 (.out1(out_reg_20_reg_20),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_26_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428613),
    .wenable(wrenable_reg_20));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_21 (.out1(out_reg_21_reg_21),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_27_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428615),
    .wenable(wrenable_reg_21));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_22 (.out1(out_reg_22_reg_22),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_28_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428617),
    .wenable(wrenable_reg_22));
  register_SE #(.BITSIZE_in1(1),
    .BITSIZE_out1(1)) reg_23 (.out1(out_reg_23_reg_23),
    .clock(clock),
    .reset(reset),
    .in1(out_UUdata_converter_FU_11_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428620),
    .wenable(wrenable_reg_23));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_24 (.out1(out_reg_24_reg_24),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_21_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428595),
    .wenable(wrenable_reg_24));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_25 (.out1(out_reg_25_reg_25),
    .clock(clock),
    .reset(reset),
    .in1(out_BMEMORY_CTRLN_16_i0_BMEMORY_CTRLN_16_i0),
    .wenable(wrenable_reg_25));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_26 (.out1(out_reg_26_reg_26),
    .clock(clock),
    .reset(reset),
    .in1(out_BMEMORY_CTRLN_16_i1_BMEMORY_CTRLN_16_i0),
    .wenable(wrenable_reg_26));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_27 (.out1(out_reg_27_reg_27),
    .clock(clock),
    .reset(reset),
    .in1(out_BMEMORY_CTRLN_16_i0_BMEMORY_CTRLN_16_i0),
    .wenable(wrenable_reg_27));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_28 (.out1(out_reg_28_reg_28),
    .clock(clock),
    .reset(reset),
    .in1(out_BMEMORY_CTRLN_16_i1_BMEMORY_CTRLN_16_i0),
    .wenable(wrenable_reg_28));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_29 (.out1(out_reg_29_reg_29),
    .clock(clock),
    .reset(reset),
    .in1(out_BMEMORY_CTRLN_16_i0_BMEMORY_CTRLN_16_i0),
    .wenable(wrenable_reg_29));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_3 (.out1(out_reg_3_reg_3),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_24_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428569),
    .wenable(wrenable_reg_3));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_30 (.out1(out_reg_30_reg_30),
    .clock(clock),
    .reset(reset),
    .in1(out_BMEMORY_CTRLN_16_i1_BMEMORY_CTRLN_16_i0),
    .wenable(wrenable_reg_30));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_31 (.out1(out_reg_31_reg_31),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_21_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428596),
    .wenable(wrenable_reg_31));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_32 (.out1(out_reg_32_reg_32),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_21_i2_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428597),
    .wenable(wrenable_reg_32));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_33 (.out1(out_reg_33_reg_33),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_21_i3_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428598),
    .wenable(wrenable_reg_33));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_34 (.out1(out_reg_34_reg_34),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_21_i4_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428599),
    .wenable(wrenable_reg_34));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_35 (.out1(out_reg_35_reg_35),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_21_i5_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428600),
    .wenable(wrenable_reg_35));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_36 (.out1(out_reg_36_reg_36),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_21_i6_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428601),
    .wenable(wrenable_reg_36));
  register_SE #(.BITSIZE_in1(64),
    .BITSIZE_out1(64)) reg_37 (.out1(out_reg_37_reg_37),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_plus_expr_FU_64_64_64_21_i7_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428602),
    .wenable(wrenable_reg_37));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_4 (.out1(out_reg_4_reg_4),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_25_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428571),
    .wenable(wrenable_reg_4));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_5 (.out1(out_reg_5_reg_5),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_26_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428573),
    .wenable(wrenable_reg_5));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_6 (.out1(out_reg_6_reg_6),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_27_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428575),
    .wenable(wrenable_reg_6));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_7 (.out1(out_reg_7_reg_7),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_28_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428577),
    .wenable(wrenable_reg_7));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_8 (.out1(out_reg_8_reg_8),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_22_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428581),
    .wenable(wrenable_reg_8));
  register_SE #(.BITSIZE_in1(32),
    .BITSIZE_out1(32)) reg_9 (.out1(out_reg_9_reg_9),
    .clock(clock),
    .reset(reset),
    .in1(out_ui_pointer_plus_expr_FU_32_0_32_23_i1_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428583),
    .wenable(wrenable_reg_9));
  // io-signal post fix
  assign OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621 = out_read_cond_FU_12_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621;
  assign OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766 = out_read_cond_FU_15_i0_fu__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766;

endmodule

// FSM based controller description for _Z6vecaddPK7lanes_tIxLi8EES2_PS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module controller__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j(done_port,
  fuselector_BMEMORY_CTRLN_16_i0_LOAD,
  fuselector_BMEMORY_CTRLN_16_i0_STORE,
  fuselector_BMEMORY_CTRLN_16_i1_LOAD,
  fuselector_BMEMORY_CTRLN_16_i1_STORE,
  selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0,
  selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1,
  selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0,
  selector_MUX_14_reg_0_0_0_0,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0,
  selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1,
  selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0,
  selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1,
  selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0,
  selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1,
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
  wrenable_reg_31,
  wrenable_reg_32,
  wrenable_reg_33,
  wrenable_reg_34,
  wrenable_reg_35,
  wrenable_reg_36,
  wrenable_reg_37,
  wrenable_reg_4,
  wrenable_reg_5,
  wrenable_reg_6,
  wrenable_reg_7,
  wrenable_reg_8,
  wrenable_reg_9,
  OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621,
  OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766,
  clock,
  reset,
  start_port);
  // IN
  input OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621;
  input OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766;
  input clock;
  input reset;
  input start_port;
  // OUT
  output done_port;
  output fuselector_BMEMORY_CTRLN_16_i0_LOAD;
  output fuselector_BMEMORY_CTRLN_16_i0_STORE;
  output fuselector_BMEMORY_CTRLN_16_i1_LOAD;
  output fuselector_BMEMORY_CTRLN_16_i1_STORE;
  output selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0;
  output selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1;
  output selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0;
  output selector_MUX_14_reg_0_0_0_0;
  output selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0;
  output selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1;
  output selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2;
  output selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3;
  output selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4;
  output selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5;
  output selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0;
  output selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1;
  output selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2;
  output selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0;
  output selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1;
  output selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0;
  output selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1;
  output selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0;
  output selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0;
  output selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1;
  output selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2;
  output selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3;
  output selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4;
  output selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5;
  output selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0;
  output selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1;
  output selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2;
  output selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0;
  output selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1;
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
  output wrenable_reg_31;
  output wrenable_reg_32;
  output wrenable_reg_33;
  output wrenable_reg_34;
  output wrenable_reg_35;
  output wrenable_reg_36;
  output wrenable_reg_37;
  output wrenable_reg_4;
  output wrenable_reg_5;
  output wrenable_reg_6;
  output wrenable_reg_7;
  output wrenable_reg_8;
  output wrenable_reg_9;
  parameter [3:0] S_13 = 4'd13,
    S_15 = 4'd15,
    S_0 = 4'd0,
    S_1 = 4'd1,
    S_2 = 4'd2,
    S_3 = 4'd3,
    S_4 = 4'd4,
    S_5 = 4'd5,
    S_6 = 4'd6,
    S_7 = 4'd7,
    S_8 = 4'd8,
    S_9 = 4'd9,
    S_10 = 4'd10,
    S_11 = 4'd11,
    S_12 = 4'd12,
    S_14 = 4'd14;
  reg [3:0] _present_state=S_13, _next_state;
  reg done_port;
  reg fuselector_BMEMORY_CTRLN_16_i0_LOAD;
  reg fuselector_BMEMORY_CTRLN_16_i0_STORE;
  reg fuselector_BMEMORY_CTRLN_16_i1_LOAD;
  reg fuselector_BMEMORY_CTRLN_16_i1_STORE;
  reg selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0;
  reg selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1;
  reg selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0;
  reg selector_MUX_14_reg_0_0_0_0;
  reg selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0;
  reg selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1;
  reg selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2;
  reg selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3;
  reg selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4;
  reg selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5;
  reg selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0;
  reg selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1;
  reg selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2;
  reg selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0;
  reg selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1;
  reg selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0;
  reg selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1;
  reg selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0;
  reg selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0;
  reg selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1;
  reg selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2;
  reg selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3;
  reg selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4;
  reg selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5;
  reg selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0;
  reg selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1;
  reg selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2;
  reg selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0;
  reg selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1;
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
  reg wrenable_reg_31;
  reg wrenable_reg_32;
  reg wrenable_reg_33;
  reg wrenable_reg_34;
  reg wrenable_reg_35;
  reg wrenable_reg_36;
  reg wrenable_reg_37;
  reg wrenable_reg_4;
  reg wrenable_reg_5;
  reg wrenable_reg_6;
  reg wrenable_reg_7;
  reg wrenable_reg_8;
  reg wrenable_reg_9;
  
  always @(posedge clock)
    if (reset == 1'b0) _present_state <= S_13;
    else _present_state <= _next_state;
  
  always @(*)
  begin
    done_port = 1'b0;
    fuselector_BMEMORY_CTRLN_16_i0_LOAD = 1'b0;
    fuselector_BMEMORY_CTRLN_16_i0_STORE = 1'b0;
    fuselector_BMEMORY_CTRLN_16_i1_LOAD = 1'b0;
    fuselector_BMEMORY_CTRLN_16_i1_STORE = 1'b0;
    selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0 = 1'b0;
    selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1 = 1'b0;
    selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0 = 1'b0;
    selector_MUX_14_reg_0_0_0_0 = 1'b0;
    selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0 = 1'b0;
    selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1 = 1'b0;
    selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2 = 1'b0;
    selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3 = 1'b0;
    selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4 = 1'b0;
    selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5 = 1'b0;
    selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0 = 1'b0;
    selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1 = 1'b0;
    selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2 = 1'b0;
    selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0 = 1'b0;
    selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1 = 1'b0;
    selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0 = 1'b0;
    selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1 = 1'b0;
    selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0 = 1'b0;
    selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0 = 1'b0;
    selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1 = 1'b0;
    selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2 = 1'b0;
    selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3 = 1'b0;
    selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4 = 1'b0;
    selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5 = 1'b0;
    selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0 = 1'b0;
    selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1 = 1'b0;
    selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2 = 1'b0;
    selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0 = 1'b0;
    selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1 = 1'b0;
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
    wrenable_reg_31 = 1'b0;
    wrenable_reg_32 = 1'b0;
    wrenable_reg_33 = 1'b0;
    wrenable_reg_34 = 1'b0;
    wrenable_reg_35 = 1'b0;
    wrenable_reg_36 = 1'b0;
    wrenable_reg_37 = 1'b0;
    wrenable_reg_4 = 1'b0;
    wrenable_reg_5 = 1'b0;
    wrenable_reg_6 = 1'b0;
    wrenable_reg_7 = 1'b0;
    wrenable_reg_8 = 1'b0;
    wrenable_reg_9 = 1'b0;
    case (_present_state)
      S_13 :
        if(start_port == 1'b1)
        begin
          wrenable_reg_0 = 1'b1;
          if (OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766 == 1'b0)
            begin
              _next_state = S_0;
            end
          else
            begin
              _next_state = S_15;
              done_port = 1'b1;
              wrenable_reg_0 = 1'b0;
            end
        end
        else
        begin
          _next_state = S_13;
        end
      S_15 :
        begin
          _next_state = S_13;
        end
      S_0 :
        begin
          fuselector_BMEMORY_CTRLN_16_i0_LOAD = 1'b1;
          fuselector_BMEMORY_CTRLN_16_i1_LOAD = 1'b1;
          selector_MUX_14_reg_0_0_0_0 = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1 = 1'b1;
          wrenable_reg_0 = 1'b1;
          wrenable_reg_1 = 1'b1;
          wrenable_reg_10 = 1'b1;
          wrenable_reg_11 = 1'b1;
          wrenable_reg_12 = 1'b1;
          wrenable_reg_13 = 1'b1;
          wrenable_reg_14 = 1'b1;
          wrenable_reg_15 = 1'b1;
          wrenable_reg_16 = 1'b1;
          wrenable_reg_17 = 1'b1;
          wrenable_reg_18 = 1'b1;
          wrenable_reg_19 = 1'b1;
          wrenable_reg_2 = 1'b1;
          wrenable_reg_20 = 1'b1;
          wrenable_reg_21 = 1'b1;
          wrenable_reg_22 = 1'b1;
          wrenable_reg_23 = 1'b1;
          wrenable_reg_3 = 1'b1;
          wrenable_reg_4 = 1'b1;
          wrenable_reg_5 = 1'b1;
          wrenable_reg_6 = 1'b1;
          wrenable_reg_7 = 1'b1;
          wrenable_reg_8 = 1'b1;
          wrenable_reg_9 = 1'b1;
          _next_state = S_1;
        end
      S_1 :
        begin
          fuselector_BMEMORY_CTRLN_16_i0_LOAD = 1'b1;
          fuselector_BMEMORY_CTRLN_16_i1_LOAD = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5 = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1 = 1'b1;
          wrenable_reg_24 = 1'b1;
          _next_state = S_2;
        end
      S_2 :
        begin
          fuselector_BMEMORY_CTRLN_16_i0_LOAD = 1'b1;
          fuselector_BMEMORY_CTRLN_16_i1_LOAD = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0 = 1'b1;
          wrenable_reg_25 = 1'b1;
          wrenable_reg_26 = 1'b1;
          _next_state = S_3;
        end
      S_3 :
        begin
          fuselector_BMEMORY_CTRLN_16_i0_LOAD = 1'b1;
          fuselector_BMEMORY_CTRLN_16_i1_LOAD = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1 = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0 = 1'b1;
          wrenable_reg_27 = 1'b1;
          wrenable_reg_28 = 1'b1;
          _next_state = S_4;
        end
      S_4 :
        begin
          fuselector_BMEMORY_CTRLN_16_i0_LOAD = 1'b1;
          fuselector_BMEMORY_CTRLN_16_i1_LOAD = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0 = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0 = 1'b1;
          wrenable_reg_29 = 1'b1;
          wrenable_reg_30 = 1'b1;
          _next_state = S_5;
        end
      S_5 :
        begin
          fuselector_BMEMORY_CTRLN_16_i0_LOAD = 1'b1;
          fuselector_BMEMORY_CTRLN_16_i1_LOAD = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0 = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0 = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1 = 1'b1;
          wrenable_reg_25 = 1'b1;
          wrenable_reg_31 = 1'b1;
          _next_state = S_6;
        end
      S_6 :
        begin
          fuselector_BMEMORY_CTRLN_16_i0_LOAD = 1'b1;
          fuselector_BMEMORY_CTRLN_16_i1_LOAD = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2 = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1 = 1'b1;
          wrenable_reg_32 = 1'b1;
          wrenable_reg_33 = 1'b1;
          _next_state = S_7;
        end
      S_7 :
        begin
          fuselector_BMEMORY_CTRLN_16_i0_LOAD = 1'b1;
          fuselector_BMEMORY_CTRLN_16_i1_LOAD = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4 = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2 = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1 = 1'b1;
          wrenable_reg_34 = 1'b1;
          wrenable_reg_35 = 1'b1;
          _next_state = S_8;
        end
      S_8 :
        begin
          wrenable_reg_36 = 1'b1;
          wrenable_reg_37 = 1'b1;
          _next_state = S_9;
        end
      S_9 :
        begin
          fuselector_BMEMORY_CTRLN_16_i0_STORE = 1'b1;
          fuselector_BMEMORY_CTRLN_16_i1_STORE = 1'b1;
          selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0 = 1'b1;
          selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0 = 1'b1;
          selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0 = 1'b1;
          selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0 = 1'b1;
          _next_state = S_10;
        end
      S_10 :
        begin
          fuselector_BMEMORY_CTRLN_16_i0_STORE = 1'b1;
          fuselector_BMEMORY_CTRLN_16_i1_STORE = 1'b1;
          selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0 = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3 = 1'b1;
          selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3 = 1'b1;
          _next_state = S_11;
        end
      S_11 :
        begin
          fuselector_BMEMORY_CTRLN_16_i0_STORE = 1'b1;
          fuselector_BMEMORY_CTRLN_16_i1_STORE = 1'b1;
          selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1 = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1 = 1'b1;
          selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1 = 1'b1;
          _next_state = S_12;
        end
      S_12 :
        begin
          fuselector_BMEMORY_CTRLN_16_i0_STORE = 1'b1;
          fuselector_BMEMORY_CTRLN_16_i1_STORE = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2 = 1'b1;
          selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1 = 1'b1;
          selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0 = 1'b1;
          if (OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621 == 1'b0)
            begin
              _next_state = S_0;
            end
          else
            begin
              _next_state = S_14;
              done_port = 1'b1;
            end
        end
      S_14 :
        begin
          _next_state = S_13;
        end
      default :
        begin
          _next_state = S_13;
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

// Top component for _Z6vecaddPK7lanes_tIxLi8EES2_PS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module __Z6vecaddPK7lanes_tIxLi8EES2_PS0_j(clock,
  reset,
  start_port,
  done_port,
  A,
  B,
  C,
  loop_count,
  M_Rdata_ram,
  M_DataRdy,
  Min_oe_ram,
  Min_we_ram,
  Min_addr_ram,
  Min_Wdata_ram,
  Min_data_ram_size,
  Mout_oe_ram,
  Mout_we_ram,
  Mout_addr_ram,
  Mout_Wdata_ram,
  Mout_data_ram_size);
  // IN
  input clock;
  input reset;
  input start_port;
  input [31:0] A;
  input [31:0] B;
  input [31:0] C;
  input [31:0] loop_count;
  input [127:0] M_Rdata_ram;
  input [1:0] M_DataRdy;
  input [1:0] Min_oe_ram;
  input [1:0] Min_we_ram;
  input [63:0] Min_addr_ram;
  input [127:0] Min_Wdata_ram;
  input [13:0] Min_data_ram_size;
  // OUT
  output done_port;
  output [1:0] Mout_oe_ram;
  output [1:0] Mout_we_ram;
  output [63:0] Mout_addr_ram;
  output [127:0] Mout_Wdata_ram;
  output [13:0] Mout_data_ram_size;
  // Component and signal declarations
  wire OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621;
  wire OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766;
  wire done_delayed_REG_signal_in;
  wire done_delayed_REG_signal_out;
  wire fuselector_BMEMORY_CTRLN_16_i0_LOAD;
  wire fuselector_BMEMORY_CTRLN_16_i0_STORE;
  wire fuselector_BMEMORY_CTRLN_16_i1_LOAD;
  wire fuselector_BMEMORY_CTRLN_16_i1_STORE;
  wire selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0;
  wire selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1;
  wire selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0;
  wire selector_MUX_14_reg_0_0_0_0;
  wire selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0;
  wire selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1;
  wire selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2;
  wire selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3;
  wire selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4;
  wire selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5;
  wire selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0;
  wire selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1;
  wire selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2;
  wire selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0;
  wire selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1;
  wire selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0;
  wire selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1;
  wire selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0;
  wire selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0;
  wire selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1;
  wire selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2;
  wire selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3;
  wire selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4;
  wire selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5;
  wire selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0;
  wire selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1;
  wire selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2;
  wire selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0;
  wire selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1;
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
  wire wrenable_reg_31;
  wire wrenable_reg_32;
  wire wrenable_reg_33;
  wire wrenable_reg_34;
  wire wrenable_reg_35;
  wire wrenable_reg_36;
  wire wrenable_reg_37;
  wire wrenable_reg_4;
  wire wrenable_reg_5;
  wire wrenable_reg_6;
  wire wrenable_reg_7;
  wire wrenable_reg_8;
  wire wrenable_reg_9;
  
  controller__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j Controller_i (.done_port(done_delayed_REG_signal_in),
    .fuselector_BMEMORY_CTRLN_16_i0_LOAD(fuselector_BMEMORY_CTRLN_16_i0_LOAD),
    .fuselector_BMEMORY_CTRLN_16_i0_STORE(fuselector_BMEMORY_CTRLN_16_i0_STORE),
    .fuselector_BMEMORY_CTRLN_16_i1_LOAD(fuselector_BMEMORY_CTRLN_16_i1_LOAD),
    .fuselector_BMEMORY_CTRLN_16_i1_STORE(fuselector_BMEMORY_CTRLN_16_i1_STORE),
    .selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0(selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0),
    .selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1(selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1),
    .selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0(selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0),
    .selector_MUX_14_reg_0_0_0_0(selector_MUX_14_reg_0_0_0_0),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1),
    .selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0(selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0),
    .selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1(selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1),
    .selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0(selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1),
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
    .wrenable_reg_31(wrenable_reg_31),
    .wrenable_reg_32(wrenable_reg_32),
    .wrenable_reg_33(wrenable_reg_33),
    .wrenable_reg_34(wrenable_reg_34),
    .wrenable_reg_35(wrenable_reg_35),
    .wrenable_reg_36(wrenable_reg_36),
    .wrenable_reg_37(wrenable_reg_37),
    .wrenable_reg_4(wrenable_reg_4),
    .wrenable_reg_5(wrenable_reg_5),
    .wrenable_reg_6(wrenable_reg_6),
    .wrenable_reg_7(wrenable_reg_7),
    .wrenable_reg_8(wrenable_reg_8),
    .wrenable_reg_9(wrenable_reg_9),
    .OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621(OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621),
    .OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766(OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766),
    .clock(clock),
    .reset(reset),
    .start_port(start_port));
  datapath__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j Datapath_i (.Mout_oe_ram(Mout_oe_ram),
    .Mout_we_ram(Mout_we_ram),
    .Mout_addr_ram(Mout_addr_ram),
    .Mout_Wdata_ram(Mout_Wdata_ram),
    .Mout_data_ram_size(Mout_data_ram_size),
    .OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621(OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428621),
    .OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766(OUT_CONDITION__Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_428532_428766),
    .clock(clock),
    .reset(reset),
    .in_port_A(A),
    .in_port_B(B),
    .in_port_C(C),
    .in_port_loop_count(loop_count),
    .M_Rdata_ram(M_Rdata_ram),
    .M_DataRdy(M_DataRdy),
    .Min_oe_ram(Min_oe_ram),
    .Min_we_ram(Min_we_ram),
    .Min_addr_ram(Min_addr_ram),
    .Min_Wdata_ram(Min_Wdata_ram),
    .Min_data_ram_size(Min_data_ram_size),
    .fuselector_BMEMORY_CTRLN_16_i0_LOAD(fuselector_BMEMORY_CTRLN_16_i0_LOAD),
    .fuselector_BMEMORY_CTRLN_16_i0_STORE(fuselector_BMEMORY_CTRLN_16_i0_STORE),
    .fuselector_BMEMORY_CTRLN_16_i1_LOAD(fuselector_BMEMORY_CTRLN_16_i1_LOAD),
    .fuselector_BMEMORY_CTRLN_16_i1_STORE(fuselector_BMEMORY_CTRLN_16_i1_STORE),
    .selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0(selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_0),
    .selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1(selector_MUX_0_BMEMORY_CTRLN_16_i0_0_0_1),
    .selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0(selector_MUX_0_BMEMORY_CTRLN_16_i0_0_1_0),
    .selector_MUX_14_reg_0_0_0_0(selector_MUX_14_reg_0_0_0_0),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_0),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_1),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_2),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_3),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_4),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_0_5),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_0),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_1),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_1_2),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_0),
    .selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1(selector_MUX_1_BMEMORY_CTRLN_16_i0_1_2_1),
    .selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0(selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_0),
    .selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1(selector_MUX_4_BMEMORY_CTRLN_16_i1_0_0_1),
    .selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0(selector_MUX_4_BMEMORY_CTRLN_16_i1_0_1_0),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_0),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_1),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_2),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_3),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_4),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_0_5),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_0),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_1),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_1_2),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_0),
    .selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1(selector_MUX_5_BMEMORY_CTRLN_16_i1_1_2_1),
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
    .wrenable_reg_31(wrenable_reg_31),
    .wrenable_reg_32(wrenable_reg_32),
    .wrenable_reg_33(wrenable_reg_33),
    .wrenable_reg_34(wrenable_reg_34),
    .wrenable_reg_35(wrenable_reg_35),
    .wrenable_reg_36(wrenable_reg_36),
    .wrenable_reg_37(wrenable_reg_37),
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

// Minimal interface for function: _Z6vecaddPK7lanes_tIxLi8EES2_PS0_j
// This component has been derived from the input source code and so it does not fall under the copyright of PandA framework, but it follows the input source code copyright, and may be aggregated with components of the BAMBU/PANDA IP LIBRARY.
// Author(s): Component automatically generated by bambu
// License: THIS COMPONENT IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
`timescale 1ns / 1ps
module _Z6vecaddPK7lanes_tIxLi8EES2_PS0_j(clock,
  reset,
  start_port,
  A,
  B,
  C,
  loop_count,
  M_Rdata_ram,
  M_DataRdy,
  done_port,
  Mout_oe_ram,
  Mout_we_ram,
  Mout_addr_ram,
  Mout_Wdata_ram,
  Mout_data_ram_size);
  // IN
  input clock;
  input reset;
  input start_port;
  input [31:0] A;
  input [31:0] B;
  input [31:0] C;
  input [31:0] loop_count;
  input [127:0] M_Rdata_ram;
  input [1:0] M_DataRdy;
  // OUT
  output done_port;
  output [1:0] Mout_oe_ram;
  output [1:0] Mout_we_ram;
  output [63:0] Mout_addr_ram;
  output [127:0] Mout_Wdata_ram;
  output [13:0] Mout_data_ram_size;
  // Component and signal declarations
  
  __Z6vecaddPK7lanes_tIxLi8EES2_PS0_j __Z6vecaddPK7lanes_tIxLi8EES2_PS0_j_i0 (.done_port(done_port),
    .Mout_oe_ram(Mout_oe_ram),
    .Mout_we_ram(Mout_we_ram),
    .Mout_addr_ram(Mout_addr_ram),
    .Mout_Wdata_ram(Mout_Wdata_ram),
    .Mout_data_ram_size(Mout_data_ram_size),
    .clock(clock),
    .reset(reset),
    .start_port(start_port),
    .A(A),
    .B(B),
    .C(C),
    .loop_count(loop_count),
    .M_Rdata_ram(M_Rdata_ram),
    .M_DataRdy(M_DataRdy),
    .Min_oe_ram({1'b0,
      1'b0}),
    .Min_we_ram({1'b0,
      1'b0}),
    .Min_addr_ram({32'b00000000000000000000000000000000,
      32'b00000000000000000000000000000000}),
    .Min_Wdata_ram({64'b0000000000000000000000000000000000000000000000000000000000000000,
      64'b0000000000000000000000000000000000000000000000000000000000000000}),
    .Min_data_ram_size({7'b0000000,
      7'b0000000}));

endmodule


