//LS32-bit is instruction and MS32-bit is PC_next
module IF_ID_reg (
    input   wire            CLK         ,
    input   wire            reset       ,
    input   wire            CLR_sync    ,
    input   wire            Enable      ,
    input   wire    [31:0]  InstrF      ,
    input   wire    [31:0]  PCPlus4F    ,
    output  reg     [31:0]  InstrD      ,
    output  reg     [31:0]  PCPlus4D      
);
    
    always @(posedge CLK, negedge reset ) begin
        if (!reset) begin
            {PCPlus4D,InstrD} <= 64'b0;
        end else begin
            if (CLR_sync) begin
                {PCPlus4D,InstrD} <= 64'b0;
            end else if (Enable) begin
                {PCPlus4D,InstrD} <= {PCPlus4F,InstrF};    
            end else begin
                {PCPlus4D,InstrD} <= {PCPlus4D,InstrD};     //if enable is not set keep the old value
            end
            
        end
    end



endmodule