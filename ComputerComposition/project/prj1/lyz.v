`timescale 10 ns / 1 ns

`define DATA_WIDTH 32

module alu(
	input [`DATA_WIDTH - 1:0] A,
	input [`DATA_WIDTH - 1:0] B,
	input [2:0] ALUop,
	output Overflow,
	output CarryOut,
	output Zero,
	output [`DATA_WIDTH - 1:0] Result
);
	reg [`DATA_WIDTH + 1:0] result;
	wire [`DATA_WIDTH + 1 :0] middle1;
	wire [`DATA_WIDTH :0] middle3;
	// TODO: Please add your logic code here
	always @(*)
	begin 
		case(ALUop)
			3'b000:
				result <= {A,1'b1} & middle3;
			3'b001:
				result <= {A,1'b1} | middle3;
			3'b010:
				result <= middle1;
			3'b110:
				result <= middle1;
			3'b111:
				result <= (middle1[32])^Overflow;
			default:
				result <= 32'b0;  
		endcase
	end
	assign middle1 = {A,1'b1} + middle3;
	assign middle3 = ALUop[2]? {~B,1'b1}:{B,1'b0};
	assign Zero = (Result)?1'b0:1'b1;
	assign Result = result[32:1];
	assign CarryOut = ALUop[2]^middle1[33];
	assign Overflow = ((middle3[32]&A[31]&~middle1[32])|(~middle3[32]&~A[31]&middle1[32]))&(~ALUop[2]|(B[31]^A[31]));
endmodule
