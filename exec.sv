`timescale 1ns/1ps
`include "opcodes.vh"
module exec (input clk,
             input [6:0] opcode,
             input [2:0] funct3,
             input [6:0] funct7,
             input [31:0] imm,
             input [31:0] rs1Data_dec,
             input [31:0] rs2Data_dec,
             input [31:0] rdMem,
             input [31:0] rdWb,
             input forward_mem_ex_rs1,
             input forward_mem_ex_rs2,
             input forward_wb_ex_rs1,
             input forward_wb_ex_rs2,
             input [31:0] pc,
             output reg [31:0] result,
             output reg branch_taken,
             output reg [31:0] address,
             output reg [31:0] data);
    
    reg [31:0] rs1Data, rs2Data;
    
    initial begin
        branch_taken = 0;
    end
    // a big if !
    always @(posedge clk)
        // possible data to store in memory
        begin
        if (forward_mem_ex_rs1) begin
            rs1Data = rdMem;
        end
        else if (forward_wb_ex_rs1) begin
            rs1Data = rdWb;
        end
        else begin
            rs1Data = rs1Data_dec;
        end
    
    if (forward_mem_ex_rs2) begin
        rs2Data = rdMem;
    end
    else if (forward_wb_ex_rs2) begin
        rs2Data = rdWb;
    end
    else begin
        rs2Data = rs2Data_dec;
    end
    
    data = rs2Data;
    casez ({opcode, funct3, funct7[5]})
        `LB,
        `LH,
        `LW,
        `LBU,
        `LHU,
        `ADDI,
        `SB,
        `SH,
        `SW: begin
            result       = rs1Data + imm;
            branch_taken = 0;
        end
        `SLLI : begin
            result       = rs1Data << imm[4:0];
            branch_taken = 0;
        end
        `SLTI : begin
            result       = $signed(rs1Data) < $signed(imm);
            branch_taken = 0;
        end
        `SLTIU : begin
            result       = rs1Data < imm;
            branch_taken = 0;
        end
        `XORI : begin
            result       = rs1Data ^ imm;
            branch_taken = 0;
        end
        `SRLI : begin
            result       = rs1Data >> imm[4:0];
            branch_taken = 0;
        end
        `SRAI: begin
            result       = $signed(rs1Data) >>> imm[4:0];
            branch_taken = 0;
        end
        `ORI: begin
            result       = rs1Data | imm;
            branch_taken = 0;
        end
        `ANDI: begin
            result       = rs1Data & imm;
            branch_taken = 0;
        end
        `AUIPC: begin
            result       = imm + pc - 4;
            branch_taken = 0;
        end
        `ADD : begin
            result       = rs1Data + rs2Data;
            branch_taken = 0;
        end
        `SUB: begin
            result       = rs1Data - rs2Data;
            branch_taken = 0;
        end
        `SLL: begin
            result       = rs1Data << rs2Data[4:0];
            branch_taken = 0;
        end
        `SLT: begin
            result       = $signed(rs1Data) < $signed(rs2Data);
            branch_taken = 0;
        end
        `SLTU: begin
            result       = rs1Data < rs2Data;
            branch_taken = 0;
        end
        `XOR: begin
            result       = rs1Data ^ rs2Data;
            branch_taken = 0;
        end
        `SRL: begin
            result       = rs1Data >> rs2Data[4:0];
            branch_taken = 0;
        end
        `SRA: begin
            result       = $signed(rs1Data) >>> rs2Data[4:0];
            branch_taken = 0;
        end
        `OR: begin
            result       = rs1Data | rs2Data;
            branch_taken = 0;
        end
        `AND: begin
            result       = rs1Data & rs2Data;
            branch_taken = 0;
        end
        `LUI: begin
            result       = imm;
            branch_taken = 0;
        end
        `BEQ: begin
            if (rs1Data == rs2Data) begin
                address      = pc + imm - 4;
                branch_taken = 1;
            end
            else
            branch_taken = 0;
        end
        `BNE: begin
            if (rs1Data != rs2Data) begin
                address      = pc + imm - 4;
                branch_taken = 1;
            end
            else
            branch_taken = 0;
        end
        `BLT: begin
            if ($signed(rs1Data) <   $signed(rs2Data)) begin
                address      = pc + imm - 4;
                branch_taken = 1;
            end
            else
            branch_taken = 0;
        end
        `BGE: begin
            if ($signed(rs1Data) >= $signed(rs2Data)) begin
                address      = pc + imm - 4;
                branch_taken = 1;
            end
            else
            branch_taken = 0;
        end
        `BLTU: begin
            if (rs1Data < rs2Data) begin
                address      = pc + imm - 4;
                branch_taken = 1;
            end
            else
            branch_taken = 0;
        end
        `BGEU: begin
            if (rs1Data >= rs2Data) begin
                address      = pc + imm - 4;
                branch_taken = 1;
            end
            else
            branch_taken = 0;
        end
        `JALR: begin
            result       = pc;
            address      = rs1Data + imm;
            branch_taken = 1;
        end
        `JAL: begin
            result       = pc;
            address      = pc + imm - 4;
            branch_taken = 1;
        end
    endcase
    end
    
endmodule
