.section .data
testdata:
.int 6,-5,3,1,-8,7,0,2,4,9
.section .text
.globl _start
_start:
	subl	$8, %esp
        movl	$testdata, (%esp)
	movl	$10, 4(%esp)
	call	Insert_sort
#output
	call	as_puts
as_puts:
	movl	$4, %eax
	movl	$1, %ebx
	movl	$testdata, %ecx
	movl	$10, %edx
	int	$0x80
	ret
#exit
	call	as_exit
as_exit:
	movl	$1, %eax
	movl	$0, %ebx
	int	$0x80
	ret
	.globl	insert_sort
	.type	insert_sort, @function
insert_sort:
.LFB0:
        push   %rdi
        pushl   %esi
        pushl   %ebx
        movl    16(%esp), %edi
        movl    20(%esp), %esi 
        dec	%esi
        testl   %esi, %esi
        jle     .L1
.L3: 
        movl    %edi, %eax
        movl   %edi, %ebx
        addl    %esi, %ebx
.L7: 
        movzbl  (%eax), %edx
        movzbl  1(%eax), %ecx
        cmpb    %cl, %dl
        jle     .L4
        movb    %cl, (%eax)
        movb    %dl, 1(%eax)
.L4:
        addl    $1, %eax
        cmpl    %ebx, %eax
        jne     .L7
.L6:
        subl    $1, %esi
        jne     .L3
.L1:
        popl    %ebx
        popl    %esi
        popl    %edi
        ret