`include "loproc_defines.vh"
module mult_tb;
reg clk, rst, valid_in;
reg [`DATA_WIDTH-1:0] in1, in2;

wire [`DATA_WIDTH-1:0] out_l, out_h;
wire valid_out;

loproc_multiplier dut(
	.mul_clk (clk),
	.mul_rst (rst),

	.in1(in1),
	.in2(in2),
	.valid_in(valid_in),

	.out_l(out_l),
	.out_h(out_h),
	.valid_out(valid_out)
);

initial begin
	$dumpfile("mult_tb.vcd");
	$dumpvars;
	clk <= 0; rst <= 0;
	valid_in <= 0; in1 <= 'h0; in2 <= 'h0;
	#4.5 rst <= 1;
	#10 rst <= 0;	
	#10 in1 <= 'h4bba; in2 <= 'h100b;valid_in<= 1;
	#10 valid_in <= 0;


	#100 in1 <= 'hff00_bff1; in2 <= 'hff11_9956; valid_in <= 1;
	#10 valid_in <= 0;
	
	#200 in1 <= 0; valid_in <= 1'b1;
	#10 valid_in <= 1'b0;
	#50 in1 <= 'h478; in2 <= 'h0; valid_in <= 1'b1;
	#10 valid_in <= 1'b0;
	$display("done");
	#500 $finish;
end
always #5 clk <= ~clk;
endmodule

