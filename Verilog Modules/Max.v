module Max #(
    parameter n = 20,
    parameter loaded_string_size = 100
)(   
    input clk,
    input rst,
    input wire [(n+1)*loaded_string_size-1 : 0] all_scores,
    output reg signed [n:0] max_out,
    output reg [6:0] max_pe_idx,
    output signed [n:0] max_curr_val
);

integer i;
reg signed [n:0] max_curr;
reg [6:0] best_idx;
assign max_curr_val = max_curr;


always@(*) begin
    max_curr = {(n+1){1'b1}}; 
    best_idx = 0;  //not the biggest value but the smallest
    for (i = 0; i <loaded_string_size;i = i+1) begin
        if ($signed(all_scores[i*(n+1) +: (n+1)]) > $signed(max_curr)) begin
            max_curr = all_scores[i*(n+1) +: (n+1)];
            best_idx = i;
        end
    end
end

always@(posedge clk)begin
    if(rst) begin
        max_out = {(n+1){1'b0}};
        max_pe_idx = 0;
    end else begin 
        if(max_out< max_curr) begin
            max_out = max_curr;
            max_pe_idx <= best_idx;
        end
    end
end
endmodule