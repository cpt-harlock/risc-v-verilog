`timescale 1ns/1ps


module pc (
    input clk,
    input [31:0] new_pc,
    output reg [31:0] pc
);
initial begin
    pc = 0;
end
always @(posedge(clk)) begin
   pc <= new_pc; 
end
    
endmodule