`timescale 1ns/1ps
module cu (  
    input rst,
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [5:0] alu_control,

    output reg reg_write,
    output reg mem_read,    // LW
    output reg mem_write,   // SW
    output reg alu_src,     // 1 = imm, 0 = rs2 
    output reg mem_to_reg   // 1 = write-back from memory, 0 = from ALU
);

always @(*) 
begin
    // default values
    alu_control = 0;
    reg_write   = 0;
    mem_read    = 0;
    mem_write   = 0;
    alu_src     = 0;
    mem_to_reg  = 0;

    if (rst) 
    begin
        alu_control = 0;
        reg_write   = 0;
        mem_read    = 0;
        mem_write   = 0;
        alu_src     = 0;
        mem_to_reg  = 0;
    end 
    else 
    begin
        if (opcode == 7'b0110011) begin  // R-TYPE
            reg_write = 1;
            case (funct3)
                3'b000 : alu_control = (funct7 == 7'b0000000) ? 6'b000001 : 6'b000010; // ADD/SUB
                3'b100 : alu_control = 6'b000110; // XOR
                3'b110 : alu_control = 6'b001001; // OR
                3'b111 : alu_control = 6'b001010; // AND
                3'b010 : alu_control = 6'b000100; // SLT
            endcase
        end

        if (opcode == 7'b0010011) begin  // I-TYPE
            reg_write = 1;
            case (funct3)
                3'b000 : alu_control = 6'b001011; // ADDI
                3'b100 : alu_control = 6'b001101; // XORI
                3'b001 : alu_control = 6'b001100; // SLTI
            endcase
        end

        if (opcode == 7'b1100011) begin  // B-TYPE
            alu_control = 6'b010000; // BEQ
        end
       
        if (opcode == 7'b0000011) begin  // LW
            reg_write = 1;
            mem_read = 1;
            mem_to_reg = 1;
            alu_src = 1;
            alu_control = 6'b001011; // Use ADDI (sr1 + imm) for address calculation
        end

        if (opcode == 7'b0100011) begin  // SW
            mem_write = 1;
            alu_src = 1;
            alu_control = 6'b001011; // Use ADDI (sr1 + imm) for address calculation
        end
    end
end
endmodule