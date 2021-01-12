`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:23:59 01/10/2021 
// Design Name: 
// Module Name:    register 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//						pos_register32b_lr: in 32b input : clk,load,rst 1b input : out 32b output; 
//						pos_register16b_lr: in 16b input : clk,load,rst 1b input : out 16b output; 
//						neg_register32b_lr: in 32b input : clk,load,rst 1b input : out 32b output; 
//						neg_register32b_lr: in 16b input : clk,load,rst 1b input : out 16b output; 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pos_register32b_lr(in,clk,load,rst,out);
input[31:0] in;
input clk,load,rst;
output reg[31:0] out;

always@(posedge clk)
begin
if(rst)
	out<=32'b0;
else if(load)
	out<=in;
end
endmodule



module pos_register16b_lr(in,clk,load,rst,out);
input[15:0] in;
input clk,load,rst;
output reg[15:0] out;

always@(posedge clk)
begin
if(rst)
	out<=16'b0;
else if(load)
	out<=in;
end
endmodule



module neg_register32b_lr(in,clk,load,rst,out);
input[31:0] in;
input clk,load,rst;
output reg[31:0] out;

always@(negedge clk)
begin
if(rst)
	out<=32'b0;
else if(load)
	out<=in;
end

endmodule


module neg_register16b_lr(in,clk,load,rst,out);
input[15:0] in;
input clk,load,rst;
output reg[15:0] out;

always@(negedge clk)
begin
if(rst)
	out<=16'b0;
else if(load)
	out<=in;
end
endmodule

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

module tst;
reg[31:0] in;
reg clk,load,rst;
wire[31:0] out;
pos_register32b_lr tt(in,clk,load,rst,out);
initial
begin
rst=1;in=32'h1235adc0;load=0;clk=0;
#20 rst=0;
#10 load=1;
#20 load=0;
#20 in=32'h3352dddc;
#20 rst=1;
#20 rst=1'bx;
#20 rst=0;
#20 load=1;
#20 load=1'bx;
#20 in=32'hffee2200;
end
always #5 clk=~clk;
endmodule



