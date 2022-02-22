
`timescale 1ns/1ps

`include "../And/and_1bit.v"
`include "../And/and_64bit.v"
`include "../Xor/xor_1bit.v"
`include "../Xor/xor_64bit.v"
`include "../Or/or_1bit.v"

`include "../Add/add_1bit.v"
`include "../Add/add_64bit.v"

`include "../Sub/not_1bit.v"
`include "../Sub/not_64bit.v"
`include "../Sub/sub_64bit.v"


module alu (


	input[1:0]control,
	input signed [63:0]a,
	input signed [63:0]b,
	output signed[63:0]out,
	output overflow
);


	reg signed[63:0]out;
	reg overflow;

	wire signed [63:0] out1;
	wire overflow1;
	wire signed [63:0] out2;
	wire overflow2;
	wire signed [63:0] out3;
	wire signed [63:0] out4;


	and_64bit g1(a, b, out3);
	xor_64bit g2(a, b, out4);
	add_64bit g3(a, b, out1, overflow1);
	sub_64bit g4(a, b, out2, overflow2);


	always@(*)
	begin
		case(control)
			2'b00:begin
				out = out1;
				overflow = overflow1;
			end
			2'b01:begin
				out = out2;
				overflow = overflow2;
				
			end
			2'b10:begin
				out = out3;
				overflow = 1'b0;
			end
			2'b11:begin
				out = out4;
				overflow = 1'b0;
			end
			
		endcase
	end
			
		
	
endmodule