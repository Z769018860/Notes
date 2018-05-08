//shifter.v

`timescale 10ns / 1ns

`define INSTRUCTION_WIDTH 32
`define DATA_WIDTH 32
`define ALU_CODE_WIDTH 2
`define IST_CODE_WIDTH 6
`define ALUop_WIDTH 3

`define DATA_WIDTH 32
`define ADDR_WIDTH 5

//shifter
`define left_shift_a 2'b00
`define left_shift_l 2'b01
`define right_shift_a 2'b10
`define right_shift_l 2'b11

`define source_ins 1'b0
`define source_reg 1'b1

module shifter(
    input [1:0]shiftmode,
    input source,
    input [4:0]shiftbit,
    input [`DATA_WIDTH-1:0]reg_shiftbit,
    input [`DATA_WIDTH-1:0]shifter_input,
    output reg [`DATA_WIDTH-1:0]shifter_output
);

wire [4:0]realshiftbit=((source==`source_ins)?shiftbit:reg_shiftbit);
wire [63:0]startwith0={32'h0,shifter_input};
wire [63:0]startwith1={32'hffffffff,shifter_input};

always@*
begin
    case(shiftmode)
        `left_shift_a:
        begin
            shifter_output=shifter_input<<realshiftbit;
        end
        `left_shift_l:
        begin
            shifter_output=shifter_input<<realshiftbit;
        end
        `right_shift_a:
        begin
            // shifter_output=shifter_input>>>;
            //ERROR >>>不被支持
            //桶形移位器

            shifter_output=(shifter_input[31])?startwith1[realshiftbit+31-:32]:startwith0[realshiftbit+31-:32];
            //ref:  https://stackoverflow.com/questions/7543592/verilog-barrel-shifter
        end
        `right_shift_l:
        begin
            shifter_output=startwith0[realshiftbit+31-:32];
            //verilog: 逻辑右移 >>            
        end


    endcase
end

endmodule