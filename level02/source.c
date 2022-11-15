#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int ac, char **av) {

    FILE *file = 0;
    size_t ret;
    char name[100];
    char token[48];
    char pass[112];

    memset(name, 0, 100);
    memset(token, 0, 41);
    memset(pass, 0, 100);

    file = fopen("/home/users/level03/.pass", "r");
    if (file == 0) {
        fwrite("ERROR: failed to open password file\n", 1, 36, stderr);
        exit(1);
    }

    size_t ret = fread(token, 1, 41, file);
    token[strcspn(token, "\n")] = '\0';

    if (ret != 41) {
        fwrite("ERROR: failed to read password file\n", 1, 36, stderr);
        fwrite("ERROR: failed to read password file\n", 1, 36, stderr);
        exit(1);
    }

    fclose(file);

    puts("===== [ Secure Access System v1.0 ] =====");
    puts("/***************************************\\");
    puts("| You must login to access this system. |");
    puts("\\**************************************/");

    printf("--[ Username: ");
    fgets(name, 100, stdin);
    name[strcspn(name, "\n")] = '\0';

    printf("--[ Password: ");
    fgets(pass, 100, stdin);
    pass[strcspn(pass, "\n")] = '\0';

    puts("*****************************************");
    if (strncmp(token, pass, 41) != 0) {
        printf(name);
        puts(" does not have access!");
        exit(1);
    }

    printf("Greetings, %s!\n", name);
    system("/bin/sh");
    return 0;
}