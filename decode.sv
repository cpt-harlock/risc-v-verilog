`timescale 1ns / 1ps
`include "defines.vh"

module decode (input [31:0] instruction,
               output [6:0] opcode,
               output [4:0] rd,
               output [2:0] funct3,
               output [4:0] rs1,
               output [4:0] rs2,
               output [6:0] funct7,
               output [31:0] imm);
wire [31:0] imm_i_type;
wire [31:0] imm_s_type;
wire [31:0] imm_b_type;
wire [31:0] imm_u_type;
wire [31:0] imm_j_type;

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
        7'b0110011: get_instruction_type = `R;
        default: get_instruction_type = `WRONG_INSTRUCTION_TYPE;
    endcase
endfunction
//sequential version
assign opcode     = instruction[6:0];
assign rd         = instruction[11:7];
assign funct3     = instruction[14:12];
assign rs1        = instruction[19:15];
assign rs2        = instruction[24:20];
assign funct7     = instruction[31:25];
assign imm_i_type = {{20{instruction[31]}},instruction[31:20]};
assign imm_s_type = {{20{instruction[31]}},instruction[31:25], instruction[11:7]};
assign imm_b_type = {{19 {instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8], 1'b0};
assign imm_u_type = {instruction[31:12], 12'b0};
assign imm_j_type = {{11{instruction[31]}},instruction[31], instruction[19:12],instruction[20],instruction[30:21], 1'b0};
assign imm = get_instruction_type(opcode) == `I ? imm_i_type :
get_instruction_type(opcode) == `S ? imm_s_type :
get_instruction_type(opcode) == `B ? imm_b_type :
get_instruction_type(opcode) == `U ? imm_u_type :
get_instruction_type(opcode) == `J ? imm_j_type : 32'b0;



endmodule
