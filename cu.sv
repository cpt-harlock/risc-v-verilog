`include "defines.vh"

module cu (
    input [6:0] opcode_fetch,
    input [6:0] opcode_dec,
    input [6:0] opcode_ex,
    input [6:0] opcode_mem,
    input branch_taken, //branch taken signal logic implemented in EX unit ...
    output nop_output_fetch,
    output nop_output_dec,
    output nop_output_ex,
    output nop_output_mem,
    output [1:0] fetch_sel
);

// insert 2 bubbles behind branch instruction 
assign nop_output_fetch = get_instruction_type(opcode_fetch) == B || get_instruction_type(opcode_fetch) == J ? 1 :
                          get_instruction_type(opcode_dec) == B || get_instruction_type(opcode_dec) == J ? 1 :
                          0;
// fetch selector is old pc while branch doesn't reach EX unit
// NOTE: we can avoid stopping the PC for jump instruction since we're going to load it with new value in any case
assign fetch_sel = get_instruction_type(opcode_fetch) == B ? `FETCH_SEL_NOP :
                   get_instruction_type(opcode_dec) == B  ? `FETCH_SEL_NOP :
                   (get_instruction_type(opcode_ex) == B || get_instruction_type(opcode_ex) == J) && branch_taken == 1 ? `FETCH_SEL_BRANCH :
                   `FETCH_SEL_PC;

endmodule