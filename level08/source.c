#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

void log_wrapper(FILE *file, char *src, char *format) {
    char buf[272];

    strcpy(buf, src);
    snprintf(buf, 254 - strlen(buf), format, strlen(buf));
    buf[strcspn(buf, "\n")] = '\0';
    fprintf(file, "LOG: %s\n", buf);
}

int main(int ac, char **av) {

    char filepath[104];
    char c = -1;
    int fd = -1;
    FILE *file;
    FILE *log;

    if (ac != 2) {
        printf("Usage: %s filename\n", av[0]);
    }

    log = fopen("./backups/.log", "w");
    if (log == NULL) {
        printf("ERROR: Failed to open %s\n", "./backups/.log");
        exit(1);
    }

    log_wrapper(log, "Starting back up: ", av[1]);

    file = fopen(av[1], "r");
    if (file == NULL) {
        printf("ERROR: Failed to open %s\n", av[1]);
        exit(1);
    }

    strcpy(filepath, "./backups/");
    strncat(filepath, av[1], 99 - strlen(filepath));
    fd = open(filepath, O_CREAT | O_EXCL | O_WRONLY, 0600);
    if (fd < 0) {
        printf("ERROR: Failed to open %s%s\n", "./backups", av[1]);
        exit(1);
    }

    while ((c = fgetc(file)) != EOF) {
        write(fd, &c, 1);
    }

    log_wrapper(log, "Finished back up ", av[1]);
    fclose(file);
    close(fd);

    return 0;
}
