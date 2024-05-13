`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    19:03:17 07/16/2022
// Design Name:
// Module Name:    loproc_multiplier
// Project Name: 	LoPROC v1.1
// Target Devices:
// Tool versions:
// Description: This module is a multiplier based on an enhanced
//						version of add and shift algorithm
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`include "loproc_defines.vh"
//`include "prencoder_32_5.v"
//`include "decoder_5_32.v"
module loproc_multiplier(
		input 										mul_clk,
		input 										mul_rst,
		input 				[`DATA_WIDTH-1:0]				in1,
		input 				[`DATA_WIDTH-1:0]				in2,
		input 										valid_in,

		output 		 		[`DATA_WIDTH-1:0]				out_l,
		output 		 		[`DATA_WIDTH-1:0]				out_h,
		output reg 									valid_out
    );

	//Storing input data on valid
	reg 	[`DATA_WIDTH-1:0]	in1_reg, in2_reg;
	always @ (posedge mul_clk or posedge mul_rst) begin
		if (mul_rst) begin
			in1_reg <= 32'h0;
			in2_reg	<= 32'h0;
		end
		else if(valid_in)	begin
			in1_reg <= in1;
			in2_reg <= in2;
		end
	end

	//Enable for shifter and accumulator
	reg acc_enable;
	always@(posedge mul_clk or posedge mul_rst) begin
		if(mul_rst) begin
			acc_enable <= 1'b0;
		end
		else if(valid_in & (in1 != 'h0) & (in2 != 'h0)) begin
			acc_enable <= 1'b1;
		end
		else if(to_fb_sel_mux ==  'h0) begin
			acc_enable <= 1'b0;
		end
	end

	//Stage 1: Feedback loop
	//The feedback loop select mux
	wire [`DATA_WIDTH-1:0]	to_enc_register, to_fb_sel_mux;
	assign to_enc_register = valid_in? in2 : to_fb_sel_mux;

   	//reg for storing the value
	reg [`DATA_WIDTH-1:0]	enc_reg;
	always @ (posedge mul_clk or posedge mul_rst) begin
		if (mul_rst) begin
			enc_reg <= 32'h0;
		end
		else begin
			enc_reg <= to_enc_register;
		end
	end

	//Encoder and decoder
	wire [`DATA_LOG2-1:0] to_shifter;
	wire [`DATA_WIDTH-1:0] from_dec;

	prencoder_32_5 priority_encoder_inst(enc_reg, to_shifter);
	decoder_5_32 decoder_inst(to_shifter, from_dec);

	assign to_fb_sel_mux = acc_enable? enc_reg & ~from_dec : 1'b0;

	//Stage 2: Shifting
	wire [`DATA_WIDTH-1:0] shifter_out_l, shifter_out_h;
	assign {shifter_out_h, shifter_out_l} = acc_enable? (in1_reg<<to_shifter) : 'h0;

	//Stage 3: Accumulate
/*	
	reg [`DATA_WIDTH-1:0] shifter_out_l_reg, shifter_out_h_reg;
	reg l_carry, h_carry;
	always @ (posedge mul_clk or posedge mul_rst) begin
		if (mul_rst | ~acc_enable) begin
			shifter_out_l_reg <= 'b0;
			l_carry				<= 'b0;
		end else begin
			{l_carry, shifter_out_l_reg} <= shifter_out_l_reg + shifter_out_l;
		end
	end

	always @ (posedge mul_clk or posedge mul_rst) begin
		if (mul_rst | ~acc_enable) begin
			shifter_out_h_reg <= 'b0;
			h_carry						<= 'b0;
		end else begin
			{h_carry, shifter_out_h_reg} <= shifter_out_h_reg + shifter_out_h + l_carry;
		end
	end
*/
	//Valid out register
	always@(posedge mul_clk or posedge mul_rst) begin
		if(mul_rst) begin
			valid_out <= 1'b0;
		end
		else if(valid_out) begin
			valid_out <= 1'b0;
		end
		else if(valid_in & (in1 == 'h0 || in2 == 'h0)) begin
			valid_out <= 1'b1;
		end
		else if((to_fb_sel_mux=='h0) & acc_enable) begin
			valid_out <= 1'b1;
		end
	end
	
	reg [2*`DATA_WIDTH-1:0] shifter_acc;
	always@(posedge mul_clk or posedge mul_rst) begin
		if(mul_rst | ~acc_enable) begin
			shifter_acc <= 'h0;
		end
		else begin
			shifter_acc <= shifter_acc + {shifter_out_h,shifter_out_l};
		end
	end

	assign out_l = shifter_acc[`DATA_WIDTH-1:0];
	assign out_h = shifter_acc[2*`DATA_WIDTH-1:`DATA_WIDTH];

endmodule
