.section .data
array:
  .int 6, -5, 3, 1, -8, 7, 0, 2, 4, 9
string:
  .ascii "012345678901234567890123456789"
mbreakpoint:
  .ascii "breakpoint\n"  
format: 
   .asciz "%d\n" 
.section .text
.globl _start

#进行插入排序
_start:
    mov $array,%rax
    mov $40,%rbx
    call sort
    call ints_to_string    
    call return

#void insert_sort(int a[], int n)
#
#{
#
#    int i;
#
#    int j, tmp;
#
#    for(i = 1; i<n; i++)
#
#    {
#
#       tmp = a[i];
#
#       j = i - 1;
#
#       while(j >=0 && a[j] >tmp)
#
#       {
#
#          a[j+1] = a[j];
#
#          j--;
#
#       }
#
#       a[j+1]=tmp;
#
#    }
#
#}



sort:
#首地址放在%rax, 长度放在%rbx
#a: %rax
#4n-a: %rbx
#4n: %r9
#a[i]: (%rcx)
#temp: %edx
#j: %esi

    mov %rax,%r9
    add %rbx,%r9

    mov %rax,%rcx
    add $4,%rcx #    int i;
    #for(i = 1; i<n; i++)
    for_sort:
    cmp %rcx,%r9
    je end
    
    movl (%ecx),%edx #tmp = a[i];
    movl %ecx,%esi
    sub $4,%esi #j = i - 1;

    #while loop_ints_to_string
    loop_while:
        cmp %eax,%esi
        jb end_while
        cmp %edx,(%esi)
        jng end_while

        #temp reg %edi

        movl (%esi),%edi
        movl %edi,4(%esi)

        sub $4,%esi
        call debug
        jmp loop_while
    end_while:
    call breakpoint
    add $4,%esi    #a[j+1]=tmp;
    mov %edx,(%esi)

    #for loop    
    add $4,%rcx
    jmp for_sort

    end:

    ret


#    push %rbx
#    push %rsi
#    push %rdi
#    mov %eax,%ecx
#    mov %eax,%edx
#    add %ebx,%ecx
#    #dec %ecx
#    add $4,%edx #i
##%ecx==终止地址
##%edx==当前地址
##for i in array 
#forloop:
#    cmp %ecx,%edx
#    jnb endsort
#
#    mov (%edx),%esi #%esi:temp
#    mov %edx,%edi #%edi:j
#    sub $4,%edi
#
#    #while
#    whileloop:
#        cmp %eax,%edi
#        jb endwhile
#        cmp %esi,(%edi)
#        jng endwhile
#        mov (%edi),%r8 #r8 is a temp reg
#        mov %r8,4(%edi)
#        dec %edi
#        jmp whileloop
#    endwhile:
#
#    mov %esi,4(%edi)
#
#    add $4,%edx
#    jmp forloop
#
#endsort:
#    pop %rdi
#    pop %rsi
#    pop %rbx
#    ret


ints_to_string:
    #%eax,%ebx,%ecx,%edx is used.
    mov $10,%rsi
    mov $array,%eax
    mov $string,%ecx
    mov $0,%edx

    loop_ints_to_string:
    cmp $0,%rsi
    je end_ints_to_string

    call int_to_string
    add $4,%eax
    dec %rsi

    jmp loop_ints_to_string

    end_ints_to_string:
    call add_endl
    call printints
    
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
    push %r8
    push %r9

    mov $1, %rax
    mov $1, %rdi
    mov $mbreakpoint, %rsi
    mov $11, %edx
    syscall

    pop %r9
    pop %r8
    pop %rbx
    pop %rcx
    pop %rdx
    pop %rsi
    pop %rdi
    pop %rax
    
    ret

printints:
# 参数: 将长度传入%edx中
    push %rax
    push %rdi
    push %rsi
    push %rdx
    push %rcx
    push %rbx

    mov $1, %rax
    mov $1, %rdi
    mov $string, %rsi
    #mov $11, %edx
    syscall

    pop %rbx
    pop %rcx
    pop %rdx
    pop %rsi
    pop %rdi
    pop %rax
    
    ret

int_to_string:
# 使用寄存器%edx来累计字符串长度
# 当前int地址用%eax传入
# 待转化的数放入%ebx
# 目的字符串放入%ecx

    movl (%eax),%ebx
    cmpl $0,%ebx
    jnl not_negative
    
    movb $'-',(%ecx)
    inc %ecx
    inc %edx
    mov %rbx,%rdi
    mov $0,%rbx
    sub %rdi,%rbx #取反, 变成正数

    not_negative:

    addl $48,%ebx
    movb %bl,(%ecx)
    inc %ecx
    inc %edx

    #add space
    movb $' ',(%ecx)
    inc %ecx
    inc %edx

    ret

add_endl:
# 使用寄存器%edx来累计字符串长度
# 目的字符串放入%ecx

    movb $'\n',(%ecx)
    inc %ecx
    inc %edx

    ret

debug:
    push %rax
    push %rdi
    push %rsi
    push %rdx
    push %rcx
    push %rbx
    push %r8
    push %r9

    call ints_to_string

    pop %r9
    pop %r8
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
