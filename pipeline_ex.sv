module pipeline_ex (
    input clk,
    input  [31:0] result_in,
    input  [31:0] data_in,
    input [4:0] rd_in,
    input [6:0] opcode_in,
    input [2:0] funct_3_in,
    input [6:0] funct_7_in,
    output reg [31:0] result_out,
    output reg [31:0] data_out,
    output reg [4:0] rd_out,
    output reg [6:0] opcode_out,
    output reg [2:0] funct_3_out,
    output reg [6:0] funct_7_out
);

always @(negedge clk ) begin
   result_out <= result_in; 
   data_out <= data_in;
   rd_out <= rd_in;
   opcode_out <= opcode_in;
   funct_3_out <= funct_3_in;
   funct_7_out <= funct_7_in;
end
    
endmodule