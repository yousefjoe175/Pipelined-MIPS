module DatapathUnit (
    /* Global inputs */ 
    input   wire                CLK,
    input   wire                RST,
    /* comes from Instruction memory */
    input   wire    [31:0]      Instr,
    /* comes from Data Memory */
    input   wire    [31:0]      MemoryReadData,
    /* comes from Stack */
    input   wire    [31:0]      StackReadData,
    /* comes from control unit */
    input   wire                RegWrite,
    input   wire                MemtoReg,
    input   wire                MemWrite,
    input   wire    [2:0]       ALUControl,
    input   wire                ALUSrc,
    input   wire                RegDst,
    input   wire                Branch,
    input   wire                BranchEq,
    input   wire                BranchNe,
    input   wire                BranchLt,
    input   wire                BranchGt,
    input   wire                Jump,
    input   wire                Link,
    input   wire                JumpReg,
    input   wire                EPCReg,

    input   wire                Push,
    input   wire                Pop,
    input   wire                MemSrc,


    output  wire    [31:0]      InstrD,
    output  wire    [31:0]      PC,
    output  wire    [31:0]      ALUOut,
    output  wire    [31:0]      WriteData,
    output  wire                MemWriteM,                 
    output  wire                PushM,
    output  wire                PopM

);

/* control signals used inside the DU */
wire                RegWriteD;
wire                MemtoRegD;
wire                MemWriteD;
wire    [2:0]       ALUControlD;
wire                ALUSrcD;
wire                RegDstD;
wire                BranchD;
wire                BranchEqD;
wire                BranchNeD;
wire                BranchLtD;
wire                BranchGtD;
wire                JumpD;
wire                LinkD;
wire                JumpRegD;
wire                EPCRegD;
wire                PushD;
wire                PopD;
wire                MemSrcD;
wire                PCSrcEqD;
wire                PCSrcNeD;
wire                PCSrcLtD;
wire                PCSrcGtD;
/* assigned the control signals to the internal wires */
assign  RegWriteD       =   RegWrite;
assign  MemtoRegD       =   MemtoReg;
assign  MemWriteD       =   MemWrite;
assign  ALUControlD     =   ALUControl;
assign  ALUSrcD         =   ALUSrc;
assign  RegDstD         =   RegDst;
assign  BranchD         =   Branch;
assign  BranchEqD       =   BranchEq;
assign  BranchNeD       =   BranchNe;
assign  BranchLtD       =   BranchLt;
assign  BranchGtD       =   BranchGt;
assign  JumpD           =   Jump;
assign  LinkD           =   Link;
assign  JumpRegD        =   JumpReg;
assign  EPCRegD         =   EPCReg;
assign  PushD           =   Push;
assign  PopD            =   Pop;
assign  MemSrcD         =   MemSrc;


/* control signals continuing to EXCUTE stage */
wire    [2:0]       ALUControlE;
wire                RegWriteE;
wire                MemtoRegE;
wire                MemWriteE;
wire                ALUSrcE;
wire                RegDstE;
wire                PushE;
wire                PopE;
wire                MemSrcE;

/* control signals continuing to MEMORY stage */
wire                RegWriteM;
wire                MemtoRegM;
wire                MemSrcM;
//wire                MemWriteM;    we already declared as output port

/* control signals continuing to WRITE BACK stage */
wire                RegWriteW;
wire                MemtoRegW;

/**********************************************************************/
/*
/*                  Exception Handler signals                     
/*
/**********************************************************************/
wire    [31:0]  EPC;
wire    [31:0]  CAUSE;
wire    [31:0]  CAUSE_in;
wire    [31:0]  EXC_Sel;
wire    [31:0]  PC_EXC;
wire    [31:0]  EXC_Address;
wire    [31:0]  PCMin4;
wire    [31:0]  PCPlus4E;
wire            EXC_FlushM;
wire            EXC_FlushE;
wire            EXC_FlushD;
wire            UND;
wire            EPCEnable;
wire            PCXmux;


/**********************************************************************/
/*
/*                  FETCH STAGE signals                     
/*
/**********************************************************************/
wire    [31:0]  PCF;            //the address that is sent to Ins memory
wire    [31:0]  PCPlus4F;       //the next addres connected to ADD4
wire    [31:0]  PCin;           //the input to the Program Counter
                                //after muxing between next ins or branch
wire    [31:0]  PCJin;          //the out of PCin and PCJumpD mux
wire    [31:0]  PCJumpLink;


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
wire    [31:0]  RD1;
wire    [31:0]  RD2;
wire    [15:0]  ImmD;
//fetched from forwarding mux of Write Back 
wire    [31:0]  RD1D;
wire    [31:0]  RD2D;

//fetched from sign extenstion
wire    [31:0]  SignImmD;
//fetched from forwarding muxes
wire    [31:0]  OP1D;
wire    [31:0]  OP2D;
//fetched from CMP 
wire            EqualD;
wire            NotEqualD;
wire            GreatThanD;
wire            lessThanD;

wire            PCSrcD;
wire            PCSrcDin;
wire    [31:0]  PCBranchD;      // the branched address that will be muxed
                                // next address
wire    [31:0]  PCJumpD;
//fetched from IF_ID register
wire    [31:0]  PCPlus4D;
wire    [31:0]  PCLinkD;
wire    [31:0]  PCLinkEPCD;

/**********************************************************************/
/*
/*                  EXECUTE STAGE signals                     
/*
/**********************************************************************/

//fetched from the decode execute register
wire    [31:0]      RD1E;
wire    [31:0]      RD2E;
wire    [4:0]       RsE;
wire    [4:0]       RtE;
wire    [4:0]       RdE;
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
wire                OVFE;


/**********************************************************************/
/*
/*                  MEMORY STAGE signals                     
/*
/**********************************************************************/
//fetched from the execute memory register
wire    [31:0]      ALUOutM;
wire    [31:0]      WriteDataM;
wire    [4:0]       WriteRegM;
wire    [31:0]      ReadDataM;   

/**********************************************************************/
/*
/*                  WRITE BACK STAGE signals                     
/*
/**********************************************************************/
//signals fetched from memory write back register
wire    [31:0]  ReadDataW;
wire    [31:0]  ALUOutW;
wire    [4:0]   WriteRegW;
wire    [31:0]  ResultW;


/**********************************************************************/
/*
/*                  Hazard unit signals            
/*
/**********************************************************************/
wire    [1:0]   ForwardAE;
wire    [1:0]   ForwardBE;
wire            ForwardAD;  //used for OP1 -> Beq
wire            ForwardBD;  
wire            ForwardAWD; //used for RD1D
wire            ForwardBWD;            

wire            HAZ_FlushE;
wire            HAZ_StallD;
wire            HAZ_StallF;

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
.PC_in(PC_EXC),
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

MUX #(.WIDTH(32)) Jump_mux
(
.In1(PCin),
.In2(PCJumpLink),    
.sel(JumpD),       
.Out(PCJin)    
);

/*************************************************/
/************* link mux ************/
MUX #(.WIDTH(32)) Link_mux
(
.In1(PCJumpD),
.In2(PCLinkEPCD),
.sel(JumpRegD),       
.Out(PCJumpLink)    
);


/*************************************************/
/************* EPC mux ************/
MUX #(.WIDTH(32)) EPC_mux
(
.In1(PCLinkD),
.In2(EPC),
.sel(EPCRegD),       
.Out(PCLinkEPCD)    
);


MUX #(.WIDTH(32)) Handler_mux
(
.In1(PCJin),
.In2(EXC_Address),    
.sel(PCXmux),       
.Out(PC_EXC)    
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
.CLR_sync(FlushD),  
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

assign  PCJumpD = {PCPlus4F[31:28],InstrD[25:0],2'b00};


/*******************************************************************/
/******** link register *******************/
Register link_reg (
    .IN(PCPlus4D),
    .CLK(CLK),
    .RST(RST),
    .Enable(LinkD),
    .OUT(PCLinkD)    
);


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
.RD1(RD1),
.RD2(RD2),
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

MUX #(.WIDTH(32)) RD1D_mux
(
.In1(RD1),
.In2(ResultW),      
.sel(ForwardAWD),   
.Out(RD1D)
);

MUX #(.WIDTH(32)) RD2D_mux
(
.In1(RD2),
.In2(ResultW),      
.sel(ForwardBWD),   
.Out(RD2D)
);




CMP #(.WIDTH(32)) Branch_EQ
(
.A(OP1D),
.B(OP2D),
.Eq(EqualD),
.Ne(NotEqualD),
.Gt(GreatThanD),
.Lt(lessThanD)
);


assign PCSrcD   = PCSrcEqD | PCSrcNeD | PCSrcLtD | PCSrcGtD | JumpD;
assign FlushD   = PCSrcD | EXC_FlushD;

assign PCSrcEqD = EqualD     & BranchEqD;
assign PCSrcNeD = NotEqualD  & BranchNeD;
assign PCSrcLtD = lessThanD  & BranchLtD;
assign PCSrcGtD = GreatThanD & BranchGtD; 


/**********************************************************************/
/*
/*                  EXECUTE  STAGE Blocks                    
/*
/**********************************************************************/

assign FlushE = EXC_FlushE | HAZ_FlushE;

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
.PCPlus4D(PCPlus4D),
.RegWriteD(RegWriteD),
.MemtoRegD(MemtoRegD),
.MemWriteD(MemWriteD),
.ALUControlD(ALUControlD),
.ALUSrcD(ALUSrcD),
.RegDstD(RegDstD),
.PushD(PushD),
.PopD(PopD),
.MemSrcD(MemSrcD),
.RD1E(RD1E),
.RD2E(RD2E),
.RsE(RsE),
.RtE(RtE),
.RdE(RdE),
.ImmE(signImmE),
.PCPlus4E(PCPlus4E),
.RegWriteE(RegWriteE),
.MemtoRegE(MemtoRegE),
.MemWriteE(MemWriteE),
.ALUControlE(ALUControlE),
.ALUSrcE(ALUSrcE),
.RegDstE(RegDstE),
.PushE(PushE),
.PopE(PopE),
.MemSrcE(MemSrcE)
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
.sel(ForwardAE),    //ForwardAD will be declared in the hazard unit        
.out(SrcAE)
);

MUX3_1 #(.WIDTH(32)) ForwardB_MUX
(
.A(RD2E),
.B(ALUOutM),        //ALUOutM will be declared in the memory stage
.C(ResultW),        //ResultW will be declared in the write back stage
.sel(ForwardBE),    //ForwardBD will be declared in the hazard unit        
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
.ALUResult(ALUOutE),
.OVF(OVFE)
);

/**********************************************************************/
/*
/*                  MEMORY STAGE Blocks                     
/*
/**********************************************************************/


assign  ALUOut      =   ALUOutM;
assign  WriteData   =   WriteDataM;
//assign  MemWriteM    =   MemWriteM;   MemWriteM is already define as output


MUX #(.WIDTH(32)) MemSrc_mux 
(
.In1(StackReadData),
.In2(MemoryReadData),      
.sel(MemSrcM),    
.Out(ReadDataM)      
);


EX_MEM_reg E_M_reg_mod
(
.CLK(CLK),
.reset(RST),
.CLR_sync(FlushM),
.ALUResultE(ALUOutE),
.WriteDataE(WriteDataE),
.WriteRegE(WriteRegE),
.RegWriteE(RegWriteE),
.MemtoRegE(MemtoRegE),
.MemWriteE(MemWriteE),
.PushE(PushE),
.PopE(PopE),
.MemSrcE(MemSrcE),
.ALUResultM(ALUOutM),
.WriteDataM(WriteDataM),
.WriteRegM(WriteRegM),
.RegWriteM(RegWriteM),
.MemtoRegM(MemtoRegM),
.MemWriteM(MemWriteM),
.PushM(PushM),
.PopM(PopM),
.MemSrcM(MemSrcM)
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
.ReadDataM(ReadDataM),
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
.FlushE(HAZ_FlushE),
.StallD(StallD),
.StallF(StallF),
.WriteRegE(WriteRegE),
.BranchD(BranchD),
.ForwardAD(ForwardAD),
.ForwardBD(ForwardBD),
.RegDstD(RegDstD),
.ForwardAWD(ForwardAWD),
.ForwardBWD(ForwardBWD)
);


/**********************************************************************/
/*
/*                  Exception Handler unit Block            
/*
/**********************************************************************/


EXC_handler EXC
(
.OVF(OVFE),
.UND(UND),
.EPCEnable,
.FlushM(EXC_FlushM),
.FlushE(EXC_FlushE),
.FlushD(EXC_FlushD),
.PCXmux(PCXmux),
.CAUSE(CAUSE_in)
);



CAUSE_Reg cs_reg
(
.CLK(CLK),
.RST(RST),
.EXC(CAUSE_in),
.CAUSE(CAUSE)
);

EPC_register EPC_reg
(
.CLK(CLK),
.RST(RST),
.Enable(EPCEnable),
.PC(PCMin4),
.EPC(EPC)
);

EXC_add EXC_ad
(
.Address(EXC_Address)
);

Adder Pcminus4
(
.A(PCPlus4E),
.B(32'hfffffffc),
.C(PCMin4) 
);



endmodule