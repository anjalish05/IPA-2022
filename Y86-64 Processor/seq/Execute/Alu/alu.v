
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
	output [2:0] cf
);


	reg signed[63:0]out;
	reg [2:0] cf;

	wire signed [63:0] out1;
	wire [2:0] cf_add;
	wire signed [63:0] out2;
	wire [2:0] cf_sub;
	wire signed [63:0] out3;
	wire [2:0] cf_and;
	wire signed [63:0] out4;
	wire [2:0] cf_xor


	and_64bit g1(a, b, out3,cf_and);
	xor_64bit g2(a, b, out4,cf_xor);
	add_64bit g3(a, b, out1, cf_add);
	sub_64bit g4(a, b, out2, cf_sub);


	always@(*)
	begin
		case(control)
			2'b00:begin
				out = out1;
				cf = cf_add;
			end
			2'b01:begin
				out = out2;
				cf = cf_sub;
				
			end
			2'b10:begin
				out = out3;
				cf = cf_and;
			end
			2'b11:begin
				out = out4;
				cf = cf_xor;
			end
			
		endcase
	end
			
		
	
endmodule