//  __asm__("li sp, 0x000000F8\n\t"); //set stack
//  __asm__("li ra, 0x000000FC\n\t"); //set ra
#define USER_LED_BITMASK  0xFF000000
#define RED_LED_BITMASK   0x00FF0000
#define GREEN_LED_BITMASK 0x0000FF00
#define BLUE_LED_BITMASK  0x000000FF

int main() {
    unsigned int* leds;
    unsigned int* timer;
    leds = (unsigned int*)0xFFFFFFFC; // all led address
    timer = (unsigned int*)0xFFFFFFF8;
    int t1 = 0;
    char i = 0;
    while (1){
        if (*timer - t1 > 600){
            t1 = *timer;
            if (i >= 32) {
                 i = 0;
                 *leds = 0;
            }
            *leds += 0xFF << i;
            i += 8;
        }
    }
}