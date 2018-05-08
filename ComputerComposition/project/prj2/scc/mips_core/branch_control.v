// branch_control.v

`timescale 10 ns / 1 ns

//todo
`define ins_bgez 5'b00001
`define ins_bltz 5'b00000


// additional_control for Beq
`define bgez 3'b000
`define blez 3'b001
`define bltz 3'b010
`define jalr 3'b011

module branch_control(
    // input [2:0]branch,
    input [4:0]branch_instruction,//Instruction[20:16]
    input [2:0]branch_op,
    input [31:0]judge_data,
    input sign,
    input zero,
    output reg branch_enable
    // input [31:0]PC,
    // output [31:0]PCout
);

wire judge_data_sign;
wire judge_data_zero;

assign judge_data_sign=judge_data[31];
assign judge_data_zero=(judge_data==0);

always@*
begin
  case(branch_op)
    `bgez: //and bltz
        begin
            case(branch_instruction)
                `ins_bgez:
                    begin
                        branch_enable=(!judge_data_sign)||judge_data_zero;
                    end

                `ins_bltz:
                    begin
                        branch_enable=judge_data_sign;
                    end
                default:
                begin
                        branch_enable=judge_data_sign;
                end
            endcase
        end
    `blez:
        begin
            branch_enable=judge_data_sign||judge_data_zero;
        end
    default:
        begin
            branch_enable=judge_data_sign||judge_data_zero;
        end
  endcase
end
endmodule