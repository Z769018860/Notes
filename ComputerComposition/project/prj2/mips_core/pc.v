`timescale 10ns / 1ns

`define INSTRUCTION_WIDTH 32


module pc(
	input  rst,
	input  clk,

    input [31:0] PCset,
	output reg[31:0] PC
);

    always@(posedge clk)
    begin
      if(rst)
        begin
            PC<=0;
        end
    else
        begin
            PC<=PCset;
        end
    end

endmodule

