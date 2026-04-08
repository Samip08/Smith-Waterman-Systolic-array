`timescale 1ns/1ps

module Genvar_tb;
    parameter N = 10; // Score bit-width
    parameter L = 4;  // Number of PEs (Query Length)
    
    reg clk, rst, load;
    reg [2*L-1:0] query_string;
    reg [1:0] s_char_in;
    wire [(N+1)*L-1:0] all_scores;

    // Instantiate the Wrapper
    Genvar_wrapper #(.n(N), .loaded_string_size(L)) uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .loaded_string(query_string),
        .S_char_in(s_char_in),
        .all_scores(all_scores)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        // --- Initialization ---
        clk = 0; rst = 1; load = 0; s_char_in = 0;
        query_string = 8'b11_10_01_00; // Example Query: T(11) G(10) C(01) A(00)
        
        $dumpfile("Genvar_sim.vcd");
        $dumpvars(0, Genvar_tb);

        #15 rst = 0;
        
        // --- Phase 1: Loading the Query ---
        // In your parallel-load code, this happens instantly
        $display("Time: %0t | Loading Query...", $time);
        #10 load = 1; 
        #10 load = 0; 

        // --- Phase 2: Streaming the Subject ---
        // We will stream "AGTC" (00, 10, 01, 11) one by one
        $display("Time: %0t | Starting Wavefront Stream...", $time);
        
        // Stream 'A' (00)
        s_char_in = 2'b00; #10; 
        // Stream 'G' (10)
        s_char_in = 2'b10; #10;
        // Stream 'C' (01)
        s_char_in = 2'b01; #10;
        // Stream 'T' (11)
        s_char_in = 2'b11; #10;
        
        // Final flush cycles to let the wave exit the last PE
        s_char_in = 2'b00; 
        repeat(L+2) #10;

        $display("Time: %0t | Simulation Finished.", $time);
        $finish;
    end

    // Monitor the scores for debugging
    initial begin
        $monitor("T=%0t | S_in=%b | Scores: %h", $time, s_char_in, all_scores);
    end

endmodule