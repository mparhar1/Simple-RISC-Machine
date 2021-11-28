module cpu(clk, reset, in, out, N, V, Z, mem_addr, mem_cmd);
    input clk, reset;
    input [15:0] in;
    output [15:0] out;
    output reg N, V, Z;
    output reg [8:0] mem_addr;
    output reg [2:0] mem_cmd;

    // States
    parameter Srst = 4'b0000, Sdecode = 4'b0001, SgetA = 4'b0010, SgetB = 4'b0011, Swrite = 4'b0100, Srewrite = 4'b0101, Salu = 4'b0110, Sshift = 4'b0111, Sloadout = 4'b1000, Sif1 = 4'b1001, Sif2 = 4'b1010, SupdatePC = 4'b1011;

    // mem_cmd
    define `MNONE = 3'b001;
    define `MREAD = 3'b010;
    define `MWRITE = 3'b100;

    // Decoder Input
    wire [15:0] decoder_in;

    // Decoder Outputs
    reg [1:0] op, shift;
    reg [15:0] sximm5, sximm8;
    reg [2:0] opcode, readnum, writenum;
    reg [3:0] state;

    // Other Variables
    reg reset_pc, load_pc, addr_sel, load_ir;
    reg [8:0] next_pc, pc_out, 

    // nsel  
    reg [2:0] nsel;

    // Datapath Inputs
    reg [1:0] vsel;
    reg loada, loadb, asel, bsel, loadc, loads, write;
    wire [2:0] Z_out;

    // Instruction Register
    vDFFE #(16) Instruct_Reg(clk, load_ir, read_data, decoder_in);

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
            default: {readnum, writenum} = 3'b0;
        endcase 
    end

    // State Machine (Mealy)
    always @(posedge clk) begin
        if(reset == 1'b1) state = Srst;
        else begin
            case(state)
                Sdecode: begin
                    if(opcode == 3'b110 && op == 2'b10) state = Swrite;
                    else state = SgetA;
                end
                Swrite: state = Sif1;
                Srst: state = Sif1;
                Sif1: state = Sif2;
                Sif2: state = SupdatePC;
                SupdatePC: state = Sdecode;
                SgetA: state = SgetB;
                SgetB: begin
                    if(opcode == 3'b110 && op == 2'b0) state = Sshift;
                    else if(opcode == 3'b101) state = Salu;
                end
                Salu: state = Sloadout;
                Sshift: state = Sloadout;
                Sloadout: state = Srewrite;
                Srewrite: state = Sif1;
                default: state = Srst;
            endcase
        end

        // output of different states
        case(state)
            SgetA: {nsel, loada, loadb} = {3'b100, 1'b1, 1'b0};
            SgetB: {nsel, loadb, loada} = {3'b001, 1'b1, 1'b0};
            Salu: {asel, bsel} = {1'b0, 1'b0};
            Sshift: {asel, bsel} = {1'b1, 1'b0};
            Sloadout: {loadc, loads} = {1'b1, 1'b1};
            Srewrite: {vsel, nsel, write} = {2'b0, 3'b010, 1'b1};
            Swrite: {vsel, nsel, write} = {2'b10, 3'b100, 1'b1};
            Srst: {reset_pc, load_pc, mem_cmd, addr_sel, load_ir} = {1'b1, 1'b1, `MNONE, 1'b0, 1'b0};
            Sif1: {reset_pc, load_pc, mem_cmd, addr_sel, load_ir} = {1'b0, 1'b0, `MREAD, 1'b1, 1'b0};
            Sif2: {reset_pc, load_pc, mem_cmd, addr_sel, load_ir} = {1'b0, 1'b0, `MREAD, 1'b1, 1'b1};
            SupdatePC: {reset_pc, load_pc, mem_cmd, addr_sel, load_ir} = {1'b0, 1'b1, `MNONE, 1'b0, 1'b0};
            default: begin 
                {nsel, vsel} = {3'b0, 2'b0};
                {loada, loadb, loadc, loads, asel, bsel, write} = 1'b0;
                {reset_pc, load_pc, addr_sel, load_ir} = 4'b0;
                mem_cmd = `MNONE;
            end
        endcase
    end

    //program counter MUX
    always @(*) begin
        next_pc = (reset_pc) ? 9'b0 : pc_out + 1;
    end

    //program counter load register
    vDFFE #(9) Program_Counter(clk, load_pc, next_pc, pc_out);

    //addr_sel MUX
    always@(*)begin
        mem_addr = (addr_sel) ? pc_out : 9'b0;
    end

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
        .mdata(16'b0),
        .PC(8'b0),
        .sximm5(sximm5),
        .sximm8(sximm8),
        .Z_out(Z_out),
        .datapath_out(out)
    );

    // Assigning V, N, Z from Z_out
    always @(*) begin
        V = Z_out[2];
        N = Z_out[1];
        Z = Z_out[0];
    end

endmodule