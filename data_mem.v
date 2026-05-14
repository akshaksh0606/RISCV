`timescale 1ns/1ps

// Data Memory - supports LW (load word) and SW (store word)
module data_mem(
    input         clk,
    input         rst,
    input         mem_read,    // control: 1 = load (LW)
    input         mem_write,   // control: 1 = store (SW)
    input  [31:0] addr,        // address from ALU result
    input  [31:0] write_data,  // data to store (rs2)
    output reg [31:0] read_data // data loaded (to write-back mux)
);

reg [7:0] mem [0:255]; // 256 bytes of data memory

integer i;

// Initialize memory to 0 on reset / at start
initial begin
    for (i = 0; i < 256; i = i + 1)
        mem[i] = 8'b0;
end

always @(posedge clk) 
begin
    if (rst) begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] <= 8'b0;
        read_data <= 32'b0; // Initialize read_data on reset
    end 
    else 
    begin
        
    if (mem_write) 
    begin
        // Little-endian word write
        mem[addr]     <= write_data[7:0];
        mem[addr + 1] <= write_data[15:8];
        mem[addr + 2] <= write_data[23:16];
        mem[addr + 3] <= write_data[31:24];
    end
    
    if (mem_read) 
    begin
        read_data <= {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
    end

    end
end



endmodule
