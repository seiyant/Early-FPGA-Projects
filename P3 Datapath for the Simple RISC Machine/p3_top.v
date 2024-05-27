module p3_top (datapath_in, writenum, readnum, write, clk, loada, loadb, loadc, asel, bsel, vsel, shift, ALUop, datapath_out, Z_out);
    // Input and output port declarations
    input [15:0] datapath_in;
    input [2:0] writenum, readnum;
    input write, clk, loada, loadb, loadc, loads, asel, bsel, vsel;
    input [1:0] shift, ALUop;
    output [15:0] datapath_out;
    output Z_out;

    // Instantiate datapath
    p3_datapath DATAPATH (
        .datapath_in(datapath_in),
        .writenum(writenum),
        .readnum(readnum),
        .write(write),
        .clk(clk),
        .loada(loada),
        .loadb(loadb),
        .loadc(loadc),
        .loads(loads),
        .asel(asel),
        .bsel(bsel),
        .vsel(vsel),
        .shift(shift),
        .ALUop(ALUop),
        .datapath_out(datapath_out),
        .Z_out(Z_out)
    );
endmodule