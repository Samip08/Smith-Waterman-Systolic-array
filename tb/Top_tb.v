`timescale 1ns/1ps

module Top_tb;
    reg clk, rst, start;
    wire [20:0] max_score;
    wire [6:0] best_i;
    wire [7:0] best_j;
    wire done;

    // Instantiate Top
    Top #(.n(20), .loaded_string_size(100), .second_string_size(100)) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .max_score(max_score),
        .done(done),
        .best_i(best_i),
        .best_j(best_j)
    );

    // Helper function to decode bits to letters
    function [7:0] decode_dna;
        input [1:0] bits;
        begin
            case(bits)
                2'b00: decode_dna = "A";
                2'b01: decode_dna = "C";
                2'b10: decode_dna = "G";
                2'b11: decode_dna = "T";
                default: decode_dna = "?";
            endcase
        end
    endfunction

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; start = 0;
        #20 rst = 0;
        #20 start = 1;
        #10 start = 0;

        wait(done == 1);
        
        #10;
        $display("===========================================");
        $display("         SMITH-WATERMAN RESULT             ");
        $display("===========================================");
        $display("Final Peak Score: %d", $signed(max_score));
        $display("Query Match Index (PE):   %d", best_i);
        $display("Subject Match Index (Time): %d", best_j);
        
        // Logic to show what characters aligned
        // Note: Subject index in mem_subject is best_j - best_i
        if (best_j >= best_i) begin
            $display("Aligned Subject Char: %s", decode_dna(uut.mem_subject[best_j - best_i]));
            $display("Aligned Query Char:   %s", decode_dna(uut.mem_query[best_i]));
        end
        
        $display("===========================================");
        
        #100 $finish;
    end

    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, Top_tb);
    end
endmodule