# level00

# Header

```bash
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
Partial RELRO   No canary found   NX enabled    No PIE          No RPATH   No RUNPATH   /home/users/level00/level00
```

<hr>

# Solution

Here is the part of the [disassembled binary](./source.s):
```c
    mov    %eax,(%esp)               ; "%d"
    call   0x80483d0 <__isoc99_scanf@plt>
    ...
    cmp    $0x149c,%eax              ; compare scanf result with 5276
    ...
    movl   $0x8048649,(%esp)         ; "/bin/sh"
    call   0x80483a0 <system@plt>
```

From these lines we can understand that binary takes a string, converts it to a number, and if this number is equal to `5276`, then the `system("/bin/sh")` will be executed.

```bash
level00@OverRide:~$ ./level00 
***********************************
*            -Level00 -           *
***********************************
Password:5276

Authenticated!
$ id
uid=1000(level00) gid=1000(level00) euid=1001(level01) egid=100(users) groups=1001(level01),100(users),1000(level00)
$ cat ../level01/.pass
uSq2ehEGT6c9S24zbshexZQBXUGrncxn5sD5QfGL
$ 
```