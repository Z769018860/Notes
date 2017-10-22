module test;
reg cin;
reg [3:0] a;
reg [3:0] b;
wire[3:0] out;
wire cout;
wire cin1,cin2,cin3;
reg clk;
initial
begin
$dumpfile("out.vcd");
$dumpvars(0,test);
$display("Start test.");
clk=0;
a=0;
b=0;
cin=0;
#10000;
$finish;
end

always#50 clk=~clk;
always@(posedge clk)
begin
    a={$random}%16;
    b={$random}%16;
    cin={$random}%2;
    $display("a=%d,b=%d,cin=%d,out=%d,cout=%d\n",a,b,cin,out,cout);
    end
    add_4 u_add_4(.a(a),.b(b),.cin(cin),.out(out),.cout(cout));

    
endmodule
