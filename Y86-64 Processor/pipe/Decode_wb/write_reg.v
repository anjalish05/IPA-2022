module WRITE_REG(clk,W_stall,m_stat,M_icode,M_valE,m_valM,M_dstE,M_dstM,W_stat,W_icode,W_valE,W_valM,W_dstE,W_dstM);

input clk;
input W_stall;
input [2:0]m_stat;
input [3:0]M_icode; 
input [63:0]m_valM; 
input [63:0]M_valE;
input [3:0]M_dstE;
input [3:0]M_dstM;

output reg [2:0] W_stat;
output reg [3:0] W_icode; 
output reg [3:0] W_dstE;
output reg [3:0] W_dstM;
output reg [63:0] W_valE;
output reg [63:0] W_valM;


always @(posedge(clk)) begin

	case (W_stall)
		4'h1: begin
			W_stat <= W_stat;
			W_icode <= W_icode;
			W_valE <= W_valE;
			W_valM <= W_valM;
			W_dstE <= W_dstE;
			W_dstM <= W_dstM;
		end
		default: begin
			W_stat <= m_stat;
			W_icode <= M_icode;
			W_valE <= M_valE;
			W_valM <= m_valM;
			W_dstE <= M_dstE;
			W_dstM <= M_dstM;
		end
	endcase
	
end

endmodule
