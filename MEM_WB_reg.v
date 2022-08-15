//EX_MEM_out <= {ReadData,ALUResult};
module MEM_WB_reg (
    input   wire                CLK,
    input   wire                reset,
    input   wire    [31:0]      ALUResultM,
    input   wire    [31:0]      ReadDataM,
    input   wire    [ 4:0]      WriteRegM,
    
    input   wire                RegWriteM,
    input   wire                MemtoRegM,    

    output  reg     [31:0]      ALUResultW,
    output  reg     [31:0]      ReadDataW,
    output  reg     [ 4:0]      WriteRegW,

    output reg                  RegWriteW,
    output reg                  MemtoRegW 
);

always @(posedge CLK, negedge reset ) begin
    if (!reset) begin
            {ALUResultW,ReadDataW,WriteRegW} <= 69'b0;
        end else begin
            {ALUResultW,ReadDataW,WriteRegW} <= {ALUResultM,ReadDataM,WriteRegM};
        end
end

always @(posedge CLK, negedge reset ) begin
    if (!reset) begin
            {RegWriteW,MemtoRegW} <= 2'b0;
        end else begin
            {RegWriteW,MemtoRegW} <= {RegWriteM,MemtoRegM};
        end
end
    
endmodule