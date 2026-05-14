module basys3_top(
    input clk, btnC,
    output [3:0] an, output [6:0] seg, output [15:0] led
);
    // Clock Divider (100MHz to ~1Hz)
    reg [26:0] clk_div;
    always @(posedge clk) clk_div <= clk_div + 1;
    wire slow_clk = clk_div[26];

    wire [31:0] alu_res;

    RISCV_CORE core (
        .clk(slow_clk), 
        .rst(btnC), 
        .alu_result(alu_res)
    );

    seven_seg display(
        .clk(clk), 
        .data(alu_res[15:0]), 
        .an(an), 
        .seg(seg)
    );

    assign led = alu_res[15:0]; 
endmodule