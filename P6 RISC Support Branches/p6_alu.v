module p6_alu (Ain, Bin, ALUop, out, N, V, Z);
    // Input and output port declarations
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output reg [15:0] out;
    output reg N, V, Z;

    reg [15:0] result; 

    always @(*) begin
        case (ALUop)
            2'b00: out = Ain + Bin; // Add
            2'b01: begin
                result = Ain - Bin; // Subtract or CMP
                out = result; // For regular subtraction

                // Set flags for CMP or subtraction
                N = result[15]; // Negative flag: MSB of the result

                V = ((Ain[15] != Bin[15]) && (result[15] != Ain[15])) ? 1'b1 : 1'b0; // Overflow: only on subtraction

                Z = (result == 16'b0) ? 1'b1 : 1'b0; // Zero flag: all bits are zero
            end
            2'b10: out = Ain & Bin; // And
            2'b11: out = ~Bin; // Not
            default: out = 16'd0; 
        endcase

        // If not a CMP or subtraction, clear flags for safety
        if (ALUop != 2'b01) begin
            N = 1'b0;
            V = 1'b0;
            Z = (out == 16'b0) ? 1'b1 : 1'b0;
        end
    end
endmodule
