`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Sanchith V M
//
// Create Date:    16:10:24 07/03/2022
// Design Name:
// Module Name:    loproc_regbank
// Project Name: LoPROC v1.1
// Target Devices:
// Tool versions:
// Description: The register bank. Width = 32, and depth = 32.
//							Has 1 input port and 2 output ports and 3 separate address ports for each of the data port
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`include "loproc_defines.vh"
module loproc_regbank(
	input 						clk, rst,
	input 						read_en, write_en,
	input 		[`REG_BANK_ADDR_WIDTH-1:0]				addr_src1, addr_src2, addr_dst,
	input 		[`DATA_WIDTH-1:0]		dst,
	output reg 	[`DATA_WIDTH-1:0]		src1, src2
);

	reg [`DATA_WIDTH-1:0] reg_b[`REG_BANK_DEPTH-1:0];

// Reading
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			src1 <= 32'h0;
			src2 <= 32'h0;
		end
		else begin
			if(read_en) begin
				src1 <=	reg_b[addr_src1];
				src2 <= reg_b[addr_src2];
			end
			else begin
				src1 <= 32'h0;
				src2 <= 32'h0;
			end
		end
	end

// Writing
always @ (negedge clk) begin
	if (~rst & write_en) begin
		reg_b[addr_dst] <= dst;
	end
end
endmodule
