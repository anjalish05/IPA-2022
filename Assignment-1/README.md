# Assignment 1   
Group Assignment 
My Teammate: Rohan Gupta 

### Build An ALU

You are expected to build an ALU unit with following functionality: 

* ADD – 64 bits   

* SUB – 64 bits  

* AND – 64 bits 

* XOR – 64 bits 

You are not allowed to use +, -, &, ^ directly on the 64-bit inputs for 64-bit operations. We expect you to write each of the above modules from scratch. 

All input and output should be signed and use 2’s complement for the subtraction. 

Write a final wrapper ALU unit from where you will call the modules mentioned above based on the control input. The ALU unit takes as input the control signal, and two 64-bit inputs, and returns the 64-bit output corresponding to the control signal chosen. An example with 64-bit inputs x and y: 

    Control 0 - ADD x and y 
    
    Control 1 – Subtract y from x 
    
    Control 2 – AND x and y 
    
    Control 3 – XOR x and y 
