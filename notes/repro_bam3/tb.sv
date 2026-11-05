// notes/repro_bam3/tb.sv: one beat on A and B (always valid), C always ready; compare every 32-bit word of C.
// +define+DUT=<top> +define+LANES=<n>
`timescale 1ns/1ps
module tb;
  localparam int WB = 64 * `LANES;
  logic clock = 0, reset = 0, start_port = 0;
  logic [WB-1:0] a, b, ref_c, got;
  wire [WB-1:0] C_TDATA;
  wire done_port, A_TREADY, B_TREADY, C_TVALID;
  `DUT dut(.clock(clock), .reset(reset), .start_port(start_port), .done_port(done_port),
           .A_TDATA(a), .A_TVALID(1'b1), .A_TREADY(A_TREADY), .B_TDATA(b), .B_TVALID(1'b1), .B_TREADY(B_TREADY),
           .C_TDATA(C_TDATA), .C_TVALID(C_TVALID), .C_TREADY(1'b1));
  always #5 clock = ~clock;
  int bad = 0, n = 0;
  always @(posedge clock) if (C_TVALID) begin got <= C_TDATA; n <= n + 1; end
  initial begin
    for (int l = 0; l < `LANES; l++) begin
      a[64*l +: 64] = {32'h1000_0000 + l, 32'h0000_1000 + 16*l};   // both words nonzero, no carry between words
      b[64*l +: 64] = {32'h0200_0000 + l, 32'h0000_0100 + l};
      ref_c[64*l +: 64] = a[64*l +: 64] + b[64*l +: 64];
    end
    repeat (3) @(posedge clock); reset = 1;
    @(posedge clock); start_port <= 1; @(posedge clock); start_port <= 0;
    while (!done_port) @(posedge clock);
    @(posedge clock); #1;
    for (int wd = 0; wd < 2 * `LANES; wd++)
      if (got[32*wd +: 32] !== ref_c[32*wd +: 32]) begin
        $display("  lane %0d %s word: got %h expected %h", wd / 2, wd % 2 ? "hi" : "lo",
                 got[32*wd +: 32], ref_c[32*wd +: 32]);
        bad++;
      end
    $display("%s LANES=%0d beats_out=%0d: %0d of %0d words differ", (bad || n != 1) ? "FAIL" : "PASS", `LANES, n, bad, 2 * `LANES);
    $finish;
  end
endmodule
