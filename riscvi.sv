`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/30/2022 11:47:46 PM
// Design Name:
// Module Name: riscvi
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
//`include "decode.sv"
//`include "exec.sv"
//`include "fetch.sv"
module riscvi(output [31:0] out);
    
    integer i;
    reg clk;
    initial begin
        $display("Simulation begin");
        for (i = 0; i < 100 ; i = i + 1) begin
            
            #10 clk = 0;
            #10 clk = 1;
        end
    end
    wire [31:0] instruction;
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;
    wire [31:0] imm_i_type;
    wire [31:0] imm_s_type;
    wire [31:0] imm_b_type;
    wire [31:0] imm_u_type;
    wire [31:0] imm_j_type;
    wire [31:0] pc;
    
    assign out = instruction;
    
    decode dec (
    .clk(clk),
    .instruction(instruction),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7),
    .imm_i_type(imm_i_type),
    .imm_s_type(imm_s_type),
    .imm_b_type(imm_b_type),
    .imm_u_type(imm_u_type),
    .imm_j_type(imm_j_type)
    );
    
    fetch fet (
    .clk(clk),
    .instruction(instruction),
    .pc(pc)
    );
    
    exec ex (
    .clk(clk),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7),
    .imm_i_type(imm_i_type),
    .imm_s_type(imm_s_type),
    .imm_b_type(imm_b_type),
    .imm_u_type(imm_u_type),
    .imm_j_type(imm_j_type),
    .pc(pc)
    );
endmodule
