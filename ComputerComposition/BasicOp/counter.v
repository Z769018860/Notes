`timescale 1ns / 1ps

`define STATE_RESET 8'd0
`define STATE_RUN 8'd1
`define STATE_HALT 8'd2

module counter(
    input clk,
    input [31:0] interval,
    input [7:0] state,
    output reg [31:0] counter
	);

reg [31:0] tic;
	always@(posedge clk)
	begin

    	case(state[7:0])

	`STATE_RESET:
		begin
			tic[31:0]<= 32'd0;
			counter<=8'd0;
		end
	`STATE_RUN:
		begin 
		if(tic[31:0]==interval[31:0])
		begin
			counter[31:0]<=counter[31:0]+1;
			tic[31:0]<=8'b0;
		end
		else
		begin
				tic[31:0]<=tic[31:0]+1;
        end
		end

	`STATE_HALT:
		begin
		end
		default:
			begin
			end
	endcase
end
endmodule