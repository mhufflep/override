#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int auth(char *buf, unsigned int num) {

    buf[strcspn(buf, "\n")] = '\0';

    size_t len = strnlen(buf, 32);

    if (len <= 5) {
        return 1;
    }

    if (ptrace(0, 0, 1, 0) == -1) {
        puts("\033[32m.---------------------------.");
        puts("\033[31m| !! TAMPERING DETECTED !!  |");
        puts("\033[32m'---------------------------'");
        return 1;
    }

    int key = (buf[3] ^ 0x1337) + 0x5eeded;
    for (size_t i = 0; i < len; i++) {
        if (buf[i] < 32) {
            return 1;
        }
        key += (buf[i] ^ key) % 0x539;
    }

    if (key != num) {
        return 1;
    }

    return 0;
}

int main() {

    char buf[32];
    unsigned int num;

    puts("***********************************");
    puts("*\t\tlevel06\t\t  *");
    puts("***********************************");
    printf("-> Enter Login: ");
    fgets(buf, 32, stdin);

    puts("***********************************");
    puts("*\t\tlevel06\t\t  *");
    puts("***********************************");
    printf("-> Enter Serial: ");
    scanf("%u", &num);

    if (auth(buf, num) == 0) {
        puts("Authenticated!");
        system("/bin/sh");
        return 0;
    }

    return 1;
}