module p3_shifter_tb();
    reg [15:0] in;
    reg [1:0] shift;
    wire [15:0] sout;
    
    p3_shifter dut (
        .in(in),
        .shift(shift),
        .sout(sout)
    );

    initial begin
        // Reset procedure
        in = 16'b0;
        shift = 2'b00;

        // Test combination: no shift
        in = 16'h1234;
        shift = 2'b00;
        #10; // Check waveform

        // Test combination: shift left 0001 0010 0011 0100
        in = 16'h1234;
        shift = 2'b01;
        #10; // Check waveform

        // Test combination: shift right 0001 0010 0011 0100
        in = 16'h1234;
        shift = 2'b10;
        #10; // Check waveform

        // Test combination: arithmetic shift right 0001 0010 0011 0100
        in = 16'hF234;
        shift = 2'b11;
        #10; // Check waveform

        $finish; // End the simulation
    end
endmodule