`timescale 1ns/1ps

`include "../Add/add_1bit.v"
`include "../Xor/xor_1bit.v"
`include "../Or/or_1bit.v"


module add_1bit(
	input a,
	input b,
	input cin,
	output sum,
	output cout);


 xor g1(sum,a,b,cin);
  and g2(k,a,b);
  and g3(l,a,cin);
  and g4(m,b,cin);
  or g5(co,k,l,m);
