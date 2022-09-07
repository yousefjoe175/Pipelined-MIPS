module ControlUnit
(
    input   wire    [31:0]  Instruction,
    input   wire            RST,

    /*Stach signals */
    output  reg             Push,
    output  reg             Pop,
    output  reg             MemSrc,
/**********************/
    output  reg             RegWrite,
    output  reg             MemtoReg,
    output  reg             MemWrite,
    output  reg     [2:0]   ALUControl,
    output  reg             ALUSrc,
    output  reg             RegDst,
    output  reg             Branch,
    output  reg             BranchEq,
    output  reg             BranchNe,
    output  reg             BranchLt,
    output  reg             BranchGt,
    output  reg             Jump,
    output  reg             Link,
    output  reg             JumpReg,
    output  reg             EPCReg
);

    localparam  rType           = 6'b00_0000;
    localparam  loadWord        = 6'b10_0011;
    localparam  storeWord       = 6'b10_1011;
    localparam  addImmediate    = 6'b00_1000;
    localparam  orImmediate     = 6'b00_1100;
    localparam  loadUpperImm    = 6'b00_1001;
    localparam  branchIfEqual   = 6'b00_0100;
    localparam  branchNotEqual  = 6'b00_0101;
    localparam  branchLessThan  = 6'b00_0110;
    localparam  branchGreatThan = 6'b00_0111;
    localparam  jump_inst       = 6'b00_0010;
    localparam  pushStack       = 6'b10_0000;
    localparam  popStack        = 6'b10_1000;
    localparam  jump_link       = 6'b00_0011;
    localparam  jump_register   = 6'b00_0001;
    localparam  jump_EPC        = 6'b01_0001;

    localparam  AND =   6'b10_0100;
    localparam  OR  =   6'b10_0101;
    localparam  ADD =   6'b10_0000;
    localparam  SUB =   6'b10_0010;
    localparam  SLT =   6'b10_1010;
    localparam  MUL =   6'b01_1100;
    localparam  LU  =   6'b10_0001;


    localparam ALU_AND  = 3'b000;
    localparam ALU_OR   = 3'b001;
    localparam ALU_PLS  = 3'b010;
    localparam ALU_MIN  = 3'b100;
    localparam ALU_MUL  = 3'b101;
    localparam ALU_SLT  = 3'b110;
    localparam ALU_LU   = 3'b111;


    reg     [2:0]   ALUOp;
    wire    [5:0]   OpCode;
    wire    [5:0]   Funct;

    

    assign  OpCode  =   Instruction [31 : 26];
    assign  Funct   =   Instruction [5 : 0];

    
    always @(*) begin
        Branch  =   BranchEq | BranchNe | BranchLt | BranchGt;
    end

    always @(*) 
        begin
            if(Instruction == 0)
                begin
                    Jump        =   1'b0; 
                    ALUOp       =   2'b00;
                    MemWrite    =   1'b0;
                    RegWrite    =   1'b0;
                    RegDst      =   1'b0;
                    ALUSrc      =   1'b0;
                    MemtoReg    =   1'b0;
                    BranchEq    =   1'b0;
                    BranchNe    =   1'b0;
                    BranchLt    =   1'b0;
                    BranchGt    =   1'b0;
                    Push        =   1'b0;
                    Pop         =   1'b0;
                    MemSrc      =   1'b0;
                    Link        =   1'b0;
                    JumpReg     =   1'b0;
                    EPCReg      =   1'b0;
                end
            else begin
                case (OpCode)
                    rType :
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   2'b10;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b1;
                            RegDst      =   1'b1;
                            ALUSrc      =   1'b0;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    loadWord :
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   2'b00;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b1;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b1;
                            MemtoReg    =   1'b1;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b1;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    pushStack:
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   2'b00;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b1;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b1;
                            MemtoReg    =   1'b1;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b1;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    storeWord :
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   2'b00;
                            MemWrite    =   1'b1;
                            RegWrite    =   1'b0;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b1;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    popStack:
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   2'b00;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b0;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b1;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b1;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    addImmediate :
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   2'b00;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b1;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b1;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    orImmediate :
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   2'b11;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b1;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b1;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    loadUpperImm :
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   3'b100;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b1;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b1;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    branchIfEqual :
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   2'b01;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b0;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b0;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b1;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    branchNotEqual :
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   2'b01;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b0;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b0;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b1;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    branchLessThan :
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   2'b01;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b0;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b0;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b1;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    branchGreatThan :
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   2'b01;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b0;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b0;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b1;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    jump_inst :
                        begin
                            Jump        =   1'b1; 
                            ALUOp       =   2'b00;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b0;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b0;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    jump_link :
                        begin
                            Jump        =   1'b1; 
                            ALUOp       =   2'b00;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b0;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b0;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b1;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end
                    jump_register :
                        begin
                            Jump        =   1'b1; 
                            ALUOp       =   2'b00;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b0;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b0;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b1;
                            EPCReg      =   1'b0;
                        end
                    jump_EPC :
                        begin
                            Jump        =   1'b1; 
                            ALUOp       =   2'b00;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b0;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b0;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b1;
                            EPCReg      =   1'b1;
                        end
                    default : 
                        begin
                            Jump        =   1'b0; 
                            ALUOp       =   2'b00;
                            MemWrite    =   1'b0;
                            RegWrite    =   1'b0;
                            RegDst      =   1'b0;
                            ALUSrc      =   1'b0;
                            MemtoReg    =   1'b0;
                            BranchEq    =   1'b0;
                            BranchNe    =   1'b0;
                            BranchLt    =   1'b0;
                            BranchGt    =   1'b0;
                            Push        =   1'b0;
                            Pop         =   1'b0;
                            MemSrc      =   1'b0;
                            Link        =   1'b0;
                            JumpReg     =   1'b0;
                            EPCReg      =   1'b0;
                        end  
                endcase
            end
            
        end
    
    always @(*) 
        begin
           case (ALUOp)
               3'b000    :   ALUControl  =   ALU_PLS;
               3'b001    :   ALUControl  =   ALU_MIN; 
               3'b010    :   
                    begin       //adding the reset of ALU control signals
                        case (Funct)
                            AND :       ALUControl  =  ALU_AND  ;
                            OR  :       ALUControl  =  ALU_OR   ;
                            ADD :       ALUControl  =  ALU_PLS  ;
                            SUB :       ALUControl  =  ALU_MIN  ;
                            SLT :       ALUControl  =  ALU_SLT  ;
                            MUL :       ALUControl  =  ALU_MUL  ;
                            LU  :       ALUControl  =  ALU_LU   ;
                            default:    ALUControl  =  ALU_PLS  ;
                        endcase
                    end
                3'b011  :   ALUControl  =   ALU_OR;
                3'b100  :   ALUControl  =   ALU_LU;
               default  :   ALUControl  =   ALU_PLS;
           endcase  
        end
    


endmodule

   