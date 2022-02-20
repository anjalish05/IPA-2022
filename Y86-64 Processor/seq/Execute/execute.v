
`include "Alu/alu.v"

module alu(aluA,aluB, alufun,valE,overflow)

input[63:0] aluA;
input[63:0] aluB
input[1:0] alufun;

output[63:0] valE;
output overflow;

endmodule

module ALU_A(icode,valC,valA,aluA)

input[3:0] icode;
input[63:0] valC;
input[63:0] valA;

output[63:0] aluA;


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

