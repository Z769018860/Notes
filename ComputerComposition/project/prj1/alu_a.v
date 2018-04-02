`timescale 10 ns / 1 ns

`define DATA_WIDTH 32
`define AND 3'b000
`define OR 3'b001
`define ADD 3'b010
`define SUB 3'b110
`define SLT 3'b111
`define todo 1
`define UNDEFINED 0

module alu(
	input [`DATA_WIDTH - 1:0] A,
	input [`DATA_WIDTH - 1:0] B,
	input [2:0] ALUop,
	output Overflow,
	output CarryOut,
	output Zero,
	output [`DATA_WIDTH - 1:0] Result
);
	wire [`DATA_WIDTH : 0]adder;
	wire [`DATA_WIDTH : 0]suber;
	wire [`DATA_WIDTH : 0]ander;
	wire [`DATA_WIDTH : 0]orer;
	
	assign adder=A+B;
	assign suber=A+~B+1;
	assign ander=A&B;
	assign orer=A|B;

	assign Zero=({Result}==0);
	assign CarryOut=((ALUop==`ADD)?adder[`DATA_WIDTH]:suber[`DATA_WIDTH]);
	
always@*
begin
	case(ALUop[2:0])
		`AND:
			begin
				Result=ander;
			end
		`OR:
			begin
				Result=orer;
			end
	  	`ADD:
		  	begin
				Overflow=(A[`DATA_WIDTH - 1]==B[`DATA_WIDTH - 1])&&(Result[`DATA_WIDTH - 1]!=A[`DATA_WIDTH - 1]);
			end
	  	`SUB:
		  	begin
				Overflow=(A[`DATA_WIDTH - 1]!=B[`DATA_WIDTH - 1])&&(Result[`DATA_WIDTH - 1]!=A[`DATA_WIDTH - 1]);
			end
		default:
	  	// `SLT:
		  	begin
				Overflow=(A[`DATA_WIDTH - 1]!=B[`DATA_WIDTH - 1])&&(Temp[`DATA_WIDTH - 1]!=A[`DATA_WIDTH - 1]);
				Result[`DATA_WIDTH-1:1]=0;
				Result[0]=Temp[`DATA_WIDTH-1]^Overflow;
			end
	endcase
end

endmodule
