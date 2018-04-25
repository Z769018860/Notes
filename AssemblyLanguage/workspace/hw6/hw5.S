#编写一个符合x86-linux-32 ABI的子过程
#输入参数： 32位有符号整数
#返回值：无
#功能：将输入的32位有符号整数以16进制字符串形式在终端输出，输出格式为：
#[-]0xhhhhhhhh
#其中，hhhhhhhh是16进制的绝对值，并消除前导0
#如，
#输入：0x0812abcd， 输出：0x812abcd
#输入：0x80001234， 输出：-0x7fffedcc

### X86-Linux-32 abi

#参数与返回值约定:
#* 参数通过栈传递
#* 参数的传递顺序是从右向左
#* 参数由调用者维护，属于调用者栈帧
#* 返回值存放在的eax寄存器
#* 返回地址存放调用者的栈桢顶部
#
#寄存器使用约定
#* eax保存返回值
#* 调用者保存eax、edx、ecx寄存器
#* 被调用者自由使用
#* 被调用者保存ebx、esi、edi寄存器
#* 调用者自由使用
#* ebp和esp是栈桢指针和栈顶指针
#
#栈桢的约定:
#
#栈桢的布局
#1. ebp旧值寄存器
#1. 其他要保存的寄存器、局部变量
#1. 形参
#1. 返回地址
#
#栈帧主体部分以16字节为单位分配
#
#栈单元大小是32位
#
#"被调用者保存, 调用者自由使用"表示: 调用之后不改变这些寄存器的值.

#hw5.S

.section .data

    var: .int 0x80001234
    var1: .int 0x00abcde1
    var2: .int 0xffffffff
    var3: .int 0xfffffffe
    var4: .int 0xffffffff
    outputbuff: .ascii "000000000000012345678901234567890"
    mbreakpoint: .ascii "breakpoint\n"

.section .text
.globl _start

_start:

    pushl $outputbuff
    pushl $var
    
    call printhex
    mov $outputbuff,%ecx
    #mov $10,%edx
    call printf
    #call printbuff
    mov   $1, %eax
    mov   $0, %ebx
    int   $0x80





.type printf, @function
printf:
    push %ebp
    push %esi
    push %edi
    movl $4, %eax
    movl $1, %ebx
    #movl	$outputbuff, %ecx
    #movl	$16, %edx
    int	$0x80
    pop %edi
    pop %esi
    pop %ebp
    ret

.type printhex, @function
printhex:
#参数: push(缓冲区地址)
#参数: push(原数组地址)

#4(%ebp):原地址
#8(%esp):缓冲区地址

#%eax:元数据复制,除法用
#%ebx:当前写入地址计数
#%ecx:循环计数器
#%edx:商
#%esi:缓冲区起始地址
#%edi:临时变量

    push %ebp
    mov %esp,%ebp
    sub $16,%esp
    push %ebx

    mov 12(%ebp),%esi
    mov 8(%ebp),%edi
    mov (%edi),%eax

    movb $'0',1(%esi)
    movb $'x',2(%esi)
    
    #mov $0,%ebx
    cmpl $0,%eax
    jng negative
    
    positive:
        movb $'+',(%esi)
        jmp endif
    negative:
        movb $'-',(%esi)
        movl $0,%ebx
        subl %eax,%ebx
        movl %ebx,%eax
	jmp endif

    endif:
        mov $0,%ecx
        mov %eax,%edi
        
	

    loop1:

        cmp $9,%cl
        je endloop1

	movb %al,%bl
        andb $15,%bl

        inc %cl #ch:counter
        shrl $4,%eax
        test %bl,%bl
        jz loop1
        
        mov %cl,%ch #ch:last counter have non 0 byte
        jmp loop1
        
    endloop1:

        mov %ch,%cl
        mov $0,%ch
        mov %edi,%eax #recover %eax
        movb $0,3(%esi,%ecx) # write'\0'
        mov %ecx,%edx

    loop2:

    if1:
	mov $15,%ebx
	andb %al,%bl
	shrl $4,%eax
        cmpb $10,%bl
        jnb alpha

        number:
        addb $48,%bl
        jmp endif1

        alpha:
        addb $55,%bl

        endif1:

        movb %bl,2(%esi,%ecx)
        #call printbuff
        loop loop2

    addl $4,%edx
    pop %ebx
    leave
    ret

breakpoint:

    push %eax
    push %ebx
    push %ecx
    push %edx
    push %esi
    push %edi
	
    movl $4, %eax
    movl $1, %ebx
    movl $mbreakpoint, %ecx
    movl $12, %edx
    int	$0x80
	
    pop %edi
    pop %esi
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    
    ret

printbuff:

    push %eax
    push %ebx
    push %ecx
    push %edx
    push %esi
    push %edi
	
    movl $4, %eax
    movl $1, %ebx
    movl $outputbuff, %ecx
    movl $12, %edx
    int	$0x80
	
    pop %edi
    pop %esi
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    
    ret
