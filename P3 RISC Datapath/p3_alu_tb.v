module p3_alu_tb();
    reg [15:0] Ain, Bin;
    reg [1:0] ALUop;
    wire [15:0] out;
    wire Z;

    p3_alu dut (
        .Ain(Ain),
        .Bin(Bin),
        .ALUop(ALUop),
        .out(out),
        .Z(Z)
    );

    initial begin
        // Reset procedure
        Ain = 16'b0;
        Bin = 16'b0;
        ALUop = 2'b0;

        // Test combination: 5 + 10
        Ain = 16'h5;
        Bin = 16'hA;
        ALUop = 2'b0;
        #10; // Check waveform

        // Test combination: 15 - 5
        Ain = 16'hF;
        Bin = 16'h5;
        ALUop = 2'b1;
        #10; // Check waveform
        
        // Test combination: 0100 1011 0110 1101 & 0011 1000 0010 1111
        Ain = 16'h4B6D;
        Bin = 16'h382F;
        ALUop = 2'b10;
        #10; // Check waveform

        // Test combination: ~1001 0000 1000 1110
        Ain = 16'h0000; // Ain not used
        Bin = 16'h908E;
        ALUop = 2'b11;
        #10; // Check waveform

        $finish; // End the simulation
    end
endmodule