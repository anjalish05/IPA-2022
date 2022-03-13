module EXECUTE_REG(clk,E_bubble,D_stat,D_icode,D_ifun,D_valC,d_valA,
d_valB,d_dstE,d_dstM,d_srcA,d_srcB,
E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,
E_srcA,E_srcB);

input clk;
input E_bubble;
input [2:0]D_stat;
input [3:0]D_icode; 
input [3:0]D_ifun; 
input [3:0]d_dstE;
input [3:0]d_dstM;
input [3:0]d_srcA;
input [3:0]d_srcB;
input [63:0]d_valA;
input [63:0]d_valB;
input [63:0]D_valC;


output reg [2:0] E_stat;
output reg [3:0] E_icode; 
output reg [3:0] E_ifun;
output reg [3:0]E_dstE;
output reg [3:0]E_dstM;;
output reg [3:0]E_srcA;
output reg [3:0]E_srcB;
output reg [63:0]E_valC;
output reg [63:0]E_valA;
output reg [63:0]E_valB;


always @(posedge(clk)) begin
	
	case (E_bubble)
		4'h1:begin
			E_icode <= 4'h1;
			E_ifun <= 4'h0;
		end
		default:begin
			E_stat <= D_stat;
			E_icode <= D_icode;
			E_ifun <= D_ifun;
			E_valC <= D_valC;
			E_valA <= d_valA;
			E_valB <= d_valB;
			E_dstE <= d_dstE;
			E_dstM <= d_dstM;
			E_srcA <= d_srcA;
			E_srcB <= d_srcB;
		end
	endcase

end



endmodule