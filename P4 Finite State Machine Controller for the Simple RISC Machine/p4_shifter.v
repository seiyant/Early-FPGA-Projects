module p4_shifter (in, shift, sout);
    // Input and output port declarations
    input [15:0] in;
    input [1:0] shift;
    output reg [15:0] sout;

    // Operator combinational logic
    always @(*) begin
        case (shift)
            2'b00: sout = in;                   
            2'b01: sout = in << 1;            // 1-bit shift left
            2'b10: sout = in >> 1;            // 1-bit shift right
            2'b11: sout = {in[15], in[15:1]}; // 1-bit arithmetic shift right
            default: sout = in;
        endcase
    end

endmodule