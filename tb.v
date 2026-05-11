`timescale 1ns/1ps

module top_tb();

    // Reg File Signals
    reg clk;
    reg rst;
    reg [4:0] read_reg_num1;
    reg [4:0] read_reg_num2;
    reg [4:0] write_reg_num1;
    reg [31:0] write_data_dm;
    reg lb, lui_control, jump, sw;
    reg [31:0] lui_imm_val;

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [4:0] read_data_addr_dm;
    wire [31:0] data_out_2_dm;

    // ALU Signals
    reg [5:0] alu_control;
    reg [31:0] imm;
    wire [31:0] alu_result;

    // Instantiate Register File
    reg_file rf_inst (
        .clk(clk), .rst(rst),
        .read_reg_num1(read_reg_num1), // Matches your port name 'read_reg_um1'
        .read_reg_num2(read_reg_num2),
        .write_reg_num1(write_reg_num1),
        .write_data_dm(write_data_dm),
        .lb(lb), .lui_control(lui_control), .lui_imm_val(lui_imm_val),
        .jump(jump), .sw(sw),
        .read_data1(read_data1), .read_data2(read_data2),
        .read_data_addr_dm(read_data_addr_dm), .data_out_2_dm(data_out_2_dm)
    );

    // Instantiate ALU
    // We connect RF outputs directly to ALU inputs for testing
    alu alu_inst (
        .sr1(read_data1),
        .sr2(read_data2),
        .alu_control(alu_control),
        .imm(imm),
        .alu_result(alu_result)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        // --- Initialization ---
        clk = 0;
        rst = 1;
        lb = 0; lui_control = 0; jump = 0; sw = 0;
        read_reg_num1 = 0; read_reg_num2 = 0; 
        write_reg_num1 = 0; write_data_dm = 0;
        lui_imm_val = 0; alu_control = 0; imm = 0;

        #15 rst = 0; // Release reset
        
        // --- Test Case 1: LUI (Load Upper Immediate) ---
        // Load 0xABCD0000 into Register 5
        @(posedge clk);
        lui_control = 1;
        write_reg_num1 = 5;
        lui_imm_val = 32'hABCD0000;
        
        @(posedge clk);
        lui_control = 0;
        $display("TC1: LUI - Reg[5] loaded with %h", rf_inst.reg_mem[5]);

        // --- Test Case 2: LB (Load Word/Byte Simulation) ---
        // Load value 50 into Register 6
        @(posedge clk);
        lb = 1;
        write_reg_num1 = 6;
        write_data_dm = 32'd50;
        
        @(posedge clk);
        lb = 0;
        $display("TC2: LB - Reg[6] loaded with %d", rf_inst.reg_mem[6]);

        // --- Test Case 3: R-Type ALU Op (ADD) ---
        // Add Reg[5] + Reg[6] (0xABCD0000 + 50)
        @(posedge clk);
        read_reg_num1 = 5;
        read_reg_num2 = 6;
        alu_control = 6'b000001; // ADD
        
        #2; // Wait for combinational logic
        $display("TC3: ADD - %h + %d = %h", read_data1, read_data2, alu_result);

        // --- Test Case 4: I-Type ALU Op (ADDI) ---
        // Reg[6] + Immediate (50 + 100)
        @(posedge clk);
        read_reg_num1 = 6;
        imm = 32'd100;
        alu_control = 6'b001011; // ADDI
        
        #2;
        $display("TC4: ADDI - %d + %d = %d", read_data1, imm, alu_result);

        // --- Test Case 5: SW (Store Word) Simulation ---
        // Move Reg[5] value to data_out_2_dm
        @(posedge clk);
        sw = 1;
        read_reg_num1 = 5;
        
        @(posedge clk);
        sw = 0;
        $display("TC5: SW - Data Out to Memory: %h", data_out_2_dm);

        #20;
        $finish;
    end

endmodule








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






`timescale 1ns/1ps


module reg_file(
    input clk,rst,
    input [4:0] read_reg_num1, // address for reading from register 1
    input [4:0] read_reg_num2, // address for reading from register 2
    input [4:0] write_reg_num1, //address for writing into reg
    input [31:0] write_data_dm, //data from memory
    input lb,
    input lui_control,
    input [31:0] lui_imm_val,
    input jump,
    input sw,

    output [31:0] read_data1, // read data output1
    output [31:0] read_data2, // read data output2
    output [4:0] read_data_addr_dm, // read address for fetching data from the data memory
    output reg [31:0] data_out_2_dm
);


reg [31:0] reg_mem [31:0];
wire [31:0] wtie_reg_dm; // address for load instructions

assign read_data_addr_dm = write_reg_num1;
assign write_reg_dm = write_reg_num1;

integer i;

always@(posedge clk)
begin
    
    if(rst)
        begin
            for(i=0 ; i<32 ; i++)
                reg_mem[i]<=i;
                data_out_2_dm = 0;
        end

    else
        begin      
            if(lb)
                begin
                    reg_mem[write_reg_num1] <= write_data_dm;
                end

            else if(sw)
                begin
                    data_out_2_dm <= reg_mem[read_reg_num1];
                end

            else if(lui_control)
                begin
                    reg_mem[write_reg_num1] <= lui_imm_val;
                end
        end

end

assign read_data1 = reg_mem[read_reg_num1];
assign read_data2 = reg_mem[read_reg_num2];



endmodule


