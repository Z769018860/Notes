//Huaqiang Wang (c) 2017
`timescale 1ns/1ps
`define workmode_4 0 //Uses [3:0] in inout socket
`define workmode_8 1
module FIFO(
    input clk,
    input resetn,
    input workmode,
    input input_valid, output_enable,
    input [7:0] fifo_in,
    output reg[7:0] fifo_out,
    output reg output_valid,
    output reg input_enable,
    output empty,
    output full
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
input clk,
input resetn,
input mode,

input dma_to_mem_enable, //MEM是否准备好接收数据。
input mem_to_dma_valid, //MEM中传入的数据是否有效。
input dma_to_cpu_enable, //CPU是否准备好接收数据。
input cpu_to_dma_valid, //CPU传入的数据是否有效。

input [3:0] mem_data_out,
input [7:0] cpu_data_out,

output dma_to_mem_valid, //向MEM传出的数据是否有效
output mem_to_dma_enable, //DMA准备好自MEM接收数据
output cpu_to_dma_enable, //DMA准备好自CPU接收数据
output dma_to_cpu_valid, //向CPU传出的数据是否有效

output [3:0] mem_data_in,
output [7:0] cpu_data_in
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
assign buf2.fifo_in=((mode==`mode_mem_to_cpu)?cpu_data_out:{4'b0000,mem_data_out});

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

