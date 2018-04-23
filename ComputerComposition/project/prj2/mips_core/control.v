// control.v

`timescale 10 ns / 1 ns

`define ALU_CODE_WIDTH 2
`define IST_CODE_WIDTH 6
`define ALUop_WIDTH 3

`define INSTRUCTION_WIDTH 32
`define CONTROL_READ_WIDTH 6

`define R 2'b10
`define Store 2'b00
`define Load 2'b00
`define StoreLoad 2'b00
`define Beq 2'b01

`define op_addiu 6'b001001
`define op_lw    6'b100011
`define op_sw    6'b101011
`define op_bne   6'b000101
`define op_beq   6'b000100
`define op_nop   6'b000000

module control(
	input [`CONTROL_READ_WIDTH-1:0]instruction_31_26,
	output reg reg_dst,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [`ALU_CODE_WIDTH-1:0]alu_code_out,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write,
    output reg need_sign_extend,
    output reg [3:0]mem_write_set
);

	// assign aluop_out=
    // ((alu_code_in==`R)?0:
    // ((alu_code_in==`S)?1:
    // ((alu_code_in==`L)?0:
    // (0))));//(alu_code_in==`X)0))));

    // always@*
    // begin
    //   case(instruction_31_26)
        
    //     default:
    //         begin
    //           //many todo
    //         end
    //   endcase
        
    // end
always@*
begin

//todo: addiu, lw, sw, bne, nop

    case(instruction_31_26)
        `op_addiu: //ADDIU
        begin
            //Add Immediate Unsigned Word
            //Description: rt <- rs + immediate
            //附注: 从这里可以看出立即数操作被视为访存指令的原因, 所有寄存器操作指令指令中用到低6位来控制ALU
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=1;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=0;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=0;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
        end

        `op_lw: //LW
        begin
            //Load Word
            //Description: rt <- memory[base+offset]
            //附注: 
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=1;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=1;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=1;//enable memread
            mem_write=0;//enable memwrite
            branch=0;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}            
            
        end

        `op_sw: //SW
        begin
            //Store Word
            //Description: memory[base+offset] <- rt
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=1;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=0;//enable reg write
            mem_read=0;//enable memread
            mem_write=1;//enable memwrite
            branch=0;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead            
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            
        end

        `op_bne: //BNE
        begin
            //Branch on Not Equal
            //Description:if rs != rt then branch
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=0;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=0;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=1;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`Beq;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead   
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            
        end

        `op_beq: //BEQ
        begin
            //Branch on Equal
            //Description:if rs = rt then branch
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=0;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=0;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=1;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`Beq;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            
        end

        `op_nop: //NOP
        begin

        //todo
            //Add Immediate Unsigned Word
            //Description: do nothing
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=1;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=0;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=0;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=0;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            
            
        end

        
        default:
        begin
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=1;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=0;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=0;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            
        end


    endcase
end
    // wire Rformat;
    // wire lw;
    // wire sw;
    // wire beq;

    // assign Rformat=instruction_31_26==6'b000000;
    // assign lw=instruction_31_26==6'b100011;
    // assign sw=instruction_31_26==6'b101011;
    // assign beq=instruction_31_26==6'b000100;

    // assign reg_dst=Rformat;
    // assign alu_src=lw|sw;
    // assign mem_to_reg=lw;
    // assign reg_write=Rformat|lw;
    // assign mem_read=lw;
    // assign mem_write=sw;
    // assign branch=beq;
    // assign alu_code_out[1]=Rformat;
    // assign alu_code_out[0]=beq;
        
endmodule

