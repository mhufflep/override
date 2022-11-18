# level06

## Header

```bash
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
Partial RELRO   Canary found      NX enabled    No PIE          No RPATH   No RUNPATH   /home/users/level06/level06
```

<hr>

## Solution

From the [disassembled binary](./source.s) and the [source](./source.c) code we can see that program uses some
encryption and the `shell` will be created if we pass a string and a serial number that matches the string.

Encryption algorithm looks like this:
```c
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
```

So, I tried to look the `key` value in the `gdb`, but faced this:
```
.---------------------------.
| !! TAMPERING DETECTED !!  |
'---------------------------'
```

Then, I decided to copy the algorithm part, compile it in separate file, and see the `key` value:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int ac, char **av) {

    if (ac != 2) {
        return 1; 
    }

    size_t len = strlen(av[1]);
    int key = (av[1][3] ^ 0x1337) + 0x5eeded;
    for (size_t i = 0; i < len; i++) {
        if (av[1][i] < 32) {
            return 1;
        }
        key += (av[1][i] ^ key) % 0x539;
    }
    printf("%s %d\n", av[1], key);
    return 0;
}
```

Compile & run:
```bash
$ cd /var/crash
$ nano test.c
$ gcc -std=c99 test.c -o test
$ ./test xxxxxx
xxxxxx 6232806
```

As simple as that! We're ready to exploit:
```bash
level06@OverRide:~$ ./level06 
***********************************
*               level06           *
***********************************
-> Enter Login: xxxxxx
***********************************
***** NEW ACCOUNT DETECTED ********
***********************************
-> Enter Serial: 6232806
Authenticated!
$ whoami
level07
$ cd ../level07
$ ls -la
total 21
dr-xr-x---+ 1 level07 level07    80 Sep 13  2016 .
dr-x--x--x  1 root    root      260 Oct  2  2016 ..
-rw-r--r--  1 level07 level07   220 Sep 10  2016 .bash_logout
lrwxrwxrwx  1 root    root        7 Sep 13  2016 .bash_profile -> .bashrc
-rw-r--r--  1 level07 level07  3533 Sep 10  2016 .bashrc
-rwsr-s---+ 1 level08 users   11744 Sep 10  2016 level07
-rw-r--r--+ 1 level07 level07    41 Oct 19  2016 .pass
-rw-r--r--  1 level07 level07   675 Sep 10  2016 .profile
$ cat .pass
GbcPDRgsFK77LNnnuh7QyFYA2942Gp8yKj9KrWD8
```

## References
