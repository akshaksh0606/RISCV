`timescale 1ns/1ps

module inst_mem(
    input [31:0] pc,
    output [31:0] instruction,
    input clk,
    input rst
);

reg [7:0] mem [99:0];

assign instruction = {mem[pc+3], mem[pc+2], mem[pc+1], mem[pc]};

initial
    
    begin

        integer i;
        for(i=0 ; i<100 ; i++)
            mem[i] = 8'b0;

      
                
                // R TYPE INSTRUCTIONS
                //ADD INSTI  (0000000 01001 01000 000 00110 0110011) x8+x9=x6
                mem[3] <= 8'h00;
                mem[2] <= 8'h94;
                mem[1] <= 8'h03;
                mem[0] <= 8'h33;

                // SUB INSTI  (0100000 01001 01000 000 00110 0110011) x8-x9=x6
                mem[7] <= 8'h40;
                mem[6] <= 8'h94;
                mem[5] <= 8'h03;
                mem[4] <= 8'h33;

                // XOR INSTI (0000000 01001 01000 100 00110 0110011) x8^x9=x6
                mem[11] <= 8'h00;
                mem[10] <= 8'h94;
                mem[9] <= 8'h43;
                mem[8] <= 8'h33;

                // OR INSTI  (0000000 01001 01000 110 00110 0110011) x8|x9=x6
                mem[15] <= 8'h00;
                mem[14] <= 8'h94;
                mem[13] <= 8'h63;
                mem[12] <= 8'h33;

                // AND INSTI (0000000 01001 01000 111 00110 0110011) x8&x9=x6
                mem[19] <= 8'h00;
                mem[18] <= 8'h94;
                mem[17] <= 8'h73;
                mem[16] <= 8'h33;

                // SLT INSTI  (0000000 01001 01000 010 00110 0110011) x8<x9?x6=1:x6=0
                mem[23] <= 8'h00;
                mem[22] <= 8'h94;
                mem[21] <= 8'h43;
                mem[20] <= 8'h33;


           

    end


endmodule