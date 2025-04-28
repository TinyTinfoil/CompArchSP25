__asm__("addi x2, x0, 0x7FF\n\t");
int main() {
    unsigned char* LED;
    unsigned int* timer;
    LED = (unsigned char*)0xFFFFFFFF;
    timer = (unsigned int*)0xFFFFFFF8;
    int delta = 200;
    int t1 = 0;
    while (1){
        *LED = ~(*LED);
    }
    
}