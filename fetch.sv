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
    (* ram_style = "block" *) reg [7:0] instruction_memory[0:2**4 - 1];
    initial begin
        $readmemh("/home/andrea/Documents/University/Code/risc-v-verilog/instruction_memory.txt", instruction_memory);
    end
    always @(posedge clk)
    begin
        instruction <= {instruction_memory[pc+3],instruction_memory[pc+2],instruction_memory[pc+1],instruction_memory[pc]};
    end
endmodule
