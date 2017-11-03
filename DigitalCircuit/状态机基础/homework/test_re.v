`timescale 1ns/1ps

module tester;
reg a,b,reset;
reg clk;
reg rand;
wire out;

parameter
S0=3'd0,
S1=3'd1,
S2=3'd2,
S3=3'd3,
S4=3'd4,
S5=3'd5,
S6=3'd6;


fsm fsm_instance(a,b,out,reset);

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
$display("Start robust test!");
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
tester.a=ain;
tester.b=bin;
$display("Current fsm_instance.nextstate:%d\nRight state:%d",fsm_instance.nextstate,current_state);
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