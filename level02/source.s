main:
    push   %rbp
    mov    %rsp,%rbp
    sub    $0x120,%rsp              ; 288 bytes allocated on stack

    mov    %edi, -0x114(%rbp)       ; the same as push edi; push rsi
    mov    %rsi, -0x120(%rbp)

    ; inlined memset or bzero
    lea    -0x70(%rbp),%rdx     
    mov    $0x0,%eax
    mov    $0xc,%ecx                ; count = 12 * qword = 96 bytes
    mov    %rdx,%rdi                ; 100 bytes array
    rep stos %rax,%es:(%rdi)
    mov    %rdi,%rdx                ; zeroing last 4 bytes
    mov    %eax,(%rdx)
    add    $0x4,%rdx

    ; inlined memset or bzero
    lea    -0xa0(%rbp),%rdx
    mov    $0x0,%eax
    mov    $0x5,%ecx                ; count = 5 * qword = 40 bytes
    mov    %rdx,%rdi                ; 48 bytes array or 41?
    rep stos %rax,%es:(%rdi)
    mov    %rdi,%rdx
    mov    %al,(%rdx)               ; zeroing 41st byte
    add    $0x1,%rdx
    
    ; inlined memset or bzero
    lea    -0x110(%rbp),%rdx
    mov    $0x0,%eax
    mov    $0xc,%ecx                ; count = 12 * qword = 96 bytes
    mov    %rdx,%rdi                ; 
    rep stos %rax,%es:(%rdi)
    mov    %rdi,%rdx                ; zeroing 4 more bytes
    mov    %eax,(%rdx)
    add    $0x4,%rdx

    movq   $0x0,-0x8(%rbp)          ; FILE *file = 0;
    movl   $0x0,-0xc(%rbp)

    mov    $0x400bb0,%edx   
    mov    $0x400bb2,%eax
    mov    %rdx,%rsi                ; "r"
    mov    %rax,%rdi                ; "/home/users/level03/.pass"
    callq  0x400700 <fopen@plt>
    mov    %rax,-0x8(%rbp)          ; file = res
    cmpq   $0x0,-0x8(%rbp)
    jne    0x4008e6 <main+210>

    mov    0x200991(%rip), %rax     ; 0x601250 <stderr@@GLIBC_2.2.5>
    mov    %rax,%rdx
    mov    $0x400bd0,%eax
    mov    %rdx,%rcx                ; stderr
    mov    $0x24,%edx               ; count = 36
    mov    $0x1,%esi                ; size = 1
    mov    %rax,%rdi                ; "ERROR: failed to open password file\n"
    callq  0x400720 <fwrite@plt>

    mov    $0x1,%edi
    callq  0x400710 <exit@plt>

    lea    -0xa0(%rbp),%rax         ; 0x4008e6 <main+210>
    mov    -0x8(%rbp),%rdx          
    mov    %rdx,%rcx                ; file
    mov    $0x29,%edx               ; count = 41 
    mov    $0x1,%esi                ; size = 1
    mov    %rax,%rdi                ; 48 bytes array, token
    callq  0x400690 <fread@plt>
    ; size_t fread(void *restrict ptr, size_t size, size_t nmemb, FILE *restrict stream);
    mov    %eax,-0xc(%rbp)

    lea    -0xa0(%rbp),%rax
    mov    $0x400bf5,%esi           ; "\n"
    mov    %rax,%rdi                ; 48 bytes array ?
    callq  0x4006d0 <strcspn@plt>   ; scan for newline symbol 
    movb   $0x0,-0xa0(%rbp,%rax,1)  ; set terminating null at the end ?

    cmpl   $0x29,-0xc(%rbp)         ; compare result of fread with 41
    je     0x40097d <main+361>

    mov    0x20091e(%rip),%rax      ; 0x601250 <stderr@@GLIBC_2.2.5>
    mov    %rax,%rdx
    mov    $0x400bf8,%eax
    mov    %rdx,%rcx                ; stderr
    mov    $0x24,%edx               ; count = 36
    mov    $0x1,%esi                ; size = 1
    mov    %rax,%rdi                ; "ERROR: failed to read password file\n"
    callq  0x400720 <fwrite@plt>

    mov    0x2008fa(%rip),%rax      ; 0x601250 <stderr@@GLIBC_2.2.5>
    mov    %rax,%rdx
    mov    $0x400bf8,%eax
    mov    %rdx,%rcx                ; stderr
    mov    $0x24,%edx               ; count = 36
    mov    $0x1,%esi                ; size = 1
    mov    %rax,%rdi                ; "ERROR: failed to read password file\n"
    callq  0x400720 <fwrite@plt>            

    mov    $0x1,%edi
    callq  0x400710 <exit@plt>

    mov    -0x8(%rbp),%rax          ; 0x40097d <main+361>
    mov    %rax,%rdi
    callq  0x4006a0 <fclose@plt>

    mov    $0x400c20,%edi           ; "===== [ Secure Access System v1.0 ] ====="
    callq  0x400680 <puts@plt>
    mov    $0x400c50,%edi           ; "/", '*' <repeats 39 times>, "\\"
    callq  0x400680 <puts@plt>
    mov    $0x400c80,%edi           ; "| You must login to access this system. |"
    callq  0x400680 <puts@plt>
    mov    $0x400cb0,%edi           ; "\\", '*' <repeats 38 times>, "/"
    callq  0x400680 <puts@plt>
    mov    $0x400cd9,%eax
    mov    %rax,%rdi                ; "--[ Username: "
    mov    $0x0,%eax
    callq  0x4006c0 <printf@plt>

    mov    0x20087e(%rip),%rax      ; 0x601248 <stdin@@GLIBC_2.2.5>
    mov    %rax,%rdx                ; stdin
    lea    -0x70(%rbp),%rax
    mov    $0x64,%esi               ; size = 100
    mov    %rax,%rdi                ; array of 100 bytes, name
    callq  0x4006f0 <fgets@plt>

    lea    -0x70(%rbp),%rax
    mov    $0x400bf5,%esi           ; "\n"
    mov    %rax,%rdi                ; array of 100 bytes, name
    callq  0x4006d0 <strcspn@plt>
    movb   $0x0,-0x70(%rbp, %rax, 1)

    mov    $0x400ce8,%eax
    mov    %rax,%rdi                ; "--[ Password: "
    mov    $0x0,%eax
    callq  0x4006c0 <printf@plt>

    mov    0x20083b(%rip),%rax      ; 0x601248 <stdin@@GLIBC_2.2.5>
    mov    %rax,%rdx
    lea    -0x110(%rbp),%rax
    mov    $0x64,%esi               ; size = 100 bytes
    mov    %rax,%rdi                ; array of 112 bytes, pass
    callq  0x4006f0 <fgets@plt>

    lea    -0x110(%rbp),%rax
    mov    $0x400bf5,%esi           ; "\n"
    mov    %rax,%rdi                ; array of 112 bytes, pass
    callq  0x4006d0 <strcspn@plt>

    movb   $0x0,-0x110(%rbp,%rax,1)

    mov    $0x400cf8,%edi           ; '*' <repeats 41 times>
    callq  0x400680 <puts@plt>

    lea    -0x110(%rbp),%rcx         
    lea    -0xa0(%rbp),%rax          
    mov    $0x29,%edx               ; count = 41
    mov    %rcx,%rsi                ; array of 112 bytes, pass
    mov    %rax,%rdi                ; array of 48 bytes, token
    callq  0x400670 <strncmp@plt>

    test   %eax,%eax
    jne    0x400a96 <main+642>

    mov    $0x400d22,%eax
    lea    -0x70(%rbp),%rdx
    mov    %rdx,%rsi                ; array of 100 bytes, name
    mov    %rax,%rdi                ; "Greetings, %s!\n"
    mov    $0x0,%eax
    callq  0x4006c0 <printf@plt>

    mov    $0x400d32,%edi           ;  "/bin/sh"
    callq  0x4006b0 <system@plt>
    mov    $0x0,%eax
    leaveq
    retq
      
    lea    -0x70(%rbp),%rax         ; 0x400a96 <main+642>
    mov    %rax,%rdi
    mov    $0x0,%eax                ; array of 100 bytes, name
    callq  0x4006c0 <printf@plt>

    mov    $0x400d3a,%edi           ; " does not have access!"
    callq  0x400680 <puts@plt>
    mov    $0x1,%edi            
    callq  0x400710 <exit@plt>