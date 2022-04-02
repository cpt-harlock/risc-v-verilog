`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2022 11:18:48 PM
// Design Name: 
// Module Name: ex
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


module ex(
    input clk,
    input [6:0] opcode,
    input [4:0] rd,
    input [2:0] funct3,
    input [4:0] rs1,
    input [4:0] rs2,
    input [6:0] funct7,
    //various immediate for each instruction type
    input [11:0] imm_i_type,
    input [11:0] imm_s_type,
    //these immediates are directly computed as fixed sign extension
    input [31:0] imm_b_type,
    input [31:0] imm_u_type,
    input [31:0] imm_j_type

    );
endmodule
