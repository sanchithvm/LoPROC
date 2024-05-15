`include "loproc_defines.vh"
module shifter_tb;

reg [`DATA_WIDTH-1:0] in1;
reg [`DATA_LOG2-1:0] in2;
reg lrn, srn, aln;

wire [`DATA_WIDTH-1:0] out;

loproc_shifter32 dut(
	.in1 (in1),
	.in2 (in2),

	.LRn (lrn),
	.SRn (srn),
	.ALn(aln),

	.out (out)
);

initial begin
	$dumpfile("shifter_dump.vcd");
	$dumpvars;
	in1 <= 'h89aa_1627;
	in2 <= 'h3;
	lrn <= 0; srn <= 0; aln <= 0;
	#10 srn <= 1;
	#10 aln <= 1;
	#10 aln <= 0; lrn <= 1;
	#10 srn <= 0;
	#10 $display("done");
	#30 $finish;


end


endmodule
