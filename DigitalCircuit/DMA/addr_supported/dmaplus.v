// Copyright (c) 2017-2018 Wang Huaqiang, Liu Yunzhe.

`timescale 1ns/1ps
`define workmode_4 0 //Uses [3:0] in inout socket
`define workmode_8 1

module FIFO(
    input clk,//时钟信号
    input resetn,//重置信号
    input workmode, //决定每次输入输出的位宽
    input input_valid, output_enable,  //外部信号:输入值有效, 可以进行输出
    input [7:0] fifo_in,        //8bits输入端口
    output [7:0] fifo_out,   //8bits输出端口
    output reg output_valid,
    output reg input_enable,
    output empty,//指示buf是否为空
    output full,//指示buf是否为满

    //新引入:地址及长度处理部分
    input fill_fifo, //在当前操作结束后直接置满当前buff, 使之可以传输(翻转)
    input empty_fifo //在当前操作结束后直接置空当前buff, 使之可以翻转
);
reg [7:0]ram[7:0];//用于存储的reg
reg [2:0]position;//记录当前存储位置位于第几行
reg writehigh;//记录当前存储位置位于一行中的开头还是中段

assign empty=(position==0)&(!writehigh)&(input_enable);//当指针位于buf第0行开头，且可以进行输入时，判断buf为空
assign full=(position==0)&(!writehigh)&(output_valid);//当指针位于buf第0行开头，且可以进行输出时，判断buf为满

assign fifo_out=(writehigh?{4'b0000,ram[position][7:4]}:ram[position]);//若buf中一行未写满（指针位于中段），则输出时进行位运算，将无意义位置零

always@(posedge clk)
begin
    if(!resetn)//初始化/重置
    begin
        input_enable<=1;//可以输入
        output_valid<=0;//输出无效
        position<=3'b0;//指针指到第0行
        writehigh<=0;//指针指到一行中的开头
    end

    if(fill_fifo)//置满
    begin

        if(input_enable&input_valid)//可以输入时输入有效
        begin
            if(workmode==`workmode_8)//如果位于8位工作模式
            begin
                ram[position]<=fifo_in;//给指针所在行写入数据
            end
            else//如果位于4位工作模式
            begin
                if(writehigh)//如果指针在行中段
                begin
                    ram[position][7:4]<=fifo_in;//给本行7:4位写入数据
                end
            end
        end
        input_enable<=0;//不接受输入
        output_valid<=1;//输出有效
        position<=3'b0;//指针指到第0行
        writehigh<=0;//指针指到一行中的开头
    end

    else//若没有置满
    if(empty_fifo)//若置空
    begin
        input_enable<=1;//接受输入
        output_valid<=0;//输出无效
        position<=3'b0;//指针指到第0行
        writehigh<=0;//指针指到一行中的开头
    end
    else//若也没有置空
    begin
        if(workmode==`workmode_8)//如果位于8位工作模式
        case({input_enable,input_valid,output_enable,output_valid})//描述状态机，4位分别为：是否接受输入，输入是否有效，是否可以输出，输出是否有效
            4'b1100://输入状态
            begin
                ram[position]<=fifo_in;//给指针所在行写入数据
                position<=position+1;//指针移至下一行
                if(position==7)//如果指针指到第8行
                begin 
                    input_enable<=0;//不接受输入
                    output_valid<=1;//输出有效
                end
            end
            4'b0011://输出状态
            begin
                position<=position+1;//指针移至下一行
                if(position==7)//如果指针指到第8行
                begin 
                    input_enable<=1;//接受输入
                    output_valid<=0;//输出无效
                end
            end    
            default:
            ;
        endcase

        if(workmode==`workmode_4)//如果位于4位工作模式
        case({input_enable,input_valid,output_enable,output_valid})//描述状态机，4位分别为：是否接受输入，输入是否有效，是否可以输出，输出是否有效
            4'b1100://输入状态
            begin
                if(writehigh)//如果指针在行中段
                begin
                    ram[position][7:4]<=fifo_in;//给本行7:4位写入数据
                    position<=position+1;//指针移至下一行
                    writehigh<=0;//指针移至行首
                    if(position==7)//如果指针指到第8行
                    begin 
                        input_enable<=0;//不接受输入
                        output_valid<=1;//输出有效
                    end
                end
                else//如果指针在行首
                begin
                    ram[position][3:0]<=fifo_in;//给本行3:0位写入数据
                    writehigh<=1;//指针移至本行中段
                end
            end
            4'b0011://输出状态
            begin
                if(writehigh)//如果指针在行中段
                begin
                    position<=position+1;//指针移至下一行
                    writehigh<=0;//指针移至行首
                    if(position==7)//如果指针指到第8行
                    begin 
                        input_enable<=1;//接受输入
                        output_valid<=0;//输出无效
                    end
                end
                else//如果指针在行首
                begin
                    writehigh<=1;//指针移至本行中段
                end
            end   
            default://其它
            ;
        endcase        
    end
end

endmodule

//将常量进行定义, 以提高代码可读性
`define mode_cpu_to_mem 1'b1 //数据传输方向:cpu->mem
`define mode_mem_to_cpu 1'b0 //数据传输方向:mem->cpu
`define buf1 1'b0 //FIFO1
`define buf2 1'b1 //FIFO2

module DMA(

input clk,
input resetn,
input mode,              //模式选择:控制DMA的工作方式:内存->CPU 或 CPU->内存

input dma_to_mem_enable, //MEM是否准备好接收数据。
input mem_to_dma_valid, //MEM中传入的数据是否有效。
input dma_to_cpu_enable, //CPU是否准备好接收数据。
input cpu_to_dma_valid, //CPU传入的数据是否有效。

input [3:0] mem_data_out, //内存信号输出
input [7:0] cpu_data_out,  //中央处理器信号输出

output dma_to_mem_valid, //向MEM传出的数据是否有效
output mem_to_dma_enable, //DMA准备好自MEM接收数据
output cpu_to_dma_enable, //DMA准备好自CPU接收数据
output dma_to_cpu_valid, //向CPU传出的数据是否有效

output [3:0] mem_data_in, //内存信号输入
output [7:0] cpu_data_in,  //中央处理器信号输入

//新引入:
output dma_cpu_trans, //输出dma是否成功的传送了8bit/4bit信息, 以方便外层控制逻辑计数, 注意传输方向不同时计数所对应的数据长度也不同
output dma_mem_trans, //输出dma是否成功的传送了8bit/4bit信息, 以方便外层控制逻辑计数, 注意传输方向不同时计数所对应的数据长度也不同
input fill_fifo, //置满当前输入fifo, 在满足条件时信号立即变化:当前输入的信号已经达到了控制信息所要求的长度
input empty_fifo //置空当前输入fifo, 在满足条件时信号立即变化:当前输出的信号已经达到了控制信息所要求的长度
);

//这两个寄存器的作用是控制FIFO模块是在4bit还是8bit模式下工作
reg buf1_mode;
reg buf2_mode;

//这个寄存器用于记录当前用于数据输入的FIFO, 此时另一个模块用于数据输出.
reg input_buf;

//实例化两个FIFO
FIFO buf1(    
    .clk(clk),
    .resetn(resetn),
    .workmode(buf1_mode)
);

FIFO buf2(
    .clk(clk),
    .resetn(resetn),
    .workmode(buf2_mode)
);

//~input_buf means output_buf
//~input_buf表示当前的输出FIFO

//接线部分
//这里我们直接使用assign语句完成用于控制的组合逻辑的设置

//内部数据输出:

//实质上, DMA的两个方向的valid, enable信号, 实际上就是对应的输入/输出FIFO的valid/enable信号.
//比如, 当输入FIFO input_valid==1, input_enable==1, 代表其可以接受数据, 若此时方向为mode_cpu_to_mem, 则其接受cpu的数据
//将当前对应输入/输出FIFO的输出信号直接作为DMA的输出信号
assign dma_to_mem_valid=(mode==`mode_cpu_to_mem)&((~input_buf==`buf1)?buf1.output_valid:buf2.output_valid);
//将当前输出FIFO的output_valid作为DMA的dma_to_mem_valid, dma_to_mem_valid信号只在mode_cpu_to_mem下有效
assign mem_to_dma_enable=(mode==`mode_mem_to_cpu)&((input_buf==`buf1)?buf1.input_enable:buf2.input_enable);
//将当前输入FIFO的input_enable作为DMA的mem_to_dma_enable, mem_to_dma_enable信号只在mode_mem_to_cpu下有效
assign cpu_to_dma_enable=(mode==`mode_cpu_to_mem)&((input_buf==`buf1)?buf1.input_enable:buf2.input_enable);
//将当前输入FIFO的input_enable作为DMA的cpu_to_dma_enable, cpu_to_dma_enable信号只在mode_cpu_to_mem下有效
assign dma_to_cpu_valid=(mode==`mode_mem_to_cpu)&((~input_buf==`buf1)?buf1.output_valid:buf2.output_valid); 
//将当前输出FIFO的output_valid作为DMA的dma_to_cpu_valid, dma_to_cpu_valid信号只在mode_mem_to_cpu下有效

//xxx_data_in 代表向xxx输出数据的端口
//将当前输出缓冲器输出的数据接到输出端口上
assign mem_data_in=(!input_buf==`buf1)?buf1.fifo_out[3:0]:buf2.fifo_out[3:0];
assign cpu_data_in=(!input_buf==`buf1)?buf1.fifo_out:buf2.fifo_out;

//外部数据输入:

assign buf1.output_enable=((mode==`mode_cpu_to_mem)?dma_to_mem_enable:dma_to_cpu_enable)&(!input_buf==`buf1);
//buf1(FIFO1)的output_enable根据其输入输出状态, 数据传输方向分别制定为dma_to_mem_enable和dma_to_cpu_enable
assign buf2.output_enable=((mode==`mode_cpu_to_mem)?dma_to_mem_enable:dma_to_cpu_enable)&(!input_buf==`buf2);
//buf2(FIFO2)的output_enable根据其输入输出状态, 数据传输方向分别制定为dma_to_mem_enable和dma_to_cpu_enable
assign buf1.input_valid=((mode==`mode_cpu_to_mem)?cpu_to_dma_valid:mem_to_dma_valid)&(input_buf==`buf1);
//buf1(FIFO1)的input_valid根据其输入输出状态, 数据传输方向分别制定为cpu_to_dma_valid和mem_to_dma_valid
assign buf2.input_valid=((mode==`mode_cpu_to_mem)?cpu_to_dma_valid:mem_to_dma_valid)&(input_buf==`buf2);
//buf2(FIFO2)的input_valid根据其输入输出状态, 数据传输方向分别制定为cpu_to_dma_valid和mem_to_dma_valid

//根据数据传输方向的不同, 将输入分别置为cpu的数据输入和mem的数据输入
assign buf1.fifo_in=((mode==`mode_cpu_to_mem)?cpu_data_out:{4'b0000,mem_data_out});
assign buf2.fifo_in=((mode==`mode_cpu_to_mem)?cpu_data_out:{4'b0000,mem_data_out});

//带地址控制的版本新引入:

//快速置满置空控制
//如果外部有fill_fifo信号输入, 置满当前输入FIFO, 注意:如果当前有有效信号输入, 会被正常保存到FIFO上当前位置
assign buf1.fill_fifo=((input_buf==`buf1)?fill_fifo:0);
assign buf2.fill_fifo=((input_buf==`buf2)?fill_fifo:0);
//如果外部有empty_fifo信号输入, 置空当前输出FIFO. 注意:不影响当前正常输出
assign buf1.empty_fifo=((~input_buf==`buf1)?empty_fifo:0);
assign buf2.empty_fifo=((~input_buf==`buf2)?empty_fifo:0);

//aaa_bbb_trans表示从aaa到bbb成功进行了一次数据传输, 根据状态的不同, 长度可能是4bit或8bit
//逻辑是: 在对应的状态下, 一个方向的enable和valid信号同时为1, 此时发生了一次数据传输
//这两个接口用于辅助进行数据传输的长度统计
assign dma_cpu_trans=((mode==`mode_cpu_to_mem)?(cpu_to_dma_valid & cpu_to_dma_enable):(dma_to_cpu_enable & dma_to_cpu_valid));
assign dma_mem_trans=((mode==`mode_cpu_to_mem)?(dma_to_mem_enable & dma_to_mem_valid):(mem_to_dma_valid & mem_to_dma_enable));


//这部分代码用于根据传输方向, 初始化两个FIFO的工作模式
always@(posedge clk)
begin
    if(!resetn)
    begin
        input_buf=`buf1; //初始化第一个接收数据的FIFO为FIFO1
        if(mode==`mode_cpu_to_mem)
        begin
            // workmode_4
            buf1_mode<=`workmode_8; //一开始buf1从cpu接收数据, 位宽为8bit
            buf2_mode<=`workmode_4; //一开始buf2向mem发送数据, 位宽为4bit
        end
        else//(mode==`mode_mem_to_cpu)
        begin
            buf1_mode<=`workmode_4;//一开始buf1从mem接收数据, 位宽为4bit
            buf2_mode<=`workmode_8;//一开始buf2向cpu发送数据, 位宽为6bit
        end
    end
end

//这部分代码用于在两个FIFO输入输出互换时调整输入/输出接口位宽
always@(*)
begin
    if(buf1.full&buf2.empty)//1满2空-->切换到1输出2输入
        begin 
            input_buf<=`buf2;
            if(mode==`mode_cpu_to_mem)//位宽调整
            begin
                buf2_mode<=`workmode_8;
                buf1_mode<=`workmode_4;
            end
            else//(mode==`mode_mem_to_cpu)
            begin
                buf2_mode<=`workmode_4;
                buf1_mode<=`workmode_8;
            end
        end
    if(buf2.full&buf1.empty)//2满1空-->切换到2输出1输入
        begin
            input_buf<=`buf1;
            if(mode==`mode_cpu_to_mem)//位宽调整
            begin
                buf1_mode<=`workmode_8;
                buf2_mode<=`workmode_4;
            end
            else//(mode==`mode_mem_to_cpu)
            begin
                buf1_mode<=`workmode_4;
                buf2_mode<=`workmode_8;
            end
        end
end

endmodule

//这个模块是在有地址的版本中新引入的控制模块
module ADDRESS_TRANSMITER(
    input clk,
    input resetn,
    input address_in_valid,     //CPU传入给DMA地址值有效
    input address_out_enable,   //DMA传出地址值可被MEM接收
    input dma_cpu_trans,     //判断dma,cpu是否产生8bit数据交换
    input dma_mem_trans,     //判断dma,mem是否产生4bit数据交换
    input [31:0]len_in,     //接收传入的长度
    input [31:0]addr_in,    //接收传入的地址
    input mode_in,      //工作模式确认
    output reg address_in_enable,   //DMA可接受CPU地址输入
    output reg address_out_valid,    //DMA传出给MEM地址值有效
    output reg dma_cpu_control,     //控制DMA-CPU数据端口 1代表交由dma控制, 0代表由此模块接管
    output reg dma_mem_control,     //控制DMA-MEM数据端口 1代表交由dma控制, 0代表由此模块接管
    // output reg transmiting,     //dma正在传输数据
    output reg [31:0]address_reg,   //地址暂存器
    output reg [31:0]len_reg,        //长度暂存器 unit: bit
    output reg [31:0]dma_cpu,         //dma-cpu的数据计数 unit: bit
    output reg [31:0]dma_mem,         //dma-mem的数据计数 unit: bit
    output fill_fifo, //置满当前输入fifo, 在满足条件时信号立即变化
    output empty_fifo //置空当前输出fifo, 在满足条件时信号立即变化
);

reg mode_reg;//储存传输方向设置

reg mem_4bit_cnt;//储存mem方向传输的低/高位情况

always@(posedge clk)
if(!resetn)//初始化
begin
    //初始化计数器, 寄存器为0
    len_reg<=0;
    dma_cpu<=0;
    dma_mem<=0;
    mem_4bit_cnt<=0; 
    address_reg<=0;

    address_in_enable<=1; //允许地址输入
    address_out_valid<=0; //禁止地址输出
    dma_cpu_control<=0; //关闭dma-cpu数据传输
    dma_mem_control<=0; //关闭dma-mem数据传输
    mode_reg<=mode_in; //加载传输方向设置
end

//这个控制模块实际的作用是: 接管原有DMA的输入输出控制端口, 无论外界数据为何, 只有在地址传输成功的情况下才开放数据传输, 否则使得原DMA的输入输出信号都体现为0

//There 4 status in total, 3 used in a work circle: address_in_enable,address_out_valid: 10 01 00 
//地址控制部分的工作按以下模式: 等待地址传入10 -> 等待地址传出01 -> 等待数据传输结束00 -> 等待地址传入10
//期间为加速数据传输, 规定DMA在从CPU获取地址之后就可以与CPU进行数据通信

//处理地址数据的传入传出
always@(posedge clk)
if(resetn)
begin
    if(address_in_enable&address_in_valid)//地址传入, 打开cpu-dma数据通道
    begin
        address_reg<=addr_in; //记录地址
        len_reg<=len_in; //记录长度
        
        if(len_in!=0)
        begin
            dma_cpu_control<=1;//打开cpu-dma数据通道
        end
        
        //状态跳转(见上方文字说明)
        address_in_enable<=0; 
        address_out_valid<=1;
    end
    if(address_out_enable&address_out_valid)//地址传出, 打开dma-mem数据通道
    begin
        if(len_reg!=0)
        begin
            dma_mem_control<=1; //打开dma-mem数据通道
        end

        //状态跳转
        address_out_valid<=0;
    end
end
//鲁棒性说明:尽管数据长度0是毫无意义的, 但是这里仍然做了处理以保证其鲁棒性. 在这种情况下, 地址会正常传输, 但是不会有数据传输发生.



//计数数据的传入传出, 在数据传入传出结束之后重新开始地址的传入传出
always@(posedge clk)
if(resetn)
begin
    // input dma_cpu_trans,     //判断dma,cpu是否产生8bit数据交换
    // input dma_mem_trans,     //判断dma,mem是否产生4bit数据交换
    if(dma_cpu_trans)//dma,cpu产生8bit数据交换
    begin
    if(dma_cpu==len_reg-1)//cpu-dma传输的数据达到要求的长度
        begin
            dma_cpu_control<=0;//关闭dma-cpu数据通道
            //此后不应再有dma_cpu_trans
            dma_cpu<=dma_cpu+1;
        end
    else
        begin
            dma_cpu<=dma_cpu+1;
        end
    end

    if(dma_mem_trans)//dma,mem产生4bit数据交换
    begin
    if(mem_4bit_cnt==0)
    begin
        mem_4bit_cnt<=mem_4bit_cnt+1;
    end
    else
    begin
        if(dma_mem==len_reg-1)
            begin
                dma_mem_control<=0;
                //此后不应再有dma_mem_trans
                dma_mem<=dma_mem+1;
                mem_4bit_cnt<=0;
            end
        else
            begin
                dma_mem<=dma_mem+1;
                mem_4bit_cnt<=0;//高低位转化
            end
        end
    end

    if((dma_mem==len_reg)&(dma_cpu==len_reg)&(len_reg!=0))//进出数据均已传输完成, 可以进行下一次地址传输
    begin
        //归0计数器
        dma_mem<=0;
        dma_cpu<=0;
        //状态跳转
        address_in_enable<=1;
    end
end
    
    //当数据未满FIFO长度就满足长度要求时, 直接置满/置空FIFO是其可以正常交换

    //对于不同的传输方向, 判断是否满足长度要求的方法也不同
    //当输入满足要求的长度时:
    assign fill_fifo=(mode_reg==`mode_mem_to_cpu)?((dma_mem==(len_reg-1))&dma_mem_trans&(mem_4bit_cnt)):((dma_cpu==(len_reg-1))&dma_cpu_trans);
    //当输出满足要求的长度时:
    assign empty_fifo=(mode_reg==`mode_mem_to_cpu)?((dma_cpu==(len_reg-1))&dma_cpu_trans):((dma_mem==(len_reg-1))&dma_mem_trans&(mem_4bit_cnt));
endmodule

//带有地址版本的DMA实现, 由原有的DMA与地址控制模块共同组成
module DMA_ADDRESS(

//数据部分------------------------------------------------------------

input clk,
input resetn,
input mode,              //模式选择:控制DMA的工作方式:内存->CPU 或 CPU->内存

input dma_to_mem_enable, //MEM是否准备好接收数据。
input mem_to_dma_valid, //MEM中传入的数据是否有效。
input dma_to_cpu_enable, //CPU是否准备好接收数据。
input cpu_to_dma_valid, //CPU传入的数据是否有效。

input [3:0] mem_data_out, //内存信号输出
input [7:0] cpu_data_out,  //中央处理器信号输出

output dma_to_mem_valid, //向MEM传出的数据是否有效
output mem_to_dma_enable, //DMA准备好自MEM接收数据
output cpu_to_dma_enable, //DMA准备好自CPU接收数据
output dma_to_cpu_valid, //向CPU传出的数据是否有效

output [3:0] mem_data_in, //内存信号输入
output [7:0] cpu_data_in,  //中央处理器信号输入

//地址控制部分------------------------------------------------------

input address_in_valid,     //CPU传入给DMA地址值有效
input address_out_enable,  //DMA传出地址值可被MEM接收
input [31:0]len_in,     //接收传入的长度
input [31:0]addr_in,    //接收传入的地址

output address_out_valid,   //DMA处于可以传出地址状态
output address_in_enable,  //CPU传出地址值可被DMA接收, DMA处于可以接受地址状态

output [31:0] address_reg,   //地址暂存器
output [31:0] len_reg        //长度暂存器 unit: bit

);

//这些内部接线是为了便于地址控制模块直接控制原DMA模块的输入输出
wire _dma_to_mem_enable;
wire _mem_to_dma_valid;
wire _dma_to_cpu_enable;
wire _cpu_to_dma_valid;
wire _dma_to_mem_valid;
wire _mem_to_dma_enable;
wire _cpu_to_dma_enable;
wire _dma_to_cpu_valid;

DMA dma(

    .clk(clk),
    .resetn(resetn),
    .mode(mode),

    .dma_to_mem_enable(_dma_to_mem_enable), //MEM是否准备好接收数据。
    .mem_to_dma_valid(_mem_to_dma_valid), //MEM中传入的数据是否有效。
    .dma_to_cpu_enable(_dma_to_cpu_enable), //CPU是否准备好接收数据。
    .cpu_to_dma_valid(_cpu_to_dma_valid), //CPU传入的数据是否有效。

    .mem_data_out(mem_data_out), //内存信号输出
    .cpu_data_out(cpu_data_out),  //中央处理器信号输出

    .dma_to_mem_valid(_dma_to_mem_valid), //向MEM传出的数据是否有效
    .mem_to_dma_enable(_mem_to_dma_enable), //DMA准备好自MEM接收数据
    .cpu_to_dma_enable(_cpu_to_dma_enable), //DMA准备好自CPU接收数据
    .dma_to_cpu_valid(_dma_to_cpu_valid), //向CPU传出的数据是否有效

    .mem_data_in(mem_data_in), //内存信号输入
    .cpu_data_in(cpu_data_in),  //中央处理器信号输入

    //新引入:
    // .dma_cpu_trans, //输出dma是否成功的传送了8bit/4bit信息, 以方便外层控制逻辑计数, 注意传输方向不同时计数所对应的数据长度也不同
    // .dma_mem_trans, //输出dma是否成功的传送了8bit/4bit信息, 以方便外层控制逻辑计数, 注意传输方向不同时计数所对应的数据长度也不同
    .fill_fifo(addr.fill_fifo), //置满当前输入fifo, 在满足条件时信号立即变化:当前输入的信号已经达到了控制信息所要求的长度
    .empty_fifo(addr.empty_fifo) //置空当前输入fifo, 在满足条件时信号立即变化

);

ADDRESS_TRANSMITER addr(

    .clk(clk),
    .resetn(resetn),
    .dma_cpu_trans(dma.dma_cpu_trans),     //判断dma,cpu是否产生8bit数据交换
    .dma_mem_trans(dma.dma_mem_trans),     //判断dma,mem是否产生4bit数据交换
    .len_in(len_in),     //接收传入的长度
    .addr_in(addr_in),    //接收传入的地址
    .mode_in(mode),      //工作模式确认

    .address_in_valid(address_in_valid),     //CPU传入给DMA地址值有效
    .address_out_enable(address_out_enable),   //DMA传出地址值可被MEM接收
    .address_in_enable(address_in_enable),   //DMA可接受CPU地址输入
    .address_out_valid(address_out_valid),    //DMA传出给MEM地址值有效
    // .dma_cpu_control(dma_cpu_control),     //控制DMA-CPU数据端口 1代表交由dma控制, 0代表由此模块接管
    // .dma_mem_control(dma_mem_control),     //控制DMA-MEM数据端口 1代表交由dma控制, 0代表由此模块接管
    
    .address_reg(address_reg),   //地址暂存器
    .len_reg(len_reg)        //长度暂存器 unit: bit
    // .dma_cpu(dma_cpu),         //dma-cpu的数据计数 unit: bit
    // .dma_mem(dma_mem)         //dma-mem的数据计数 unit: bit
    // .fill_fifo(), //置满当前输入fifo, 在满足条件时信号立即变化
    // .empty_fifo() //置空当前输出fifo, 在满足条件时信号立即变化
);

//使用新引出的这两根线, 用与门直接控制原DMA的控制信号. 要关闭一个方向的传输, 只需将控制信号全置0(&0), 开启传输只需(&1)
wire dma_mem_control;
wire dma_cpu_control;

assign dma_mem_control=addr.dma_mem_control;
assign dma_cpu_control=addr.dma_cpu_control;
//新引出的信号由地址控制模块驱动

//改写外部传入信号
assign _dma_to_mem_enable=dma_to_mem_enable&dma_mem_control;
assign _mem_to_dma_valid=mem_to_dma_valid&dma_mem_control;
assign _dma_to_cpu_enable=dma_to_cpu_enable&dma_cpu_control;
assign _cpu_to_dma_valid=cpu_to_dma_valid&dma_cpu_control;

//改写内部传出信号
assign dma_to_mem_valid=_dma_to_mem_valid&dma_mem_control;
assign mem_to_dma_enable=_mem_to_dma_enable&dma_mem_control;
assign cpu_to_dma_enable=_cpu_to_dma_enable&dma_cpu_control;
assign dma_to_cpu_valid=_dma_to_cpu_valid&dma_cpu_control;

endmodule