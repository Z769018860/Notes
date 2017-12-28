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