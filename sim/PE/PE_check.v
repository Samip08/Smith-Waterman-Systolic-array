`timescale 1ns/1ps

module PE_check;
    // Parameters matching your latest PE
    parameter n = 5; 
    parameter CHARWIDTH = 2;
    parameter CLK_PERIOD = 10;
    
    reg clk, rst, load;
    reg [1:0] char_in;
    reg signed [n:0] E_in, F_in, G_in;
    reg [CHARWIDTH-1:0] S_in;
    
    wire signed [n:0] H_curr, H_delay;
    wire [CHARWIDTH-1:0] S_out, char_out;

    // DUT Instance with your updated port list
    PE #(.n(n), .CHARWIDTH(CHARWIDTH)) dut (
        .clk(clk), 
        .rst(rst),
        .load(load),
        .char_in(char_in),
        .E_in(E_in), 
        .F_in(F_in), 
        .G_in(G_in), 
        .S_in(S_in),
        .H_curr(H_curr), 
        .H_delay(H_delay),
        .S_out(S_out),
        .char_out(char_out)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        $dumpfile("PE_check.vcd");
        $dumpvars(0, PE_check);

        // --- PHASE 1: Reset ---
        $display("\n=== Starting Smith-Waterman PE Test ===");
        rst = 1; load = 0; char_in = 0;
        E_in = 0; F_in = 0; G_in = 0; S_in = 0;
        #(CLK_PERIOD * 2);
        rst = 0;
        $display("Status: Reset Complete");

        // --- PHASE 2: Load Query Character ---
        // Let's load '2' (e.g., 'T') into this PE
        @(posedge clk);
        load = 1;
        char_in = 2'b10; // Value 2
        @(posedge clk);
        load = 0;
        $display("Status: Loaded Q_pe = %0d", char_in);

        // --- PHASE 3: Match Test ---
        $display("\nTest 1: Match (S_in=2, Q_pe=2)");
        // Diagonal input (G_in) is 1. Match is +2.
        G_in = 1; S_in = 2'b10; 
        @(posedge clk); 
        #1; // Wait for logic to settle
        $display("  Input: G_in=%0d, Match=+2 | Output: H_curr=%0d (Expected: 3)", G_in, H_curr);

        // --- PHASE 4: Dependency & Delay Test ---
        $display("\nTest 2: Left Input & Delay Check");
        // E_in is 10. Loss is -1. Should result in 9.
        E_in = 10; S_in = 2'b01; // Mismatch with Q_pe(2)
        @(posedge clk);
        #1;
        $display("  Input: E_in=%0d, Loss=-1  | Output: H_curr=%0d (Expected: 9)", E_in, H_curr);
        $display("  Check: H_delay = %0d (Expected: 3 from previous cycle)", H_delay);

        // --- PHASE 5: Zero Floor (Local Alignment) ---
        $display("\nTest 3: Zero Floor Check");
        E_in = -5; F_in = -2; G_in = -10;
        @(posedge clk);
        #1;
        $display("  Input: All negative  | Output: H_curr=%0d (Expected: 0)", H_curr);

        $display("\n=== Simulation Complete ===\n");
        $finish;
    end
endmodule