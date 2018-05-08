
/*
addu
sll,
nop
beq
move(?use or)
j
jal ???????????????????????????????
jr,
lui,
slti,
sltiu,
subu

-----------------------
共计11条指令
阶段II需要实现移位指令，因
此需修改代码，按手册定义要
求处理nop指令
III

and,
 andi,
 bgez,
  blez, //additional jmp controler
bltz,  
 jalr,  //R pc_to_reg
 lb,   //loadbyte  数据宽度控制线启用(后面复用) +扩展逻辑可控 b h
  lbu,

   lh  //loadsize-->
   , lhu,
//跳转控制器
//移位器
//扩展器
lwl,
 lwr,  //update nor fsthalf, backhalf
 slt
  movn, //move not zero: alu control to control if regwrite //add alu_reg_write_enabled in alucontrol
   movz,  //alu control to control if regwrite
nor,
 or,
  ori,(zero-extend),sl   /extend SL control to 2:0 
   sb, 数据宽度控制线启用
    sh,
sll
     sllv,
sltu,   //change alu_reg_write_enabled in alucontrol
 sra,   //全使用alu_control 控制移位器    移位器引脚: 符号 左右 启用与否 数据输入源:指令/寄存器
  srav,
   srl,
    srlv,
swl,   //控制数据宽度控制线
 swr,
///--------------------------
  xor, 
  xori
共计29条指令
表格中各阶段需完成的个别指
令助记符为“MIPS Pseudo
Instruction伪指令”，请自行
查阅其所对应的真实机器指令；
例如，请同学们比较我们提供
的测试程序中的move指令二进
制码和MIPS指令手册中or指令
定义的opcode

*/