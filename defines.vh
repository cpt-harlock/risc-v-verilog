`define FETCH_SEL_PC 2'b00
`define FETCH_SEL_BRANCH 2'b01
`define FETCH_SEL_NOP 2'b10
`define FETCH_SEL_NOP 2'b10
`define NOP_INSTRUCTION 32'b0000000_00000_00000_000_00000_0110011
`define NOP_OPCODE 32'b0000000_00000_00000_000_00000_0110011
`define DATA_MEM_SIZE 2**10
`define INSTRUCTIONS_MEM_SIZE 2**8

`define R 3'b000
`define I 3'b001
`define S 3'b010
`define B 3'b011 
`define U 3'b100
`define J 3'b101
`define WRONG_INSTRUCTION_TYPE 3'b111