int main() {
    unsigned char* LED;
    unsigned char* RED;
    unsigned char* GREEN;
    unsigned char* BLUE;
    unsigned int* timer;
    LED = (unsigned char*)0xFFFFFFFF;
    RED = (unsigned char*)0xFFFFFFFE;
    GREEN = (unsigned char*)0xFFFFFFFD;
    BLUE = (unsigned char*)0xFFFFFFFC;
    timer = (unsigned int*)0xFFFFFFF8;
    int delta = 200;
    int t1 = 0;
    while (1){
        if (*timer - t1 > delta){
            t1 = *timer;
            *LED += 40;
            *RED += 30;
            *GREEN += 15;
            *BLUE += 5;
            if (*LED > 0xFF) {
                *LED = 0;
            }
            if (*RED > 0xFF) {
                *RED = 0;
            }
            if (*GREEN > 0xFF) {
                *GREEN = 0;
            }
            if (*BLUE > 0xFF) {
                *BLUE = 0;
            }
        }
    }
    
}