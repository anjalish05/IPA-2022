`timescale 1ns/1ps
`include "add_1bit.v"

module add_64bittb;

	reg signed [63:0]a;
	reg signed [63:0]b;

	wire signed [63:0]out;
	wire  [2:0] cf_add;
	add_64bit dut(.a(a), .b(b), .out(out), . cf_add(cf_add));

	initial begin
		$dumpfile("add_64bit.vcd");
		$dumpvars(0, add_64bittb);

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
    #2 b = 64'b0000000000000000000000000000000000000000000000000000000000000001;

  end

  initial 
		$monitor("a=%d b=%d out=%d cf_add=%b\n",a, b, out, cf_add);

endmodule