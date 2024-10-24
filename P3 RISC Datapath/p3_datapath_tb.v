module p3_datapath_tb();
    reg [15:0] datapath_in;
    reg [2:0] writenum, readnum;
    reg write, clk, loada, loadb, loadc, loads, asel, bsel, vsel;
    reg [1:0] shift, ALUop;
    wire [15:0] datapath_out;
    wire Z_out;
    
    p3_datapath dut (
        .datapath_in(datapath_in),
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
        .shift(shift),
        .ALUop(ALUop),
        .datapath_out(datapath_out),
        .Z_out(Z_out)
    );
    
    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset procedure
    task reset_sys();
        begin
            write = 0;
            writenum = 3'b000;
            readnum = 3'b000;
            datapath_in = 16'b0;
            loada = 0;
            loadb = 0;
            loadc = 0;
            asel = 0;
            bsel = 0;
            vsel = 0;
            shift = 2'b00;
            ALUop = 2'b00;
            #10;
        end
    endtask

    initial begin
        // Reset procedure
        reset_sys();

        // Test combination: addition
        // Write 5 to R0
        datapath_in = 16'h5;
        writenum = 3'b0;
        write = 1;
        #10 write = 0;

        // Write 10 to R1
        datapath_in = 16'hA;
        writenum = 3'b1;
        write = 1;
        #10 write = 0;

        // Load R0 to A
        readnum = 3'b0;
        loada = 1;
        #10 loada = 0;

        // Load R1 to B
        readnum = 3'b1;
        loadb = 1;
        #10 loadb = 0;

        // A + B (R0 + R1)
        asel = 0;
        bsel = 0;
        ALUop = 2'b0;
        loadc = 1;
        #10 loadc = 0;

        // Write result to R2
        vsel = 0;
        writenum = 3'b10;
        write = 1;
        #10 write = 0;
        #20; // Check waveform

        // Test combination: subtraction
        // Write 15 to R3
        datapath_in = 16'hF;
        writenum = 3'b11;
        write = 1;
        #10 write = 0;

        // Write 5 to R4
        datapath_in = 16'h5;
        writenum = 3'b100;
        write = 1;
        #10 write = 0;

        // Load R3 to A
        readnum = 3'b11;
        loada = 1;
        #10 loada = 0;

        // Load R4 to B
        readnum = 3'b100;
        loadb = 1;
        #10 loadb = 0;

        // A - B (R3 - R4)
        asel = 0;
        bsel = 0;
        ALUop = 2'b01;
        loadc = 1;
        #10 loadc = 0;

        // Write result to R5
        vsel = 0;
        writenum = 3'b101;
        write = 1;
        #10 write = 0;
        #20; // Check waveform

        // Test combination: shift
        // Write 0001 0010 0011 0100 to R6
        datapath_in = 16'h1234;
        writenum = 3'b110;
        write = 1;
        #10 write = 0;

        // Load R6 to B
        readnum = 3'b110;
        loadb = 1;
        #10 loadb = 0;

        // Perform shift left (B << 1)
        shift = 2'b1;
        bsel = 0;
        loadc = 1;
        #10 loadc = 0;

        // Write result to R7
        vsel = 0;
        writenum = 3'b111;
        write = 1;
        #10 write = 0;
        #20; // Check waveform
        reset_sys();

        $finish; // End the simulation
    end
endmodule