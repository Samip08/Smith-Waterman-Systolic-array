`timescale 1ns/1ps

module PE_check;
    parameter n = 3;
    parameter CLK_PERIOD = 10;
    
    reg clk;
    reg signed [n:0] E_in, F_in, G_in;
    reg [n-1:0] S_in;
    wire signed [n:0] H_out;
    wire [n-1:0] S_out;

    PE #(.n(n), .Q_pe(2)) dut (
        .clk(clk), .E_in(E_in), .F_in(F_in), .G_in(G_in), .S_in(S_in),
        .H_out(H_out), .S_out(S_out)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        $dumpfile("PE_check.vcd");
        $dumpvars(0, PE_check);

        // Initialize
        E_in = 0; F_in = 0; G_in = 0; S_in = 0;

        $display("\n=== PE Logic Test (n=3) ===");

        // Test 1: Match
        $display("Test 1: Match (S_in=2, Q_pe=2)");
        G_in = 1; S_in = 2; 
        @(negedge clk); #1;
        $display("  Input: G_in=%0d, Match=+2 | Output: H_out=%0d (Expected: 3)", G_in, H_out);

        // Test 2: Left Input High (The one that failed before)
        $display("Test 2: Left Input High (E_in=5)");
        E_in = 5; F_in = 0; G_in = 0; S_in = 0; 
        @(negedge clk); #1;
        $display("  Input: E_in=%0d, Loss=-1  | Output: H_out=%0d (Expected: 4)", E_in, H_out);
        if (H_out == 4) $display("  RESULT: SUCCESS");
        else           $display("  RESULT: FAILURE - Still Overflowing!");

        // Test 3: Clipping
        $display("Test 3: Clipping Negative");
        E_in = 0; F_in = 0; G_in = 0; S_in = 0; 
        @(negedge clk); #1;
        $display("  Input: All 0, Mismatch | Output: H_out=%0d (Expected: 0)", H_out);

        $display("=== Simulation Complete ===\n");
        $finish;
    end
endmodule