`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:40:04 12/04/2020
// Design Name:
// Module Name:    muxes.v with test
// Project Name:
// Target Devices:
// Tool versions:
// Description: Modules included
//					mux21b(a,b,s,out) - a,b 1b i/p : s 1b select : out 1b o/p
//					mux321b(in,s,out) - in 32b i/p : s 5b i/p : out 1b o/p
//					mux232b(a,b,s,out) - a,b 32b i/p : s 1b select : out 32b o/p
//					mux432b(a,b,c,d,s,out) - a,b,c,d 32b i/p : s 2b select : out 32b o/p
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module mux21b(a,b,s,out);
input a,b,s;
output out;
assign out= (a&(~s)) | (b&s);

endmodule

module mux232b(a,b,s,out);		//.......
input[31:0] a,b;
input s;
output[31:0] out;

genvar i;
generate
	for(i=0;i<32;i=i+1) begin
		mux21b m1(a[i],b[i],s,out[i]);
	end
endgenerate
endmodule

module mux321b(in,s,out);		//.......
input[31:0] in;
input[4:0] s;
output out;
wire[15:0] w;
wire[7:0] q;
wire[3:0] m;
wire[1:0] k;

genvar i;
generate
	for(i=0;i<32;i=i+2) begin
		mux21b m1(in[i],in[i+1],s[0],w[i/2]);
	end
	for(i=0;i<16;i=i+2) begin
		mux21b m2(w[i],w[i+1],s[1],q[i/2]);
	end
	for(i=0;i<8;i=i+2) begin
		mux21b m3(q[i],q[i+1],s[2],m[i/2]);
	end
	for(i=0;i<4;i=i+2) begin
		mux21b m4(m[i],m[i+1],s[3],k[i/2]);
	end
endgenerate
mux21b m5(k[0],k[1],s[4],out);

endmodule

module mux432b(a,b,c,d,s,out);		//........
input[31:0] a,b,c,d;
input[1:0] s;
output[31:0] out;
wire[31:0] o1,o2;

mux232b a1(a,b,s[0],o1);
mux232b a2(c,d,s[0],o2);
mux232b a3(o1,o2,s[1],out);
endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
// TEST MODULES
/*
module tst;
reg[31:0] a,b,c,d;
reg[1:0] s;
wire[31:0] out;

mux432b uut(a,b,c,d,s,out);
initial
begin
a=32'h12adb57e;b=32'hffff0032;c=32'h234518ef;d=32'hacdefb13;s=2'b00;
#10 s=2'b11;
#10 s=2'b1x;
#10 s=2'b0z;
#10 s=2'b10;
#10 b=32'h32ed39xx;
#10 b=32'h32ed39zz;
#10 b=32'hxxxxxxxx;
#10 b=32'hzzzzzzzz;
#10 s=2'bxx;
end
endmodule


module tst;
reg[31:0] in;
reg[4:0] s;
wire o;

mux321b qwe(in,s,o);
initial
begin
in=32'hf0f0f789;s=5'b00000;
#10 s=5'b00001;
#10 in[1]=1'b1;
#10 in[1]=1'bx;
#10 s=5'b10000;
#10 in=32'hf0f1f789;
#10 s=5'b111111;
#10 in[31]=1'b0;
end
endmodule


module tst;
reg a,b,s;
wire o;
mux21b uut(a,b,s,o);
initial
begin
a=1'b1;b=1'b0;s=1'b0;
#10 s=1'b1;
#10 b=1'b1;
#10 b=1'bx;
#10 b=1'bz;
#10 a=1'bz;s=1'b0;
#10 a=1'b1;s=1'bx;b=1'b0;
#10 s=1'bz;
end
endmodule
*/
