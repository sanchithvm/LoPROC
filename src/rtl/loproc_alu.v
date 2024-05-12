`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Sanchith V M
//
// Create Date:    15:47:00 07/03/2022
// Design Name:
// Module Name:    loproc_alu
// Project Name:  LoPROC v1.1
// Target Devices:
// Tool versions:
// Description: The ALU for the LoPROC processor. This ALU is based on the HACK ALU from nand2tetris project
//
// Dependencies: loproc_defines.vh
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`include "/home/sanchith/documents/loproc_clone/src/rtl/loproc_defines.vh"
module loproc_alu(

  input   [`DATA_WIDTH-1:0]   x,y,
  input                       zx,zy,nx,ny,f,l,cs,asel,cin,
  output                      cout,
  output  [`DATA_WIDTH-1:0]   alu_out
 );
	 
 wire c;
 wire [`DATA_WIDTH-1:0]  x1, x2, y1, y2;
 wire [`DATA_WIDTH-1:0]  op_and, op_xor, op_arith, op_logic, op;

//Stage 1
	assign x1 = zx? 32'h0 : x;
	assign y1 = zy? 32'h0 : y;

//Stage 2
	assign x2 = nx? ~x1 : x1;
	assign y2 = ny? ~y1 : y1;

//Stage 3 - Logical operation
	assign op_and = x2 & y2;
	assign op_xor = x2 ^ y2;
	assign op_logic = l? op_xor : op_and; //Logic operation select

//Stage 4- Arithmetic operation
	assign c = cs? cin : 1'b0; //Carry select
	assign {cout,op_arith} = x2 + y2 + c;

//Stage 5
	assign op = f? op_arith : op_logic;

//Stage 6
	assign alu_out = asel? ~op : op;
endmodule
