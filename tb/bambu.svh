// tb/bambu.svh: what a Bambu top needs around tb/common.svh's sources and checkers.
//
// common.svh comes unchanged from dslx-exercises (tb/SOURCE). Its cfg_src plays an XLS proc's
// cfg channel; a Bambu top has none. It has start_port and done_port, and the run-time pins
// (loop_count, len, alpha) are plain input wires that Bambu never registers: they feed the
// loop's comparators on every iteration, so they must hold their value for the whole task
// (notes/bambu.md, Limitations). bambu_ctl takes cfg_src's place: the testbench drives the pins
// as constants, and bambu_ctl pulses start_port once per task, the first time right after
// reset and then on the cycle after each done_port, TASKS times.
//
// Bambu's reset is active low and synchronous (`if (reset == 1'b0)` inside `always @(posedge
// clock)`); the testbenches keep common.svh's active-high rst and connect `.reset(~rst)`.
//
// Cycle counts, both from the start_port cycle (the counterpart of the cfg transfer):
//   cycles      to the last output beat, as dslx-exercises measures XLS
//   cycles_done to done_port, as Bambu's own co-simulation ("Total cycles") and Vitis's
//               ap_start to ap_done
`ifndef TB_BAMBU_SVH
`define TB_BAMBU_SVH
`include "common.svh"

module bambu_ctl #(
    parameter int TASKS = 1
) (
    input  logic clk,
    input  logic rst,
    input  int   cycle,
    output logic start,
    input  logic done,
    output int   started,
    output int   finished,
    output int   t_first,      // cycle of the first start pulse: the start of task 1
    output int   t_done_first  // cycle of the first done_port
);
  initial begin started = 0; finished = 0; t_first = -1; t_done_first = -1; end
  always @(posedge clk) begin
    if (rst) start <= 1'b0;
    else begin
      if (start) begin
        started <= started + 1;
        if (t_first < 0) t_first <= cycle;
      end
      if (done) begin
        finished <= finished + 1;
        if (t_done_first < 0) t_done_first <= cycle;
      end
      // One pulse right after reset, then one on the cycle after each done, while tasks remain.
      start <= !start && ((started == 0 && finished == 0) || done) && (started + start) < TASKS;
    end
  end
endmodule

`endif
