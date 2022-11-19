# level08

## Header

```bash
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
Full RELRO      Canary found      NX disabled   No PIE          No RPATH   No RUNPATH   /home/users/level08/level08
```

<hr>

## Solution

From the [disassembled binary](./source.s) and the [source](./source.c) code we can see that program uses some
encryption and the `shell` will be created if we pass a string and a serial number that matches the string.

<details>
<summary>To understand open attributes</summary>

You can find open attributes `0xc1` and `0x1b0` in this file:
```bash
    level08@OverRide:~$ nano /usr/include/x86_64-linux-gnu/bits/fcntl.h
```
</details>


## References
