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
`define special  6'b000000
//---------------------

//branch
`define nop 3'b000
`define bne 3'b001
`define beq 3'b010
`define j 3'b011
`define use_branch_controler 3'b100 //use branch_controler to control PC 


//alu_src
//alu_src=1;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
`define readdata2  2'b00
`define signextend 2'b01
`define upper16    2'b10
`define wtfitis    2'b11

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
    wire [2:0]Branch;
    //wire MemRead;
    wire MemtoReg;
    wire [`ALU_CODE_WIDTH-1:0]ALUCodeOut;
    //wire MemWrite;
    wire [1:0]ALUSrc;
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

	wire [`DATA_WIDTH - 1:0]Add8Result;	
	add Add8(	
		.A(PC),
		.B(8),
		.Result(Add8Result)
	);

	wire [`DATA_WIDTH - 1:0]AddOffsetResult;
	wire [`DATA_WIDTH-1:0]ShiftLeft2Out;

	add AddOffset(	
		.A(Add4Result),
		.B(ShiftLeft2Out),
		.Result(AddOffsetResult)
	);

	wire [`INSTRUCTION_WIDTH-1:0]LongJumpPC;
	wire [`INSTRUCTION_WIDTH-1:0]BranchControlerOut;
	wire RegtoPC;//It will only work in the status of nop
	wire BranchEnable;
	wire [`DATA_WIDTH-1:0]ALURealResult;

	assign LongJumpPC={PC[31:28],Instruction[25:0],2'b00};
	//todo
	assign PCset=
		(((Branch==`bne)&!ALUzero)?AddOffsetResult:
		((Branch==`beq)&ALUzero)?AddOffsetResult:
		((Branch==`j)?LongJumpPC:
		((Branch==`use_branch_controler)?BranchControlerOut:
		((RegtoPC)?ALURealResult:
		Add4Result))));
		
	assign BranchControlerOut=
		((BranchEnable)?AddOffsetResult:Add4Result);

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

	wire [2:0]AdditionalControl;
	wire [3:0]ExtenderControl;
	wire JAL;
	wire OWmemwriteset;
	wire [3:0]CWrite_strb;
	wire [3:0]OWrite_strb;
	assign Write_strb=(OWmemwriteset?OWrite_strb:CWrite_strb);

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
		CWrite_strb,
		AdditionalControl,
		ExtenderControl,
		JAL,
		OWmemwriteset,
		ALURealResult[1:0]
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

	wire   RegRdata2Zero;
	assign RegRdata2Zero=(RegRdata2==0);

	wire [1:0]ConditionalMove;

	//conditional_move
	`define normal_move 2'b00 
	`define zero_move 2'b01 
	`define nzero_move 2'b11 

	assign RegWaddr=((JAL?5'b11111:
					(RegDst?Instruction[15:11]:Instruction[20:16])));
	assign RegRaddr1=Instruction[25:21];
	assign RegRaddr2=Instruction[20:16];
	assign Regwen=(ConditionalMove[0]?
					((ConditionalMove==`zero_move)?RegRdata2Zero:(!RegRdata2Zero)):
					RegWrite);

	//ALU logic
	//EX

	wire [`ALUop_WIDTH-1:0]ALUopOut;
	wire EnableShifter;
	wire PCNexttoReg;

	wire [1:0]ShiftMode;
	wire ShiftSource;

	alu_control ALUcontrol(
    	.alu_code_in(ALUCodeOut),
		.ist_code_in(Instruction[5:0]),
		.additional_control(AdditionalControl),
		.aluop_out(ALUopOut),
		.enable_shifter(EnableShifter),
		.reg_to_pc(RegtoPC),
		.pcnext_to_reg(PCNexttoReg),
		.conditional_move(ConditionalMove),
		.shiftmode(ShiftMode),
        .shiftsource(ShiftSource)
	);

	// wire [`INSTRUCTION_WIDTH-1:0]JudgeData;
	branch_control BranchControl(
		// .branch(Branch),
		.branch_instruction(Instruction[20:16]),//Instruction[20:16]
		.branch_op(AdditionalControl),
    	.judge_data(RegRdata1),
    	.branch_enable(BranchEnable),
		.sign(ALURealResult[31]),
		.zero(ALUzero)
	);

	wire [`DATA_WIDTH-1:0]ShifterOutput;
	
	wire [`DATA_WIDTH-1:0]ALUResult=(EnableShifter?ShifterOutput:ALURealResult);
	wire [`DATA_WIDTH-1:0]Upper16Out=({Instruction[15:0],16'b0000_0000_0000_0000});

	alu ALU(
		.A(RegRdata1),
		.B(
			(ALUSrc==`readdata2)?RegRdata2:
			(ALUSrc==`signextend)?SignExtendOut:
		 	(ALUSrc==`upper16)?Upper16Out:
		 	RegRdata2),
		.ALUop(ALUopOut),
		.Result(ALURealResult),
		.Zero(ALUzero)
	);



	shifter Shifter(
		.shiftmode(ShiftMode),
    	.source(ShiftSource),
    	.shiftbit(Instruction[10:6]),
		.reg_shiftbit(RegRdata1),
    	.shifter_input(RegRdata2),
    	.shifter_output(ShifterOutput)
	);

	//data memory
	//MEM

	assign Address=ALURealResult;
	
	wire [31:0]MemExtended;
	// output MemWrite
	wire ShiftWriteData;
	assign Write_data=((ShiftWriteData)?MemExtended:RegRdata2);
	
	//output [3:0] Write_strb,

	//output MemRead

	//WB

	extender Extender(
		.extender_control(ExtenderControl),
	    .mem_input(Read_data),
		.reg_input(RegRdata2),
		.ea(ALURealResult[1:0]),
	    .extender_output(MemExtended),
		.owstrb(OWmemwriteset),
		.strb(OWrite_strb),
		.shift(ShiftWriteData)
	);

	assign RegWdata=(JAL?Add8Result:
				(PCNexttoReg?Add8Result:
				(MemtoReg?MemExtended:
				(ConditionalMove[0]?RegRdata1://条件移动指令, 注意修改define时应谨慎
				ALUResult))));

endmodule
