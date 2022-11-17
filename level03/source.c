#include <stdlib.h>
#include <stdio.h>

void decrypt(int offset) {
    // stack protection here
    char encrypted[17] = "Q}|u`sfg~sf{}|a3";

    size_t len = strlen(encrypted);
    size_t i = 0;
    do {
        encrypted[i] ^= offset;
        i++;
    } while (i < len);
    

    if (!strncmp("Congratulations!", encrypted, 11)) {
        system("/bin/sh");
    } else {
        puts("\nInvalid Password");
    }
    // stack protection here
}

void test(int key1, int key2) {
    int offset = key2 - key1;

    switch (offset) {
        case 0x1:
        case 0x2:
        case 0x3:
        case 0x4:
        case 0x5:
        case 0x6:
        case 0x7:
        case 0x8:
        case 0x9:
        case 0x10:
        case 0x11:
        case 0x12:
        case 0x13:
        case 0x14:
        case 0x15: {
            decrypt(offset);
            break;
        }
        default: {   
            decrypt(rand());
            break;
        }
    }
}

int main(int ac, char **av) {

    int num;

    srand(time(0));

    puts("***********************************");
    puts("*\t\tlevel03\t\t**");
    puts("***********************************");
    printf("Password:");

    scanf("%d", &num);

    test(num, 322424845);

    return 0;
}