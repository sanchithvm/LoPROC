`include "loproc_defines.vh"

module pc_tb;
reg clk, rst;

reg load, interrupt;
reg [1:0] jump;

reg [`INSTRUCTION_WIDTH-1:0] jmp_addr;
reg [`INSTRUCTION_WIDTH-1:0] interrupt_addr;
wire [`INSTRUCTION_WIDTH-1:0] next_instr_addr;

loproc_pc dut (
	.clk(clk),
	.rst(rst),
	.load(load),
	.interrupt(interrupt),
	.jump(jump),
	.jmp_addr(jmp_addr),
	.interrupt_addr(interrupt_addr),
	.next_instr_addr(next_instr_addr)
);


initial begin
	$dumpfile("pc_dump.vcd");
	$dumpvars;
	clk <= 0; rst <= 0;
	load <= 0; interrupt <= 0;
	jump<= 0;

	jmp_addr <= 'h0; interrupt_addr <= 'h5000_2000;

	#5 rst <= 1;
	#10 rst <= 0;

	#10 load <= 1;

	#200 jump <= 'h1; jmp_addr <= 'h400;
	#10 jump <= 'h0; jmp_addr <= 'h0;

	#100 jump <= 'h2; jmp_addr <= 'h50;
	#10 jump <= 'h0;

	#50 load <= 0;

	#50 load <= 1;
	#20 interrupt <= 1;
	#10 interrupt <= 0;

	#50 $finish;
end

always #5 clk <= ~clk;

endmodule


