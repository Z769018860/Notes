`timescale 1ns/1ps

module smalltest;
reg [15:0]a;
reg [15:0]b;
wire cout;
wire [15:0]out;
reg cin;

add16 x16(a,b,cin,out,cout);

initial
begin
a=65535;
b=1;
cin=1;
#50;
$display("%d %d %d %d %d",a,b,cin,cout,out);
$finish;
end

endmodule