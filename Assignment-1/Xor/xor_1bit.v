`timescale 1ns/1ps

module xor_1bit( a, b, out);

input a, b;
output reg out;

always @(a or b ) begin
	
	if(a == 1'b0)
	begin
		if(b == 1'b0)
			out = 1'b0;
	end
	else if(a == 1'b0)
	begin
		if(b == 1'b1)
			out = 1'b1;
	end
	else if(a == 1'b1)
	begin
		if(b == 1'b0)
			out = 1'b1;
	end
	else 
	begin
		out = 1'b0;
	end
	
		
end

endmodule
