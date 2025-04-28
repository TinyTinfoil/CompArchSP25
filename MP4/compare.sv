module compare(
    input logic [31:0] A,          // First 32-bit input
    input logic [31:0] B,          // Second 32-bit input
    input logic [2:0] funct3,   // funct3 for comparison
    output logic flag

);
    always_comb begin
        case (funct3)
            3'h0: flag = (A == B); // Equal
            3'h1: flag = (A != B); // Not equal
            3'h4: flag = ($signed(A) < $signed(B));  // Less than
            3'h5: flag = ($signed(A) >= $signed(B)); // Greater than or equal to
            3'h6: flag = ($unsigned(A) < $unsigned(B));  // Less than (unsigned)
            3'h7: flag = ($unsigned(A) >= $unsigned(B)); // Greater than or equal to (unsigned)
            default: flag = 1'b0;    // Default case
        endcase
    end
endmodule