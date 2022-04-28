`include "defines.vh"
`include "opcodes.vh"

module cu (input clk,
           input reset,
           input [6:0] opcode_fetch,
           input [6:0] opcode_dec,
           input [6:0] opcode_ex,
           input [6:0] opcode_mem,
           input [6:0] opcode_wb,
           input [2:0] funct_3_ex,
           input funct_7_bit_ex,
           input branch_taken,        //branch taken signal logic implemented in EX unit ...
           input [4:0] rd_ex,
           input [4:0] rs1_dec,
           input [4:0] rs2_dec,
           input [4:0] rd_mem,
           input [4:0] rd_wb,
           output nop_output_fetch,
           output nop_output_dec,
           output nop_output_ex,
           output nop_output_mem,
           output [1:0] fetch_sel,
           output store_mem,
           output load_mem,
           output store_reg,
           output [2:0] size,
           output sign,
           output stall_dec,
           output forward_mem_ex_rs1,
           output forward_mem_ex_rs2,
           output forward_wb_ex_rs1,
           output forward_wb_ex_rs2);

function [2:0] get_instruction_type;
    input [6:0] opcode;
    case (opcode)
        7'b0000011,
        7'b0010011,
        7'b1100111: get_instruction_type = `I;
        7'b0100011: get_instruction_type = `S;
        7'b0010111,
        7'b0110111: get_instruction_type = `U;
        7'b1100011: get_instruction_type = `B;
        7'b1101111: get_instruction_type = `J;
        7'b0110011: get_instruction_type = `R;
        default: get_instruction_type    = `WRONG_INSTRUCTION_TYPE;
    endcase
endfunction

function is_jump_instruction;
    input [6:0] opcode;
    case (opcode)
    7'b1100111,
    7'b1101111: is_jump_instruction = 1;
    default: is_jump_instruction = 0;
    endcase
   endfunction

function write_to_register_instruction;
    input [6:0] opcode;
    case (opcode)
        7'b0000011,
        7'b0010011,
        7'b1100111: write_to_register_instruction = 1;
        7'b0100011: write_to_register_instruction = 0;
        7'b0010111,
        7'b0110111: write_to_register_instruction = 1;
        7'b1100011: write_to_register_instruction = 0;
        7'b1101111: write_to_register_instruction = 1;
        7'b0110011: write_to_register_instruction = 1;
        default: write_to_register_instruction    = 0;
    endcase
endfunction


function read_from_register_instruction;
    input [6:0] opcode;
    case (opcode)
        7'b0000011,
        7'b0010011,
        7'b1100111: read_from_register_instruction = 1;
        7'b0100011: read_from_register_instruction = 1;
        7'b0010111,
        7'b0110111: read_from_register_instruction = 1;
        7'b1100011: read_from_register_instruction = 1;
        7'b1101111: read_from_register_instruction = 0;
        7'b0110011: read_from_register_instruction = 1;
        default: read_from_register_instruction    = 1;
    endcase
endfunction



wire branch_stall, jump_stall, raw_stall;
wire store_reg_wb;


assign branch_stall = get_instruction_type(opcode_fetch) == `B || get_instruction_type(opcode_dec) == `B;
assign jump_stall   = is_jump_instruction(opcode_fetch) || is_jump_instruction(opcode_dec) ;
assign raw_stall = write_to_register_instruction(opcode_ex) && read_from_register_instruction(opcode_dec) && (rd_ex == rs1_dec || rd_ex == rs2_dec) && rd_ex != 0;
assign stall = branch_stall || jump_stall || raw_stall;
assign nop_output_fetch = branch_stall || jump_stall;
// fetch selector is old pc while branch doesn't reach EX unit
// NOTE: we can avoid stopping the PC for jump instruction since we're going to load it with new value in any case
assign fetch_sel = branch_taken == 1 ? `FETCH_SEL_BRANCH : stall == 1 ? `FETCH_SEL_NOP :
`FETCH_SEL_PC;
assign stall_dec = raw_stall;
//assign stall_dec = 0;

assign store_mem = get_instruction_type(opcode_ex) == `S ? 1 : 0;
assign load_mem = {opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `LB ? 1 :
{opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `LH ? 1 :
{opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `LW ? 1 :
{opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `LBU ? 1 :
{opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `LHU ? 1 :
0;

assign store_reg = get_instruction_type(opcode_mem) == `R ? 1 :
get_instruction_type(opcode_mem) == `I ? 1 :
get_instruction_type(opcode_mem) == `J ? 1 :
get_instruction_type(opcode_mem) == `U ? 1 : 0;

assign size = {opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `LB || {opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `SB || {opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `LBU ? 1 :
{opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `LH || {opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `SH || {opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `LHU ? 2 :
{opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `LW || {opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `SW ? 4 : 0;

assign sign = {opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `LB || {opcode_ex, funct_3_ex, funct_7_bit_ex} ==? `LH ? 1 : 0;


assign store_reg_wb = get_instruction_type(opcode_wb) == `R ? 1 :
get_instruction_type(opcode_wb) == `I ? 1 :
get_instruction_type(opcode_wb) == `J ? 1 :
get_instruction_type(opcode_wb) == `U ? 1 : 0;


//forwarding signals
assign forward_mem_ex_rs1 = (rd_mem == rs1_dec) && (rs1_dec != 0) && (store_reg);
assign forward_mem_ex_rs2 = (rd_mem == rs2_dec) && (rs2_dec != 0) && (store_reg);

assign forward_wb_ex_rs1 = (rd_wb == rs1_dec) && (rs1_dec != 0) && (store_reg_wb);
assign forward_wb_ex_rs2 = (rd_wb == rs2_dec) && (rs2_dec != 0) && (store_reg_wb);


endmodule
