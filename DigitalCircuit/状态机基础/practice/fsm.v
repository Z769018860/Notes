`timescale 1ns/1ps

module fsm(in1, out1,reset);

input 
in1,
reset;

output out1;

reg [1:0]
current_state,
next_state;

reg
toout,
clk;
  
parameter
IDLE=2'd0,
state1 =2'd1,
state2 =2'd2,
state3 =2'd3;

assign out1=toout;

initial
begin
  clk<=0;
  current_state<=2;
  next_state<=1;
end

always #50 clk=~clk;

always@(posedge clk)
begin
    current_state<=next_state;
end

always@(current_state or posedge reset)
begin
    next_state=IDLE;
    if(reset)
    current_state=IDLE;
    else
    begin
    case(current_state)
    IDLE:
        next_state<=IDLE;
    state1:
        next_state<=state2;
    state2:
        next_state<=state3;
    state3:
        next_state<=state1;
    default:
        next_state<=state1;
    endcase
    end
end

always@(posedge clk or reset or in1)
begin
    case(next_state)
    IDLE:
        toout<=0;
    state1:
        toout<=1;
    state2:
        toout<=0;
    state3:
        toout<=1;
    default:
        toout<=0;
    endcase
end

endmodule
    