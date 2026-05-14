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
                
                
                // R TYPE INSTRUCTIONS
                //ADD INSTI  (0000000 01001 01000 000 00110 0110011) x8+x9=x6
                mem[3] = 8'h00;
                mem[2] = 8'h94;
                mem[1] = 8'h03;
                mem[0] = 8'h33;

                // SUB INSTI  (0100000 01001 01000 000 00110 0110011) x8-x9=x6
                mem[7] = 8'h40;
                mem[6] = 8'h94;
                mem[5] = 8'h03;
                mem[4] = 8'h33;

                // XOR INSTI (0000000 01001 01000 100 00110 0110011) x8^x9=x6
                mem[11] = 8'h00;
                mem[10] = 8'h94;
                mem[9] = 8'h43;
                mem[8] = 8'h33;

                // OR INSTI  (0000000 01001 01000 110 00110 0110011) x8|x9=x6
                mem[15] = 8'h00;
                mem[14] = 8'h94;
                mem[13] = 8'h63;
                mem[12] = 8'h33;

                // AND INSTI (0000000 01001 01000 111 00110 0110011) x8&x9=x6
                mem[19] = 8'h00;
                mem[18] = 8'h94;
                mem[17] = 8'h73;
                mem[16] = 8'h33;

                // SLT INSTI  (0000000 01001 01000 010 00110 0110011) x8<x9?x6=1:x6=0
                mem[23] = 8'h00;
                mem[22] = 8'h94;
                mem[21] = 8'h23;
                mem[20] = 8'h33;

                //I TYPE INSTRUCTIONS

                // ADDI1 INSTI (000000000001 01000 000 00110 0010011) x8+1=x6
                mem[27] = 8'h00;
                mem[26] = 8'h14;
                mem[25] = 8'h03;
                mem[24] = 8'h13;

                // SLTI INSTI (000000000001 01000 001 00110 0010011) x8<1?x6=1:x6=0
                mem[31] = 8'h00;
                mem[30] = 8'h14;
                mem[29] = 8'h13;
                mem[28] = 8'h13;

                //XORI INSTI (000000000001 01000 100 00110 0010011) x8^1=x6
                mem[35] = 8'h00;
                mem[34] = 8'h14;
                mem[33] = 8'h43;
                mem[32] = 8'h13;

                // BTYPE INSTRUCTIONS

                //BEQ INSTI (0 000000 01001 01000 000 0001 0 1100011) if(x8==x9) PC=PC+4+2*2
                mem[39] = 8'h00;
                mem[38] = 8'h94;   
                mem[37] = 8'h01;
                mem[36] = 8'h63;

                // MEMORY INSTRUCTIONS

                // LW INSTI (000000000100 01000 010 00110 0000011) x6 = mem[x8 + 4]
                mem[43] = 8'h00;
                mem[42] = 8'h44;
                mem[41] = 8'h23;
                mem[40] = 8'h03;

                // SW INSTI (0000000 01001 01000 010 01000 0100011) mem[x8 + 8] = x9
                mem[47] = 8'h00;
                mem[46] = 8'h94;
                mem[45] = 8'h24;
                mem[44] = 8'h23;

                //JAL x0, -8 (111111111000 00000 000 00000 1101111) PC=PC-8 (we used this for fibonacci)
                mem[48] = 8'h6F;
                mem[49] = 8'hF0;
                mem[50] = 8'h9F;
                mem[51] = 8'hFF;
    
    end


endmodule