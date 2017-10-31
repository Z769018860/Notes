`timescale 1ns/1ps
module testfsm;
reg in;
wire out;
reg reset;

fsm alpha_instance(in,out,reset);

initial
begin
in=0;
reset=0;
end

initial
begin
  $dumpfile("out.vcd");
  $dumpvars(0,testfsm);
//   $monitor("inn:",in,"out",out);
//   $monitoron;
  # 5000;
  reset=1;
  #10000;
  $finish;
end

endmodule