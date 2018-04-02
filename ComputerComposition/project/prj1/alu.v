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
	output [`DATA_WIDTH - 1:0] Result
);


	reg CarryOut;
	// reg Zero;
	reg [`DATA_WIDTH - 1:0] Result;
	wire [`DATA_WIDTH-1:0] Temp;//A+~B+1

	assign Zero=({Result}==0);
	assign Temp=A+~B+1;
	assign Overflow=
		((ALUop==`ADD)?
		(A[`DATA_WIDTH - 1]==B[`DATA_WIDTH - 1])&&(Result[`DATA_WIDTH - 1]!=A[`DATA_WIDTH - 1]):
		(A[`DATA_WIDTH - 1]!=B[`DATA_WIDTH - 1])&&(Temp[`DATA_WIDTH - 1]!=A[`DATA_WIDTH - 1]));

always@*
begin
	case(ALUop[2:0])
		`AND:
			begin
				{CarryOut,Result}=A&B;			
			end
		`OR:
			begin
				{CarryOut,Result}=A|B;			
			end
	  	`ADD:
		  	begin
				{CarryOut,Result}=A+B;
			end
	  	`SUB:
		  	begin
				{CarryOut,Result}=A+~B+1;
			end
		default:
	  	// `SLT:
		  	begin
				Result[`DATA_WIDTH-1:1]=0;
				Result[0]=Temp[`DATA_WIDTH-1]^Overflow;
			end
	endcase
end

endmodule
