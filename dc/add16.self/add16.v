module add16(in1,in2,cin,out,cout);
input [15:0]in1,in2;
input cin;
output [15:0] out;
output cout;
wire wire1,wire2,wire3;
wire [3:0]add1,add2,add3,add4,bdd1,bdd2,bdd3,bdd4;

assign {add4,add3,add2,add1}=in1;
assign {bdd4,bdd3,bdd2,bdd1}=in2;
add4 a1(add1,bdd1,cin,out[3:0],wire1);
add4 a2(add2,bdd2,wire1,out[7:4],wire2);
add4 a3(add3,bdd3,wire2,out[11:8],wire3);
add4 a4(add4,bdd4,wire3,out[15:12],cout);

endmodule