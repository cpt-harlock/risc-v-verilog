`timescale 1ns / 1ps
`include "defines.vh"
//`include "modules_include.vh"
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

module riscvi(output [31:0] out);
    
    integer i;
    reg clk;
    initial begin
    clk = 0;
    reset = 1;
    #5;
    reset = 0;
    #5;
    reset = 1; 
        $display("Simulation begin");
        $dumpfile("test.vcd");
        $dumpvars;
        $monitor("At time %t, value = %h (%0d)",
        $time, clk, clk);
        #10;
        for (i = 0; i < 400 ; i = i + 1) begin
            
            #10 clk = 0;
            //            $stop;
            #10 clk = 1;
        end
        $finish;
    end
    wire [31:0] instruction;
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;
    wire [31:0] imm;
    wire [31:0] pc_out;
    wire [31:0] fetch_input;
    wire [31:0] pc_input;
    
    wire [31:0] branch_target;
    wire [1:0] fetch_sel;
    
    
    wire branch_taken;
    wire [31:0] fetch_pipeline_output_instruction;
    
    assign out = instruction;
    
    reg reset;
    
    /* CONTROL UNIT */
    wire [2:0] size_load_store;
    cu control_unit (
    .clk(clk),
    .reset(reset),
    .opcode_fetch(fetch_pipeline_output_instruction[6:0]),
    .opcode_dec(opcode_ex_in_temp),
    .opcode_ex(opcode_ex),
    .funct_3_ex(funct_3_ex),
    .funct_7_bit_ex(funct_7_ex[5]),
    .opcode_mem(opcode_mem),
    .opcode_wb(opcode_wb),
    .branch_taken(branch_taken), //branch taken signal logic implemented in EX unit ...
    .rd_ex(mem_rd_in),
    .rs1_dec(rs1_ex_in_temp),
    .rs2_dec(rs2_ex_in_temp),
    .rd_mem(regfile_rd),
    .rd_wb(wb_rd),
    .nop_output_fetch(nop_output_fetch),
    .nop_output_dec(nop_output_dec),
    .nop_output_ex(nop_output_ex),
    .nop_output_mem(nop_output_mem),
    .fetch_sel(fetch_sel),
    // signal for exec pipeline reg
    .store_mem(store_mem_cu),
    .load_mem(load_mem_cu),
    .store_reg(store_reg_cu),
    .size(size_load_store),
    .sign(sign_load_store),
    .stall_dec(stall_dec),
    .forward_mem_ex_rs1(forward_mem_ex_rs1),
    .forward_mem_ex_rs2(forward_mem_ex_rs2),
    .forward_wb_ex_rs1(forward_wb_ex_rs1),
    .forward_wb_ex_rs2(forward_wb_ex_rs2)
    );
    
    /* FETCH UNIT */
    assign fetch_input = fetch_sel == `FETCH_SEL_PC ? pc_out :
    fetch_sel == `FETCH_SEL_BRANCH ?  branch_target :
    pc_out - 4;
    assign pc_input = fetch_input + 4;
    
    fetch fet (
    .clk(clk),
    .instruction(instruction),
    .pc(fetch_input)
    );
    
    pc pcreg (
    .clk(clk),
    .new_pc(pc_input),
    .pc(pc_out)
    );
    
    wire [31:0] fetch_pipe_pc_out;

    pipeline_fetch pipe_fetch (
    .clk(clk),
    .input_instruction(instruction),
    .nop_output(nop_output_fetch),
    .output_instruction(fetch_pipeline_output_instruction),
    //VIP: saved pc is instruction one + 4
    .pc_in(pc_out),
    .pc_out(fetch_pipe_pc_out)
    );
    
    /* END FETCH UNIT */
    
    wire [6:0] opcode_dec;
    wire [4:0] rs1_dec, rs2_dec, rd_dec;
    wire [31:0] imm_dec, rs1Data, rs2Data;
    wire [2:0] funct3_dec;
    wire [6:0] funct7_dec;
    wire [31:0] dec_pipe_pc_out;
    
    /* DECODE UNIT */
    decode dec (
    .clk(clk),
    .instruction(fetch_pipeline_output_instruction),
    .opcode(opcode_dec),
    .rd(rd_dec),
    .funct3(funct3_dec),
    .rs1(rs1_dec),
    .rs2(rs2_dec),
    .funct7(funct7_dec),
    .imm(imm_dec)
    );
    
    regfile rf (
    .clk(clk),
    .rs1(rs1_dec),
    .rs2(rs2_dec),
    .rd(regfile_rd),
    .wen(store_reg_cu),
    .rdData(regfile_rd_data),
    .rs1Data(rs1Data),
    .rs2Data(rs2Data)
    );
    
    wire [6:0] opcode_ex_in;
    wire [4:0] rd_ex_in;
    wire [2:0] funct3_ex_in;
    wire [4:0] rs1_ex_in, rs2_ex_in;
    wire [6:0] funct7_ex_in;
    wire [31:0] imm_ex_in;
    wire [31:0] rs1_data_ex_in, rs2_data_ex_in;
    
    wire [6:0] opcode_ex_in_temp;
    wire [4:0] rd_ex_in_temp;
    wire [2:0] funct3_ex_in_temp;
    wire [4:0] rs1_ex_in_temp, rs2_ex_in_temp;
    wire [6:0] funct7_ex_in_temp;
    wire [31:0] imm_ex_in_temp;
    wire [31:0] rs1_data_ex_in_temp, rs2_data_ex_in_temp;
    wire [31:0] dec_pipe_pc_out_temp;
    
    pipeline_dec pipe_dec (
    .clk(clk),
    .stall(stall_dec),
    .nop_output(dec_nop_output),
    .opcode_in(opcode_dec),
    .rd_in(rd_dec),
    .funct3_in(funct3_dec),
    .rs1_in(rs1_dec),
    .rs2_in(rs2_dec),
    .funct7_in(funct7_dec),
    .imm_in(imm_dec),
    .rs1_data_in(rs1Data),
    .rs2_data_in(rs2Data),
    .opcode_out(opcode_ex_in_temp),
    .rd_out(rd_ex_in_temp),
    .funct3_out(funct3_ex_in_temp),
    .rs1_out(rs1_ex_in_temp),
    .rs2_out(rs2_ex_in_temp),
    .funct7_out(funct7_ex_in_temp),
    .imm_out(imm_ex_in_temp),
    .rs1_data_out(rs1_data_ex_in_temp),
    .rs2_data_out(rs2_data_ex_in_temp),
    .pc_in(fetch_pipe_pc_out),
    .pc_out(dec_pipe_pc_out_temp)
    );
    
    /* END DEC UNIT */
    
    //NOP instruction for RAW stall    
    

    
    assign opcode_ex_in = !stall_dec ? opcode_ex_in_temp : `NOP_INSTRUCTION_OPCODE;
    assign funct3_ex_in = !stall_dec ? funct3_ex_in_temp : `NOP_INSTRUCTION_FUNCT3;
    assign rs1_data_ex_in = !stall_dec ? rs1_data_ex_in_temp : `NOP_INSTRUCTION_RS1_DATA;
    assign rs2_data_ex_in = !stall_dec ? rs2_data_ex_in_temp : `NOP_INSTRUCTION_RS2_DATA;
    assign funct7_ex_in = !stall_dec ? funct7_ex_in_temp : `NOP_INSTRUCTION_FUNCT7;
    assign imm_ex_in = !stall_dec ? imm_ex_in_temp : `NOP_INSTRUCTION_IMM;
    assign dec_pipe_pc_out = !stall_dec ? dec_pipe_pc_out_temp : `NOP_INSTRUCTION_PC;
    assign rd_ex_in = !stall_dec ? rd_ex_in_temp  : `NOP_INSTRUCTION_RD;
    assign rs1_ex_in = !stall_dec ? rs1_ex_in_temp  : `NOP_INSTRUCTION_RS1;
    assign rs2_ex_in = !stall_dec ? rs2_ex_in_temp  : `NOP_INSTRUCTION_RS2;
    
    /* EX UNIT */
    wire [31:0] ex_result;
    exec ex (
    .clk(clk),
    .opcode(opcode_ex_in),
    .funct3(funct3_ex_in),
    .rs1Data_dec(rs1_data_ex_in),
    .rs2Data_dec(rs2_data_ex_in),
    .rdMem(regfile_rd_data),
    .rdWb(wb_rd_data),
    .forward_mem_ex_rs1(forward_mem_ex_rs1),
    .forward_mem_ex_rs2(forward_mem_ex_rs2),
    .forward_wb_ex_rs1(forward_wb_ex_rs1),
    .forward_wb_ex_rs2(forward_wb_ex_rs2),
    .funct7(funct7_ex_in),
    .imm(imm_ex_in),
    .pc(dec_pipe_pc_out),
    .result(ex_result),
    .address(branch_target),
    .branch_taken(branch_taken)
    );
    
    wire [31:0] mem_result;
    wire [31:0] mem_data;
    wire [4:0] mem_rd_in;
    wire mem_store_mem;
    wire mem_load_mem;
    wire mem_store_reg;
    
    wire [6:0] opcode_ex;
    
    wire [2:0] funct_3_ex;
    wire [6:0] funct_7_ex;
    
    pipeline_ex pipe_ex (
    .clk(clk),
    .result_in(ex_result),
    .data_in(rs2_data_ex_in),
    .rd_in(rd_ex_in),
    .opcode_in(opcode_ex_in),
    .funct_3_in(funct3_ex_in),
    .funct_7_in(funct7_ex_in),
    .result_out(mem_result),
    .data_out(mem_data),
    .rd_out(mem_rd_in),
    .opcode_out(opcode_ex),
    .funct_3_out(funct_3_ex),
    .funct_7_out(funct_7_ex)
    );
    /* END EX MODULE */
    
    
    /* BEGIN MEM MODULE */
    wire [31:0] mem_out_data;
    mem memory (
    .clk(clk),
    .result(mem_result),
    .data(mem_data),
    .store_mem(store_mem_cu),
    .load_mem(load_mem_cu),
    .size(size_load_store),
    .out_data(mem_out_data),
    .sign(sign_load_store)
    );
    
    
    wire [31:0] regfile_rd_data;
    wire regfile_wen;
    wire [4:0] regfile_rd;
    wire [6:0] opcode_mem;
    wire store_reg_cu;
    
    pipeline_mem pipe_mem (
    .clk(clk),
    .data_in(mem_out_data),
    .rd_in(mem_rd_in),
    .opcode_in(opcode_ex),
    .data_out(regfile_rd_data),
    .rd_out(regfile_rd),
    .opcode_out(opcode_mem)
    );
    /* END MEM */
    
    wire [31:0] wb_rd_data;
    wire [6:0] opcode_wb;
    wire [4:0] wb_rd;
    pipeline_mem pipe_wb (
    .clk(clk),
    .data_in(regfile_rd_data),
    .rd_in(regfile_rd),
    .opcode_in(opcode_mem),
    .data_out(wb_rd_data),
    .rd_out(wb_rd),
    .opcode_out(opcode_wb)
    );
    
    
endmodule
