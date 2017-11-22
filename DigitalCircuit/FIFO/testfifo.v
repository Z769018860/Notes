`timescale 1ns/1ps
module test();

reg clk;
reg [3:0] Data_In;
reg input_enable,output_enable;
reg rst;
wire [7:0] Data_Out;
wire input_valid,output_valid;
// reg [7:0] Data_Out;
// reg [7:0] ram [7:0];
// reg writelow;//写入低高位控制
// reg [2:0]pos_write,pos_read;


fifo insfifo(clk,rst,Data_In,Data_Out,input_valid, output_valid, input_enable, output_enable);

initial
begin
  clk=0;
  rst=1;
  // input_valid=0;
  input_enable=0;
  // output_valid=0;
  output_enable=0;
  Data_In=0;
//   Data_Out=0;
$dumpfile("out.vcd");
$dumpvars(0,test);
$display("Start test.");
  #100
  $monitor(input_valid, input_enable, output_valid, output_enable,Data_In,Data_Out);
  setlong(30);
  set(1);
  set(0);
  set(2);
  set(0);
  set(0);
  set(1);
  set(3);
  set(3);
  set(3);
  set(3);
  set(3);
  set(3);
  set(3);
  set(3);
  set(3);
  set(3);
  get();
  set(0);
  set(2);
  get();
  set(0);
  set(0);
  get();
  set(0);
  set(0);
  get();
  setlong(1);
  get();
  setlong(1);
  get();
  setlong(1);
  get();
  setlong(1);
  get();
  setlong(1);
  get();
  setlong(1);
  get();
  repeat(100)
  begin
  randomtest();
  end
  $finish;
  end

always #50 clk=~clk;

// always@(posedge clk)begin
task set(toset);
integer toset;
begin
Data_In=toset;
input_enable=1;
// input_valid=1;
output_enable=0;
// output_valid=0;
rst=0;
#100;
end
endtask

task get();
begin
rst=0;
input_enable=0;
// input_valid=0;
output_enable=1;
// output_valid=1;
#100;
$display("%d",Data_Out);
end
endtask

task setlong(integer a);
begin
set(a%'b10000);
set(a>>4);
end
endtask

task randomtest();
begin

input_enable=$random % 2;
output_enable=$random % 2;
Data_In=$random % 16;
#100;

end
endtask

endmodule