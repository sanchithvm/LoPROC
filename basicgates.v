`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:47:15 12/04/2020 
// Design Name: 
// Module Name:    basicgates.v
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Modules included
//					not32(out,in) - out 32bit o/p : in 32bit i/p
//					and32(out,a,b) - out 32bit o/p : a and b 32bit i/p
//					or32(out,a,b) - out 32bit o/p : a and b 32bit i/p
//					xor32(out,a,b) - out 32bit o/p : a and b 32bit i/p
//					and32red(out,in) - out 1bit o/p : in 32bit i/p
//					or32red(out,in) - out 1bit o/p : in 32bit i/p
//					xor32red(out,in) - out 1bit o/p : in 32bit i/p
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module and32(o,a,b);
input[31:0] a,b;
output[31:0] o;

assign o=a&b;
endmodule

module not32(o,i);
input[31:0] i;
output[31:0] o;

assign o=~i;
endmodule

module or32(out,a,b);
input[31:0] a,b;
output[31:0] out;

assign o=a|b;
endmodule

module xor32(out,a,b);
input[31:0] a,b;
output[31:0] out;

assign o=a^b;
endmodule

module and32red(out,in);
input[31:0] in;
output out;

assign out=in[31]&in[30]&in[29]&in[28]&in[27]&in[26]&in[25]&in[24]&in[23]&in[22]&in[21]&in[20]&in[19]&in[18]&in[17]&in[16]&in[15]&in[14]&in[13]&in[12]&in[11]&in[10]&in[9]&in[8]&in[7]&in[6]&in[5]&in[4]&in[3]&in[2]&in[1]&in[0];
endmodule

module or32red(out,in);
input[31:0] in;
output out;

assign out=in[31]|in[30]|in[29]|in[28]|in[27]|in[26]|in[25]|in[24]|in[23]|in[22]|in[21]|in[20]|in[19]|in[18]|in[17]|in[16]|in[15]|in[14]|in[13]|in[12]|in[11]|in[10]|in[9]|in[8]|in[7]|in[6]|in[5]|in[4]|in[3]|in[2]|in[1]|in[0];
endmodule

module xor32red(out,in);
input[31:0] in;
output out;

assign out=in[31]^in[30]^in[29]^in[28]^in[27]^in[26]^in[25]^in[24]^in[23]^in[22]^in[21]^in[20]^in[19]^in[18]^in[17]^in[16]^in[15]^in[14]^in[13]^in[12]^in[11]^in[10]^in[9]^in[8]^in[7]^in[6]^in[5]^in[4]^in[3]^in[2]^in[1]^in[0];
endmodule
