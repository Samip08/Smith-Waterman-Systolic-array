`timescale 1ns/1ps

module booth_multiplier_tb;
    // 1. Parameters and Signals
    parameter n = 8;
    reg [n-1:0] multiplicand;
    reg [n-1:0] multiplier;
    wire [2*n-1:0] product;

    // 2. Instantiate the Unit Under Test (UUT)
    booth_multiplier #(n) uut (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product)
    );

    initial begin
        // 3. Setup Waveform Dumping for GTKWave
        $dumpfile("booth_test.vcd");
        $dumpvars(0, booth_multiplier_tb);

        // 4. Apply Test Case: -4 and 5
        // In 8-bit: -4 is 8'sb11111100, 5 is 8'sb00000101
        multiplicand = -8'd25; 
        multiplier = 8'd49;

        // Wait for the combinational logic to settle
        #10;

        // 5. Display the result in Decimal (%d) and Binary (%b)
        $display("---------------------------------------");
        $display("Multiplicand: %d (Binary: %b)", $signed(multiplicand), multiplicand);
        $display("Multiplier:   %d (Binary: %b)", $signed(multiplier), multiplier);
        $display("Result:       %d (Binary: %b)", $signed(product), product);
        $display("---------------------------------------");

        if ($signed(product) == -1225) 
            $display("SUCCESS");
        else 
            $display("FAILURE: Expected -20, got %d", $signed(product));

        $finish;
    end
endmodule