// tb/rowsum_tb.sv: testbench for a Bambu rowsum point (y[i] = sum(A[i, :]), A streamed row-major, int64, W lanes per beat).
// From dslx-exercises' tb/rowsum_tb.sv (tb/SOURCE), with bambu_ctl (tb/bambu.svh) in place
// of the cfg channel; the run-time pins are constants held for the whole run.
// Compile-time defines (bench/bambu.py sets them): DUT (the top module, Bambu's mangled C++ name), W, N (elements of A, m * n), NOUT (results per task), LOOP_COUNT (beats per task, N / W), LEN (beats per result), STALL (0: cycle run, 1: stall run), MAXCYC (watchdog).
// The vector files IN_A.hex and EXP_y.hex are in the simulation folder.
// Prints one line: PASS|FAIL rowsum N=.. W=.. stall=.. cycles=.. cycles_done=.. latency=..
//   cycles:      last result minus the start pulse
//   cycles_done: done_port minus the start pulse
//   latency:     first result minus first input beat
`include "bambu.svh"

`ifndef W
`define W 4
`endif
`ifndef N
`define N 64
`endif
`ifndef NOUT
`define NOUT 1
`endif
`ifndef LOOP_COUNT
`define LOOP_COUNT (`N / `W)
`endif
`ifndef LEN
`define LEN `LOOP_COUNT
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
  localparam int NOUT = `NOUT;
  localparam int STALL = `STALL;
  localparam int TASKS = STALL ? 2 : 1;

  logic clk = 1'b0, rst = 1'b1;
  always #5 clk = ~clk;  // 10 ns
  int cycle = 0;
  always @(posedge clk) cycle <= cycle + 1;

  logic start, done;
  logic [64*W-1:0] a_d;
  logic [64-1:0] r_d;
  logic a_v, a_r, r_v, r_r;
  int st_n, dn_n, st_t0, dn_t0, a_n, a_t0, r_n, r_bad, r_t0, r_t1;

  bambu_ctl #(.TASKS(TASKS)) u_ctl (
      .clk(clk), .rst(rst), .cycle(cycle), .start(start), .done(done),
      .started(st_n), .finished(dn_n), .t_first(st_t0), .t_done_first(dn_t0));
  beat_src #(.W(W), .NELEM(N), .FILE("IN_A.hex"), .TASKS(TASKS), .STALL(STALL), .SEED(11)) u_a (
      .clk(clk), .rst(rst), .cycle(cycle), .data(a_d), .valid(a_v), .ready(a_r), .sent(a_n), .t_first(a_t0));
  beat_chk #(.W(1), .NELEM(NOUT), .FILE("EXP_y.hex"), .NAME("y"), .STALL(STALL), .SEED(37)) u_r (
      .clk(clk), .rst(rst), .cycle(cycle), .data(r_d), .valid(r_v), .ready(r_r),
      .got(r_n), .bad(r_bad), .t_first(r_t0), .t_last(r_t1));

  `DUT dut (
      .clock(clk), .reset(~rst), .start_port(start), .done_port(done),
      .loop_count(32'(`LOOP_COUNT)), .len(32'(`LEN)),
      .A_TDATA(a_d), .A_TVALID(a_v), .A_TREADY(a_r),
      .y_TDATA(r_d), .y_TVALID(r_v), .y_TREADY(r_r));

  initial begin
    repeat (3) @(posedge clk);
    rst <= 1'b0;
    fork
      wait (r_n == TASKS * NOUT && dn_n == TASKS);
      begin
        repeat (`MAXCYC) @(posedge clk);
        $display("FAIL rowsum N=%0d W=%0d stall=%0d timeout after %0d cycles: %0d of %0d results out, %0d of %0d done",
                 N, W, STALL, `MAXCYC, r_n, TASKS * NOUT, dn_n, TASKS);
        $finish;
      end
    join_any
    @(posedge clk);
    $display("%0s rowsum N=%0d W=%0d stall=%0d cycles=%0d cycles_done=%0d latency=%0d: %0d of %0d results differ",
             r_bad ? "FAIL" : "PASS", N, W, STALL, r_t1 - st_t0, dn_t0 - st_t0, r_t0 - a_t0, r_bad, TASKS * NOUT);
    $finish;
  end
endmodule
