`timescale 1ns/1ps

module p4_cpu_tb;

    // Inputs
    reg clk;
    reg reset;
    reg s;
    reg load;
    reg [15:0] in;

    // Outputs
    wire [15:0] out;
    wire N;
    wire V;
    wire Z;
    wire w;

    // Instantiate the CPU module
    p4_cpu uut (
        .clk(clk),
        .reset(reset),
        .s(s),
        .load(load),
        .in(in),
        .out(out),
        .N(N),
        .V(V),
        .Z(Z),
        .w(w)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        reset = 1;
        s = 0;
        load = 0;
        in = 16'b0;

        // Wait for global reset to finish
        #10;
        reset = 0;

        // Test Case 1: Load an ADD instruction
        // ADD R0, R1, R2 (R0 = R1 + R2)
        // Assuming the instruction format is [opcode][Rn][Rd][Rm]
        load = 1;
        in = 16'b1100001000010010; // Example instruction encoding
        #10;
        load = 0;
        s = 1; // Start the CPU

        // Wait for the CPU to process the instruction
        #50;
        s = 0;

        // Test Case 2: Load a MOV instruction
        // MOV R3, #10 (R3 = 10)
        load = 1;
        in = 16'b1110001100001010; // Example instruction encoding
        #10;
        load = 0;
        s = 1; // Start the CPU

        // Wait for the CPU to process the instruction
        #50;
        s = 0;

        // Test Case 3: Load a CMP instruction
        // CMP R4, R5 (Set flags based on R4 - R5)
        load = 1;
        in = 16'b1011001001000101; // Example instruction encoding
        #10;
        load = 0;
        s = 1; // Start the CPU

        // Wait for the CPU to process the instruction
        #50;
        s = 0;

        // Add more test cases as needed...

        // Finish simulation
        $stop;
    end

endmodule