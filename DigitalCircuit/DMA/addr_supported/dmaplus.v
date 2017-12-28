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
    output reg[7:0] fifo_out,   //8bits输出端口
    output reg output_valid,
    output reg input_enable,
    output empty,
    output full,

    //地址及长度处理部分
    input fill_fifo

);
reg [7:0]ram[7:0];
reg [2:0]position;
reg writehigh;

assign empty=(position==0)&(!writehigh)&(input_enable);
assign full=(position==0)&(!writehigh)&(output_valid);

always@(posedge clk)
begin
    if(!resetn)
    begin
        fifo_out<=8'b0;
        input_enable<=1;
        output_valid<=0;
        position<=3'b0;
        writehigh<=0;
    end
    if(fill_fifo)
    begin
        input_enable<=0;
        output_valid<=1;
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
                fifo_out<=ram[position];
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
                    fifo_out[3:0]<=ram[position][7:4];
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
                    fifo_out[3:0]<=ram[position][3:0];
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

//地址控制部分------------------------------------------------------

input address_in_valid,     //CPU传入给DMA地址值有效
input address_out_valid,   //DMA处于可以传出地址状态
input [31:0]len_in,     //接收传入的长度
input [31:0]addr_in,    //接收传入的地址

output address_out_enable,  //DMA传出地址值可被MEM接收
output address_in_enable,  //CPU传出地址值可被DMA接收, DMA处于可以接受地址状态
output [3:0] mem_data_in, //内存信号输入
output [7:0] cpu_data_in,  //中央处理器信号输入
output [31:0] address_reg,   //地址暂存器
output [31:0] len_reg        //长度暂存器 unit: bit

);

reg buf1_mode;
reg buf2_mode;

reg input_buf;

//-------------------------------------------------------
// wire address_in_enable;   //DMA可接受CPU地址输入
// wire address_out_valid;    //DMA传出给MEM地址值有效
wire dma_cpu_control;     //控制DMA-CPU数据端口
wire dma_mem_control;     //控制DMA-MEM数据端口
wire fill_fifo;     //dma正在传输数据
// wire [31:0]dma_recv         //dma已经接受的数据计数 unit: bit


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

assign dma_to_mem_valid=(mode==`mode_cpu_to_mem)&((~input_buf==`buf1)?buf1.output_valid:buf2.output_valid); 
assign mem_to_dma_enable=(dma_mem_control)&(mode==`mode_mem_to_cpu)&((input_buf==`buf1)?buf1.input_enable:buf2.input_enable);
assign cpu_to_dma_enable=(dma_cpu_control)&(mode==`mode_cpu_to_mem)&((input_buf==`buf1)?buf1.input_enable:buf2.input_enable);
assign dma_to_cpu_valid=(mode==`mode_mem_to_cpu)&((~input_buf==`buf1)?buf1.output_valid:buf2.output_valid); 
assign mem_data_in=(!input_buf==`buf1)?buf1.fifo_out[3:0]:buf2.fifo_out[3:0];
assign cpu_data_in=(!input_buf==`buf1)?buf1.fifo_out:buf2.fifo_out;

assign buf1.output_enable=((mode==`mode_cpu_to_mem)?dma_to_mem_enable:dma_to_cpu_enable)&(!input_buf==`buf1);
assign buf2.output_enable=((mode==`mode_cpu_to_mem)?dma_to_mem_enable:dma_to_cpu_enable)&(!input_buf==`buf2);
assign buf1.input_valid=((mode==`mode_cpu_to_mem)?cpu_to_dma_valid&dma_cpu_control:mem_to_dma_valid&dma_mem_control)&(input_buf==`buf1);
assign buf2.input_valid=((mode==`mode_cpu_to_mem)?cpu_to_dma_valid&dma_cpu_control:mem_to_dma_valid&dma_mem_control)&(input_buf==`buf2);
assign buf1.fifo_in=((mode==`mode_cpu_to_mem)?cpu_data_out:{4'b0000,mem_data_out});
assign buf2.fifo_in=((mode==`mode_mem_to_cpu)?cpu_data_out:{4'b0000,mem_data_out});

//判断dma是否收到1bit数据
assign dma_received=(mode==`mode_cpu_to_mem)?(cpu_to_dma_enable&cpu_to_dma_valid&dma_cpu_control):(mem_to_dma_enable&mem_to_dma_valid&dma_mem_control);
// always@(posedge clk)
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



assign buf1.fill_fifo=fill_fifo&(input_buf==`buf1);
assign buf2.fill_fifo=fill_fifo&(input_buf==`buf2);

ADDRESS_TRANSMITER atins(
    .clk(clk),
    .resetn(resetn),
    .address_in_valid(address_in_valid),     //CPU传入给DMA地址值有效
    .address_out_enable(address_out_enable),   //DMA传出地址值可被MEM接收
    .dma_received(dma_received),     //判断dma是否收到1bit数据
    .len_in(len_in),     //接收传入的长度
    .addr_in(addr_in),    //接收传入的地址
    .mode_in(mode), //工作模式确认
    .address_in_enable(address_in_enable),   //DMA可接受CPU地址输入
    .address_out_valid(address_out_valid),    //DMA传出给MEM地址值有效
    .dma_cpu_control(dma_cpu_control),     //控制DMA-CPU数据端口
    .dma_mem_control(dma_mem_control),     //控制DMA-MEM数据端口
    .fill_fifo(fill_fifo),     //dma正在传输数据
    .address_reg(address_reg),   //地址暂存器
    .len_reg(len_reg)        //长度暂存器 unit: bit
    // .dma_recv         //dma已经接受的数据计数 unit: bit
);

endmodule

module ADDRESS_TRANSMITER(
    input clk,
    input resetn,
    input address_in_valid,     //CPU传入给DMA地址值有效
    input address_out_enable,   //DMA传出地址值可被MEM接收
    input dma_received,     //判断dma是否收到1bit数据
    input [31:0]len_in,     //接收传入的长度
    input [31:0]addr_in,    //接收传入的地址
    input mode_in,      //工作模式确认
    output reg address_in_enable,   //DMA可接受CPU地址输入
    output reg address_out_valid,    //DMA传出给MEM地址值有效
    output reg dma_cpu_control,     //控制DMA-CPU数据端口
    output reg dma_mem_control,     //控制DMA-MEM数据端口
    output reg transmiting,     //dma正在传输数据
    output reg [31:0]address_reg,   //地址暂存器
    output reg [31:0]len_reg,        //长度暂存器 unit: bit
    output reg [31:0]dma_recv,         //dma已经接受的数据计数 unit: bit
    output reg fill_fifo
);

reg mode_reg;

always@(posedge clk)
if(!resetn)
begin
    len_reg<=0;
    dma_recv<=0;
    address_reg<=0;
    address_in_enable<=1;
    address_out_valid<=0;
    dma_cpu_control<=1;
    dma_mem_control<=0;
    transmiting<=0;
    mode_reg<=mode_in;
    fill_fifo<=0;
end
else
begin
    if(fill_fifo)
        fill_fifo<=0;
    if(address_in_enable&address_in_valid)
    begin
    //接收cpu传入的地址和长度, 激活传出状态, 若cpu->mem, 则cpu已经可进行传输, 激活dma读取状态
        address_reg=addr_in;
        len_reg<=len_in;
        address_in_enable<=0;
        address_out_valid<=1;
        if(mode_reg==`mode_cpu_to_mem)
        begin
            transmiting<=1;
            dma_mem_control<=1;
            dma_cpu_control<=1;
        end    
    end
    
    if(address_out_enable&address_out_valid)
    begin
    //向mem传出地址和长度, 若mem->cpu, 则mem已经可进行传输
        if(mode_reg==`mode_mem_to_cpu)
            transmiting<=1;
        dma_mem_control<=1;
        dma_cpu_control<=1;
        address_out_valid<=0;
    end

    if(transmiting&dma_received)//dma读取状态, 在读取到需要的长度以后终止读取, 但写入依然正常进行
        dma_recv=dma_recv+1;
        if(dma_recv>=len_reg)
        begin
            transmiting=0;
            //fillcurrentfifo negedge transmiting
            fill_fifo<=1;
            if(mode_reg==`mode_cpu_to_mem)
            begin
                dma_cpu_control<=0;
            end
            else//(mode_reg==`mode_mem_to_cpu)
            begin
                dma_mem_control<=0;
            end
            dma_recv<=0;
            address_in_enable<=1;
        end

end

endmodule

