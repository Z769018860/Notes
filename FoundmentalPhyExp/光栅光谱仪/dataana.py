import scipy as sp
import numpy as np 
import matplotlib.pyplot as plt
import math
import sys

if(len(sys.argv)==1):
    print(r"Usage: python .\dataana.py <name_of_txt> (<range:leftbound> <range:rightbound>)")
    print(r"Usage example: python .\dataana.py .\1030.txt <500> <1000>")
    print(r"Usage example: python .\dataana.py .\1030.txt")
    exit();

x=[]
y=[]

#Get data
file = open(sys.argv[1])

for line in file:
    sline=line.split()
    x.append(sline[0])
    y.append(sline[1])

x=list(map(float,x))
y=list(map(float,y))

if(sys.argv[2] and sys.argv[3]):
    x=x[int(sys.argv[2]):int(sys.argv[3])]
    y=y[int(sys.argv[2]):int(sys.argv[3])]

#Analyze data

def max(y):
    temp=-1
    maxfind=0
    i=0
    while (i<len(y)):
        if (float(y[i])> maxfind):
            temp=i;
            maxfind=y[i]

        i=i+1
    return (temp)

maxindex=max(y)

def findhalf(y,maxindex):
    hmax=y[maxindex]/2
    result=[]
    z=list(map(lambda x:abs(x-hmax),y))
    # print(z)
    _find=1000
    get=0
    a=maxindex-1
    while(y[a]>y[maxindex]/8*3 and (a-1)>0):
        if(z[a]<_find):
            get=a
            _find=z[a]
        a=a-1
    result.append(get)
    
    get=0
    
    _find=1000
    b=maxindex+1
    while((b+1)<len(y) and y[b]>y[maxindex]/8*3 ):
        if(z[b]<_find):
            get=b
            _find=z[b]
            
        b=b+1
    result.append(get)
        

    difresult=[]
    print("Find half peak point at:",result, ",which are:")
    for i in result:
        print("    ",x[i],"nm")
    while(len(result)!=0 and len(result)%2==0):
        # print(len(result))
        difresult.append(abs(x[result.pop()]-x[result.pop()]))
    return difresult


print("wavelength (x) = ",x[maxindex])
print("energy (ymax) = ",y[maxindex])

print ("Half peak width:",round(findhalf(y,maxindex).pop(),2),"nm")
print("Scan step length:", round(x[1]-x[0],2),"nm")


#Draw curve
# namex=input("namex?")
# namey=input("namey?")
title=sys.argv[1]

#X-y curve
plt.figure(figsize=(8,4))
plt.plot(x,y,color="black",linewidth=2)
plt.xlabel("wavelength/nm")
plt.ylabel("energy")
plt.title(title)
# plt.annotate("test",xy=(0,0),xytext=(0,0))
plt.savefig(title+"_energy.png")
plt.show()


#Find alpha
d=1.5*10e-3 #m
alpha=list(map(lambda x: math.log(1/(x/100))/d,y))

plt.figure(figsize=(8,4))
plt.plot(x,alpha,color="black",linewidth=2)
plt.xlabel("wavelength/nm")
plt.ylabel("alpha/m^(-1)")
plt.title(title)
plt.savefig(title+"_alpha.png")
plt.show()