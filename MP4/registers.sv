module registers (
    input logic [4:0] read_addr1,   // Read address
    input logic [4:0] read_addr2,   // Read address
    input logic [4:0] write_addr,   // Write address
    input logic write_enable,   //write signal
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
    always_ff @(posedge write_enable) begin
        if (write_enable && write_addr != 5'd0) begin
            registers[write_addr] <= write_data;
        end
    end

    // Read logic
    assign read_data1 = (read_addr1 == 5'd0) ? 32'd0 : registers[read_addr1];
    assign read_data2 = (read_addr2 == 5'd0) ? 32'd0 : registers[read_addr2];

endmodule
