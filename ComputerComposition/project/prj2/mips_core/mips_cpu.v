`timescale 10ns / 1ns

`define INSTRUCTION_WIDTH 32
`define ALU_CODE_WIDTH 2
`define IST_CODE_WIDTH 6
`define ALUop_WIDTH 3

`define DATA_WIDTH 32
`define ADDR_WIDTH 5

//ISA
//--------------------
`define op_addiu 6'b001001
`define op_lw    6'b100011
`define op_sw    6'b101011
`define op_bne   6'b000101
`define op_beq   6'b000100
`define op_nop   6'b000000
//---------------------

module mips_cpu(
	input  rst,
	input  clk,

	output [31:0] PC,
	input  [31:0] Instruction,

	output [31:0] Address,
	output MemWrite,
	output [31:0] Write_data,
	output [3:0] Write_strb,

	input  [31:0] Read_data,
	output MemRead
);

//todo: addiu, lw, sw, bne, nop

//   ideal_mem		# (
// 	  .ADDR_WIDTH	(MEM_ADDR_WIDTH)
//   ) u_ideal_mem (
// 	  .clk			(mips_cpu_clk),
	  
// 	  .Waddr		(Waddr),
// 	  .Raddr1		(PC[MEM_ADDR_WIDTH - 1:2]),
// 	  .Raddr2		(Raddr),

// 	  .Wren			(Wren),
// 	  .Rden1		(1'b1),
// 	  .Rden2		(Rden),

// 	  .Wdata		(Wdata),
// 	  .Wstrb		(Wstrb),
// 	  .Rdata1		(Instruction),
// 	  .Rdata2		(Rdata)
//   );

	wire [`INSTRUCTION_WIDTH-1:0]PCset;
	// wire Instruction[31:26];
	wire RegDst;
    wire Branch;
    //wire MemRead;
    wire MemtoReg;
    wire [`ALU_CODE_WIDTH-1:0]ALUCodeOut;
    //wire MemWrite;
    wire ALUSrc;
    wire RegWrite;

	wire [`ADDR_WIDTH - 1:0]RegWaddr;
	wire [`ADDR_WIDTH - 1:0]RegRaddr1;
	wire [`ADDR_WIDTH - 1:0]RegRaddr2;
	wire Regwen;
	wire [`DATA_WIDTH - 1:0]RegWdata;
	wire [`DATA_WIDTH - 1:0]RegRdata1;
	wire [`DATA_WIDTH - 1:0]RegRdata2;

	wire ALUzero;

	//PC++ logic
	//IF

	pc PCreg(rst,clk,PCset,PC);

	wire [`DATA_WIDTH - 1:0]Add4Result;

	add Add4(	
		.A(PC),
		.B(4),
		.Result(Add4Result)
	);

	wire [`DATA_WIDTH - 1:0]AddOffsetResult;
	wire [`DATA_WIDTH-1:0]ShiftLeft2Out;

	add AddOffset(	
		.A(Add4Result),
		.B(ShiftLeft2Out),
		.Result(AddOffsetResult)

	);

	assign PCset=((((Instruction[26]==1)?~ALUzero:ALUzero)&Branch)?AddOffsetResult:Add4Result);

	wire [`DATA_WIDTH-1:0]SignExtendOut;
	wire NeedSignExtend;

	sign_extend SignExtend(
		.sign_extend_in(Instruction[15:0]),
		.sign_extend_out(SignExtendOut),
		.need_sign_extend(NeedSignExtend)
	);

	shift_left_2 ShiftLeft2(
		.shift_left_2_in(SignExtendOut),//todo: sign extend?
		.shift_left_2_out(ShiftLeft2Out)	
	);

	//Control logic
	//ID

	control Control(
		Instruction[31:26],
		RegDst,
    	Branch,
    	MemRead,
    	MemtoReg,
    	ALUCodeOut,
    	MemWrite,
    	ALUSrc,
    	RegWrite,
		NeedSignExtend,
		Write_strb
		);

	reg_file Registers(	
	 	clk,
	 	rst,
	 	RegWaddr,
	 	RegRaddr1,
	 	RegRaddr2,
	 	Regwen,
	 	RegWdata,
	 	RegRdata1,
	 	RegRdata2
		);

	assign RegWaddr=(RegDst?Instruction[15:11]:Instruction[20:16]);
	assign RegRaddr1=Instruction[25:21];
	assign RegRaddr2=Instruction[20:16];
	assign Regwen=RegWrite;

	//ALU logic
	//EX

	wire [`ALUop_WIDTH-1:0]ALUopOut;

	alu_control ALUcontrol(
    	.alu_code_in(ALUCodeOut),
		.ist_code_in(Instruction[5:0]),
		.aluop_out(ALUopOut)
	);

	wire [`DATA_WIDTH-1:0]ALUResult;

	alu ALU(
		.A(RegRdata1),
		.B(ALUSrc?SignExtendOut:RegRdata2),
		.ALUop(ALUopOut),
		.Result(ALUResult),
		.Zero(ALUzero)
	);

	//data memory
	//MEM

	assign Address=ALUResult;
	
	// output MemWrite
	
	assign Write_data=RegRdata2;
	
	//output [3:0] Write_strb,

	//output MemRead

	//WB
	assign RegWdata=(MemtoReg?Read_data:ALUResult);

endmodule

