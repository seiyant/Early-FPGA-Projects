module p5_ram (clk, address, data_in, we, data_out);
    //Input and output port declarations
    input clk;
    input [7:0] address;
    input [15:0] data_in;
    input we; 
    output reg [15:0] data_out;

    //Memory array with 256 locations
    reg [15:0] mem [0:255];

    //Initialize memory with text file values
    initial begin
        $readmemb("data.txt", mem);
    end

    //Read/write sequential logic block
    always @(posedge clk) begin
        //Write if write enable
        if (we)
            mem[address] <= data_in;
        //Read from memory
        data_out <= mem[address];
    end
endmodule