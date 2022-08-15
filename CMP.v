module CMP #(
    parameter WIDTH = 32
) (
    input   wire    [ WIDTH - 1 : 0]    A,
    input   wire    [ WIDTH - 1 : 0]    B,
    output  wire                        cmp
);
    
    assign cmp = A == B? 1 : 0;
endmodule