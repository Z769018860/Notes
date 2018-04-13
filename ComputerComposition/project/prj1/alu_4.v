//有一个多余加法器的版本

`timescale 10 ns / 1 ns

`define DATA_WIDTH 32
`define AND 3'b000
`define OR 3'b001
`define ADD 3'b010
`define SUB 3'b110
`define SLT 3'b111

module alu(
	input [`DATA_WIDTH - 1:0] A,
	input [`DATA_WIDTH - 1:0] B,
	input [2:0] ALUop,
	output Overflow,
	output CarryOut,
	output Zero,
	output reg [`DATA_WIDTH - 1:0] Result
);

	// reg [`DATA_WIDTH - 1:0] Result;
	wire [`DATA_WIDTH:0] AplusB;//A+B
	wire [`DATA_WIDTH:0] AminusB;//A+~B+1

	assign Zero=({Result}==0);
	assign AplusB=A+B;
	assign AminusB=A+~B+1;
	assign Overflow=
		((ALUop==`ADD)?
		(A[`DATA_WIDTH - 1]==B[`DATA_WIDTH - 1])&&(Result[`DATA_WIDTH - 1]!=A[`DATA_WIDTH - 1]):
		(A[`DATA_WIDTH - 1]!=B[`DATA_WIDTH - 1])&&(AminusB[`DATA_WIDTH - 1]!=A[`DATA_WIDTH - 1]));
	
	assign CarryOut=
		((ALUop==`ADD)?
		AplusB[`DATA_WIDTH]:
		AminusB[`DATA_WIDTH]);


always@*
begin
	case(ALUop[2:0])
		`AND:
			begin
				Result=A&B;			
			end
		`OR:
			begin
				Result=A|B;			
			end
	  	`ADD:
		  	begin
				Result=AplusB;
			end
	  	`SUB:
		  	begin
				Result=AminusB;
			end
		default:
	  	// `SLT:
		  	begin
				Result[`DATA_WIDTH-1:1]=0;
				Result[0]=AminusB[`DATA_WIDTH-1]^Overflow;
			end
	endcase
end

endmodule
