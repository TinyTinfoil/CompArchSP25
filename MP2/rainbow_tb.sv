
`timescale 10ns/10ns
`include "top.sv"

module rainbow_tb;

    parameter PWM_INTERVAL = 1200;

    logic clk = 0;
    logic RGB_R;
    logic RGB_G;
    logic RGB_B;

    top # (
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u0 (clk, RGB_R, RGB_G, RGB_B);

    initial begin
        $dumpfile("rainbow.vcd");
        $dumpvars(0, rainbow_tb);
        #200000000 //2s to account for invalid initial state
        $finish;
    end

    always begin
        #4
        clk = ~clk;
    end

endmodule