`timescale 1ns / 1ps

module fetch_tb; 

reg clk; 
reg [63:0] pc; 
wire [7:0] Byte0;
wire [71:0] Byte19;
wire [3:0] icode; 
wire [3:0] ifun;

wire need_regids;
wire need_valC;
wire instr_valid;
wire imem_error;

wire [3:0] rA;
wire [3:0] rB;

wire [63:0] valP;
wire [63:0] valC;

reg [7:0] instr_mem [2047:0];

split sp(.Byte0(Byte0), .icode(icode), .ifun(ifun));
align al(.Byte19(Byte19), .need_regids(need_regids), .rA(rA), .rB(rB), .valC(valC));
PC_INCREMENT PC_i(.pc(pc), .need_regids(need_regids), .need_valC(need_valC), .valP(valP));
INSTR_VALID i_valid(.icode(icode), .instr_valid(instr_valid));
Need_REGIDS nreg(.icode(icode), .need_regids(need_regids));
Need_VALC n_valC(.icode(icode), .need_valC(need_valC));
instruction_memory InstMem(.clk(clk),.pc(pc),.imem_error(imem_error),.Byte0(Byte0),.Byte19(Byte19));


initial begin
    $dumpfile("fetch_test.vcd");
    $dumpvars(0, fetch_tb);

    clk = 0; 
    pc = 64'd1;

    #10 clk = ~clk; pc=64'd0;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=64'd112;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
  end  
  
initial begin
		$monitor("clk=%d, pc=%d, icode=%d, ifun=%d, rA=%b, rB=%b, valC=%d, valP=%d, imeme_err = %b\n", clk, pc, icode, ifun, rA, rB, valC, valP,imem_error);

end

endmodule