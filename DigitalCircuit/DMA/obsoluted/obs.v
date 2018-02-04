

module DMA_withaddr(

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
