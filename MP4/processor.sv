`include "memory.sv"
`include "decoder.sv"
`include "ALU.sv"
`include "registers.sv"
`include "compare.sv"
`include "memref.sv"
module top (
    input logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B,
    output logic LED
);
logic [31:0] PC;
logic [31:0] PC_next;
logic [2:0] funct3;
logic [6:0] funct7;
logic [31:0] imm;
logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;
logic [6:0] opcode;
logic write_enable;
logic [4:0] addr;
logic mem_write_enable;
logic [2:0] mem_funct3;
logic [31:0] mem_write_address;
logic [31:0] mem_write_data;
logic [31:0] mem_read_address;
logic [31:0] mem_read_data;
memory #(.INIT_FILE(`CODE)) mem (
    .clk(clk),
    .write_mem(mem_write_enable),
    .funct3(mem_funct3),
    .write_address(mem_write_address),
    .write_data(mem_write_data),
    .read_address(mem_read_address),
    .read_data(mem_read_data),
    .led(LED_n),
    .red(RGB_R_n),
    .green(RGB_G_n),
    .blue(RGB_B_n)
);

assign RGB_R = ~RGB_R_n;
assign RGB_G = ~RGB_G_n;
assign RGB_B = ~RGB_B_n;
assign LED = ~LED_n;

logic [31:0] rd1;
logic [31:0] rd2;
logic [31:0] data;
registers registers (
    .read_addr1(rs1),   // Read address
    .read_addr2(rs2),   // Read address
    .write_addr(rd),   // Write address
    .write_enable(write_enable),   //write signal
    .write_data(data), // Data to write
    .read_data1(rd1), // Data read
    .read_data2(rd2),  // Data read
    .clk(clk)
);
logic [31:0] op1_alu;
logic [31:0] op2_alu;
logic [31:0] res_alu;

ALU alu (
    .A(op1_alu),          // First 32-bit input
    .B(op2_alu),          // Second 32-bit input
    .funct3(funct3),
    .funct7(funct7),
    .Result(res_alu),                // 32-bit result
    .clk(clk) // Clock signal
);
logic [31:0] instruction_in;
decoder d (
    .instruction (instruction_in),
    .funct3 (funct3),
    .funct7 (funct7),
    .imm (imm),
    .rs1 (rs1),
    .rs2 (rs2),
    .rd (rd),
    .opcode (opcode),
    .clk (clk)
);
logic flag;
logic flag_cmp;
logic [31:0] cmp_op1;
logic [31:0] cmp_op2;
compare cmp (
    .A(cmp_op1),
    .B(cmp_op2),
    .funct3(funct3),
    .flag(flag_cmp)
);
logic [2:0] stage;
initial begin
    PC = 0;
    PC_next = 0;
    write_enable = 0;
    addr = 0;
    data = 0;
    flag = 0;
    op1_alu = 0;
    op2_alu = 0;
    cmp_op1 = 0;
    cmp_op2 = 0;
    stage = 3;
    instruction_in = 0;
end

always_ff @(posedge clk) begin
        case (stage)
        0: begin
            // Decode
            instruction_in <= mem_read_data; // Pass instruction to decoder
            PC_next <= PC + 4;
        end
        1: begin
            // Execute
            // load register data to operands
            case (opcode)
                // R-type instructions
                7'b0110011: begin
                    op1_alu <= rd1; // Read data from rs1 into alu
                    op2_alu <= rd2; // Read data from rs2
                end
                // I-type alu instructions
                7'b0010011: begin
                    op1_alu <= rd1; // Read data from rs1
                    op2_alu <= imm; // Immediate value
                end
                // I-type load instructions
                7'b0000011: begin
                    mem_funct3 <= funct3;
                    mem_read_address <= rd1 + imm; // Use rs1 value
                end
                // S-type store instructions
                7'b0100011: begin
                    mem_funct3 <= funct3;
                    mem_write_address <= rd1 + imm;
                    mem_write_data <= rd2;
                end
                // B-type branch instructions
                7'b1100011: begin
                    cmp_op1 <= rd1;
                    cmp_op2 <= rd2;
                end
                // J-type jal
                7'b1101111: begin
                    data <= PC_next;
                end
                // I type jalr
                7'b1100111: begin
                    data <= PC_next;
                end
                // U-type lui
                7'b0110111: begin
                    data <= imm;
                end
                // U type auipc
                7'b0010111: begin
                    data <= PC + imm; 
                end
            endcase
        end
        2: begin 
            // Writeback
            // Read register data from modules
            case (opcode)
                // R-type instructions
                7'b0110011: begin
                    data <= res_alu; // Result from ALU
                end
                // I-type alu instructions
                7'b0010011: begin
                    data <= res_alu; // Result from ALU
                end
                // I-type load instructions
                7'b0000011: begin
                    data <= mem_read_data; // Load word
                end
                // S-type store instructions
                //noop
                // B-type branch instructions
                7'b1100011: begin
                    if (flag_cmp) begin
                        PC_next <= PC + $signed(imm);
                    end
                end
                // J-type jal
                7'b1101111: begin
                    PC_next <= PC + $signed(imm);
                end
                // I type jalr
                7'b1100111: begin
                    PC_next <= rd1 + $signed(imm);
                end
                // U-type lui
                //noop
                // U type auipc
                7'b0010111: begin
                    PC_next <= data;
                end
            endcase
            write_enable <= 1;
            if (opcode == 7'b0100011) begin
                mem_write_enable <= 1;
            end
        end
        3: begin
            PC <= PC_next;
            // Update PC and close writes
            //Fetch
            write_enable <= 0;
            mem_write_enable <= 0;
            mem_write_data <= 0;
            mem_write_address <= 0;
            mem_funct3 <= 3'b010;
            mem_read_address <= PC_next;
        end
        endcase
        // Increment stage for next clock cycle
        stage <= stage + 1;
        if (stage > 4) begin
            stage <= 0; // Reset stage to 0 after completing the cycle
        end
end

endmodule