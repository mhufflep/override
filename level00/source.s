main:
    push   %ebp
    mov    %esp,%ebp
    and    $0xfffffff0,%esp

    sub    $0x20,%esp

    movl   $0x80485f0,(%esp)         ; '*' <repeats 35 times>
    call   0x8048390 <puts@plt>
    movl   $0x8048614,(%esp)         ; "* \t     -Level00 -\t\t  *"
    call   0x8048390 <puts@plt>
    movl   $0x80485f0,(%esp)         ; '*' <repeats 35 times>
    call   0x8048390 <puts@plt>

    mov    $0x804862c,%eax
    mov    %eax,(%esp)               ; "Password:"
    call   0x8048380 <printf@plt>

    mov    $0x8048636,%eax
    lea    0x1c(%esp),%edx
    mov    %edx,0x4(%esp)            ; local var
    mov    %eax,(%esp)               ; "%d"
    call   0x80483d0 <__isoc99_scanf@plt>
    mov    0x1c(%esp),%eax
    cmp    $0x149c,%eax              ; compare scanf result with 5276
    jne    0x804850d <main+121>

    movl   $0x8048639,(%esp)         ; "\nAuthenticated!"
    call   0x8048390 <puts@plt>
    movl   $0x8048649,(%esp)         ; "/bin/sh"
    call   0x80483a0 <system@plt>
    mov    $0x0,%eax
    jmp    0x804851e <main+138>

    movl   $0x8048651,(%esp)         ; "\nInvalid Password!"
    call   0x8048390 <puts@plt>
    mov    $0x1,%eax

    leave  
    ret