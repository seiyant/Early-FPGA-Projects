module p6_top (KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    // Input and output port declarations
    input [3:0] KEY,
    input [9:0] SW,
    output [9:0] LEDR,
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5

    // Internal wire declarations
    wire clk = KEY[0];
    wire reset = KEY[1];
    wire s = KEY[2]; 
    wire load = KEY[3];
    wire [15:0] instruction;
    wire [15:0] cpu_out; 
    wire N, V, Z, w;

    // Instantiate RAM
    RAM MEM (
        .clk(clk),
        .address(cpu_out[7:0]),
        .data_in(16'b0),
        .we(1'b0), 
        .data_out(instruction)
    );

    // Instantiate CPU
    p6_cpu CPU (
        .clk(clk),
        .reset(reset),
        .s(s),
        .load(load),
        .in(instruction),
        .out(cpu_out),
        .N(N),
        .V(V),
        .Z(Z),
        .w(w)
    );

    // Display outputs on LEDs
    assign LEDR[9:0] = cpu_out[9:0];
endmodule