`timescale 1ns/1ps

module test;
reg [15:0]adda;
reg [15:0]addb;
wire [15:0]out;
reg cin;
wire cout;
reg clk;

add16 a16(adda,addb,cin,out,cout);

initial
    begin
      $dumpfile("out.vcd");
      $dumpvars(0,test);
      $display("Start test.");
      clk=0;
      adda=0;
      addb=0;
      cin=0;
    //   cout=0;wire不能被直接赋值？!
      #10000;
      $finish;
    end

always@(posedge clk)
begin
    adda={$random}%65536;
    addb={$random}%65536;
    // addb={$random%(2*16)};
    cin={$random}%2;
    #50
    $display("a%d b%d cin%d cout%d out%d a+b%d total%d",adda,addb,cin,cout,out,adda+addb+cin,cout*65536+out);
    if (cout*65536+out==adda+addb+cin) 
    begin
    $display("Correct");  
    end
end

always #50 clk=~clk;

endmodule