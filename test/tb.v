`default_nettype none
`timescale 1ns / 1ps

/*
 * Testbench for 2nd Order IIR Biquad Filter
 *
 * This testbench:
 *  - Generates the clock
 *  - Generates reset
 *  - Enables the design
 *  - Applies an impulse input
 *  - Dumps waveforms to tb.fst
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
  // 10 ns period = 100 MHz
  // ============================================================

  initial begin
    clk = 1'b0;

    forever #5 clk = ~clk;
  end


  // ============================================================
  // Test stimulus
  // ============================================================

  initial begin

    // Initial values
    rst_n  = 1'b0;
    ena    = 1'b1;
    ui_in  = 8'd0;
    uio_in = 8'd0;


    // ------------------------------------------------------------
    // RESET
    // ------------------------------------------------------------

    #20;

    rst_n = 1'b1;


    // ------------------------------------------------------------
    // IMPULSE INPUT
    // ------------------------------------------------------------
    //
    // Input sequence:
    //
    // 100, 0, 0, 0, 0, 0, ...
    //
    // This is useful for observing the IIR impulse response.
    // ------------------------------------------------------------

    @(posedge clk);
    ui_in = 8'd100;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;

    @(posedge clk);
    ui_in = 8'd0;


    // ------------------------------------------------------------
    // End simulation
    // ------------------------------------------------------------

    #20;

    $finish;

  end


  // ============================================================
  // Display values in terminal
  // ============================================================

  initial begin

    $monitor(
      "Time=%0t ns | rst_n=%b | ena=%b | input=%d | output=%d",
      $time,
      rst_n,
      ena,
      $signed(ui_in),
      $signed(uo_out)
    );

  end

endmodule
