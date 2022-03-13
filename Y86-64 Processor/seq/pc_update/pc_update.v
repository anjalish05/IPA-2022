`timescale 1ns / 1ps

module pc_update(clk, cnd, icode, valC, valM, valP, newpc);

input clk, cnd;
input [63:0] valC; 
input [63:0] valM; 
input [63:0] valP;  
input [3:0] icode;

output reg [63:0] newpc;

always@(*) begin
    

    if (icode == 4'b0111) //icode = 7
    begin
        if(cnd == 1'b1)
        begin
            newpc <= valC;
        end
        else begin
            newpc <= valP;
        end
    end

    else if (icode == 4'b1000) // icode = 8; for call
    begin 
        newpc <= valC;
    end

    else if (icode == 4'b1001) // icode = 9; for ret 
    begin
        newpc <= valM;
    end
    else
    begin
        newpc<= valP;
    end
    
    
end
endmodule