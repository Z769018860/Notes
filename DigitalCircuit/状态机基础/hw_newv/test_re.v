`timescale 1ns/1ps

module tester;
reg a,b,reset;
reg clk;
reg rand;
wire out;

parameter
S0=6'b1,
S1=6'b10,
S2=6'b100,
S3=6'b1000,
S4=6'b10000,
S5=6'b100000;

fsm fsm_instance(a,b,out,reset,clk);

initial
begin
$dumpfile("out.vcd");
$dumpvars(0,tester);
reset=1;
$monitor("state:",fsm_instance.state," statenext:",fsm_instance.nextstate," a:",a," b:",b);
$monitoron;
clk=0;
rand=0;
test(1,0,S0);//0
test(0,1,S0);
test(1,1,S0);
test(1,1,S1);//1
test(0,0,S1);
test(1,0,S1);
test(1,1,S4);//4
test(0,0,S4);
test(1,0,S4);
test(0,1,S3);//3
test(1,1,S3);
test(0,0,S3);
test(0,1,S2);//2
test(1,1,S2);
test(0,0,S2);
test(0,1,S1);
test(1,0,S3);
test(0,1,S4);
test(0,0,S5);//5
test(1,1,S5);
test(0,1,S5);
test(1,0,S5);
test(0,0,S0);
test(1,0,S5);
test(1,1,S0);
test(0,1,S1);
test(0,0,S3);
test(1,0,S2);
test(0,0,S5);
$monitoroff;
#1000;
rand=1;
$display("\n\nStart robust test!");
$display("------------------------------------------------");
$monitoron;
#10000;
$finish;
end

always # 50 clk=~clk;

always@(posedge clk)
if(rand)
begin
    a={$random}%2;
    b={$random}%2;
end

task test(ain,bin,current_state);
integer ain,bin;
integer current_state;

begin
tester.a<=ain;
tester.b<=bin;
$display("Fsm_instance.nextstate:%d\nRight state:%d\nOutput:%d",fsm_instance.nextstate,current_state,out);
if(current_state!=fsm_instance.state)
$display("Fsm went to the wrong state!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
#100;
end
endtask

// task forced_test(ain,bin,current_state,next_state);

// integer
// ain,
// bin;
// reg current_state,next_state;

// begin
// test.a=ain;
// test.b=bin;
// fsm_instance.state=current_state;
// #101;
// if(fsm.state!=next_state)
// $display("Fsm went to the wrong state!\n");
// #99;
// end
// endtask

endmodule