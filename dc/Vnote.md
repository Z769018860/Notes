# Verilog Learning note

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