module lab7_top(KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [3:0] KEY;
    input [9:0] SW;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;



endmodule

module RAM(clk, read_address, write_address, write, din, dout);
    parameter data_width = 32;
    parameter addr_width = 4;
    parameter filename = "data.txt";
    
    input clk;
    input [addr_width-1:0] read_address, write_address;
    input write;
    input [data_width-1:0] din;
    output reg [data_width-1:0] dout;
    
    reg [data_width-1:0] mem [2**addr_width-1:0];

    initial $readmemb(filename, mem);

    always@(posedge clk) begin
        if(write)
            mem[write_address] <= din;
        dout <= mem[read_address];
    end
endmodule