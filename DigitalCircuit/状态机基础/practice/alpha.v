`timescale 1ns/1ps
module alpha(a,out);
input a;
output out;
parameter
status1=2'd0,
status2=2'd1,
status3=2'd2,
status4=2'd3;
wire status_now;
reg clk;
// reg goto;

initial
begin
  clk=0;
  status_now=ststus1;
end

always@(posedge clk)
begin
    case(status_now)
    status1:
        if(a==1)status_now=status2;
    status2:status_now=status3;
    status3:status_now=status1;
    status4:status_now=status1;
    default:status_now=status2;
end

always #50 clk=~clk;

endmodule