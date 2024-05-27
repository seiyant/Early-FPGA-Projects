module p3_regfile (data_in, writenum, readnum, write, clk, data_out);
    // Input and output port declarations
    input [15:0] data_in,
    input [2:0] writenum, readnum,
    input write, clk,
    output reg [15:0] data_out

    // Define 8 16-bits registers
    reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7;

    // Register input sequential logic
    always @(posedge clk) begin
        if (write) begin
            case (writenum)
                3'b000: R0 <= data_in;
                3'b001: R1 <= data_in;
                3'b002: R2 <= data_in;
                3'b003: R3 <= data_in;
                3'b004: R4 <= data_in;
                3'b005: R5 <= data_in;
                3'b006: R6 <= data_in;
                3'b007: R7 <= data_in;
                default: ; // Do nothing
            endcase
        end
    end

    // Register output combinational logic
    always @(*) begin
        case (readnum)
            3'b000: data_out = R0;
            3'b001: data_out = R1;
            3'b002: data_out = R2;
            3'b003: data_out = R3;
            3'b004: data_out = R4;
            3'b005: data_out = R5;
            3'b006: data_out = R6;
            3'b007: data_out = R7;
            default: data_out = 16'b0; // Output 0s
        endcase
    end
endmodule