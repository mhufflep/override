#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

int main() {

    int n = 0;
    char buf[100];
    fgets(buf, 100, stdin);
    
    n = 0;
    while (n <= strlen(buf)) {
        if (isupper(buf[n])) {
            buf[n] += 32;
        }
        n++;
    }

    printf(buf);
    exit(0);
}