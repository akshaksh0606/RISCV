

module test_reg_file(
    input clk,rst,
    input [4:0] read_reg_num1, // address for reading from register 1
    input [4:0] read_reg_num2, // address for reading from register 2
    input [4:0] write_reg_num1, //address for writing into reg  
    input [31:0] write_data, // data to be written into register
    input reg_write, // control signal for writing into register

    output [31:0] read_data1, // read data output1
    output [31:0] read_data2 // read data output2
  
);


reg [31:0] reg_mem [31:0];
wire [31:0] write_reg_dm; // address for load instructions


assign write_reg_dm = write_reg_num1;

integer i;

always@(posedge clk)
begin
    
    if(rst)
        begin
            for(i=0 ; i<32 ; i=i+1)
                reg_mem[i]<=32'b0;
        end
    else if(reg_write)
        begin
            reg_mem[write_reg_num1] <= write_data;
        end
end

assign read_data1 = (read_reg_num1 == 0) ? 32'b0 : reg_mem[read_reg_num1];
assign read_data2 = (read_reg_num2 == 0) ? 32'b0 : reg_mem[read_reg_num2];


endmodule