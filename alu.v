`timescale 1ns/1ps


module alu(
    input [31:0] sr1,
    input [31:0] sr2,
    input [5:0] alu_control,
    input [31:0] imm,
    output reg [31:0] alu_result

);

always @ (*) begin

    case (alu_control)

    //R TYPE

    6'b000001: //addition
        alu_result = sr1 + sr2;
    6'b000010: //subtraction
        alu_result = sr1 - sr2;

    // Logical Ops

    6'b000110: //xor
        alu_result = sr1 ^ sr2;
    6'b001001: //or
        alu_result = sr1 | sr2;
    6'b001010: //and
        alu_result = sr1 & sr2;


    // SLT

    6'b000100: 
        alu_result = ($signed(sr1) < $signed(sr2)) ? 32'b1 : 32'b0;

    // shift
    6'b000011: //sll
        alu_result = sr1 << sr2[4:0];
    6'b000111: //srl
        alu_result = sr1 >> sr2[4:0];


    // I TYPE OPERATIONS

    6'b001011: //addi
        alu_result = sr1 + imm;
   6'b001100: //slti
        alu_result = ($signed(sr1) < $signed(imm)) ? 32'b1 : 32'b0;
   6'b001101: //xori
        alu_result = sr1 ^ imm;
    6'b001110: //ori
        alu_result = sr1 | imm;
    6'b001111: //andi
        alu_result = sr1 & imm;


    // B TYPE OPERATIONS

    6'b010000: alu_result = (sr1 == sr2) ? 32'b1 : 32'b0; // BEQ
    6'b010001: alu_result = (sr1 != sr2) ? 32'b1 : 32'b0; // BNE
    6'b010010: alu_result = ($signed(sr1) < $signed(sr2)) ? 32'b1 : 32'b0; // BLT
    6'b010011: alu_result = ($signed(sr1) >= $signed(sr2)) ? 32'b1 : 32'b0; // BGE



    

    default alu_result = 32'b0;

    endcase
    

end



endmodule


