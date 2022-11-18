auth:
    push   %ebp
    mov    %esp,%ebp
    sub    $0x28,%esp           ; 40 bytes allocated on stack

    movl   $0x8048a63,0x4(%esp) ; "\n"
    mov    0x8(%ebp),%eax
    mov    %eax,(%esp)          ; first arg
    call   0x8048520 <strcspn@plt>
    add    0x8(%ebp),%eax
    movb   $0x0,(%eax)

    movl   $0x20,0x4(%esp)
    mov    0x8(%ebp),%eax
    mov    %eax,(%esp)          ; first arg
    call   0x80485d0 <strnlen@plt>
    mov    %eax,-0xc(%ebp)
   
    push   %eax
    xor    %eax,%eax
    je     0x8048785 <auth+61>
    add    $0x4,%esp
    pop    %eax                 ; 0x8048785 <auth+61>

    cmpl   $0x5,-0xc(%ebp)
    jg     0x8048796 <auth+78>

    mov    $0x1,%eax
    jmp    0x8048877 <auth+303>

    movl   $0x0,0xc(%esp)       ; 0x8048796 <auth+78>
    movl   $0x1,0x8(%esp)
    movl   $0x0,0x4(%esp)
    movl   $0x0,(%esp)
    call   0x80485f0 <ptrace@plt>

    cmp    $0xffffffff,%eax     ; -1
    jne    0x80487ed <auth+165>

    movl   $0x8048a68,(%esp)    ; "\033[32m.", '-' <repeats 27 times>, "."
    call   0x8048590 <puts@plt>
    movl   $0x8048a8c,(%esp)    ; "\033[31m| !! TAMPERING DETECTED !!  |"
    call   0x8048590 <puts@plt>
    movl   $0x8048ab0,(%esp)    ; "\033[32m'", '-' <repeats 27 times>, "'"
    call   0x8048590 <puts@plt>
    mov    $0x1,%eax
    jmp    0x8048877 <auth+303>

    mov    0x8(%ebp),%eax       ; 0x80487ed <auth+165>
    add    $0x3,%eax
    movzbl (%eax),%eax
    movsbl %al,%eax
    xor    $0x1337,%eax
    add    $0x5eeded,%eax
    mov    %eax,-0x10(%ebp)

    movl   $0x0,-0x14(%ebp)     ; loop counter initialization
    jmp    0x804885b <auth+275>

    mov    -0x14(%ebp),%eax     ; 0x804880f <auth+199>
    add    0x8(%ebp),%eax
    movzbl (%eax),%eax
    cmp    $0x1f,%al            ; comparing with 31
    jg     0x8048823 <auth+219>

    mov    $0x1,%eax
    jmp    0x8048877 <auth+303> ; returning

    mov    -0x14(%ebp),%eax     ; 0x8048823 <auth+219>
    add    0x8(%ebp),%eax       ;
    movzbl (%eax),%eax          ;
    movsbl %al,%eax             ;
    mov    %eax,%ecx            ;
    xor    -0x10(%ebp),%ecx     ;
    mov    $0x88233b2b,%edx     ;
    mov    %ecx,%eax            ;
    mul    %edx                 ; key += (buf[i] ^ key) % 0x539;
    mov    %ecx,%eax            ;
    sub    %edx,%eax            ;
    shr    %eax                 ;
    add    %edx,%eax            ;
    shr    $0xa,%eax            ;
    imul   $0x539,%eax,%eax     ;
    mov    %ecx,%edx            ;
    sub    %eax,%edx            ;
    mov    %edx,%eax            ;
    add    %eax,-0x10(%ebp)     ;
   
    addl   $0x1,-0x14(%ebp)

    mov    -0x14(%ebp),%eax     ; 0x804885b <auth+275>
    cmp    -0xc(%ebp),%eax
    jl     0x804880f <auth+199>

    mov    0xc(%ebp),%eax
    cmp    -0x10(%ebp),%eax
    je     0x8048872 <auth+298>
    mov    $0x1,%eax
    jmp    0x8048877 <auth+303>
    
    mov    $0x0,%eax            ; 0x8048872 <auth+298>
    leave                       ; 0x8048877 <auth+303>
    ret 


main:
    push   %ebp
    mov    %esp,%ebp
    and    $0xfffffff0,%esp
    sub    $0x50,%esp           ; 80 bytes allocated on stack

    mov    0xc(%ebp),%eax
    mov    %eax,0x1c(%esp)      ; av[0] ?

   ; stack canary
    mov    %gs:0x14,%eax
    mov    %eax,0x4c(%esp)
    xor    %eax,%eax

    push   %eax
    xor    %eax,%eax
    je     0x804889d <main+36>
    add    $0x4,%esp
    pop    %eax                 ; 0x804889d <main+36>

    movl   $0x8048ad4,(%esp)    ; '*' <repeats 35 times>
    call   0x8048590 <puts@plt>

    movl   $0x8048af8,(%esp)    ; "*\t\tlevel06\t\t  *"
    call   0x8048590 <puts@plt>

    movl   $0x8048ad4,(%esp)    ; '*' <repeats 35 times>
    call   0x8048590 <puts@plt>

    mov    $0x8048b08,%eax  
    mov    %eax,(%esp)          ; "-> Enter Login: "
    call   0x8048510 <printf@plt>

    mov    0x804a060,%eax
    mov    %eax,0x8(%esp)       ; stdin
    movl   $0x20,0x4(%esp)      ; size = 32
    lea    0x2c(%esp),%eax
    mov    %eax,(%esp)
    call   0x8048550 <fgets@plt>

    movl   $0x8048ad4,(%esp)    ; '*' <repeats 35 times>
    call   0x8048590 <puts@plt>

    movl   $0x8048b1c,(%esp)    ; "***** NEW ACCOUNT DETECTED ********"
    call   0x8048590 <puts@plt>

    movl   $0x8048ad4,(%esp)    ; '*' <repeats 35 times>
    call   0x8048590 <puts@plt>

    mov    $0x8048b40,%eax
    mov    %eax,(%esp)          ; "-> Enter Serial: "
    call   0x8048510 <printf@plt>

    mov    $0x8048a60,%eax
    lea    0x28(%esp),%edx
    mov    %edx,0x4(%esp)       ; local var
    mov    %eax,(%esp)          ; "%u"
    call   0x80485e0 <__isoc99_scanf@plt>

    mov    0x28(%esp),%eax
    mov    %eax,0x4(%esp)
    lea    0x2c(%esp),%eax
    mov    %eax,(%esp)
    call   0x8048748 <auth>

    test   %eax,%eax
    jne    0x8048969 <main+240>

    movl   $0x8048b52,(%esp)    ; "Authenticated!"
    call   0x8048590 <puts@plt>

    movl   $0x8048b61,(%esp)    ; "/bin/sh"
    call   0x80485a0 <system@plt>

    mov    $0x0,%eax
    jmp    0x804896e <main+245>

    mov    $0x1,%eax            ; 0x8048969 <main+240>

    ; stack canary
    mov    0x4c(%esp),%edx      ; 0x804896e <main+245>
    xor    %gs:0x14,%edx
    je     0x8048980 <main+263>
    call   0x8048580 <__stack_chk_fail@plt>
    
    leave                       ; 0x8048980 <main+263>
    ret  