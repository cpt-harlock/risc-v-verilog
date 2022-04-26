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
                     output [6:0] opcode_out,
                     output [4:0] rd_out,
                     output [2:0] funct3_out,
                     output [4:0] rs1_out,
                     output [4:0] rs2_out,
                     output [6:0] funct7_out,
                     output [31:0] imm_out,
                     output [31:0] rs1_data_out,
                     output [31:0] rs2_data_out,
                     output [31:0] pc_out);
    
    reg [6:0] opcode_out_temp;
    reg [4:0] rd_out_temp;
    reg [2:0] funct3_out_temp;
    reg [4:0] rs1_out_temp;
    reg [4:0] rs2_out_temp;
    reg [6:0] funct7_out_temp;
    reg [31:0] imm_out_temp;
    reg [31:0] rs1_data_out_temp;
    reg [31:0] rs2_data_out_temp;
    reg [31:0] pc_out_temp;
    
    
    always @(negedge clk, stall) begin
        if (!stall) begin
            if (nop_output == 1)
            begin
                //TODO: implement!!!
            end
            else begin
                opcode_out_temp   <= opcode_in;
                rd_out_temp       <= rd_in;
                funct3_out_temp   <= funct3_in;
                rs1_out_temp      <= rs1_in;
                rs2_out_temp      <= rs2_in;
                funct7_out_temp   <= funct7_in;
                imm_out_temp      <= imm_in;
                rs1_data_out_temp <= rs1_data_in;
                rs2_data_out_temp <= rs2_data_in;
                pc_out_temp       <= pc_in;
            end
        end
    end

    assign opcode_out == !stall ? opcode_out_temp : `NOP_INSTRUCTION_OPCODE;    
    assign rd_out == !stall ? rd_out_temp : `NOP_INSTRUCTION_RD;    
    assign funct3_out == !stall ? funct3_out_temp : `NOP_INSTRUCTION_FUNCT3;    
    assign funct7_out == !stall ? funct7_out_temp : `NOP_INSTRUCTION_FUNCT7;    
    assign rs1_out == !stall ? rs1_out_temp : `NOP_INSTRUCTION_RS1;    
    assign rs2_out == !stall ? rs2_out_temp : `NOP_INSTRUCTION_RS2;    
    assign imm_out == !stall ? imm_out_temp : `NOP_INSTRUCTION_IMM;    
    assign rs1_data_out == !stall ? rs1_data_out_temp : `NOP_INSTRUCTION_RS1_DATA;    
    assign rs2_data_out == !stall ? rs2_data_out_temp : `NOP_INSTRUCTION_RS2_DATA;    
    assign pc_out == !stall ? pc_out_temp : `NOP_INSTRUCTION_PC;    
    

endmodule
