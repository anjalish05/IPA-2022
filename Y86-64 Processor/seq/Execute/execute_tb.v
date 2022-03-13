`timescale 1ns / 1ps

`include "Add/add_1bit.v"
`include "Add/add_64bit.v"
`include "And/and_1bit.v"
`include "And/and_64bit.v"
`include "Or/or_1bit.v"
`include "Sub/not_1bit.v"
`include "Sub/not_64bit.v"
`include "Sub/sub_64bit.v"
`include "Xor/xor_1bit.v"
`include "Xor/xor_64bit.v"

module execute_test;

    integer k;

    wire [63:0] aluA;
    wire [63:0] aluB;
    wire [1:0] alufun;
    wire [2:0] cf;
    wire [63:0] valE;
    reg [63:0] valA; 
    reg [63:0] valB;
    reg [63:0] valC;
    reg [3:0] icode;
    reg [3:0] ifun;
    wire [2:0] outf;
    wire cnd;

    alu_block alulogic(.aluA(aluA),.aluB(aluB),.alufun(alufun),.cf(cf),.valE(valE));
    ALU_A alualogic(.icode(icode),.valA(valA),.valC(valC),.aluA(aluA));
    ALU_B alublogic(.icode(icode),.valB(valB),.aluB(aluB));
    ALU_fun alufunlogic(.icode(icode),.ifun(ifun),.alufun(alufun));
    set_CC cclogiv(.icode(icode),.cf(cf),.outf(outf));
    CND cndlogic(.ifun(ifun),.outf(outf),.cnd(cnd));
    

    
    initial begin
        $dumpfile("execute_test.vcd");
        $dumpvars(0,execute_test);
        
        // OpXX rA rB
        icode <= 4'h6;
        ifun  <= 4'h0;
        valA  <= 64'd30;
        valB  <= 64'd50;
        #10;
        icode <= 4'h6;
        ifun  <= 4'h1;
        valA  <= 64'd30;
        valB  <= 64'd50;
        #10;
        icode <= 4'h6;
        ifun  <= 4'h2;
        valA  <= 64'd30;
        valB  <= 64'd50;
        #10;
        icode <= 4'h6;
        ifun  <= 4'h3;
        valA  <= 64'd30;
        valB  <= 64'd50;
        #10;

        // move instructions
        icode <= 4'h3;
        ifun  <= 4'h0;
        valA  <= 64'd30;
        valB  <= 64'd50;
        valC  <= 64'd20;
        #10;
        icode <= 4'h4;
        ifun  <= 4'h0;
        valA  <= 64'd30;
        valB  <= 64'd50;
        valC  <= 64'd35;
        #10;
        icode <= 4'h5;
        ifun  <= 4'h0;
        valA  <= 64'd30;
        valB  <= 64'd50;
        valC  <= 64'd70;
        #10;

        // push pop instructions
        icode <= 4'hA;
        ifun  <= 4'h0;
        valA  <= 64'd30;
        valB  <= 64'd50;
        valC  <= 64'd20;
        #10;
        icode <= 4'hB;
        ifun  <= 4'h0;
        valA  <= 64'd30;
        valB  <= 64'd50;
        valC  <= 64'd20;
        #10;

        
        #10 $finish;
   end
    
endmodule