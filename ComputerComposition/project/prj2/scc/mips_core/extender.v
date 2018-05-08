// extender.v

//extender and merger
//modify data output by memory

//mem extender control
`define extend32          4'b0000
`define extend16_signed   4'b0001
`define extend16_unsigned 4'b0010
`define extend8_signed    4'b0011
`define extend8_unsigned  4'b0100

`define merge_loadwordleft  4'b0101
`define merge_loadwordright 4'b0110
`define swl 4'b0111
`define swr 4'b1000
`define sb  4'b1001
`define sh  4'b1010
//todo: left and right

module extender(
    input[3:0]extender_control,
    input [31:0]mem_input,//from mem
    input [31:0]reg_input,//from reg
    input [1:0]ea,
    output reg[31:0] extender_output,
    output reg owstrb,
    output reg[3:0] strb,
    output reg shift
);

    always@*
    begin
      case(extender_control)
        `extend32:
        begin
            extender_output=mem_input;
            owstrb=0;
            strb=4'b1111;
            shift=0;
        end  

        `extend8_signed:
        begin
            owstrb=1;
            strb=4'b1111;
            shift=0;
            case(ea)
                2'b00:
                begin
                    extender_output=mem_input[7]?{24'b111111_111111_111111_111111,mem_input[7:0]}:{24'b0,mem_input[7:0]};
                end
                2'b01:
                begin
                    extender_output=mem_input[15]?{24'b111111_111111_111111_111111,mem_input[15:8]}:{24'b0,mem_input[15:8]};                    
                end
                2'b10:
                begin
                    extender_output=mem_input[23]?{24'b111111_111111_111111_111111,mem_input[23:16]}:{24'b0,mem_input[23:16]};                    
                end
                2'b11:
                begin
                    extender_output=mem_input[31]?{24'b111111_111111_111111_111111,mem_input[31:24]}:{24'b0,mem_input[31:24]};                    
                end
                default:
                begin
                    extender_output=mem_input[31]?{24'b111111_111111_111111_111111,mem_input[31:24]}:{24'b0,mem_input[31:24]};                    
                end

            endcase
        end

        `extend16_signed:
        begin
            owstrb=1;
            strb=4'b1111;
            shift=0;
            case(ea[1])
                1'b0:
                begin
                    extender_output=mem_input[15]?{16'b11111111_11111111,mem_input[15:0]}:{16'b0,mem_input[15:0]};
                end
                1'b1:
                begin
                    extender_output=mem_input[15]?{16'b11111111_11111111,mem_input[31:16]}:{16'b0,mem_input[31:16]};                    
                end
                default:
                begin
                    extender_output=mem_input[15]?{16'b11111111_11111111,mem_input[31:16]}:{16'b0,mem_input[31:16]};                    
                end
            endcase
        end
            
            // extender_output=(mem_input[7]?
            // {24'b1111_1111_1111_1111_1111_1111,mem_input[7:0]}:            
            // {24'b0000_0000_0000_0000_0000_0000,mem_input[7:0]});
        
            // extender_output=mem_input[7:0];        

        `extend8_unsigned:
        begin
            owstrb=1;
            strb=4'b1111;
            shift=0;
            case(ea)
                2'b00:
                begin
                    extender_output={24'b0,mem_input[7:0]};
                end
                2'b01:
                begin
                    extender_output={24'b0,mem_input[15:8]};
                end
                2'b10:
                begin
                    extender_output={24'b0,mem_input[23:16]};
                end
                2'b11:
                begin
                    extender_output={24'b0,mem_input[31:24]};
                end
                default:
                begin
                    extender_output={24'b0,mem_input[31:24]};
                end
            endcase
            // extender_output={24'b0000_0000_0000_0000_0000_0000,mem_input[7:0]};
        end

        `extend16_unsigned:
        begin
            owstrb=1;
            strb=4'b1111;
            shift=0;
            case(ea[1])
                1'b0:
                begin
                    extender_output={16'b0,mem_input[15:0]};
                end
                1'b1:
                begin
                    extender_output={16'b0,mem_input[31:16]};
                end
                default:
                begin
                    extender_output={16'b0,mem_input[31:16]};
                end
            endcase
            // extender_output={24'b0000_0000_0000_0000_0000_0000,mem_input[7:0]};
        end

        `merge_loadwordleft:
        begin
            owstrb=0;
            strb=4'b1111;
            shift=0;
            
            case(ea)
                2'b00:
                begin
                    extender_output={mem_input[7:0],reg_input[23:0]};
                end
                2'b01:
                begin
                    extender_output={mem_input[15:0],reg_input[15:0]};                    
                end
                2'b10:
                begin
                    extender_output={mem_input[23:0],reg_input[7:0]};                
                end
                2'b11:
                begin
                    extender_output={mem_input[31:0]};                
                end//todo
                default:
                begin
                    extender_output={mem_input[31:0]};                
                end//todo
            endcase
        end

        `merge_loadwordright:
        begin
            owstrb=0;
            strb=4'b1111;
            shift=0;
            
            case(ea)
                2'b00:
                begin
                    extender_output={mem_input[31:0]};
                end
                2'b01:
                begin
                    extender_output={reg_input[31:24],mem_input[31:8]};
                end
                2'b10:
                begin
                    extender_output={reg_input[31:16],mem_input[31:16]};
                end
                2'b11:
                begin
                    extender_output={reg_input[31:8],mem_input[31:24]};
                end//todo
                default:
                begin
                    extender_output={reg_input[31:8],mem_input[31:24]};
                end//todo
            endcase    
        end

        `swl:
        begin
            owstrb=1;        
            shift=1;
            case(ea)
                2'b00:
                begin
                    extender_output={24'b0,reg_input[31:24]};
                    strb=4'b0001;
                end
                2'b01:
                begin
                    extender_output={16'b0,reg_input[31:16]};
                    strb=4'b0011;
                end
                2'b10:
                begin
                    extender_output={8'b0,reg_input[31:8]};
                    strb=4'b0111;
                end
                2'b11:
                begin
                    extender_output={reg_input[31:0]};
                    strb=4'b1111;
                end
                default:
                begin
                    extender_output={reg_input[31:0]};
                    strb=4'b1111;
                end
            endcase
        end
        
        `swr:
        begin
            owstrb=1;        
            shift=1;
            case(ea)
                2'b00:
                begin
                    extender_output={reg_input[31:0]};
                    strb=4'b1111;
                end
                2'b01:
                begin
                    extender_output={reg_input[23:0],8'b0};
                    strb=4'b1110;
                end
                2'b10:
                begin
                    extender_output={reg_input[15:0],16'b0};
                    strb=4'b1100;
                end
                2'b11:
                begin
                    extender_output={reg_input[7:0],24'b0};
                    strb=4'b1000;
                end
                default:
                begin
                    extender_output={reg_input[7:0],24'b0};
                    strb=4'b1000;
                end
            endcase
        end

        `sb:
        begin   
            owstrb=1;
            shift=1;
            case(ea)
                2'b00:
                begin
                    strb=4'b0001;
                    extender_output={24'b0,reg_input[7:0]};
                end
                2'b01:
                begin
                    strb=4'b0010;
                    extender_output={16'b0,reg_input[7:0],8'b0};
                end
                2'b10:
                begin
                    strb=4'b0100;
                    extender_output={8'b0,reg_input[7:0],16'b0};
                end
                2'b11:
                begin
                    strb=4'b1000;
                    extender_output={reg_input[7:0],24'b0};
                end
                default:
                begin
                    strb=4'b1000;
                    extender_output={reg_input[7:0],24'b0};
                end
            endcase
        end

        `sh:
        begin   
            owstrb=1;
            shift=1;
            case(ea[1])
                1'b1:
                begin
                    strb=4'b1100;
                    extender_output={reg_input[15:0],16'b0};
                end
                1'b0:
                begin
                    strb=4'b0011;
                    extender_output={16'b0,reg_input[15:0]};
                end
                default:
                begin
                    strb=4'b0011;
                    extender_output={16'b0,reg_input[15:0]};
                end
            endcase
        end

        default:
        begin
            extender_output=mem_input;
            owstrb=1;
            strb=4'b1111;
            shift=0;
        end        

      endcase


    end

endmodule
