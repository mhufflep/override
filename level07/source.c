#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void clear_stdin(void) {
    int c;
    do {
        c = getchar();
        if (c == '\n') {
            break ;
        }
    } while (c != -1);
}

unsigned int get_unum(void) {
    unsigned int arr[3];

    arr[0] = 0;
    fflush(stdout);
    scanf("%u", arr);
    clear_stdin();
    return arr[0];
}

int read_number(char *buf) {
    unsigned int index;

    printf(" Index: ");
    index = get_unum();
    printf(" Number at data[%u] is %u\n", index, ((unsigned int *)buf)[index]);
    return 0;
}

int store_number(unsigned int *nums) {
    unsigned int num;
    unsigned int index;
  
    printf(" Number: ");
    num = get_unum();
    printf(" Index: ");
    index = get_unum();
    if ((index % 3 == 0) || (num >> 0x18 == 0xb7)) {
        puts(" *** ERROR! ***");
        puts("   This index is reserved for wil!");
        puts(" *** ERROR! ***");
        return 1;
    }
    nums[index] = num;
    return 0;
}

int main(int ac, char **av, char **env) {

    unsigned int nums[25];
    char **tmp_av = av;
    char **tmp_env = env;
    int ret;
    char cmd[20];

    memset(cmd, 0, 20);
    memset(nums, 0, 25 * sizeof(unsigned int));

    for (size_t i = 0; tmp_av[i]; i++) {
        memset(tmp_av[i], 0, strlen(tmp_av[i]));
    }

    for (size_t i = 0; tmp_env[i]; i++) {
        memset(tmp_env[i], 0, strlen(tmp_env[i]));
    }
    
    puts("----------------------------------------------------\n"
         "Welcome to wil\'s crappy number stora ge service!   \n"
         "----------------------------------------------------\n"
         "Commands:                                           \n"
         "    store - store a number into the data storage    \n"
         "    read   - read a number from the data storage    \n"
         "    quit  - exit the program                        \n"
         "----------------------------------------------------\n"
         "   wil has reserved some storage :>                 \n"
         "-------------------------------------------------");
    
    while (1) {

        printf("Input command: ");

        fgets(cmd, 20, stdin);
        cmd[strlen(cmd) - 1] = '\0';

        if (!strncmp(cmd, "store", 5)) {
            ret = store_number(nums);
        } else if (!strncmp(cmd, "read", 4)) {
            ret = read_number(nums);
        } else if (!strncmp(cmd, "quit", 4)) {
            break ;
        } 

        if (ret == 0) {
            printf(" Completed %s command successfully\n", cmd);
        } else {
            printf(" Failed to do %s command\n", cmd);
        }
        memset(cmd, 0, 20);        
    }

    return 0;
}