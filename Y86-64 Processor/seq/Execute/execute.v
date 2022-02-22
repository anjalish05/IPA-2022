
`include "Alu/alu.v"

module alu(aluA,aluB, alufun,valE,overflow)

input[63:0] aluA;
input[63:0] aluB
input[1:0] alufun;

output[63:0] valE;
output [2:0]cf;






endmodule

module ALU_A(icode,valC,valA,aluA)

input[3:0] icode;
input[63:0] valC;
input[63:0] valA;

output[63:0] aluA;

always @(icode,valC,valA) begin
	
	case (icode)
	4'h2,4'h6: 
		aluA <= valA;
	4'h5,4'h4,4'h3:
		aluA <= valA;
	4'h8,4'hA:
		aluA <= 64'd8;
	4'h9,4'hB:
		aluA <= -64'd8;
		default: 
	endcase
end

endmodule

module ALU_B(icode,valB,aluB)

input[3:0] icode;
input[63:0] valB;

output[63:0] aluB;
 
endmodule

module ALU_fun(icode,ifun,alufun)

input[3:0] icode;
input[3:0] ifun;

output[1:0] alufun;

endmodule


module set_CC(icode,CC)

endmodule

