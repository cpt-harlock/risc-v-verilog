module pipeline_mem (
    input clk,
    input [31:0] data_in,
    input store_reg_in,
    input [4:0] rd_in,
    output reg [31:0] data_out,
    output reg store_reg_out,
    output reg [4:0] rd_out
);

always @(negedge clk ) begin
   data_out = data_in; 
   store_reg_out = store_reg_in;
   rd_out = rd_in;
end
    
endmodule