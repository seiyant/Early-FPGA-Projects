module p5_alu (Ain, Bin, ALUop, out, N, V, Z);
    // Input and output port declarations
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output reg [15:0] out;
    output reg N, V, Z;

    // Operator combinational logic
    always @(*) begin
        case (ALUop)
            2'b00: out = Ain + Bin; // Add
            2'b01: out = Ain - Bin; // Subtract
            2'b10: out = Ain & Bin; // And
            2'b11: out = ~Bin;      // Not
            default: out = 16'b0; 
        endcase

        // Flag for negative
        N = out[15];

        // Flag for overflow
        if (ALUop == 2'b00) begin
            V = ((Ain[15] == Bin[15]) && (out[15] != Ain[15])) ? 1'b1 : 1'b0; end 
        else if (ALUop == 2'b01) begin
            V = ((Ain[15] != Bin[15]) && (out[15] != Ain[15])) ? 1'b1 : 1'b0; end 
        else begin
            V = 1'b0;
        end

        // Flag for zero
        Z = (out == 16'b0) ? 1'b1 : 1'b0;
    end
endmodule