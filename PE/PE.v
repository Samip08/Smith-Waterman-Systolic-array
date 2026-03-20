module PE #(
    parameter n = 5,  //preferably larger to hold peak value(n=20)
    parameter CHARWIDTH = 2, 
    parameter signed match = 2, 
    parameter signed mismatch = -1,
    parameter signed loss = -1  
)(  input clk,
    input load,
    input rst,
    input [1:0] char_in, // A, G ,T ,C
    input signed [n:0] E_in,     //left input
    input signed[n:0] F_in,     //up input 
    input signed[n:0] G_in,     //diagonal input 
    input [CHARWIDTH-1:0] S_in,          
    output reg signed [n:0] H_curr,
    output reg signed [n:0] H_delay,
    output reg [CHARWIDTH-1:0] S_out,
    output reg [CHARWIDTH-1:0] char_out
);
reg [CHARWIDTH-1:0] Q_pe;
wire signed [n:0] E_temp, F_temp, G_temp, H_temp;
assign E_temp = E_in+loss;
assign F_temp = F_in+loss;
assign G_temp = (Q_pe == S_in) ? (G_in + match) : (G_in + mismatch);
assign H_temp = (E_temp > F_temp && E_temp > G_temp && E_temp >0) ? E_temp : 
                (F_temp > G_temp && F_temp > 0) ? F_temp : (G_temp > 0)? G_temp : 0;     

always@(posedge clk) begin
    if (rst) begin
        H_curr <= 0;
        H_delay <= 0;
        S_out <= 0;

    end else if(load) begin 
        Q_pe <= char_in;
        char_out <= Q_pe;

    end else begin 
        S_out <= S_in;
        H_delay <= H_curr;
        H_curr <= H_temp;
    end 
end 
endmodule