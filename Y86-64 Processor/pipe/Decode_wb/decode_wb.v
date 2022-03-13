`timescale 1ns/1ps


module registerfile(clk, W_dstE, W_dstM, d_srcA, d_srcB, W_valE, W_valM, d_rvalA, d_rvalB);

input [3:0]W_dstE;
input [3:0]W_dstM;
input [3:0]d_srcA;
input [3:0]d_srcB;
input clk;
input [63:0] W_valE;
input [63:0] W_valM;

output reg[63:0] d_rvalA;
output reg[63:0] d_rvalB;


reg [63:0] register_file[14:0];

parameter rax = 4'h0 ;
parameter rcx = 4'h1 ;
parameter rdx = 4'h2 ;
parameter rbx = 4'h3 ;
parameter rsp = 4'h4 ;
parameter rbp = 4'h5 ;
parameter rsi = 4'h6 ;
parameter rdi = 4'h7 ;
parameter r8 = 4'h8 ;
parameter r9 = 4'h9 ;
parameter r10 = 4'hA ;
parameter r11 = 4'hB;
parameter r12 = 4'hC ;
parameter r13 = 4'hD;
parameter r14 = 4'hE ;
parameter rnone = 4'hF ;

initial
begin
register_file[4'h0] <= 64'h0;
register_file[4'h1] <= 64'h0;
register_file[4'h2] <= 64'h0;
register_file[4'h3] <= 64'h0;
register_file[4'h4] <= 64'h0;
register_file[4'h5] <= 64'h0;
register_file[4'h6] <= 64'h0;
register_file[4'h7] <= 64'h0;
register_file[4'h8] <= 64'h0;
register_file[4'h9] <= 64'h0;
register_file[4'hA] <= 64'h0;
register_file[4'hB] <= 64'h0;
register_file[4'hC] <= 64'h0;
register_file[4'hD] <= 64'h0;
register_file[4'hE] <= 64'h0;
end


always @(*) begin

	if (d_srcA != rnone) begin
		d_rvalA <= register_file[d_srcA];
		
	end

	if (d_srcB != rnone) begin
		d_rvalB <= register_file[d_srcB];
		
	end
	
end

always @(posedge(clk)) begin

	if(W_dstE != rnone) begin
		register_file[W_dstE] <= W_valE;
	end

	if(W_dstM != rnone) begin
		register_file[W_dstM] <= W_valM;
	end
	
end


endmodule

module WRITE_STAT(W_stat, stat);

input [2:0] W_stat;
output reg[2:0] stat;

parameter SBUB = 3'h0;
parameter SAOK = 3'h1;
parameter SHLT = 3'h2;
parameter SADR = 3'h3;
parameter SINS = 3'h4;

always @(*) begin
	case (W_stat)
		SBUB:
			stat <= SAOK; 
		default: stat <= W_stat;
	endcase
	
end

endmodule

module d_VALA_logic(
	input [3:0] D_icode,
	input [63:0] d_rvalA,
	input [63:0] D_valP,
	input [3:0] d_srcA,
	input [3:0] e_dstE,
	input [3:0] M_dstM,
	input [3:0] M_dstE,
	input [3:0] W_dstM,
	input [3:0] W_dstE,
	input [63:0] e_valE,
	input [63:0] m_valM,
	input [63:0] M_valE,
	input [63:0] W_valM,
	input [63:0] W_valE,
	output reg [63:0] d_valA  );

always @(*) begin
	
	if(D_icode == 4'h8 || D_icode == 4'h7)begin
		 d_valA <=D_valP;
	end
	else begin
		
		case (d_srcA)

		e_dstE:
			d_valA <= e_valE;
		M_dstM:
			d_valA <= m_valM;
		M_dstE:
			d_valA <= M_valE;
		W_dstM:
			d_valA <= W_valM;
		W_dstE:
			d_valA <= W_valE;
			default: d_valA <=d_rvalA;
		endcase
	end

end

endmodule


module d_VALB_logic(	
	input [63:0] d_rvalB,
	input [63:0] D_valP,
	input [3:0] d_srcB,
	input [3:0] e_dstE,
	input [3:0] M_dstM,
	input [3:0] M_dstE,
	input [3:0] W_dstM,
	input [3:0] W_dstE,
	input [63:0] e_valE,
	input [63:0] m_valM,
	input [63:0] M_valE,
	input [63:0] W_valM,
	input [63:0] W_valE,
	output reg [63:0]d_valB );

always @(*) begin
	
	case (d_srcB)

	e_dstE:
		d_valB <= e_valE;
	M_dstM:
		d_valB <= m_valM;
	M_dstE:
		d_valB <= M_valE;
	W_dstM:
		d_valB <= W_valM;
	W_dstE:
		d_valB <= W_valE;
		default: d_valB <=d_rvalB;
	endcase

end

endmodule



module d_srcA_logic(D_icode, D_rA, d_srcA);

input[3:0]D_icode;
input[3:0]D_rA;

output reg[3:0]d_srcA;

parameter rsp = 4'h4 ;
parameter rnone = 4'hF ;


always @(D_icode,D_rA) begin

	case (D_icode)
	4'h2, 4'h3,4'h4,4'h5,4'h8,4'h6, 4'hA:
	begin
		d_srcA <= D_rA;
	end
	4'h9,4'hB:
	begin
		d_srcA <= rsp;
	end
		default: d_srcA <= rnone;
	endcase
	
end

endmodule


module d_srcB_logic(D_icode, D_rB, d_srcB);


input[3:0]D_icode;
input[3:0]D_rB;

output reg[3:0]d_srcB;

parameter rsp = 4'h4 ;
parameter rnone = 4'hF ;


always @(D_icode,D_rB) begin

	case (D_icode)
	4'h6, 4'h4, 4'h5:
	begin
		d_srcB<= D_rB;
	end
	4'hA, 4'hB, 4'h8, 4'h9:
	begin
		d_srcB <= rsp;
	end
		default: d_srcB <= rnone;
	endcase
	
end

endmodule


module dstE_logic(D_icode, D_ifun, D_rB, d_dstE);


input[3:0]D_icode;
input [3:0] D_ifun;
input[3:0]D_rB;
output reg[3:0]d_dstE;

parameter rsp = 4'h4 ;
parameter rnone = 4'hF ;


always @(*) begin

	case (D_icode) 
	4'h2,4'h3, 4'h6:
		d_dstE <= D_rB;
	4'hA, 4'hB, 4'h8, 4'h9:
		d_dstE <= rsp;
		default: d_dstE <= rnone;
	endcase
	
end

endmodule

module dstM_logic(D_icode, D_rA, d_dstM);


input[3:0]D_icode;
input[3:0]D_rA;

output reg[3:0]d_dstM;


parameter rsp = 4'h4 ;
parameter rnone = 4'hF ;

always @(D_icode,D_rA) begin
	 case (D_icode)
	 4'h5, 4'hB: 
		d_dstM <= D_rA;
		 default: d_dstM <= rnone;
	 endcase
	
end
endmodule
