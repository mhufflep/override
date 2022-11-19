clear_stdin:
    push   %ebp
    mov    %esp,%ebp
    sub    $0x18,%esp               ; 24 bytes allocated on stack

    movb   $0x0,-0x9(%ebp)
    jmp    0x80485d1 <clear_stdin+13>
    nop                             ; 0x80485d0 <clear_stdin+12>
    
    call   0x8048490 <getchar@plt>  ; 0x80485d1 <clear_stdin+13>
    mov    %al,-0x9(%ebp)
    
    cmpb   $0xa,-0x9(%ebp)          ; '\n'
    je     0x80485e5 <clear_stdin+33>
    
    cmpb   $0xff,-0x9(%ebp)         ; -1
    jne    0x80485d0 <clear_stdin+12>
    leave                           ; 0x80485e5 <clear_stdin+33>
    ret

read_number:
    push   %ebp
    mov    %esp,%ebp
    sub    $0x28,%esp       ; 40 bytes allocated on stack

    movl   $0x0,-0xc(%ebp)

    mov    $0x8048add,%eax  ; " Index: "
    mov    %eax,(%esp)
    call   0x8048470 <printf@plt>

    call   0x80485e7 <get_unum>
    mov    %eax,-0xc(%ebp)  ; save in local index

    mov    -0xc(%ebp),%eax
    shl    $0x2,%eax        ; index * 4

    add    0x8(%ebp),%eax
    mov    (%eax),%edx
    mov    $0x8048b1b,%eax
    mov    %edx,0x8(%esp)   ;  buf[index]
    mov    -0xc(%ebp),%edx  
    mov    %edx,0x4(%esp)   ;  index
    mov    %eax,(%esp)      ; " Number at data[%u] is %u\n"
    call   0x8048470 <printf@plt>

    mov    $0x0,%eax
    leave  
    ret 

get_unum:
    push   %ebp
    mov    %esp,%ebp
    sub    $0x28,%esp        ; 40 bytes allocated on stack
    
    movl   $0x0,-0xc(%ebp)

    mov    0x804a060,%eax  
    mov    %eax,(%esp)       ; stdout
    call   0x8048480 <fflush@plt>

    mov    $0x8048ad0,%eax
    lea    -0xc(%ebp),%edx
    mov    %edx,0x4(%esp)    ; local uint var
    mov    %eax,(%esp)       ; "%u"
    call   0x8048500 <__isoc99_scanf@plt>

    call   0x80485c4 <clear_stdin>
    mov    -0xc(%ebp),%eax   ; return the value of local var

    leave  
    ret 

store_number:
    push   %ebp
    mov    %esp,%ebp
    sub    $0x28,%esp

    movl   $0x0,-0x10(%ebp)
    movl   $0x0,-0xc(%ebp)

    mov    $0x8048ad3,%eax  
    mov    %eax,(%esp)      ; " Number: "
    call   0x8048470 <printf@plt>
   
    call   0x80485e7 <get_unum>
    mov    %eax,-0x10(%ebp)
    mov    $0x8048add,%eax
    mov    %eax,(%esp)      ; " Index: "
    call   0x8048470 <printf@plt>

    call   0x80485e7 <get_unum>
    mov    %eax,-0xc(%ebp)

    mov    -0xc(%ebp),%ecx      ;
    mov    $0xaaaaaaab,%edx     ;
    mov    %ecx,%eax            ;
    mul    %edx                 ;
    shr    %edx                 ;
    mov    %edx,%eax            ; (index % 3 == 0)
    add    %eax,%eax            ;
    add    %edx,%eax            ;
    mov    %ecx,%edx            ;
    sub    %eax,%edx            ;
    test   %edx,%edx            ;
    je     0x8048697 <store_number+103>

    mov    -0x10(%ebp),%eax
    shr    $0x18,%eax

    cmp    $0xb7,%eax
    jne    0x80486c2 <store_number+146>

    movl   $0x8048ae6,(%esp)    ; 0x8048697 <store_number+103>
    call   0x80484c0 <puts@plt> ; " *** ERROR! ***"
    movl   $0x8048af8,(%esp)    ; "   This index is reserved for wil!"
    call   0x80484c0 <puts@plt>
    movl   $0x8048ae6,(%esp)    ; " *** ERROR! ***"
    call   0x80484c0 <puts@plt>
    mov    $0x1,%eax
    jmp    0x80486d5 <store_number+165>

    mov    -0xc(%ebp),%eax      ; 0x80486c2 <store_number+146>
    shl    $0x2,%eax            ; index * 4
    add    0x8(%ebp),%eax
    mov    -0x10(%ebp),%edx
    mov    %edx,(%eax)

    mov    $0x0,%eax
    leave  
    ret  

main:
    push   %ebp
    mov    %esp,%ebp
    push   %edi
    push   %esi
    push   %ebx
    and    $0xfffffff0,%esp
    sub    $0x1d0,%esp      ; 464 bytes allocated on stack

    mov    0xc(%ebp),%eax    
    mov    %eax,0x1c(%esp)  ; argv
    mov    0x10(%ebp),%eax
    mov    %eax,0x18(%esp)  ; env

    ; stack canary
    mov    %gs:0x14,%eax
    mov    %eax,0x1cc(%esp)
    xor    %eax,%eax
   
    ; inlined memset
    movl   $0x0,0x1b4(%esp) ; ret number 
    movl   $0x0,0x1b8(%esp)
    movl   $0x0,0x1bc(%esp)
    movl   $0x0,0x1c0(%esp)
    movl   $0x0,0x1c4(%esp)
    movl   $0x0,0x1c8(%esp)

    ; inlined memset
    lea    0x24(%esp),%ebx
    mov    $0x0,%eax
    mov    $0x64,%edx       ; size = 100
    mov    %ebx,%edi
    mov    %edx,%ecx
    rep stos %eax,%es:(%edi)

    jmp    0x80487ea <main+199>

    ; inlined strlen ?
    mov    0x1c(%esp),%eax      ; 0x80487a7 <main+132>
    mov    (%eax),%eax
    movl   $0xffffffff,0x14(%esp)
    mov    %eax,%edx
    mov    $0x0,%eax
    mov    0x14(%esp),%ecx
    mov    %edx,%edi
    repnz scas %es:(%edi),%al
    mov    %ecx,%eax
    not    %eax

    lea    -0x1(%eax),%edx      
    mov    0x1c(%esp),%eax
    mov    (%eax),%eax
    mov    %edx,0x8(%esp)       ; av[i] length
    movl   $0x0,0x4(%esp)       ; 
    mov    %eax,(%esp)          ; av[i]
    call   0x80484f0 <memset@plt>
    addl   $0x4,0x1c(%esp)      ; go to the next av
    mov    0x1c(%esp),%eax      ;  0x80487ea <main+199>
    mov    (%eax),%eax

    test   %eax,%eax
    jne    0x80487a7 <main+132>
    jmp    0x8048839 <main+278>

    mov    0x18(%esp),%eax      ; 0x80487f6 <main+211>
    mov    (%eax),%eax
    movl   $0xffffffff,0x14(%esp)
    mov    %eax,%edx
    mov    $0x0,%eax
    mov    0x14(%esp),%ecx
    mov    %edx,%edi
    repnz scas %es:(%edi),%al
    mov    %ecx,%eax
    not    %eax

    lea    -0x1(%eax),%edx
    mov    0x18(%esp),%eax
    mov    (%eax),%eax
    mov    %edx,0x8(%esp)
    movl   $0x0,0x4(%esp)
    mov    %eax,(%esp)
    call   0x80484f0 <memset@plt>

    addl   $0x4,0x18(%esp)
    mov    0x18(%esp),%eax      ; 0x8048839 <main+278>
    mov    (%eax),%eax

    test   %eax,%eax
    jne    0x80487f6 <main+211>


    movl   $0x8048b38,(%esp)    ; - * 52 "\n  Welcome to wil's crappy number storage service!   \n", '-' * 52, "\n Commands:", ' ' * 31
    call   0x80484c0 <puts@plt>

    mov    $0x8048d4b,%eax      ; 0x804884f <main+300>
    mov    %eax,(%esp)          ; "Input command: "
    call   0x8048470 <printf@plt>

    movl   $0x1,0x1b4(%esp)
    mov    0x804a040,%eax
    mov    %eax,0x8(%esp)       ; stdin
    movl   $0x14,0x4(%esp)      ; size = 20
    lea    0x1b8(%esp),%eax
    mov    %eax,(%esp)      
    call   0x80484a0 <fgets@plt>

    ; inlined strlen
    lea    0x1b8(%esp),%eax
    movl   $0xffffffff,0x14(%esp)
    mov    %eax,%edx
    mov    $0x0,%eax
    mov    0x14(%esp),%ecx
    mov    %edx,%edi
    repnz scas %es:(%edi),%al
    mov    %ecx,%eax
    not    %eax
    sub    $0x1,%eax

    sub    $0x1,%eax
    movb   $0x0,0x1b8(%esp,%eax,1)

    ; inline strncmp
    lea    0x1b8(%esp),%eax
    mov    %eax,%edx
    mov    $0x8048d5b,%eax
    mov    $0x5,%ecx            ; n = 5
    mov    %edx,%esi            ; arr
    mov    %eax,%edi            ; "store"
    repz cmpsb %es:(%edi),%ds:(%esi)
    seta   %dl
    setb   %al
    mov    %edx,%ecx
    sub    %al,%cl
    mov    %ecx,%eax
    movsbl %al,%eax

    test   %eax,%eax
    jne    0x80488f8 <main+469>

    lea    0x24(%esp),%eax
    mov    %eax,(%esp)
    call   0x8048630 <store_number>
    mov    %eax,0x1b4(%esp)
    jmp    0x8048965 <main+578>

    ; inlined strncmp
    lea    0x1b8(%esp),%eax     ; 0x80488f8 <main+469>
    mov    %eax,%edx
    mov    $0x8048d61,%eax      
    mov    $0x4,%ecx            ; n = 4
    mov    %edx,%esi            ; arr 
    mov    %eax,%edi            ; "read"
    repz cmpsb %es:(%edi),%ds:(%esi)
    seta   %dl
    setb   %al
    mov    %edx,%ecx
    sub    %al,%cl
    mov    %ecx,%eax
    movsbl %al,%eax
  
    test   %eax,%eax
    jne    0x8048939 <main+534>

    lea    0x24(%esp),%eax
    mov    %eax,(%esp)
    call   0x80486d7 <read_number>
    mov    %eax,0x1b4(%esp)
    jmp    0x8048965 <main+578>

    lea    0x1b8(%esp),%eax     ; 0x8048939 <main+534>
    mov    %eax,%edx
    mov    $0x8048d66,%eax
    mov    $0x4,%ecx        ; n = 4
    mov    %edx,%esi        ; arr
    mov    %eax,%edi        ; "quit"
    repz cmpsb %es:(%edi),%ds:(%esi)
    seta   %dl
    setb   %al
    mov    %edx,%ecx
    sub    %al,%cl
    mov    %ecx,%eax
    movsbl %al,%eax

    test   %eax,%eax
    je     0x80489cf <main+684>

    cmpl   $0x0,0x1b4(%esp)     ; 0x8048965 <main+578>
    je     0x8048989 <main+614>
    mov    $0x8048d6b,%eax      
    lea    0x1b8(%esp),%edx
    mov    %edx,0x4(%esp)       ; arr
    mov    %eax,(%esp)          ; " Failed to do %s command\n"
    call   0x8048470 <printf@plt>

    jmp    0x80489a1 <main+638>

    mov    $0x8048d88,%eax      ; 0x8048989 <main+614>
    lea    0x1b8(%esp),%edx
    mov    %edx,0x4(%esp)       ; arr
    mov    %eax,(%esp)          ; " Completed %s command successfully\n"
    call   0x8048470 <printf@plt>

    ; inlined memset
    lea    0x1b8(%esp),%eax     ; 0x80489a1 <main+638>
    movl   $0x0,(%eax)
    movl   $0x0,0x4(%eax)
    movl   $0x0,0x8(%eax)
    movl   $0x0,0xc(%eax)
    movl   $0x0,0x10(%eax)
    jmp    0x804884f <main+300>

    nop                         ; 0x80489cf <main+684>
    mov    $0x0,%eax

    ; stack canary
    mov    0x1cc(%esp),%esi
    xor    %gs:0x14,%esi
    je     0x80489ea <main+711>
    call   0x80484b0 <__stack_chk_fail@plt>

    lea    -0xc(%ebp),%esp      ; 0x80489ea <main+711>
    pop    %ebx
    pop    %esi
    pop    %edi
    pop    %ebp
    ret 