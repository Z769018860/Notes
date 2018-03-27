#hw2.S

.section .data
stringvar:
  .ascii	"0123456789abcdef"
  /*要输出1032547698badcfe*/
.section .text
.globl _start
_start:

#main
    movl    $8, %ecx
    movl    $0, %ebx
loopmark:
    xchgb   ($stringvar,%ebx,2), %al
    xchgb   1($stringvar,%ebx,2), %al
    xchgb   ($stringvar,%ebx,2), %al
    incl    %ebx
    loop    loopmark

#output
	movl	$4, %eax
	movl	$1, %ebx
	movl	$stringvar, %ecx
	movl	$16, %edx
	int	$0x80
#exit
	movl	$1, %eax
	movl	$0, %ebx
	int	$0x80

#    mov rax, 1
#    mov rdi, 1
#    mov rsi, offset output
#    mov edx, 18
#    syscall
#
#    mov rax, 60
#    mov rdi, 0
#    syscall
