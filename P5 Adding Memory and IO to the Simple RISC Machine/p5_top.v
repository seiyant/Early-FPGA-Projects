module p5_top (
    input [3:0] KEY,               // 4-bit input from the DE1-SoC keys
    input [9:0] SW,                // 10-bit input from the DE1-SoC switches
    output [9:0] LEDR,             // 10-bit output to the DE1-SoC red LEDs
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 // 7-segment displays
);

    wire clk = KEY[0];             // Assign KEY[0] to clk
    wire reset = KEY[1];           // Assign KEY[1] to reset
    wire s = KEY[2];               // Assign KEY[2] to start signal
    wire load = KEY[3];            // Assign KEY[3] to load signal
    wire [15:0] instruction;       // Wire to hold the instruction fetched from memory
    wire [15:0] cpu_out;           // Wire to hold the output from the CPU
    wire N, V, Z, w;               // Wires for the status flags from the CPU

    // Instantiate RAM
    RAM MEM (
        .clk(clk),                 // Connect clk to the RAM module
        .address(cpu_out[7:0]),    // Connect lower 8 bits of cpu_out to the RAM address
        .data_in(16'b0),           // Data input to RAM, not used in this stage
        .we(1'b0),                 // Write enable signal, set to 0 as we are not writing in this stage
        .data_out(instruction)     // Connect instruction output from RAM to the CPU
    );

    // Instantiate CPU
    p5_cpu CPU (
        .clk(clk),                 // Connect clk to the CPU
        .reset(reset),             // Connect reset to the CPU
        .s(s),                     // Connect start signal to the CPU
        .load(load),               // Connect load signal to the CPU
        .in(instruction),          // Connect instruction input to the CPU
        .out(cpu_out),             // Connect output from the CPU
        .N(N),                     // Connect negative flag output from the CPU
        .V(V),                     // Connect overflow flag output from the CPU
        .Z(Z),                     // Connect zero flag output from the CPU
        .w(w)                      // Connect waiting flag output from the CPU
    );

    // Display outputs on LEDs
    assign LEDR[9:0] = cpu_out[9:0]; // Assign lower 10 bits of cpu_out to the red LEDs
    // (You can add additional display logic for HEX displays if needed)

endmodule