ADDI x1, x0, -4 // x1 = 0xFFFFFFFC, *leds
ADDI x2, x0, -8 // x2 = 0xFFFFFFF8, *timer
LW x3, 0(x2) // x3 = timer
ADDI x3, x3, 60 // x3 = delta (timer+60)
ADDI x7, x0, 14 // x7 = 14
RESET:
    ADDI x4, x0, 3 // x4 = next_led
    ADDI x5, x0, 0 // x5 = step_count
    j INCREMENT
LOOP:
    SW x4, 0(x1) // *leds = next_led
    LW x6, 0(x2) // x6 = timer
    bge x6, x3, INCREMENT # if x6 >= delta then increment
    j LOOP // else loop

INCREMENT:
    ADDI x5, x5, 1 // step_count++
    bge x5, x7, RESET # if step_count >= 14 then reset
    slli x4, x4, 1 // next_led = next_led << 1
    LW x3, 0(x2) // x3 = timer
    ADDI x3, x3, 60 // x3 = delta (timer+60)
    j LOOP


    