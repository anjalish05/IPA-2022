`timescale 1ns/1ps
module add_64bit(a, b, out, overflow);	

	input signed [63:0]a ;
	input signed [63:0]b ;
	output signed [63:0]out ;
	output overflow;

	wire [64:0]carry;

	assign carry[0] = 1'b0;

	genvar i;

	generate for(i = 0; i < 64; i = i+1) 
  	begin
    		add_1bit g1(a[i], b[i], carry[i], out[i], carry[i+1]);
  	end
  	endgenerate

	xor g2(overflow, carry[64], carry[63]);

endmodule