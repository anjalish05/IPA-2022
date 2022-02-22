`timescale 1ns/1ps


module registerfile(clk,dstE,dstM,srcA,srcB,valE,valM,valA,valB);

input [3:0]dstE;
input [3:0]dstM;
input [3:0]srcA;
input [3:0]srcB;

input [63:0] valE;
input [63:0] valM;

output reg[63:0] valA;
output reg[63:0] valB;


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

	if (srcA != rnone) begin
		valA <= register_file[srcA];
		
	end

	if (srcB != rnone) begin
		valB <= register_file[srcB]
		
	end
	
end

always @(negedge(clk)) begin

	if(dstE != rnone) begin
		register_file[dstE] <= valE;
	end

	if(dstM != rnone) begin
		register_file[dstM] <= valM;
	end
	
end


endmodule




module srcA_logic(icode,rA,srcA);

input[3:0]icode;
input[3:0]rA;

output reg[3:0]srcA;

parameter rsp = 4'h4 ;
parameter rnone = 4'hF ;


always @(icode,rA) begin

	case (icode)
	4'h2, 4'h3, 4'h6, 4'hA:
	begin
		srcA<= rA;
	end
	4'h9,4'hB:
	begin
		srcA <= rsp;
	end
		default: srcA <= rnone;
	endcase
	
end

endmodule


module srcB_logic(icode,rB,srcB);


input[3:0]icode;
input[3:0]rB;

output[3:0]srcB;

parameter rsp = 4'h4 ;
parameter rnone = 4'hF ;


always @(icode,rB) begin

	case (icode)
	4'h6, 4'h4, 4'h5:
	begin
		srcA<= rB;
	end
	4'hA, 4'hB, 4'h8, 4'h9:
	begin
		srcA <= rsp;
	end
		default: srcA <= rnone;
	endcase
	
end

endmodule


module dstE_logic(icode,rB,dstM);


input[3:0]icode;
input[3:0]rB;

output[3:0]dstM;

parameter rsp = 4'h4 ;
parameter rnone = 4'hF ;

rr and cnd rB
ir rB
rsp
rnone

always @(icode,rA) begin

	case (icode)
	
		: 
		default: 
	endcase
	
end

endmodule


module dstM_logic(icode,rA,dstE);


input[3:0]icode;
input[3:0]rA;

output[3:0]dstE;

always @(icode) begin
	 case (icode)
		 : 
		 default: 
	 endcase
	
end
endmodule

