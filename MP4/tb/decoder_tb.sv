`define assert(signal, value, test) \
        if (signal !== value) begin \
            $display({test,": Assertion FAILED in %m: signal != value"}); \
            $finish; \
        end else begin \
            $display({test,": Assertion passed in %m: signal == value"}); \
        end
`timescale 10ns/10ns
`include "decoder.sv"

module decoder_tb;

    logic [31:0] instruction;          // First 32-bit input
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [31:0] imm;   // Immediate value
    logic [4:0] rs1;    // Source register 1
    logic [4:0] rs2;    // Source register 2
    logic [4:0] rd;      // Destination register
    logic [6:0] opcode; // Opcode for instruction type
    logic clk; // Clock signal

    decoder u0 (
        .instruction(instruction),
        .funct3(funct3),
        .funct7(funct7),
        .imm(imm),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .clk(clk)
    );

    initial begin
        // Test case 1: R type instruction (SRA)
        instruction = 32'h4030d133;
        #10;
        `assert(funct3, 4'h5,"R funct3"); 
        `assert(funct7, 8'h20,"R funct7");
        `assert(rs1, 5'd1,"R rs1");
        `assert(rs2, 5'd3,"R rs2");
        `assert(rd, 5'd2,"R rd");
        `assert(opcode, 7'b0110011,"R opcode");
        #10;
        // Test case 2: I type instruction (addi)
        instruction = 32'h01710193;
        #10;
        `assert(funct3, 3'b000,"I funct3");
        `assert(imm, 32'd23,"I imm");
        `assert(rs1, 5'd2,"I rs1");
        `assert(rd, 5'd3,"I rd");
        `assert(opcode, 7'b0010011,"I opcode");
        #10;
        // Test case 3: I type instruction (lb)
        instruction = 32'hfe208103;
        #10;
        `assert(funct3, 3'b000,"I funct3");
        `assert(imm, 32'b11111111111111111111111111100010,"I imm"); //sign extend test
        `assert(rs1, 5'd1,"I rs1");
        `assert(rd, 5'd2,"I rd");
        `assert(opcode, 7'b0000011,"I opcode");
        #10;
        // Test case 4: I type instruction (jalr)
        instruction = 32'h00008167;
        #10;
        `assert(funct3, 3'b000,"I funct3");
        `assert(imm, 32'd0,"I imm");
        `assert(rs1, 5'd1,"I rs1");
        `assert(opcode, 7'b1100111,"I opcode");
        #10;
        // Test case 5: S type instruction (sw)
        instruction = 32'h003120a3;
        #10;
        `assert(funct3, 3'b010,"S funct3");
        `assert(imm, 32'd1,"S imm");
        `assert(rs1, 5'd2,"S rs1");
        `assert(rs2, 5'd3,"S rs2");
        `assert(opcode, 7'b0100011,"S opcode");
        #10;
        // Test case 6: B type instruction (beq)
        instruction = 32'h00310163;
        #10;
        `assert(funct3, 3'b000,"B funct3");
        `assert(imm, 32'd2,"B imm");
        `assert(rs1, 5'd2,"B rs1");
        `assert(rs2, 5'd3,"B rs2");
        `assert(opcode, 7'b1100011,"B opcode");
        #10;
        // Test case 7: U type instruction (lui)
        instruction = 32'h00028137;
        #10;
        `assert(imm, 32'd40 << 12,"U imm");
        `assert(rd, 5'd2,"U rd");
        `assert(opcode, 7'b0110111,"U opcode");
        #10;
        // Test case 8: J type instruction (jal)
        instruction = 32'h014001ef;
        #10;
        `assert(imm, 32'd20,"J imm");
        `assert(rd, 5'd3,"J rd");
        `assert(opcode, 7'b1101111,"J opcode");
        #10;
        $finish;
    end
    always begin
        #4
        clk = ~clk;
    end
endmodule