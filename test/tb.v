`timescale 1ns/1ps

module biquad_iir_tb;

    // Inputs
    reg clk;
    reg reset;
    reg signed [15:0] x;

    // Output
    wire signed [15:0] y;

    // ------------------------------------------------
    // Instantiate the IIR Biquad Filter
    // ------------------------------------------------

    biquad_iir uut (
        .clk   (clk),
        .reset (reset),
        .x     (x),
        .y     (y)
    );

    // ------------------------------------------------
    // Clock generation
    // 10 ns clock period = 100 MHz
    // ------------------------------------------------

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ------------------------------------------------
    // Test sequence
    // ------------------------------------------------

    initial begin

        // Initial values
        reset = 1;
        x = 0;

        // Hold reset
        #20;

        // Release reset
        reset = 0;

        // ------------------------------------------------
        // IMPULSE INPUT
        // ------------------------------------------------

        // x[n] = 10000
        x = 16'sd10000;
        #10;

        // x[n] = 0 from now onwards
        x = 16'sd0;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;

        // End simulation
        $stop;

    end

    // ------------------------------------------------
    // Display results
    // ------------------------------------------------

    initial begin

        $monitor(
            "Time = %0t ns | Reset = %b | Input = %d | Output = %d",
            $time,
            reset,
            x,
            y
        );

    end

endmodule
