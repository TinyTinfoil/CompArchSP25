module compare(
    input logic [31:0] A,          // First 32-bit input
    input logic [31:0] B,          // Second 32-bit input
    input logic [2:0] funct3,   // funct3 for comparison
    output logic flag

);
    always_comb begin
        case (funct3)
            3'b000: flag = (A == B); // Equal
            3'b001: flag = (A != B); // Not equal
            3'b010: flag = (A < B);  // Less than
            3'b011: flag = (A >= B); // Greater than or equal to
            3'b100: flag = (A > B);  // Greater than
            3'b101: flag = (A <= B); // Less than or equal to
            default: flag = 1'b0;    // Default case
        endcase
    end
endmodule