`timescale 1ns/1ps


module and_1bittb;

	reg a,b;
	wire out;




	and_1bit dut(.a(a),.b(b),.out(out));

	initial begin
		$dumpfile("and_1bit.vcd");
		$dumpvars(0,and_1bittb);

		a=1'b0;
		b=1'b0;
	repeat(4) begin 
		#10 a = ~a;
		#20 b = ~b;
	end
		
	end


	
		
	
	
  initial 
		$monitor("a=%b b=%b out=%b \n",a,b,out);

endmodule