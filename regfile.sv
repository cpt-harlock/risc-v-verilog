`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2022 11:32:55 PM
// Design Name: 
// Module Name: regfile
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

module regfile(
    input clk, 
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input wen,
    input [31:0] rdData,
    output reg [31:0] rs1Data,
    output reg [31:0] rs2Data
    );
    
    reg [31:0] registers[0:2**5 - 1];
    
    always @(posedge(clk)) begin
        rs1Data <= registers[rs1];
        rs2Data <= registers[rs2];
        if (wen == 1)
            registers[rd] <= rdData;
    end
     
endmodule
