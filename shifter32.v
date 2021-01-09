`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:38:58 12/07/2020 
// Design Name: 
// Module Name:    shifter32 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//					zeros(in,LRn,out) - in 5b i/p : LRn 1b control : out 32b o/p
//					shifter32(in1,in2,lrn,srn,aln,out) - in1 32b i/p : in2 5b i/p : lrn,srn,aln 1b control : out 32b o/p
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`include "muxes.v"

module zeros(in,LRn,out);
input[4:0] in;
input LRn;
output[31:0] out;
wire[4:0] inn;
wire[31:0] lop,rop;
genvar i;

assign inn = ~in;
assign lop[0] = inn[4]&inn[3]&inn[2]&inn[1]&inn[0];
assign lop[1] = inn[4]&inn[3]&inn[2]&inn[1];
assign lop[2] = lop[1] | (inn[4]&inn[3]&inn[2]&inn[0]);
assign lop[3] = inn[4]&inn[3]&inn[2];
assign lop[4] = lop[3] | (inn[4]&inn[3]&inn[1]&inn[0]);
assign lop[5] = lop[3] | (inn[4]&inn[3]&inn[1]);
assign lop[6] = lop[5] | (inn[4]&inn[3]&inn[0]);
assign lop[7] = inn[4]&inn[3];

assign lop[8] = lop[7] | (inn[4]&inn[2]&inn[1]&inn[0]);
assign lop[9] = lop[7] | (inn[4]&inn[2]&inn[1]);
assign lop[10] = lop[9] | (inn[4]&in[3]&inn[2]&inn[0]);
assign lop[11] = lop[7] | (inn[4]&inn[2]);
assign lop[12] = lop[11] | (inn[4]&inn[1]&inn[0]);
assign lop[13] = lop[11] | (inn[4]&inn[1]);
assign lop[14] = lop[13] | (inn[4]&inn[0]);
assign lop[15] = inn[4];

assign lop[16] = lop[15] | (inn[3]&inn[2]&inn[1]&inn[0]);
assign lop[17] = lop[15] | (inn[3]&inn[2]&inn[1]);
assign lop[18] = lop[17] | (inn[3]&inn[2]&inn[0]);
assign lop[19] = lop[15] | (inn[3]&inn[2]);
assign lop[20] = lop[19] | (inn[3]&inn[1]&inn[0]);
assign lop[21] = lop[19] | (inn[3]&inn[1]);
assign lop[22] = lop[21] | (inn[3]&inn[0]);
assign lop[23] = lop[15] | inn[3];

assign lop[24] = lop[23] | (inn[2]&inn[1]&inn[0]);
assign lop[25] = lop[23] | (inn[2]&inn[1]);
assign lop[26] = lop[25] | (in[3]&inn[2]&inn[0]);
assign lop[27] = lop[23] | inn[2];
assign lop[28] = lop[27] | (inn[1]&inn[0]);
assign lop[29] = lop[27] | inn[1];
assign lop[30] = lop[29] | inn[0];
assign lop[31] = 1'b1;

generate
	for(i=0;i<32;i=i+1)
	begin
		assign rop[i] = lop[31-i];
	end
endgenerate

mux232b m1(rop,lop,LRn,out);


endmodule

module shifter32(in1,in2,lrn,srn,aln,out);
input[31:0] in1;
input[4:0] in2;
input lrn,srn,aln;
output[31:0] out;
wire[31:0] w0[31:0],ww,op,opn,w2,m2sel;
wire[4:0] in2w,in2l,in2lr;

genvar i,j;
assign in2l = 32-in2;
generate
	for(i=0;i<5;i=i+1)
	begin
		mux21b lr1(in2[i],in2l[i],lrn,in2lr[i]);
	end
endgenerate

generate
	for(j=0;j<32;j=j+1)
	begin
		for(i=0;i<32;i=i+1)
		begin
			assign w0[j][i] = in1[(i+j)%32];
		end
		mux321b mu(w0[j],in2lr,ww[j]);
	end
	
endgenerate	

generate
	for(i=0;i<5;i=i+1)
	begin
		mux21b sr1(1'b0,in2[i],srn,in2w[i]);
	end
endgenerate
zeros z0(in2w,lrn,op);
assign opn = ~op;
generate
	for(i=0;i<32;i=i+1)
	begin
		assign w2[i] = ww[i]&op[i];
		assign m2sel[i] = opn[i]&aln;
		mux21b l2(w2[i],in1[31],m2sel[i],out[i]);
	end
endgenerate

endmodule


//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

/*
module tstzer;
reg[4:0] in;
reg lr;
wire[31:0] out;
integer i;

zeros uut(in,lr,out);
initial
begin
in = 5'b00000;lr=0;
for(i=1;i<32;i=i+1)
begin
#10 in = i;
end
#50 lr=1;
for(i=0;i<32;i=i+1)
begin
#10 in = i;
end

end
endmodule
*/
/*
module tstshift;
reg[31:0] data;
reg[4:0] in;
reg lrn,aln,srn;
wire[31:0] out;

shifter32 uut(data,in,lrn,srn,aln,out);

initial
begin
$dumpvars;
data=32'haaff0023;in=5'b00100;lrn=1'b0;srn=1'b0;aln=1'b0;
#10 srn=1'b1;
#10 lrn=1'b1;
#10 in=5'b001100;
#10 in=5'b000011;
#10 srn=1'b0;
#10 lrn=1'b0;
#10 aln=1'b1;
#10 srn=1'b1;
end
endmodule
 */