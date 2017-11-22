module FIFO(Input_vaild,Input_enable,Output_vaild,Output_enable,clk,Data_in,Data_out,rst);



input Input_vaild,Input_enable,rst;

input clk;

input [3:0] Data_in;

input Output_vaild,Output_enable;

output[7:0] Data_out;

reg [7:0]ram[7:0];

reg c;reg[2:0]pr;reg[2:0]pw;reg w;

reg  [7:0]Data_out;

wire full;

always @ (posedge clk)

if(rst)

    begin

    c=0;

    Data_out=0;

    pr=0;

    pw=0;

    w=0;

    end

 else begin



 if((!full)&&Input_vaild&&Input_enable) begin

    if(w==0)begin

        ram[pw][3:0]<=Data_in;

        w = w+1;

     end

    else begin

        ram[pw][7:4]<=Data_in;

        w=w-1;

        pw=(pw==7)?0:pw+1;

        c=c+1;

    end

  end

 else if (full&&Output_vaild&&Output_enable)begin

    Data_out<=ram[pr];

    pr=(pr==7)?0:pr+1;

    c=c-1;

    end

  end

assign full=(c==8);



endmodule
