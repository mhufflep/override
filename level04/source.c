#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <sys/ptrace.h>

int main() {

    pid_t pid;
    long res;
    int s1;
    int s2;
    char buf[32];
    int status;

    pid = fork();

    memset(buf, 0, 32);
    res = 0;  
    status = 0; 

    if (pid == 0) {
        prctl(PR_SET_PDEATHSIG, SIGHUP);
        ptrace(PTRACE_TRACEME, 0, 0, 0);
        puts("Give me some shellcode, k");
        gets(buf);
        return 0;
    }

    do {
        wait(&status);
        s1 = status;
        s2 = status;
        if (WIFEXITED(s1) || WIFSIGNALED(s2)) {
            puts("child is exiting...");
            return 0;
        }
        res = ptrace(PTRACE_PEEKUSER, pid, 44, 0);  // xgs in user_regs_struct
    } while (res != 11);

    puts("no exec() for you");
    kill(pid, SIGKILL);
    
    return 0;
}