#include <stdlib.h>
#include <stdio.h>

int main() {

    int res;

    puts("***********************************");
    puts("* \t     -Level00 -\t\t  *");
    puts("***********************************");

    printf("Password:");
    scanf("%d", res);

    if (res != 5276) {
        puts("\nInvalid Password!");
        return 1;
    }

    puts("\nAuthenticated!");
    system("/bin/sh");

    return 0;
}