`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 01:05:16
// Design Name: 
// Module Name: mealyfsm
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


module mealyfsm(clk,rst,a,b,out);
     input     clk;
     input     rst;
     input     a;
     input     b;
     output    [3:0] out;
     reg [3:0] currentstate,nextstate;
     reg [3:0] out;
     parameter S0 = 4'b0000;
     parameter S1 = 4'b0001;
     parameter S2 = 4'b0010;
     parameter S3 = 4'b0011;
     parameter S4 = 4'b0100;
     parameter S5 = 4'b0101;
always@(posedge clk or negedge rst)
    if(!rst)
      currentstate <= S0;
    else
      currentstate <= nextstate;
always@(currentstate or a or rst)
    if(!rst)
      nextstate = S0;
    else 
      case(currentstate)
        S0: if (a==1) nextstate = (b == 1)? S1 : S5;
                      else 
                      begin
                      nextstate = S0;
                      $display("Error404:Undefined Step!");
                      end
        S1: if (a==1&&b==0)nextstate = S4;
                           else if (a==0&&b==1) nextstate = S3;
                           else 
                           begin
                           nextstate = S1;
                           $display("Error404:Undefined Step!");
                           end
        S2: if (a==0&&b==0)nextstate = S1;
                           else if (a==1&&b==0) nextstate = S5;
                           else 
                           begin
                           nextstate = S2;
                           $display("Error404:Undefined Step!");
                           end
        S3: if (a==0&&b==0)nextstate = S2;
                           else if (a==1&&b==0) nextstate = S4;
                           else 
                           begin
                           nextstate = S3;
                           $display("Error404:Undefined Step!");
                           end
        S4: if (a==1&&b==0)nextstate = S3;
                           else if (a==0&&b==1) nextstate = S5;
                           else 
                           begin
                           nextstate = S4;
                           $display("Error404:Undefined Step!");
                           end
        S5: if (a==0&&b==0)nextstate = S5;
                           else if (a==1&&b==0) nextstate = S1;
                           else 
                           begin
                           nextstate = S5;
                           $display("Error404:Undefined Step!");
                           end
        default:nextstate = S0;
      endcase 
always @(currentstate)
begin
  case(currentstate)
      S0:out = 4'b0000;
      S1:out = 4'b0001;
      S2:out = 4'b0010;
      S3:out = 4'b0011;
      S4:out = 4'b0100;
      S5:out = 4'b0101;
      default:out = 4'b0000;
  endcase
end
endmodule 