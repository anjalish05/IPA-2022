// reads instructions from intruction memory 
// finding values of icode, ifun, rA, rB, valC using the instructions

module SELECT_PC(F_pred_pc, M_icode, M_cnd, M_valA, W_icode, W_valM,f_pc);

input [63:0] F_pred_pc;
input [3:0] M_icode;
/////////////////////////////look at this line////////'
input M_cnd;

input [63:0] M_valA;
input [3:0] W_icode;
input [63:0] W_valM;

output reg [63:0] f_pc;

always @(*) begin
    if(M_icode == 4'h7 && !M_cnd) 
        f_pc <= M_valA;
    else if( W_icode == 4'h9 )
        f_pc <= W_valM;
    else
        f_pc <= F_pred_pc;
end


endmodule




module PREDICT_PC(f_icode, f_valC, f_valP, predict_pc);

input [3:0] f_icode;
input [63:0] f_valC;
input [63:0] f_valP;
output reg [63:0] predict_pc;

always @(*) begin
    case (f_icode)
        4'h7,4'h8:
            predict_pc <= f_valC; 
        default: predict_pc<= f_valP;
    endcase

end

endmodule

module STAT_fetchlogic(f_icode,instr_valid,imem_error,f_stat);

    input [3:0] f_icode;
    input imem_error;
    input instr_valid;
    output reg[2:0] f_stat;

    
    parameter SAOK = 3'h1;
    parameter SHLT = 3'h2;
    parameter SADR = 3'h3;
    parameter SINS = 3'h4;

    always @(*)
    begin
        if(imem_error) 
            f_stat <= SADR;
        else if (!instr_valid)
            f_stat <= SINS;
        else if (f_icode == 4'h0)
            f_stat <= SHLT;
        else f_stat <= SAOK;
    end

endmodule

module split(Byte0,f_icode,f_ifun);

input [7:0] Byte0;
output [3:0] f_icode;
output [3:0] f_ifun;

    assign f_icode = Byte0[7:4];
    assign f_ifun = Byte0[3:0];

endmodule


module Need_VALC(f_icode, need_valC);
input [3:0] f_icode;
output reg need_valC;

always @(f_icode)
    begin
    case (f_icode)
        4'h3, 4'h4, 4'h5, 4'h7, 4'h8:
            begin
                assign need_valC = 1'b1;
            end
        4'h1, 4'h2, 4'h6, 4'h6, 4'h9, 4'hA, 4'hB:
            begin
                assign need_valC = 1'b0;
            end

        default: need_valC = 1'b0;
    endcase
    end
endmodule


module Need_REGIDS(f_icode, need_regids);

input [3:0] f_icode;
output reg need_regids;

    always @(f_icode)
        begin
        case (f_icode)
            4'h2, 4'h3, 4'h4, 4'h5, 4'h6, 4'hA, 4'hB:
                begin
                    assign need_regids = 1'b1;
                end
            4'h1, 4'h7, 4'h8, 4'h9:
                begin
                    assign need_regids = 1'b0;
                end

            default: need_regids = 1'b0;
        endcase
        end

endmodule


module align(Byte19, need_regids, f_rA, f_rB, f_valC);

input [71:0] Byte19;
input need_regids;
output [3:0] f_rA;
output [3:0] f_rB;
output [63:0] f_valC;

    assign f_rA = Byte19[7:4];
    assign f_rB = Byte19[3:0];
    assign f_valC = need_regids ? Byte19[71:8]:Byte19[63:0];

  
endmodule

module PC_INCREMENT(f_pc, f_icode, need_regids, need_valC, f_valP);

input[63:0] f_pc;
input [3:0] f_icode;
input need_regids;
input need_valC;
reg halt;
output [63:0] f_valP;

always @(f_icode) begin
    if(f_icode == 4'b000) begin
        halt =1'b1;
    end
    else
        halt =1'b0;
    
end
   

    assign f_valP = halt? f_pc:(need_valC ? (need_regids ? f_pc+10:f_pc+9):(need_regids ? f_pc+2:f_pc+1));

endmodule

module INSTR_VALID(f_icode, instr_valid);
input [3:0] f_icode;
output reg instr_valid;

always @(f_icode)
    begin
    case (f_icode)
        4'h0, 4'h1, 4'h2, 4'h3, 4'h4, 4'h5, 4'h6, 4'h7, 4'h8, 4'h9, 4'hA, 4'hB:
            begin
                assign instr_valid = 1'b1;
            end
    
        default: instr_valid = 1'b0;
    endcase
    end


endmodule