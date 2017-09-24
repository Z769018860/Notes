#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import sys

#read file in line
#建立全局变量
paper=""
insection=[0]
file_to_open="note.md"
_encoding="utf-8"
outputfilename="filename"
outputencoding="utf-8"

#简单文件头/尾
FILFHEAD=''
FILEEND=''

#在输出缓冲区paper中加入新内容
def add(addon):
    global paper
    paper=paper+addon

#正文逐行处理函数
def convertline(line):
    global paper
    global insection

    #在此处添加针对语法的特殊处理
    #对于单行语法    
    if "#" in line:
        return 0

    #对于块语法
        if "@" in line:

        #定义
            if "定义" in line:
                insection.append("定义")
                name=line[4:]
                add(r'''2333''')
                return 0

            if insection[-1]=="定义":
                add(r'''2333''')
                insection.pop()
                return 0


    #若不属于任何特殊情况(没有@)
    add(line)
            
            


#读取文件
if(len(sys.argv)>1):
    file_to_open=sys.argv[1]
else:
    pass
    # file_to_open="note.md"

if(len(sys.argv)>2):
    _encoding=sys.argv[2]
else:
    pass
    # _encoding="utf-8"
    

file=open(file_to_open,encoding=_encoding)

#获取附加参数
name=input("name:")

#设置默认参数
if(name==""):
    name="Augustus Wang"

# head=open('filehead.dat','r',encoding='utf-8').read()
# paper=paper+head

#写文件头
add(FILEHEAD)

#逐行处理
while True:
    line =file.readline()
    if not line:
        break
    convertline(line)

#写文件尾
add(FILEEND)


output=open(outputfilename,'w',encoding=outputencoding)
output.write(paper)

output.close()
file.close()

#结束后调用命令行命令
# os.system('pdflatex output.tex %DOC%')

# log=subprocess.call(r"pdflatex output.tex %DOC%",shell=True)
# print(log)
subprocess.call("pause")
input()

