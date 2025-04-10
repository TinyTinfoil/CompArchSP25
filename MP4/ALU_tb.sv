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
        // Test case 2: SUB
        A = 32'd5;
        B = 32'd3;
        funct3 = 3'b000; // SUB
        funct7 = 7'b0100000;
        #10;
        `assert(Result, 32'd2,"Sub");
        #10;

        // Test case 3: XOR
        A = 32'hF0F0F0F0;
        B = 32'hFF0F0F0F;
        funct3 = 3'b100; // XOR
        funct7 = 7'b0000000;
        #10;
        `assert(Result, 32'h0FFFFFFF, "XOR");

        // Test case 4: OR
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        funct3 = 3'b110; // OR
        funct7 = 7'b0000000;
        #10;
        `assert(Result, 32'hFFFFFFFF, "OR");
        #10;

        // Test case 5: XOR
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        funct3 = 3'b100; // XOR
        funct7 = 7'b0000000;
        #10;
        `assert(Result, 32'hFFFFFFFF, "XOR");
        #10;

        // Test case 6: SLL (Shift Left Logical)
        A = 32'd1;
        B = 32'd4;
        funct3 = 3'b001; // SLL
        funct7 = 7'b0000000;
        #10;
        `assert(Result, 32'd16, "SLL");
        #10;

        // Test case 7: SRL (Shift Right Logical)
        A = 32'd16;
        B = 32'd4;
        funct3 = 3'b101; // SRL
        funct7 = 7'b0000000;
        #10;
        `assert(Result, 32'd1, "SRL");
        #10;

        // Test case 8: SRA (Shift Right Arithmetic)
        A = -32'd16; // Negative number
        B = 32'd4;
        funct3 = 3'b101; // SRA
        funct7 = 7'b0100000;
        #10;
        `assert(Result, -32'd1, "SRA");
        #10;

        // Test case 9: SLT (Set Less Than)
        A = 32'd5;
        B = 32'd10;
        funct3 = 3'b010; // SLT
        funct7 = 7'b0000000;
        #10;
        `assert(Result, 32'd1, "SLT");
        #10;

        // Test case 10: SLTU (Set Less Than Unsigned)
        A = 32'hFFFFFFFF; // Large unsigned value
        B = 32'd10;
        funct3 = 3'b011; // SLTU
        funct7 = 7'b0000000;
        #10;
        `assert(Result, 32'd0, "SLTU");
        #10;

        $finish;
    end

endmodule