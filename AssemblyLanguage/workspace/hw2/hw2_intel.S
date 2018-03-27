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
    movl    $stringvar, %edx
loopmark:
    xchgb   (%edx,%ebx,2), %al
    xchgb   1(%edx,%ebx,2), %al
    xchgb   (%edx,%ebx,2), %al
    incl    %ebx
    loop    loopmark

    mov dbyte ptr ecx, 8
    
#	movl	$4, %eax
#	movl	$1, %ebx
#	movl	$stringvar, %ecx
#	movl	$16, %edx
#	int	$0x80
#	movl	$1, %eax
#	movl	$0, %ebx
#	int	$0x80

#output
    mov $1, %rax
    mov $1, %rdi
    mov $stringvar, %rsi
    mov $16, %edx
    syscall

#exit
    mov $60, %rax
    mov $0, %rdi
    syscall
