secret_backdoor:
    push   %rbp
    mov    %rsp,%rbp
    add    $0xffffffffffffff80,%rsp   ; 128 bytes allocated on stack

    mov    0x20171d(%rip),%rax        ; 0x201fb8
    mov    (%rax),%rax
    mov    %rax,%rdx           ; 0 - stdin
    lea    -0x80(%rbp),%rax
    mov    $0x80,%esi          ; size = 128
    mov    %rax,%rdi           ; buf of 128 bytes
    callq  0x770 <fgets@plt>

    lea    -0x80(%rbp),%rax
    mov    %rax,%rdi           ; buf of 128 bytes
    callq  0x740 <system@plt>

    leaveq 
    retq 

set_msg:
    push   %rbp
    mov    %rsp,%rbp
    sub    $0x410,%rsp          ; 1040 bytes allocated on stack

    mov    %rdi,-0x408(%rbp)    ; char *buf

    ; inlined memset
    lea    -0x400(%rbp),%rax
    mov    %rax,%rsi
    mov    $0x0,%eax
    mov    $0x80,%edx   
    mov    %rsi,%rdi
    mov    %rdx,%rcx            ; count = 128 * qword = 1024 bytes
    rep stos %rax,%es:(%rdi)

    lea    0x265(%rip),%rdi     ; 0x555555554bcd, ">: Msg @Unix-Dude"
    callq  0x555555554730 <puts@plt>

    lea    0x26b(%rip),%rax     ; 0x555555554bdf, ">>: "
    mov    %rax,%rdi
    mov    $0x0,%eax
    callq  0x555555554750 <printf@plt>

    mov    0x201630(%rip),%rax  ; 0x555555755fb8, addr of stdin
    mov    (%rax),%rax
    mov    %rax,%rdx            ; stdin
    lea    -0x400(%rbp),%rax        
    mov    $0x400,%esi          ; size = 1024
    mov    %rax,%rdi            ; tmp
    callq  0x555555554770 <fgets@plt>
    ; char *fgets(char * restrict str, int size, FILE * restrict stream);

    mov    -0x408(%rbp),%rax
    mov    0xb4(%rax),%eax
    movslq %eax,%rdx
    lea    -0x400(%rbp),%rcx
    mov    -0x408(%rbp),%rax
    mov    %rcx,%rsi            ; char *tmp
    mov    %rax,%rdi            ; char *buf
    callq  0x555555554720 <strncpy@plt>

    leaveq 
    retq 

set_username:
    push   %rbp
    mov    %rsp,%rbp
    sub    $0xa0,%rsp           ; 160 bytes allocated on stack

    mov    %rdi,-0x98(%rbp)     ; char *buf

    ; inlined memset
    lea    -0x90(%rbp),%rax
    mov    %rax,%rsi
    mov    $0x0,%eax
    mov    $0x10,%edx
    mov    %rsi,%rdi
    mov    %rdx,%rcx            ; count = 16 * qword = 128 bytes
    rep stos %rax,%es:(%rdi)

    lea    0x1e1(%rip),%rdi     ; 0x555555554be4, ">: Enter your username"
    callq  0x555555554730 <puts@plt>

    lea    0x1d0(%rip),%rax     ; 0x555555554bdf, ">>: "
    mov    %rax,%rdi
    mov    $0x0,%eax
    callq  0x555555554750 <printf@plt>

    mov    0x201595(%rip),%rax  ; 0x555555755fb8, addr of stdin
    mov    (%rax),%rax
    mov    %rax,%rdx            ; stdin
    lea    -0x90(%rbp),%rax
    mov    $0x80,%esi           ; size = 128
    mov    %rax,%rdi            ; char *tmp
    callq  0x555555554770 <fgets@plt>

    movl   $0x0,-0x4(%rbp)
    jmp    0x555555554a6a <set_username+157>
    mov    -0x4(%rbp),%eax      ; 0x555555554a46 <set_username+121>
    cltq   
    movzbl -0x90(%rbp,%rax,1),%ecx
    mov    -0x98(%rbp),%rdx     ; char *buf
    mov    -0x4(%rbp),%eax
    cltq   
    mov    %cl,0x8c(%rdx,%rax,1) ; offset of 140 bytes
    addl   $0x1,-0x4(%rbp)

    cmpl   $0x28,-0x4(%rbp)     ; 0x555555554a6a <set_username+157>
    jg     0x555555554a81 <set_username+180>
    mov    -0x4(%rbp),%eax
    cltq   
    movzbl -0x90(%rbp,%rax,1),%eax
    test   %al,%al
    jne    0x555555554a46 <set_username+121>

    mov    -0x98(%rbp),%rax     ; 0x555555554a81 <set_username+180>
    lea    0x8c(%rax),%rdx
    lea    0x165(%rip),%rax     ; 0x555555554bfb, ">: Welcome, %s"
    mov    %rdx,%rsi            ; &tmp[140]
    mov    %rax,%rdi
    mov    $0x0,%eax
    callq  0x555555554750 <printf@plt>

    leaveq 
    retq 

handle_msg:
    push   %rbp
    mov    %rsp,%rbp
    sub    $0xc0,%rsp   ; 192 bytes allocated on stack`
   
    lea    -0xc0(%rbp),%rax
    add    $0x8c,%rax   ; 140
    movq   $0x0,(%rax)
    movq   $0x0,0x8(%rax)
    movq   $0x0,0x10(%rax)
    movq   $0x0,0x18(%rax)
    movq   $0x0,0x20(%rax)

    movl   $0x8c,-0xc(%rbp)

    lea    -0xc0(%rbp),%rax
    mov    %rax,%rdi
    callq  0x5555555549cd <set_username>

    lea    -0xc0(%rbp),%rax
    mov    %rax,%rdi
    callq  0x555555554932 <set_msg>

    lea    0x295(%rip),%rdi        ; ">: Msg sent!"
    callq  0x555555554730 <puts@plt>

    leaveq 
    retq

main:
    push   %rbp
    mov    %rsp,%rbp

    lea    0x15d(%rip),%rdi     ; title
    callq  0x730 <puts@plt>
    callq  0x8c0 <handle_msg>

    mov    $0x0,%eax
    pop    %rbp
    retq 