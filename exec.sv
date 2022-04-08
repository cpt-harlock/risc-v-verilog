`timescale 1ns/1ps
`include "opcodes.vh"
module exec (input clk,
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
             output reg [31:0] pc);
    (* ram_style = "block" *) reg [7:0] data_memory[0:2**10 - 1];
    reg [31:0] registers[0:2**5 - 1];
    reg [31:0] rs1Data, rs2Data;
    reg [31:0] address;
    
    
    initial
    begin
        pc = 0;
        $readmemh("/home/andrea/Documents/University/Code/risc-v-verilog/register_memory.txt", registers);
        $readmemh("/home/andrea/Documents/University/Code/risc-v-verilog/data_memory.txt", data_memory);
    end
    
    // a big if !
    always @*
    begin
    rs1Data = registers[rs1];
    rs2Data = registers[rs2];
    //TODO: put wen = 0?
    casez ({opcode, funct3, funct7[5]})
        `LB : begin
            registers[rd] = {{24{data_memory[imm_i_type+rs1Data][7]}},data_memory[imm_i_type+rs1Data]};
            pc            = pc + 4;
        end
        `LH : begin
            registers[rd] = {{16{data_memory[imm_i_type+rs1Data+1][7]}},data_memory[imm_i_type+rs1Data+1],data_memory[imm_i_type+rs1Data]};
            pc            = pc + 4;
        end
        `LW : begin
            registers[rd] = {data_memory[imm_i_type+rs1Data+3],data_memory[imm_i_type+rs1Data+2],data_memory[imm_i_type+rs1Data+1],data_memory[imm_i_type+rs1Data]};
            pc            = pc + 4;
        end
        `LBU : begin
            registers[rd] = {{24{1'b0}},data_memory[imm_i_type+rs1Data]};
            pc            = pc + 4;
        end
        `LHU : begin
            registers[rd] = {{16{1'b0}},data_memory[imm_i_type+rs1Data+1],data_memory[imm_i_type+rs1Data]};
            pc            = pc + 4;
        end
        `ADDI : begin
            registers[rd] = registers[rs1] + imm_i_type;
            pc            = pc + 4;
        end
        `SLLI : begin
            registers[rd] = registers[rs1] << imm_i_type[4:0];
            pc            = pc + 4;
        end
        `SLTI : begin
            registers[rd] = $signed(registers[rs1]) < $signed(imm_i_type);
            pc            = pc + 4;
        end
        `SLTIU : begin
            registers[rd] = registers[rs1] < imm_i_type;
            pc            = pc + 4;
        end
        `XORI : begin
            registers[rd] = registers[rs1] ^ imm_i_type;
            pc            = pc + 4;
        end
        `SRLI : begin
            registers[rd] = registers[rs1] >> imm_i_type[4:0];
            pc            = pc + 4;
        end
        `SRAI: begin
            registers[rd] = registers[rs1] >>> imm_i_type[4:0];
            pc            = pc + 4;
        end
        `ORI: begin
            registers[rd] = registers[rs1] | imm_i_type;
            pc            = pc + 4;
        end
        `ANDI: begin
            registers[rd] = registers[rs1] & imm_i_type;
            pc            = pc + 4;
        end
        `AUIPC: begin
            registers[rd] = imm_u_type + pc;
            pc            = pc + 4;
        end
        `SB: begin
            address              = rs1Data + imm_s_type;
            data_memory[address] = rs2Data[7:0];
            pc                   = pc + 4;
        end
        `SH: begin
            address                = rs1Data + imm_s_type;
            data_memory[address]   = rs2Data[7:0];
            data_memory[address+1] = rs2Data[15:8];
            pc                     = pc + 4;
        end
        `SW: begin
            address                = rs1Data + imm_s_type;
            data_memory[address]   = rs2Data[7:0];
            data_memory[address+1] = rs2Data[15:8];
            data_memory[address+2] = rs2Data[23:16];
            data_memory[address+3] = rs2Data[31:24];
            pc                     = pc + 4;
        end
        `ADD : begin
            registers[rd] = rs1Data + rs2Data;
            pc            = pc + 4;
        end
        `SUB: begin
            registers[rd] = rs1Data - rs2Data;
            pc            = pc + 4;
        end
        `SLL: begin
            registers[rd] = rs1Data << rs2Data[4:0];
            pc            = pc + 4;
        end
        `SLT: begin
            registers[rd] = $signed(rs1Data) < $signed(rs2Data);
            pc            = pc + 4;
        end
        `SLTU: begin
            registers[rd] = rs1Data < rs2Data;
            pc            = pc + 4;
        end
        `XOR: begin
            registers[rd] = rs1Data ^ rs2Data;
            pc            = pc + 4;
        end
        `SRL: begin
            registers[rd] = rs1Data >> rs2Data[4:0];
            pc            = pc + 4;
        end
        `SRA: begin
            registers[rd] = rs1Data >>> rs2Data[4:0];
            pc            = pc + 4;
        end
        `OR: begin
            registers[rd] = rs1Data | rs2Data;
            pc            = pc + 4;
        end
        `AND: begin
            registers[rd] = rs1Data & rs2Data;
            pc            = pc + 4;
        end
        `LUI: begin
            registers[rd] = imm_u_type;
            pc            = pc + 4;
        end
        `BEQ: begin
            if (rs1Data == rs2Data) begin
                pc = pc + imm_b_type;
            end
            else
            pc = pc + 4;
        end
        `BNE: begin
            if (rs1Data != rs2Data) begin
                pc = pc + imm_b_type;
            end
            else
            pc = pc + 4;
        end
        `BLT: begin
            if ($signed(rs1Data) <   $signed(rs2Data)) begin
                pc = pc + imm_b_type;
            end
            else
            pc = pc + 4;
        end
        `BGE: begin
            if ($signed(rs1Data) >= $signed(rs2Data)) begin
                pc = pc + imm_b_type;
            end
            else
            pc = pc + 4;
        end
        `BLTU: begin
            if (rs1Data < rs2Data) begin
                pc = pc + imm_b_type;
            end
            else
            pc = pc + 4;
        end
        `BGEU: begin
            if (rs1Data >= rs2Data) begin
                pc = pc + imm_b_type;
            end
            else
            pc = pc + 4;
        end
        `JALR: begin
            registers[rd] = pc + 4;
            pc            = rs1Data + imm_j_type;
        end
        `JAL: begin
            registers[rd] = pc + 4;
            pc            = pc + imm_j_type;
        end
    endcase
    end
    
endmodule
