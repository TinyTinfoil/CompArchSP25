`define assert(signal, value, test) \
        if (signal !== value) begin \
            $display({test,": Assertion FAILED in %m: signal != value"}); \
            $finish; \
        end else begin \
            $display({test,": Assertion passed in %m: signal == value"}); \
        end
`timescale 10ns/10ns
`include "ALU.sv"

module ALU_tb;

    logic [31:0] A;          // First 32-bit input
    logic [31:0] B;          // Second 32-bit input
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [31:0] Result;  

    ALU u0 (A, B, funct3, funct7, Result); // Instantiate the ALU

    initial begin
        // Test case 1: ADD
        A = 32'd5;
        B = 32'd3;
        funct3 = 3'b000; // ADD
        funct7 = 7'b0000000;
        #10;
        `assert(Result, 32'd8,"Add"); 
        #10;
        $finish;
    end

endmodule