// mem_cmd
`define MNONE 3'b001
`define MREAD 3'b010
`define MWRITE 3'b100

module cpu(clk, reset, in, out, mem_addr, mem_cmd, N, V, Z);
    input clk, reset;
    input [15:0] in;
    output [15:0] out;
    output reg N, V, Z;
    output reg [8:0] mem_addr;
    output reg [2:0] mem_cmd;

    // States
    parameter Srst = 4'b0000, Sdecode = 4'b0001, SgetA = 4'b0010, SgetB = 4'b0011, Swrite = 4'b0100, Srewrite = 4'b0101, Salu = 4'b0110, Sshift = 4'b0111, Sloadout = 4'b1000, Sif1 = 4'b1001, Sif2 = 4'b1010, SupdatePC = 4'b1011, Shalt = 4'b1100, Sldr = 4'b1101, Sstr = 4'b1110, Sldr_mem = 4'b1111, Sstr_addr = 5'b10000, Sstr_rd = 5'b10001, Sstr_rd_alu = 5'b10010, Sstr_loadout = 5'b10011, Sstr_write = 5'b10100, Srewrite_mem = 5'b10101, Sint1 = 5'b10110, Scmp = 5'b10111, Sint2 = 5'b11000;

    // Decoder Input
    wire [15:0] decoder_in;

    // Decoder Outputs
    reg [1:0] op, shift;
    reg [15:0] sximm5, sximm8;
    reg [2:0] opcode, readnum, writenum;
    reg [4:0] state;

    // Other Variables
    reg reset_pc, load_pc, addr_sel, load_ir, load_addr;
    reg [8:0] next_pc;
    wire [8:0] PC;
    wire [8:0] data_addr_out;

    // nsel  
    reg [2:0] nsel;

    // Datapath Inputs
    reg [1:0] vsel;
    reg loada, loadb, asel, bsel, loadc, loads, write;
    wire [2:0] Z_out;

    // Instruction Register
    vDFFE #(16) Instruct_Reg(clk, load_ir, in, decoder_in);

    // Instruction Decoder
    always@(*) begin
        op = decoder_in[12:11];
        sximm5 = { {11{decoder_in[4]}}, decoder_in[4:0] };
        sximm8 = { {8{decoder_in[7]}}, decoder_in[7:0] };
        shift = decoder_in[4:3];
        opcode = decoder_in[15:13];
    end

    //nsel MUX
    always@(*)begin
       case(nsel)
            3'b001: begin
                readnum = decoder_in[2:0];
                writenum = decoder_in[2:0];
            end // Rm
            3'b010: begin
                readnum = decoder_in[7:5];
                writenum = decoder_in[7:5];
            end // Rd
            3'b100: begin
                readnum = decoder_in[10:8];
                writenum = decoder_in[10:8];
            end // Rn
            default: {readnum, writenum} = 3'bx;
        endcase 
    end

    // State Machine (Mealy)
    always @(posedge clk) begin
        if(reset == 1'b1) state = Srst;
        else begin
            case(state)
                Sdecode: begin
                    if(opcode == 3'b110 && op == 2'b10) state = Swrite;
                    else if(opcode == 3'b111) state = Shalt;
                    else state = SgetA;
                end
                Swrite: state = Sint1;
                Srst: state = Sif1;
                Sif1: state = Sif2;
                Sif2: state = SupdatePC;
                SupdatePC: state = Sdecode;
                SgetA: state = SgetB;
                SgetB: begin
                    if(opcode == 3'b110 && op == 2'b0) state = Sshift;
                    else if(opcode == 3'b101) state = Salu;
                    else if(opcode == 3'b011) state = Sldr;
                    else if(opcode == 3'b100) state = Sstr;
                end
                Salu: state = Sloadout;
                Sshift: state = Sloadout;
                Sldr: state = Sloadout;
                Sstr: state = Sloadout;
                Sldr_mem: state = Srewrite_mem;
                Sstr_addr: state = Sstr_rd;
                Sstr_rd: state = Sstr_rd_alu;
                Sstr_rd_alu: state = Sstr_loadout;
                Sstr_loadout: state = Sstr_write;
                Sstr_write: state = Sint1; 
                Srewrite_mem: state <= Sint1;
                Sloadout: begin
                    if(opcode == 3'b011) state = Sldr_mem;
                    else if(opcode == 3'b100) state = Sstr_addr;
                    else if(op == 2'b01) state = Scmp;
                    else state = Srewrite;
                end
                Sint1: state = Sif1;
                Scmp: state = Sint1;
                Srewrite: state = Sint1;
                default: state = Srst;
            endcase
        end

        // output of different states
        case(state)
            SgetA: {nsel, loada, loadb} = {3'b100, 1'b1, 1'b0};
            SgetB: {nsel, loadb, loada} = {3'b001, 1'b1, 1'b0};
            Salu: {asel, bsel} = {1'b0, 1'b0};
            Sshift: {asel, bsel} = {1'b1, 1'b0};
            Sldr: {asel, bsel} = {1'b0, 1'b1};
            Sstr: {asel, bsel} = {1'b0, 1'b1};
            Sldr_mem: {addr_sel, mem_cmd, load_addr} = {1'b0, `MREAD, 1'b1};
            Sstr_addr: {addr_sel, mem_cmd, load_addr} = {1'b0, `MNONE, 1'b1};
            Sstr_rd: {nsel, loadb, loada} = {3'b010, 1'b1, 1'b0};
            Sstr_rd_alu: {asel, bsel, load_addr} = {1'b1, 1'b0, 1'b0};
            Sstr_loadout: {loadc, loads} = {1'b1, 1'b1};
            Sstr_write: mem_cmd = `MWRITE;
            Sloadout: {loadc, loads} = {1'b1, 1'b1};
            Srewrite: {vsel, nsel, write} = {2'b0, 3'b010, 1'b1};
            Scmp: {vsel, nsel, write} = {2'b0, 3'b0, 1'b0};
            Srewrite_mem: {vsel, nsel, write, mem_cmd} = {2'b11, 3'b010, 1'b1, `MNONE};
            Swrite: {vsel, nsel, write} = {2'b10, 3'b100, 1'b1};
            Srst: {reset_pc, load_pc, mem_cmd, addr_sel, load_ir} = {1'b1, 1'b1, `MNONE, 1'b0, 1'b0};
            Sif1: {reset_pc, load_pc, mem_cmd, addr_sel, load_ir} = {1'b0, 1'b0, `MREAD, 1'b1, 1'b0};
            Sif2: {reset_pc, load_pc, mem_cmd, addr_sel, load_ir, write} = {1'b0, 1'b0, `MREAD, 1'b1, 1'b1, 1'b0};
            SupdatePC: {reset_pc, load_pc, mem_cmd, addr_sel, load_ir} = {1'b0, 1'b1, `MNONE, 1'b0, 1'b0};
            default: begin 
                {nsel, vsel} = {3'b0, 2'bx};
                {loada, loadb, loadc, loads, asel, bsel} = 6'b0;
                write = 1'b0;
                {reset_pc, load_pc, addr_sel, load_ir, load_addr} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                mem_cmd = `MNONE;
            end
        endcase
    end

    //program counter MUX
    always @(*) begin
        next_pc = (reset_pc) ? 9'b0 : PC + 1;
    end

    //program counter load register
    vDFFE #(9) Program_Counter(clk, load_pc, next_pc, PC);

    //addr_sel MUX
    always@(*)begin
        mem_addr = (addr_sel) ? PC : data_addr_out;
    end

    // data_address load register
    vDFFE #(9) Data_Address(clk, load_addr, out[8:0], data_addr_out);

    // Datapath Instantiation
    datapath DP(
        .clk(clk), 
        .readnum(readnum), 
        .vsel(vsel), 
        .loada(loada), 
        .loadb(loadb), 
        .shift(shift),
        .asel(asel),
        .bsel(bsel),
        .ALUop(op),
        .loadc(loadc),
        .loads(loads),
        .writenum(writenum),
        .write(write),
        .mdata(in),
        .PC(8'b0),
        .sximm5(sximm5),
        .sximm8(sximm8),
        .Z_out(Z_out),
        .datapath_out(out)
    );

    always @(*) begin
        V = Z_out[2];
        N = Z_out[1];
        Z = Z_out[0];
    end
endmodule