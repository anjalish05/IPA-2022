`timescale 1ns / 1ps

module alu_tb;

	reg signed [63:0]a;
	reg signed [63:0]b;
	wire signed [63:0]out;
	wire  [2:0]cf;
	reg [1:0] control;

	alu dut(.a(a), .b(b), .control(control), .out(out), .cf(cf));

	
	initial begin
		$dumpfile("alu.vcd");
		$dumpvars(0,alu_tb);


  control = 2'b00;
  
  a=64'b1011;
  b=64'b0100;

  repeat(2) begin
    #2 control = control + 2'b01;    
    #2 control = control + 2'b01;
    #2 control = control + 2'b01; 
    #2 begin
      control = control + 2'b01; 
      a = -a;
    end

    #2 control = control + 2'b01;    
    #2 control = control + 2'b01;
    #2 control = control + 2'b01; 
    #2 begin
      control = control + 2'b01;  
      b = -b;
    end
  end
 
  #2 a = 64'b0111111111111111111111111111111111111111111111111111111111111111;

  repeat(2) begin 
    #2 control = control + 2'b01;    
    #2 control = control + 2'b01;
    #2 control = control + 2'b01; 


    #2 begin
      control = control + 2'b01; 
      b = 64'b0000000000000000000000000000000000000000000000000000000000000001;

    end

  end

  end
 
  initial 
		$monitor("control = %d a=%d b=%d  out=%d  cf=%b\n",control,a,b,out,cf);

endmodule