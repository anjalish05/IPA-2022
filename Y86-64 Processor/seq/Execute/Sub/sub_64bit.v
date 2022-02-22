`timescale 1ns / 1ps


module sub_64bit (a, b, out, overflow);

input signed [63:0]a;
input signed [63:0]b;
output signed [63:0]out;
output overflow;

wire [63:0]no; // no = not output
not_64bit g1(b, no); // inverting bits of input b

wire [63:0]finv; // for final inversion
assign finv = 64'b1;

wire [63:0]add_finv;
add_64bit g2(finv, no, add_finv, fadd);

add_64bit g3(a, add_finv, out, overflow);

endmodule