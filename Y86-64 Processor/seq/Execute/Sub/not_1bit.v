`timescale 1ns / 1ps

module not_1bit (
    input a,
    output no
);
reg no;

always @(a) begin
    
    if (a == 1'b0)
    begin
        no = 1'b1;
    end

    else if (a == 1'b1)
    begin
        no = 1'b0;
    end
end

endmodule