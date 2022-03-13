`timescale 1ns/1ps
`include "xor_1bit.v"

module xor_64bittb;

	reg signed [63:0]a;
	reg signed [63:0]b;

	wire signed [63:0]out;
	wire [2:0] cf_xor;

	xor_64bit dut(.a(a),.b(b),.out(out),.cf_xor(cf_xor));

	initial begin
		$dumpfile("xor_64bit.vcd");
		$dumpvars(0, xor_64bittb);

	
		a=64'd11;
		b=64'd4;

		repeat(2) begin
			#2 begin
				a = -a;
			end
			#2 begin
				b = -b;
			end
			end
		
		
		repeat(4) begin 

			#2 begin
				a = ~a;
				a = a<<2;
				a = ~a;
				end

			#2 begin
				b = ~b;
				b = b<<4;
				b = ~b;
			end

		end


		end

  initial 
		$monitor("a=%b b=%b out=%b \n", a, b, out);

endmodule