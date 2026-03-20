module booth_multiplier #(parameter n=8)(
    input [n-1:0] multiplicand,
    input [n-1:0] multiplier,
    output reg [2*n-1:0] product
);

reg [2*n-1:0] AQ;
reg [n-1:0] B;
reg Q_1;
reg [1:0] check;

integer k;

always@(*)begin
    AQ = {{n{1'b0}}, multiplier};
    Q_1 = 1'b0;
    B = multiplicand;

    for(k=n;k!=1'b0;k--)begin
        check = {AQ[0],Q_1};
        if(check == 2'b01)begin
            AQ[2*n-1:n]=AQ[2*n-1:n]+B;
        end 
        if(check == 2'b10)begin
            AQ[2*n-1:n]=AQ[2*n-1:n] + ~B + {{(n-1){1'b0}},1'b1};
        end
        Q_1 = AQ[0];
        AQ = {AQ[2*n-1],AQ[2*n-1:1]};
    end
    product = AQ;
end

endmodule

