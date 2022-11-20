#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct s_data {
    int len;
    char username[40];
    char msg[140];
};

void secret_backdoor(void) {
    char tmp[128];

    fgets(tmp, 128, stdin);
    system(tmp);
}

void set_username(struct s_data *data) {
    int i;
    char tmp[140];

    memset(tmp, 0, 128);
    puts(">: Enter your username");
    printf(">>: ");

    fgets(tmp, 128, stdin);

    for (i = 0; i <= 40 && tmp[i]; i++) {
        data->username[i] = tmp[i];
    }

    printf(">: Welcome, %s", data->username);
}

void set_msg(struct s_data *data) {
    char tmp[1024];

    memset(tmp, 0, 1024);
    puts(">: Msg @Unix-Dude");
    printf(">>: ");

    fgets(tmp, 1024, stdin);

    strncpy(data->msg, tmp, data->len);
}

void handle_msg() {
    struct s_data data;

    memset(data.username, 0, 40);

    data.len = 140;
    set_username(&data);
    set_msg(&data);
    puts(">: Msg sent!");
}

int main(void) {

    puts(
        "--------------------------------------------\n"
        "|   ~Welcome to l33t-m$n ~    v1337        |\n"
        "--------------------------------------------\n"
    );
    handle_msg();
    return 0;
}
