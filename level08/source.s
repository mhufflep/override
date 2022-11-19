log_wrapper:
    push   %rbp
    mov    %rsp,%rbp
    sub    $0x130,%rsp          ; 304 bytes allocated on stack

    mov    %rdi,-0x118(%rbp)
    mov    %rsi,-0x120(%rbp)
    mov    %rdx,-0x128(%rbp)

    ; stack canary
    mov    %fs:0x28,%rax
    mov    %rax,-0x8(%rbp)
    xor    %eax,%eax
   
    mov    -0x120(%rbp),%rdx
    lea    -0x110(%rbp),%rax
    mov    %rdx,%rsi            ; src = arg2
    mov    %rax,%rdi            ; dst = local buffer
    callq  0x4006f0 <strcpy@plt>

    mov    -0x128(%rbp),%rsi

    ; inlined strlen
    lea    -0x110(%rbp),%rax
    movq   $0xffffffffffffffff,-0x130(%rbp)
    mov    %rax,%rdx
    mov    $0x0,%eax
    mov    -0x130(%rbp),%rcx
    mov    %rdx,%rdi
    repnz scas %es:(%rdi),%al
    mov    %rcx,%rax
    not    %rax
    lea    -0x1(%rax),%rdx

    mov    $0xfe,%eax
    mov    %rax,%r8
    sub    %rdx,%r8     ; 0xfe - strlen(buf) 

    ; inlined strlen
    lea    -0x110(%rbp),%rax
    movq   $0xffffffffffffffff,-0x130(%rbp)
    mov    %rax,%rdx
    mov    $0x0,%eax
    mov    -0x130(%rbp),%rcx
    mov    %rdx,%rdi
    repnz scas %es:(%rdi),%al
    mov    %rcx,%rax
    not    %rax
    lea    -0x1(%rax),%rdx

    lea    -0x110(%rbp),%rax
    add    %rdx,%rax            ; strlen(buf)
    mov    %rsi,%rdx            ; arg3
    mov    %r8,%rsi             ; 0xfe - strlen(buf)
    mov    %rax,%rdi            ; local buf
    mov    $0x0,%eax
    callq  0x400740 <snprintf@plt>
    ; int snprintf(char *str, size_t size, const char *format, ...);

    lea    -0x110(%rbp),%rax    ; local buf
    mov    $0x400d4c,%esi       ; "\n"
    mov    %rax,%rdi
    callq  0x400780 <strcspn@plt>
    movb   $0x0,-0x110(%rbp,%rax,1)

    mov    $0x400d4e,%ecx
    lea    -0x110(%rbp),%rdx    ; local buf   
    mov    -0x118(%rbp),%rax
    mov    %rcx,%rsi            ; "LOG: %s\n"
    mov    %rax,%rdi            ; FILE *file 
    mov    $0x0,%eax
    callq  0x4007a0 <fprintf@plt>
    ; int fprintf(FILE *stream, const char *format, ...);

    ; stack canary
    mov    -0x8(%rbp),%rax
    xor    %fs:0x28,%rax
    je     0x4009ee <log_wrapper+298>
    callq  0x400720 <__stack_chk_fail@plt>
   
    leaveq  ;0x4009ee <log_wrapper+298>
    retq 

main:
    push   %rbp
    mov    %rsp,%rbp
    sub    $0xb0,%rsp           ; 120 bytes allocated on stack

    mov    %edi,-0x94(%rbp)     ; ac
    mov    %rsi,-0xa0(%rbp)     ; av

    ; stack canary
    mov    %fs:0x28,%rax
    mov    %rax,-0x8(%rbp)
    xor    %eax,%eax

    movb   $0xff,-0x71(%rbp)
    movl   $0xffffffff,-0x78(%rbp)

    cmpl   $0x2,-0x94(%rbp)
    je     0x400a4a <main+90>

    mov    -0xa0(%rbp),%rax
    mov    (%rax),%rdx
    mov    $0x400d57,%eax
    mov    %rdx,%rsi        ; av[0]
    mov    %rax,%rdi        ; "Usage: %s filename\n"
    mov    $0x0,%eax
    callq  0x400730 <printf@plt>

    mov    $0x400d6b,%edx   ; 0x400a4a <main+90>
    mov    $0x400d6d,%eax   
    mov    %rdx,%rsi        ; "w"
    mov    %rax,%rdi        ; "./backups/.log"  
    callq  0x4007c0 <fopen@plt>
    mov    %rax,-0x88(%rbp)
    cmpq   $0x0,-0x88(%rbp)
    jne    0x400a91 <main+161>

    mov    $0x400d7c,%eax   ; "ERROR: Failed to open %s\n"
    mov    $0x400d6d,%esi   ; "./backups/.log"
    mov    %rax,%rdi
    mov    $0x0,%eax
    callq  0x400730 <printf@plt>
    mov    $0x1,%edi
    callq  0x4007d0 <exit@plt>

    mov    -0xa0(%rbp),%rax ; 0x400a91 <main+161>
    add    $0x8,%rax
    mov    (%rax),%rdx      ; av[1]
    mov    -0x88(%rbp),%rax
    mov    $0x400d96,%esi   ; "Starting back up: "
    mov    %rax,%rdi        ; FILE *log
    callq  0x4008c4 <log_wrapper>

    mov    $0x400da9,%edx
    mov    -0xa0(%rbp),%rax
    add    $0x8,%rax
    mov    (%rax),%rax
    mov    %rdx,%rsi        ; "r"
    mov    %rax,%rdi        ; av[1]
    callq  0x4007c0 <fopen@plt>
    mov    %rax,-0x80(%rbp)
    cmpq   $0x0,-0x80(%rbp)
    jne    0x400b09 <main+281>

    mov    -0xa0(%rbp),%rax
    add    $0x8,%rax
    mov    (%rax),%rdx
    mov    $0x400d7c,%eax   
    mov    %rdx,%rsi        ; av[1]
    mov    %rax,%rdi        ; "ERROR: Failed to open %s\n"
    mov    $0x0,%eax
    callq  0x400730 <printf@plt>

    mov    $0x1,%edi
    callq  0x4007d0 <exit@plt>

    ; ./backups/ copied to local buf
    mov    $0x400dab,%edx   ; 0x400b09 <main+281>
    lea    -0x70(%rbp),%rax
    mov    (%rdx),%rcx
    mov    %rcx,(%rax)
    movzwl 0x8(%rdx),%ecx
    mov    %cx,0x8(%rax)
    movzbl 0xa(%rdx),%edx
    mov    %dl,0xa(%rax)

    ; inlined strlen
    lea    -0x70(%rbp),%rax
    movq   $0xffffffffffffffff,-0xa8(%rbp)
    mov    %rax,%rdx
    mov    $0x0,%eax
    mov    -0xa8(%rbp),%rcx
    mov    %rdx,%rdi
    repnz scas %es:(%rdi),%al
    mov    %rcx,%rax
    not    %rax

    lea    -0x1(%rax),%rdx
    mov    $0x63,%eax   ;
    mov    %rax,%rcx    ; 99 - strlen(filepath)
    sub    %rdx,%rcx    ;
    mov    %rcx,%rdx    ;
    mov    -0xa0(%rbp),%rax
    add    $0x8,%rax
    mov    (%rax),%rax
    mov    %rax,%rcx
    lea    -0x70(%rbp),%rax
    mov    %rcx,%rsi
    mov    %rax,%rdi
    callq  0x400750 <strncat@plt>

    lea    -0x70(%rbp),%rax
    mov    $0x1b0,%edx          ; access rights = 0660
    mov    $0xc1,%esi           ; O_CREAT | O_EXCL | O_WRONLY
    mov    %rax,%rdi            ; backup filepath
    mov    $0x0,%eax
    callq  0x4007b0 <open@plt>
    mov    %eax,-0x78(%rbp)     ; saved fd

    cmpl   $0x0,-0x78(%rbp)
    jns    0x400bed <main+509>

    mov    -0xa0(%rbp),%rax
    add    $0x8,%rax
    mov    (%rax),%rdx          ; av[1]
    mov    $0x400db6,%eax   
    mov    $0x400dab,%esi       ; "./backups/"
    mov    %rax,%rdi            ; "ERROR: Failed to open %s%s\n"
    mov    $0x0,%eax
    callq  0x400730 <printf@plt>

    mov    $0x1,%edi
    callq  0x4007d0 <exit@plt>

    ; copying
    lea    -0x71(%rbp),%rcx ; 0x400bd5 <main+485>
    mov    -0x78(%rbp),%eax
    mov    $0x1,%edx
    mov    %rcx,%rsi
    mov    %eax,%edi
    callq  0x400700 <write@plt>
    jmp    0x400bee <main+510>

    nop                     ; 0x400bed <main+509>
    mov    -0x80(%rbp),%rax ; 0x400bee <main+510>
    mov    %rax,%rdi
    callq  0x400760 <fgetc@plt>

    mov    %al,-0x71(%rbp)
    movzbl -0x71(%rbp),%eax
    cmp    $0xff,%al        ; compare to EOF
    jne    0x400bd5 <main+485>

    mov    -0xa0(%rbp),%rax
    add    $0x8,%rax
    mov    (%rax),%rdx      ; av[1]
    mov    -0x88(%rbp),%rax
    mov    $0x400dd2,%esi   ; "Finished back up "
    mov    %rax,%rdi        ; FILE *log
    callq  0x4008c4 <log_wrapper>

    mov    -0x80(%rbp),%rax
    mov    %rax,%rdi
    callq  0x400710 <fclose@plt>

    mov    -0x78(%rbp),%eax
    mov    %eax,%edi
    callq  0x400770 <close@plt>
    mov    $0x0,%eax

    ; stack canary
    mov    -0x8(%rbp),%rdi
    xor    %fs:0x28,%rdi
    je     0x400c56 <main+614>
    callq  0x400720 <__stack_chk_fail@plt>
   
    leaveq  ; 0x400c56 <main+614>
    retq 