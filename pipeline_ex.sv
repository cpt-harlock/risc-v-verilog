module pipeline_ex (
    input clk,
    input  [31:0] result_in,
    input  [31:0] data_in,
    input [4:0] rd_in,
    output reg [31:0] result_out,
    output reg [31:0] data_out,
    output reg [4:0] rd_out
);

always @(negedge clk ) begin
   result_out = result_in; 
   data_out = data_in;
   rd_out = rd_in;
end
    
endmodule