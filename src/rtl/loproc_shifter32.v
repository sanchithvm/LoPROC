`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    18:13:05 07/03/2022
// Design Name:
// Module Name:    loproc_shifter32
// Project Name:	LoPROC v1.1
// Target Devices:
// Tool versions:
// Description: This module performs shift operation based on barrel shifter.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`include "loproc_defines.vh"
`include "muxes.v"
module loproc_shifter32(
	input		[`DATA_WIDTH-1:0]		in1,
	input 	[`DATA_LOG2-1:0]								in2,
	input 											LRn, SRn, ALn,

	output 	[`DATA_WIDTH-1:0]		out
);

	wire [`DATA_LOG2-1:0] in2r, in2lr, mask_in;
	wire [`DATA_WIDTH-1:0] in_s1[`DATA_WIDTH-1:0]; //Input for Stage 1
	wire [`DATA_WIDTH-1:0] s1;	//Output of Stage 1

	wire [`DATA_WIDTH-1:0] mask_bits; //generated 32b mask for transforming rotation to shift
	wire [`DATA_WIDTH-1:0] masked_op;
	wire [`DATA_WIDTH-1:0] s2; //Output of Stage 2

	//Pre-stage for rotating
	assign in2r = 32 - in2;	//left rotate by in2 is same as right rotate by 32-in2
	assign in2lr = LRn? in2r : in2;

	//Stage 1: generated rotated version of input
	genvar i,j;
	generate
		for(i=0;i<32;i=i+1) begin	: gen_s1
			for(j=0;j<32;j=j+1) begin : gen_in_s1
				assign in_s1[i][j] = in1[(i+j)%32];
			end
			mux321b s1_mux_inst(in_s1[i],in2lr,s1[i]);
		end
	endgenerate

	//Masking : required to obtain shifted version from rotated version
	assign mask_in = SRn? in2 : 5'h0; //input for mask generator, 0 sent when rotation is chosen so that no bits are masked

	//generate mask bits
	gen_mask mask_inst(mask_in, LRn, mask_bits);

	//Stage 2: Mask the output of Stage 1 and generate final output
	assign masked_op = s1 & mask_bits;
	genvar k;
	generate
		for(k=0;k<32;k=k+1) begin : gen_s2
			assign s2[k] = ALn? (mask_bits[k]? masked_op[k] : 1'b1) : (masked_op[k]);
		end
	endgenerate

	assign out = s2;




endmodule

module gen_mask(

		input 		[`DATA_LOG2-1:0]			in,
		input 							LRn,
		output 		[`DATA_WIDTH-1:0]		mask_o

	);
	reg [`DATA_WIDTH-1:0] mask_out;
		always@(*) begin
			case ({LRn,in})
				//Right shift masking
				6'h00: mask_out = 32'hffff_ffff;
				6'h01: mask_out = 32'h7fff_ffff;
				6'h02: mask_out = 32'h3fff_ffff;
				6'h03: mask_out = 32'h1fff_ffff;
				6'h04: mask_out = 32'h0fff_ffff;
				6'h05: mask_out = 32'h07ff_ffff;
				6'h06: mask_out = 32'h03ff_ffff;
				6'h07: mask_out = 32'h01ff_ffff;
				6'h08: mask_out = 32'h00ff_ffff;
				6'h09: mask_out = 32'h007f_ffff;
				6'h0a: mask_out = 32'h003f_ffff;
				6'h0b: mask_out = 32'h001f_ffff;
				6'h0c: mask_out = 32'h000f_ffff;
				6'h0d: mask_out = 32'h0007_ffff;
				6'h0e: mask_out = 32'h0003_ffff;
				6'h0f: mask_out = 32'h0001_ffff;
				6'h10: mask_out = 32'h0000_ffff;
				6'h11: mask_out = 32'h0000_7fff;
				6'h12: mask_out = 32'h0000_3fff;
				6'h13: mask_out = 32'h0000_1fff;
				6'h14: mask_out = 32'h0000_0fff;
				6'h15: mask_out = 32'h0000_07ff;
				6'h16: mask_out = 32'h0000_03ff;
				6'h17: mask_out = 32'h0000_01ff;
				6'h18: mask_out = 32'h0000_00ff;
				6'h19: mask_out = 32'h0000_007f;
				6'h1a: mask_out = 32'h0000_003f;
				6'h1b: mask_out = 32'h0000_001f;
				6'h1c: mask_out = 32'h0000_000f;
				6'h1d: mask_out = 32'h0000_0007;
				6'h1e: mask_out = 32'h0000_0003;
				6'h1f: mask_out = 32'h0000_0001;

				//Left shift Masking
				6'h20: mask_out = 32'hffff_ffff;
				6'h21: mask_out = 32'hffff_fffe;
				6'h22: mask_out = 32'hffff_fffc;
				6'h23: mask_out = 32'hffff_fff8;
				6'h24: mask_out = 32'hffff_fff0;
				6'h25: mask_out = 32'hffff_ffe0;
				6'h26: mask_out = 32'hffff_ffc0;
				6'h27: mask_out = 32'hffff_ff80;
				6'h28: mask_out = 32'hffff_ff00;
				6'h29: mask_out = 32'hffff_fe00;
				6'h2a: mask_out = 32'hffff_fc00;
				6'h2b: mask_out = 32'hffff_f800;
				6'h2c: mask_out = 32'hffff_f000;
				6'h2d: mask_out = 32'hffff_e000;
				6'h2e: mask_out = 32'hffff_c000;
				6'h2f: mask_out = 32'hffff_8000;
				6'h30: mask_out = 32'hffff_0000;
				6'h31: mask_out = 32'hfffe_0000;
				6'h32: mask_out = 32'hfffc_0000;
				6'h33: mask_out = 32'hfff8_0000;
				6'h34: mask_out = 32'hfff0_0000;
				6'h35: mask_out = 32'hffe0_0000;
				6'h36: mask_out = 32'hffc0_0000;
				6'h37: mask_out = 32'hff80_0000;
				6'h38: mask_out = 32'hff00_0000;
				6'h39: mask_out = 32'hfe00_0000;
				6'h3a: mask_out = 32'hfc00_0000;
				6'h3b: mask_out = 32'hf800_0000;
				6'h3c: mask_out = 32'hf000_0000;
				6'h3d: mask_out = 32'he000_0000;
				6'h3e: mask_out = 32'hc000_0000;
				6'h3f: mask_out = 32'h8000_0000;
				default: mask_out = 32'h0000_0000;
			endcase
		end

		assign mask_o = mask_out;
endmodule
