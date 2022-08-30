module Register (
    input   wire    [31:0]      IN,
    input   wire                CLK,
    input   wire                RST,
    input   wire                Enable,
    output  reg     [31:0]      OUT            
);
    

    always @(posedge CLK , negedge RST) begin
        if (!RST) begin
            OUT <= 32'b0;
        end else begin
            if(Enable) begin
                OUT <= IN;
            end
        end
    end


endmodule