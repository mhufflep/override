#include <stdlib.h>
#include <stdio.h>

char a_user_name[100];

int verify_user_pass(char *pass) {
    return strncmp(pass, "admin", 5);
}

int verify_user_name(void) {
    puts("verifying username....\n");
    return strncmp(a_user_name, "dat_wil", 7);
}

int main() {

    int passed;
    char pass[64];

    // inlined memset
    memset(pass, 0, 64);

    puts("********* ADMIN LOGIN PROMPT *********");
    printf("Enter username: ");
    fgets(a_user_name, 0x100, stdin);

    passed = verify_user_name();
    if (passed != 0) {
        puts("nope, incorrect username...\n");
        return 1;
    }

    puts("Enter Password: ");
    fgets(pass, 0x64, stdin);

    passed = verify_user_pass(pass);
    if (passed == 0 || passed != 0) {
        puts("nope, incorrect password...\n");
        return 1;
    }

    return 0;
}