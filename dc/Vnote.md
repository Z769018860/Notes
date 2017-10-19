# Verilog Learning Note

## 基础语法

```verilog
`timescale 1ns/1ps

module test;

    //测试电路的输入必须为reg类型
    reg clock;
    reg in;
    wire outw;

    //initial always 并行执行
    initial //将寄存器变量初始化为给定值

    always #50 clock~=clock;//#50 延时50

    always @(posedge clock);//always do while()
    //posedeg 上升沿
        begin
          #1 outw=clock;
          #1 outw={$random%3};//$random 系统函数 生成随机数
          //其中所有指令串行执行
        end

    initial
        begin
            assign outw=1;
        end

    //模块例化
    muxtwom(.a(in),.out(outw));//引脚链接 .外部端口名(内部端口名)
endmodule
```

## 简单开发环境搭建

使用iverilog搭建简单开发环境

使用此代码在批处理中读入变量

```bat
set /p 变量名=提示
```

在命令行中对批处理传入的变量分别为
%1, %2, ...

由此构建批处理

```bat
set testbentch_module=%1
set testbentch_file="%testbentch_module%"

iverilog -o "%testbentch_module%.vvp" "%testbentch_file%" "%2" "%3" "%4"
vvp "%testbentch_module%.vvp"

gtkwave out.vcd
rem set gtkw_file="%testbentch_module%.gtkw"
rem if exist %gtkw_file% (gtkwave %gtkw_file%) else (gtkwave "%testbentch_module%.vcd")
```

注意激励文件中需要以下语句:

```verilog
$dumpfile("out.vcd");
$dumpvars(0,test);
$display("Start test.");
```

## 学习笔记部分

1. 在always内被赋值的每一个信号都必须定义成reg型
1. 在reg被作为操作数时被视为是无符号值,尽管在赋值时其可以被赋成负数
1. 存储器reg [7:0]memory [255:0];
1. 同或(异或取反)可以写作^~
1. 不定值x和高阻值z
1. ==(可以返回x)与===(只返回01)
1. 位拼接运算符{},注意其中所有信号必须指明位数(如常量),可以重复或嵌套
1. 常量值表示1'b1
1. 缩减运算B=&B

## 阻塞赋值=与非阻塞赋值<=

## 顺序块,并行块

顺序块

```verilog
begin:name
    a<=1;
end
```

并行块

```verilog
fork:name
    a<=1;
    b<=2;
join
```

> 在Verilog语言里，所有的变量都是静态的，即所有的变量都只有一个唯一的存储地址，因此进入或跳出块并不影响存储在变量内的值, 基于以上原因，块名就提供了一个在任何仿真时刻确认变量值的方法。P39


## 避免偶然生成锁存器

如果用到if语句，最好写上else项。如果用case语句，最好写上default项。

## 循环

在Verilog HDL中存在着四种类型的循环语句，用来控制执行语句的执行次数。 

1. forever     连续的执行语句。 
2. repeat()      连续执行一条语句 n 次。 
3. while()  执行一条语句直到某个条件不满足。如果一开始条件即不满足(为假)，               则语句一次也不能被执行。 
4. for()

## function和task

任务和函数有些不同，主要的不同有以下四点： 

1. 函数只能与主模块共用同一个仿真时间单位，而任务可以定义自己的仿真时间单位。
2. 函数不能启动任务，而任务能启动其它任务和函数。 
3. 函数至少要有一个输入变量，而任务可以没有或有多个任何类型的变量。 
4. 函数返回一个值，而任务则不返回值。

区别:函数的目的是通过返回一个值来响应输入信号的值。任务却能支持多种目的，能计算多个结果值，这些结果值只能通过被调用的任务的输出或总线端口送出。Verilog HDL模块使用函数时是把它当作表达式中的操作符，这个操作的结果值就是这个函数的返回值。

函数的使用规则(ie:函数只可以看成一个无时长的运算符)： 

1. 函数的定义不能包含有任何的时间控制语句，即任何用＃、@、或wait来标识的语句。 
2. 函数不能启动任务。 
3. 定义函数时至少要有一个输入参量。 
4. 在函数的定义中必须有一条赋值语句给函数中的一个内部变量赋以函数的结果值，该内部变量具有和函数名相同的名字。

## 内部语句

```verilog
$display //输出时换行

$write //输出时不换行

$monitor(变量列表,在其中一个发生变化时会输出整个变量列表)
$monitoron  //首次调用时会输出变量列表
$monitoroff

$time  //返回一个64比特的整数来表示的当前仿真时刻值

$stop; 
$stop(n);
//把EDA工具(例如仿真器)置成暂停模式，在仿真环境下给出一个交互式的命令提示符，将控制权交给用户。这个任务可以带有参数表达式。根据参数值(0，1或2)的不同，输出不同的信息。参数值越大，输出的信息越多。

$readmemb //(bin)
$readmemh  //(hex)从文件中读取数据到存贮器中

$random //返回一个32bit的随机数。它是一个带符号的整形数. 常与%配合使用

$random % x //返回正负值
{$random} % x  //返回正值
``` 