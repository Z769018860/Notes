module add_4(a,b,cin,out,cout);
input[3:0] a;
input[3:0] b;
input cin;
output[3:0] out;
output cout;
wire cin1,cin2,cin3;

assign out[0]=a[0]^b[0]^cin;
assign cin1=a[0]&b[0]|a[0]&cin|b[0]&cin;
assign out[1]=a[1]^b[1]^cin1;
assign cin2 = a[1]&b[1]|a[1]&cin1|b[1]&cin1;
assign out[2]=a[2]^b[2]^cin2;
assign cin3 = a[2]&b[2]|a[2]&cin2|b[2]&cin2;
assign out[3]=a[3]^b[3]^cin3;
assign cout = a[3]&b[3]|a[3]&cin3|b[3]&cin3;
endmodule


