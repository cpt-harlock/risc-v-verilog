`timescale 1ns / 1ps
`include "defines.vh"
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
        #10;
        for (i = 0; i < 1000 ; i = i + 1) begin
            
            #10 clk = 0;
//            $stop;
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
    wire [31:0] imm;
    wire [31:0] pc_out;
    wire [31:0] fetch_input;
    wire [31:0] pc_input;
    
    wire [31:0] branch_target;
    wire [1:0] fetch_sel;
    
    
    wire branch_taken;
    wire [31:0] fetch_pipeline_output_instruction;
    
    assign out = instruction;
   
    /* CONTROL UNIT */
   cu control_unit (
    .opcode_fetch(fetch_pipeline_output_instruction[6:0]),
    .opcode_dec(opcode_dec),
    .opcode_ex(opcode_ex),
    .opcode_mem(opcode_mem),
    .branch_taken(branch_taken), //branch taken signal logic implemented in EX unit ...
    .nop_output_fetch(nop_output_cu),
    .nop_output_dec(nop_output_dec),
    .nop_output_ex(nop_output_ex),
    .nop_output_mem(nop_output_mem),
    .fetch_sel(fetch_sel),
    // signal for exec pipeline reg
    .store_mem(store_mem_cu),
    .load_mem(load_mem_cu),
    .store_reg(store_reg_cu)
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
    .nop_output(fetch_nop_output),
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
     .rs1(rs1_dec),
     .rs2(rs2_dec),
     .rd(regfile_rd),
     .wen(regfile_wen),
     .rdData(regfile_rd_data),
     .rs1Data(rs1Data),
     .rs2Data(rs2Data)
    );
    
    
    pipeline_dec pipe_dec (
    .clk(clk),
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
    .opcode_out(opcode_ex_in),
    .rd_out(rd_ex_in),
    .funct3_out(funct3_ex_in),
    .rs1_out(rs1_ex_in),
    .rs2_out(rs2_ex_in),
    .funct7_out(funct7_ex_in),
    .imm_out(imm_ex_in),
    .rs1_data_out(rs1_data_ex_in),
    .rs2_data_out(rs2_data_ex_in),
    .pc_in(fetch_pipe_pc_out),
    .pc_out(dec_pipe_pc_out)
    );

    /* END DEC UNIT */

    /* EX UNIT */
    exec ex (
    .clk(clk),
    .opcode(opcode_ex_in),
    .funct3(funct3_ex_in),
    .rs1Data(rs1_ex_in),
    .rs2Data(rs2_ex_in),
    .funct7(funct7_ex_in),
    .imm(),
    .pc(dec_pipe_pc_out),
    .result(),
    .address(branch_target),
    .branch_taken(branch_taken)
    );

    wire [31:0] mem_result;
    wire [31:0] mem_data;
    wire [4:0] mem_rd_in;
    wire mem_store_mem;
    wire mem_load_mem;
    wire mem_store_reg;

    pipeline_ex pipe_ex (
    .clk(clk),
    .result_in(ex_result),
    .data_in(ex_data),
    .rd_in(rd_ex_in),
    .result_out(mem_result),
    .data_out(mem_data),
    .rd_out(mem_rd_in)
    );
    /* END EX MODULE */


    /* BEGIN MEM MODULE */
    wire [31:0] mem_out_data;
    mem memory (
    .clk(clk),
    .result(mem_result),
    .data(mem_data),
    .store_mem(mem_store_mem),
    .load_mem(mem_load_mem),
    .size(size_cu),
    .out_data(mem_out_data)
    ); 


    wire [31:0] regfile_rd_data;
    wire regfile_wen;
    wire [4:0] regfile_rd;

    pipeline_mem pipe_mem (
    .clk(clk),
    .data_in(mem_out_data),
    .store_reg_in(store_reg_cu),
    .rd_in(mem_rd_in),
    .data_out(regfile_rd_data),
    .store_reg_out(regfile_wen),
    .rd_out(regfile_rd)
    );
    /* END MEM */


endmodule
