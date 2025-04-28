int main() {
    unsigned char* LED;
    unsigned int* timer;
    LED = (unsigned char*)0xFFFFFFFC; // user
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