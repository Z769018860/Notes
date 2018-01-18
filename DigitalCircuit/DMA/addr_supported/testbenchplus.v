// Copyright (c) 2017-2018 Wang Huaqiang, Cai Xin.

`define MODE 1 //MODE决定数据传输的方向 MODE为1：cpu_to_mem 1，;MODE为0：mem_to_cpu :
//使用者可以改变MODE的define值以实现不同方向的数据传输
 `define L  0//L决定CPU所传输的数据长度是否为随机数，L=1时，CPU传输数据为固定长度12,L=0时，CPU传输数据为随机数
 //L=1时，数据长度不变，方便检查其余数据，L=0时，可以检查CPU传输数据长度len的鲁棒性
 `timescale 1ns/1ps

module CPU(
//数据部分    
input clk,
input resetn,
input cpu_to_dma_enable, //DMA准备好自CPU接收数据
input dma_to_cpu_valid, //向CPU传出的数据是否有效
input [7:0] cpu_in_socket,//CPU的输入值

output reg dma_to_cpu_enable, //CPU是否准备好接收数据。
output reg cpu_to_dma_valid, //CPU传入的数据是否有效。
output reg [7:0] cpu_out_socket,//CPU的输出值
//------------------------------
//地址控制部分
input addr_out_enable,  //DMA准备好自CPU接收地址
output reg addr_out_valid,  //CPU正在传出有效的地址

output reg [31:0] addr_out, //地址输出
output reg [31:0] len_out  //数据长度输出

);


reg l;//配合L
always@ (posedge clk)
begin

    //give out random status and data.
    dma_to_cpu_enable<=$random%2;
    cpu_to_dma_valid<=$random%2;
    
    cpu_out_socket<=$random%'b100000000;
    //---------------------------------------------

    addr_out_valid<=$random%2;
    l=`L;
    len_out<=(l==1)?12:($random%'b10000+5);
    addr_out<=$random;
  
if(resetn)
begin
//如果满足cpu向dma传输数据的条件，则print现在的cpu输出值
        if(cpu_to_dma_valid&cpu_to_dma_enable)
        begin
            $display("      cpu->dma: cpu gived %x",cpu_out_socket);
        end
//如果满足dma向cpu传输数据的条件，则print现在的cpu输入值
        if(dma_to_cpu_enable&dma_to_cpu_valid)
        begin
            $display("      dma->cpu: cpu received %x",cpu_in_socket);
        end
//如果满足cpu向dma传输地址的条件，则print现在cpu输出的地址和数据长度
        if(addr_out_valid&addr_out_enable)
        begin
            $display("\naddr::cpu->dma: addr: %x len: %d",addr_out,len_out);
        end
end
end

endmodule

module MEM(

//数据部分
input clk,
input resetn,
input mem_to_dma_enable, //DMA准备好自MEM接收数据
input dma_to_mem_valid, //向MEM传出的数据是否有效
input [3:0] mem_in_socket,//内存输入值

output reg dma_to_mem_enable, //MEM是否准备好接收数据。
output reg mem_to_dma_valid, //MEM传入的数据是否有效。
output reg [3:0] mem_out_socket,//内存输出值
//--------------------------------------
//地址控制部分
input addr_in_valid,  //DMA传出有效的地址
output reg addr_in_enable,  //MEM可以接收地址

input [31:0] addr_in, //地址输入
input [31:0] len_in //数据长度输入

);
//由于内存的接口宽度为4，所以需要变量记录现在的数据是八位数中的前4位（高位）还是后四位（低位）
reg _rec_high;//记录接受数据是否为高位
reg _st_high;//记录输出数据是否为高位
reg [7:0] _received;//记录mem收到的8位数，便于print该数据之后检查
reg [7:0]  _sent;//记录mem输出的8位数，便于print该数据之后检查
//-------------------------
initial
begin
    _received<=8'b0;
    _sent<=8'b0;
    _rec_high<=0;
    _st_high<=0;
end
always@ (posedge clk)
begin
    //give out random status and data.
    dma_to_mem_enable<=$random%2;
    mem_to_dma_valid<=$random%2;
    mem_out_socket<=$random%'b10000;
    addr_in_enable<=$random%2;
    
if(resetn)
    begin
    //如果满足mem向dma传输数据的条件，则print现在的mem输出值
    if(mem_to_dma_valid&mem_to_dma_enable)
    begin
        $display("mem->dma: mem gived %x",mem_out_socket);
        if(_st_high)//如果此时输出的值为高位    
        begin
            _sent[7:4]=mem_out_socket;
            $display("      mem gived %x in 8 bits",_sent);
            _st_high=~_st_high;            
        end       
        else      
        begin
             _sent[3:0]=mem_out_socket;
            _st_high=~_st_high;
        end
    end
//如果满足dma向mem传输数据的条件，则print现在的mem输入值
    if(dma_to_mem_enable&dma_to_mem_valid&TEST.resetn)
    begin
        $display("dma->mem: mem received %x",mem_in_socket);
        if(_rec_high)
        begin
             _received[7:4]=mem_in_socket;
            $display("      mem received %x in 8 bits",_received);
            _rec_high=~_rec_high;            
        end
        else
        begin
            _received[3:0]=mem_in_socket;
            _rec_high=~_rec_high;
        end
    end
//如果满足cpu向dma传输地址的条件，则print现在cpu输出的地址和数据长度
    if(addr_in_enable&addr_in_valid)
     begin
        $display("addr::dma->mem: addr: %x len: %d",addr_in,len_in);
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
    .mem_out_socket(mem_out_wire),
    //--------------------------------------
//地址控制部分
.addr_in_valid(dmains.address_out_valid),  //DMA传出有效的地址
// .addr_in_enable,  //MEM可以接收地址

.addr_in(dmains.address_reg), //地址输入
.len_in(dmains.len_reg) //数据长度输入

);

CPU cpuins(
    .clk(clk),
    .resetn(resetn),
    .cpu_to_dma_enable(cpu_to_dma_enable),
    .cpu_to_dma_valid(cpu_to_dma_valid),
    .dma_to_cpu_enable(dma_to_cpu_enable),
    .dma_to_cpu_valid(dma_to_cpu_valid),
    .cpu_in_socket(cpu_in_wire),
    .cpu_out_socket(cpu_out_wire),
    //------------------------------
    //地址控制部分
    .addr_out_enable(dmains.address_in_enable)  //DMA准备好自CPU接收地址
    // .addr_out_valid,  //CPU正在传出有效的地址

);

DMA_ADDRESS dmains(
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

    .mem_data_in(mem_in_wire), //内存信号输入
    .cpu_data_in(cpu_in_wire), //中央处理器信号输入
//------------------------------------------
    .address_in_valid(cpuins.addr_out_valid),     //CPU传入给DMA地址值有效
    .address_out_valid(memins.addr_in_valid),   //DMA处于可以传出地址状态
    .address_out_enable(memins.addr_in_enable),  //DMA传出地址值可被MEM接收
    .address_in_enable(memins.addr_in_enable),  //CPU传出地址值可被DMA接收, DMA处于可以接受地址状态
    
    .len_in(cpuins.len_out),     //接收传入的长度
    .addr_in(cpuins.addr_out)    //接收传入的地址

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