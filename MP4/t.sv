`include "memory.sv"
module top (
    input logic clk,                  // Clock signal
    input logic SW,
    output logic RGB_R,             // Red LED output
    output logic RGB_G,           // Green LED output
    output logic RGB_B             // Blue LED output
);

    // Memory interface
    logic [31:0] address;   // Address to read from memory
    logic [31:0] data_out; // Data read from memory

    // Instantiate memory module
    memory #(.INIT_FILE("rv32i_test.txt")
    ) mem (
        .clk(clk),
        .write_mem(SW), // No write operation in this example
        .funct3(3'b010),  // Example funct3 for reading
        .write_address(address), // Not used in read mode
        .write_data(address),    // Not used in read mode
        .read_address(address),
        .read_data(data_out),
        .led(),            // Not used in this example
        .red(),           // Not used in this example
        .green(),         // Not used in this example
        .blue()           // Not used in this example
    );
    reg [31:0] data; // Data
    // Sequential logic to iterate through memory addresses
    always_ff @(posedge clk) begin
            address <= address + 4;
            data <= data_out;
    end

    // Map lowest bits of data to LEDs
    always_ff @(negedge clk) begin
        RGB_R   <= data > 120 ; // Lowest bit to red LED
        RGB_G <= data> 300; // Second lowest bit to green LED
        RGB_B  <= data > 4294967290; // Third lowest bit to blue LED
    end

endmodule