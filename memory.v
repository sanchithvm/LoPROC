`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:59:16 01/10/2021 
// Design Name: 
// Module Name:    memory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pos_memory32(in,address,clk,WRn,out);
input[31:0] in;
input[15:0] address;
input clk,WRn;
output reg[31:0] out;
reg[31:0] mem[(1<<16)-1:0];

always@(posedge clk)
begin
if(WRn)
mem[address]=in;
else
out<=mem[address];
end
endmodule

module neg_memory32(in,address,clk,WRn,out);
input[31:0] in;
input[15:0] address;
input clk,WRn;
output reg[31:0] out;
reg[31:0] mem[(1<<16)-1:0];

always@(negedge clk)
begin
if(WRn)
mem[address]=in;
else
out<=mem[address];
end
endmodule


///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

module tmem;
reg[31:0] in;
reg[15:0] address;
reg clk,WRn;
wire[31:0] out;

neg_memory32 n1(in,address,clk,WRn,out);
initial
begin
clk=0;WRn=0;address=5'd0;
#10 address=16'd12;in=32'h06;
#10 WRn=1;
#10 WRn=0;
#10 address=16'd10;in=32'h05;
#10 WRn=1;
#20 address=16'd50;in=32'h25;
#20 WRn=0;
#20 address=16'd12;
#10 WRn=1'bz;
#10 WRn=1'bx;
#10 WRn=0;
#20 address=16'd10;
#20 address=16'd12;
#20 address=16'd50;
#20 address=16'd1;
#20 address=16'hffff;in=32'h5587d6a9;
#10 WRn=1;
#7 WRn=0;
end
always #5 clk=~clk;
endmodule
