//ID_EX_out <= {PC_next,RD1,RD2,Imm};
module ID_EX_reg (
    input   wire            CLK,
    input   wire            reset,
    input   wire            CLR_sync,

    input   wire    [31:0]  RD1D,
    input   wire    [31:0]  RD2D,
    input   wire    [ 4:0]  RsD,
    input   wire    [ 4:0]  RtD,
    input   wire    [ 4:0]  RdD,
    input   wire    [31:0]  ImmD,
    

    input   wire            RegWriteD,    
    input   wire            MemtoRegD,
    input   wire            MemWriteD,
    
    input   wire    [ 2:0]  ALUControlD,
    input   wire            ALUSrcD,
    input   wire            RegDstD,

    output  reg     [31:0]  RD1E,
    output  reg     [31:0]  RD2E,
    output  reg     [ 4:0]  RsE,
    output  reg     [ 4:0]  RtE,
    output  reg     [ 4:0]  RdE,
    output  reg     [31:0]  ImmE,
    

    output  reg             RegWriteE,  
    output  reg             MemtoRegE,
    output  reg             MemWriteE,
    
    output  reg     [ 2:0]  ALUControlE,
    output  reg             ALUSrcE,
    output  reg             RegDstE
    
);

always @(posedge CLK, negedge reset ) begin
    if (!reset) begin
            {RD1E,RD2E,RsE,RtE,RdE,ImmE} <= 138'b0;
        end else begin
            if (CLR_sync) begin
                {RD1E,RD2E,RsE,RtE,RdE,ImmE} <= 138'b0;
            end else begin
                {RD1E,RD2E,RsE,RtE,RdE,ImmE} <= {RD1D,RD2D,RsD,RtD,RdD,ImmD};    
            end
            
        end
end

always @(posedge CLK, negedge reset ) begin
    if (!reset) begin
            {RegWriteE,MemtoRegE,MemWriteE,ALUControlE,ALUSrcE,RegDstE} <= 9'b0;
        end else begin
            if (CLR_sync) begin
                {RegWriteE,MemtoRegE,MemWriteE,ALUControlE,ALUSrcE,RegDstE} <= 9'b0;    //NOP cause the bubble
            end else begin
                {RegWriteE,MemtoRegE,MemWriteE,ALUControlE,ALUSrcE,RegDstE} <= {RegWriteD,MemtoRegD,MemWriteD,ALUControlD,ALUSrcD,RegDstD};    
            end
        end
end


endmodule