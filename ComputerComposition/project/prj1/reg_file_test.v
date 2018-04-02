`timescale 10ns / 1ns

`define DATA_WIDTH 32
`define ADDR_WIDTH 5

module reg_file_test
();

	reg clk;
	reg rst;
	reg [`ADDR_WIDTH - 1:0] waddr;
	reg wen;
	reg [`DATA_WIDTH - 1:0] wdata;

	reg [`ADDR_WIDTH - 1:0] raddr1;
	reg [`ADDR_WIDTH - 1:0] raddr2;
	wire [`DATA_WIDTH - 1:0] rdata1;
	wire [`DATA_WIDTH - 1:0] rdata2;

	reg [`DATA_WIDTH-1:0]datarec;
	//reg [`ADDR_WIDTH-1:0]lastwaddr;
	//reg [`ADDR_WIDTH-1:0]towaddr;-->input to waddr directly
	reg [10:0]cnt;
	
	reg [`ADDR_WIDTH-1:0]p;//lastwaddr
    reg [`DATA_WIDTH - 1:0]randdata;
	initial begin
	   cnt=0;
	   clk=0;
	end
	
	always@(posedge clk)
	begin
	   while(cnt<20)
           begin
               cnt=cnt+1;
               single_unit_test();
           end
           cnt=0;
		while(cnt<100)
		begin
			cnt=cnt+1;
           rand_test();
		end
	end

	always begin
		#1 clk = ~clk;
	end

//任务定义： 

task single_unit_test;
begin
    rst=0;
    // raddr1[`ADDR_WIDTH-1:0]=p[`ADDR_WIDTH-1:0];
	p[`ADDR_WIDTH-1:0]=$random; 
	// randdata[`DATA_WIDTH - 1:0]={$random} %32'd429496;
	// waddr[`ADDR_WIDTH-1:0]=p[`ADDR_WIDTH-1:0];
	wen={$random} % 2;
	waddr[`ADDR_WIDTH-1:0]=p;
	raddr1[`ADDR_WIDTH-1:0]=p;
	raddr2[`ADDR_WIDTH-1:0]=p;
	// wdata[`DATA_WIDTH - 1:0]= randdata[`DATA_WIDT`H - 1:0];
	
	// if(rdata1[`DATA_WIDTH - 1:0]!=u_reg_file.rf[raddr1][`DATA_WIDTH - 1:0]||
	// rdata2[`DATA_WIDTH - 1:0]==u_reg_file.rf[raddr2][`DATA_WIDTH - 1:0]
	// ||randdata[`DATA_WIDTH - 1:0]!=u_reg_file.rf[waddr][`DATA_WIDTH - 1:0])
	// begin
	//   $display("Some thing went wrong.");
    // end
	$display("waddr=%d,raddr1=%d,raddr2=%d,wdata=%d,rdata1=%d,rdata2=%d",waddr,raddr1,raddr2,wdata,rdata1,rdata2);
    

end	
endtask


task  rand_test; 

	begin
	   rst=0;
		waddr[`ADDR_WIDTH-1:0]={$random};
		raddr1[`ADDR_WIDTH-1:0]={$random};
		raddr2[`ADDR_WIDTH-1:0]={$random};
		wdata[`DATA_WIDTH-1:0]={$random} ;
		wen={$random} % 2;
		$display("waddr=%d,raddr1=%d,raddr2=%d,wdata=%d,rdata1=%d,rdata2=%d",waddr,raddr1,raddr2,wdata,rdata1,rdata2);
	end

endtask 

task test;
input _rst;
input [`ADDR_WIDTH-1:0]_waddr;
input [`ADDR_WIDTH-1:0]_raddr1;
input [`ADDR_WIDTH-1:0]_raddr2;
input [`DATA_WIDTH-1:0]_wdata;
input _wen;
begin
	$display("waddr=%d,raddr1=%d,raddr2=%d,wdata=%d,rdata1=%d,rdata2=%d",waddr,raddr1,raddr2,wdata,rdata1,rdata2);
end
endtask

	reg_file u_reg_file(
		.clk(clk),
		.rst(rst),
		.waddr(waddr),
		.raddr1(raddr1),
		.raddr2(raddr2),
		.wen(wen),
		.wdata(wdata),
		.rdata1(rdata1),
		.rdata2(rdata2)
	);

endmodule

