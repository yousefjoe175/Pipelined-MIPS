//EX_MEM_out <= {PCBranch,Zero,ALUResult,RD2};
module EX_MEM_reg (
    input   wire                CLK,
    input   wire                reset,
    
    input   wire    [31:0]      ALUResultE,
    input   wire    [31:0]      WriteDataE,
    input   wire    [ 4:0]      WriteRegE,
    
    
    input   wire                RegWriteE,
    input   wire                MemtoRegE,    
    input   wire                MemWriteE,
    
    output  reg     [31:0]      ALUResultM,
    output  reg     [31:0]      WriteDataM,
    output  reg     [ 4:0]      WriteRegM,
    
    output  reg                 RegWriteM,
    output  reg                 MemtoRegM,    
    output  reg                 MemWriteM
    
);

always @(posedge CLK, negedge reset ) begin
    if (!reset) begin
            {ALUResultM,WriteDataM,WriteRegM} <= 102'b0;
        end else begin
            {ALUResultM,WriteDataM,WriteRegM} <= {ALUResultE,WriteDataE,WriteRegE};
        end
end

always @(posedge CLK, negedge reset ) begin
    if (!reset) begin
            {RegWriteM,MemtoRegM,MemWriteM} <= 4'b0;
        end else begin
            {RegWriteM,MemtoRegM,MemWriteM} <= {RegWriteE,MemtoRegE,MemWriteE};
        end
end

endmodule