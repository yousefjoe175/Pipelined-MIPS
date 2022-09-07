module EXC_handler (
    input   wire                OVF,
    input   wire                UND,
    output  wire                EPCEnable,
    output  wire                FlushM,
    output  wire                FlushE,
    output  wire                FlushD,
    output  wire                PCXmux,
    output  reg       [31:0]    CAUSE
);
    
    assign  EPCEnable   = OVF;
    assign  FlushD      = OVF;
    assign  FlushE      = OVF;
    assign  FlushM      = OVF;
    assign  PCXmux      = OVF;

    always @(*) begin
        if(OVF)
            CAUSE <= 32'b1;
    end

endmodule