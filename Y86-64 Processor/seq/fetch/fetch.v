// reads instructions from intruction memory 
// finding values of icode, ifun, rA, rB, valC using the instructions


module split(Byte0, icode, ifun);

input [7:0] Byte0;
output [3:0] icode;
output [3:0] ifun;

    assign icode = Byte0[7:4];
    assign ifun = Byte0[3:0];

endmodule

module Need_VALC(icode, need_valC);
input [3:0] icode;
output reg need_valC;

always @(icode)
    begin
    case (icode)
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

module Need_REGIDS(icode, need_regids);

input [3:0] icode;
output reg need_regids;

    always @(icode)
        begin
        case (icode)
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


module align(Byte19,need_regids,rA,rB,valC);

input [71:0] Byte19;
input need_regids;
output [3:0] rA;
output [3:0] rB;
output [63:0] valC;

    assign rA = Byte19[7:4] ;
    assign rB = Byte19[3:0];
    assign valC = need_regids ? Byte19[71:8]:Byte19[63:0];

  
endmodule

module PC_INCREMENT(pc, icode, need_regids, need_valC, valP);

input[63:0] pc;
input[3:0] icode;
input need_regids;
input need_valC;

reg halt;
output [63:0] valP;

always @(icode) begin

      if(icode == 4'b000) begin
        halt <= 1'b1;
    end
    else
        halt <= 1'b0;
    
end
  

    assign valP = halt ? pc:(need_valC ? (need_regids ? pc+10:pc+9):(need_regids ? pc+2:pc+1));


endmodule

module INSTR_VALID(icode, instr_valid);
input [3:0] icode;
output reg instr_valid;

always @(icode)
    begin
    case (icode)
        4'h0, 4'h1, 4'h2, 4'h3, 4'h4, 4'h5, 4'h6, 4'h7, 4'h8, 4'h9, 4'hA, 4'hB:
            begin
                assign instr_valid = 1'b1;
            end
    
        default: instr_valid = 1'b0;
    endcase
    end


endmodule