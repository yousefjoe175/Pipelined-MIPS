module DatapathUnit (
    /* Global inputs */ 
    input   wire                CLK,
    input   wire                RST,
    /* comes from Instruction memory */
    input   wire    [31:0]      Instr,
    /* comes from Data Memory */
    input   wire    [31:0]      ReadData,
    /* comes from control unit */
    input   wire                RegWrite,
    input   wire                MemtoReg,
    input   wire                MemWrite,
    input   wire    [2:0]       ALUControl,
    input   wire                ALUSrc,
    input   wire                RegDst,
    input   wire                Branch,
    input   wire                Jump,

    output  wire    [31:0]      InstrD,
    output  wire    [31:0]      PC,
    output  wire    [31:0]      ALUOut,
    output  wire    [31:0]      WriteData,
    output  wire                MemWriteM                 

);
/* control signals used inside the DU */
wire                RegWriteD;
wire                MemtoRegD;
wire                MemWriteD;
wire    [2:0]       ALUControlD;
wire                ALUSrcD;
wire                RegDstD;
wire                BranchD;
wire                JumpD;

/* assigned the control signals to the internal wires */
assign  RegWriteD       =   RegWrite;
assign  MemtoRegD       =   MemtoReg;
assign  MemWriteD       =   MemWrite;
assign  ALUControlD     =   ALUControl;
assign  ALUSrcD         =   ALUSrc;
assign  RegDstD         =   RegDst;
assign  BranchD         =   Branch;
assign  JumpD           =   Jump;

/* control signals continuing to EXCUTE stage */
wire    [2:0]       ALUControlE;
wire                RegWriteE;
wire                MemtoRegE;
wire                MemWriteE;
wire                ALUSrcE;
wire                RegDstE;

/* control signals continuing to MEMORY stage */
wire                RegWriteM;
wire                MemtoRegM;
//wire                MemWriteM;    we already declared as output port

/* control signals continuing to WRITE BACK stage */
wire                RegWriteW;
wire                MemtoRegW;

/**********************************************************************/
/*
/*                  FETCH STAGE signals                     
/*
/**********************************************************************/
wire    [31:0]  PCF;            //the address that is sent to Ins memory
wire    [31:0]  PCPlus4F;       //the next addres connected to ADD4
wire    [31:0]  PCin;           //the input to the Program Counter
                                //after muxing between next ins or branch


/**********************************************************************/
/*
/*                  DECODE STAGE signals                     
/*
/**********************************************************************/
//fetched from instruction
wire    [4:0]   RsD;
wire    [4:0]   RtD;
wire    [4:0]   RdD;
//fetched from register file
wire    [31:0]  RD1D;
wire    [31:0]  RD2D;
wire    [15:0]  ImmD;
//fetched from sign extenstion
wire    [31:0]  SignImmD;
//fetched from forwarding muxes
wire    [31:0]  OP1D;
wire    [31:0]  OP2D;
//fetched from CMP 
wire            EqualD;

wire            PCSrcD;
wire    [31:0]  PCBranchD;      // the branched address that will be muxed
                                // next address
//fetched from IF_ID register
wire    [31:0]  PCPlus4D;

/**********************************************************************/
/*
/*                  EXECUTE STAGE signals                     
/*
/**********************************************************************/

//fetched from the decode execute register
wire    [31:0]      RD1E;
wire    [31:0]      RD2E;
wire    [5:0]       RsE;
wire    [5:0]       RtE;
wire    [5:0]       RdE;
wire    [31:0]      signImmE;
//coming out of RegDst mux
wire    [4:0]       WriteRegE;
//coming from forwardB mux 3X1
wire    [31:0]      WriteDataE;
//coming from SrcB mux 2X1
wire    [31:0]      SrcBE;
//coming from forwardA mux 3X1
wire    [31:0]      SrcAE;
//coming from ALU
wire    [31:0]      ALUOutE;

/**********************************************************************/
/*
/*                  MEMORY STAGE signals                     
/*
/**********************************************************************/
//fetched from the execute memory register
wire    [31:0]      ALUOutM;
wire    [31:0]      WriteDataM;
wire    [4:0]       WriteRegM;

/**********************************************************************/
/*
/*                  WRITE BACK STAGE signals                     
/*
/**********************************************************************/
//signals fetched from memory write back register
wire    [31:0]  ReadDataW;
wire    [31:0]  ALUOutW;
wire    [5:0]   WriteRegW;
wire    [31:0]  ResultW;


/**********************************************************************/
/*
/*                  Hazard unit signals            
/*
/**********************************************************************/
wire    [1:0]   ForwardAE;
wire    [1:0]   ForwardBE;
wire    [1:0]   ForwardAD;
wire    [1:0]   ForwardBD;

wire            FlushE;
wire            StallD;
wire            StallF;

/**********************************************************************/
/*
/*                  FETCH STAGE Blocks
/*
/**********************************************************************/

assign  PC  =   PCF;

ProgramCounter PC_reg
(
.CLK(CLK),
.reset(RST),
.Enable(StallF),
.PC_in(PCin),
.PC(PCF)   
);

Adder ADD4 
(
    .A(PCF),
    .B(32'd4),
    .C(PCPlus4F)
);

MUX #(.WIDTH(32)) Branch_mux
(
.In1(PCPlus4F),
.In2(PCBranchD),    //PCBranchD will be declared in Decoder stage
.sel(PCSrcD),       //PCSrcD will be declared in Decoder stage
.Out(PCin)    
);
/**********************************************************************/
/*
/*                  DECODE STAGE Blocks                     
/*
/**********************************************************************/


/*  IF_ID register between fetch and decode stage */
IF_ID_reg F_D_reg_mod 
(
.CLK(CLK),
.reset(RST),
.CLR_sync(PCSrcD),  
.Enable(StallD),
.InstrF(Instr),
.PCPlus4F(PCPlus4F),
.InstrD(InstrD),        
.PCPlus4D(PCPlus4D)
);

assign  RsD     =   InstrD[25:21];
assign  RtD     =   InstrD[20:16];
assign  RdD     =   InstrD[15:11];
assign  ImmD    =   InstrD[15:0];

SignExtend Sign0 (
    .Inst(ImmD),
    .SignImm(SignImmD)
);

Adder ADDBranch
(
    .A(SignImmD<<2),
    .B(PCPlus4D),
    .C(PCBranchD)
);


Register_file RF0 
(
.RD1(RD1D),
.RD2(RD2D),
.WE3(RegWriteW),
.A1(RsD),
.A2(RtD),
.A3(WriteRegW), //WriteRegW will be decalred in the write back stage
.CLK(CLK),
.WD3(ResultW),  //ResultW will be declared in the write back stage
.reset(RST)
);


MUX #(.WIDTH(32)) OP1_mux
(
.In1(RD1D),
.In2(ALUOutM),      //ALUOutM will be declared in the memory stage
.sel(ForwardAD),    //ForwardAD will be declared in the hazard unit
.Out(OP1D)
);

MUX #(.WIDTH(32)) OP2_mux
(
.In1(RD2D),
.In2(ALUOutM),      //ALUOutM will be declared in the memory stage
.sel(ForwardBD),    //ForwardBD will be declared in the hazard unit        
.Out(OP2D)      
);

CMP #(.WIDTH(32)) Branch_EQ
(
.A(OP1D),
.B(OP2D),
.cmp(EqualD)
);

assign PCSrcD = EqualD & BranchD;


/**********************************************************************/
/*
/*                  EXECUTE  STAGE Blocks                    
/*
/**********************************************************************/


ID_EX_reg D_E_reg_mod
(
.CLK(CLK),
.reset(RST),
.CLR_sync(FlushE),  //FlushE will be declared later in hazard unit
.RD1D(RD1D),
.RD2D(RD2D),
.RsD(RsD),
.RtD(RtD),
.RdD(RdD),
.ImmD(SignImmD),
.RegWriteD(RegWriteD),
.MemtoRegD(MemtoRegD),
.MemWriteD(MemWriteD),
.ALUControlD(ALUControlD),
.ALUSrcD(ALUSrcD),
.RegDstD(RegDstD),
.RD1E(RD1E),
.RD2E(RD2E),
.RsE(RsE),
.RtE(RtE),
.RdE(RdE),
.ImmE(signImmE),
.RegWriteE(RegWriteE),
.MemtoRegE(MemtoRegE),
.MemWriteE(MemWriteE),
.ALUControlE(ALUControlE),
.ALUSrcE(ALUSrcE),
.RegDstE(RegDstE)
);

// mux to choose between Rt or Rd as second operand
MUX #(.WIDTH(5)) RegDst_mux 
(
.In1(RtE),
.In2(RdE),      //ALUOutM will be declared in the memory stage
.sel(RegDstE),    //ForwardBD will be declared in the hazard unit        
.Out(WriteRegE)      
);


MUX3_1 #(.WIDTH(32)) ForwardA_MUX
(
.A(RD1E),
.B(ALUOutM),        //ALUOutM will be declared in the memory stage
.C(ResultW),        //ResultW will be declared in the write back stage
.sel(ForwardAD),    //ForwardAD will be declared in the hazard unit        
.out(SrcAE)
);

MUX3_1 #(.WIDTH(32)) ForwardB_MUX
(
.A(RD2E),
.B(ALUOutM),        //ALUOutM will be declared in the memory stage
.C(ResultW),        //ResultW will be declared in the write back stage
.sel(ForwardBD),    //ForwardBD will be declared in the hazard unit        
.out(WriteDataE)    
);

// mux to choose between RD2 or immediate value
MUX #(.WIDTH(32)) ALUSrc_mux 
(
.In1(WriteDataE),
.In2(signImmE),      
.sel(ALUSrcE),    
.Out(SrcBE)      
);


ALU ALU_mod
(
.SrcA(SrcAE),
.SrcB(SrcBE),
.ALUControl(ALUControlE),
.ALUResult(ALUOutE)
);

/**********************************************************************/
/*
/*                  MEMORY STAGE Blocks                     
/*
/**********************************************************************/


assign  ALUOut      =   ALUOutM;
assign  WriteData   =   WriteDataM;
//assign  MemWriteM    =   MemWriteM;   MemWriteM is already define as output


EX_MEM_reg E_M_reg_mod
(
.CLK(CLK),
.reset(RST),
.ALUResultE(ALUOutE),
.WriteDataE(WriteDataE),
.WriteRegE(WriteRegE),
.RegWriteE(RegWriteE),
.MemtoRegE(MemtoRegE),
.MemWriteE(MemWriteE),
.ALUResultM(ALUOutM),
.WriteDataM(WriteDataM),
.WriteRegM(WriteRegM),
.RegWriteM(RegWriteM),
.MemtoRegM(MemtoRegM),
.MemWriteM(MemWriteM)
);

/**********************************************************************/
/*
/*                  WRITE BACK STAGE Blocks                    
/*
/**********************************************************************/

MEM_WB_reg  M_W_reg_mod
(
.CLK(CLK),
.reset(RST),
.ALUResultM(ALUOutM),
.ReadDataM(ReadData),
.WriteRegM(WriteRegM),
.RegWriteM(RegWriteM),
.MemtoRegM(MemtoRegM),
.ALUResultW(ALUOutW),
.ReadDataW(ReadDataW),
.WriteRegW(WriteRegW),
.RegWriteW(RegWriteW),
.MemtoRegW(MemtoRegW)
);

// mux to choose between data from memory or from ALU
MUX #(.WIDTH(32)) MemToReg_mux 
(
.In2(ReadDataW),
.In1(ALUOutW),      
.sel(MemtoRegW),    
.Out(ResultW)      
);

/**********************************************************************/
/*
/*                  Hazard unit Block            
/*
/**********************************************************************/

Hazard_Unit H0
(
.RsE(RsE),
.RtE(RtE),
.WriteRegM(WriteRegM),
.RegWriteM(RegWriteM),
.WriteRegW(WriteRegW),
.RegWriteW(RegWriteW),
.ForwardAE(ForwardAE),
.ForwardBE(ForwardBE),
.RegWriteE(RegWriteE),
.ALUSrcE(ALUSrcE),
.MemtoRegE(MemtoRegE),
.MemtoRegM(MemtoRegM),
.RsD(RsD),
.RtD(RtD),
.FlushE(FlushE),
.StallD(StallD),
.StallF(StallF),
.WriteRegE(WriteRegE),
.BranchD(BranchD),
.ForwardAD(ForwardAD),
.ForwardBD(ForwardBD)
);



endmodule