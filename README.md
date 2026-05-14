# RISC-V Single-Cycle Processor
A 32-bit single-cycle RISC-V CPU implemented in Verilog and deployed on the Basys 3 FPGA board. The processor executes a Fibonacci sequence generator in hardware, displaying running results on the onboard 7-segment display and LEDs.

# Features
-32-bit single-cycle datapath following the RISC-V RV32I base integer ISA

-Supports R-type, I-type, B-type, S-type, and J-type instruction formats

-Integrated instruction memory, data memory, and 32-entry register file

-Hardware Fibonacci sequence demo hard-coded into instruction memory

-Basys 3 top-level with clock divider (~1 Hz), 7-segment display driver, and LED output

-Modular design

# Supported Instructions

R Type - ADD, SUB, XOR, OR, AND, SLT

I Type - ADDI, XORI, SLTI, LW

S Type - SW

B Type - BEQ

J Type - JAL


# Module Descriptions
# RISCV_CORE.v
Integrates all submodules into the complete single-cycle datapath. Handles the program counter (PC) logic, including reset, BEQ branching, and JAL jumps.
# alu.v
Combinational ALU supporting ADD, SUB, XOR, OR, AND, SLT (signed), ADDI, XORI, SLTI, and BEQ flag generation. Controlled by a 6-bit alu_control signal from the CU.
# cu.v
Combinational control unit. Decodes opcode, funct3, and funct7 fields to generate alu_control, reg_write, mem_read, mem_write, alu_src, and mem_to_reg signals.
# imm_gen.v
Sign-extends and rearranges immediate fields for I, B, S, and J instruction formats.
# inst_mem.v
100-byte byte-addressable instruction ROM. Two versions exist: fibonacci.v contains a clean Fibonacci-only program; inst_mem.v contains a comprehensive instruction set test sequence (ADD through JAL).
# data_mem.v
256-byte synchronous data memory supporting word-aligned LW (load word) and SW (store word) in little-endian byte order.
# test_reg_file.v
32-entry × 32-bit synchronous register file. Register x0 is hardwired to zero. Supports simultaneous read of two registers and write of one register per cycle.
# seven_seg.v
Time-multiplexed 4-digit 7-segment display driver. Refreshes at ~381 Hz using a 20-bit counter from the 100 MHz clock. Decodes 4-bit hex nibbles to 7-segment patterns.
# TOP.v
Basys 3 top-level wrapper. Instantiates the CPU core and display driver, routes board I/O, and provides the clock divider.

