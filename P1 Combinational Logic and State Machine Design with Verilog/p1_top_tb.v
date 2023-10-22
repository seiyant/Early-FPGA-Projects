module p1_top_tb();
    reg [9:0] SW;
    reg [3:0] KEY = 4'b1111;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    wire [9:0] LEDR;

    p1_top dut (
        .SW(SW),
        .KEY(KEY),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .LEDR(LEDR)
    );

    // Clock generation with integrated reset
    always begin 
	if (KEY[3] == 0) begin
	    KEY[0] = 0; #5;// Hold clock high during reset
	end
	else begin
            #5 KEY[0] = 1;
            #5 KEY[0] = 0;
	end
    end

    // Reset procedure
    task reset_sys(); 
        begin
            KEY[3] = 0; #10
            KEY[3] = 1; #10;
        end
    endtask

    initial begin
        // Reset the system
        reset_sys();

        // Test combination: 838482
        SW[3:0] = 4'h8; #10;
        SW[3:0] = 4'h3; #10;
        SW[3:0] = 4'h8; #10;
        SW[3:0] = 4'h4; #10;
        SW[3:0] = 4'h8; #10;
        SW[3:0] = 4'h2; #10;
        #10; // Check for "0PEn"
        reset_sys();

        // Test combination: 838982
        SW[3:0] = 4'h8; #10;
        SW[3:0] = 4'h3; #10;
        SW[3:0] = 4'h8; #10;
        SW[3:0] = 4'h9; #10;
        SW[3:0] = 4'h8; #10;
        SW[3:0] = 4'h2; #10;
        #10; // Check for "CL05Ed"
        reset_sys();

        // Test combination: 8384A2
        SW[3:0] = 4'h8; #10;
        SW[3:0] = 4'h3; #10;
        SW[3:0] = 4'h8; #10;
        SW[3:0] = 4'h4; #10;
        SW[3:0] = 4'hA; #10;
        SW[3:0] = 4'h2; #10;
        #10; // Check for "Err0r"
        reset_sys();

        $finish;
    end
    
endmodule
