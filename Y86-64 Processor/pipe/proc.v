`timescale 1ns / 1ps

`include "fetch/fetch.v"
`include "fetch/fetch_reg.v"
`include "fetch/instrmem.v"
`include "Decode_wb/decode_reg.v"
`include "Decode_wb/decode_wb.v"
`include "Decode_wb/write_reg.v"
`include "Execute/execute_reg.v"
`include "Execute/execute.v"
`include "Memory/mem_reg.v"
`include "Memory/ram.v"
`include "pipeline_ctrl.v"

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

module Processor;

    reg clk;

    // fetch
    wire [63:0] f_pc;

    // fetch reg
    wire [63:0] predict_pc;
    reg [63:0] F_pred_pc;

    // instruction memory
    wire imem_error;
    wire [7:0] Byte0;
    wire [71:0] Byte19;

    // execute, execute register
    wire [63:0] aluA;
    wire [63:0] aluB;
    wire [1:0]  alufun;
    wire [2:0]  cf;
    wire [2:0] outf;
    // wire signed [63:0] out1;
    // wire [2:0] cf_add;
    // wire signed [63:0] out2;
    // wire [2:0] cf_sub;
    // wire signed [63:0] out3;
    // wire [2:0] cf_and;
    // wire signed [63:0] out4;
    // wire [2:0] cf_xor;

    wire [2:0]D_stat;
    wire [3:0]D_icode; 
    wire [3:0]D_ifun; 
    wire [3:0]d_dstE;
    wire [3:0]d_dstM;
    wire [3:0]d_srcA;
    wire [3:0]d_srcB;
    wire [63:0]d_valA;
    wire [63:0]d_valB;
    wire [63:0]D_valC;


    wire [2:0] E_stat;
    wire [3:0] E_icode; 
    wire [3:0] E_ifun;
    wire [3:0] E_dstE;
    wire [3:0] E_dstM;;
    wire [3:0] E_srcA;
    wire [3:0] E_srcB;
    wire [63:0] E_valC;
    wire [63:0] E_valA;
    wire [63:0] E_valB;

    // decode, decode reg, decode wb, write reg
    wire [2:0]f_stat;
    wire [3:0]f_icode; 
    wire [3:0]f_ifun; 
    wire [3:0]f_rA;
    wire [3:0]f_rB;
    wire [63:0]f_valC;
    wire [63:0]f_valP;

    wire [3:0] D_rA;
    wire [3:0] D_rB;
    wire [63:0] D_valP;

    wire [3:0]W_dstE;
    wire [3:0]W_dstM;
    wire [63:0] W_valE;
    wire [63:0] W_valM;

    wire [63:0] d_rvalA;
    wire [63:0] d_rvalB;

    wire [63:0] register_file[14:0];
    wire [2:0] stat;

	wire [3:0] e_dstE;
	wire [3:0] M_dstM;
	wire [3:0] M_dstE;
	wire [63:0] m_valM;


    wire [2:0]m_stat;
    wire [63:0]m_valA; 
    wire [63:0]M_valE;

    wire [2:0] W_stat;
    wire [3:0] W_icode; 

    // memory 
    wire e_cnd; 
    wire [3:0]e_dstM;
    wire [63:0]e_valE;
    wire [2:0] M_stat;
    wire [3:0] M_icode; 
    wire M_cnd;

    wire [63:0] memaddr;
    wire [63:0] memdata;
    wire read;
    wire write;
    wire [63:0] memory[8191:0]; 
    wire dmemerror;
    wire [63:0] valM;
    wire [63:0] M_valA;

    wire [3:0] icode;
    wire  [63:0] valA;
    wire [63:0] valP;



    // pipeline control 
    wire F_stall;
    wire D_stall;
    wire D_bubble;
    wire E_bubble;
    wire M_bubble;
    wire W_stall;

    // fetch
    //FETCH_REG f_reg(.clk(clk), .predict_pc(predict_pc), .F_pred_pc(F_pred_pc));
    SELECT_PC sel_pc(.F_pred_pc(F_pred_pc), .M_icode(M_icode), .M_cnd(M_cnd), .M_valA(M_valA), .W_icode(W_icode), .W_valM(W_valM), .f_pc(f_pc));
    PREDICT_PC pred_pc(.f_icode(f_icode), .f_valC(f_valC), .f_valP(f_valP), .predict_pc(predict_pc));
    STAT_fetchlogic flstat(.f_icode(f_icode), .instr_valid(instr_valid), .imem_error(imem_error), .f_stat(f_stat));
    split sp(.Byte0(Byte0), .f_icode(f_icode), .f_ifun(f_ifun));
    align al(.Byte19(Byte19), .need_regids(need_regids), .f_rA(f_rA), .f_rB(f_rB), .f_valC(f_valC));
    PC_INCREMENT PC_i(.f_pc(f_pc), .f_icode(f_icode), .need_regids(need_regids), .need_valC(need_valC), .f_valP(f_valP));
    INSTR_VALID i_valid(.f_icode(f_icode), .instr_valid(instr_valid));
    Need_REGIDS nreg(.f_icode(f_icode), .need_regids(need_regids));
    Need_VALC n_valC(.f_icode(f_icode), .need_valC(need_valC));
    instruction_memory InstMem(.clk(clk), .f_pc(f_pc), .imem_error(imem_error), .Byte0(Byte0), .Byte19(Byte19));
    
    // decode
     DECODE_REG d_reg(.clk(clk), .f_stat(f_stat), .f_icode(f_icode), .f_ifun(f_ifun), .f_rA(f_rA), .f_rB(f_rB), .f_valC(f_valC), .f_valP(f_valP), .D_stat(D_stat), .D_icode(D_icode), .D_ifun(D_ifun), .D_rA(D_rA), .D_rB(D_rB), .D_valC(D_valC), .D_valP(D_valP));
     registerfile reg_file(.clk(clk), .W_dstE(W_dstE), .W_dstM(W_dstM), .d_srcA(d_srcA), .d_srcB(d_srcB), .W_valE(W_valE), .W_valM(W_valM), .d_rvalA(d_rvalA), .d_rvalB(d_rvalB));
     WRITE_STAT wr_stat(.W_stat(W_stat), .stat(stat));
     d_VALA_logic d_valAlog(.D_icode(D_icode), .d_rvalA(d_rvalA), .D_valP(D_valP), .d_srcA(d_srcA), .e_dstE(e_dstE), .M_dstM(M_dstM),
	 .M_dstE(M_dstE), .W_dstM(W_dstM), .W_dstE(W_dstE), .e_valE(e_valE), .m_valM(m_valM), .M_valE(M_valE), .W_valM(W_valM), .W_valE(W_valE), .d_valA(d_valA) );
     d_VALB_logic d_valBlog(.d_rvalB(d_rvalB), .D_valP(D_valP), .d_srcB(d_srcB), .e_dstE(e_dstE), .M_dstM(M_dstM), .M_dstE(M_dstE),
	                .W_dstM(W_dstM), .W_dstE(W_dstE), .e_valE(e_valE), .m_valM(m_valM), .M_valE(M_valE), .W_valM(W_valM), .W_valE(W_valE), .d_valB(d_valB) );
    d_srcA_logic d_srcAlog(.D_icode(D_icode), .D_rA(D_rA), .d_srcA(d_srcA));
    d_srcB_logic d_srcBlog(.D_icode(D_icode), .D_rB(D_rB), .d_srcB(d_srcB));
    dstE_logic dstE_log(.D_icode(D_icode), .D_ifun(D_ifun), .D_rB(D_rB), .d_dstE(d_dstE));
    dstM_logic dstM_log(.D_icode(D_icode), .D_rA(D_rA), .d_dstM(d_dstM));
    WRITE_REG wr_reg(.clk(clk),.W_stall(W_stall),.m_stat(m_stat),.m_valM(m_valM), .M_icode(M_icode), .M_valE(M_valE), .M_dstE(M_dstE), .M_dstM(M_dstM),
                    .W_stat(W_stat), .W_icode(W_icode), .W_valE(W_valE), .W_valM(W_valM), .W_dstE(W_dstE), .W_dstM(W_dstM));
    
    // execute
    EXECUTE_REG exec_reg(.clk(clk), .D_stat(D_stat), .D_icode(D_icode), .D_ifun(D_ifun), .D_valC(D_valC), .d_valA(d_valA),
        .d_valB(d_valB), .d_dstE(d_dstE), .d_dstM(d_dstM), .d_srcA(d_srcA), .d_srcB(d_srcB), .E_stat(E_stat), .E_icode(E_icode), .E_ifun(E_ifun), .E_valC(E_valC), .E_valA(E_valA), .E_valB(E_valB), .E_dstE(E_dstE), .E_dstM(E_dstM), .E_srcA(E_srcA), .E_srcB(E_srcB));
    alu_block alulogic(.aluA(aluA), .aluB(aluB), .alufun(alufun), .cf(cf), .e_valE(e_valE));
    EXE_DST_E_LOGIC e_dselogic(.E_icode(E_icode),.e_cnd(e_cnd),.E_dstE(E_dstE),.e_dstE(e_dstE));
    ALU_A alualogic(.E_icode(E_icode), .E_valA(E_valA), .E_valC(E_valC), .aluA(aluA));
    ALU_B alublogic(.E_icode(E_icode), .E_valB(E_valB), .aluB(aluB));
    ALU_fun alufunlogic(.E_icode(E_icode), .E_ifun(E_ifun), .alufun(alufun));
    set_CC cclogiv(.E_icode(E_icode), .cf(cf), .outf(outf));
    CND cndlogic(.E_ifun(E_ifun), .outf(outf), .e_cnd(e_cnd));

    // memory
    MEMORY_REG mem_reg(.clk(clk), .E_stat(E_stat), .E_icode(E_icode), .e_cnd(e_cnd), .e_valE(e_valE),
        .E_valA(E_valA), .e_dstE(e_dstE), .E_dstM(E_dstM),
        .M_stat(M_stat), .M_icode(M_icode), .M_cnd(M_cnd), .M_valE(M_valE), .M_valA(M_valA), .M_dstE(M_dstE), .M_dstM(M_dstM));
    RAM ram(.memaddr(memaddr),.read(read), .write(write),.M_valA(M_valA),.m_valM(m_valM), .dmemerror(dmemerror));
    MEM_addr m_addr(.M_icode(M_icode), .M_valE(M_valE), .M_valA(M_valA), .memaddr(memaddr));
    MEM_read m_read(.M_icode(M_icode), .read(read));
    MEM_write m_write(.M_icode(M_icode), .write(write));
    STAT_memlogic mem_stat(.dmemerror(dmemerror), .M_stat(M_stat), .m_stat(m_stat));
  

    // pipeline control 
    PIPE_CONTROL_LOGIC pipe_ctrl(.D_icode(D_icode),
                .d_srcA(d_srcA), .d_srcB(d_srcB), .E_icode(E_icode), .E_dstM(E_dstM), .e_Cnd(e_Cnd), .M_icode(M_icode), .m_stat(m_stat), .W_stat(W_stat),
                .F_stall(F_stall), .D_stall(D_stall), .D_bubble(D_bubble), .E_bubble(E_bubble), .M_bubble(M_bubble), .W_stall(W_stall));

initial
begin

    $dumpfile("proc.vcd");
    $dumpvars(0, Processor);
    // $readmemh("rom.mem", instr_mem);
    
    clk = 1'b1;
    F_pred_pc = 64'd0;

end

  
always @(posedge clk)
      begin    
          case (F_stall)
              1'b1:
                F_pred_pc <= F_pred_pc; 
              default: F_pred_pc <= predict_pc;
          endcase
      end

    always #5 clk <= ~clk;
    initial
        #500 $finish;

    
initial begin
	//USE below monitor to monitor fetch values.
    	//$monitor("clk=%d,F_stall = %b,,F_pred_pc=%d, f_pc = %d,predict_pc = %d, D_stall = %b, D_bubble %b, E_bubble = %b,M_bubble = %b,W_stall =%b,f_icode=%d, f_ifun=%d, f_rA=%b, f_rB=%b, f_valC=%d, f_valP=%d, \n",
        //clk, F_stall,F_pred_pc,f_pc,predict_pc,D_stall,D_bubble,E_bubble,M_bubble,W_stall,f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP);
    // Pipeline control Monitor
        //$monitor("clk=%d,F_pc = %d,D_icode =%d,E_icode = %d,d_dstM = %b,E_dstM=%b,d_srcA =%b,d_srcB = %b,m_stat=%b,W_stat = %b,M_icode=%d,e_cnd = %b,F_stall = %b, D_stall = %b,W_stall = %b,D_bubble = %b,E_bubble = %b,M_bubble = %b\n", clk,F_pred_pc,D_icode,E_icode,d_dstM,E_dstM,d_srcA,d_srcB,m_stat,W_stat,M_icode,e_cnd,F_stall , D_stall, W_stall,D_bubble,E_bubble,M_bubble);
    // Decode Stage 
        //$monitor("clk=%d,F_pc = %d,D_icode = %d,D_ifun = %d, f_rA = %b,D_rA = %b, D_rB = %b, D_valC =%d ,D_valP = %d,d_srcA =%b,d_srcB = %b,d_valA = %d, d_valB = %d\n",clk,F_pred_pc,D_icode,D_ifun,f_rA,D_rA,D_rB,D_valC,D_valP,d_srcA,d_srcB,d_valA,d_valB);
    //Execute Stage
        // $monitor("clk=%d,F_pc = %d,E_icode = %d,e_valE = %d, aluA = %d,aluB = %d,alufun = %d, E_valC = %d,E_valA = %d, E_valB = %d,d_dstE = %b,D_rA = %b,D_rB = %b,E_dstE = %b,e_dstE = %b\n",
           //clk,f_pc,E_icode,e_valE,aluA,aluB,alufun,E_valC,E_valA,E_valB,d_dstE,D_rA,D_rB,E_dstE,e_dstE);
    // Memory stage 
       //$monitor("clk =%b, write= %b,F_pc = %d,read =%b, M_icode = %d,M_cnd= %b, m_valM = %d, M_valE =%d,memaddr = %d,M_valA =%d, M_dstE =%b,e_dstE = %b, M_dstM = %b",
       //clk,write,f_pc,read,M_icode,M_cnd,m_valM,M_valE,memaddr,M_valA,M_dstE,e_dstE,M_dstM);
    //Write back stage:
      //$monitor("clk=%d,W_stall = %b,F_pc= %d,f_valc = %d W_icode = %d,W_dstE = %b,W_dstM = %b,W_valE =%d,W_valM = %d,e_cnd = %b,M_cnd =%b",
        //clk,W_stall,F_pred_pc,f_valC,W_icode,W_dstE,W_dstM,W_valE,W_valM,e_cnd,M_cnd);

        //$monitor("clk=%d,E_icode = %d, e_valE = %d,outf = %b,e_cnd =%b,M_cnd= %b, M_valA = %d, W_valM = %d,f_pc = %d,pred_pc =%d, F_pc= %d,f_valc = %d,f_valP = %d,needregids = %b"
        //,clk,E_icode,e_valE,outf,e_cnd,M_cnd,M_valA,W_valM,f_pc,predict_pc,F_pred_pc,f_valC,f_valP,need_regids);

        	//$monitor("clk=%d,D_icode = %d,F_stall = %b,,F_pred_pc=%d, f_pc = %d,predict_pc = %d, D_stall = %b, D_bubble %b, E_bubble = %b,M_bubble = %b,W_stall =%b,f_icode=%d, f_ifun=%d, f_rA=%b, f_rB=%b, f_valC=%d, f_valP=%d, \n",
        //clk, D_icode,F_stall,F_pred_pc,f_pc,predict_pc,D_stall,D_bubble,E_bubble,M_bubble,W_stall,f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP);

    //$monitor("clk=%b,F_predPC=%d,F_stall=%b,\n",clk,F_pred_pc,F_stall);
//Fetchstage 
//$monitor("clk=%b,F_PC=%d,f_stat=%b,f_icode=%h,f_ifun=%h,f_rA=%h,f_rB=%h,f_valC=%d,f_valP=%d,\n",clk,f_pc,f_stat,f_icode,f_ifun,f_rA,f_rB,f_valC,f_valP);
//Decode Reg 
//$monitor("clk=%b,F_PC=%d,D_stat=%b,D_icode,D_ifun=%h,D_rA=%h,D_rB=%h,D_valC=%d,D_valP=%d,D_stall=%d,D_bubble=%b,\n",clk,f_pc,D_stat,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP,D_stall,D_bubble);
// Execute stage REg   /
//$monitor("clk=%b,F_PC=%d,E_icode1=%h,E_stat=%b,E_ifun=%h,E_valC=%d,E_valA=%d,E_valB=%d,E_dstE=%h,E_dstM=%h,E_srcA=%h,E_srcB=%h,E_bubble=%b\n",clk,f_pc,E_icode,E_stat,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,E_srcA,E_srcB,E_bubble);
// Memory stage Reg  
 $monitor("clk=%b,F_PC=%d,M_stat=%b,M_icode=%h,M_Cnd=%b,M_valE=%d,M_valA=%d,M_dstE=%h,M_dstM=%h,M_bubble=%b,\n",clk,f_pc,M_stat,M_icode,M_cnd,M_valE,M_valA,M_dstE,M_dstM,M_bubble);
//Writeback stage Reg   
//$monitor("clk=%b,F_PC=%d,W_stat=%b,W_icode=%h,W_valE=%d,W_valM=%d,W_dstE=%h,W_dstM=%h,W_stall=%b \n",clk,f_pc,W_stat,W_icode,W_valE,W_valM,W_dstE,W_dstM,W_stall);


end

endmodule
