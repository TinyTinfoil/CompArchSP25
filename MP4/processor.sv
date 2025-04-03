`include "memory.sv"
`include "decoder.sv"
`include "ALU.sv"
`include "registers.sv"
`include "compare.sv"
module top (
    input logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B,
    output logic LED
);
logic [31:0] PC;
logic [31:0] PC_next;
logic [31:0] instruction;
logic [2:0] funct3;
logic [6:0] funct7;
logic [31:0] imm;
logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;
logic [6:0] opcode;
logic write_enable;
logic [4:0] addr;
logic [31:0] data;
logic mem_write_enable;
logic [2:0] mem_funct3;
logic [31:0] mem_write_address;
logic [31:0] mem_write_data;
logic [31:0] mem_read_address;
logic [31:0] mem_read_data;
memory #(.INIT_FILE("rv32i_test.txt")) mem (
    .clk(clk),
    .write_mem(mem_write_enable),
    .funct3(mem_funct3),
    .write_address(mem_write_address),
    .write_data(mem_write_data),
    .read_address(mem_read_address),
    .read_data(mem_read_data),
    .led(LED),
    .red(RGB_R),
    .green(RGB_G),
    .blue(RGB_B)
);
logic [31:0] rd1;
logic [31:0] rd2;
registers registers (
    .read_addr1(rs1),   // Read address
    .read_addr2(rs2),   // Read address
    .write_addr(rd),   // Write address
    .write_enable(write_enable),   //write signal
    .write_data(data), // Data to write
    .read_data1(rd1), // Data read
    .read_data2(rd2)  // Data read
);
logic [31:0] op1;
logic [31:0] op2;
logic [31:0] res;
ALU alu (
    .A(op1),          // First 32-bit input
    .B(op2),          // Second 32-bit input
    .funct3(funct3),
    .funct7(funct7),
    .Result(res)                // 32-bit result
);
decoder d (
    .instruction (instruction),
    .funct3 (funct3),
    .funct7 (funct7),
    .imm (imm),
    .rs1 (rs1),
    .rs2 (rs2),
    .rd (rd),
    .opcode (opcode)
);
logic flag;
logic flag_cmp;
compare cmp (
    .A(op1),
    .B(op2),
    .funct3(funct3),
    .flag(flag_cmp)
);
initial begin
    PC = 0;
end
logic [2:0] stage;
initial begin
    stage = 0;
    PC = 0;
    PC_next = 0;
end

always_ff @( posedge clk ) begin
    case (stage)
    0: begin
        // Fetch
        mem_funct3 <= 3'b010;
        mem_read_address <= PC;
        instruction <= mem_read_data;
    end
    1: begin
        // Decode/execute
        case (opcode)
            // R-type instructions
            7'b0110011: begin
                op1 <= rd1; // Read data from rs1
                op2 <= rd2; // Read data from rs2
                data <= res; // Result from ALU
                write_enable <= 1; // Enable write to register file
                PC_next <= PC + 4;
            end
            // I-type alu instructions
            7'b0010011: begin
                op1 <= rd1; // Read data from rs1
                op2 <= imm; // Immediate value
                data <= res; // Result from ALU
                write_enable <= 1; // Enable write to register file
                PC_next <= PC + 4;
            end
            // I-type load instructions
            7'b0000011: begin
                mem_funct3 <= funct3;
                mem_read_address <= rd1 + imm; // Use rs1 value
                write_enable <= 1; // Enable write to register file
                PC_next <= PC + 4;
            end
            // S-type store instructions
            7'b0100011: begin
                mem_funct3 <= funct3;
                mem_write_address <= rd1 + imm;
                mem_write_data <= rd2;
                mem_write_enable <= 1;
                PC_next <= PC + 4;
            end
            // B-type branch instructions
            7'b1100011: begin
                op1 <= rd1;
                op2 <= rd2;
                flag <= flag_cmp; // Set the flag based on comparison
            end
            // U-type lui
            7'b0110111: begin
                data <= imm << 12;
                write_enable <= 1;
                PC_next <= PC + 4;
            end
            // U type auipc
            7'b0010111: begin
                data <= PC + (imm << 12);
                write_enable <= 1;
                PC_next <= PC + 4;
            end
            // J-type jal
            7'b1101111: begin
                data <= PC + 4;
                write_enable <= 1;
                PC_next <= PC + imm;
            end
            // I type jalr
            7'b1100111: begin
                data <= PC + 4;
                write_enable <= 1;
                PC_next <= rd1 + imm;
            end
        endcase
    end
    2: begin
        // Write back
        case (opcode)
        // I type load instructions
        7'b0000011: begin
            data <= mem_read_data;
            write_enable <= 1;
        end
        // S-type store instructions
        7'b0100011: begin
            mem_write_enable <= 0;
        end
        // B-type branch instructions
        7'b1100011: begin
            if (flag) begin
                PC_next <= PC + imm;
            end else begin
                PC_next <= PC + 4;
            end
        end
        endcase
    end
    3: begin
        write_enable <= 0;
        mem_write_enable <= 0;
        PC <= PC_next;
    end
    endcase
    // Increment stage for next clock cycle
    stage <= stage + 1;
end
endmodule