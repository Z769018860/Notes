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

    var: .int 0x12345678
    var1: .int 0x00abcde1
    var2: .int 0xffffffff
    var3: .int 0xfffffffe
    var4: .int 0xffffffff
    outputbuff: .ascii "123456789012345678901234567890"

.section text
.globl _start

_start:
    pushl var #4
    call print_signed_32_to_hex
    mov   $1, %eax
    mov   $0, %ebx
    int   $0x80



.type print_signed_32_to_hex, @function

print_signed_32_to_hex:
    push %ebp
    mov %esp,%ebp
    sub $16,%esp


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

printhex:
#%eax:原地址
#%ecx:缓冲区地址

#%edx:长度暂存(缓冲区下标)
#%esi:元数据复制
    push %ebx
    push %esi
    push %edi
    mov 3,%edx
    movb $'0',1(%ecx)
    movb $'x',2(%ecx)
    movl (%eax),%esi

    cmpl $0,%esi
    jng negative
    
    positive:
        movb $'+',(%ecx)
        jmp endif
    negative:
        movb $'-',(%ecx)
        jmp endif
        movl $0,%ebx
        subl %esi,%ebx
        movl %ebx,%esi

    endif:
        
    

    andl $15,%esi

    pop %edi
    pop %esi
    pop %ebx
    ret

