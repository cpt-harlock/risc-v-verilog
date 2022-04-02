`timescale 1ns / 1ps


module decode (
    input clk,
    input [31:0] instruction,
    output reg [6:0] opcode,
    output reg [4:0] rd,
    output reg [2:0] funct3,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [6:0] funct7,
    output reg [31:0] imm_i_type,
    output reg [31:0] imm_s_type,
    output reg [31:0] imm_b_type,
    output reg [31:0] imm_u_type,
    output reg [31:0] imm_j_type
    );
    //sequential version
//    always @(posedge(clk))
//    begin
//        opcode <= instruction[6:0];
//        rd <= instruction[11:7];
//        funct3 <= instruction[14:12];
//        rs1 <= instruction[19:15];
//        rs2 <= instruction[24:20];
//        funct7 <= instruction[31:25];
//        imm_i_type <= instruction[31:20];
//        imm_s_type <= {instruction[31:25], instruction[11:7]};
//        imm_b_type <= {{19 {instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8], 1'b0};
//        imm_u_type <= {instruction[31:12], 12'b0};
//        imm_j_type <= {{11{instruction[31]}},instruction[31], instruction[19:12],instruction[20],instruction[30:21], 1'b0};
//    end
// combinatorial
assign opcode = instruction[6:0];
assign rd = instruction[11:7];
assign funct3 = instruction[14:12];
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign funct7 = instruction[31:25];
assign imm_i_type = {{20{instruction[31]}},instruction[31:20]};
assign imm_s_type = {{20{instruction[31]}},instruction[31:25], instruction[11:7]};
assign imm_b_type = {{19 {instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8], 1'b0};
assign imm_u_type = {instruction[31:12], 12'b0};
assign imm_j_type = {{11{instruction[31]}},instruction[31], instruction[19:12],instruction[20],instruction[30:21], 1'b0};

endmodule