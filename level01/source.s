verify_user_pass:
    push   %ebp
    mov    %esp,%ebp
    push   %edi
    push   %esi

    ; inlined strncmp
    mov    0x8(%ebp),%eax
    mov    %eax,%edx
    mov    $0x80486b0,%eax  ; "admin"
    mov    $0x5,%ecx
    mov    %edx,%esi
    mov    %eax,%edi
    repz cmpsb %es:(%edi),%ds:(%esi)
    seta   %dl
    setb   %al
    mov    %edx,%ecx
    sub    %al,%cl
    mov    %ecx,%eax
    movsbl %al,%eax

    pop    %esi
    pop    %edi
    pop    %ebp
    ret 


verify_user_name:
    push   %ebp
    mov    %esp,%ebp
    push   %edi
    push   %esi
    sub    $0x10,%esp

    ; inlined strncmp
    movl   $0x8048690,(%esp)    ; "verifying username....\n"
    call   0x8048380 <puts@plt> 
    mov    $0x804a040,%edx      ; a_user_name
    mov    $0x80486a8,%eax      ; "dat_wil"
    mov    $0x7,%ecx
    mov    %edx,%esi
    mov    %eax,%edi
    repz cmpsb %es:(%edi),%ds:(%esi)
    seta   %dl
    setb   %al
    mov    %edx,%ecx
    sub    %al,%cl
    mov    %ecx,%eax
    movsbl %al,%eax

    add    $0x10,%esp
    pop    %esi
    pop    %edi
    pop    %ebp
    ret    


main:
    push   %ebp
    mov    %esp,%ebp
    push   %edi
    push   %ebx
    and    $0xfffffff0,%esp

    sub    $0x60,%esp          ; 96 bytes allocated on stack
   
    ; inlined memset 
    lea    0x1c(%esp),%ebx
    mov    $0x0,%eax
    mov    $0x10,%edx       ; 16 * dword (4 bytes) = 64 bytes
    mov    %ebx,%edi
    mov    %edx,%ecx
    rep stos %eax,%es:(%edi)

    movl   $0x0,0x5c(%esp)

    movl   $0x80486b8,(%esp)    ; "********* ADMIN LOGIN PROMPT *********"
    call   0x8048380 <puts@plt>
   
    mov    $0x80486df,%eax
    mov    %eax,(%esp)          ; "Enter Username: "
    call   0x8048360 <printf@plt>

    mov    0x804a020,%eax
    mov    %eax,0x8(%esp)       ; stdin
    movl   $0x100,0x4(%esp)     ; size = 256
    movl   $0x804a040,(%esp)    ; char a_user_name[100] global var
    call   0x8048370 <fgets@plt>

    call   0x8048464 <verify_user_name>
    mov    %eax,0x5c(%esp)
    cmpl   $0x0,0x5c(%esp)
    je     0x8048550 <main+128>

    movl   $0x80486f0,(%esp)    ; "nope, incorrect username...\n"
    call   0x8048380 <puts@plt>
    mov    $0x1,%eax
    jmp    0x80485af <main+223>

    movl   $0x804870d,(%esp)    ; 0x8048550 <main+128>, "Enter Password: "
    call   0x8048380 <puts@plt>

    mov    0x804a020,%eax
    mov    %eax,0x8(%esp)       ; stdin
    movl   $0x64,0x4(%esp)      ; size = 100
    lea    0x1c(%esp),%eax      
    mov    %eax,(%esp)          ; 0x60 - 0x1c = 96 - 28 = 68 bytes array
    call   0x8048370 <fgets@plt>

    lea    0x1c(%esp),%eax
    mov    %eax,(%esp)
    call   0x80484a3 <verify_user_pass>
    mov    %eax,0x5c(%esp)

    cmpl   $0x0,0x5c(%esp)
    je     0x8048597 <main+199>
    cmpl   $0x0,0x5c(%esp)
    je     0x80485aa <main+218>

    movl   $0x804871e,(%esp)    ; 0x8048597 <main+199>, "nope, incorrect password...\n"
    call   0x8048380 <puts@plt>
    mov    $0x1,%eax
    jmp    0x80485af <main+223>

    mov    $0x0,%eax            ; 0x80485aa <main+218>

    lea    -0x8(%ebp),%esp      ; 0x80485af <main+223>
    pop    %ebx
    pop    %edi
    pop    %ebp
    ret    
