module ALU (
    input  logic [31:0] A,          // First 32-bit input
    input  logic [31:0] B,          // Second 32-bit input
    input  logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic [31:0] Result     // 32-bit result
);

    // ALU Operations
    // funct3 = 0, add a and b
    // funct3 = 0, funct7 = 0x20 sub a and b
    //funct3 = 4, xor a and b
    // funct3 = 6, or a and b
    // funct3 = 7, and a and b
    // funct3 = 1, sll a and b
    // funct3 = 2, slt a and b
    // funct3 = 3, sltu a and b
    // funct3 = 5, srl a and b
    // funct3 = 5, funct7 = 0x20 sra a and b
    always @(*) begin
        case (funct3)
            3'b000: Result = (funct7 == 7'h20) ? A - B : A + B; // ADD or SUB
            3'b100: Result = A ^ B;                            // XOR
            3'b110: Result = A | B;                            // OR
            3'b111: Result = A & B;                            // AND
            3'b001: Result = A << B[4:0];                      // SLL
            3'b010: Result = (A[31]==1 && B[31] == 0) || (A < B) ? 32'b1 : 32'b0; // SLT
            3'b011: Result = (A < B) ? 32'b1 : 32'b0;          // SLTU
            3'b101: Result = (funct7 == 7'h20) && (A[31] == 1) ? ~(~A >> B[4:0]): A >> B[4:0]; // SRA or SRL
            default: Result = 32'b0;                           // Default case
        endcase
    end


endmodule