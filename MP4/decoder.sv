module decoder (
    input [31:0] instruction, // Instruction input
    output logic [2:0] funct3, // Function code for ALU operation
    output logic [6:0] funct7, // Function code for ALU operation
    output logic [31:0] imm,   // Immediate value
    output logic [4:0] rs1,    // Source register 1
    output logic [4:0] rs2,    // Source register 2
    output logic [4:0] rd,      // Destination register
    output logic [6:0] opcode // Opcode for instruction type
);

    // Extract opcode
    assign opcode = instruction[6:0];
    // Determine instruction type
    logic R;
    logic I;
    logic S;
    logic B;
    logic U;
    logic J;
    assign R = (opcode == 7'b0110011); // R-type instructions
    assign I = (opcode == 7'b0000011) || (opcode == 7'b0010011) || (opcode == 7'b1100111); // Load, ALU immediate, JALR
    assign S = (opcode == 7'b0100011); // Store instructions
    assign B = (opcode == 7'b1100011); // Branch instructions
    assign U = (opcode == 7'b0110111) || (opcode == 7'b0010111); // LUI, AUIPC
    assign J = (opcode == 7'b1101111); // JAL instructions
    // funct3 not used in U type and J type instructions
    assign funct3 = ~(U || J) ? instruction[14:12] : 3'b000;
    // funct7 only used in R type instructions
    assign funct7 = R ? instruction[31:25] : 7'b0000000;
    // Extract rs1, rs2, and rd
    assign rs1 = ~(U || J)  ? instruction[19:15] : 5'b00000;
    assign rs2 = (R || S || B) ? instruction[24:20] : 5'b00000;
    assign rd = ~(S || B) ? instruction[11:7] : 5'b00000;
    // Extract immediate value based on opcode
    always_comb begin
        case (opcode)
            // I type immediate
            7'b0000011: imm = {{20{instruction[31]}}, instruction[31:20]}; // Load instructions
            7'b0010011: imm = {{20{instruction[31]}}, instruction[31:20]}; // ALU immediate instructions
            7'b1100111: imm = {{20{instruction[31]}}, instruction[31:20]}; // JALR
            // S type immediate
            7'b0100011: imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // Store instructions
            // B type immediate
            7'b1100011: imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // Branch instructions
            // U type immediate
            7'b0110111: imm = {instruction[31:12], 12'b0}; // LUI
            7'b0010111: imm = {instruction[31:12], 12'b0}; // AUIPC
            // J type immediate
            7'b1101111: imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // JAL
            default: imm = 32'b0; // Default case
        endcase
    end

endmodule