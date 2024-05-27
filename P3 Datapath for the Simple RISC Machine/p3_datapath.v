module p3_datapath (datapath_in, writenum, readnum, write, clk, loada, loadb, loadc, asel, bsel, vsel, shift, ALUop, datapath_out, Z_out);
    // Input and output port declarations
    input [15:0] datapath_in;
    input [2:0] writenum, readnum;
    input write, clk, loada, loadb, loadc, loads, asel, bsel, vsel; 
    input [1:0] shift, ALUop;
    output [15:0] datapath_out;
    output Z_out;

    // Internal wire declarations
    wire [15:0] data_in, data_out;
    wire [15:0] A, B, C;
    wire [15:0] Ain, Bin, sout, ALUout;
    wire Z;

    // Pass through register file
    p3_regfile REGFILE (
        .data_in(data_in),
        .writenum(writenum),
        .readnum(readnum),
        .write(write),
        .clk(clk),
        .data_out(data_out)
    );

    // Pass through pipeline register A
    reg [15:0] A_reg;
    always @(posedge clk) begin
        if (loada) A_reg <= data_out;
    end

    assign A = A_reg;

    // Pass through pipeline register B
    reg [15:0] B_reg;
    always @(posedge clk) begin
        if (loadb) B_reg <= data_out;
    end

    assign B = B_reg;

    // Pass through shifter unit
    p3_shifter SHIFTER (
        .in(B),
        .shift(shift),
        .sout(sout)
    );

    // Pass through arithmetic logic unit
    p3_alu ALU (
        .Ain(Ain),
        .Bin(Bin),
        .ALUop(ALUop),
        .out(ALUout),
        .Z(Z)
    );

    // Pass through pipeline register C
    reg [15:0] C_reg;
    always @(posedge clk) begin
        if (loadc) C_reg <= ALUout;
    end

    assign C = C_reg;

    // Pass through status register
    reg [15:0] status_reg;
    always @(posedge clk) begin
        if (loads) status_reg <= Z;
    end

    // Assign outputs
    assign datapath_out = C;
    assign Z_out = status_reg;

    // Pass through source operand multiplexers
    assign Ain = asel ? 16'b0 : A;
    assign Bin = bsel ? datapath_in : sout;

    // Pass through writeback multiplexer
    assign data_in = vsel ? datapath_in : C;
endmodule