module CMP #(
    parameter WIDTH = 32
) (
    input   wire    [ WIDTH - 1 : 0]    A,
    input   wire    [ WIDTH - 1 : 0]    B,
    output  wire                        Eq,
    output  wire                        Ne,
    output  wire                        Gt,
    output  wire                        Lt
);
    
    assign  Eq  =   A == B? 1 : 0;
    assign  Ne  =   A == B? 0 : 1;
    assign  Gt  =   A >  B? 1 : 0;
    assign  Lt  =   A <  B? 1 : 0;


endmodule