`define FETCH_SEL_PC 2'b00
`define FETCH_SEL_BRANCH 2'b01
`define FETCH_SEL_NOP 2'b10
`define FETCH_SEL_NOP 2'b10
`define NOP_INSTRUCTION 32'b0000000_00000_00000_000_00000_0110011
`define NOP_OPCODE 32'b0000000_00000_00000_000_00000_0110011
`define DATA_MEMSIZE 2**16

typedef enum bit[2:0] { R, I, S, B, U, J } instruction_type;

function [2:0] get_instruction_type;
    input [6:0] opcode;
    case (opcode)
        7'b0000011,
        7'b0010011,
        7'b1100111: get_instruction_type = I; 
        7'b0100011: get_instruction_type = S;
        7'b0010111,
        7'b0110111: get_instruction_type = U;
        7'b1100011: get_instruction_type = B;
        7'b1101111: get_instruction_type = J;
        default: get_instruction_type = R;
    endcase
endfunction