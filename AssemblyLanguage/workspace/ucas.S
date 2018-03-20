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
    mov eax, 4
    mov ebx, 1
    mov ecx, offset output
    mov edx, 17
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80
