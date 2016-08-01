/* test bench */
`timescale 1ns/1ps
`include "def.h"
module test_mipse;
parameter STEP = 10;
   reg clk, rst_n;
   reg[31:0] count;
   reg[31:0] stall;
   wire [`DATA_W-1:0] ddataout, ddatain ;
   wire [`DATA_W-1:0] iaddr;
   wire [`DATA_W-1:0] daddr;
   wire [`DATA_W-1:0] idata;
   wire we;
  
   always #(STEP/2) begin
            clk <= ~clk;
   end

   mipse mipse_1(.clk(clk), .rst_n(rst_n), .instr(idata),
               .readdata(ddatain), .pc(iaddr), .aluout(daddr),
               .writedata(ddataout), .memwrite(we) );

  imem  imem_1(.a(iaddr[17:2]), .rd(idata) );
  dmem  dmem_1(.clk(clk), .a(daddr[17:2]), .rd(ddatain), 
  					.wd(ddataout), .we(we) );

   initial begin
      $dumpfile("mipse.vcd");
      $dumpvars(0,mipse_1);
      clk <= `DISABLE;
      rst_n <= `ENABLE_N;
	  count <= 0;
	  stall <= 0;
   #(STEP*1/4)
   #STEP
      rst_n <= `DISABLE_N;
   #(STEP*100000)
   $finish;
   end

   always @(negedge clk) begin
      $display("pc:%h idatain:%h stall:%b", mipse_1.pc, mipse_1.instr, mipse_1.stall);
      $display("reg:%h %h %h %h %h %h %h", 
	mipse_1.rfile_1.rf[1], mipse_1.rfile_1.rf[2],
	mipse_1.rfile_1.rf[3], mipse_1.rfile_1.rf[4], mipse_1.rfile_1.rf[5],
	mipse_1.rfile_1.rf[6], mipse_1.rfile_1.rf[7]); 
      $display("mem:%h %h %h %h", 
	dmem_1.mem[0], dmem_1.mem[1],
	dmem_1.mem[2], dmem_1.mem[3]);
	count <= count+1;
	if(mipse_1.stall) stall <= stall+1;
	if( (daddr == 32'h7fff) & we) begin
		$display("%h count:%d stall:%d",ddataout,count,stall);
		$finish;
   end 
   end
endmodule
