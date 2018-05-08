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
`define op_j     6'b000010
`define op_jal   6'b000011
`define op_lui   6'b001111
`define op_slti  6'b001010
`define op_sltiu 6'b001011
`define op_andi  6'b001100
`define special  6'b000000
`define regimm   6'b000001
`define op_blez  6'b000110
`define op_lb    6'b100000
`define op_lbu   6'b100100
`define op_lh    6'b100001
`define op_lhu   6'b100101
`define op_lwl   6'b100010
`define op_lwr   6'b100110
`define op_ori   6'b001101
`define op_sb    6'b101000
`define op_sh    6'b101001
`define op_swl   6'b101010
`define op_swr   6'b101110
`define op_xori  6'b001110



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

// additional_control for StoreLoad
`define normal 3'b000
`define slt    3'b001
`define and    3'b010
`define or     3'b011
`define xor     3'b100

// additional_control for Beq
`define bgez 3'b000
`define blez 3'b001
`define bltz 3'b010
`define jalr 3'b011

//mem extender control
`define extend32          4'b0000
`define extend16_signed   4'b0001
`define extend16_unsigned 4'b0010
`define extend8_signed    4'b0011
`define extend8_unsigned  4'b0100

`define merge_loadwordleft  4'b0101
`define merge_loadwordright 4'b0110
`define swl 4'b0111
`define swr 4'b1000
`define sb  4'b1001
`define sh  4'b1010
//todo: left and right


module control(
	input [`CONTROL_READ_WIDTH-1:0]instruction_31_26,
	output reg reg_dst,
    output reg [2:0]branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [`ALU_CODE_WIDTH-1:0]alu_code_out,
    output reg mem_write,
    output reg [1:0]alu_src,
    output reg reg_write,
    output reg need_sign_extend,
    output reg [3:0]mem_write_set,
    output reg [2:0]additional_control,
    output reg [3:0]mem_extend_control,
    output jal,
    output owmemwriteset,
    input ea
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

//mem extend and merge related
always@*
begin
    case(instruction_31_26)
        `op_lb:
        begin
            mem_extend_control=`extend8_signed;

        end

        `op_lbu:
        begin
            mem_extend_control=`extend8_unsigned;
        end

        `op_lh:
        begin
            mem_extend_control=`extend16_signed;
        end

        `op_lhu:
        begin
            mem_extend_control=`extend16_unsigned;
        end

        `op_lwl:
        begin
            mem_extend_control=`merge_loadwordleft;
        end

        `op_lwr:
        begin
            mem_extend_control=`merge_loadwordright;
        end 

        `op_swl:
        begin
            mem_extend_control=`swl;
        end
        `op_swr:
        begin
            mem_extend_control=`swr;
        end
        `op_sb:
        begin
            mem_extend_control=`sb;
        end
        `op_sh:
        begin
            mem_extend_control=`sh;
        end
        default:
        begin
            mem_extend_control=`extend32;
        end
    endcase
end

assign jal = instruction_31_26==`op_jal;

always@*
begin

//fin: addiu, lw, sw, bne, nop

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
            branch=`nop;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead  //todo
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
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
            branch=`nop;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}            
            additional_control=`normal;//used for special needs;
            
        end

        `op_lui: //LUI
        begin
            //Load Upper Immediate
            //Description: rt <- {imm16,0*16}
            //附注: 
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`upper16;//signextend(1) or readdata2(0) or upper16 or wtfitis            
            // alu_src=`upper16;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=0;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}            
            additional_control=`normal;//used for special needs;
            
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
            branch=`nop;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead            
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
        end

        `op_sb: //SB
        begin
            //Store Byte
            //Description: memory[base+offset] <- rt
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=1;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=0;//enable reg write
            mem_read=0;//enable memread
            mem_write=1;//enable memwrite
            branch=`nop;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead            
            mem_write_set=4'b0001;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
        end

        `op_sh: //SH
        begin
            //Store Halfword
            //Description: memory[base+offset] <- rt
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=1;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=0;//enable reg write
            mem_read=0;//enable memread
            mem_write=1;//enable memwrite
            branch=`nop;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead            
            mem_write_set=4'b0011;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
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
            branch=`bne;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`Beq;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead   
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
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
            branch=`beq;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`Beq;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
        end

        `op_j: //JUMP
        begin
            //Branch in 256 MB region
            //Description: do nothing but jump long long long
            reg_dst=1;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=1;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=0;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=`j;//nop or bne or beq or j
            alu_code_out[1:0]=`R;//R Store Load StoreLoad Beq
            need_sign_extend=0;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
        end

        `op_jal: //JUMP and LINK
        begin
            //todo
            //Execute a procedure in 256 MB region
            //Description: ???
            reg_dst=1;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=1;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=`j;//nop or bne or beq or j
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=0;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
        end


        `op_andi: //ANDI
        begin
            //To do a bitwise logical AND with a constant
            //Description: rt <- rs and {16*0,imm16}
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//nop or bne or beq or j
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=0;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`and;//used for special needs;
            
        end

        //the newest
        `special: //Reg instructions
        begin
            //Call ALU to do special instructions.
            //Description: call alu_control
            reg_dst=1;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`readdata2;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//nop or bne or beq or j
            alu_code_out[1:0]=`R;//R Store Load StoreLoad Beq
            need_sign_extend=0;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
        end


        `op_slti: //Set on Less Than Immediate //SLTI
        begin
            // rt←(rs < immediate)
            //Description:Compare the contents of GPRrsand the 16-bit signedimmediateas signed integers and record the Boolean result ofthe comparison in GPRrt. If GPRrsis less thanimmediate,the result is 1 (true); otherwise, it is 0 (false).
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//nop or bne or beq or j
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`slt;//used for special needs;
            
        end

        `op_sltiu: //Set on Less Than Immediate Unsigned//SLTIU
        begin
            // rt←(rs < immediate)
            //Description: ditto
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//nop or bne or beq or j
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=0;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`slt;//used for special needs;
            
        end

        `regimm: //BGEZ //BLTZ
        begin
            //Use instruction[20:16] and branch_control

            //BGEZ
            //Branch on Greater Than or Equal to Zero
            //Description: if rs ≥0 then branch
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=0;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=`use_branch_controler;//nop or bne or beq or j or use_branch_controler
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`bgez;//used for special needs;
            
        end

        `op_blez: //BLEZ
        begin
            //Use instruction[20:16] and branch_control

            //BGEZ
            //Branch on Greater Than or Equal to Zero
            //Description: if rs ≥0 then branch
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=0;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=`use_branch_controler;//nop or bne or beq or j or use_branch_controler
            alu_code_out[1:0]=`Beq;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`blez;//used for special needs;
            
        end

        `op_lb: //LB
        begin

            //Load Byte
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=1;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=1;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//nop or bne or beq or j or use_branch_controler
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
        end

        `op_lbu: //LBU
        begin
            //Load Byte Unsigned        
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=1;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=1;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//nop or bne or beq or j or use_branch_controler
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
        end

        `op_lh: //LH
        begin
            //Load Halfword        
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=1;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=1;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//nop or bne or beq or j or use_branch_controler
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
        end

        `op_lhu: //LHU
        begin
            //Load Halfword Usigned        
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=1;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=1;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//nop or bne or beq or j or use_branch_controler
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
        end

        `op_lwl: //LWL
        begin
            //Load Word Left        
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=1;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=1;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//nop or bne or beq or j or use_branch_controler
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
        end

        `op_lwr: //LWR
        begin
            //Load Word Right        
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=1;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=1;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//nop or bne or beq or j or use_branch_controler
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
        end

        `op_ori: //ORI
        begin
            //OR IMM       
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//nop or bne or beq or j or use_branch_controler
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=0;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`or;//used for special needs;
            
        end

        `op_swl: //SWL
        begin
            //Store Word Left     
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=0;//enable reg write
            mem_read=0;//enable memread
            mem_write=1;//enable memwrite
            branch=`nop;//nop or bne or beq or j or use_branch_controler
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}//todo
            additional_control=`normal;//used for special needs;
            
        end

        `op_swr: //SWR
        begin
            //Store Word Right     
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=0;//enable reg write
            mem_read=0;//enable memread
            mem_write=1;//enable memwrite
            branch=`nop;//nop or bne or beq or j or use_branch_controler
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=1;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}//todo
            additional_control=`normal;//used for special needs;
            
        end

        `op_xori: //XORI
        begin
            //Store Word Right     
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=`signextend;//signextend(1) or readdata2(0) or upper16 or wtfitis
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=1;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//nop or bne or beq or j or use_branch_controler
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=0;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`xor;//used for special needs;
            
        end
        
        default:
        begin
            reg_dst=0;//1->()Reg.writereg=ins[15:11] 0->(rt)Reg.writereg=ins[20:16]
            alu_src=1;//1->ALU.B=signextend 0->ALI.B=Reg.Readdata2
            mem_to_reg=0;//1->write mem.readdata->reg.writedata  0->write ALU.result->reg.writedata
            reg_write=0;//enable reg write
            mem_read=0;//enable memread
            mem_write=0;//enable memwrite
            branch=`nop;//if branch&ALU.zero --> pc jmp (is branch instruction)
            alu_code_out[1:0]=`StoreLoad;//R Store Load StoreLoad Beq
            need_sign_extend=0;//1 -> extend 16->32 with sign; 0 -> just add 16*0 ahead
            mem_write_set=4'b1111;//write all 32 bit:1111 {byte_3, byte_2, byte_1, byte_0}
            additional_control=`normal;//used for special needs;
            
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

