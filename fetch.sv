`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2022 11:46:06 PM
// Design Name: 
// Module Name: fetch
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


module fetch(
    input clk,
    input [31:0] pc,
    output reg [31:0] instruction
    );
    (* ram_style = "block" *) reg [31:0] instruction_memory[0:2**3];
    always @(posedge clk)
    begin
        instruction <= instruction_memory[pc];
    end
endmodule
