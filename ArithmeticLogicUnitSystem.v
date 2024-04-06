`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITU Computer Engineering Department
// Engineer: Emre Safa Yalçın & Emre  Çağrı Dalcı
// Project Name: BLG222E Project 1
//////////////////////////////////////////////////////////////////////////////////

module MUX_2X1(S, I, Y);
    input wire S;
    input wire [15:0] I;
    output reg [7:0] Y;

    always@(*) begin
        case(S)
            1'b0: Y <= I[7:0];
            1'b1: Y <= I[15:8];
            default: Y <= I[7:0];
        endcase
    end
endmodule

module MUX_4X1(S, I0, I1, I2, I3, Y);
    input wire [1:0] S;
    input wire [15:0] I0; 
    input wire [15:0] I1;
    input wire [7:0] I2;
    input wire [7:0] I3;
    output reg [15:0] Y;

    always@(*) begin
        case(S)
            2'b00: Y <= I0;
            2'b01: Y <= I1;
            2'b10: begin
                Y[7:0] <= I2;
                Y[15:8] <= {8{I2[7]}};
                end
            2'b11: begin
                Y[7:0] <= I3;
                Y[15:8] <= {8{I3[7]}};
                end
                
            default: Y <= I0;
        endcase
    end
endmodule

module ArithmeticLogicUnitSystem (
    RF_OutASel, 
    RF_OutBSel, 
    RF_FunSel,
    RF_RegSel,
    RF_ScrSel,
    ALU_WF,
    ALU_FunSel,
    ARF_OutCSel, 
    ARF_OutDSel, 
    ARF_FunSel,
    ARF_RegSel,
    IR_LH,
    IR_Write,
    Mem_WR,
    Mem_CS,
    MuxASel,
    MuxBSel,
    MuxCSel,
    Clock
);
    //RF
    input wire [2:0] RF_OutASel; // OutASel
    input wire [2:0] RF_OutBSel; // OutBSel
    input wire [2:0] RF_FunSel; 
    input wire [3:0] RF_RegSel;
    input wire [3:0] RF_ScrSel;
    wire [15:0] OutA; 
    wire [15:0] OutB;
    //ALU
    input wire ALU_WF;
    input wire [4:0] ALU_FunSel;
    wire [15:0] ALUOut;
    wire [3:0] ALUOutFlag;
    //ARF
    input wire [1:0] ARF_OutCSel; 
    input wire [1:0] ARF_OutDSel; 
    input wire [2:0] ARF_FunSel;
    input wire [2:0] ARF_RegSel;
    wire [15:0] OutC;
    wire [15:0] OutD;
    
    //IR
    input wire IR_LH;
    input wire IR_Write;
    wire [15:0] IROut;

    //Memory
    input wire Mem_WR;
    input wire Mem_CS;
    wire [7:0] MemOut;
    wire [15:0] Address;

    // MUX A
    input wire [1:0] MuxASel;
    wire [15:0] MuxAOut;
    
    //MUX B
    input wire [1:0] MuxBSel;
    wire [15:0] MuxBOut;
    //MUX C
    input wire MuxCSel;
    wire [7:0] MuxCOut;
    
    input wire Clock;
    assign Address = OutD;
    
    Memory MEM(
        .Clock(Clock), 
        .Address(Address), 
        .Data(MuxCOut), 
        .WR(Mem_WR), 
        .CS(Mem_CS), 
        .MemOut(MemOut)
    );

    ArithmeticLogicUnit ALU(
        .A(OutA), 
        .B(OutB), 
        .FunSel(ALU_FunSel),
        .WF(ALU_WF),
        .ALUOut(ALUOut), 
        .FlagsOut(ALUOutFlag),
	.Clock(Clock)
    );
    
    MUX_4X1 MUXA(
        .S(MuxASel), 
        .I0(ALUOut), 
        .I1(OutC), 
        .I2(MemOut), 
        .I3(IROut[7:0]), 
        .Y(MuxAOut)
    );

    MUX_4X1 MUXB(
        .S(MuxBSel), 
        .I0(ALUOut), 
        .I1(OutC), 
        .I2(MemOut), 
        .I3(IROut[7:0]), 
        .Y(MuxBOut)
    );
    MUX_2X1 MUXC(
        .S(MuxCSel), 
        .I(ALUOut),  
        .Y(MuxCOut)
    );
    InstructionRegister IR(
        .Clock(Clock),
        .I(MemOut),
        .Write(IR_Write),
        .LH(IR_LH),
        .IROut(IROut)
    );
    RegisterFile RF(
        .I(MuxAOut), 
        .OutASel(RF_OutASel), 
        .OutBSel(RF_OutBSel), 
        .FunSel(RF_FunSel), 
        .RegSel(RF_RegSel), 
        .ScrSel(RF_ScrSel), 
        .OutA(OutA), 
        .OutB(OutB),
        .Clock(Clock)
    );
    AddressRegisterFile ARF(
        .I(MuxBOut), 
        .OutCSel(ARF_OutCSel), 
        .OutDSel(ARF_OutDSel), 
        .FunSel(ARF_FunSel), 
        .RegSel(ARF_RegSel),
        .OutC(OutC), 
        .OutD(OutD), 
        .Clock(Clock)
    );
endmodule