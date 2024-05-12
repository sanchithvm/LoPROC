`define DATA_WIDTH 32
module tb_alu;

reg [`DATA_WIDTH-1:0] x,y;
reg cin;
reg [7:0] opcode;

wire cout;
wire [`DATA_WIDTH-1:0] alu_out;

loproc_alu dut (
	.x(x),
	.y(y),
	.zx(opcode[7]),
	.zy(opcode[6]),
	.nx(opcode[5]),
	.ny(opcode[4]),
	.f(opcode[3]),
	.l(opcode[2]),
	.cs(opcode[1]),
	.asel(opcode[0]),
	.cin(cin),

	.cout(cout),
	.alu_out(alu_out)
);

initial begin
	$dumpfile("loproc_alu.vcd");
	$dumpvars;
	$monitor("[monitor] time = %0t, x = %d, y = %d, cin = %d, alu_out = %d\t\topcode = %h\n", $time, x, y, cin, alu_out, opcode);
	x='h0; y='h0; cin = 'h0;
	opcode = 'h0;

	#10 x='h8ab; y='hf76; //AND
	#10 opcode = 'h1; //NAND
	#10 opcode = 'h31; //OR
	#10 opcode = 'h30; //NOR
	#10 opcode = 'h04; //XOR
	#10 opcode = 'h08; //ADD
	#10 opcode = 'h0a; //ADDC
	#10 cin = 'h1;
	#10 opcode = 'h29; //SUB x-y
	#10 opcode = 'h19; //SUB y-x
	#10 opcode = 'h79; //INC X
	#10 opcode = 'ha8; //DEC Y
	$finish;	
end

endmodule
