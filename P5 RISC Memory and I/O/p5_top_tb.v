`timescale 1ns/1ps

module p5_top_tb;

    // Inputs to the top module (mimicking the DE1-SoC switches and keys)
    reg [3:0] KEY;
    reg [9:0] SW;

    // Outputs from the top module (mimicking LEDs and HEX displays)
    wire [9:0] LEDR;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // Instantiate the top-level module
    p5_top uut (
        .KEY(KEY),
        .SW(SW),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    // Clock generation
    initial begin
        KEY[0] = 0; 
        forever #5 KEY[0] = ~KEY[0];
    end

    // Test sequence
    initial begin
        // Initialize inputs
        KEY[1] = 1; 
        KEY[2] = 0;  
        KEY[3] = 0; 
        SW = 10'b0; 

        #20;
        KEY[1] = 0;

        // Test Case 1: Load and execute an instruction
        KEY[3] = 1;
        #10;
        KEY[3] = 0; 

        // Start the CPU to execute the instruction
        KEY[2] = 1;
        #10;
        KEY[2] = 0; 
        #200;

        // Test Case 2: Toggle switches to verify memory-mapped I/O
        SW = 10'b1111111111;
        #50;
        SW = 10'b0000000000;
        #50;

        // Test Case 3: Reset CPU mid-execution
        KEY[1] = 1;
        #10;
        KEY[1] = 0;
        #100;

        $stop;
    end

endmodule