# override

The final project in the cybersecurity branch.
The goal is to pass all the 10 levels:

| Level | Exploit\Technique\Breach |
| ----- | ------- |
| [level00](/level00/walkthrough.md) | Passing suitable argument |
| [level01](/level01/walkthrough.md) | Buffer overflow, ret2libc |
| [level02](/level02/walkthrough.md) | Format string attack |
| [level03](/level03/walkthrough.md) | Passing suitable argument |
| [level04](/level04/walkthrough.md) | Buffer overflow, ret2libc |
| [level05](/level05/walkthrough.md) | Format string attack, GOT rewriting |
| [level06](/level06/walkthrough.md) | Passing suitable argument |
| [level07](/level07/walkthrough.md) | Passing suitable argument |
| [level08](/level08/walkthrough.md) |  |
| [level09](/level09/walkthrough.md) |  |

## References
- [stack protection](https://developers.redhat.com/articles/2022/06/02/use-compiler-flags-stack-protection-gcc-and-clang#control_flow_integrity)
- [asm instructions at the beginning of the frame](https://reverseengineering.stackexchange.com/questions/15173/what-is-the-purpose-of-these-instructions-before-the-main-preamble)
- [frame structure](https://reverseengineering.stackexchange.com/questions/14880/basic-reversing-question-about-local-variable/14883#14883)
- [rpath vs runpath](https://medium.com/obscure-system/rpath-vs-runpath-883029b17c45)
- [compiling a shared library](https://amir.rachum.com/blog/2016/09/17/shared-libraries/#compiling-a-shared-library)
- [ret2shellcode](https://wiki.bi0s.in/pwning/stack-overflow/return-to-shellcode/)
- [stack protector](https://mudongliang.github.io/2016/05/24/stack-protector.html)
