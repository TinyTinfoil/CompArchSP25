// Rainbow

module top (
    input  logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);

  // CLK frequency is 12MHz, so 12,000,000 cycles is 1s
  parameter BLINK_INTERVAL = 12000000;
  logic [$clog2(BLINK_INTERVAL) - 1:0] count = 0;
  logic [2:0] state = 1'b000;
  logic [2:0] RGB_RGB;

  assign {RGB_R, RGB_G, RGB_B} = RGB_RGB;

  initial begin
    LED   = 1'b0;
    RGB_RGB = 3'b000;
  end

  always_ff @(posedge clk) begin
    if (count == BLINK_INTERVAL - 1) begin
      count <= 0;
      state <= (state + 1) % 6;
    end else begin
      count <= count + 1;
    end
  end
  always_comb begin
    unique case (state)
        0: RGB_RGB = 3'b100;
        1: RGB_RGB = 3'b110;
        2: RGB_RGB = 3'b010;
        3: RGB_RGB = 3'b011;
        4: RGB_RGB = 3'b001;
        5: RGB_RGB = 3'b101;
    endcase
  end
endmodule
