main:
    push   %ebp
    mov    %esp,%ebp
    push   %edi
    push   %ebx
    and    $0xfffffff0,%esp
    sub    $0x90,%esp       ; 144 bytes allocated on stack

    movl   $0x0,0x8c(%esp)
    mov    0x80497f0,%eax   
    mov    %eax,0x8(%esp)   ; stdin
    movl   $0x64,0x4(%esp)  ; size = 100
    lea    0x28(%esp),%eax 
    mov    %eax,(%esp)      ; array of 100 bytes
    call   0x8048350 <fgets@plt>
    movl   $0x0,0x8c(%esp)

    jmp    0x80484d3 <main+143>

    ; inlined isupper
    lea    0x28(%esp),%eax  ; 0x8048487 <main+67>
    add    0x8c(%esp),%eax
    movzbl (%eax),%eax
    cmp    $0x40,%al
    jle    0x80484cb <main+135>
    lea    0x28(%esp),%eax
    add    0x8c(%esp),%eax
    movzbl (%eax),%eax
    cmp    $0x5a,%al
    jg     0x80484cb <main+135>

    ; tolower
    lea    0x28(%esp),%eax
    add    0x8c(%esp),%eax
    movzbl (%eax),%eax
    mov    %eax,%edx
    xor    $0x20,%edx
    lea    0x28(%esp),%eax
    add    0x8c(%esp),%eax
    mov    %dl,(%eax)

    addl   $0x1,0x8c(%esp)  ; 0x80484cb <main+135>
    mov    0x8c(%esp),%ebx  ; 0x80484d3 <main+143>

    ; inlined strlen
    lea    0x28(%esp),%eax
    movl   $0xffffffff,0x1c(%esp)
    mov    %eax,%edx
    mov    $0x0,%eax
    mov    0x1c(%esp),%ecx
    mov    %edx,%edi
    repnz scas %es:(%edi),%al
    mov    %ecx,%eax
    not    %eax
    sub    $0x1,%eax

    cmp    %eax,%ebx
    jb     0x8048487 <main+67>

    lea    0x28(%esp),%eax
    mov    %eax,(%esp)       ; array of 100 chars
    call   0x8048340 <printf@plt>

    movl   $0x0,(%esp)
    call   0x8048370 <exit@plt>