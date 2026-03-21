module Top #(
    parameter n = 10,  //preferably larger to hold peak value(n=20)
    parameter CHARWIDTH = 2, 
    parameter loaded_string_size = 4,
    parameter second_string_size = 8  
)(
    input clk, rst, start,
    input [2*loaded_string_size-1:0] loaded_string,
    input [2*second_string_size-1:0] second_string,
    output [n:0] max_score,
    output reg done
);

reg [4:0] count;
reg process = 1'b0;
reg load = 1'b0;
reg [CHARWIDTH-1:0] S_in_curr;
wire [(n+1)*loaded_string_size-1 : 0] all_scores;

always @(posedge clk )begin
    if(rst) begin
        count <= 0;
        process <= 0;
        load <= 0;
        done <= 0;
        S_in_curr <= 0;

    end else begin 

        if (start && !process && !done) begin
            process <= 1'b1;
            load <= 1'b1; 
        
        end else if (process && !done) begin
            load <= 1'b0;
            if (count < second_string_size) begin
                S_in_curr <= second_string[count*CHARWIDTH +: CHARWIDTH];
                count <= count + 1;
            end else begin
                process <= 1'b0;
                done <= 1'b1;
            end
        end        
    end
end

Genvar_wrapper #(.n(n), .loaded_string_size(loaded_string_size)) genvar_wrapper (
    .clk(clk),
    .load(load),
    .rst(rst),
    .loaded_string(loaded_string),
    .S_char_in(S_in_curr),
    .all_scores(all_scores)
);

Max #(.n(n), .loaded_string_size(loaded_string_size)) max (
    .clk(clk),
    .rst(rst),
    .all_scores(all_scores),
    .max_out(max_score)
);

endmodule