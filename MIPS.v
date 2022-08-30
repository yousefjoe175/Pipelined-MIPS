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
    wire            BranchEq;
    wire            BranchNe;
    wire            BranchLt;
    wire            BranchGt;
    wire            Jump;
    wire            Link;
    wire            JumpReg;
    
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
        .BranchEq(BranchEq),
        .BranchNe(BranchNe),
        .BranchLt(BranchLt),
        .BranchGt(BranchGt),
        .Jump(Jump),
        .Push(Push),
        .Pop(Pop),
        .MemSrc(MemSrc),
        .Link(Link),
        .JumpReg(JumpReg)
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
        .BranchEq(BranchEq),
        .BranchNe(BranchNe),
        .BranchLt(BranchLt),
        .BranchGt(BranchGt),        
        .Jump(Jump),
        .Link(Link),
        .JumpReg(JumpReg),
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