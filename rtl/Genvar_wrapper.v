module Genvar_wrapper #(
    parameter n = 20, //preferably larger to hold peak value(n=20)
    parameter loaded_string_size = 100 
)(
    input clk,
    input load,
    input rst,
    input [2*loaded_string_size-1:0] loaded_string,
    input [1:0] S_char_in,
    output wire [(n+1)*loaded_string_size-1 : 0] all_scores    
);

wire signed [n:0] H_curr [0:loaded_string_size-1];
wire signed [n:0] H_delay [0:loaded_string_size-1];
wire [1:0] S_out [0:loaded_string_size-1];
wire [1:0] char_out [0:loaded_string_size-1];

genvar i;
generate
    for( i=0; i<loaded_string_size; i=i+1)begin : PE_GEN
        if(i==0) begin
            PE #(.n(n)) pe (
                .clk(clk),
                .load(load),
                .rst(rst),
                .char_in(loaded_string[1:0]),
                .E_in({(n+1){1'b0}}),
                .F_in({(n+1){1'b0}}),  //fix because it takes 11 bit 0's
                .G_in({(n+1){1'b0}}),
                .S_in(S_char_in),
                .H_curr(H_curr[i]),
                .H_delay(H_delay[i]),
                .S_out(S_out[i]),
                .char_out(char_out[i])
            );
        end else begin 
            PE #(.n(n)) pe (
                .clk(clk),
                .load(load),
                .rst(rst),
                .char_in(loaded_string[2*i+1:2*i]),
                .E_in(H_curr[i-1]),
                .F_in(H_curr[i]),
                .G_in(H_delay[i-1]),
                .S_in(S_out[i-1]),
                .H_curr(H_curr[i]),
                .H_delay(H_delay[i]),
                .S_out(S_out[i]),
                .char_out(char_out[i])
            );
        end

        assign all_scores[i*(n+1) +: (n+1)] = H_curr[i];
    end
endgenerate
endmodule 