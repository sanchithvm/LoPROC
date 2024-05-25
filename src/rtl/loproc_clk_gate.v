`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Sanchith V M
//
// Create Date:    19:01:18 07/30/2022
// Design Name:
// Module Name:    loproc_clk_gate
// Project Name:    LoPROC v1.1
// Target Devices:
// Tool versions:
// Description: This module outputs a gated clock based on the input
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module loproc_clk_gate(
    input       src_clk,
    input       clk_en,

    output      gated_clk
    );

    //FF to latch EN
    reg en_q;
    always @ (posedge src_clk) begin
        en_q <= clk_en;
    end

    assign gated_clk = en_q & src_clk;


endmodule
