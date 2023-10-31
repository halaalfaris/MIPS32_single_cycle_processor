`timescale 1 ns/1 ns
module mips32_tb ();

reg clk, reset;

mip32_b mip (clk, reset);

initial begin 
	reset = 1'b1;
	clk = 1'b0;
	#5; 
	clk = 1'b1;
	#2;
	reset = 1'b0;
	#3;
	
	
	forever begin 
	clk = #5 ~clk;
	end
	
	end


endmodule