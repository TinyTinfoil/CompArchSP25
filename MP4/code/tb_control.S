addi x1, zero, 30 # x1 = 30
addi x2, zero, -20 # x2 = -20
addi x3, zero, 30 # x3 = 30
addi x4, zero, -20 # x4 = -20
beq x1, x2, ERROR # if x1 == x2, branch to ERROR
beq x1, x3, BEQ_I
addi x31, zero, 2 # set error reg
BEQ_I:
    beq x2, x4, BEQ_S
    addi x31, zero, 2 # set error reg
BEQ_S:
    blt x1, x3, ERROR
    bltu x2, x1, ERROR
    bne x2, x4, ERROR
    bne x1, x1, ERROR
    jal x0, SUCCESS
    
ERROR:
    addi x31, zero, 2 # set error reg
SUCCESS:
    addi x30, zero, 1 # set success reg


