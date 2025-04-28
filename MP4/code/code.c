__asm__("addi x2, x0, 0x7FF\n\t");
int main() {
    unsigned char* LED, *LED1, *LED2, *LED3;
    unsigned int* timer;
    LED = (unsigned char*)0xFFFFFFFF; // blue led
    LED1 = (unsigned char*)0xFFFFFFFE;
    LED2 = (unsigned char*)0xFFFFFFFD;
    LED3 = (unsigned char*)0xFFFFFFFC;
    unsigned char* currLED = LED;
    unsigned char* LEDs[] = {LED, LED1, LED2, LED3};
    timer = (unsigned int*)0xFFFFFFF4;
    int delta = 1;
    int t1 = 0;
    int i = 0;
    while (1){
        if (*timer - t1 > delta){
            t1 = *timer;
            *currLED += 60;
            if (*currLED > 0xFF) {
                *currLED = 0;
                currLED = LEDs[i];
                i = (i + 1) % 4;
            }
        }
    }
}