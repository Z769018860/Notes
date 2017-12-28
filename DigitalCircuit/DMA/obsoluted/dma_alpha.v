//Huaqiang Wang (c) 2017
`define mode_cpu_to_mem 1'b1
`define mode_mem_to_cpu 1'b0
`define buf1 1'b0
`define buf2 1'b1

module dma(
input clk,
input resetn,
input mode,

input dma_to_mem_enable, //MEM是否准备好接收数据。
input mem_to_dma_valid, //MEM中传入的数据是否有效。
input dma_to_cpu_enable, //CPU是否准备好接收数据。
input cpu_to_dma_valid, //CPU传入的数据是否有效。

input [3:0] mem_data_out,
input [7:0] cpu_data_out,

output reg dma_to_mem_valid, //向MEM传出的数据是否有效
output reg mem_to_dma_enable, //DMA准备好自MEM接收数据
output reg cpu_to_dma_enable, //DMA准备好自CPU接收数据
output reg dma_to_cpu_valid, //向CPU传出的数据是否有效

output reg [3:0] mem_data_in,
output reg [7:0] cpu_data_in
);

reg[7:0]BUF1[7:0];
reg[7:0]BUF2[7:0];

reg [2:0]mem_write;
reg [2:0]cpu_write;
reg mem_write_high;

reg buf_input;



always@(posedge clk)
begin
    if(!resetn)
    begin
        if(mode==`mode_cpu_to_mem)
        begin
            dma_to_mem_valid<=0;
            mem_to_dma_enable<=0;
            cpu_to_dma_enable<=1;
            dma_to_cpu_valid<=0;
        end
        else
        begin
            dma_to_mem_valid<=0;
            mem_to_dma_enable<=1;
            cpu_to_dma_enable<=0;
            dma_to_cpu_valid<=0;
        end
        buf_input=`buf1;
        mem_write_high<=0;
        mem_write=3'b0;
        cpu_write=3'b0;
        mem_data_in=0;
        cpu_data_in=0;
        // _buffull=0;
    end
    else
    begin
        case ({cpu_to_dma_enable,dma_to_cpu_enable,mem_to_dma_enable,dma_to_mem_enable})
            4'b1000://cpu to dma
            begin
                if(cpu_to_dma_valid)
                begin
                    if(buf_input==`buf1)
                    begin
                        BUF1[cpu_write]<=cpu_data_in;
                        if(cpu_write==3'd7)
                        begin
                            cpu_to_dma_enable<=0;
                            dma_to_mem_valid<=1;
                            cpu_write<=3'd0;
                            buf_input<=`buf2;
                        end
                        else
                        begin
                            cpu_write<=cpu_write+1;
                        end
                    end
                    else//(buf_input==buf2)
                    begin
                        BUF2[cpu_write]<=cpu_data_in;
                        if(cpu_write==3'd7)
                        begin
                            cpu_to_dma_enable<=0;
                            dma_to_mem_valid<=1;
                            cpu_write<=3'd0;
                            buf_input<=`buf1;
                        end
                        else
                        begin
                            cpu_write<=cpu_write+1;
                        end
                    end
                end

            end 
            4'b0100://dma to cpu 
            begin
                if(dma_to_cpu_valid)
                begin
                    if(!buf_input==`buf1)
                    begin
                        cpu_data_in<=BUF1[cpu_write];
                        if(cpu_write==3'd7)
                        begin
                            dma_to_cpu_valid<=0;
                            mem_to_dma_enable<=1;
                            cpu_write<=3'd0;
                            buf_input<=~`buf2;
                        end
                        else
                        begin
                            cpu_write<=cpu_write+1;
                        end
                    end
                    else//(buf_input==buf2)
                    begin
                        cpu_data_in<=BUF2[cpu_write];
                        if(cpu_write==3'd7)
                        begin
                            dma_to_cpu_valid<=0;
                            mem_to_dma_enable<=1;
                            cpu_write<=3'd0;
                            buf_input<=~`buf1;
                        end
                        else
                        begin
                            cpu_write<=cpu_write+1;
                        end
                    end
                end
            end
            4'b0010://mem to dma 
            begin
                if(mem_to_dma_valid)
                begin
                    if(buf_input==`buf1)
                    begin
                        if(mem_write_high)
                        begin
                            BUF1[cpu_write][7:4]<=mem_data_in;
                            if(cpu_write==3'd7&mem_write_high)
                            begin
                                // _buffull=0;
                                mem_to_dma_enable<=0;
                                dma_to_cpu_valid<=1;
                                buf_input<=`buf2;
                                mem_write_high<=~mem_write_high;
                            end
                        end
                        else
                        begin
                            BUF1[cpu_write][3:0]<=mem_data_in;
                            mem_write_high<=~mem_write_high;
                        end                            
                        
                        begin
                            if(mem_write_high)
                                cpu_write<=cpu_write+1;
                        end
                    end
                    else//(buf_input==buf2)
                    begin
                        if(mem_write_high)
                        begin
                            BUF2[cpu_write][7:4]<=mem_data_in;
                            if(cpu_write==3'd7&mem_write_high)
                            begin
                                mem_to_dma_enable<=0;
                                dma_to_cpu_valid<=1;
                                buf_input<=`buf1;
                            end
                            mem_write_high<=~mem_write_high;
                        end
                        else
                        begin
                            BUF2[cpu_write][3:0]<=mem_data_in;
                            mem_write_high<=~mem_write_high;
                        end                
                                    
                        begin
                            if(mem_write_high)
                                cpu_write<=cpu_write+1;
                        end
                    end
                end
            end 
            4'b0001://dma to mem 
            begin
                if(dma_to_mem_valid)
                begin
                    if(!buf_input==`buf1)
                    begin
                        if(mem_write_high)
                        begin
                            mem_data_in<= BUF1[cpu_write][7:4];
                            if(cpu_write==3'd7&mem_write_high)
                            begin
                                dma_to_mem_valid<=0;
                                cpu_to_dma_enable<=1;
                                buf_input<=~`buf2;
                            end
                            mem_write_high<=~mem_write_high;
                        end
                        else
                        begin
                            mem_data_in<= BUF1[cpu_write][3:0];
                            mem_write_high<=~mem_write_high;
                        end                            
                        
                        begin
                            if(mem_write_high)
                                cpu_write<=cpu_write+1;
                        end
                    end
                    else//(!buf_input==buf2)
                    begin
                        if(mem_write_high)
                        begin
                            mem_data_in<= BUF2[cpu_write][7:4];
                            mem_write_high<=~mem_write_high;
                        end
                        else
                        begin
                            mem_data_in<=BUF2[cpu_write][3:0];
                            if(cpu_write==3'd7&mem_write_high)
                            begin
                                dma_to_mem_valid<=0;
                                cpu_to_dma_enable<=1;
                                buf_input<=~`buf1;
                            end
                            mem_write_high<=~mem_write_high;
                        end                

                        begin
                            if(mem_write_high)
                                cpu_write<=cpu_write+1;
                        end
                    end
                end
            end 
            default: 
            ;
        endcase
    end
end

endmodule
