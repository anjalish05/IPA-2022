`timescale 1ns / 1ps

module not_64bit (
    input signed [63:0]a,
    output signed [63:0]out
);

genvar i;

generate for(i = 0; i < 64; i = i + 1)
begin
    not_1bit g1(a[i], out[i]);
end

endgenerate

endmodule