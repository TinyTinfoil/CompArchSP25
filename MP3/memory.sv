// Sample memory module

module memory #(
    parameter INIT_FILE = ""
)(
    input logic     clk,
    input logic     [8:0] read_address, //0 - 512 address
    output logic    [9:0] read_data // 10 bit with changed sign bit
);

    // Declare memory array for storing 128 9-bit samples of a sine function
    logic [8:0] sample_memory [128];

    initial if (INIT_FILE) begin
        $readmemh(INIT_FILE, sample_memory); //only have quarter wave
    end
    logic [6:0] quarter_index = 0;
    logic [7:0] half_index;
    assign half_index = read_address[7:0];
    always_comb begin
        if (half_index <= 127) quarter_index = half_index;
        if (half_index >= 128) quarter_index = 255 - half_index;
    end
    logic [9:0] read_datap = 0;
    always_ff @(posedge clk) begin
        read_datap <= sample_memory[quarter_index];
        case (read_address[8:7])
            2'b00: read_data <= 512 + read_datap;
            2'b01: read_data <= 512 + read_datap;
            2'b10: read_data <= 512 - read_datap;
            2'b11: read_data <= 512 - read_datap;
        endcase
    end
endmodule
