// tb/common.svh: the parts every kernel testbench shares.
//
// A testbench plays forge's streamers around one XLS proc: cfg_src sends the run-time pins
// (one transfer per task), beat_src feeds an input stream from a .hex file of elements (packed
// W lanes per beat, lane 0 in the low bits), beat_chk takes an output stream and compares every
// lane with a .hex file of expected elements. The .hex files (vectors/<kernel>/<size>/) are
// linked into the simulation folder by util/run.py, so the testbenches open them by name.
//
// STALL = 0: every input valid and every output ready on every cycle, as Vitis cosim drives
// the streams; this run gives the cycle count. STALL = 1: random gaps on valid and ready, and
// TASKS = 2 tasks back to back; this run checks the handshakes and the reload between tasks,
// and its cycle count means nothing. A source keeps valid high until its beat is taken.
//
// Plain SystemVerilog, no DPI: it runs on Questa and Icarus Verilog (iverilog -g2012).
`ifndef TB_COMMON_SVH
`define TB_COMMON_SVH
`timescale 1ns/1ps

// The run-time pins: TASKS transfers of the same value, the next one offered as soon as
// the previous one is taken (the proc only takes it once it is idle again).
module cfg_src #(
    parameter int CW = 32,
    parameter int TASKS = 1
) (
    input  logic          clk,
    input  logic          rst,
    input  int            cycle,
    input  logic [CW-1:0] value,
    output logic [CW-1:0] data,
    output logic          valid,
    input  logic          ready,
    output int            sent,
    output int            t_first     // cycle of the first transfer: the start of task 1
);
  assign data = value;
  initial begin sent = 0; t_first = -1; end
  always @(posedge clk) begin
    if (rst) valid <= 1'b0;
    else begin
      if (valid && ready) begin
        sent <= sent + 1;
        if (t_first < 0) t_first <= cycle;
      end
      valid <= (sent + (valid && ready)) < TASKS;
    end
  end
endmodule

// One input stream: NELEM elements from FILE, W per beat, repeated for every task.
module beat_src #(
    parameter int W = 1,
    parameter int NELEM = 1,
    parameter FILE = "IN_A.hex",
    parameter int TASKS = 1,
    parameter int STALL = 0,
    parameter int SEED = 1
) (
    input  logic            clk,
    input  logic            rst,
    input  int              cycle,
    output logic [64*W-1:0] data,
    output logic            valid,
    input  logic            ready,
    output int              sent,
    output int              t_first   // cycle of the first beat taken
);
  localparam int NB = NELEM / W;
  logic [63:0] mem [0:NELEM-1];
  integer seed;

  function automatic logic [64*W-1:0] pack(input int k);  // beat k of a task
    logic [64*W-1:0] v;
    for (int l = 0; l < W; l++) v[64*l +: 64] = mem[k * W + l];
    return v;
  endfunction

  initial begin
    seed = SEED;
    sent = 0;
    t_first = -1;
    $readmemh(FILE, mem);
    data = pack(0);
  end

  always @(posedge clk) begin
    if (rst) valid <= 1'b0;
    else begin
      if (valid && ready) begin
        sent <= sent + 1;
        data <= pack((sent + 1) % NB);
        if (t_first < 0) t_first <= cycle;
      end
      if (valid && !ready) valid <= 1'b1;  // hold until taken
      else valid <= ((sent + (valid && ready)) < TASKS * NB) && (STALL == 0 || ($random(seed) & 3) != 0);
    end
  end
endmodule

// One output stream: NELEM expected elements in FILE, W per beat, the same for every task.
module beat_chk #(
    parameter int W = 1,
    parameter int NELEM = 1,
    parameter FILE = "EXP_C.hex",
    parameter NAME = "C",
    parameter int STALL = 0,
    parameter int SEED = 7
) (
    input  logic            clk,
    input  logic            rst,
    input  int              cycle,
    input  logic [64*W-1:0] data,
    input  logic            valid,
    output logic            ready,
    output int              got,
    output int              bad,      // lanes that differ
    output int              t_first,  // cycle of the first beat out
    output int              t_last    // cycle of the latest beat out
);
  localparam int NB = NELEM / W;
  logic [63:0] mem [0:NELEM-1];
  integer seed;

  initial begin
    seed = SEED;
    got = 0;
    bad = 0;
    t_first = -1;
    t_last = -1;
    $readmemh(FILE, mem);
  end

  always @(posedge clk) begin
    if (rst) ready <= 1'b0;
    else begin
      ready <= STALL == 0 || ($random(seed) & 3) != 0;
      if (valid && ready) begin
        for (int l = 0; l < W; l++)
          if (data[64*l +: 64] !== mem[(got % NB) * W + l]) begin
            if (bad < 3)
              $display("  %0s[%0d]: got %0d expected %0d", NAME, (got % NB) * W + l,
                       $signed(data[64*l +: 64]), $signed(mem[(got % NB) * W + l]));
            bad = bad + 1;
          end
        got <= got + 1;
        if (t_first < 0) t_first <= cycle;
        t_last <= cycle;
      end
    end
  end
endmodule

`endif
