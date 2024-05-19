`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Sanchith V M
//
// Create Date:    18:01:15 07/30/2022
// Design Name:
// Module Name:    loproc_pc
// Project Name: LoPROC v1.1
// Target Devices:
// Tool versions:
// Description: This is the program counter that stores the address of the
//						next instruction to be processed
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`include "loproc_defines.vh"
module loproc_pc(

    input                                            clk,
    input                                            rst,

    input                                            load,
    input       [1:0]                                jump,
    input                                            interrupt,
    input       [`INSTRUCTION_WIDTH-1:0]             jmp_addr,
    input       [`INSTRUCTION_WIDTH-1:0]             interrupt_addr,

    output reg  [`INSTRUCTION_WIDTH-1:0]             next_instr_addr

    );

    localparam  JMP     = 2'h1;
    localparam  JMP_ADD = 2'h2;


    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            next_instr_addr <= 32'h0;
        end else begin
            if(load) begin
                if(interrupt) begin
                    next_instr_addr <= interrupt_addr;
                end
                else if(jump==JMP) begin
                    next_instr_addr <= jmp_addr;
                end
                else if(jump==JMP_ADD) begin
                    next_instr_addr <= next_instr_addr + jmp_addr;
                end
                else begin
                    next_instr_addr <= next_instr_addr + 1'h1;
                end
            end
        end
    end

endmodule
