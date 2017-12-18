import pandas as pd
import sys

x=[]
y=[]

if(len(sys.argv)!=2):
    print("Usage example: python g:\spacetoexcel.py 2.check_roughly_by1.00nm.txt")
    exit();

#Get data
file = open(sys.argv[1])

for line in file:
    sline=line.split()
    x.append(sline[0])
    y.append(sline[1])

x=list(map(float,x))
y=list(map(float,y))

a=pd.DataFrame([x,y])

writer = pd.ExcelWriter(sys.argv[1]+".xlsx")
a.to_excel(writer,'Sheet1')
writer.save()