`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/22 15:06:55
// Design Name: 
// Module Name: fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo(clk,rst,in_v,out_v,in_en,out_en,data_in,data_out);
input clk,rst;
input in_v,out_en;
input  [3:0]data_in;//��������
output [7:0]data_out;//�������
output out_v,in_en;

wire    out_v,in_en,in_v,out_en;
reg    [7:0]data_out;  

reg    [3:0] ram[15:0];//dual port��RAM
reg    [3:0] rd_ptr;//д�Ͷ�ָ��
reg    [3:0] wr_ptr;
reg    [3:0] counter;//�����жϿ���

always@(posedge clk)
begin
 if(!rst)
 begin
  counter=0;
  data_out=0;
  wr_ptr=0;
  rd_ptr=0;
  ram[0]=0;
 end
 else
 begin
 if (in_v==1&&out_v==1&&in_en==1&&out_en==1)
   $display("Error!Wrong status!");
 else if (out_v==1&&out_en==1)
          begin
		   data_out=(ram[rd_ptr]<<4)+ram[rd_ptr+1];//�Ƚ��ȳ�����˶��Ļ����ɰ��մ�����
		   counter=counter-2;
		   rd_ptr=(rd_ptr==14)?0:rd_ptr+2;
		  end
	   else if (in_v==1&&in_en==1)
          begin
		   ram[wr_ptr]=data_in;//д����
		   counter=counter+1;
		   wr_ptr=(wr_ptr==15)?0:wr_ptr+1;
		  end
            else
	     counter=counter;
 end
end

assign in_en=(counter<=15)?1:0;
assign out_v=(counter==15)?1:0;


endmodule