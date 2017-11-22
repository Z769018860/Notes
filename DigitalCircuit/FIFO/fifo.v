`timescale 1ns/1ps

module fifo(
    input clk,
    input rst,
    input [3:0] Data_In,
    output [7:0] Data_Out,
    output input_valid,  output_valid,
    input input_enable, output_enable);
// input clk;
// input [3:0] Data_In;
// input input_valid, input_enable, output_valid, output_enable;
// input rst;
// output [7:0] Data_Out;
reg [7:0] Data_Out;
reg [7:0] ram [7:0];
reg writelow;//写入低高位控制
reg [2:0]pos_write,pos_read;
reg input_valid,  output_valid;


always@(posedge clk)begin
  if(rst)begin
    // for(int i=0;i<7;i++)begin
    //     ram[i]=0;
    pos_read<=0;
    pos_write<=0;
    writelow<=1;
    Data_Out<=0;
    input_valid=1;
    output_valid=0;
    end
    else
    case({input_enable,input_valid,output_enable,output_valid})
        4'b1100://input
        begin
            if(!(pos_read==(pos_write+1)||(pos_write-7)==pos_read))
            begin     
            if(writelow)begin
            ram[pos_write][3:0]<=Data_In;
            writelow<=~writelow;
            // pos_write=pos_write+1;
            end
            else begin
            ram[pos_write][7:4]<=Data_In;
            writelow<=~writelow;
            pos_write<=pos_write+1;
            end
            end

        if(!(pos_read==(pos_write+1)||(pos_write-7)==pos_read))
        begin
        input_valid<=1;
        output_valid<=0;
        end
        else
        begin
        input_valid<=0;
        output_valid<=1;
        end

        end


        4'b0011:
        begin
            if(pos_read===(pos_write+1)||pos_read===(pos_write-7))begin
            Data_Out<=ram[pos_read];
            pos_read<=pos_read+1;
            input_valid<=1;
            output_valid<=0;
            end
        
        end

        default:
        ;
    endcase
    end
endmodule