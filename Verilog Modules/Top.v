module Top #(
    parameter n = 20,  //preferably larger to hold peak value(n=20)
    parameter CHARWIDTH = 2, 
    parameter loaded_string_size = 100,
    parameter second_string_size = 100  
)(
    input clk, rst, start,
    // input [2*loaded_string_size-1:0] loaded_string,
    // input [2*second_string_size-1:0] second_string,
    output [n:0] max_score,
    output reg done,
    output [6:0] best_i,
    output reg [7:0] best_j
);

reg [CHARWIDTH-1:0] mem_query [0:loaded_string_size-1];
reg [CHARWIDTH-1:0] mem_subject [0:second_string_size-1];
reg [CHARWIDTH*loaded_string_size-1:0] flattened_query;

wire signed [n:0] current_cycle_max;
wire [6:0] current_best_pe;
assign best_i = current_best_pe;

integer j;
initial begin
    $readmemb("seq1.mem", mem_query);
    $readmemb("seq2.mem", mem_subject);
    
    for (j = 0; j < loaded_string_size; j = j + 1) begin
        flattened_query[j*CHARWIDTH +: CHARWIDTH] = mem_query[j];
    end
end

reg [7:0] count;
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
            if (count < second_string_size+ loaded_string_size) begin
                // S_in_curr <= second_string[count*CHARWIDTH +: CHARWIDTH];
                if (count < second_string_size) begin
                    S_in_curr <= mem_subject[count];
                end else begin
                S_in_curr <= 2'b00;
                end
                count <= count + 1;
            end else begin
                process <= 1'b0;
                done <= 1'b1;
            end

            if (max_score < current_cycle_max) begin
                best_j <= count; 
            end
        end        
    end
end

Genvar_wrapper #(.n(n), .loaded_string_size(loaded_string_size)) genvar_wrapper (
    .clk(clk),
    .load(load),
    .rst(rst),
    .loaded_string(flattened_query),
    .S_char_in(S_in_curr),
    .all_scores(all_scores)
);

Max #(.n(n), .loaded_string_size(loaded_string_size)) max (
    .clk(clk),
    .rst(rst),
    .all_scores(all_scores),
    .max_out(max_score),
    .max_pe_idx(best_i),        
    .max_curr_val(current_cycle_max)
);

endmodule