`timescale 1ns/1ps

module add_64bit(a, b, out, cf_add);	

	input signed [63:0]a ;
	input signed [63:0]b ;
	output signed [63:0]out ;
	output reg [2:0] cf_add;

	wire [64:0]carry;

	wire overflow;
	assign carry[0] = 1'b0;

	genvar i;

	generate for(i = 0; i < 64; i = i+1) 
  	begin
    		add_1bit g1(a[i], b[i], carry[i], out[i], carry[i+1]);
  	end
  	endgenerate
	
	xor_1bit g2(carry[64], carry[63], overflow);


always @(*) begin
	
	if (out == 64'd0) begin
		cf_add[0] = 1'b1;
		
	end
	else cf_add[0] = 1'b0;

	if(out[63]==1'b1) begin
		cf_add[1] = 1'b1;
	end
	else cf_add[1] = 1'b0;	


	cf_add[2] <= overflow;

end
endmodule