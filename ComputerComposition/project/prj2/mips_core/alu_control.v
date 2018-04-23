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

module alu_control(
	input [`ALU_CODE_WIDTH-1:0]alu_code_in,
    input [`IST_CODE_WIDTH-1:0]ist_code_in,
	output reg[`ALUop_WIDTH-1:0]aluop_out
);

	// assign aluop_out=
    // ((alu_code_in==`R)?0:
    // ((alu_code_in==`Store)?1:
    // ((alu_code_in==`L)?0:
    // (0))));//(alu_code_in==`Beq)0))));

    always@*
    begin
      case(alu_code_in)
        `StoreLoad:
            begin
                aluop_out=`ADD;
            end

        `Beq:
            begin
                aluop_out=`SUB;
            end

        `R:
            begin
                case(ist_code_in)
                    //todo

                    //ADD
                    6'b100000:
                    begin
                        aluop_out=`ADD;                        
                    end
                    //SUB,subtract
                    6'b100010:
                    begin
                        aluop_out=`SUB;                        
                    end
                    //AND
                    6'b100100:
                    begin
                        aluop_out=`AND;                        
                    end
                    //OR
                    6'b100101:
                    begin
                        aluop_out=`OR;                        
                    end
                    //SLT
                    6'b101010:
                    begin
                        aluop_out=`SLT;                        
                    end

                    default:
                     begin
                        aluop_out=3'b000;
                     end

                endcase
            end


        default:
            begin
              aluop_out=0;
            end
      endcase
        
    end
        
endmodule

