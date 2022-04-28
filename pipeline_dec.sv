`include "defines.vh"
module pipeline_dec (input clk,
                     input nop_output,
                     input [6:0] opcode_in,
                     input [4:0] rd_in,
                     input [2:0] funct3_in,
                     input [4:0] rs1_in,
                     input [4:0] rs2_in,
                     input [6:0] funct7_in,
                     input [31:0] imm_in,
                     input [31:0] rs1_data_in,
                     input [31:0] rs2_data_in,
                     input [31:0] pc_in,
                     input stall,
                     output reg [6:0] opcode_out,
                     output reg [4:0] rd_out,
                     output reg [2:0] funct3_out,
                     output reg [4:0] rs1_out,
                     output reg [4:0] rs2_out,
                     output reg [6:0] funct7_out,
                     output reg [31:0] imm_out,
                     output reg [31:0] rs1_data_out,
                     output reg [31:0] rs2_data_out,
                     output reg [31:0] pc_out);
    
//    reg [6:0] opcode_out_temp;
//    reg [4:0] rd_out_temp;
//    reg [2:0] funct3_out_temp;
//    reg [4:0] rs1_out_temp;
//    reg [4:0] rs2_out_temp;
//    reg [6:0] funct7_out_temp;
//    reg [31:0] imm_out_temp;
//    reg [31:0] rs1_data_out_temp;
//    reg [31:0] rs2_data_out_temp;
//    reg [31:0] pc_out_temp;
    
    
    always @(negedge clk) begin
        //when stalling, preserve registers
        if (!stall) begin
            if (nop_output == 1)
            begin
                opcode_out   <= `NOP_INSTRUCTION_OPCODE;
                rd_out       <= `NOP_INSTRUCTION_RD;
                funct3_out   <= `NOP_INSTRUCTION_FUNCT3;
                rs1_out      <= `NOP_INSTRUCTION_RS1;
                rs2_out      <= `NOP_INSTRUCTION_RS2;
                funct7_out   <= `NOP_INSTRUCTION_FUNCT7;
                imm_out      <= `NOP_INSTRUCTION_IMM;
                rs1_data_out <= `NOP_INSTRUCTION_RS1_DATA;
                rs2_data_out <= `NOP_INSTRUCTION_RS2_DATA;
                pc_out       <= `NOP_INSTRUCTION_PC;
            end
            else begin
                opcode_out   <= opcode_in;
                rd_out       <= rd_in;
                funct3_out   <= funct3_in;
                rs1_out      <= rs1_in;
                rs2_out      <= rs2_in;
                funct7_out   <= funct7_in;
                imm_out      <= imm_in;
                rs1_data_out <= rs1_data_in;
                rs2_data_out <= rs2_data_in;
                pc_out       <= pc_in;
            end
        end
    end

//    assign opcode_out = !stall ? opcode_out_temp : `NOP_INSTRUCTION_OPCODE;    
//    assign rd_out = !stall ? rd_out_temp : `NOP_INSTRUCTION_RD;    
//    assign funct3_out = !stall ? funct3_out_temp : `NOP_INSTRUCTION_FUNCT3;    
//    assign funct7_out = !stall ? funct7_out_temp : `NOP_INSTRUCTION_FUNCT7;    
//    assign rs1_out = !stall ? rs1_out_temp : `NOP_INSTRUCTION_RS1;    
//    assign rs2_out = !stall ? rs2_out_temp : `NOP_INSTRUCTION_RS2;    
//    assign imm_out = !stall ? imm_out_temp : `NOP_INSTRUCTION_IMM;    
//    assign rs1_data_out = !stall ? rs1_data_out_temp : `NOP_INSTRUCTION_RS1_DATA;    
//    assign rs2_data_out = !stall ? rs2_data_out_temp : `NOP_INSTRUCTION_RS2_DATA;    
//    assign pc_out = !stall ? pc_out_temp : `NOP_INSTRUCTION_PC;    
    

endmodule
