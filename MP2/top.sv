`include "pwm.sv"
`include "lin.sv"

module top #(
    parameter PWM_INTERVAL = 1200       // CLK frequency is 12MHz, so 1,200 cycles is 100us
)(
    input logic  clk, 
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);
    parameter STATE_INTERVAL = 2000000; // change state every 2M cycles
    logic [$clog2(STATE_INTERVAL) - 1:0] count = 0; // code from blink.sv
    logic [$clog2(6) - 1:0] state = 0;
    logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value_R;
    logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value_B;
    logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value_G;
    logic [2:0] state_R = 2;
    logic [2:0] state_G = 0;
    logic [2:0] state_B = 2;
    logic pwm_out_R;
    logic pwm_out_G;
    logic pwm_out_B;

    always_ff @(posedge clk) begin // code from blink.sv
    if (count == STATE_INTERVAL - 1) begin
      count <= 0;
      state <= (state + 1) % 6; //Track state parameter
    end else begin
      count <= count + 1;
    end
    end
    always_comb begin
     unique case (state) //State is mod 6 so no need for default
        0: begin
            state_R = 2;
            state_G = 0;
            state_B = 2;
        end
        1: begin
            state_R = 1;
            state_G = 2;
            state_B = 2;
        end
        2: begin
            state_R = 2;
            state_G = 2;
            state_B = 0;
        end
        3: begin
            state_R = 2;
            state_G = 1;
            state_B = 2;
        end
        4: begin
            state_R = 0;
            state_G = 2;
            state_B = 2;
        end
        5: begin
            state_R = 2;
            state_G = 2;
            state_B = 1;
        end
    endcase
  end

    lin #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) ucR (
        .clk            (clk),
        .inc_or_dec     (state_R),
        .pwm_value      (pwm_value_R)
    );

    pwm #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) uR (
        .clk            (clk),
        .pwm_value      (pwm_value_R),
        .pwm_out        (pwm_out_R)
    );

    lin #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) ucG (
        .clk            (clk),
        .inc_or_dec     (state_G),
        .pwm_value      (pwm_value_G)
    );

    pwm #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) uG (
        .clk            (clk),
        .pwm_value      (pwm_value_G),
        .pwm_out        (pwm_out_G)
    );

    lin #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) ucB (
        .clk            (clk),
        .inc_or_dec     (state_B),
        .pwm_value      (pwm_value_B)
    );

    pwm #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) uB (
        .clk            (clk),
        .pwm_value      (pwm_value_B),
        .pwm_out        (pwm_out_B)
    );

    assign RGB_R = ~pwm_out_R;
    assign RGB_G = ~pwm_out_G;
    assign RGB_B = ~pwm_out_B;

endmodule