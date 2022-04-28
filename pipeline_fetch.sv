`include "defines.vh"

module pipeline_fetch (input clk,
                       input [31:0] input_instruction,
                       input nop_output,
                       input [31:0] pc_in,
                       output reg [6:0] opcode,
                       output reg [31:0] output_instruction,
                       output reg [31:0] pc_out);
    
    always @(negedge clk) begin
        if (nop_output == 1) begin
            output_instruction = `NOP_INSTRUCTION;
            opcode = `NOP_INSTRUCTION_OPCODE;
            pc_out = `NOP_INSTRUCTION_PC;
            end
        else begin
            output_instruction = input_instruction;
            opcode             = output_instruction[6:0];
            pc_out             = pc_in;
         end
    end
    
    
endmodule
