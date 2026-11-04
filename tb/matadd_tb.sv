// tb/matadd_tb.sv: testbench for a Bambu matadd point (C = A + B on m x n matrices streamed row-major, int64, W lanes per beat).
// From dslx-exercises' tb/matadd_tb.sv (tb/SOURCE), with bambu_ctl (tb/bambu.svh) in place
// of the cfg channel; the run-time pins are constants held for the whole run.
// Compile-time defines (bench/bambu.py sets them): DUT (the top module, Bambu's mangled C++ name), W, N (elements per matrix, m * n), LOOP_COUNT (beats per task, N / W), STALL (0: cycle run, 1: stall run), MAXCYC (watchdog).
// The vector files IN_A.hex, IN_B.hex and EXP_C.hex are in the simulation folder.
// Prints one line: PASS|FAIL matadd N=.. W=.. stall=.. cycles=.. cycles_done=.. latency=..
//   cycles:      last output beat minus the start pulse
//   cycles_done: done_port minus the start pulse
//   latency:     first output beat minus first input beat
`include "bambu.svh"

`ifndef W
`define W 4
`endif
`ifndef N
`define N 64
`endif
`ifndef LOOP_COUNT
`define LOOP_COUNT (`N / `W)
`endif
`ifndef STALL
`define STALL 0
`endif
`ifndef MAXCYC
`define MAXCYC 100000
`endif

module tb;
  localparam int W = `W;
  localparam int N = `N;
  localparam int STALL = `STALL;
  localparam int TASKS = STALL ? 2 : 1;

  logic clk = 1'b0, rst = 1'b1;
  always #5 clk = ~clk;  // 10 ns
  int cycle = 0;
  always @(posedge clk) cycle <= cycle + 1;

  logic start, done;
  logic [64*W-1:0] a_d, b_d;
  logic [64*W-1:0] r_d;
  logic a_v, a_r, b_v, b_r, r_v, r_r;
  int st_n, dn_n, st_t0, dn_t0, a_n, a_t0, b_n, b_t0, r_n, r_bad, r_t0, r_t1;

  bambu_ctl #(.TASKS(TASKS)) u_ctl (
      .clk(clk), .rst(rst), .cycle(cycle), .start(start), .done(done),
      .started(st_n), .finished(dn_n), .t_first(st_t0), .t_done_first(dn_t0));
  beat_src #(.W(W), .NELEM(N), .FILE("IN_A.hex"), .TASKS(TASKS), .STALL(STALL), .SEED(11)) u_a (
      .clk(clk), .rst(rst), .cycle(cycle), .data(a_d), .valid(a_v), .ready(a_r), .sent(a_n), .t_first(a_t0));
  beat_src #(.W(W), .NELEM(N), .FILE("IN_B.hex"), .TASKS(TASKS), .STALL(STALL), .SEED(23)) u_b (
      .clk(clk), .rst(rst), .cycle(cycle), .data(b_d), .valid(b_v), .ready(b_r), .sent(b_n), .t_first(b_t0));
  beat_chk #(.W(W), .NELEM(N), .FILE("EXP_C.hex"), .NAME("C"), .STALL(STALL), .SEED(37)) u_r (
      .clk(clk), .rst(rst), .cycle(cycle), .data(r_d), .valid(r_v), .ready(r_r),
      .got(r_n), .bad(r_bad), .t_first(r_t0), .t_last(r_t1));

  `DUT dut (
      .clock(clk), .reset(~rst), .start_port(start), .done_port(done),
      .loop_count(32'(`LOOP_COUNT)),
      .A_TDATA(a_d), .A_TVALID(a_v), .A_TREADY(a_r),
      .B_TDATA(b_d), .B_TVALID(b_v), .B_TREADY(b_r),
      .C_TDATA(r_d), .C_TVALID(r_v), .C_TREADY(r_r));

  initial begin
    repeat (3) @(posedge clk);
    rst <= 1'b0;
    fork
      wait (r_n == TASKS * (N / W) && dn_n == TASKS);
      begin
        repeat (`MAXCYC) @(posedge clk);
        $display("FAIL matadd N=%0d W=%0d stall=%0d timeout after %0d cycles: %0d of %0d beats out, %0d of %0d done",
                 N, W, STALL, `MAXCYC, r_n, TASKS * (N / W), dn_n, TASKS);
        $finish;
      end
    join_any
    @(posedge clk);
    $display("%0s matadd N=%0d W=%0d stall=%0d cycles=%0d cycles_done=%0d latency=%0d: %0d of %0d lanes differ",
             r_bad ? "FAIL" : "PASS", N, W, STALL, r_t1 - st_t0, dn_t0 - st_t0, r_t0 - a_t0, r_bad, TASKS * N);
    $finish;
  end
endmodule
