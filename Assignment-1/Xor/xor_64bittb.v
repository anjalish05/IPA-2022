`timescale 1ns/1ps

module xor_64bittb;

	reg signed [63:0]a;
	reg signed [63:0]b;

	wire signed [63:0]out;

	xor_64bit dut(.a(a),.b(b),.out(out));

	initial begin
		$dumpfile("xor_64bit.vcd");
		$dumpvars(0, xor_64bittb);

		a = 64'b0;
		b = 64'b0;

	repeat(4) begin 
		#10 begin
			a = ~a;
			a = a<<1;
			a = ~a;
		end
		#20 begin
			b = ~b;
			b = b<<2;
			b = ~b;
		end
	end	
	end

  initial 
		$monitor("a=%b b=%b out=%b \n", a, b, out);

endmodule