`timescale 1ns/1ps

module RISCV_CORE(
    input clk,
    input rst,
    output [31:0] alu_result
);
 
wire [31:0] pc_out, instruction, read_data1, read_data2, alu_out,imm;
wire [5:0] alu_control;
wire reg_write,BEQ;
reg [31:0] pc;
wire [31:0] mem_read_data; //LW data from memory
wire mem_read, mem_write, alu_src, mem_to_reg; 
wire [31:0] final_write_data = mem_to_reg ? mem_read_data : alu_out;


// Program Counter
always @(posedge clk or posedge rst) begin
    if(rst) 
        pc <= 0;
    else if (BEQ && (instruction[6:0] == 7'b1100011)) // BEQ
        pc <= pc + imm; 
    else if (instruction[6:0] == 7'b1101111)        // JAL
        pc <= pc + imm;
    else 
        pc <= pc + 4;  
end


// Instruction Memory
inst_mem imem(
    .clk(clk),
    .rst(rst),
    .pc(pc),
    .instruction(instruction)
);

// Cntrol Unit
cu CU(
    .rst(rst),
    .opcode(instruction[6:0]),
    .funct3(instruction[14:12]),
    .funct7(instruction[31:25]),
    .alu_control(alu_control),
    .reg_write(reg_write),
    .mem_read(mem_read),    
    .mem_write(mem_write),  
    .alu_src(alu_src),      
    .mem_to_reg(mem_to_reg) 
);

// Data memory
data_mem DMEM(
    .clk(clk),
    .rst(rst),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .addr(alu_out),
    .write_data(read_data2), // Store rs2
    .read_data(mem_read_data)
);

wire [31:0] alu_input2 = alu_src ? imm : read_data2;

// Register File
test_reg_file RF(
    .clk(clk), 
    .rst(rst), 
    .reg_write(reg_write),
    .read_reg_num1(instruction[19:15]),
    .read_reg_num2(instruction[24:20]),
    .write_reg_num1(instruction[11:7]),
    .write_data(final_write_data), 
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// Immediate Generator
imm_gen IMM(
    .instruction(instruction),
    .imm_out(imm)
);

// Arithmetic Logic Unit
alu ALU(
    .sr1(read_data1),
    .sr2(alu_input2), 
    .alu_control(alu_control),
    .imm(imm),
    .alu_result(alu_out),
    .BEQ(BEQ)
);

assign alu_result = alu_out; // Output ALU result for display/LEDs


endmodule