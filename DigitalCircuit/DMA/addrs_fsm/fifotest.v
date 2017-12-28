`timescale 1ns/1ps

module FIFO_TEST();
reg clk;
reg resetn;
reg [7:0]in;
reg [7:0]out;

initial
begin
  clk=0;
  resetn=0;
  in=0;
  out=0;
end

always #50
begin
  clk<=~clk;
end

always@(posedge clk)
begin
  in<=$random;
end

