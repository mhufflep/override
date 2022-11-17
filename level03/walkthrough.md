# level03

## Header

```bash
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
Partial RELRO   Canary found      NX enabled    No PIE          No RPATH   No RUNPATH   /home/users/level03/level03
```

<hr>

## Solution

From the [disassembled binary](./source.s) and the [source](./source.c) code, we can understand that `system("/bin/sh")` will be executed if string will be decrypted properly.

The algorithm used for encryption called `XOR cipher` or
`XOR encryption` and it is primitive as hell: <br>
For every character in the given message resulting character is calculated by bitwise `xor`ing it with some key. 

Here is what encrypted string looks like in [disassembled code](./source.s):
```c
    movl   $0x757c7d51,-0x1d(%ebp)
    movl   $0x67667360,-0x19(%ebp)
    movl   $0x7b66737e,-0x15(%ebp)
    movl   $0x33617c7d,-0x11(%ebp)
    movb   $0x0,-0xd(%ebp)
```

We will use this, to get readable form:
```python
print "\x75\x7c\x7d\x51"[::-1] + \
      "\x67\x66\x73\x60"[::-1] + \
      "\x7b\x66\x73\x7e"[::-1] + \
      "\x33\x61\x7c\x7d"[::-1]
```

Let's look at the strings:
```
encrypted: "Q}|u`sfg~sf{}|a3"
decrypted: "Congratulations!"
```

Here is the table that represents all these characters in binary form:
| ASCII (dec) | bin | bin | ASCII (enc) |
| :---: | :---: | :---: | :---: |
| C | 01000011 | 01010001 | Q |
| o | 01101111 | 01111101 | } |
| n | 01101110 | 01111100 | | |
| g | 01100111 | 01110101 | u |
| r | 01110010 | 01100000 | ` |
| a | 01100001 | 01110011 | s |
| t | 01110100 | 01100110 | f |
| u | 01110101 | 01100111 | g |
| l | 01101100 | 01111110 | ~ |
| a | 01100001 | 01110011 | s |
| t | 01110100 | 01100110 | f |
| i | 01101001 | 01111011 | { |
| o | 01101111 | 01111101 | } |
| n | 01101110 | 01111100 | | |
| s | 01110011 | 01100001 | a |
| ! | 00100001 | 00110011 | 3 |


A little reminder about `xor` operation:
| A     | B     | A ^ B |
| :---: | :---: | :---: |
| 0     |   0   |   0   |
| 0     |   1   |   1   |
| 1     |   0   |   1   |
| 1     |   1   |   0   |


Let's get our first pair to calcalate the offset:
```
C 01000011
^ 00010010   = 18 in decimal
Q 01010001
```

Or just simply:
```bash
$ python -c "print ord('C') ^ ord('Q')"
18
```

Now we know the offset is equal to `18`.

From [decompiled code](./source.c) we can see how this offset is calculated:
```c
void test(int key1, int key2) {
    ...
    int offset = key2 - key1;
    ...
}

int main(int ac, char **av) {
    ...
    test(num, 322424845);
    ...
}
```

Yes, it is calculated by subtracting `num` from `322424845`!

So, to get the password, we need to use hard math skills:
```
322424845 - 18 = 322424827
```

Finally, let's move to the next level:
```bash
level03@OverRide:~$ ./level03 
***********************************
*               level03         **
***********************************
Password:322424827
$ whoami
level04
$ cd ../level04
$ ls -la
total 17
dr-xr-x---+ 1 level04 level04   80 Sep 13  2016 .
dr-x--x--x  1 root    root     260 Oct  2  2016 ..
-rw-r--r--  1 level04 level04  220 Sep 10  2016 .bash_logout
lrwxrwxrwx  1 root    root       7 Sep 13  2016 .bash_profile -> .bashrc
-rw-r--r--  1 level04 level04 3533 Sep 10  2016 .bashrc
-rwsr-s---+ 1 level05 users   7797 Sep 10  2016 level04
-rw-r--r--+ 1 level04 level04   41 Oct 19  2016 .pass
-rw-r--r--  1 level04 level04  675 Sep 10  2016 .profile
$ cat .pass
kgv3tkEb9h2mLkRsPkXRfc2mHbjMxQzvb2FrgKkf
```

## References
- [XOR cipher](https://www.geeksforgeeks.org/xor-cipher/)
- [GS in asm](https://stackoverflow.com/questions/9249315/what-is-gs-in-assembly)
- [stack canary](https://xorl.wordpress.com/2010/10/14/linux-glibc-stack-canary-values/)
