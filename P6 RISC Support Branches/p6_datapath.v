module p6_datapath (datapath_in, mdata, sximm5, sximm8, PC, writenum, readnum, write, clk, loada, loadb, loadc, loads, asel, bsel, vsel, shift, ALUop, datapath_out, N_out, V_out, Z_out);
    // Input and output port declarations
    input [15:0] datapath_in, mdata, sximm5, sximm8, PC;
    input [2:0] writenum, readnum;
    input write, clk, loada, loadb, loadc, loads, asel, bsel;
    input [1:0] vsel; // Modified to 2 bits for more selection options
    input [1:0] shift, ALUop;
    output [15:0] datapath_out;
    output N_out, V_out, Z_out;

    // Internal wire declarations
    wire [15:0] data_in, data_out;
    wire [15:0] A, B, C;
    wire [15:0] Ain, Bin, sout, ALUout;
    wire N, V, Z;

    // Register file to store and retrieve values
    p6_regfile REGFILE (
        .data_in(data_in),
        .writenum(writenum),
        .readnum(readnum),
        .write(write),
        .clk(clk),
        .data_out(data_out)
    );

    // Data input multiplexer with PC and immediate options
    assign data_in = (vsel == 2'b00) ? datapath_in :
                     (vsel == 2'b01) ? sximm8 :
                     (vsel == 2'b10) ? mdata : // Memory data
                     PC; // For function calls (BL) and returns (BX)

    // Pipeline register A
    reg [15:0] A_reg;
    always @(posedge clk) begin
        if (loada) A_reg <= data_out;
    end
    assign A = A_reg;

    // Pipeline register B
    reg [15:0] B_reg;
    always @(posedge clk) begin
        if (loadb) B_reg <= data_out;
    end
    assign B = B_reg;

    // Shifter unit
    p6_shifter SHIFTER (
        .in(B),
        .shift(shift),
        .sout(sout)
    );

    // ALU for arithmetic and comparison operations
    p6_alu ALU (
        .Ain(Ain),
        .Bin(Bin),
        .ALUop(ALUop),
        .out(ALUout),
        .N(N),
        .V(V),
        .Z(Z)
    );

    // Pipeline register C to store ALU results
    reg [15:0] C_reg;
    always @(posedge clk) begin
        if (loadc) C_reg <= ALUout;
    end
    assign C = C_reg;

    // Status register to store flags (N, V, Z)
    reg Z_reg, N_reg, V_reg;
    always @(posedge clk) begin
        if (loads) begin
            Z_reg <= Z;
            N_reg <= N;
            V_reg <= V;
        end
    end

    // Outputs
    assign datapath_out = C;
    assign Z_out = Z_reg;
    assign N_out = N_reg;
    assign V_out = V_reg;

    // Multiplexers for selecting source operands to the ALU
    assign Ain = asel ? 16'b0 : A;       // Select 0 or register A
    assign Bin = bsel ? sximm5 : sout;   // Select immediate or shifted register B
endmodule