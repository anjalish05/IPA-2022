`timescale 1ns/1ps


module sub_64bittb;

	reg signed [63:0]a;
	reg signed [63:0]b;

	wire signed [63:0]out;
	wire  overflow;
	sub_64bit dut(.a(a), .b(b), .out(out), .overflow(overflow));

	initial begin
		$dumpfile("sub_64bit.vcd");
		$dumpvars(0, sub_64bittb);

		a = 64'b0000000000000000000000000000000000000000000000000000000000000000;
		b = 64'b0000000000000000000000000000000000000000000000000000000000000000;

	repeat(8) begin 
		#10 begin
			a = ~a;
			a = a << 4;
			a = ~a;
		end
		#20 begin
			b = ~b;
			b = b<<8;
			b = ~b;
		end
	end
	repeat(4) begin 
		#10 begin
			a = ~a;
			a = a<<8;
			a = ~a;
		end
		#20 b= b<<16;
	
		
	end
	end

  initial 
		$monitor("a=%d b=%d out=%d overflow=%b\n", a, b, out, overflow);

endmodule