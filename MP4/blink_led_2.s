addi x1, x0, 255
lui x2, -1
ori x2, x2, -8
lui x3, -1
ori x3, x3, -1
addi x4, x0, 2
lb x5, 0(x2)
bgeu x5, x4, 8
jalr x0, 0(x0)
lb x6, 0(x3)
xor x6, x6, x0
sb x6, 0(x3)
addi x4, x5, 2
jalr x0, 0(x0)