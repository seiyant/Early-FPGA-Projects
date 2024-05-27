module p3_regfile_tb();
    reg [15:0] data_in;
    reg [2:0] writenum, readnum;
    reg write, clk;
    wire [15:0] data_out;

    p3_regfile dut (
        .data_in(data_in),
        .writenum(writenum),
        .readnum(readnum),
        .write(write),
        .clk(clk),
        .data_out(data_out)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Reset procedure
    task reset_sys();
        begin
            write = 0;
            writenum = 3'b0;
            readnum = 3'b0;
            data_in = 16'b0;
            #20;
        end
    endtask

    initial begin
        // Reset the system
        reset_sys();

        // Test combination: write = 0
        data_in = 16'hA5A5;
        writenum = 3'b0;
        write = 0; #10;
        readnum = 3'b0; #10;
        #20; // Check waveform
        reset_sys();

        // Test combination: write = 1
        data_in = 16'h5A5A;
        writenum = 3'b1;
        write = 1; #10;
        write = 0; // Turn write off
        readnum = 3'b1; #10;
        #20; // Check waveform
        reset_sys();

        // Test combination: write = 1, readnum = 3
        data_in = 16'h1234;
        writenum = 3'b10;
        write = 1; #10;
        write = 0; // Turn write off
        readnum = 3'b11;
        #20; //Check waveform
        readnum = 3'b10; // Correct readnum
        #20; // Check waveform
        reset_sys();

        $finish; 
    end
endmodule