module MIPS(
    input   wire                CLK,
    input   wire                RST,
    output  wire     [15:0]     test_value 
);
    wire    [31:0]  Instr;
    wire    [31:0]  InstrD;
    wire    [31:0]  ReadData;
    wire            RegWrite;
    wire            MemtoReg;
    wire            MemWrite;
    wire    [2:0]   ALUControl;
    wire            ALUSrc;
    wire            RegDst;
    wire            Branch;
    wire            Jump;
    wire    [31:0]  PC;
    wire    [31:0]  ALUOut;
    wire    [31:0]  WriteData;
    wire            MemWriteM;



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
        .Jump(Jump)
    );




    DatapathUnit D1 
    (
        .CLK(CLK),
        .RST(RST),
        .Instr(Instr),
        .ReadData(ReadData),
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
        .MemWriteM(MemWriteM)
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



endmodule