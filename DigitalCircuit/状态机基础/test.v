`timescale 1ns/1ps
module test;
reg inn;
wire out;

alpha alpha_instance(inn,out);

initial inn=0;

initial
begin
  $dumpfile(out.vcd);
  $dumpvars(0,test);
  $monitor("inn:",inn,"out",out);
  $monitoron;
end

endmodule;