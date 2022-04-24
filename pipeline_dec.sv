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
    
    always @(negedge clk) begin
        if (nop_output == 1)
        begin
        end
        else begin
            opcode_out <= opcode_in;
            rd_out <= rd_in;
            funct3_out <= funct3_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            funct7_out <= funct7_in;
            imm_out <= imm_in;
            rs1_data_out <= rs1_data_in;
            rs2_data_out <= rs2_data_in;
            pc_out <= pc_in;
        end
    end
    
endmodule
