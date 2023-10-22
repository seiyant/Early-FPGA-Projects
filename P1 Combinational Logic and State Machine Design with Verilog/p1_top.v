// Define symbolic names for clarity
//        ---- HEX0 ----
//        HEX5      HEX1
//        ---- HEX6 ----
//        HEX4      HEX2
//        ---- HEX3 ----
`define hex_0 7'b1000000 // Acts as both O and 0
`define hex_1 7'b1111001
`define hex_2 7'b0100100
`define hex_3 7'b0110000
`define hex_4 7'b0011001
`define hex_5 7'b0010010 // Acts as both S and 5
`define hex_6 7'b0000010
`define hex_7 7'b1111000
`define hex_8 7'b0000000
`define hex_9 7'b0010000
`define hex_P 7'b0001100
`define hex_E 7'b0000110
`define hex_n 7'b0101011
`define hex_C 7'b1000110
`define hex_L 7'b1001110
`define hex_d 7'b0100001
`define hex_r 7'b1001110

module p1_top(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
    // Input and output port declarations
    input [9:0] SW; 
    input [3:0] KEY;
    output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    output reg [9:0] LEDR;

    // Clock and reset derived from KEY inputs
    wire clk = ~KEY[0];
    wire reset = ~KEY[3];

    // State register
    reg [3:0] present_state;

    // Wire for the binary input
    wire [3:0] binary_input;
    assign binary_input = SW[3:0];

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            present_state = 4'd0;
        end
        else begin 
            case (present_state)
                // States transition for correct input
                4'd0: present_state = (binary_input == 4'd8) ? 4'd1 : 4'd7;
                4'd1: present_state = (binary_input == 4'd3) ? 4'd2 : 4'd8; 
                4'd2: present_state = (binary_input == 4'd8) ? 4'd3 : 4'd9;
                4'd3: present_state = (binary_input == 4'd4) ? 4'd4 : 4'd10;
                4'd4: present_state = (binary_input == 4'd8) ? 4'd5 : 4'd11;
                4'd5: present_state = (binary_input == 4'd2) ? 4'd6 : 4'd12;
                // Correct input self-loop
                4'd6: present_state = 4'd6; 
                // State transition for incorrect input
                4'd7: present_state = 4'd8;
                4'd8: present_state = 4'd9;
                4'd9: present_state = 4'd10;
                4'd10: present_state = 4'd11;
                4'd11: present_state = 4'd12;
                // Incorrect input self-loop
                4'd12: present_state = 4'd12;
                default: present_state = 4'd0;
            endcase
        end
    end

    // 7-segment display logic
    always @(*) begin
        case (present_state)
            // Display "0PEn" after correct combination
            4'd6: begin
                HEX0 = `hex_n;
                HEX1 = `hex_E;
                HEX2 = `hex_P;
                HEX3 = `hex_0; HEX4 = 7'b1111111; HEX5 = 7'b1111111; 
            end
            // Display "CL05Ed" after correct combination
            4'd12: begin
                HEX0 = `hex_d;
                HEX1 = `hex_E;
                HEX2 = `hex_5;
                HEX3 = `hex_0;
                HEX4 = `hex_L;
                HEX5 = `hex_C;
            end
            // Display each input as a decimal
            default: begin
                case (binary_input)
                    4'b0000: begin 
                        HEX0 = `hex_0; HEX1 = 7'b1111111; HEX2 = 7'b1111111; HEX3 = 7'b1111111; HEX4 = 7'b1111111; HEX5 = 7'b1111111;
                    end
                    4'b0001: begin 
                        HEX0 = `hex_1; HEX1 = 7'b1111111; HEX2 = 7'b1111111; HEX3 = 7'b1111111; HEX4 = 7'b1111111; HEX5 = 7'b1111111;
                    end
                    4'b0010: begin 
                        HEX0 = `hex_2; HEX1 = 7'b1111111; HEX2 = 7'b1111111; HEX3 = 7'b1111111; HEX4 = 7'b1111111; HEX5 = 7'b1111111;
                    end
                    4'b0011: begin 
                        HEX0 = `hex_3; HEX1 = 7'b1111111; HEX2 = 7'b1111111; HEX3 = 7'b1111111; HEX4 = 7'b1111111; HEX5 = 7'b1111111;
                    end
                    4'b0100: begin 
                        HEX0 = `hex_4; HEX1 = 7'b1111111; HEX2 = 7'b1111111; HEX3 = 7'b1111111; HEX4 = 7'b1111111; HEX5 = 7'b1111111;
                    end
                    4'b0101: begin 
                        HEX0 = `hex_5; HEX1 = 7'b1111111; HEX2 = 7'b1111111; HEX3 = 7'b1111111; HEX4 = 7'b1111111; HEX5 = 7'b1111111;
                    end
                    4'b0110: begin 
                        HEX0 = `hex_6; HEX1 = 7'b1111111; HEX2 = 7'b1111111; HEX3 = 7'b1111111; HEX4 = 7'b1111111; HEX5 = 7'b1111111;
                    end
                    4'b0111: begin 
                        HEX0 = `hex_7; HEX1 = 7'b1111111; HEX2 = 7'b1111111; HEX3 = 7'b1111111; HEX4 = 7'b1111111; HEX5 = 7'b1111111;
                    end
                    4'b1000: begin 
                        HEX0 = `hex_8; HEX1 = 7'b1111111; HEX2 = 7'b1111111; HEX3 = 7'b1111111; HEX4 = 7'b1111111; HEX5 = 7'b1111111;
                    end
                    4'b1001: begin 
                        HEX0 = `hex_9; HEX1 = 7'b1111111; HEX2 = 7'b1111111; HEX3 = 7'b1111111; HEX4 = 7'b1111111; HEX5 = 7'b1111111;
                    end
                    // Display "Err0r" for inputs greater than 4'b1001
                    default: begin
                        HEX0 = `hex_r;
                        HEX1 = `hex_0;
                        HEX2 = `hex_r;
                        HEX3 = `hex_r;
                        HEX4 = `hex_E; HEX5 = 7'b1111111; 
                    end
                endcase
            end
        endcase
    end

    // LED display logic
    always @(*) begin
        LEDR[0] = SW[0] ? 1'b1 : 1'b0;
        LEDR[1] = SW[1] ? 1'b1 : 1'b0;
        LEDR[2] = SW[2] ? 1'b1 : 1'b0;
        LEDR[3] = SW[3] ? 1'b1 : 1'b0;
        LEDR[4] = SW[4] ? 1'b1 : 1'b0;
        LEDR[5] = SW[5] ? 1'b1 : 1'b0;
        LEDR[6] = SW[6] ? 1'b1 : 1'b0;
        LEDR[7] = SW[7] ? 1'b1 : 1'b0;
        LEDR[8] = SW[8] ? 1'b1 : 1'b0;
        LEDR[9] = SW[9] ? 1'b1 : 1'b0;
    end
endmodule
