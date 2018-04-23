// sign_extend.v

`timescale 10 ns / 1 ns

`define INPUT_WIDTH 16
`define OUTPUT_WIDTH 32

module sign_extend(
	input need_sign_extend,
	input [`INPUT_WIDTH-1:0]sign_extend_in,
	output reg [`OUTPUT_WIDTH-1:0]sign_extend_out
);

always@*
begin
  case(need_sign_extend)
	1:
		begin
			sign_extend_out=(sign_extend_in[`INPUT_WIDTH-1]?
				{16'b1111_1111_1111_1111,sign_extend_in}:
				{16'b0000_0000_0000_0000,sign_extend_in});
		end
	0:
		begin
			sign_extend_out={16'b0000_0000_0000_0000,sign_extend_in};
		end
	default:
		begin
			sign_extend_out={16'b0000_0000_0000_0000,sign_extend_in};
		end
  endcase
end



endmodule

