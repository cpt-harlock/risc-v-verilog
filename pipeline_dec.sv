module pipeline_dec (
    input clk,
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
    output [31:0] rs1_data_out,
    output [31:0] rs2_data_out,
    output [31:0] pc_out
);

always @(negedge clk ) begin
   if (nop_output == 1) 
   begin
   end 
end

endmodule