module lab7_top(KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [3:0] KEY;
    input [9:0] SW;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // mem_cmd
    define `MNONE = 3'b001;
    define `MREAD = 3'b010;
    define `MWRITE = 3'b100;

    // Instantiate RAM Module
    RAM MEM(
        .clk(~KEY[0]),
        .read_address(mem_addr[7:0]),
        .write_address(mem_addr[7:0]),
        .write(write_out && msel),
        .din(write_data),
        .dout(dout)
    );

    // `MREAD, `MWRITE and msel comparison
    always @(*) begin
        if(mem_cmd == `MREAD) read_out = 1'b1;
        else read_out = 1'b0;

        if(mem_cmd == `MWRITE) write_out = 1'b1;
        else write_out = 1'b0;

        if(mem_addr[8] == 1'b0) msel = 1'b1;
        else msel = 1'b0;
    end

    // Tri-state drivers
    always @(*) begin
        read_data = (read_out && msel) ? dout : {16{1'bz}};
    end
    
    // Instantiate CPU Module
    cpu U(
        .clk(~KEY[0]),
        .reset(~KEY[1]),
        .in(read_data),
        .out(write_data),
        .N(N),
        .V(V),
        .Z(Z),
        .mem_addr(mem_addr),
        .mem_cmd(mem_cmd)
    );

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
        if(write) mem[write_address] <= din;
        dout <= mem[read_address];
    end
endmodule