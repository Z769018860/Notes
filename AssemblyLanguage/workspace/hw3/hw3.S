.section .data
iostring:
  .asciz "ab1g2hA0H56po9wK78nB"
.section .text
.globl _start

#补充完整下面的程序，将iostring中的小写字母转换为大写字母，然后输出转换后的iostring
_start:
  
#start
    mov $iostring,%eax
    #mov $iostring,%ebx
    mov $0,%edx #length

#while
WHILE:
    inc %edx
    movb (%eax),%bl
    testb %bl,%bl
    je END

    #_if
    #_ifcondition
        cmpb $'a',(%eax)
        jb ELSE
        cmpb $'z',(%eax)
        ja ELSE

    #meet_IF_condition:
        subb $32, (%eax)

    ELSE:
        #do nothing

    #end_if
    inc %eax
    jmp WHILE

END:
#endwhile

#output
    mov $1, %rax
    mov $1, %rdi
    mov $iostring, %rsi
    #mov $16, %edx
    syscall

#exit
    mov $60, %rax
    mov $0, %rdi
    syscall

#output
	#movl	$4, %eax
	#movl	$1, %ebx
	#movl	$iostring, %ecx
    #movl	$16, %edx
    

	#int	$0x80
#exit
	#movl	$1, %eax
	#movl	$0, %ebx
	#int	$0x80
