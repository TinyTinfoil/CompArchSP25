/* Type your code here, or load an example. */
int main() {
    unsigned int* LED, *timer;
    LED = (unsigned int*)0xFFFFFFFF;
    timer = (unsigned int*)0xFFFFFFF8;
    int delta = 200;
    int t1 = 0;
    while (1){
        if (*timer - t1 > delta){
            t1 = *timer;
            *LED += 1;
        }
    }
    
}