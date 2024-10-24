`define WAIT      3'b000
`define GETA      3'b001
`define GETB      3'b010
`define ADD       3'b011
`define WRITE_REG 3'b100
`define DECODE    3'b101

module p4_cpu (clk, reset, s, load, in, out, N, V, Z, w);
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

    // Finite state machine
    reg [2:0] state, next_state;
    always @(posedge clk or posedge reset) begin
        if (reset) state <= `WAIT;
        else state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            `WAIT: next_state = s ? `DECODE : `WAIT;
            //Move to Get A if opcode is 110
            `DECODE: next_state = (instruction[15:13] == 3'b110) ? `GETA : `GETB; 
            `GETA: next_state = `GETB;
            `GETB: next_state = `ADD;
            `ADD: next_state = `WRITE_REG;
            `WRITE_REG: next_state = `WAIT;
            default: next_state = `WAIT;
        endcase
    end

    // Control signals for datapath, ALU, and registers
    reg loada, loadb, loadc, asel, bsel, vsel, loads, write;
    reg [1:0] shift, ALUop;
    reg [2:0] writenum, readnum;

    always @(*) begin
        // Define default values
        loada = 0; loadb = 0; loadc = 0; asel = 0; bsel = 0;
        vsel = 0; loads = 0; write = 0; shift = 2'b00; ALUop = 2'b00;
        writenum = 3'b000; readnum = 3'b000;
        // Change signals based on current state
        case (state)
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
    p4_datapath DP (
        .datapath_in(in),
        .mdata(16'b0), //Placeholder for memory data input, not in use
        .sximm8({{8{instruction[7]}}, instruction[7:0]}),  //Sign-extended 8-bit immediate value
        .PC(16'b0), //Placeholder for program counter, not in use
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
