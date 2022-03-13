`timescale  1ns/1ps

module and_64bit(
	input signed [63:0]a,
	input signed [63:0]b,
	output signed [63:0] out,
	output reg[2:0] cf_and
);

genvar i;

generate for(i = 0; i<64;i=i+1)
begin
	and_1bit g1(a[i],b[i],out[i]);
end
	
endgenerate

always @(*) begin
	

	if (out == 64'b0) begin
		cf_and[0] = 1'b1;

	end else cf_and[0] = 1'b0;
	
	if(out[63]==1'b1) begin
		cf_and[1] = 1'b1;
	end else cf_and[1] = 1'b0;

	cf_and[2] = 1'b0;

end

endmodule