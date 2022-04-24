`include "defines.vh"
module mem (
    input clk,
    input [31:0] result,
    input [31:0] data,
    input store_mem,
    input load_mem,
    input [2:0] size,
    input sign,
    output reg [31:0] out_data
    
);

reg [7:0] memory [0:`DATA_MEM_SIZE-1];

initial begin
    $readmemh("/home/harlock/data_memory.txt", memory);
end

always @(posedge clk ) begin
    if (store_mem == 1) begin
        case (size)
            1: memory[result] <= data[7:0];
            2: {memory[result+1],memory[result]} <= data[15:0];
	    4: {memory[result+3],memory[result+2],memory[result+1],memory[result]} <= data;
            default: ;
        endcase
    end    
    if (load_mem == 1) begin
        case (size)
            1:  out_data <= sign == 0 ? {{24{1'b0}},memory[result]} : {{24{memory[result][7]}},memory[result]};
            2:  out_data <= sign == 0 ?  {{16{1'b0}},memory[result+1], memory[result]} : {{16{memory[result+1][7]}},memory[result+1], memory[result]};
            4:  out_data <= {memory[result+3], memory[result+2],memory[result+1], memory[result]};
            default: ;
        endcase
    end
    else 
        out_data = result;
end 
endmodule
