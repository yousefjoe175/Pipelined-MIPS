module CAUSE_Reg (
    input   wire                CLK,
    input   wire                RST,
    input   wire    [31:0]      EXC,
    output  reg     [31:0]      CAUSE
);
    always @(posedge CLK, negedge RST) begin
        if(!RST)
            CAUSE <= 32'd0;
        else
            CAUSE <= EXC;
    end


endmodule