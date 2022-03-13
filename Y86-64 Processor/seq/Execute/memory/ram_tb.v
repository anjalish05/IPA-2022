`timescale 1ns / 1ps
module ram_test;

    reg [3:0] icode;
    wire [63:0] memaddr;
    wire [63:0] memdata;
    reg [63:0] valE;
    reg [63:0] valA;
    reg [63:0] valP;
    wire [63:0] valM;
    wire read;
    wire write;

    RAM ram1(.memaddr(memaddr),.memdata(memdata),.read(read),.write(write),.valM(valM),.dmemerror(dmemerror));
    MEM_addr Ma(.icode(icode),.valA(valA),.valE(valE),.memaddr(memaddr));
    MEM_read Mr(.icode(icode),.read(read));
    MEM_write Mw(.icode(icode),.write(write));
    MEM_data Md(.icode(icode),.valA(valA),.valP(valP),.memdata(memdata));    

    
    integer k;
    parameter base_addr = 64'hFF;

    
    initial begin
    $dumpfile("ram_test.vcd");
    $dumpvars(0,ram_test);

    
    for(k=0;k<10;k++)
    begin
        icode <= 4'h4;
        valE  <= k + base_addr;
        valA  <= k+ $random;
        #10;
    end

    for(k=0;k<10;k++)
    begin
        icode <= 4'h5;
        valE  <= k + base_addr;
        #10;
    end

    #20 $finish;
        
    end

    
    


endmodule