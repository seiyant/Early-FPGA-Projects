module p6_top (KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    // Input and output port declarations
    input [3:0] KEY,
    input [9:0] SW,
    output [9:0] LEDR,
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5

    // Internal wire declarations
    wire clk = KEY[0]; // Clock from KEY[0]
    wire reset = KEY[1]; // Reset from KEY[1]
    wire s = KEY[2]; // Step signal from KEY[2]
    wire load = KEY[3]; // Load instruction into CPU
    wire [15:0] instruction; // Instruction fetched from RAM
    wire [15:0] cpu_out; // Output from CPU (ALU result or PC value)
    wire [15:0] ram_out; // Data read from RAM
    wire [15:0] ram_in; // Data to write into RAM
    wire N, V, Z, w; // CPU status flags and wait flag
    wire we; // Write enable signal for RAM

    // Use switches to provide input data to RAM (if needed)
    assign ram_in = {6'b0, SW[9:0]}; // Example: use 10-bit switch input

    // Instantiate RAM (with read/write capability)
    p6_ram MEM (
        .clk(clk),
        .address(cpu_out[7:0]), // Address from CPU output (lower 8 bits)
        .data_in(ram_in), // Data input for writing to RAM
        .we(we), // Write enable signal
        .data_out(ram_out) // Data read from RAM
    );

    // Instantiate CPU
    p6_cpu CPU (
        .clk(clk),
        .reset(reset),
        .s(s),
        .load(load),
        .in(ram_out), // Instruction from RAM
        .out(cpu_out), // CPU output (PC or ALU result)
        .N(N), // Negative flag
        .V(V), // Overflow flag
        .Z(Z), // Zero flag
        .w(w) // Wait flag
    );

    // Display CPU output on LEDs
    assign LEDR[9:0] = cpu_out[9:0];

    // Write enable logic
    assign we = SW[0]; 
endmodule