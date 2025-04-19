// Modified memory module

module memory #(
    parameter INIT_FILE = ""
) (
    input  logic       clk,
    input  logic [8:0] read_address,  //0 - 512 address
    output logic [9:0] read_data      // 10 bit with changed sign bit
);

  // Declare memory array for storing 128 9-bit samples of a sine function
  logic [8:0] sample_memory[128];

  initial
    if (INIT_FILE) begin
      $readmemh(INIT_FILE, sample_memory);  //only have quarter wave
    end

  //Set quarter wave index to subsection of half_index
  logic [6:0] quarter_index = 0;

  always_ff @(posedge clk) begin
    case (read_address[7])
      1'b0: quarter_index <= read_address[6:0];
      1'b1: quarter_index <= 255 - read_address[6:0];
    endcase
    case (read_address[8])
      1'b0: read_data <= 511 + sample_memory[quarter_index];
      1'b1: read_data <= 511 - sample_memory[quarter_index];
    endcase
  end
endmodule
