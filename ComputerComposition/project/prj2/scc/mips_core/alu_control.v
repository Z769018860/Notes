// alu_control.v

`timescale 10 ns / 1 ns

`define ALU_CODE_WIDTH 2
`define IST_CODE_WIDTH 6
`define ALUop_WIDTH 3

//todo
`define R 2'b10
`define Store 2'b00
`define Load 2'b00
`define StoreLoad 2'b00
`define Beq 2'b01

`define DATA_WIDTH 32
`define AND 3'b000
`define OR 3'b001
`define ADD 3'b010
`define SUB 3'b110
`define SLT 3'b111
`define XOR 3'b100
`define NOR 3'b101
`define SLTU 3'b011

// additional_control for StoreLoad
`define normal 3'b000
`define slt    3'b001
`define and    3'b010
`define or     3'b011
`define xor    3'b100

// additional_control for Beq
`define bgez 3'b000
`define blez 3'b001
`define bltz 3'b010
`define jalr 3'b011

//conditional_move
`define normal_move 2'b00 
`define zero_move 2'b01 
`define nzero_move 2'b11 

//shifter
`define left_shift_a 2'b00
`define left_shift_l 2'b01
`define right_shift_a 2'b10
`define right_shift_l 2'b11

`define source_ins 1'b0
`define source_reg 1'b1

module alu_control(
	input [`ALU_CODE_WIDTH-1:0]alu_code_in,
    input [`IST_CODE_WIDTH-1:0]ist_code_in,
    input [2:0]additional_control,
	output reg[`ALUop_WIDTH-1:0]aluop_out,
    output reg enable_shifter,
    output reg reg_to_pc,
    output pcnext_to_reg,
    output reg [1:0]conditional_move,
    output reg [1:0]shiftmode,
    output reg shiftsource
);

	// assign aluop_out=
    // ((alu_code_in==`R)?0:
    // ((alu_code_in==`Store)?1:
    // ((alu_code_in==`L)?0:
    // (0))));//(alu_code_in==`Beq)0))));

    //JALR
    assign pcnext_to_reg=(ist_code_in==6'b001001)&&(alu_code_in==`R);

    //条件转移控制
    always@*
    begin
        if(alu_code_in==`R)
        begin
        case(ist_code_in)
            6'b001011: //movn
            begin
                conditional_move=`nzero_move;
                //regwritedata=readdata1
                //控制regwen
            end

            6'b001010: //movz
            begin
                conditional_move=`zero_move;
                //regwritedata=readdata1
                //控制regwen
            end

            default:
            begin
                conditional_move=`normal_move;
                //在外界使用正常的regwritedata
                //reg写enable
            end
        endcase 
        end
        else
        begin
                conditional_move=`normal_move;
        end
    end

    //移位逻辑控制
    always@*
    begin   
        case(ist_code_in)
            //SLLV
            6'b000100:
            begin
              shiftmode=`left_shift_l;
              shiftsource=`source_reg;
            end
            //SLL
            6'b000000:
            begin
              shiftmode=`left_shift_l;
              shiftsource=`source_ins;
            end
            //SRA
            6'b000011:
            begin
                shiftmode=`right_shift_a;
                shiftsource=`source_ins;
            end
            //SRAV
            6'b000111:
            begin
                shiftmode=`right_shift_a;
                shiftsource=`source_reg;
            end
            //SRL
            6'b000010:
            begin
                shiftmode=`right_shift_l;
                shiftsource=`source_ins;
            end
            //SRLV
            6'b000110:
            begin
                shiftmode=`right_shift_l;
                shiftsource=`source_reg;
            end

        endcase
    end

    always@*
    begin
      case(alu_code_in)
        `StoreLoad:
            begin
            // additional_control=`normal;//used for special needs;
                case(additional_control)
                `normal:
                    begin
                        aluop_out=`ADD;
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                `slt:
                    begin
                        aluop_out=`SLT;
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                `and:
                    begin
                        aluop_out=`AND;
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                `or:
                    begin
                        aluop_out=`OR;
                        enable_shifter=0;
                        reg_to_pc=0;
                    end       
                `xor:
                    begin
                        aluop_out=`XOR;
                        enable_shifter=0;
                        reg_to_pc=0;
                    end

                default:
                    begin
                        aluop_out=`ADD;
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                endcase
            end

        `Beq:
            begin
                aluop_out=`SUB;
                enable_shifter=0;
                reg_to_pc=0;
            end

        `R:
            begin
                case(ist_code_in)
                    //todo

                    //ADDU
                    6'b100001:
                    begin
                        aluop_out=`ADD;                        
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                    //ADD
                    6'b100000:
                    begin
                        aluop_out=`ADD;                        
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                    //SUB,subtract
                    6'b100010:
                    begin
                        aluop_out=`SUB;                        
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                    //SUBU,subtract
                    6'b100011:
                    begin
                        aluop_out=`SUB;                        
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                    //AND
                    6'b100100:
                    begin
                        aluop_out=`AND;                        
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                    //OR
                    6'b100101:
                    begin
                        aluop_out=`OR;                        
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                    //SLT
                    6'b101010:
                    begin
                        aluop_out=`SLT;                        
                        enable_shifter=0;
                        reg_to_pc=0;
                    end


                //SLLV
                6'b000100:
                begin
                        aluop_out=`ADD;//no influence                        
                        enable_shifter=1;
                        reg_to_pc=0;
                end
                //SLL
                6'b000000:
                begin
                        aluop_out=`ADD;//no influence                        
                        enable_shifter=1;
                        reg_to_pc=0;
                end
                //SRA
                6'b000011:
                begin
                        aluop_out=`ADD;//no influence                        
                        enable_shifter=1;
                        reg_to_pc=0;
                end
                //SRAV
                6'b000111:
                begin
                        aluop_out=`ADD;//no influence                        
                        enable_shifter=1;
                        reg_to_pc=0;
                end
                //SRL
                6'b000010:
                begin
                        aluop_out=`ADD;//no influence                        
                        enable_shifter=1;
                        reg_to_pc=0;
                end
                //SRLV
                6'b000110:
                begin
                        aluop_out=`ADD;//no influence                        
                        enable_shifter=1;
                        reg_to_pc=0;
                end
                
                //SLTU
                6'b101011:
                begin
                        aluop_out=`SLTU;//no influence                        
                        enable_shifter=0;
                        reg_to_pc=0;
                end

                    //JR
                    6'b001000:
                    begin
                        aluop_out=`ADD;                        
                        enable_shifter=0;
                        reg_to_pc=1;
                    end
                    //JALR
                    6'b001001:
                    begin
                        aluop_out=`ADD;                        
                        enable_shifter=0;
                        reg_to_pc=1;
                    end
                    //MOVN
                    6'b001011:
                    begin
                        aluop_out=`ADD;                        
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                    //MOVZ
                    6'b001010: //movz
                    begin
                        aluop_out=`ADD;                        
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                    //NOR
                    6'b100111:
                    begin
                        aluop_out=`NOR;                        
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                    //XOR
                    6'b100110:
                    begin
                        aluop_out=`XOR;                        
                        enable_shifter=0;
                        reg_to_pc=0;
                    end
                    // //SRA
                    // 6'b000011:
                    // begin
                    //     aluop_out=`NOR;                        
                    //     enable_shifter=0;
                    //     reg_to_pc=0;
                    // end


                    default: //SRA SRAV
                     begin
                        aluop_out=3'b000;
                        enable_shifter=0;
                        reg_to_pc=0;
                     end

                endcase
            end


        default:
            begin
                        aluop_out=3'b000;
                        enable_shifter=0;
                        reg_to_pc=0;
            end
      endcase
        
    end
        
endmodule

