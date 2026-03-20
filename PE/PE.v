module PE #(
    parameter n = 3,
    parameter Q_pe =2, // 2 bit value of the pe     
    parameter signed match = 2, 
    parameter signed mismatch = -1,
    parameter signed loss = -1  
)(  input clk,
    input signed [n:0] E_in,     //left input
    input signed[n:0] F_in,     //up input 
    input signed[n:0] G_in,     //diagonal input 
    input [n-1:0] S_in,          
    output reg signed [n:0] H_out,
    output reg [n-1:0] S_out
);

wire signed [n:0] E_temp, F_temp, G_temp, H_temp;
assign E_temp = E_in+loss;
assign F_temp = F_in+loss;
assign G_temp = (Q_pe == S_in) ? (G_in + match) : (G_in + mismatch);
assign H_temp = (E_temp > F_temp && E_temp > G_temp) ? E_temp : 
                (F_temp > G_temp) ? F_temp : G_temp;

always@(negedge clk) begin
    S_out <= S_in;
    if (H_temp < 0) begin
        H_out <= 0;
    end 
    else begin
        H_out <= H_temp;
    end
end
endmodule