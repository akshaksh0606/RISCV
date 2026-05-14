`timescale 1ns/1ps

module inst_mem(
    input [31:0] pc,
    output [31:0] instruction,
    input clk,
    input rst
);  

reg [7:0] mem [99:0];

assign instruction = {mem[pc+3], mem[pc+2], mem[pc+1], mem[pc]};
integer i;
initial
    
    begin
        
        for(i=0 ; i<100 ; i=i+1)
      
            mem[i] = 8'b0;
                
// PC 0: ADDI x1, x0, 1  (Set first number)
mem[0] = 8'h93; mem[1] = 8'h00; mem[2] = 8'h10; mem[3] = 8'h00;
// PC 4: ADDI x2, x0, 0  (Set second number)
mem[4] = 8'h13; mem[5] = 8'h01; mem[6] = 8'h00; mem[7] = 8'h00;
// PC 8: ADD x1, x1, x2  (x1 = x1 + x2) -> Fixed rd=1
mem[8] = 8'hB3; mem[9] = 8'h80; mem[10] = 8'h20; mem[11] = 8'h00;
// PC 12: ADD x2, x1, x2 (x2 = x2 + x1)
mem[12] = 8'h33; mem[13] = 8'h81; mem[14] = 8'h20; mem[15] = 8'h00;
// PC 16: JAL x0, -8     (Jump back to PC 8) -> Fixed encoding
mem[16] = 8'h6F; mem[17] = 8'hF0; mem[18] = 8'h9F; mem[19] = 8'hFF;
               

    end


endmodule