`default_nettype none
`timescale 1ns / 1ps

/*
 * Testbench for Tiny Tapeout 2nd Order IIR Biquad Filter
 */

module tb ();

  // ============================================================
  // Dump signals to FST file
  // ============================================================

  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
  end


  // ============================================================
  // Tiny Tapeout signals
  // ============================================================

  reg        clk;
  reg        rst_n;
  reg        ena;

  reg [7:0]  ui_in;
  reg [7:0]  uio_in;

  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;


  // ============================================================
  // Instantiate the IIR Biquad
  // ============================================================

  tt_um_iir_biquad user_project (
      .ui_in  (ui_in),
      .uo_out (uo_out),

      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),

      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );


  // ============================================================
  // Clock generation
  // 10 ns period
  // ============================================================

  initial begin
    clk = 1'b0;

    forever #5 clk = ~clk;
  end


  // ============================================================
  // Test stimulus
  // ============================================================

  initial begin

    // Initial conditions
    rst_n  = 1'b0;
    ena    = 1'b1;
    ui_in  = 8'd0;
    uio_in = 8'd0;


    // ==========================================================
    // RESET
    // ==========================================================

    $display("----------------------------------------");
    $display("Resetting IIR Biquad Filter");
    $display("----------------------------------------");

    #20;

    rst_n = 1'b1;

    @(posedge clk);


    // ==========================================================
    // IMPULSE RESPONSE
    // ==========================================================

    $display("");
    $display("----------------------------------------");
    $display("IIR BIQUAD IMPULSE RESPONSE");
    $display("----------------------------------------");
    $display("Input\tOutput");


    // First sample = impulse
    ui_in = 8'd100;

    @(posedge clk);
    #1;

    $display("%d\t%d", ui_in, $signed(uo_out));


    // Remaining samples = zero
    ui_in = 8'd0;

    @(posedge clk);
    #1;
    $display("%d\t%d", ui_in, $signed(uo_out));

    @(posedge clk);
    #1;
    $display("%d\t%d", ui_in, $signed(uo_out));

    @(posedge clk);
    #1;
    $display("%d\t%d", ui_in, $signed(uo_out));

    @(posedge clk);
    #1;
    $display("%d\t%d", ui_in, $signed(uo_out));

    @(posedge clk);
    #1;
    $display("%d\t%d", ui_in, $signed(uo_out));

    @(posedge clk);
    #1;
    $display("%d\t%d", ui_in, $signed(uo_out));

    @(posedge clk);
    #1;
    $display("%d\t%d", ui_in, $signed(uo_out));

    @(posedge clk);
    #1;
    $display("%d\t%d", ui_in, $signed(uo_out));

    @(posedge clk);
    #1;
    $display("%d\t%d", ui_in, $signed(uo_out));


    // ==========================================================
    // END SIMULATION
    // ==========================================================

    $display("");
    $display("----------------------------------------");
    $display("Simulation completed");
    $display("----------------------------------------");

    #20;

    $finish;

  end

endmodule
