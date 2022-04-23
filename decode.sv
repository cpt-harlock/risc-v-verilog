`timescale 1ns / 1ps
`include "defines.vh"

module decode (input clk,
               input [31:0] instruction,
               output reg [6:0] opcode,
               output reg [4:0] rd,
               output reg [2:0] funct3,
               output reg [4:0] rs1,
               output reg [4:0] rs2,
               output reg [6:0] funct7,
               output reg [31:0] imm);
    reg [31:0] imm_i_type;
    reg [31:0] imm_s_type;
    reg [31:0] imm_b_type;
    reg [31:0] imm_u_type;
    reg [31:0] imm_j_type;
    
    function [2:0] get_instruction_type;
        input [6:0] opcode;
        case (opcode)
            7'b0000011,
            7'b0010011,
            7'b1100111: get_instruction_type = `I;
            7'b0100011: get_instruction_type = `S;
            7'b0010111,
            7'b0110111: get_instruction_type = `U;
            7'b1100011: get_instruction_type = `B;
            7'b1101111: get_instruction_type = `J;
            default: get_instruction_type    = `R;
        endcase
    endfunction
    //sequential version
    always @(posedge(clk))
    begin
        opcode     = instruction[6:0];
        rd         = instruction[11:7];
        funct3     = instruction[14:12];
        rs1        = instruction[19:15];
        rs2        = instruction[24:20];
        funct7     = instruction[31:25];
        imm_i_type = {{20{instruction[31]}},instruction[31:20]};
        imm_s_type = {{20{instruction[31]}},instruction[31:25], instruction[11:7]};
        imm_b_type = {{19 {instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8], 1'b0};
        imm_u_type = {instruction[31:12], 12'b0};
        imm_j_type = {{11{instruction[31]}},instruction[31], instruction[19:12],instruction[20],instruction[30:21], 1'b0};
        case (get_instruction_type(opcode))
            `I: imm       = imm_i_type;
            `S: imm       = imm_s_type;
            `B: imm       = imm_b_type;
            `U: imm       = imm_u_type;
            `J: imm       = imm_j_type;
            default: imm = imm_i_type;
        endcase
    end
    // combinatorial
    
    
    
endmodule
