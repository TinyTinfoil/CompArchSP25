// Fade between two values for a pwm in SV, based on the fade example code (with edits for external state)

module lin #(
    parameter INC_DEC_INTERVAL = 10000,     // increment every 10000 cycles
    parameter INC_DEC_MAX = 200,            // Transition to the final state after 200 increments / decrements
    parameter PWM_INTERVAL = 1200,
    parameter INC_DEC_VAL = PWM_INTERVAL / INC_DEC_MAX,
    parameter PWM_START = 0
)(
    input logic clk, 
    input logic [2:0] inc_or_dec,
    output logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value
);
    // Declare variables for timing state transitions
    logic [$clog2(INC_DEC_INTERVAL) - 1:0] count = 0;
    logic [$clog2(INC_DEC_MAX) - 1:0] inc_dec_count = 0;
    logic time_to_inc_dec = 1'b0;

    initial begin
        pwm_value = PWM_START;
        /*Won't be accurate for the first second (since red starts at 100%) but will
        be accurate after first loop around color wheel 
        Blue and green start out at zero, so will be accurate from the start*/
    end


    // Implement counter for incrementing / decrementing PWM value
    always_ff @(posedge clk) begin
        if (count == INC_DEC_INTERVAL - 1) begin
            count <= 0;
            time_to_inc_dec <= 1'b1;
        end
        else begin
            count <= count + 1;
            time_to_inc_dec <= 1'b0;
        end
    end

    // Increment / Decrement PWM value as appropriate given current state
    always_ff @(posedge time_to_inc_dec) begin
        case (inc_or_dec)
            0:
                if (pwm_value < PWM_INTERVAL) begin //Don't increment past max
                    pwm_value <= pwm_value + INC_DEC_VAL;
                end
            1:
                if (pwm_value > 0) begin //Don't decrement past 0
                    pwm_value <= pwm_value - INC_DEC_VAL;
                end
            2:
                pwm_value <= pwm_value;
        endcase
    end

    // Implement counter for timing state transitions - Not used but useful for debugging
    always_ff @(posedge time_to_inc_dec) begin
        if (inc_dec_count == INC_DEC_MAX - 1) begin
            inc_dec_count <= 0;
        end
        else begin
            inc_dec_count <= inc_dec_count + 1;
        end
    end

endmodule