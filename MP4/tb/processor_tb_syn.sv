// Sine testbench - unchanged from the original
`timescale 10ns/10ns
`include "processor_syn.v"

module processor_tb;

    logic clk = 0;
    logic RGB_R;
    logic RGB_G;
    logic RGB_B;
    logic LED;

    top u0 (clk, RGB_R, RGB_G, RGB_B, LED);

    initial begin
        $dumpfile("processor.vcd");
        $dumpvars(1, u0);
        #10000
        $finish;
    end

    always begin
        #1
        clk = ~clk;
    end

endmodule

