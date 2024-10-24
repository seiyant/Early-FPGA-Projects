`define GETA      4'b0001
`define GETB      4'b0010
`define ADD       4'b0011
`define WRITE_REG 4'b0100
`define DECODE    4'b0101
`define RESET     4'b0110
`define IF1       4'b0111
`define IF2       4'b1000
`define UPDATE_PC 4'b1001
`define BRANCH    4'b1010
`define CALL      4'b1011
`define RETURN    4'b1100

module p6_cpu (clk, reset, s, load, in, out, N, V, Z, w);
    // Input and output port declarations
    input clk, reset, s, load;
    input [15:0] in;
    output [15:0] out;
    output N, V, Z, w;

    // Instruction register
    reg [15:0] instruction;
    always @(posedge clk) begin
        if (reset) 
            instruction <= 16'b0;
        else if (load) 
            instruction <= in;
    end

    // Program Counter (PC) and address logic
    reg [7:0] pc; // 8-bit program counter
    always @(posedge clk or posedge reset) begin
        if (reset) 
            pc <= 8'b0; // Reset PC
        else if (load_pc) begin
            if (branch_taken) 
                pc <= pc + 1 + sximm8; // Conditional branch offset
            else if (state == `CALL) 
                pc <= pc + 1 + sximm8; // Call (BL) offset
            else if (state == `RETURN) 
                pc <= R7; // Return (BX) to saved address
            else 
                pc <= pc + 1; // Default PC increment
        end
    end

    // RAM instantiation (for instruction/data memory access)
    wire [15:0] ram_out;
    reg [15:0] ram_in;
    reg we; // Write enable signal for RAM

    p6_ram RAM (
        .clk(clk),
        .address(pc),      // Use PC as the address to read/write
        .data_in(ram_in),  // Data to write into RAM
        .we(we),           // Write enable signal
        .data_out(ram_out) // Data read from RAM
    );

    // State machine for control logic
    reg [3:0] state, next_state;
    always @(posedge clk or posedge reset) begin
        if (reset) 
            state <= `RESET;
        else 
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            `RESET: next_state = `IF1;
            `IF1: next_state = `IF2;
            `IF2: next_state = `DECODE;
            `DECODE: begin
                case (instruction[15:12])
                    4'b0010: next_state = `BRANCH; // Branch instructions
                    4'b0101: next_state = `CALL;   // Function call (BL)
                    4'b0100: next_state = `RETURN; // Function return (BX)
                    default: next_state = `GETA;
                endcase
            end
            `GETA: next_state = `GETB;
            `GETB: next_state = `ADD;
            `ADD: next_state = `WRITE_REG;
            `WRITE_REG: next_state = `IF1;
            `BRANCH: next_state = `IF1;
            `CALL: next_state = `IF1;
            `RETURN: next_state = `IF1;
            default: next_state = `RESET;
        endcase
    end

    // Control signals for datapath, ALU, and registers
    reg loada, loadb, loadc, asel, bsel, vsel, loads, write, load_pc, load_ir;
    reg [1:0] shift, ALUop;
    reg [2:0] writenum, readnum;
    reg branch_taken;

    // Branch logic (based on status flags)
    always @(*) begin
        case (instruction[11:8])
            4'b0000: branch_taken = 1;               // Unconditional branch (B)
            4'b0001: branch_taken = (Z == 1);        // BEQ
            4'b0010: branch_taken = (Z == 0);        // BNE
            4'b0011: branch_taken = (N != V);        // BLT
            4'b0100: branch_taken = (N != V) || (Z == 1); // BLE
            default: branch_taken = 0;
        endcase
    end

    // Control signal generation
    always @(*) begin
        // Default values for control signals
        loada = 0; loadb = 0; loadc = 0; asel = 0; bsel = 0;
        vsel = 0; loads = 0; write = 0; load_pc = 0; load_ir = 0;
        shift = 2'b00; ALUop = 2'b00; writenum = 3'b000; readnum = 3'b000;
        we = 0; ram_in = 16'b0; 

        case (state)
            `RESET: begin
                load_pc = 1;
            end
            `IF1: begin
                load_pc = 1; // Load instruction from memory (PC -> RAM address input)
            end
            `IF2: begin
                instruction <= ram_out; // Load fetched instruction
            end
            `GETA: begin
                loada = 1;
                readnum = instruction[10:8]; // Rn field
            end
            `GETB: begin
                loadb = 1;
                readnum = instruction[7:5]; // Rm field
            end
            `ADD: begin
                asel = 0;
                bsel = 0;
                ALUop = 2'b00; // ADD operation
                loadc = 1;
                loads = 1;
            end
            `WRITE_REG: begin
                writenum = instruction[4:2]; // Rd field
                vsel = 0;
                write = 1;
            end
            `BRANCH: begin
                load_pc = 1; // Update PC based on branch logic
            end
            `CALL: begin
                writenum = 3'b111; // R7 (link register)
                vsel = 1; // Write PC + 1 to R7
                write = 1;
                load_pc = 1;
            end
            `RETURN: begin
                load_pc = 1; // Set PC to R7 value for return
            end
        endcase
    end

    // Instantiate datapath
    p6_datapath DP (
        .datapath_in(in),
        .mdata(16'b0),
        .sximm8({{8{instruction[7]}}, instruction[7:0]}),
        .PC(pc),
        .sximm5({{11{instruction[4]}}, instruction[4:0]}),
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

    // Wait flag
    assign w = (state == `WAIT);
endmodule