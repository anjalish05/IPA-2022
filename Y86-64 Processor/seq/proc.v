`timescale 1ns / 1ps

`include "fetch/fetch.v"
`include "fetch/instrmem.v"
`include "decode/decode.v"
`include "Execute/execute.v"
`include "memory/ram.v"
`include "pc_update/pc_update.v"


`include "Execute/And/and_1bit.v"
`include "Execute/And/and_64bit.v"
`include "Execute/Xor/xor_1bit.v"
`include "Execute/Xor/xor_64bit.v"
`include "Execute/Or/or_1bit.v"

`include "Execute/Add/add_1bit.v"
`include "Execute/Add/add_64bit.v"

`include "Execute/Sub/not_1bit.v"
`include "Execute/Sub/not_64bit.v"
`include "Execute/Sub/sub_64bit.v"


module proc;

reg clk; 
reg [63:0] pc;

// fetch, intruction memory
wire [3:0] icode;
wire [3:0] ifun;
wire [7:0] Byte0;
wire [71:0] Byte19;
wire need_valC;
wire need_regids;
wire [63:0] valC;
wire [3:0] rA;
wire [3:0] rB;
wire [63:0] valP;
wire imem_error;
wire instr_valid; // reg or wire?

// decode
wire [3:0] dstE;
wire [3:0] dstM;
wire [3:0] srcA;
wire [3:0] srcB;
wire [63:0] valE;
wire [63:0] valM;
wire [63:0] valA;
wire [63:0] valB;
// execute
wire [63:0] aluA;
wire [63:0] aluB;
wire [1:0] alufun;
wire [2:0] cf;
wire [2:0] outf;
wire cnd;

// memory
wire [63:0] memaddr;
wire [63:0] memdata;
wire read;
wire write;
wire dmemerror;
reg [2:0] stat;

// pc update
wire [63:0] newpc;


// fetch
split sp(.Byte0(Byte0), .icode(icode), .ifun(ifun));
align al(.Byte19(Byte19), .need_regids(need_regids), .rA(rA), .rB(rB), .valC(valC));
PC_INCREMENT PC_i(.pc(pc), .icode(icode), .need_regids(need_regids), .need_valC(need_valC), .valP(valP));
INSTR_VALID i_valid(.icode(icode), .instr_valid(instr_valid));
Need_REGIDS nreg(.icode(icode), .need_regids(need_regids));
Need_VALC n_valC(.icode(icode), .need_valC(need_valC));
instruction_memory InstMem(.clk(clk),.pc(pc),.imem_error(imem_error),.Byte0(Byte0),.Byte19(Byte19));

// decode 
registerfile reg_f(.clk(clk), .dstE(dstE), .dstM(dstM), .srcA(srcA) , .srcB(srcB) , .valA(valA) , .valB(valB) , .valM(valM), .valE(valE));
srcA_logic sA_l(.icode(icode), .rA(rA), .srcA(srcA));
srcB_logic sB_l(.icode(icode), .rB(rB), .srcB(srcB));
dstE_logic dE_l(.icode(icode), .rB(rB), .cnd(cnd), .ifun(ifun), .dstE(dstE));
dstM_logic dM_l(.icode(icode), .rA(rA), .dstM(dstM));

// execute 
alu_block alulogic(.aluA(aluA), .aluB(aluB), .alufun(alufun), .cf(cf), .valE(valE));
ALU_A alualogic(.icode(icode), .valA(valA), .valC(valC), .aluA(aluA));
ALU_B alublogic(.icode(icode), .valB(valB), .aluB(aluB));
ALU_fun alufunlogic(.icode(icode), .ifun(ifun), .alufun(alufun));
set_CC cclogiv(.icode(icode), .cf(cf), .outf(outf));
CND cndlogic(.ifun(ifun), .outf(outf), .cnd(cnd));

// memory
RAM ram1(.memaddr(memaddr), .memdata(memdata), .read(read), .write(write), .valM(valM), .dmemerror(dmemerror));
MEM_addr Ma(.icode(icode), .valA(valA), .valE(valE), .memaddr(memaddr));
MEM_read Mr(.icode(icode), .read(read));
MEM_write Mw(.icode(icode), .write(write));
MEM_data Md(.icode(icode), .valA(valA), .valP(valP), .memdata(memdata));    

// PC Update
pc_update pc_new(.clk(clk), .cnd(cnd), .icode(icode), .valC(valC), .valM(valM), .valP(valP), .newpc(newpc));

/* // sub 64 bit
wire [63:0] suba;
wire [63:0] subb;
wire [63:0] subout;
wire [2:0] subflag;
sub_64bit check(.a(suba),.b(subb),.out(subout),.cf_sub(subflag));
// add 64 bit
wire [63:0] adda;
wire [63:0] addb;
wire [63:0] addout;
wire [2:0] addflag;
add_64bit chec_k(.a(adda),.b(addb),.out(addout),.cf_add(addflag)); */

initial
begin

    $dumpfile("proc.vcd");
    $dumpvars(0, proc);
    // $readmemh("rom.mem", instr_mem);
    
    clk = 1'b1;
    pc = 64'd0;

end

always @(posedge clk)
      begin    
        pc <= newpc;
      end

    always #10 clk <= ~clk;
    initial
        #670 $finish;

    
initial begin
  //$monitor("clk=%d, pc=%d, icode=%d, ifun=%d, rA=%b, rB=%b, valC=%d, valP=%d, aluA = %d, aluB = %d, valA=%d, valB=%d,valE=%d, valM=%d, alufun =%d,read = %b,write = %b,memaddr=%d,memdata = %d,newpc = %d\n", clk, pc, icode, ifun, rA, rB, valC, valP, aluA, aluB, valA, valB, valE, valM,alufun,read,write,memaddr,memdata,newpc);
  //$monitor("clk=%d, pc=%d, icode=%d, ifun=%d, rA=%b, rB=%b",clk, pc, icode, ifun, rA, rB,);
    $monitor("clk=%d, pc=%d, icode=%d, ifun=%d, rA=%b, rB=%b, valC=%d, valP=%d, aluA = %d, aluB = %d, alufun = %b ,valA=%d, valB=%d,valE=%d, outf = %b,cf =%b,cnd =%b\n", 
    clk, pc, icode, ifun, rA, rB, valC, valP, aluA, aluB,alufun,valA, valB, valE,outf,cf,cnd );

end

endmodule