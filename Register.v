`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITU Computer Engineering Department
// Engineer: Emre Safa Yalçın & Emre  Çağrı Dalcı
// Project Name: BLG222E Project 1
//////////////////////////////////////////////////////////////////////////////////


module Register(Clock,I,FunSel,E,Q);

    input wire [15:0] I;
    input wire [2:0] FunSel;
    input wire E;
    input wire Clock;
    output reg [15:0] Q;
    always @(posedge Clock)
        begin
        if(E)
        begin
            case(FunSel)
                3'b000   :   Q <= Q - {{15{1'b0}},1'b1};
                3'b001   :   Q <= Q + {{15{1'b0}},1'b1};
                3'b010   :   Q <= I[15:0];
                3'b011   :   Q <= {16{1'b0}};
                3'b100   :   begin
                             Q[15:8] <= 8'b0;
                             Q[7:0] <= I[7:0];
                             end
                3'b101   :   Q[7:0] <= I[7:0];
                3'b110   :   Q[15:8] <= I[7:0];
                3'b111   :   begin
                             Q[15:8] <= {8{I[7]}};
                             Q[7:0] <= I[7:0];
                             end
            default     :   Q <= Q;
            endcase
        end 
        else
        begin
        Q<=Q;
        end
        end
endmodule
