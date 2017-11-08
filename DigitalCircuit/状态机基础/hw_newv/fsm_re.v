`timescale 1ns/1ps

module fsm(a,b,out,reset,clk);

input a,b,reset,clk;
output out;
reg [5:0]state,nextstate;
// reg clk,outreg;
reg outreg;
//There are 6 status in total.
parameter
S0=6'b1,
S1=6'b10,
S2=6'b100,
S3=6'b1000,
S4=6'b10000,
S5=6'b100000;



assign out=outreg;

initial
begin
//   clk=0;
  state=S0;
  nextstate=S0;
  outreg=0;
end

// always #50 clk=~clk;

always@(posedge clk or negedge reset)
    if(!reset)
    state<=S0;
    else
    state<=nextstate;


always@(state or a or b)
begin
            nextstate=state;
            // outreg=0;
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
            default:
                boom();
            endcase
end

always@(posedge clk )
begin
            case(state)
            S0:
            begin
                if(a==1 && b==1)
                outreg=0;
                else
                if(a==0 && b==0)
                outreg=1;
                else
                hold();
            end
            S1:
            begin
                if(a==1 && b==0)
                outreg=1;            
                else
                if(a==0 && b==1)
                outreg=0;
                else
                hold();
            end
            S2:
            begin
                if(a==0 && b==0)
                outreg=1;
                else
                if(a==1 && b==0)
                outreg=0;
                else
                hold();
            end
            S3:
            begin
                if(a==0 && b==0)
                outreg=0;
                else
                if(a==1 && b==0)
                outreg=1;
                else
                hold();
            end
            S4:
            begin
                if(a==0 && b==1)
                outreg=1;
                else
                if(a==1 && b==0)
                outreg=0;
                else
                hold();
            end
            S5:
            begin
                if(a==0 && b==0)
                outreg=0;
                else
                if(a==1 && b==0)
                outreg=1;
                else
                hold();
            end
            default:
                hold();
            endcase
end

task boom();
begin
// $display("Undefined input or behavior!");
// fsm.outreg=1;
end
endtask

task hold();
begin
$display("-------------------------\nHold(): Current state:%d Input: a:%d b:%d Output:%d\n---------------------",state,a,b,out);
end
endtask

endmodule