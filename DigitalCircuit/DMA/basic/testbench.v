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
input [7:0] cpu_in_socket,  //CPU的数据传入端口

output reg dma_to_cpu_enable, //CPU是否准备好接收数据。
output reg cpu_to_dma_valid, //CPU传入的数据是否有效。
output reg [7:0] cpu_out_socket //CPU的数据传出端口
);

always@ (posedge clk)
begin

    //give out random status and data.
    dma_to_cpu_enable<=$random%2;
    cpu_to_dma_valid<=$random%2;
    cpu_out_socket=$random%'b100000000;
if(resetn)
    begin
    if(cpu_to_dma_valid&cpu_to_dma_enable)
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
input [3:0] mem_in_socket, //CPU的数据传入端口

output reg dma_to_mem_enable, //MEM是否准备好接收数据。
output reg mem_to_dma_valid, //MEM传入的数据是否有效。
output reg [3:0] mem_out_socket //MEM的数据传入端口

);
reg [7:0] _received;
reg [7:0]  _sent;
reg _rec_high;
reg _st_high;

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