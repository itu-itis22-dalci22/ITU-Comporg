`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITU Computer Engineering Department
// Engineer: Emre Safa Yalçın & Emre  Çağrı Dalcı
// Project Name: BLG222E Project 1
//////////////////////////////////////////////////////////////////////////////////


module ArithmeticLogicUnit(A, B, FunSel, WF, ALUOut, FlagsOut, Clock);
    input [15:0] A;
    input [15:0] B;
    input wire [4:0] FunSel;
    input wire WF;
    input wire Clock;
    output reg [15:0] ALUOut;
    output reg [3:0] FlagsOut;
    reg Z = 0;
    reg C = 0;
    reg C_temp = 0;
    reg N = 0;
    reg O = 0;
    reg O_temp = 0;
    
    always @(*) begin
        if (FunSel[4] == 0) begin  
	    // 8 Bit Operations     
            case (FunSel[3:0])
                4'b0000: // ALUOut = A
                    begin
                        ALUOut[7:0] = A[7:0];
                    end
                4'b0001: // ALUOut = B
                    begin
                        ALUOut[7:0] = B[7:0];
                    end
                4'b0010: // ALUOut = Not A
                    begin
                        ALUOut[7:0] = ~A[7:0];
                    end
                4'b0011: // ALUOut = Not B
                    begin
                        ALUOut[7:0] = ~B[7:0];
                    end
                4'b0100: // ALUOut = A + B
                    begin
                        O_temp = 0;
                        {C_temp, ALUOut[7:0]} = {1'b0, A[7:0]} + {1'b0, B[7:0]};

                        if ((A[7] == B[7]) && (B[7] != ALUOut[7])) begin
                            O_temp = 1;
                        end         
                    end
                4'b0101: // ALUOut = A + B + Carry
                    begin
                        O_temp = 0;
                        {C_temp, ALUOut[7:0]} = {1'b0, A[7:0]} + {1'b0, B[7:0]} + {8'd0, C};

                        if ((A[7] == B[7]) && (B[7] != ALUOut[7])) begin
                            O_temp = 1;
                        end
                    end
                4'b0110: // ALUOut = A - B
                    begin
                        O_temp = 0;
                        {C_temp, ALUOut[7:0]} = {1'b0, A[7:0]} + {1'b0, (~B[7:0] + 8'd1)};

                        if ((B[7] == ALUOut[7]) && (B[7] != A[7])) begin
                            O_temp = 1;
                        end
                    end
                4'b0111: // ALUOut = A AND B
                    begin
                        ALUOut[7:0] = A[7:0] & B[7:0];
                    end
                4'b1000: // ALUOut = A OR B
                    begin
                        ALUOut[7:0] = A[7:0] | B[7:0];
                    end
                4'b1001: // ALUOut = A XOR B
                    begin
                        ALUOut[7:0] = A[7:0] ^ B[7:0];
                    end
                4'b1010: // ALUOut = A NAND B
                    begin
                        ALUOut[7:0] = ~(A[7:0] & B[7:0]);
                    end
                4'b1011: // ALUOut = LSL A
                    begin
                        C_temp = A[7];
                        ALUOut[7:0] = A[7:0] << 1;
                    end
                4'b1100: // ALUOut = LSR A
                    begin
                        C_temp = A[0];
                        ALUOut[7:0] = A[7:0] >> 1;
                    end
                4'b1101: // ALUOut = ASR A
                    begin
                        ALUOut[7:0] = A[7:0];
                        ALUOut = ALUOut >> 1;
                        ALUOut[7] = ALUOut[6];
                    end
                4'b1110: // ALUOut = CSL A
                    begin
                        ALUOut = {A[6:0],C};
                        C = A[7];
                    end
                4'b1111: // ALUOut = CSR A
                    begin
                        ALUOut = {C, A[7:1]};
                        C = A[0];
                    end
                default: // Return A
                    begin
                        ALUOut = A[7:0];
                    end
            endcase
              
            ALUOut[15:8] <= {8{ALUOut[7]}};
              
        end    
          
          //  16 Bit Operations
          else begin
            case (FunSel[3:0])
                4'b0000: // ALUOut = A
                        begin
                            ALUOut = A;

                        end
                4'b0001: // ALUOut = B
                        begin
                            ALUOut = B;
                        end
                4'b0010: // ALUOut = Not A
                        begin
                            ALUOut = ~A;
                        end
                4'b0011: // ALUOut = Not B
                        begin
                            ALUOut = ~B;
                        end
                4'b0100: // ALUOut = A + B
                        begin
                            O_temp = 0;
                            {C_temp, ALUOut} = {1'b0, A} + {1'b0, B};

                            if ((A[15] == B[15]) && (B[15] != ALUOut[15])) begin
                                O_temp = 1;
                            end
                        end
                4'b0101: // ALUOut = A + B + Carry
                        begin
                            O_temp = 0;
                            {C_temp, ALUOut} = {1'b0, A} + {1'b0, B} + {16'd0, C};

                            if ((A[15] == B[15]) && (B[15] != ALUOut[15])) begin
                                O_temp = 1;
                            end
                        end         
                4'b0110: // ALUOut = A - B
                        begin
                            O_temp = 0;
                            {C_temp, ALUOut} = {1'b0, A} + {1'b0, (~B + 16'd1)};

                            if ((B[15] == ALUOut[15]) && (B[15] != A[15])) begin
                                O = 1;
                            end
                        end
                4'b0111: // ALUOut = A AND B
                        begin
                            ALUOut = A & B;
                        end
                4'b1000: // ALUOut = A OR B
                        begin
                            ALUOut = A | B;
                        end
                4'b1001: // ALUOut = A XOR B
                        begin
                            ALUOut = A ^ B;
                        end
                4'b1010: // ALUOut = A NAND B
                        begin
                            ALUOut = ~(A & B);
                        end
                4'b1011: // ALUOut = LSL A
                        begin
                            C_temp = A[15];
                            ALUOut = A << 1;
                        end

                4'b1100: // ALUOut = LSR A
                        begin
                            C_temp = A[0];
                            ALUOut = A >> 1;
                        end
                4'b1101: // ALUOut = ASR A
                        begin
                            ALUOut = A >>> 1;
                        end
                4'b1110: // ALUOut = CSL A
                        begin
                            ALUOut = {A[14:0],A[15]};
                            C_temp = A[15];
                        end
                4'b1111: // ALUOut = CSR A
                        begin
                            ALUOut = {A[0], A[15:1]};
                            C_temp = A[0];
                        end
                
                default: // Return A
                        begin
                            ALUOut = A;
                        end
                
              endcase
            end
      end

	always @(posedge Clock) begin
	    if (WF) begin 
	        if (ALUOut[15] == 1) begin // Negative
                    N = 1;
                end else begin
                    N = 0;
                end
                
	   	if (ALUOut == 16'd0) begin // Zero
                    Z = 1;
                end else begin
                    Z = 0;
                end
	   	C = C_temp;
	   	O = O_temp;
	    	FlagsOut <= {Z,C,N,O};
	    end
        end

endmodule