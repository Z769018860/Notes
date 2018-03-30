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


	reg Overflow;
	reg CarryOut;
	// reg Zero;
	reg [`DATA_WIDTH - 1:0] Result;
	reg [`DATA_WIDTH-1:0] Temp;

	assign Zero=({Result}==0);

always@*
begin
	case(ALUop[2:0])
		`AND:
			begin
				{CarryOut,Result}=A&B;			
				Overflow=`UNDEFINED;
				Temp=`UNDEFINED;
			end
		`OR:
			begin
				{CarryOut,Result}=A|B;			
				Overflow=`UNDEFINED;
				Temp=`UNDEFINED;				
			end
	  	`ADD:
		  	begin
				{CarryOut,Result}=A+B;
				Overflow=(A[`DATA_WIDTH - 1]==B[`DATA_WIDTH - 1])&&(Result[`DATA_WIDTH - 1]!=A[`DATA_WIDTH - 1]);
				Temp=`UNDEFINED;
				
			end
	  	`SUB:
		  	begin
				{CarryOut,Result}=A+~B+1;
				Overflow=(A[`DATA_WIDTH - 1]!=B[`DATA_WIDTH - 1])&&(Result[`DATA_WIDTH - 1]!=A[`DATA_WIDTH - 1]);
				Temp=`UNDEFINED;
				
				//todo Overflow
			end
	  	`SLT:
		  	begin
				{CarryOut,Temp}=A+~B+1;
				Overflow=(A[`DATA_WIDTH - 1]!=B[`DATA_WIDTH - 1])&&(Temp[`DATA_WIDTH - 1]!=A[`DATA_WIDTH - 1]);
				Result[`DATA_WIDTH-1:1]=0;
				Result[0]=Temp[`DATA_WIDTH-1]^Overflow;
			end
		default:
			begin
			    {CarryOut,Temp}=`UNDEFINED;
				Overflow=`UNDEFINED;
				Temp=`UNDEFINED;				
			end
	endcase
end

endmodule
