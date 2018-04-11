.section .data
array:
  .int 6, -5, 3, 1, -8, 7, 0, 2, 4, 9
string:
  .ascii "0123456789"
mbreakpoint:
  .ascii "breakpoint\n"  
format: 
   .asciz "%d\n" 
.section .text
.globl _start

#进行插入排序
_start:
    mov $array,%eax
    mov $10,%ebx
    call sort
    call int_to_string    
    call breakpoint
    push $11     
    push $string   
    
    call print
    call return


sort:
#首地址放在%eax, 长度放在%ebx
    push %rbx
    push %rsi
    push %rdi
    mov %eax,%ecx
    mov %eax,%edx
    add %ebx,%ecx
    #dec %ecx
    inc %edx #i
#%ecx==终止地址+1
#%edx==当前地址
#for i in array 
forloop:
    cmp %ecx,%edx
    jnb endsort

    mov (%edx),%esi #%esi:temp
    mov %edx,%edi #%edi:j
    dec %edi

    #while
    whileloop:
        cmp %eax,%edi
        jb endwhile
        cmp %esi,(%edi)
        jna endwhile
        mov (%edi),%r8 #r8 is a temp reg
        mov %r8,1(%edi)
        dec %edi
        jmp whileloop
    endwhile:

    mov %esi,1(%edi)

    add $1,%edx
    jmp forloop

endsort:
    pop %rdi
    pop %rsi
    pop %rbx
    ret

output:
#字符串地址放在%ecx, 长度放在%edx
    push %rdi
    push %rsi
    mov $1, %rax
    mov $1, %rdi
    mov %ecx, %esi
    #mov %edx, %edx
    syscall
    pop %rsi
    pop %rdi
    ret

print:
#字符串地址后push, 长度先push
    mov $1, %rax
    mov $1, %rdi
    mov -4(%esp), %esi
    mov -8(%esp), %edx
    syscall
    ret $8

int_to_string:
#convert in to string with a '\0' in the end
    push %rbx
    mov $string,%ecx
    mov $array,%edx
    mov $10,%ebx

    int_to_string_loop:    
        test %ebx,%ebx        
        je int_to_string_endloop
                
        dec %ebx

        movl (%edx),%eax
        add $48,%eax
        movb %al,(%ecx)#bug
        inc %ecx
        add $4,%edx
        
        jmp int_to_string_loop

    int_to_string_endloop:    
    
    movb $0,(%rcx)
    pop %rbx
    ret

return:
    mov $60, %rax
    mov $0, %rdi
    syscall

breakpoint:
    push %rax
    push %rdi
    push %rsi
    push %rdx
    push %rcx
    push %rbx

    mov $1, %rax
    mov $1, %rdi
    mov $mbreakpoint, %rsi
    mov $11, %edx
    syscall

    pop %rbx
    pop %rcx
    pop %rdx
    pop %rsi
    pop %rdi
    pop %rax
    
    ret

printint:
    push %rax
    push %rdi
    push %rsi
    push %rdx
    push %rcx
    push %rbx

    push $12
    push $format 
    call printf

    pop %rbx
    pop %rcx
    pop %rdx
    pop %rsi
    pop %rdi
    pop %rax
    
    ret


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
