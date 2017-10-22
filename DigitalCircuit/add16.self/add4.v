module add4(add1,add2,cin,out,cout);
input [3:0]add1,add2;
input cin;
output [3:0]out;
output cout;

assign {cout,out}=add1+add2+cin;

endmodule


