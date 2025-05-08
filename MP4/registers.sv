module registers (
    input logic [4:0] read_addr1,   // Read address
    input logic [4:0] read_addr2,   // Read address
    input logic [4:0] write_addr,   // Write address
    input logic write_enable,   //write signal
    input clk, // Clock signal
    input logic [31:0] write_data, // Data to write
    output logic [31:0] read_data1, // Data read
    output logic [31:0] read_data2 // Data read
);

    // Memory array for 32 general-purpose 32-bit registers
    logic [31:0] registers [32];
    // Initialize all registers to 0
    initial begin
        for (int i = 0; i < 32; i++) begin
            registers[i] = 32'd0;
        end
    end

    // Write logic
    always_ff @(posedge clk) begin
        if (write_enable && write_addr != 5'd0) begin
            registers[write_addr] <= write_data;
        end
        registers[0] = 32'd0;
    end
    always_comb begin
        // Read logic
        read_data1 = (read_addr1 == 5'd0) ? 32'd0 : registers[read_addr1];
        read_data2 = (read_addr2 == 5'd0) ? 32'd0 : registers[read_addr2];
    end
    
//For iverilog in order to see the registers in gtkwave
logic [31:0] reg0;
assign reg0 = registers[0];
logic [31:0] reg1;
assign reg1 = registers[1];
logic [31:0] reg2;
assign reg2 = registers[2];
logic [31:0] reg3;
assign reg3 = registers[3];
logic [31:0] reg4;
assign reg4 = registers[4];
logic [31:0] reg5;
assign reg5 = registers[5];
logic [31:0] reg6;
assign reg6 = registers[6];
logic [31:0] reg7;
assign reg7 = registers[7];
logic [31:0] reg8;
assign reg8 = registers[8];
logic [31:0] reg9;
assign reg9 = registers[9];
logic [31:0] reg10;
assign reg10 = registers[10];
logic [31:0] reg11;
assign reg11 = registers[11];
logic [31:0] reg12;
assign reg12 = registers[12];
logic [31:0] reg13;
assign reg13 = registers[13];
logic [31:0] reg14;
assign reg14 = registers[14];
logic [31:0] reg15;
assign reg15 = registers[15];
logic [31:0] reg16;
assign reg16 = registers[16];
logic [31:0] reg17;
assign reg17 = registers[17];
logic [31:0] reg18;
assign reg18 = registers[18];
logic [31:0] reg19;
assign reg19 = registers[19];
logic [31:0] reg20;
assign reg20 = registers[20];
logic [31:0] reg21;
assign reg21 = registers[21];
logic [31:0] reg22;
assign reg22 = registers[22];
logic [31:0] reg23;
assign reg23 = registers[23];
logic [31:0] reg24;
assign reg24 = registers[24];
logic [31:0] reg25;
assign reg25 = registers[25];
logic [31:0] reg26;
assign reg26 = registers[26];
logic [31:0] reg27;
assign reg27 = registers[27];
logic [31:0] reg28;
assign reg28 = registers[28];
logic [31:0] reg29;
assign reg29 = registers[29];
logic [31:0] reg30;
assign reg30 = registers[30];
logic [31:0] reg31;
assign reg31 = registers[31];
endmodule
