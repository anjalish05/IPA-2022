

module RAM(memaddr,memdata,read,write,valM,dmemerror);

input[63:0] memaddr;
input[63:0] memdata;
input read;
input write;

reg [63:0] memory[8191:0]; 

output reg[63:0] valM;
output reg dmemerror;

dmemerror <= 1'b0;

always @(write,read,memdata,memaddr) begin

	if(read && !write) begin
		valM <= memory[memaddr];
	end
	if(write && !read) begin
		memory[memaddr] <= valM;
	end

	if (memaddr >= 64'd258) begin
		dmemerror <= 1'b1;
	end
	else begin
		dmemerror <= 1'b0;

	end

	
	
end


endmodule

module MEM_addr(icode,valE,valA,memaddr);

input[3:0] icode;
input [63:0] valE;
input[63:0] valA;

output reg[63:0] memaddr;

always @(icode,valE,valA) begin
	

	case (icode)
		4'h4, 4'h5, 4'hA, 4'h8: 
			memaddr <= valE;
		4'h9, 4'hB:
			memaddr <= valA;
	endcase

end

endmodule

module MEM_data(icode, valA, valP, memdata);

input[3:0] icode;
input [63:0] valA;
input[63:0] valP;

output reg[63:0] memdata;

always @(icode,valA,valP) begin
	
	case (icode)
		4'h4, 4'hA:
			memdata <= valA;
		4'h8:
			memdata<= valP;
		
	endcase
end

endmodule

module MEM_read (icode,read);

input [3:0] icode;
output reg read;

always @(icode) begin
	

	case (icode)
		4'h5, 4'hB, 4'h9:
			read <= 1'b1;
		default: read <= 1'b0;
	endcase
end
endmodule

module MEM_write (icode,write);

input [3:0] icode;
output reg write;

always @(icode) begin
	

	case (icode)
		4'h4, 4'hA, 4'h8:
			write <= 1'b1;
			
		default: write <= 1'b0;
	endcase
end
endmodule

//module STAT(instr_valid, icode, dmemerror, )