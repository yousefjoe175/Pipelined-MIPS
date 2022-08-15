module Hazard_Unit (
    input   wire    [4:0]   RsE,
    input   wire    [4:0]   RtE,
    input   wire    [4:0]   WriteRegM,
    input   wire            RegWriteM,
    input   wire    [4:0]   WriteRegW,
    input   wire            RegWriteW,

    output  reg     [1:0]   ForwardAE,
    output  reg     [1:0]   ForwardBE,


    input   wire            RegWriteE,
    input   wire            ALUSrcE,
    input   wire            MemtoRegE,
    input   wire            MemtoRegM,
    input   wire    [4:0]   RsD,
    input   wire    [4:0]   RtD,

    output  reg             FlushE,
    output  reg             StallD,
    output  reg             StallF,

    input   wire    [4:0]   WriteRegE,
    input   wire            BranchD,

    output  reg             ForwardAD,
    output  reg             ForwardBD,

    input   wire            RegDstD,

    output  reg             ForwardAWD,
    output  reg             ForwardBWD
    

);
    
    reg     BranchStall, lwStall;

    always @(*) begin
        if((RsE == WriteRegM) && RegWriteM)   //data coming from memory stage
            ForwardAE = 2'b01;
        else if (RsE == WriteRegW && RegWriteW)
            ForwardAE = 2'b10;
        else
            ForwardAE = 2'b00;
    end


    always @(*) begin
        if((RtE == WriteRegM) && RegWriteW)
            ForwardBE = 2'b01;
        else if ((RtE == WriteRegW) && RegWriteW)
            ForwardBE = 2'b10;
        else
            ForwardBE = 2'b00;
    end


    //handling data hazard stalling
    //if {ID/EX.MemRead and [(ID/EX.RegisterRt = IF/ID.RegisterRs) or (ID/EX.RegisterRt = IF/ID.RegisterRt)]}
    always @(*) begin
        if(MemtoRegE && ((RtE == RsD) || (RtE == RtD)))
            lwStall = 1'b1;
        else 
            lwStall = 1'b0;
    end 

    always @(*) begin
        if(RsD == WriteRegM && RegWriteM)
            ForwardAD = 1'b1;
        else
            ForwardAD = 1'b0;
    end

    always @(*) begin
        if(RtD == WriteRegM && RegWriteM)
            ForwardBD = 1'b1;
        else
            ForwardBD = 1'b0;
    end

    always @(*) begin
        if(BranchD && RegWriteE && (WriteRegE == RsD || WriteRegE == RtD)
        || BranchD && MemtoRegM && (WriteRegE == RsD || WriteRegE == RtD))  
            BranchStall = 1'b1;
        else
            BranchStall = 1'b0;
    end

    always @(*) begin
        if((RsD == WriteRegW) && RegWriteW)
            begin
                ForwardAWD = 1'b1;
            end
        else
            begin
                ForwardAWD = 1'b0;
            end
    end

    always @(*) begin
        if((RtD == WriteRegW) && RegWriteW && RegDstD)
            begin
                ForwardBWD = 1'b1;
            end
        else
            begin
                ForwardBWD = 1'b0;
            end
    end


    always @(*) begin
        if(BranchStall || lwStall)
            begin
              FlushE = 1;
              StallD = 0;
              StallF = 0;  
            end
        else
            begin
              FlushE = 0;
              StallD = 1;
              StallF = 1;  
            end

    end


endmodule