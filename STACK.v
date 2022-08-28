module STACK #(
    parameter STK_WIDTH = 32, 
    parameter PTR_WIDTH = 6
) (
    input   wire                            CLK     ,
    input   wire                            RST     ,
    input   wire                            PUSH    ,
    input   wire                            POP     ,    
    input   wire    [STK_WIDTH - 1 : 0]     Data_in ,

    output  wire                            FULL    ,
    output  wire                            EMPTY   ,
    output  reg     [PTR_WIDTH - 1 : 0]     SP      ,
    output  reg     [STK_WIDTH - 1 : 0]     Data_out
);

integer k;

reg [STK_WIDTH - 1 : 0] stack_mem [2**PTR_WIDTH - 1 : 0];




//stack pointer update
always @(posedge CLK, negedge RST ) begin
    if (!RST) begin
        SP <= -1;
    end else begin
        if(POP)
            begin
                if(!FULL) begin
                    SP <= SP - 'd1;
                end
            end
        else if(PUSH)
            begin
                if(!EMPTY) begin
                    SP <= SP + 'd1;
                end
            end
    end
end

assign  EMPTY   = &SP   ;

assign  FULL    = ~|SP  ;



// Popping is +ve edge triggered
// Pushing is -ve edge triggered
always @(posedge CLK , negedge RST) begin
    if (!RST) begin
        for(k = 0; k < 2**PTR_WIDTH; k = k + 1) 
            begin
                stack_mem[k] <= 0;
            end
    end else begin
        if(POP) stack_mem[SP] <= Data_in;
    end
end

always @(negedge CLK, negedge RST) begin
    if (!RST) begin
        Data_out <= 'd0;
    end else begin
        if(PUSH) Data_out <= stack_mem[SP + 'd1];
    end
end
   
endmodule