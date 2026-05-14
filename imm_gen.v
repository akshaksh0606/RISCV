`timescale 1ns/1ps


module imm_gen(
    input [31:0] instruction,
    output reg [31:0] imm_out
);

 
always @(*) 
begin
    case(instruction[6:0])
        7'b0010011: //I TYPE
            imm_out = {{20{instruction[31]}}, instruction[31:20]}; // sign-extend the immediate
        7'b1100011: //B TYPE
            imm_out = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // sign-extend and rearrange for branch offset
        7'b0000011: //I TYPE (LW)
            imm_out = {{20{instruction[31]}}, instruction[31:20]}; // same as arithmetic I-type
        7'b0100011: //S TYPE (SW)
         imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // imm[11:5] = inst[31:25],  imm[4:0] = inst[11:7]
        7'b1101111: // J-TYPE (JAL)
            imm_out = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // sign-extend and rearrange for jump offset
        default:
            imm_out = 32'b0; // default case
    endcase
end



endmodule