// shift_left_2.v

`timescale 10 ns / 1 ns

`define OUTPUT_WIDTH 32

module shift_left_2(
	input [`OUTPUT_WIDTH-1:0]shift_left_2_in,
	output [`OUTPUT_WIDTH-1:0]shift_left_2_out
);

	assign shift_left_2_out={shift_left_2_in[`OUTPUT_WIDTH-3:0],2'b00};

endmodule

