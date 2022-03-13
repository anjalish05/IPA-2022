

module sub_64bit (a, b, out, cf_sub);

input signed [63:0]a;
input signed [63:0]b;
output signed [63:0]out;
output reg[2:0] cf_sub;

genvar i;
wire overflow;
wire [2:0] fadd;
wire [63:0]no; // no = not output
not_64bit g1(b, no); // inverting bits of input b

wire [63:0]f_inv; // for final inversion
assign f_inv = 64'd1;

wire [63:0]add_finv;

wire [64:0] sub_carry1;
wire [64:0] sub_carry2;

assign sub_carry1[0] = 1'b0;
assign sub_carry2[0] = 1'b0;


generate for(i = 0; i < 64; i = i+1) 
  	begin
    		add_1bit g1(f_inv[i], no[i], sub_carry1[i], add_finv[i], sub_carry1[i+1]);
  	end
  	endgenerate
	

generate for(i = 0; i < 64; i = i+1) 
  	begin
    		add_1bit g3(a[i], add_finv[i], sub_carry2[i], out[i], sub_carry2[i+1]);
  	end
  	endgenerate
	
	xor_1bit g4(sub_carry2[64], sub_carry2[63],overflow);

always @(*) begin

if (out == 64'd0) begin
	cf_sub[0] = 1'b1;
	

end else cf_sub[0] = 1'b0;

if(out[63]==1'b1) begin
	cf_sub[1] = 1'b1;
end else cf_sub[1] = 1'b0;

cf_sub[2] = overflow;

end

endmodule