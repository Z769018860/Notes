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

	//公用加法器逻辑
	wire [`DATA_WIDTH:0]adder;
	wire [`DATA_WIDTH:0]addee;
	assign addee=((ALUop==`ADD)?B:~B+1);
	assign adder=A+addee; //共用加法器

	//标志位输出逻辑
	assign CarryOut=adder[32];

	assign Zero=({Result}==0);

	assign Overflow=
		((ALUop==`ADD)?
		(A[`DATA_WIDTH - 1]==B[`DATA_WIDTH - 1])&&(adder[`DATA_WIDTH - 1]!=A[`DATA_WIDTH - 1]):
		(A[`DATA_WIDTH - 1]!=B[`DATA_WIDTH - 1])&&(adder[`DATA_WIDTH - 1]!=A[`DATA_WIDTH - 1]));
	
	//选择器逻辑
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
					Result=adder;
				end
		  	`SUB:
			  	begin
					Result=adder;
				end
			default:
		  	// `SLT:
			  	begin
					Result[`DATA_WIDTH-1:1]=0;
					Result[0]=adder[`DATA_WIDTH-1]^Overflow;
				end
		endcase
	end

endmodule
