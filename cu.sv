`include "defines.vh"
`include "opcodes.vh"

module cu (
    input [6:0] opcode_fetch,
    input [6:0] opcode_dec,
    input [6:0] opcode_ex,
    input [6:0] opcode_mem,
    // branch taken signal computed by ex phase
    input branch_taken, //branch taken signal logic implemented in EX unit ...
    // signal to nop pipelines
    output nop_output_fetch,
    output nop_output_dec,
    output nop_output_ex,
    output nop_output_mem,
    output [1:0] fetch_sel,
    // signal for exec pipeline reg
    output store_mem,
    output load_mem,
    output store_reg,
    output [1:0] size
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

assign store_mem = get_instruction_type(opcode_ex) == S ? 1 : 0;
assign load_mem = opcode_ex == `LB ? 1 :
                    opcode_ex == `LH ? 1 :
                    opcode_ex == `LW ? 1 :
                    opcode_ex == `LBU ? 1 :
                    opcode_ex == `LHU ? 1 :
                    0;
assign store_reg = get_instruction_type(opcode_ex) == R ? 1 :
                    get_instruction_type(opcode_ex) == I ? 1 :
                    get_instruction_type(opcode_ex) == J ? 1 :
                    get_instruction_type(opcode_ex) == U ? 1 : 0;

assign size = opcode_ex == `LB || opcode_ex == `SB || opcode_ex == `LBU ? 1 :
                opcode_ex == `LH || opcode_ex == `SH || opcode_ex == `LHU ? 2 :
                opcode_ex == `LW || opcode_ex == `SW ? 4 : 0;
endmodule