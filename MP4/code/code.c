int main() {
    unsigned int* LED;
    unsigned int* timer;
    LED = (unsigned int*)0xFFFFFFFF;
    // LED1 = (unsigned char*)0xFFFFFFFE;
    // LED2 = (unsigned char*)0xFFFFFFFD;
    // LED3 = (unsigned char*)0xFFFFFFFC;
    timer = (unsigned int*)0xFFFFFFF8;
    int delta = 200;
    int t1 = 0;
    while (1){
        if (*timer - t1 > delta){
            t1 = *timer;
            *LED += 60;
            if (*LED > 0xFF) {
                *LED = 0;
            }
        }
    }
    
}