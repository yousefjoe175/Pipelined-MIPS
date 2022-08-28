module MIPS(
    input   wire                CLK,
    input   wire                RST,
    output  wire     [15:0]     test_value 
);
    wire    [31:0]  Instr;
    wire    [31:0]  InstrD;
    wire    [31:0]  MemoryReadData;
    wire    [31:0]  StackReadData;
    wire            RegWrite;
    wire            MemtoReg;
    wire            MemWrite;
    wire    [2:0]   ALUControl;
    wire            ALUSrc;
    wire            RegDst;
    wire            Branch;
    wire            Jump;
    
    wire            Push;
    wire            Pop;
    wire            MemSrc;
    
    


    wire    [31:0]  PC;
    wire    [31:0]  ALUOut;
    wire    [31:0]  WriteData;
    wire            MemWriteM;
    wire            PushM;
    wire            PopM;


    wire            FULL;
    wire            EMPTY;
    wire    [5:0]   SP;

    ControlUnit C1
    (
        .Instruction(InstrD),
        .RST(RST),
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .Branch(Branch),
        .Jump(Jump),
        .Push(Push),
        .Pop(Pop),
        .MemSrc(MemSrc)
    );




    DatapathUnit D1 
    (
        .CLK(CLK),
        .RST(RST),
        .Instr(Instr),
        .MemoryReadData(MemoryReadData),
        .StackReadData(StackReadData),
        .Push(Push),
        .Pop(Pop),
        .MemSrc(MemSrc),
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .Branch(Branch),
        .Jump(Jump),
        .InstrD(InstrD),
        .PC(PC),
        .ALUOut(ALUOut),
        .WriteData(WriteData),
        .MemWriteM(MemWriteM),
        .PushM(PushM),
        .PopM(PopM)
    );

    data_memory M1 
    (
        .A(ALUOut),          
        .WD(WriteData),
        .CLK(CLK),
        .reset(RST),
        .WE(MemWriteM),
        .RD(ReadData),
        .test_value(test_value)
    );

    Ins_memory M2(
        .Instruction(Instr),
        .PC(PC)
    );

//module STACK #(
//    parameter STK_WIDTH = 32, 
//    parameter PTR_WIDTH = 6
//) (
//    input   wire                            CLK     ,
//    input   wire                            RST     ,
//    input   wire                            PUSH    ,
//    input   wire                            POP     ,    
//    input   wire    [STK_WIDTH - 1 : 0]     Data_in ,
//    output  wire                            FULL    ,
//    output  wire                            EMPTY   ,
//    output  reg     [PTR_WIDTH - 1 : 0]     SP      ,
//    output  reg     [STK_WIDTH - 1 : 0]     Data_out
//);


STACK STK_WIDTH
(
.CLK(CLK)     ,
.RST(RST)     ,
.PUSH(PushM)    ,
.POP(PopM)     ,
.Data_in(WriteData),
.FULL(FULL)    ,
.EMPTY(EMPTY)   ,
.SP(SP)      ,
.Data_out(StackReadData)
);

endmodule