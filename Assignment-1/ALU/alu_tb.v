`timescale 1ns / 1ps

module alu_tb;

	reg signed [63:0]a;
	reg signed [63:0]b;
	wire signed [63:0]out;
	wire  overflow;
	reg [1:0] control;

	alu dut(.a(a), .b(b), .control(control), .out(out), .overflow(overflow));

	
	initial begin
		$dumpfile("alu.vcd");
		$dumpvars(0,alu_tb);

		a=64'b0000000000000000000000000000000000000000000000000000000000000000;
		b=64'b0000000000000000000000000000000000000000000000000000000000000000;

		control = 2'b00;

	
		#100;

	#20 control=2'b00;a=64'b1011;b=64'b0100;
    #20 control=2'b01;a=64'b1011;b=64'b0100;
    #20 control=2'b10;a=64'b1011;b=64'b0100;
    #20 control=2'b11;a=64'b1011;b=64'b0100;
    #20 control=2'b00;a=-64'b1011;b=64'b0100;
    #20 control=2'b01;a=-64'b1011;b=64'b0100;
    #20 control=2'b10;a=-64'b1011;b=64'b0100;
    #20 control=2'b11;a=-64'b1011;b=64'b0100;
    #20 control=2'b00;a=64'b1011;b=-64'b0100;
    #20 control=2'b01;a=64'b1011;b=-64'b0100;
    #20 control=2'b10;a=64'b1011;b=-64'b0100;
    #20 control=2'b11;a=64'b1011;b=-64'b0100;
    #20 control=2'b00;a=-64'b1011;b=-64'b0100;
    #20 control=2'b01;a=-64'b1011;b=-64'b0100;
    #20 control=2'b10;a=-64'b1011;b=-64'b0100;
    #20 control=2'b11;a=-64'b1011;b=-64'b0100;
    #20 control=2'b00;a=64'd2147483647;b=64'd1;
    #20 control=2'b01;a=64'd2147483647;b=-64'd1;
    #20 control=2'b00;a=64'b0;b=64'b0;
	end

  initial 
		$monitor("control = %d a=%d b=%d  out=%d  overflow=%b\n",control,a,b,out,overflow);

endmodule