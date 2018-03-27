# 汇编语言笔记

***

## Example: 汇编程序示例

```attasm
#hello.S
.section .data
	output:	.ascii  "Hello World\n“
.section .text
.globl _start
_start:
/* output  like printf */
	movl	$4, %eax
	movl	$1, %ebx
	movl	$output, %ecx
	movl	$12, %edx
	int	$0x80
/* exit */
	movl	$1, %eax
	movl	$0, %ebx
	int	$0x80
```

## 注释

1. “#”开头的一行
2. “/*”和 “*/”包围的一段内容

注意：“;”不是注释标志

## 节

以字符“.”开头的符号名称

    .section
    .data

节-针对未链接的单个文件

    .section

常见的节

    .text  -- 代码
    .data  -- 数据
    .bss  -- 未初始化数据

## 数据定义

1. 数据定义在数据区，即节 .data
2. 数据定义需要指定数据类型和值
   “.ascii” 定义ASCII字符串类型
   “Hello world\n”是字符串的值
3. 数据定义通常需要一个符号名作为标号以方便引用
    output
即为一个标号

## 符号（symbol）
* 由字母（大小写）、数字和’_.$’组成
* 以字母或’._’开头
* 作为标号（label）时后面紧跟’:’
* 符号区分大小写

    output :	.ascii	“Hello World\n”
* 定义了一个字符串”Hello World\n”
* 定义了一个标号 output，与该字符串的地址关联
* 该字符串可通过标号output进行访问  

## 程序入口地址

Ld默认的入口地址：_start
     _start必须是第一条指令的标号
2. Ld -e entry可改变入口地址
3. 入口地址必须定义为全局符号
    .globl 或者 .global 定义全局符号
    .globl _start

## 指令格式
（以mov指令为例）

指令后缀表示数据类型
* ’l’：表示32位数据
* ’w’：表示16位数据
* ‘b’：表示8位数据

说明：
    mov指令涉及不同数据类型，需要后缀区分
    int指令没有不同数据类型

数据类型
    .byte, .word, .int, .long, .quad, .octa
    .ascii, .asciz


立即数操作数

   ‘$number’：表示立即数number
    ‘$symbol’：表示标号地址

寄存器

    寄存器名加前缀%

源操作数与目标操作数

    左边是源操作数
    最右边是目的操作数

## int 0x80（Linux32系统调用）

> 系统调用即调用操作系统提供的功能，需要在核心态运行
> 中断引发特权态改变，从用户态进入核心态
> Linux约定0x80（128）号软中断为系统调用
> Linux系统调用的寄存器约定
> EAX：系统调用号，4号是写文件，1号是程序退出
> EBX、ECX、EDX、…：传递参数

4号调用：写文件

    EBX：文件描述符，1表示终端
    ECX：输出缓冲区（Buffer）的地址
    EDX：输出的字节数

1号调用：程序退出

    EBX：返回值

> 64bit下系统中断定义发生变化

## 汇编程序的基本形式

```x86asm
.section .data
    <initialized data>
.section .bss
    <uninitialized data>
.section .text
.globl _start
_start:
    <instruction code>
```

注意: .text、.data、.bss等基本节的名字用小写, 其他的汇编指导大小写混合不影响


## Intel语法

指令不需要后缀，汇编器根据使用的寄存器和数据类型来区别

立即数不加$

内存操作数需要显示的类型操作

    byte ptr,  word ptr,  dword ptr

标号地址需要使用offset操作

    offset output

目的寄存器在最左边

1. .intel_syntax表示采用Intel语法
2. noprefix表示寄存器名前不加%
3. offset label：引用标号地址
4. 目的寄存器在最左边
5. 立即数不加$

```x86asm
#hello.S
        .intel_syntax noprefix
```

## 汇编、链接、执行
$ as -o hello.o hello.S
$ ld -o hello hello.o

```shell
# $vi asm_sh
as -o $1.o $1.S
ld -o $1 $1.o
# $chmod +x asm_sh
# $./asm_sh hello
# $./hello
# Hello World
# $
```

```shell
echo as -o $1.o $1.S
as -o $1.o $1.S
echo ld -o $1 $1.o
ld -o $1 $1.o
echo running $1
./$1
```

## objdump

    $objdump <options> <file> 

options:

```
   -x       Display the contents of all headers, 显示所有文件头
   -d      Display assembler contents of executable sections, 反汇编代码
   -s      Display the full contents of all sections requested, 显示所有内容
   -D       反汇编所有内容
```

    File off //文件偏移      
    Algn     //对齐

symbol table 格式:

value flag_bits section alignment name

其中对于flag_bits: l: local, d: debug, g: global

## GDB

* Break
* Run
* Continue 
* Info //info registers 
* Nexti
* Stepi
* Display /c //在每个断点显示表达式的值
* print /c  
* X //地址
* Disassemble
* quit

```
info registers 
```

## 汇编Debug信息的程序

```sh
as --gstabs -o hello.o hello.S
ld -o hello hello.o
```

## 汇编32bit的程序

```sh
as --32 --gstabs -o hello.o hello.S
ld -m elf_i386 -o hello hello.o
```

```sh
echo as --32 --gstabs -o $1.o $1.S
as --32 --gstabs -o $1.o $1.S
echo ld -m elf_i386 -o $1 $1.o
ld -m elf_i386 -o $1 $1.o
echo running $1
./$1
```


## HW1

32位版本

```x86asm
#ucas.S
    .intel_syntax noprefix
.section .data
    output: .ascii "University of CAS\n"
.section .bss
.section .text
.globl _start

_start:fi
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
    mov edx, 18
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80

```

64位版本

```x86asm
#ucas.S
    .intel_syntax noprefix
.section .data
    output: .ascii "University of CAS\n"
.section .bss
.section .text
.globl _start

_start:
/*
    64位系统
    1号调用：写文件

    RDI：文件描述符，1表示终端
    RSI：输出缓冲区（Buffer）的地址
    EDX：输出的字节数

    60号调用：程序退出

    RDI：返回值

    系统中断使用 syscall 语句
*/
    mov rax, 1
    mov rdi, 1
    mov rsi, offset output
    mov edx, 18
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

```

***

## MOV指令

### Intel Syntax

指令格式：

    MOV  destination, source    

语义：destination = source
适用范围: 寄存器之间, 内存<->寄存器

### AT&T Syntax

指令格式：

    MOVx  source, destination   

其中，x  = b, w, l，用于指定内存操作数的大小
## 内存操作数指令示例（AT&T）
```x86asm
movb   var, %al				disp
movw  (%ebx), ax			base
movl  $4, 4(%ebx)			base+disp
movl  (%ebx, %esi),%eax		base+index
movl  4(%ebx, %esi),%eax		base+index+disp
movl  %eax, (%ebx, %esi, 2) 	base+index*scale
movl  4(%ebx, %esi, 2), %eax	base+index*scale+disp
movl  4(,%esi,2), %eax		index*scale+disp
```

```x86asm
disp(基地址,index,scale)
```
## XCHG指令

Intel syntax

指令格式：

    XCHG  destination, source

语义：destination与source交换, i.e. 源操作数与目的操作数交换数据

适用范围: 寄存器之间, 内存<->寄存器

## MOVZX和MOVSX指令

Intel syntax

指令格式：

    MOVZ  destination, source

语义：移动的同时扩展数据宽度. MOVZX描述用0来进行扩展, MOVS使用符号位来进行扩展

适用范围: 寄存器之间, 内存<->寄存器

## MOVZX/MOVSX指令示例（AT&T）

```x86asm
movzbw		bytevar, %ax
movsbw		bytevar+4, %cx
movzwl		%cx, %ebx
movswl		wordvar+2, %edx
movzbl		bytevar+2, %esi
movsbl		%al, %edi
```

## 二进制算术指令

INC, DEC, ADD, SUB, NEG

算术指令在CPU内部计算时不区分有符号数和无符号数, 都按照无符号数计算, 根据指令和计算结果设置相应的标志位，供程序使用

注: 可以使用8位的立即数, 会自动扩展为对应的宽度

### EFLAGS的状态标志位

* CF - Carry
* 无符号数运算溢出（最高位发生进位或借位）
* OF - Overflow
* 有符号数运算溢出（正+正=负, 负+负=正, 正-负=负, 负-正=正）
* SF - Sign
* 结果为负数
* ZF - Zero
* 结果为0
* AF - Auxiliary Carry
* Bit 3 到 Bit 4的进位
* PF - Parity
* 奇偶标志，最低字节”1”的个数为偶数

## INC, DEC

INC：加1

指令格式：

    INC destination

语义：destination <- destination + 1

CF标志位不变，其他标志位根据计算结果改变

DEC：减1

指令格式：
    
    DEC destination

语义：destination <- destination – 1

CF标志位不变，其他标志位根据计算结果改变

## ATT语法宽度的自动识别

如果操作数大小可以通过寄存器区分，则指令后缀可省略，汇编器自动识别

如：

```x86asm
inc	%al		等价于	incb	%al
dec	%ax		等价于	decw	%ax
inc	%ecx		等价于	incl	%ecx
decb	bytevar
incw	(%ebx, %esi, 2)
decl	4(%eax)
```

## ADD, SUB

ADD：加

指令格式：

    ADD destination, source

语义：destination = destination + source

根据计算结果改变标志位CF、OF、SF、ZF、AF、PF

SUB：减

指令格式：
    
    SUB destination, source

语义：destination = destination – source

根据计算结果改变标志位CF、OF、SF、ZF、AF、PF

remark: 

* 源与目的操作数大小一致，即都是8位、16位或32位
* 内存操作数最多只有一个
* 立即数只能作为源操作数

## NEG

NEG：求相反数（补码）

指令格式：

    NEG destination

语义：destination = 0 - destination

标志位: 如果destination =0，CF=0，否则CF=1, 其他标志位根据结果设置

## LOOP

LOOP：循环（Loop with ECX counter)

指令格式：

    LOOP  destination

语义：counter = counter - 1, 如果 counter ≠ 0，跳转到标号destination处（循环入口）执行，否则

结束LOOP指令，执行LOOP之后第一条指令

16位地址counter是CX寄存器

```x86asm
  mov 	$10, %ecx
  mov 	$0, %al
  mov 	$bytevar, %ebx
l1:
  movb 	%al, (%ebx)
  inc  	%ebx
  inc  	%al
  loop 	l1
```
## C语言对应的汇编

使用

    gcc -S xxxx.c
    gcc -S -masm=intel xxxx.c

来生成汇编代码.

## HW2

```x86asm
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

```
