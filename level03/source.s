decrypt:
    push   %ebp
    mov    %esp,%ebp
    push   %edi
    push   %esi
    sub    $0x40,%esp

    ; stack canary
    mov    %gs:0x14,%eax
    mov    %eax,-0xc(%ebp)
    xor    %eax,%eax

   ; string: Q}|u`sfg~sf{}|a3
    movl   $0x757c7d51,-0x1d(%ebp)
    movl   $0x67667360,-0x19(%ebp)
    movl   $0x7b66737e,-0x15(%ebp)
    movl   $0x33617c7d,-0x11(%ebp)
    movb   $0x0,-0xd(%ebp)
   
    push   %eax
    xor    %eax,%eax
    je     0x804869b <decrypt+59>
    add    $0x4,%esp
    pop    %eax     ; 0x804869b <decrypt+59>

    ; inlined strlen
    lea    -0x1d(%ebp),%eax
    movl   $0xffffffff,-0x2c(%ebp)
    mov    %eax,%edx
    mov    $0x0,%eax
    mov    -0x2c(%ebp),%ecx
    mov    %edx,%edi
    repnz scas %es:(%edi),%al
    mov    %ecx,%eax
    not    %eax
    sub    $0x1,%eax

    mov    %eax,-0x24(%ebp)
    movl   $0x0,-0x28(%ebp)
    jmp    0x80486e5 <decrypt+133>

    ; while loop
    lea    -0x1d(%ebp),%eax     ; 0x80486c7 <decrypt+103>
    add    -0x28(%ebp),%eax
    movzbl (%eax),%eax
    mov    %eax,%edx
    mov    0x8(%ebp),%eax
    xor    %edx,%eax
    mov    %eax,%edx
    lea    -0x1d(%ebp),%eax
    add    -0x28(%ebp),%eax
    mov    %dl,(%eax)
    addl   $0x1,-0x28(%ebp)
    mov    -0x28(%ebp),%eax     ; 0x80486e5 <decrypt+133>
    cmp    -0x24(%ebp),%eax
    jb     0x80486c7 <decrypt+103>

    ; inlined strncmp
    lea    -0x1d(%ebp),%eax
    mov    %eax,%edx
    mov    $0x80489c3,%eax  ; "Congratulations!"
    mov    $0x11,%ecx
    mov    %edx,%esi
    mov    %eax,%edi
    repz cmpsb %es:(%edi),%ds:(%esi)
    seta   %dl
    setb   %al
    mov    %edx,%ecx
    sub    %al,%cl
    mov    %ecx,%eax
    movsbl %al,%eax

    test   %eax,%eax
    jne    0x8048723 <decrypt+195>

    movl   $0x80489d4,(%esp)        ; "/bin/sh"
    call   0x80484e0 <system@plt>

    jmp    0x804872f <decrypt+207>
    movl   $0x80489dc,(%esp)        ; 0x8048723 <decrypt+195>
    call   0x80484d0 <puts@plt>     ; "\nInvalid Password"
   
    ; stack canary
    mov    -0xc(%ebp),%esi      ; 0x804872f <decrypt+207>
    xor    %gs:0x14,%esi
    je     0x8048740 <decrypt+224>
    call   0x80484c0 <__stack_chk_fail@plt>

    add    $0x40,%esp
    pop    %esi
    pop    %edi
    pop    %ebp
    ret    


test:
    push   %ebp
    mov    %esp,%ebp
    sub    $0x28,%esp       ; 40 bytes allocated on stack

    mov    0x8(%ebp),%eax   ; 2nd arg, 0x1337d00d
    mov    0xc(%ebp),%edx   ; 1st arg, num

    mov    %edx,%ecx
    sub    %eax,%ecx        ; arg2 -= arg1

    mov    %ecx,%eax
    mov    %eax,-0xc(%ebp)
    cmpl   $0x15,-0xc(%ebp) ; compare with 21
    ja     0x804884a <test+259>

    ; switch case
    mov    -0xc(%ebp),%eax
    shl    $0x2,%eax        ; left shift
    add    $0x80489f0,%eax
    mov    (%eax),%eax
    jmp    *%eax

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    mov    -0xc(%ebp),%eax
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    jmp    0x8048858 <test+273>

    call   0x8048520 <rand@plt>     ; 0x804884a <test+259>
    mov    %eax,(%esp)
    call   0x8048660 <decrypt>
    nop

    leave  ; 0x8048858 <test+273>
    ret 

main:
    push   %ebp
    mov    %esp,%ebp
    and    $0xfffffff0,%esp
    sub    $0x20,%esp           ; 32 bytes allocated on stack

    push   %eax
    xor    %eax,%eax
    je     0x804886b <main+17>
    add    $0x4,%esp
    pop    %eax                 ; 0x804886b <main+17>

    movl   $0x0,(%esp)
    call   0x80484b0 <time@plt>

    mov    %eax,(%esp)
    call   0x8048500 <srand@plt>

    movl   $0x8048a48,(%esp)    ; '*' <repeats 35 times>
    call   0x80484d0 <puts@plt>

    movl   $0x8048a6c,(%esp)    ; "*\t\tlevel03\t\t**"
    call   0x80484d0 <puts@plt>
   
    movl   $0x8048a48,(%esp)    ; '*' <repeats 35 times>
    call   0x80484d0 <puts@plt>
   
    mov    $0x8048a7b,%eax      ; "Password:"
    mov    %eax,(%esp)
    call   0x8048480 <printf@plt>

    mov    $0x8048a85,%eax  
    lea    0x1c(%esp),%edx      ; local int
    mov    %edx,0x4(%esp)
    mov    %eax,(%esp)          ; "%d"
    call   0x8048530 <__isoc99_scanf@plt>

    mov    0x1c(%esp),%eax
    movl   $0x1337d00d,0x4(%esp)  ; 322424845
    mov    %eax,(%esp)            ; local int
    call   0x8048747 <test>
    
    mov    $0x0,%eax
    leave  
    ret 