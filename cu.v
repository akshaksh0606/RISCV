`timescale 1ns/1ps

module cu ( 
    input reset,
    input [6:0] opcode,
    input [2:0] dunct3,
    input [6:0] funct7,
    output [5:0] alu_contol
);

always @(reset)
begin
    if(reset)
    alu_control <= 0;
end

always @(*)
begin
    if(opcode== 7'b0110011)
    begin

       case(funct3)
            3'b000 : alu_control <= (funct7 == 7'b0000000) ? 6'b000001 : 6'b000000;  //ADD OR SUB
            3'b100 : alu_control <= 6'b000110; //XOR
            3'b110 : alu_control <= 6'b001001; //OR    
            3'b111 : alu_control <= 6'b001010; //AND  
            3'b010 : alu_control <= 6'b000100; //SLT
       endcase

    end
end




endmodule