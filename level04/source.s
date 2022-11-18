main:
    push   %ebp
    mov    %esp,%ebp
    push   %edi
    push   %ebx
    and    $0xfffffff0,%esp
    sub    $0xb0,%esp           ; 176 bytes allocated on stack

    call   0x8048550 <fork@plt>
    mov    %eax,0xac(%esp)

    ; inlined memset or bzero
    lea    0x20(%esp),%ebx
    mov    $0x0,%eax
    mov    $0x20,%edx
    mov    %ebx,%edi
    mov    %edx,%ecx
    rep stos %eax,%es:(%edi)

    movl   $0x0,0xa8(%esp)
    movl   $0x0,0x1c(%esp)

    ; check for child process
    cmpl   $0x0,0xac(%esp)
    jne    0x8048769 <main+161>

    movl   $0x1,0x4(%esp)
    movl   $0x1,(%esp)
    call   0x8048540 <prctl@plt>

    movl   $0x0,0xc(%esp)
    movl   $0x0,0x8(%esp)
    movl   $0x0,0x4(%esp)
    movl   $0x0,(%esp)
    call   0x8048570 <ptrace@plt>

    movl   $0x8048903,(%esp)    ; "Give me some shellcode, k"
    call   0x8048500 <puts@plt>

    lea    0x20(%esp),%eax
    mov    %eax,(%esp)
    call   0x80484b0 <gets@plt>
    jmp    0x804881a <main+338>
    
    nop                         ; 0x8048768 <main+160>

    lea    0x1c(%esp),%eax      ; 0x8048769 <main+161>
    mov    %eax,(%esp)          ; &status
    call   0x80484f0 <wait@plt>

    ; WIFEXITED
    mov    0x1c(%esp),%eax
    mov    %eax,0xa0(%esp)
    mov    0xa0(%esp),%eax
    and    $0x7f,%eax
    test   %eax,%eax
    je     0x80487ac <main+228>
    ; status & 7f == 0

    ; WIFSIGNALED
    mov    0x1c(%esp),%eax
    mov    %eax,0xa4(%esp)
    mov    0xa4(%esp),%eax
    and    $0x7f,%eax
    add    $0x1,%eax
    sar    %al                  ; signed shift right (saves sign bit)
    test   %al,%al
    jle    0x80487ba <main+242>
    ; ((status & 7f) + 1 >> 1) > 0

    movl   $0x804891d,(%esp)    ; 0x80487ac <main+228>
    call   0x8048500 <puts@plt> ; "child is exiting..."
    jmp    0x804881a <main+338> ; exiting

    movl   $0x0,0xc(%esp)       ; 0x80487ba <main+242>
    movl   $0x2c,0x8(%esp)
    mov    0xac(%esp),%eax
    mov    %eax,0x4(%esp)
    movl   $0x3,(%esp)
    call   0x8048570 <ptrace@plt>
    mov    %eax,0xa8(%esp)
    cmpl   $0xb,0xa8(%esp)      ; compare res to 11
    jne    0x8048768 <main+160>

    movl   $0x8048931,(%esp)    ; "no exec() for you"
    call   0x8048500 <puts@plt>

    movl   $0x9,0x4(%esp)       ; signal, SIGKILL or SIGTERM
    mov    0xac(%esp),%eax     
    mov    %eax,(%esp)          ; pid
    call   0x8048520 <kill@plt>

    nop
    mov    $0x0,%eax            ; 0x804881a <main+338>
    lea    -0x8(%ebp),%esp
    pop    %ebx
    pop    %edi
    pop    %ebp
    ret  