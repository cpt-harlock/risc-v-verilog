`timescale 1ns/1ps
`include "opcodes.vh"
module exec (
    input clk,
    input [6:0] opcode,
    input [4:0] rd,
    input [2:0] funct3,
    input [4:0] rs1,
    input [4:0] rs2,
    input [6:0] funct7,
    input [31:0] imm_i_type,
    input [31:0] imm_s_type,
    input [31:0] imm_b_type,
    input [31:0] imm_u_type,
    input [31:0] imm_j_type,
    output [31:0] pc
    );
    
    (* ram_style = "block" *) reg [7:0] data_memory[0:2**3-1]; 
    reg [31:0] registers[0:2**5 - 1];
    reg [31:0] rs1Data, rs2Data;
    
    // a big if !
    always @*
    begin
    rs1Data = registers[rs1];
    rs2Data = registers[rs2];
    //TODO: put wen = 0?
    case ({opcode, funct3, funct7[5]})
        `LB : begin
        registers[rd] = {{24{data_memory[imm_i_type+rs1Data][7]}},data_memory[imm_i_type+rs1Data]};
        end
        `LH : begin
        registers[rd] = {{16{data_memory[imm_i_type+rs1Data+1][7]}},data_memory[imm_i_type+rs1Data+1],data_memory[imm_i_type+rs1Data]};
        end
        `LW : begin
        registers[rd] = {data_memory[imm_i_type+rs1Data+3],data_memory[imm_i_type+rs1Data+2],data_memory[imm_i_type+rs1Data+1],data_memory[imm_i_type+rs1Data]};
        end
    endcase
    end
    
endmodule