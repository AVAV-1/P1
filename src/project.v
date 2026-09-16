/*
 * 2nd Order IIR Biquad Filter
 * Tiny Tapeout
 *
 * Difference equation:
 *
 * y[n] = b0*x[n] + b1*x[n-1] + b2*x[n-2]
 *        - a1*y[n-1] - a2*y[n-2]
 *
 * Fixed-point coefficients: Q1.7
 */

`default_nettype none

module tt_um_iir_biquad (
    input  wire [7:0] ui_in,     // 8-bit input sample
    output wire [7:0] uo_out,    // 8-bit output sample
    input  wire [7:0] uio_in,    // Unused
    output wire [7:0] uio_out,   // Unused
    output wire [7:0] uio_oe,    // Unused
    input  wire       ena,       // Enable
    input  wire       clk,       // Clock
    input  wire       rst_n      // Active-low reset
);

    // ============================================================
    // INPUT AND OUTPUT
    // ============================================================

    wire signed [7:0] x;

    reg signed [7:0] y;

    assign x = ui_in;

    assign uo_out = y;

    // Bidirectional pins unused
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;


    // ============================================================
    // DELAY REGISTERS
    // ============================================================

    reg signed [7:0] x1;
    reg signed [7:0] x2;

    reg signed [7:0] y1;
    reg signed [7:0] y2;


    // ============================================================
    // BIQUAD COEFFICIENTS
    //
    // Q1.7 format
    //
    // b0 = 0.25  -> 32
    // b1 = 0.50  -> 64
    // b2 = 0.25  -> 32
    //
    // a1 = -0.40 -> -51
    // a2 = 0.20  -> 26
    // ============================================================

    localparam signed [7:0] B0 = 8'sd32;
    localparam signed [7:0] B1 = 8'sd64;
    localparam signed [7:0] B2 = 8'sd32;

    localparam signed [7:0] A1 = -8'sd51;
    localparam signed [7:0] A2 = 8'sd26;


    // ============================================================
    // MULTIPLIERS
    // ============================================================

    reg signed [15:0] mult_b0;
    reg signed [15:0] mult_b1;
    reg signed [15:0] mult_b2;

    reg signed [15:0] mult_a1;
    reg signed [15:0] mult_a2;


    // ============================================================
    // ACCUMULATOR
    // ============================================================

    reg signed [19:0] accumulator;

    reg signed [19:0] result;


    // ============================================================
    // IIR BIQUAD
    // ============================================================

    always @(posedge clk) begin

        if (!rst_n) begin

            // Reset delay elements
            x1 <= 8'sd0;
            x2 <= 8'sd0;

            y1 <= 8'sd0;
            y2 <= 8'sd0;

            y <= 8'sd0;

        end

        else if (ena) begin

            // ----------------------------------------------------
            // Feed-forward terms
            // ----------------------------------------------------

            mult_b0 = x  * B0;
            mult_b1 = x1 * B1;
            mult_b2 = x2 * B2;

            // ----------------------------------------------------
            // Feedback terms
            // ----------------------------------------------------

            mult_a1 = y1 * A1;
            mult_a2 = y2 * A2;

            // ----------------------------------------------------
            // Difference equation
            //
            // y[n] =
            // b0*x[n] + b1*x[n-1] + b2*x[n-2]
            // - a1*y[n-1] - a2*y[n-2]
            // ----------------------------------------------------

            accumulator =
                mult_b0 +
                mult_b1 +
                mult_b2 -
                mult_a1 -
                mult_a2;

            // ----------------------------------------------------
            // Convert Q2.14 back to Q1.7
            // ----------------------------------------------------

            result = accumulator >>> 7;

            // Output
            y <= result[7:0];

            // ----------------------------------------------------
            // Update delay registers
            // ----------------------------------------------------

            x2 <= x1;
            x1 <= x;

            y2 <= y1;
            y1 <= result[7:0];

        end

    end


    // ============================================================
    // UNUSED INPUT
    // ============================================================

    wire _unused;

    assign _unused = &{uio_in, 1'b0};

endmodule
