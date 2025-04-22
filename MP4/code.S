ADDI x1, x0, 4 
JALR x2, x1, 4
ADDI x3, x0, -1
ADDI x6, x0, 80
SB x0, 0(x3)
LB x4, 0(x3)
ADDI x5, x4, 20
SB x5, 0(x3)
BLTU x4, x6, -12
JAL x0, -20

