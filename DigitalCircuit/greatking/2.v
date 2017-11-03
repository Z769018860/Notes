`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 00:42:11
// Design Name: 
// Module Name: text
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_fsm;
  reg clk,rst;
  reg  a,b;
  wire [3:0] out;
  mealyfsm 
    fsm(.clk(clk),.rst(rst),.a(a),.b(b),.out(out));
    initial
    begin
$dumpfile("out.vcd");  
   $dumpvars(0,tb_fsm);
      a = 0;
      b = 0;
      clk = 0;
      rst = 1;
    end
    
    initial
    begin
      repeat (100) #7 clk=~clk;
      end
    
    initial
      repeat (34) 
      begin
      #23 a=~a;
      #23 b=~b;
      end
    
    initial
      begin
        #31 rst = 1;
        #23 rst = 0;
              $display("currentstate:%d nextstate:%d step:%d %d",fsm.currentstate,fsm.nextstate,a,b); 

      end
      
  /*initial
    begin
      clk = 0;
      rst = 1;
      #5 rst = 0;
      #3 rst = 1;
      #20 a = 0;b = 0;
      #20 b = 1;
      #20 a = 0;
      #20 b = 0;
      $display("currentstate:%d nextstate:%d step:%d %d",currentstate,nextstate,a,b);
      #10000;
      $finish;
    end;
  always #50 clk = ~clk;
$display("currentstate:%d nextstate:%d step:%d %d",currentstate,nextstate,a,b);*/
endmodule

