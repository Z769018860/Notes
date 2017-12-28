// Copyright (c) 2017 Augustus Wang.

`define MODE 0
`timescale 1ns/1ps
// parameter mode_cpu_to_mem 1'b1;
// parameter mode_mem_to_cpu 1'b0;

module CPU(
input clk,
input resetn,
input cpu_to_dma_enable, //DMA准备好自CPU接收数据
input dma_to_cpu_valid, //向CPU传出的数据是否有效
input [7:0] cpu_in_socket,

output reg dma_to_cpu_enable, //CPU是否准备好接收数据。
output reg cpu_to_dma_valid, //CPU传入的数据是否有效。
output reg [7:0] cpu_out_socket,
//------------------------------
input addr_out_enable,  //DMA准备好自CPU接收地址
output reg addr_out_valid,  //CPU正在传出有效的地址

output reg [31:0] addr_out,
output reg [31:0] len_out

);
reg [31:0] out_cnt;
reg [31:0] addr_save;

always@ (posedge clk)
begin

    //give out random status and data.
    dma_to_cpu_enable<=$random%2;
    cpu_to_dma_valid<=$random%2;
    cpu_out_socket=$random%'b100000000;
    //---------------------------------------------

    addr_out_valid<=1;
    len_out<=0;
    addr_out<=0;
    addr_save<=0;
if(resetn)
begin
//-------------------------------------------------------------------------
        if(addr_out_enable&addr_out_valid)
        begin
          addr_out=$random;
          addr_len=8;
          addr_out_enable<=0;
          addr_save<=addr_out;
        end
        if(!addr_out_valid) //Data transfering
            if(cpu_to_dma_enable&cpu_to_dma_valid)
            begin
              out_cnt=out_cnt+1;
              if(out_cnt>=addr_save) //Transfer finished
              begin
                out_cnt<=0;
                addr_save<=0;
                addr_out_valid<=1;
              end
            end
//===================================================================
        if(cpu_to_dma_valid&cpu_to_dma_enable&addr_out_enable&addr_out_valid)
        begin
            $display("cpu->dma: cpu gived %x",cpu_out_socket);
        end

        if(dma_to_cpu_enable&dma_to_cpu_valid)
        begin
            $display("dma->cpu: cpu received %x",cpu_in_socket);
        end
end
end

endmodule

module MEM(
input clk,
input resetn,
input mem_to_dma_enable, //DMA准备好自MEM接收数据
input dma_to_mem_valid, //向MEM传出的数据是否有效
input [3:0] mem_in_socket,

output reg dma_to_mem_enable, //MEM是否准备好接收数据。
output reg mem_to_dma_valid, //MEM传入的数据是否有效。
output reg [3:0] mem_out_socket,
//--------------------------------------
input addr_in_valid,  //DMA传出有效的地址
output reg addr_in_enable,  //MEM可以接收地址

input [31:0] addr_in,
input [31:0] len_in

);
reg [7:0] _received;
reg [7:0]  _sent;
reg _rec_high;
reg _st_high;
//-------------------------
reg [31:0] len_reg;
reg [31:0] out_cnt;

initial
begin
    _rec_high<=0;
    _st_high<=0;
    _received<=8'b0;
    _sent<=8'b0;
end

always@ (posedge clk)

begin
    
    //give out random status and data.
    dma_to_mem_enable<=$random%2;
    mem_to_dma_valid<=$random%2;
    mem_out_socket<=$random%'b10000;
    
if(resetn)
    begin
    
    if(mem_to_dma_valid&mem_to_dma_enable)
    begin
        $display("mem->dma: mem gived %x",mem_out_socket);
        if(_st_high)
        begin
            _sent[7:4]=mem_out_socket;
            $display("mem gived %x in 8 bits",_sent);
            _st_high=~_st_high;            
        end
        else
        begin
            _sent[3:0]=mem_out_socket;
            _st_high=~_st_high;
        end
    end

    if(dma_to_mem_enable&dma_to_mem_valid&TEST.resetn)
    begin
        $display("dma->mem: mem received %x",mem_in_socket);
        if(_rec_high)
        begin
            _received[7:4]=mem_in_socket;
            $display("mem gived %x in 8 bits",_received);
            _rec_high=~_rec_high;            
        end
        else
        begin
            _received[3:0]=mem_in_socket;
            _rec_high=~_rec_high;
        end
    end
end
end

endmodule

module TEST();
reg clk;
reg resetn;
reg mode;

wire mem_to_dma_valid;
wire mem_to_dma_enable;
wire dma_to_mem_enable;
wire dma_to_mem_valid;
wire cpu_to_dma_valid;
wire cpu_to_dma_enable;
wire dma_to_cpu_enable;
wire dma_to_cpu_valid;
wire [3:0]mem_in_wire;
wire [3:0]mem_out_wire;
wire [7:0]cpu_in_wire;
wire [7:0]cpu_out_wire;

MEM memins(
    .clk(clk),
    .resetn(resetn),
    .mem_to_dma_enable(mem_to_dma_enable),
    .mem_to_dma_valid(mem_to_dma_valid),
    .dma_to_mem_enable(dma_to_mem_enable),
    .dma_to_mem_valid(dma_to_mem_valid),
    .mem_in_socket(mem_in_wire),
    .mem_out_socket(mem_out_wire)
);

CPU cpuins(
    .clk(clk),
    .resetn(resetn),
    .cpu_to_dma_enable(cpu_to_dma_enable),
    .cpu_to_dma_valid(cpu_to_dma_valid),
    .dma_to_cpu_enable(dma_to_cpu_enable),
    .dma_to_cpu_valid(dma_to_cpu_valid),
    .cpu_in_socket(cpu_in_wire),
    .cpu_out_socket(cpu_out_wire)
);

DMA dmains(
    .clk(clk),
    .resetn(resetn),
    .mode(mode),

    .dma_to_mem_enable(dma_to_mem_enable) , //MEM是否准备好接收数据。
    .mem_to_dma_valid(mem_to_dma_valid), //MEM中传入的数据是否有效。
    .dma_to_cpu_enable(dma_to_cpu_enable), //CPU是否准备好接收数据。
    .cpu_to_dma_valid(cpu_to_dma_valid),//CPU传入的数据是否有效。

    .mem_data_out(mem_out_wire),
    .cpu_data_out(cpu_out_wire),

    .dma_to_mem_valid(dma_to_mem_valid), //向MEM传出的数据是否有效
    .mem_to_dma_enable(mem_to_dma_enable), //DMA准备好自MEM接收数据
    .cpu_to_dma_enable(cpu_to_dma_enable), //DMA准备好自CPU接收数据
    .dma_to_cpu_valid(dma_to_cpu_valid), //向CPU传出的数据是否有效

    .mem_data_in(mem_in_wire),
    .cpu_data_in(cpu_in_wire)
//------------------------------------------
    .address_in_valid(cpuins.address_out_valid),     //CPU传入给DMA地址值有效
    .address_out_valid,   //DMA处于可以传出地址状态
    .len_in,     //接收传入的长度
    .addr_in,    //接收传入的地址
    .
    .address_out_enable,  //DMA传出地址值可被MEM接收
    .address_in_enable,  //CPU传出地址值可被DMA接收, DMA处于可以接受地址状态
    .mem_data_in, //内存信号输入
    .cpu_data_in,  //中央处理器信号输入
    .address_reg,   //地址暂存器
    .len_reg        //长度暂存器 unit: bit

);


initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0,TEST);
    $display("Start test.");
    clk=0;
    resetn=0;
    mode=`MODE;
    #100
    resetn=1;
//   #10000
//   $finish;
end

always@(posedge clk)
begin
end

always #50
begin
    clk=~clk;
end

endmodule