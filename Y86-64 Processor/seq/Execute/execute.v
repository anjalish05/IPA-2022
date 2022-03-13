`timescale 1ns / 1ps

module alu_block(aluA, aluB, alufun, valE, cf);

input[63:0] aluA;
input[63:0] aluB;
input[1:0] alufun;

output reg[63:0] valE;
output reg[2:0] cf;

wire signed [63:0] out1;
wire [2:0] cf_add;
wire signed [63:0] out2;
wire [2:0] cf_sub;
wire signed [63:0] out3;
wire [2:0] cf_and;
wire signed [63:0] out4;
wire [2:0] cf_xor;

	and_64bit g1(aluA, aluB, out3, cf_and);
	xor_64bit g2(aluA, aluB, out4, cf_xor);
	add_64bit g3(aluA, aluB, out1, cf_add);
	sub_64bit g4(aluB,aluA, out2, cf_sub);


	always@(*)
	begin
		case(alufun)
			2'b00:begin
				valE <= out1;
				cf <= cf_add;
			end
			2'b01:begin
				valE <= out2;
				cf <= cf_sub;
				
			end
			2'b10:begin
				valE <= out3;
				cf <= cf_and;
			end
			2'b11:begin
				valE <= out4;
				cf <= cf_xor;
			end
			
		endcase
	end
			
endmodule

module ALU_A(icode, valC, valA, aluA);

input[3:0] icode;
input[63:0] valC;
input[63:0] valA;

output reg[63:0] aluA;

always @(icode, valC, valA) begin
	
	case (icode)
	4'h2,4'h6: 
		aluA <= valA;
	4'h5,4'h4,4'h3:
		aluA <= valC;
	4'h8,4'hA:
		aluA <= -64'd8;
	4'h9,4'hB:
		aluA <= 64'd8;
	endcase
end

endmodule


module ALU_B(icode, valB, aluB);

input[3:0] icode;
input[63:0] valB;

output reg[63:0] aluB;

always @(icode, valB) begin
	
	case (icode)
	4'h4,4'h5,4'h6, 4'h8,4'h9, 4'hA, 4'hB: 
		aluB <= valB;
	4'h3,4'h4:
		aluB <= 64'b0;
	endcase
end

 
endmodule


module ALU_fun(icode, ifun, alufun);

input[3:0] icode;
input[3:0] ifun;

output reg[1:0] alufun;

always @(icode) begin

	case (icode)
	4'h6: begin
		alufun[1] = ifun[1];
		alufun[0] = ifun[0];
	end
		default:alufun <= 2'b00;
	endcase
	
end
endmodule


module set_CC(icode, cf, outf);

input [3:0] icode;
input [2:0]cf;
output reg[2:0] outf;

always @ (icode,cf)
begin
    case (icode)
        4'h6: 
            outf <= cf;
        default: outf <= outf;
    endcase
end

endmodule


module CND(ifun, outf, cnd);
    
    input[3:0] ifun;
    input[2:0] outf;
    output reg cnd;

    always @(ifun,outf)
    begin
        case(ifun)
        4'h0: cnd <= 1'b1;

        4'h1:
        begin
            if((outf[1]^outf[2]) || outf[0]) 
            cnd <= 1'b1;
            else
            cnd <= 1'b0;
        end

        4'h2:
        begin
            if(outf[1]^outf[2]) 
            cnd <= 1'b1;
            else
            cnd <= 1'b0;
        end
        
        4'h3:
        begin
            if(outf[0]) 
            cnd <= 1'b1;
            else
            cnd <= 1'b0;
        end 
        
        4'h4:
        begin
            if(~outf[0]) 
            cnd <= 1'b1;
            else
            cnd <= 1'b0;
        end
        
        4'h5:
        begin
            if(~(outf[1]^outf[2])) 
            cnd <= 1'b1;
            else
            cnd <= 1'b0;
        end
        
        4'h6:
        begin
            if(~(outf[1]^outf[2]) & ~outf[0]) 
            cnd <= 1'b1;
            else
            cnd <= 1'b0;
        end
        endcase
        
    end

endmodule