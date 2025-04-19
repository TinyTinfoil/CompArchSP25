`define assert(signal, value, test) \
        if (signal !== value) begin \
            $display({test,": Assertion FAILED in %m: signal != value"}); \
            $finish; \
        end else begin \
            $display({test,": Assertion passed in %m: signal == value"}); \
        end
`timescale 10ns/10ns
`include "compare.sv"

module ALU_tb;

    logic [31:0] A;          // First 32-bit input
    logic [31:0] B;          // Second 32-bit input
    logic [2:0] funct3;
    logic flag;  

    compare u0 (A, B, funct3, flag); // Instantiate

    initial begin
        // Test case 1: Equal
        A = 32'd5;
        B = 32'd5;
        funct3 = 3'h0; // Equal
        #10;
        `assert(flag, 1'b1, "Equal");
        #10;

        // Test case 2: Not Equal
        A = 32'd5;
        B = 32'd3;
        funct3 = 3'h1; // Not Equal
        #10;
        `assert(flag, 1'b1, "Not Equal");
        #10;

        // Test case 3: Less Than (signed)
        A = 32'd5;
        B = 32'd10;
        funct3 = 3'h4; // Less Than (signed)
        #10;
        `assert(flag, 1'b1, "Less Than (signed)");
        #10;

        // Test case 4: Greater Than or Equal (signed)
        A = 32'd10;
        B = 32'd5;
        funct3 = 3'h5; // Greater Than or Equal (signed)
        #10;
        `assert(flag, 1'b1, "Greater Than or Equal (signed)");
        #10;

        // Test case 5: Less Than (unsigned)
        A = 32'd5;
        B = 32'd10;
        funct3 = 3'h6; // Less Than (unsigned)
        #10;
        `assert(flag, 1'b1, "Less Than (unsigned)");
        #10;

        // Test case 6: Greater Than or Equal (unsigned)
        A = 32'd10;
        B = 32'd5;
        funct3 = 3'h7; // Greater Than or Equal (unsigned)
        #10;
        `assert(flag, 1'b1, "Greater Than or Equal (unsigned)");
        #10;
        
        $finish;
    end

endmodule