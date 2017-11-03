`timescale 1ns/1ps

module fsm(a,b,out,reset);

input a,b,reset;
output out;
reg [3:0]state,nextstate;
reg clk,outreg;
//There are 6 status in total.
parameter
S0=3'd0,
S1=3'd1,
S2=3'd2,
S3=3'd3,
S4=3'd4,
S5=3'd5,
S6=3'd6;


assign out=outreg;

initial
begin
  clk=0;
  state=S0;
  nextstate=S0;
  outreg=0;
end

always #50 clk=~clk;

always@(posedge clk or negedge reset)
    if(!reset)
    state<=S0;
    else
    state<=nextstate;


always@(state or a or b)
begin
            nextstate=state;
            outreg=0;
            case(state)
            S0:
            begin
                if(a==1 && b==1)
                nextstate=S1;
                else
                if(a==0 && b==0)
                nextstate=S5;
                else
                boom();
            end
            S1:
            begin
                if(a==1 && b==0)
                nextstate=S4;
                else
                if(a==0 && b==1)
                nextstate=S3;
                else
                boom();
            end
            S2:
            begin
                if(a==0 && b==0)
                nextstate=S1;
                else
                if(a==1 && b==0)
                nextstate=S5;
                else
                boom();
            end
            S3:
            begin
                if(a==0 && b==0)
                nextstate=S2;
                else
                if(a==1 && b==0)
                nextstate=S4;
                else
                boom();
            end
            S4:
            begin
                if(a==0 && b==1)
                nextstate=S5;
                else
                if(a==1 && b==0)
                nextstate=S3;
                else
                boom();
            end
            S5:
            begin
                if(a==0 && b==0)
                nextstate=S5;
                else
                if(a==1 && b==0)
                nextstate=S0;
                else
                boom();
            end
            S6:
                boom();
            default:
                boom();
            endcase
end

// always@(posedge clk or negedge reset)
// begin
// case(state):
// S0: 
// S1:
// S2:
// S3:
// S4:
// S5:
// S6:
// default:
// endcase
// end

task boom();
begin
$display("Undefined input or behavior!");
fsm.outreg=1;
end
endtask

endmodule