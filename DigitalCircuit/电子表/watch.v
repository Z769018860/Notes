`timescale 1ns / 1ps

module watch(clk, resetn, set, key_col1, key_col2, key_row2, key_row3, key_row4, num0_scan_select, num0_seg7);
   
   //输入端口声明
   input clk;
   input resetn;              // 复位信号，脉冲开关
   input set;                // 设置时间
                             // 在设置时间状态下，用键盘输入设定时、分、秒的高低位
   input key_row2;           //       | col_1  | col_2
   input key_row3;           // row_2 | hour_h | hour_l
   input key_row4;           // row_3 | min_h  | min_l
                             // row_4 | sec_h  | sec_l  
   
   //输出端口声明
   output key_col1;
   output key_col2;
   output [5:0] num0_scan_select; //选择FPGA_NUM0 7段数码管的扫描位：hour_h,hour_l,min_h,min_l
   output [6:0] num0_seg7;        //FPGA_NUM0 7段数码管显示a~g
   
   //时间hour、min、sec
   reg [1:0] hour_h;         //0~2,小时的十位
   reg [3:0] hour_l;         //0~9,小时的个位
   reg [2:0] min_h;          //0~5
   reg [3:0] min_l;          //0~9
   reg [2:0] sec_h;          //0~5
   reg [3:0] sec_l;          //0~9
   
   //---------------------------------------------计算1s----------------------------------------------//
   parameter COUNTER_SUM = 27'd99_999_999;   //100MHz。计数满COUNTER_SUM时，秒数加1s。
//   parameter COUNTER_SUM = 27'd5;   //100MHz。计数满COUNTER_SUM时，秒数加1s。

   reg [26:0] count;                             //计数器，上限为COUNTER_SUM
   always @(posedge clk)
   begin
      if ( !resetn )                              //复位
         begin
            count <= 27'd0;
            hour_h<=2'b0;         //0~2,小时的十位
            hour_l<=4'b0;         //0~9,小时的个位
            min_h<=3'b0;          //0~5
            min_l<=4'b0;          //0~9
            sec_h<=3'b0;          //0~5
            sec_l<=4'b0;          //0~9
         end
      else if ( count < COUNTER_SUM )
         begin
            count <= count + 27'd1;              // 不满COUNTER_SUM则累加1
         end
      else
         begin
            count <= 27'd0;                      // 满COUNTER_SUM，则回到零
         end 
   end
   
   wire one_second;
   assign one_second = (count == COUNTER_SUM);   // count满COUNTER_SUM，产生sec进位
   
   //-----------------------------------------scan FPGA key------------------------------------------//
   //FPGA上键盘为4X4，从左到右有4列：col1、col2、col3、col4，从上到下有4行：row1，row2，row3，row4
   //本次只使用{col1,col2}X{row2,row3,row4}共6个按钮，用于设定时钟时、分、秒的十位、个位
   //FPGA上键盘原理为，当有按钮（如col1 X row2）按下时，给该按钮所在列（col1）输入0，则会在所在行row2检测到一个0输出
   //故，当4列col1~col4给4'b1101的输入时，若在4行row1~row4检测到4'b1011，则说明col3 X row2按钮被按下
   //基于以上原理，可设计状态机用于扫描键盘输入
   //state0：给{col1,col2}输入2'b00，若{row2,row3,row4}不为3'b111，说明有按钮按下,则转state1
   //state1：给{col1,col2}输入2'b01，检测第一列有无按键按下
   //        若{row2,row3,row4}为3'b111，说明无按键按下,则转state3检测第二列，否则说明有按键按下转state2
   //state2：给{col1,col2}继续输入2'b01，直到{row2,row3,row4}为3'b111，
   //        说明已按下的按键被松开,一次按键完成，转state0；
   //        若{row2,row3,row4}不为3'b111，说明还是原来按键，则继续保持state2，以防一次按键被重复检测
   //state3：给{col1,col2}继续输入2'b10，检测第二列有无按键按下，类似state1
   //state4： 等待state3检测到的按键被释放，类似state2
   //
   reg [2:0] state;
   reg [2:0] next_state;

   reg [ 3:0] state_count;
   always @(posedge clk)
   begin
       if(!resetn || state_count[3])
       begin
           state_count <= 4'd0;
       end
       else
       begin
           state_count <= state_count + 1'b1;
       end
   end
	
   always @(posedge clk)
   begin
      if (!resetn)
      begin
         state <= 3'd0;
      end
      else if (state_count[3])//每到state_count[3], go to next state
      begin
         state <= next_state;
      end
   end
	
   always @(*)
   begin
      case(state)
         3'd0 : next_state <= {2'd0,!(key_row2 & key_row3 & key_row4)};
         3'd1 : 
            if ( key_row2 & key_row3 & key_row4 )
            begin
               next_state <= 3'd3;
            end
            else
            begin
               next_state <= 3'd2;
            end
         3'd2 : 
            if ( key_row2 & key_row3 & key_row4 )
            begin
               next_state <= 3'd0;
            end
            else
            begin
               next_state <= 3'd2;
            end
         3'd3 : 
            if ( key_row2 & key_row3 & key_row4 )
            begin
               next_state <= 3'd0;
            end
            else
            begin
               next_state <= 3'd4;
            end
         3'd4 : 
            if ( key_row2 & key_row3 & key_row4 )
            begin
               next_state <= 3'd0;
            end
            else
            begin
               next_state <= 3'd4;
            end
         default:next_state <= 3'd0;
      endcase
   end
	
   reg key_col1;
   reg key_col2;
   always @(*)
   begin
      case(state)
         3'd0 : {key_col1,key_col2} <= 2'b00;
         3'd1 : {key_col1,key_col2} <= 2'b01;
         3'd2 : {key_col1,key_col2} <= 2'b01;
         3'd3 : {key_col1,key_col2} <= 2'b10;
         3'd4 : {key_col1,key_col2} <= 2'b10;
         default:{key_col1,key_col2} <= 2'b00;
      endcase
   end

   //---------------------------------------------sec_l-------------------------------------------------//
   //sec_l累加使能信号：set为1时，来一个对应脉冲（row4 & col2）则有效；否则，count产生one_second时有效
   wire sec_l_addEn;
   assign sec_l_addEn = set ? ( (state==3'd3)&state_count[3]&!key_row4 ) : one_second;
   //TODO 1:reg [3:0] sec_l
    always@(posedge clk)
    if(sec_l_addEn)
    begin
    if(sec_l==4'd9)
        begin
        sec_l<=4'b0;
        end
    else
        begin
        sec_l<=sec_l+4'b1;
        end
    end
   wire sec_l_to_h;
    assign sec_l_to_h=((sec_l==4'd9)&sec_l_addEn);
   //TODO 2:assign sec_l_to_h;
   
   //---------------------------------------------sec_h-------------------------------------------------//
   //sec_h累加使能信号：set为1时，来一个对应脉冲（row4 & col1）则有效；否则，sec_l_to_h有进位时有效
   wire sec_h_addEn;
   assign sec_h_addEn = set ? ( (state==3'd1)&state_count[3]&!key_row4 ) : sec_l_to_h;
   //TODO 3: reg [2:0] sec_h
   always@(posedge clk)
   if(sec_h_addEn)
   begin
        if(sec_h==3'd5)
            begin
            sec_h<=3'd0;
            end
        else
            begin
            sec_h<=sec_h+3'b1;
            end
        end
   wire sec_to_min;
   //TODO 4:assign sec_to_min;
   assign sec_to_min=((sec_h==3'd5)&sec_h_addEn);
   
   //---------------------------------------------min_l-------------------------------------------------//
   //min_l累加使能信号：set为1时，来一个对应脉冲（row3 & col2）则有效；否则，sec_to_min有进位时有效
   wire min_l_addEn;
   assign min_l_addEn = set ? ( (state==3'd3)&state_count[3]&!key_row3 ) : sec_to_min;
   //TODO 5: reg [3:0] min_l;
   always@(posedge clk)
   if(min_l_addEn)
   begin
        if(min_l==4'd9)
            begin
            min_l<=4'd0;
            end
        else
            begin
            min_l<=min_l+4'b1;
            end
        end
   wire min_l_to_h;
   //TODO 6:assign min_l_to_h;
   assign min_l_to_h = ((min_l==4'd9)&min_l_addEn);
   
   //---------------------------------------------min_h-------------------------------------------------//
   //min_h累加使能信号：set为1时，来一个对应脉冲（row3 & col1）则有效；否则，min_l_to_h有进位时有效
   wire min_h_addEn;
   assign min_h_addEn = set ? ( (state==3'd1)&state_count[3]&!key_row3 ) : min_l_to_h;
   //TODO 7: reg [2:0] min_h
    always@(posedge clk)
    if(min_h_addEn)
   begin
        if(min_h==3'd5)
            begin
            min_h<=3'd0;
            end
        else
            begin
            min_h<=min_h+3'b1;
            end
        end
   wire min_to_hour;
   //TODO 8:assign min_to_hour;
   assign min_to_hour =((min_h==3'd5)&min_h_addEn);
   
   //---------------------------------------------hour_l-------------------------------------------------//
   //hour_l累加使能信号：set为1时，来一个对应脉冲（row2 & col2）则有效；否则，min_to_hour有进位时有效
   wire hour_l_addEn;
   assign hour_l_addEn = set ? ( (state==3'd3)&state_count[3]&!key_row2 ) : min_to_hour;
   //TODO 9:reg [3:0] hour_l;
   always@(posedge clk)
   if(hour_l_addEn)
   begin 
        if(hour_l==4'd9)
            begin
            hour_l<=4'd0;
            end
        else
            begin
            if((hour_h==2'd2)&hour_l==4'd3)
                begin
                hour_h<=2'd0;
                hour_l<=4'd0;
                end
            else
                begin
                hour_l<=hour_l+4'b1;
                end
            end
        end
   wire hour_l_to_h;
   //TODO 10:assign hour_l_to_h;
   assign hour_l_to_h=((hour_l==4'd9)&hour_l_addEn);
   
   //---------------------------------------------hour_h-------------------------------------------------//
   //min_h累加使能信号：set为1时，来一个对应脉冲（row2 & col1）则有效；否则，min_l_to_h有进位时有效
   wire hour_h_addEn;
   assign hour_h_addEn = set ? ( (state==3'd1)&state_count[3]&!key_row2 ) : hour_l_to_h;
   //TODO 11:reg [1:0] hour_h;
    always@(posedge clk)
    if(hour_h_addEn)
    begin 
          hour_h<=hour_h+4'b1;
    end

   //---------------------------------------------display-------------------------------------------------//
   //FPGA_NUM0 display
   //选择FPGA_NUM0的扫描位
   reg [5:0] num0_scan_select;      //0111:hour_h; 1011:hour_l; 1101:min_h; 1110:min_l;
   always @( posedge clk )
   begin
      case(count[12:10])
         3'b000: num0_scan_select <= 6'b011111;   //hour_h
         3'b001: num0_scan_select <= 6'b101111;   //hour_l
         3'b010: num0_scan_select <= 6'b110111;   //min_h
         3'b011: num0_scan_select <= 6'b111011;   //min_l
         3'b100: num0_scan_select <= 6'b111101;   //min_l
         3'b101: num0_scan_select <= 6'b111110;   //min_l
         default:num0_scan_select <= 6'b111111;
      endcase
   end
   //选择FPGA_NUM0的扫描数据，用于选择7段数码管的显示
   reg [3:0] num0_scan_data;
   always @ ( posedge clk )  
   begin
      case(count[12:10])
         3'b000: num0_scan_data <= {2'b00,hour_h};  
         3'b001: num0_scan_data <= hour_l;
         3'b010: num0_scan_data <= {1'b0,min_h};
         3'b011: num0_scan_data <= min_l;
         3'b100: num0_scan_data <= {1'b0,sec_h};
         3'b101: num0_scan_data <= sec_l;
      endcase
   end
   //展示FPGA_NUM0的7段数码管
   reg [6:0] num0_seg7;   // FPGA_NUM0:a~g
   always @( posedge clk )
   begin
      if ( !resetn )
      begin
         num0_seg7 <= 7'b0000000;
      end
      else
      begin
         case ( num0_scan_data )
            4'd0 : num0_seg7 <= 7'b1111110;   //0
            4'd1 : num0_seg7 <= 7'b0110000;   //1
            4'd2 : num0_seg7 <= 7'b1101101;   //2
            4'd3 : num0_seg7 <= 7'b1111001;   //3
            4'd4 : num0_seg7 <= 7'b0110011;   //4
            4'd5 : num0_seg7 <= 7'b1011011;   //5
            4'd6 : num0_seg7 <= 7'b1011111;   //6
            4'd7 : num0_seg7 <= 7'b1110000;   //7
            4'd8 : num0_seg7 <= 7'b1111111;   //8
            4'd9 : num0_seg7 <= 7'b1111011;   //9
            default:num0_seg7<= 7'b0000000;
         endcase
      end
   end
endmodule
