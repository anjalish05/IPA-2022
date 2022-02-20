`timescale 1ns / 1ps


module add_1bit(
  input a,
  input b,
  input cin,
  output sum,
  output co);

  xor_1bit g1(a,b, d);
  xor_1bit g2(cin, d,sum);

  and_1bit g3(a, b,k);
  and_1bit g4(a, cin,l);
  and_1bit g5(b, cin,m);
  
  or_1bit g6(m, k, q);
  or_1bit g7(q, l,co);

endmodule