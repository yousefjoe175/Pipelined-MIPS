module EPC_register (
    input   wire                CLK,
    input   wire                RST,
    input   wire                Enable,
    input   wire    [31:0]      PC,
    output  reg     [31:0]      EPC
);


    always @(posedge CLK, negedge RST ) begin
        if(!RST)
            EPC <= 32'd0;
        else
            if (Enable) begin
                EPC <= PC;
            end
    end
    
endmodule