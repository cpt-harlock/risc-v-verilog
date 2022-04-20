`include "defines.vh"
module mem (
    input clk,
    input [31:0] result,
    input [31:0] data,
    input store_mem,
    input load_mem,
    input [1:0] size,
    output reg [31:0] out_data
    
);

reg [7:0] memory [0:`DATA_MEMSIZE-1];

always @(posedge clk ) begin
    if (store_mem == 1) begin
        case (size)
            1: memory[result] = data[7:0];
            2: {memory[result+1],memory[result]} = data[15:0];
            4: {memory[result+3],memory[result+2],memory[result+1],memory[result]} = data;
            default: ;
        endcase
    end    
    if (load_mem == 1) begin
        case (size)
            1:  out_data = {{24{1'b0}},memory[result]};
            2:  out_data = {{16{1'b0}},memory[result+1], memory[result]};
            4:  out_data = {memory[result+3], memory[result+2],memory[result+1], memory[result]};
            default: ;
        endcase
    end
    else 
        out_data = result;
end 
endmodule