#ucas.S
    .intel_syntax noprefix
.section .data
    output: .ascii "University of CAS\n"
.section .bss
.section .text
.globl _start

_start:
/*
4号调用：写文件

    EBX：文件描述符，1表示终端
    ECX：输出缓冲区（Buffer）的地址
    EDX：输出的字节数

1号调用：程序退出

    EBX：返回值
*/
    mov rax, 1
    mov rdi, 1
    mov rsi, offset output
    mov edx, 18
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
