addi x1, x0, 0xFFFFFFFE
lb x2, 0(x1) # load word from address in x1
addi x3, x0, 30 
sb x3, 0(x1) # store word to address in x1
