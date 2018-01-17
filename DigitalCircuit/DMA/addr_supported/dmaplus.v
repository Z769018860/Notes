// Copyright (c) 2017 Augustus Wang.

`timescale 1ns/1ps
`define workmode_4 0 //Uses [3:0] in inout socket
`define workmode_8 1

module FIFO(
    input clk,
    input resetn,
    input workmode, //决定每次输入输出的位宽
    input input_valid, output_enable,  //外部信号:输入值有效, 可以进行输出
    input [7:0] fifo_in,        //8bits输入端口
    output [7:0] fifo_out,   //8bits输出端口
    output reg output_valid,
    output reg input_enable,
    output empty,
    output full,

    //新引入:地址及长度处理部分
    input fill_fifo, //在当前操作结束后直接置满当前buff, 使之可以传输(翻转)
    input empty_fifo //在当前操作结束后直接置空当前buff, 使之可以翻转
);
reg [7:0]ram[7:0];
reg [2:0]position;
reg writehigh;

assign empty=(position==0)&(!writehigh)&(input_enable);
assign full=(position==0)&(!writehigh)&(output_valid);

assign fifo_out=(writehigh?{4'b0000,ram[position][7:4]}:ram[position]);

always@(posedge clk)
begin
    if(!resetn)//初始化/重置
    begin
        input_enable<=1;
        output_valid<=0;
        position<=3'b0;
        writehigh<=0;
    end

    if(fill_fifo)//置满
    begin

        if(input_enable&input_valid)
        begin
            if(workmode==`workmode_8)        
            begin
                ram[position]<=fifo_in;
            end
            else
            begin
                if(writehigh)
                begin
                    ram[position][7:4]<=fifo_in;
                end
            end
        end
        input_enable<=0;
        output_valid<=1;
        position<=3'b0;
        writehigh<=0;
    end

    else
    if(empty_fifo)//置空
    begin
        input_enable<=1;
        output_valid<=0;
        position<=3'b0;
        writehigh<=0;
    end
    else
    begin
        if(workmode==`workmode_8)
        case({input_enable,input_valid,output_enable,output_valid})
            4'b1100://input
            begin
                ram[position]<=fifo_in;
                position<=position+1;
                if(position==7)
                begin 
                    input_enable<=0;
                    output_valid<=1;
                end
            end
            4'b0011://output
            begin
                position<=position+1;
                if(position==7)
                begin 
                    input_enable<=1;
                    output_valid<=0;
                end
            end    
            default:
            ;
        endcase

        if(workmode==`workmode_4)
        case({input_enable,input_valid,output_enable,output_valid})
            4'b1100://input
            begin
                if(writehigh)
                begin
                    ram[position][7:4]<=fifo_in;
                    position<=position+1;
                    writehigh<=0;
                    if(position==7)
                    begin 
                        input_enable<=0;
                        output_valid<=1;
                    end
                end
                else//(!write_high)
                begin
                    ram[position][3:0]<=fifo_in;
                    writehigh<=1;
                end
            end
            4'b0011://output
            begin
                if(writehigh)
                begin
                    position<=position+1;
                    writehigh<=0;
                    if(position==7)
                    begin 
                        input_enable<=1;
                        output_valid<=0;
                    end
                end
                else//(!write_high)
                begin
                    writehigh<=1;
                end
            end   
            default:
            ;
        endcase        
    end
end

endmodule

`define mode_cpu_to_mem 1'b1
`define mode_mem_to_cpu 1'b0
`define buf1 1'b0
`define buf2 1'b1

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
input empty_fifo //置空当前输入fifo, 在满足条件时信号立即变化
);

reg buf1_mode;
reg buf2_mode;

reg input_buf;

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

//~input_buf means ouput_buf

assign dma_to_mem_valid=(mode==`mode_cpu_to_mem)&((~input_buf==`buf1)?buf1.output_valid:buf2.output_valid); 
assign mem_to_dma_enable=(mode==`mode_mem_to_cpu)&((input_buf==`buf1)?buf1.input_enable:buf2.input_enable);
assign cpu_to_dma_enable=(mode==`mode_cpu_to_mem)&((input_buf==`buf1)?buf1.input_enable:buf2.input_enable);
assign dma_to_cpu_valid=(mode==`mode_mem_to_cpu)&((~input_buf==`buf1)?buf1.output_valid:buf2.output_valid); 
assign mem_data_in=(!input_buf==`buf1)?buf1.fifo_out[3:0]:buf2.fifo_out[3:0];
assign cpu_data_in=(!input_buf==`buf1)?buf1.fifo_out:buf2.fifo_out;

// assign dma_to_mem_enable=(!input_buf==`buf1)?buf1.output_enable:buf2.output_enable;
// assign mem_to_dma_valid=(input_buf==`buf1)?buf1.input_valid:buf2.input_valid;
// assign dma_to_cpu_enable=(!input_buf==`buf1)?buf1.output_enable:buf2.output_enable;
// assign cpu_to_dma_valid=(input_buf==`buf1)?buf1.input_valid:buf2.input_valid;
assign buf1.output_enable=((mode==`mode_cpu_to_mem)?dma_to_mem_enable:dma_to_cpu_enable)&(!input_buf==`buf1);
assign buf2.output_enable=((mode==`mode_cpu_to_mem)?dma_to_mem_enable:dma_to_cpu_enable)&(!input_buf==`buf2);
assign buf1.input_valid=((mode==`mode_cpu_to_mem)?cpu_to_dma_valid:mem_to_dma_valid)&(input_buf==`buf1);
assign buf2.input_valid=((mode==`mode_cpu_to_mem)?cpu_to_dma_valid:mem_to_dma_valid)&(input_buf==`buf2);

// assign mem_data_out[3:0]=(input_buf==`buf1)?buf1.fifo_in[3:0]:buf2.fifo_in[3:0];
// assign cpu_data_out[7:0]=(input_buf==`buf1)?buf1.fifo_in:buf2.fifo_in;
assign buf1.fifo_in=((mode==`mode_cpu_to_mem)?cpu_data_out:{4'b0000,mem_data_out});
assign buf2.fifo_in=((mode==`mode_cpu_to_mem)?cpu_data_out:{4'b0000,mem_data_out});

assign buf1.fill_fifo=((input_buf==`buf1)?fill_fifo:0);
assign buf2.fill_fifo=((input_buf==`buf2)?fill_fifo:0);
assign buf1.empty_fifo=((~input_buf==`buf1)?empty_fifo:0);
assign buf2.empty_fifo=((~input_buf==`buf2)?empty_fifo:0);

assign dma_cpu_trans=((mode==`mode_cpu_to_mem)?(cpu_to_dma_valid & cpu_to_dma_enable):(dma_to_cpu_enable & dma_to_cpu_valid));
assign dma_mem_trans=((mode==`mode_cpu_to_mem)?(dma_to_mem_enable & dma_to_mem_valid):(mem_to_dma_valid & mem_to_dma_enable));

// P-code
// always@(*)
// if(mode==`mode_mem_to_cpu)
// begin
//     if(input_buf==`buf1)
//     begin
//         mem_to_dma_enable=buf1.input_enable;
//         buf1.input_valid=mem_to_dma_valid;
//         dma_to_cpu_valid=buf2.output_valid;
//         buf2.output_enable=dma_to_cpu_enable;
//         buf1.fifo_in=mem_data_out;
//         cpu_data_in=buf2.fifo_out;
//     end
//     else//(input_buf==`buf2)
//     begin
//         mem_to_dma_enable=buf2.input_enable;
//         buf2.input_valid=mem_to_dma_valid;
//         dma_to_cpu_valid=buf1.output_valid;
//         buf1.output_enable=dma_to_cpu_enable;
//         buf2.fifo_in=mem_data_out;
//         cpu_data_in=buf1.fifo_out;
//     end
// end
// else//(mode==`mode_cpu_to_mem)
// begin
//     if(input_buf==`buf1)
//     begin
//         cpu_to_dma_enable=buf1.input_enable;
//         buf1.input_valid=cpu_to_dma_valid;
//         dma_to_mem_valid=buf2.output_valid;
//         buf2.output_enable=dma_to_mem_enable;
//         buf1.fifo_in=cpu_data_out;
//         mem_data_in=buf2.fifo_out;
//     end
//     else//(input_buf==`buf2)
//     begin
//         cpu_to_dma_enable=buf2.input_enable;
//         buf2.input_valid=cpu_to_dma_valid;
//         dma_to_mem_valid=buf1.output_valid;
//         buf1.output_enable=dma_to_mem_enable;
//         buf2.fifo_in=cpu_data_out;
//         mem_data_in=buf1.fifo_out;
//     end
// end

always@(posedge clk)
begin
    if(!resetn)
    begin
        input_buf=`buf1;
        if(mode==`mode_cpu_to_mem)
        begin
            // workmode_4
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

always@(*)
begin
    if(buf1.full&buf2.empty)
        begin 
            input_buf<=`buf2;
            if(mode==`mode_cpu_to_mem)
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
    if(buf2.full&buf1.empty)
        begin
            input_buf<=`buf1;
            if(mode==`mode_cpu_to_mem)
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

reg mode_reg;

reg mem_4bit_cnt;

always@(posedge clk)
if(!resetn)
begin
    len_reg<=0;
    dma_cpu<=0;
    dma_mem<=0;
    address_reg<=0;
    address_in_enable<=1;
    address_out_valid<=0;
    dma_cpu_control<=0;
    dma_mem_control<=0;
    mode_reg<=mode_in;
    mem_4bit_cnt<=0;
end

//There 4 status in total: address_in_enable,address_out_valid: 10 01 00 

//处理地址数据的传入传出
always@(posedge clk)
if(resetn)
begin
    if(address_in_enable&address_in_valid)//地址传入, 打开cpu-dma数据通道
    begin
        address_reg<=addr_in;
        len_reg<=len_in;
        dma_cpu_control<=1;//打开cpu-dma数据通道
        address_in_enable<=0;
        address_out_valid<=1;
    end
    if(address_out_enable&address_out_valid)//地址传出, 打开dma-mem数据通道
    begin
        dma_mem_control<=1;
        address_out_valid<=0;
    end
end


//地址传出, 打开dma-mem数据通道
//地址传入, 打开cpu-mem数据通道


//计数数据的传入传出, 在数据传入传出结束之后重新开始地址的传入传出
always@(posedge clk)
if(resetn)
begin
    // input dma_cpu_trans,     //判断dma,cpu是否产生8bit数据交换
    // input dma_mem_trans,     //判断dma,mem是否产生4bit数据交换
    if(dma_cpu_trans)
    begin
    if(dma_cpu==len_reg-1)
        begin
            dma_cpu_control<=0;
            //此后不应再有dma_cpu_trans
            dma_cpu<=dma_cpu+1;
        end
    else
        begin
            dma_cpu<=dma_cpu+1;
        end
    end

    if(dma_mem_trans)
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
                mem_4bit_cnt<=0;
            end
        end
    end

    if((dma_mem==len_reg)&(dma_cpu==len_reg)&(len_reg!=0))//进出数据均已传输完成, 可以进行下一次地址传输
    begin
        dma_mem<=0;
        dma_cpu<=0;
        address_in_enable<=1;
    end
end
    
    assign fill_fifo=(mode_reg==`mode_mem_to_cpu)?((dma_mem==(len_reg-1))&dma_mem_trans&(mem_4bit_cnt)):((dma_cpu==(len_reg-1))&dma_cpu_trans);
    assign empty_fifo=(mode_reg==`mode_mem_to_cpu)?((dma_cpu==(len_reg-1))&dma_cpu_trans):((dma_mem==(len_reg-1))&dma_mem_trans&(mem_4bit_cnt));
endmodule

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

wire dma_mem_control;
wire dma_cpu_control;

assign dma_mem_control=addr.dma_mem_control;
assign dma_cpu_control=addr.dma_cpu_control;

assign _dma_to_mem_enable=dma_to_mem_enable&dma_mem_control;
assign _mem_to_dma_valid=mem_to_dma_valid&dma_mem_control;
assign _dma_to_cpu_enable=dma_to_cpu_enable&dma_cpu_control;
assign _cpu_to_dma_valid=cpu_to_dma_valid&dma_cpu_control;
assign dma_to_mem_valid=_dma_to_mem_valid&dma_mem_control;
assign mem_to_dma_enable=_mem_to_dma_enable&dma_mem_control;
assign cpu_to_dma_enable=_cpu_to_dma_enable&dma_cpu_control;
assign dma_to_cpu_valid=_dma_to_cpu_valid&dma_cpu_control;

endmodule