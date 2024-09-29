`define GETA      4'b0001
`define GETB      4'b0010
`define ADD       4'b0011
`define WRITE_REG 4'b0100
`define DECODE    4'b0101
`define RESET     4'b0110
`define IF1       4'b0111
`define IF2       4'b1000
`define UPDATE_PC 4'b1001

module p6_cpu (clk, reset, s, load, in, out, N, V, Z, w);
    // Input and output port declarations
    input clk, reset, s, load;
    input [15:0] in;
    output [15:0] out;
    output N, V, Z, w;

    // Instruction register
    reg [15:0] instruction;
    always @(posedge clk) begin
        if (reset) instruction <= 16'b0;
        else if (load) instruction <= in;
    end

    // Program Counter (PC)
    reg [7:0] pc; // 8-bit program counter
    always @(posedge clk or posedge reset) begin
        if (reset) pc <= 8'b0; // Reset PC
        else if (load_pc) pc <= pc + 1; // Increment PC
    end

    // Finite state machine
    reg [3:0] state, next_state;
    always @(posedge clk or posedge reset) begin
        if (reset) state <= `RESET;
        else state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            `RESET: next_state = `IF1;
            `IF1: next_state = `IF2;
            `IF2: next_state = `UPDATE_PC;
            `UPDATE_PC: next_state = s ? `DECODE : `WAIT;
            // Move to Get A if opcode is 110
            `DECODE: next_state = (instruction[15:13] == 3'b110) ? `GETA : `GETB; 
            `GETA: next_state = `GETB;
            `GETB: next_state = `ADD;
            `ADD: next_state = `WRITE_REG;
            `WRITE_REG: next_state = `IF1;
            default: next_state = `RESET;
        endcase
    end

    // Control signals for datapath, ALU, and registers
    reg loada, loadb, loadc, asel, bsel, vsel, loads, write, load_pc, load_ir;
    reg [1:0] shift, ALUop;
    reg [2:0] writenum, readnum;

    always @(*) begin
        //Define default values
        loada = 0; loadb = 0; loadc = 0; asel = 0; bsel = 0;
        vsel = 0; loads = 0; write = 0; load_pc = 0; load_ir = 0; shift = 2'b00; ALUop = 2'b00;
        writenum = 3'b000; readnum = 3'b000;
        //Change signals based on current state
        case (state)
            `RESET: begin
                load_pc = 1;
            end
            `IF1: begin
                // Send PC value to memory address input, request memory read (to be defined)
            end
            `IF2: begin
                load_ir = 1;
            end
            `UPDATE_PC: begin
                load_pc = 1;
            end
            `GETA: begin
                loada = 1;
                // Set readnum to Rn field
                readnum = instruction[10:8];
            end
            `GETB: begin
                loadb = 1;
                // Set readnum to Rm field
                readnum = instruction[7:5];
            end
            `ADD: begin
                // Select register A for ALU Ain
                asel = 0;
                // Select register B for ALU Bin
                bsel = 0;
                // Set ALU operation to ADD
                ALUop = 2'b00;
                // Load results to register C
                loadc = 1;
                // Load status register
                loads = 1;
            end
            `WRITE_REG: begin
                // Set writenum to Rd field
                writenum = instruction[4:2];
                // Select ALU result for writeback
                vsel = 0;
                // Enable write to register file
                write = 1;
            end
        endcase
    end

    // Instantiate datapath
    p6_datapath DP (
        .datapath_in(in),
        .mdata(16'b0), 
        .sximm8({{8{instruction[7]}}, instruction[7:0]}),
        .PC(16'b0),
        .sximm5({{11{instruction[4]}}, instruction[4:0]}), //Sign-extended 5-bit immediate value
        .writenum(writenum),
        .readnum(readnum),
        .write(write),
        .clk(clk),
        .loada(loada),
        .loadb(loadb),
        .loadc(loadc),
        .asel(asel),
        .bsel(bsel),
        .vsel(vsel),
        .loads(loads),
        .shift(shift),
        .ALUop(ALUop),
        .datapath_out(out), 
        .Z_out(Z),
        .N_out(N),
        .V_out(V)
    );

    // Flag for waiting
    assign w = (state == `WAIT);
endmodule