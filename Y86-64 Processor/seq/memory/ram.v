

module RAM(memaddr,memdata,read,write,valM,dmemerror)

input[63:0] memaddr;
input[63:0] memdata;
input read;
input write;

reg [63:0] memory[8191:0] 

output reg[63:0] valM;
output reg memerror;

always @(*) begin
	if(read && !write) begin
		valM <= memory[memaddr];
	end
	if(write && !read) begin
		memory[memaddr] <= valM;
	end
	
end


endmodule

module MEM_addr(icode,valE,valA,memaddr)

input[3:0] icode;
input [63:0] valE;
input[63:0] valA;

output reg[63:0] memaddr;

case (icode)
	4'h4, 4'h5, 4'hA, 4'h8: 
		memaddr <= valE;
	4'h9, 4'hB:
		memaddr <= valA;
endcase


endmodule

module MEM_data(icode, valA, valP, memdata)

input[3:0] icode;
input [63:0] valA;
input[63:0] valP;

output reg[63:0] memdata;

case (icode)
	4'h4, 4'hA:
		memdata <= valA;
	4'h8:
		memdata<= valP;
	
endcase


endmodule

module MEM_read (icode,read);

input [63:0] icode;
output reg read

case (icode)
	4'h5, 4'hB, 4'h9:
		read <= 1'b1;

	default: read <= 1'b0;
endcase

endmodule

module MEM_write (icode,write);

input [63:0] icode;
output reg write

case (icode)
	4'h4, 4'hA, 4'h8:
		write <= 1'b1;
		 
	default: write <= 1'b0;
endcase

endmodule

module STAT(instr_valid, icode, dmemerror, )