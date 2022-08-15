module MUX3_1 #(
    parameter WIDTH = 32
) (
    input   wire    [WIDTH - 1 : 0]     A,
    input   wire    [WIDTH - 1 : 0]     B,
    input   wire    [WIDTH - 1 : 0]     C,
    input   wire    [   1      : 0]     sel,
    output  reg     [WIDTH - 1 : 0]     out
);

always @(*) begin
    if (sel == 2'b00) begin //if 00 or 11
            out = A;
    end else if (sel == 2'b01) begin 
            out = B;
    end else if (sel == 2'b10) begin
            out = C;
    end else    begin
            out = A;
    end
end
    
endmodule