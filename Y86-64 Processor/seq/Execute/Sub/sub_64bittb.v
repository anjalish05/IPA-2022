`timescale 1ns/1ps


`include "add_64bit.v"
`include "add_1bit.v"
`include "not_1bit.v"
`include "not_64bit.v"

module sub_64bittb;

	reg signed [63:0]a;
	reg signed [63:0]b;

	wire signed [63:0]out;
	wire  overflow;
	sub_64bit dut(.a(a), .b(b), .out(out), .overflow(overflow));

	initial begin
		$dumpfile("sub_64bit.vcd");
		$dumpvars(0, sub_64bittb);

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
			#2 a = 64'b0111111111111111111111111111111111111111111111111111111111111111;
			#10 b = -64'd1;
			
		end

  initial 
		$monitor("a=%d b=%d out=%d overflow=%b\n", a, b, out, overflow);

endmodule